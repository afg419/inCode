---
title: "Dependent Types in Haskell: Introduction to Singletons (Part 1)"
categories: Haskell
series: Practical Dependent Types in Haskell
tags: functional programming, dependent types, haskell, singletons, types
create-time: 2017/08/06 21:07:12
date: never
identifier: singletons-1
slug: introduction-to-singletons-1
---

Real dependent types are coming to Haskell soon!  Until then, we have the
great *[singletons][]* library :)

[singletons]: http://hackage.haskell.org/package/singletons

If you've ever run into dependently typed programming in Haskell, you've
probably encountered mentions of singletons (and the *singletons* library).
This series of articles will be my attempt at giving you the story of the
library, the problems it solves, the power that it gives to you, and how you
can integrate it into your code today![^origin]  (Also, after [my previous
April Fools post][april], people have been asking me for an actual non-joke
singletons post.)

[april]: https://blog.jle.im/entry/verified-instances-in-haskell.html

[^origin]: This series will be based on [a talk][lc] I gave over the summer, and will
expand on it eventually.

[lc]: http://talks.jle.im/lambdaconf-2017/singletons/

### Prerequisites

These posts will assume no knowledge of dependent types, and, for now, only
basic to intermediate Haskell knowledge. (Types, kinds, typeclasses, data
types, functions)  The material in this post greatly *overlaps* with my
[dependently typed neural networks][ann] series, but some of the concepts are
introduced in different contexts.

[ann]: https://blog.jle.im/entry/practical-dependent-types-in-haskell-1.html

All code is built on *GHC 8.2.1* and with the *[nightly-2017-11-27][snapshot]*
snapshot (so, singletons-2.3.1).  However, there are negligible changes in the
GHC type system between GHC 8.0 and 8.2 (the only difference is in the
libraries, more or less), so everything should work on GHC 8.0 as well!

[snapshot]: https://www.stackage.org/nightly-2017-11-27

The content in the first section of this post, describing the singleton design
pattern, uses the following extensions:

*   DataKinds
*   GADTs
*   KindSignatures
*   RankNTypes
*   TypeApplications
*   TypeInType

And the second section, introducing the library itself, uses, on top of these:

*   TypeFamilies
*   TemplateHaskell

These extension will be explained when they are used or become relevant.

The Phantom of the Types
------------------------

Let's start with a very common Haskell trick that most learn early in
their Haskelling journey: the [phantom type][].

[phantom type]: https://wiki.haskell.org/Phantom_type

Phantom types in Haskell are a very easy way to add a layer of "type safety"
for your types and DSL's.  It helps you restrict what values functions can take
and encode pre- and post-conditions directly into your types.

For example, in

```haskell
data Foo a = MkFoo
```

The `a` parameter is phantom, because nothing of type `a` in the data type...it
just exists as a dummy parameter for the `Foo` type.  We can use `MkFoo`
without ever requiring something of type `a`:

```haskell
ghci> :t MkFoo :: Foo Int
Foo Int
ghci> :t MkFoo :: Foo Bool
Foo Bool
```

A common use case of phantom type parameters is to tag data as "sanitized" or
"unsanitized", for instance.  For a simple example, let's check out a simple
DSL for a type-safe door:

```haskell
!!!singletons/Door.hs "data DoorState " "data Door "
```

A couple things going on here:

1.  Our type we are going to be playing with is a `Door`, which contains a
    single field describing, say, the material that the door is made out of.
    (`UnsafeMkDoor "Oak"` would be an oak door)

2.  We're using the `DataKinds` extension to create both the *type* `DoorState`
    as well as the *kind* `DoorState`.

    Normally, `data DoorState = Opened | Closed | Locked` in Haskell defines
    the type `DoorState` and the value constructors `Opened`, `Closed`, and
    `Locked`.

    However, with `DataKinds`, that statement also defines a new *kind*
    `DoorState`, with *type* constructors `'Opened`, `'Closed`, and `'Locked`.
    (note the `'` ticks!)[^ticks]

    ```haskell
    ghci> :k 'Opened
    DoorState
    ghci> :k 'Locked
    DoorState
    ```

[^ticks]: The `'` ticks are technically optional, but I find that it's good
style, at this point in Haskell, to use them whenever you can.  It'll prevent a
lot of confusion, trust me!

3.  We're defining the `Door` type with a *phantom parameter* `s`.  It's a
    phantom type because we don't actually have any *values* of type `s` in our
    data type...the `s` is only just there as a dummy parameter for the type.

    We can use `UnsafeMkDoor` without ever using anything of type `s`.  In
    reality, a real `Door` type would be a bit more complicated (and the direct
    `UnsafeMkDoor` constructor would be hidden).

    ```haskell
    ghci> :t UnsafeMkDoor "Birch" :: Door 'Opened
    Door 'Opened
    ghci> :t UnsafeMkDoor "Iron" :: Door 'Locked
    Door 'Locked
    ```

    We can also use the *TypeApplications* extension to write this in a bit
    more convenient way --

    ```haskell
    ghci> :t UnsafeMkDoor @'Opened "Birch"
    Door 'Opened
    ghci> :t UnsafeMkDoor @'Locked "Iron"
    Door 'Locked
    ```

We'll take a `Door s` to mean the type of a door with that current status.  So
a `Door 'Opened` is the type of an opened door, a `Door 'Closed` is the type of
a closed (and unlocked) door, etc.  The `String` that the `Door` contains
represents its material (oak, birch, spruce, etc.).

Alternatively, we can define `Door` using [*GADT* syntax][gadt] (which requires
the `GADTs` extension).

[gadt]: https://en.wikibooks.org/wiki/Haskell/GADT#Syntax

```haskell
data Door :: DoorState -> Type where
    UnsafeMkDoor :: String -> Door s
```

This is defining the exact same type in the alternate "GADT syntax" style of
data type declaration -- here, we define types by giving the type of its
constructors.

### Phantoms in Action

At first, this seems a bit silly.  Why even have the extra type parameter if
you don't ever use it?

Well, right off the bat, we can write functions that expect only a certain type
of `Door`, and return a specific type of `Door`:

```haskell
!!!singletons/Door.hs "closeDoor ::"
```

So, the `closeDoor` function will *only* take a `Door 'Opened` (an opened
door).  And it will return a `Door 'Closed` (a closed door).

```haskell
ghci> let myDoor = UnsafeMkDoor "Spruce" :: Door 'Opened
ghci> :t closeDoor myDoor
Door 'Closed
ghci> let yourDoor = UnsafeMkDoor "Acacia" :: Door 'Closed
ghci> :t closeDoor yourDoor
TYPE ERROR!  TYPE ERROR!
```

You can think of this as a nice way of catching *logic errors* at compile-time.
If your door type did not have its status in the type, the `closeDoor` could
have been given a closed or locked door, and you'd have to reject it at
runtime!

By adding the state of the door into its type, we can encode our pre-conditions
and post-conditions directly into the type.  And any opportunity to move
runtime errors to compile-time errors should be celebrated with a little party!

This would also stop you from doing silly things like closing a door twice in a
row:

```haskell
ghci> :t closeDoor . closeDoor
TYPE ERROR!  TYPE ERROR!
```

Do you see why?

With a couple of state transitions, we can write compositions that are
typechecked to all be legal:

```haskell
!!!singletons/Door.hs "lockDoor ::" "openDoor ::"
```

```haskell
ghci> :t closeDoor . openDoor
Door 'Closed -> Door 'Closed
ghci> :t lockDoor . closeDoor . openDoor
Door 'Closed -> Door 'Locked
```

### The Phantom Menace

However, in standard Haskell, we quickly run into some practical problems if we
program with phantom types this way.

For example, how could we write a function to get the state of a door?

```haskell
doorStatus :: Door s -> DoorState
doorStatos _ = -- ?
```

(It can be done with an ad-hoc typeclass, but it's not simple, and it's prone
to implementation bugs)

And, perhaps even more important, how can you create a `Door` with a given
state that isn't known until runtime?  If we know the type of our doors at
compile-time, we can just explicitly write `UnsafeMkDoor "Iron" :: Door
'Opened` or `UnsafeMkDoor @'Opened "Iron"`.  But what if we wanted to make a
door based on a `DoorState` input?


```haskell
mkDoor :: DoorState -> String -> Door s
mkDoor Opened = -- ?
mkDoor Closed = -- ?
mkDoor Locked = -- ?
```

Ah hah, you say.  That's easy!

```haskell
mkDoor :: DoorState -> String -> Door s
mkDoor Opened = UnsafeMkDoor
mkDoor Closed = UnsafeMkDoor
mkDoor Locked = UnsafeMkDoor
```

Unfortunately, that's not how types work in Haskell.  Remember that for a
polymorphic type `forall s. DoorState -> String -> Door s`, the *caller* picks
the type variable.

```haskell
ghci> :t mkDoor Opened "Acacia" :: Door 'Closed
Door 'Closed
```

Oops!

### The Fundamental Issue in Haskell

We've hit upon a fundamental issue in Haskell's type system: **type erasure**.
In Haskell, types only exist *at compiletime*, for help with typechecking.
They are completely erased at runtime.

This is usually what we want.  It's great for performance, and you can bypass
things like the ad-hoc runtime type checking that you have to deal with in
dynamic languages like python.

But in our case, it makes functions like `doorState` fundamentally impossible.
Or, does it?

The Singleton Pattern
---------------------

A singleton in Haskell is a type that, for each instantiation its type
variables, has exactly one inhabitant, and whose constructor (when pattern
matched on) reveals its type.

```haskell
!!!singletons/Door.hs "data SingDS ::"
```

Here we're using *GADT syntax* again.  (Also note that `Type` a synonym for the
`*` kind, exported from the *Data.Kind* module)   Notice that, if we use
`SOpened`, we will get a `SingDS 'Opened`.  And if we have a `SingDS 'Opened`,
we know that it was constructed using `SOpened`.  Essentially, this gives us
three values:

```haskell
SOpened :: SingDS 'Opened
SClosed :: SingDS 'Closed
SLocked :: SingDS 'Locked
```

### The Power of the Pattern Match

The power of singletons is that we can now *pattern match* on types,
essentially.

```haskell
!!!singletons/Door.hs "doorStatus ::"
```

(using *LambdaCase* syntax)

We can rewrite `doorStats` to take an additional `SingDS`, which we can use to
figure out what `s` is.  When we pattern match on it, we reveal what `s` is.
Essentially, the gain the ability to "pattern match" on the `s` type variable.

The singleton property of `SingDS` ensures us that whatever `s` the `SingDS`
has is the *same* `s` that the `Door` has.

Not only do *we* know what `s` is, but GHC can also take advantage of it.  In
the scope of the case statement branch, GHC *knows* what `s` must be:

```haskell
!!!singletons/Door.hs "closeDoor ::"1 "lockDoor ::"1 "lockAnyDoor ::"
```

Note that `lockDoor . closeDoor :: Door 'Opened -> Door 'Locked`.  GHC will
only allow you to compile that if it *knew* that the input is `Door
'Opened`...and, because of the GADT pattern match, it does!

Similar for the `SLocked -> id` branch --- `id` is only a valid response if `s`
is `'Locked` (and so `id :: Door 'Locked -> Door 'Locked`).  But, because we
pattern matched on `SLocked`, GHC knows that this is legal!

We say that `SOpened` is a "runtime witness" to `s` being `'Opened`.

### Recovering Implicit Passing

One downside is that we are required to manually pass in our witness.  Wouldn't
it be nice if we could have it be passed implicitly?  We can do something with
typeclasses:

```haskell
!!!singletons/Door.hs "class SingDSI" "instance SingDSI"
```

And so now we can do:

```haskell
!!!singletons/Door.hs "doorStatus_ ::" "lockAnyDoor_ ::"
```

Here, type inference will tell GHC that you want `singDS :: SingDS s`, and it
will pull out the proper singleton for the door you want to check!

(By the way, If you program Haskell regularly, it should slightly bug you that
it's super easy to write a bad instance of `SingDSI`.  More about this later.)

#### The Same Power

In Haskell, a constraint `SingDSI s =>` is essentially the same as passing in
`SingDS s` explicitly.  Either way, you are passing in a runtime witness that
your function can use.  You can think of `SingDSI s =>` as passing it in
*implicitly*, and `SingDS s ->` as passing it in *explicitly*.

Earlier, I disparaged the "ad-hoc typeclass" approach.  But, here, the
typeclass isn't quite ad-hoc; it's basically exactly carrying around an
implicit witness of `s` that we can grab at any time.

So, it's important to remember that `doorStatus` and `doorStatus_` are the
"same function", with the same power.  They are just written in different
styles -- `doorStatus` is written in explicit style, and `doorStatus_` is
written in implicit style.

#### Going backwards

Going from `SingDSI s =>` to `SingDS s ->` (implicit to explicit) is very easy
-- just use `singDS` to get a `SingDS s` if you have a `SingDSI s` constraint
available.

Going from `SingDS s ->` to `SingDSI s =>` (explicit to implicit) in Haskell is
actually a little trickier.  The typical way to do this is with a CPS-like
utility function:

```haskell
!!!singletons/Door.hs "withSingDSI ::"
```

`withSingDSI` takes a `SingDS s`, and a value (of type `r`) that requires a
`SingDSI s` instance to be created.  And it creates that value for you!

It works because in each branch, `s` is now a *specific*, monomorphic,
"concrete" `s`, and GHC knows that such an instance exists for every branch.
In the `SOpened` branch, `s ~ 'Opened`,[^eq] so GHC knows that there is a
`SingDSI 'Opened` instance, and gives it to you.  In the `SCloed` branch, `s ~
'Closed`, so GHC knows that there is a `SingDSI 'Closed` instance, and gives
*that* to you, etc.

[^eq]: `~` here refers to "type equality", or the constraint that the types on
both sides are equal.  `s ~ 'Opened` can be read as "`s` is `'Opened`".

So now, we can run our implicit functions (like `lockAnyDoor_`) by giving them
explicit inputs:

```haskell
!!!singletons/Door.hs "lockAnyDoor__ ::"
```

### Fun with Witnesses

We can write a nice version of `mkDoor` using singletons:

```haskell
!!!singletons/Door.hs "mkDoor ::"
```

So we can call it values of `SingDS`:

```haskell
ghci> :t mkDoor SOpened "Oak"
Door 'Opened
ghci> :t mkDoor SLocked "Spruce"
Door 'Locked
```

And now we can't do something silly like pass in `SLocked` to get a `Door
'Opened`!

However, this is still a step away from a `Door` whose status can vary at
runtime.

Ditching the Phantom
--------------------

Now, sometimes we don't actually care about the state of the door, and we don't
*want* the state of the door in its type.  Our `closeAnyDoor` function earlier
was an example.

We have a couple of options here --- we can create a new type `SomeDoor`, that
doesn't have the opened/closed status in its type, but rather as a runtime
value:

```haskell
data SomeDoor = UnsafeMkSomeDoor DoorState String
```

Now, we could have actually been using this type the entire time, if we didn't
care about type safety.  In the real world and in real applications, we might
have actually written `SomeDoor` before we ever thought about `Door` with a
phantom type.  It's definitely the more typical Haskell thing.

We can "construct" this from a normal `Door`, using the smart constructor:

```haskell
fromDoor :: SingDS s -> Door s -> SomeDoor
fromDoor SOpened (UnsafeMkDoor m) = UnsafeMkSomeDoor Opened m
formDoor SClosed (UnsafeMkDoor m) = UnsafeMkSomeDoor Closed m
formDoor SLocked (UnsafeMkDoor m) = UnsafeMkSomeDoor Locked m
```

### SomeDoor to Door

Now, `SomeDoor` is great.  But isn't it annoying that we might potentially have
to write the same function for both `Door` and `SomeDoor`, because they have
different implementations.  For example:

```haskell
closeSomeDoor :: SomeDoor -> Maybe SomeDoor
closeSomeDoor (UnsafeMkSomeDoor Opened m) = Just (UnsafeMkSomeDoor Closed m)
closeSomeDoor (UnsafeMkSomeDoor Closed m) = Nothing
closeSomeDoor (UnsafeMkSomeDoor Locked m) = Nothing
```

Wouldn't it be nice if we can re-use our original `closeDoor`?  This is a toy
example, and in real life, closing a door might have some complicated runtime
logic, and it'd be annoying to re-implement it for both `SomeDoor` and `Door`.

One thing we can do is write a function to convert a `SomeDoor` into a `Door`,
so we can re-use our original `closeDoor`.

#### Converting into an existential

Going from `SomeDoor` to `Door s` is slightly trickier in Haskell than going
the other way around.  One trick we often use is a CPS-style existential type.

The essential concept is that normal Haskell type variables are universally
qualified, meaning that the *caller* can pick how to instantiate `s`.  However,
we want a function where the *function* can pick the `s`, and the caller must
handle whatever `s` is given by the function:

```haskell
withSomeDoor :: SomeDoor -> (forall s. SingDS s -> Door s -> r) -> r
withSomeDoor (UnsafeMkSomeDoor Opened m) f = f SOpened (UnsafeMkDoor m)
withSomeDoor (UnsafeMkSomeDoor Closed m) f = f SClosed (UnsafeMkDoor m)
withSomeDoor (UnsafeMkSomeDoor Locked m) f = f SLocked (UnsafeMkDoor m)
```

Notice the funky CPS-like type signature of `withSomeDoor`.  To use
`withSomeDoor` and access the `Door`, you have to pass in a function to handle
*any possible `s`*.  And, as you can see, the function passed in might be given
an `SOpened`, an `SClosed`, or an `SLocked`.  It has to be able to handle all
three!

Here, we call `s` *existentially quantified*.  The `withSomeDoor` function gets
to pick which `s` to give `f`.  So, the `s` type variable is chosen by the
*function*, and not by the caller.

So we can implement `closeSomeDoor` (and even a `lockAnySomeDoor`) using this
conversion function:

```haskell
closeSomeDoor :: SomeDoor -> Maybe (Door 'Closed)
closeSomeDoor sd = withSomeDoor sd $ \case
    SOpened -> \d -> Just $ closeDoor d
    SClosed -> \_ -> Nothing
    SLocked -> \_ -> Nothing

lockAnySomeDoor :: SomeDoor -> Door 'Locked
lockAnySomeDoor sd = withSomeDoor sd $ \s d ->
    lockAnyDoor s d
```

#### The Existential Datatype

However, there's another path we can take.  With the power of singletons, we
can actually implement `SomeDoor` *in terms of* `Door`, using an existential
data type!

```haskell
-- using existential constructor syntax
data SomeDoor = forall s. MkSomeDoor (SingDS s) (Door s)

-- or, using GADT syntax
!!!singletons/Door.hs "data SomeDoor ::"
```

`MkSomeDoor` is a constructor for an existential data type, meaning that the
data type "hides" a type variable `s`.

Hopefully you can see the similarities between our original `SomeDoor` and this
one.  The key difference is that original `SomeDoor` contains a `DoorState`,
and this new `SomeDoor` contains a `SingDS` (a *singleton* for the
`DoorState`).

In Haskell, existential data types are pretty nice, syntactically, to work
with.  For a comparison, let's re-implement our previous functions with our new
data type:

```haskell
!!!singletons/Door.hs "closeSomeDoor ::" "lockAnySomeDoor ::"
```

It's important to remember that our original separate-implementation `SomeDoor`
is, functionally, identical to the new code-reusing `SomeDoor`.  The reason why
they are the same is that *having an existentially quantified singleton is the
same as having a value of the corresponding type.*  Having an existentially
quantified `SingDS s` is *the same as* having a value of type `DoorState`.

If they're identical, why use a `SingDS` or the new `SomeDoor` at all?  One
main reason (besides allowing code-reuse) is that *using the singleton lets us
recover the type*. Essentially, a `SingDS s` not only contains whether it is
Opened/Closed/Locked...it contains it in a way that GHC can use to bring it all
back to the type level.

Basically, `SingDS` allows us to re-use our original `Door s` implementation,
because we store both the `Door`...*and* the `s` at the type level.  It also
lets GHC *check* our implementations, to help ensure that they are correct,
because you maintain the `s` at the type level.

#### Some Lingo

In the language of dependently typed programming, we call `SomeDoor` a
**dependent sum**, because you can imagine it basically as:

```haskell
data SomeDoor = SDOpened (SingDS 'Opened) (Door 'Opened)
              | SDClosed (SingDS 'Closed) (Door 'Closed)
              | SDLocked (SingDS 'Locked) (Door 'Locked)
```

A three-way sum between a `Door 'Opened`, a `Door 'Closed`, and a `Door
'Locked`, essentially.  If you have a `SomeDoor`, it's *either* an opened door,
a closed door, or a locked door.  Try looking at this new `SomeDoor` until you
realize that this type is the same type as the previous `SomeDoor`!

You might also see `SomeDoor` called a **dependent pair**, because it's
basically an existentially quantified tuple of the type (the `s`, witnessed by
the `SingDS s`) with a value (the `Door s`).

### Types at Runtime

With this last tool, we finally have enough to build a function to "make" a
door with the status unknown until runtime:

```haskell
!!!singletons/Door.hs "mkSomeDoor ::"
```

```haskell
ghci> let mySomeDoor = mkSomeDoor Opened "Birch"
ghci> :t mySomeDoor
SomeDoor
ghci> putStrLn $ case mySomeDoor of
        MkSomeDoor SOpened _ -> "mySomeDoor was opened!"
        MkSomeDoor SClosed _ -> "mySomeDoor was closed!"
        MkSomeDoor SLocked _ -> "mySomeDoor was locked!"
mySomeDoor was opened!
```

Using `mkSomeDoor`, we can truly pass in a `DoorState` that we generate at
runtime (from IO, or a user prompt, or a configuration file, maybe), and create
a `Door` based on it.

Take *that*, type erasure! :D

The Singletons Library
----------------------

Now that we understand some of the benefits of singletons as they relate to
phantom types, we can appreciate what the singletons *library* has to offer: a
fully unified, coherent system for working with singletons of almost *all*
Haskell types!

First, there's Template Haskell for generating our singletons given our type:

```haskell
data DoorState = Opened | Closed | Locked
  deriving (Show, Eq)

genSingletons [''DoorState]

-- or
!!!singletons/DoorSingletons.hs "$(singletons "
```

This generates, for us:

```haskell
-- not the actual code, but essentially what happens
data Sing :: DoorState -> Type where
    SOpened :: Sing 'Opened
    SClosed :: Sing 'Closed
    SLocked :: Sing 'Locked
```

`Sing` is a poly-kinded type constructor (a "data family").  `STrue :: Sing
'True` is the singleton for `'True`, `SJust SOpened :: Sing ('Just 'Opened)` is
the singleton for `'Just 'Opened`, etc.

It also generates us instances for `SingI`, a poly-kinded typeclass:

```haskell
instance SingI 'Opened where
    sing = SOpened
instance SingI 'Closed where
    sing = SClosed
instance SingI 'Locked where
    sing = SLocked
```

Which is basically our `SingDSI` typeclass, except we have instances for
singletons of all kinds! (heh)  There's a `SingI` instance for `'True`, a
`SingI` instance for `10`, a `SingI` instance for `'Just 'Opened`, etc.:

```haskell
ghci> sing :: Sing 'True
STrue
ghci> sing :: Sing ('Just 'Opened)
SJust SOpened
```

The great thing about the library is that these types and instances are
generated, that they're correct (note that I could have implemented `SingDSI`
incorrectly earlier, bu using the library guarantees that I don't), and that
they all work together smoothly.

We also have `withSingI`, which is equivalent to our `withSingDSI` function
earlier.

```haskell
withSingI :: Sing s -> (forall r. SingI s => r) -> r
```

Note that if you have singletons for a kind `k`, you also have instances for
kind `Maybe k`, as well.  And also for `[k]`, even!  This is a major advantage
of using the *singletons* library to manage your singletons instead of writing
them yourself.

```haskell
ghci> :t SOpened `SCons` SClosed `SCons` SLocked `SCons` SNil
Sing '[ 'Opened, 'Closed, 'Locked ]
```

(Remember that, because of `DataKinds`, `Maybe` is a kind constructor, who has
two type constructors, the type `'Nothing` and the type constructor `'Just :: k
-> Maybe k`)

Singletons for all integrate together seamlessly, and you have mechanisms to
generate them for your own type and roll it all into the system!

### Extra Goodies

In addition to generating singletons for our libraries, it gives us convenient
functions for working with the different "manifestations" of our types.

Recall that `DoorState` has four different things associated with it now:

1.  The *type* `DoorState`, whose value constructors are `Opened`, `Closed`,
    and `Locked`.
2.  The *kind* `DoorState`, whose type constructors are `'Opened`, `'Closed`,
    and `'Locked`
3.  The singletons for `'Opened`, `'Closed`, and `'Locked`.
4.  The `SingI` instances for `'Opened`, `'Closed`, and `'Locked'`

Kind of confusing, and in the future, when we have real dependent types, we can
hopefully combine all of these manifestations into the same thing.  But for
now, we do have to deal with converting between them, and for that, we have,
generated for us:

*   `fromSing :: Sing (s :: DoorState) -> DoorState` takes us from singletons
    to values:

    ```haskell
    ghci> fromSing SOpened
    Opened
    ```

*   `toSing :: DoorState -> SomeSing DoorState` takes us from values to their
    (existentially quantified) singletons

    ```haskell
    ghci> let s = toSing Opened
    ghci> :t s
    s :: SomeSing DoorState
    ghci> putStrLn $ case s of
            SomeSing SOpened -> "Opened."
            SomeSing SClosed -> "SClosed."
            SomeSing SLocked -> "SLocked."
    "Opened."
    ```

    `SomeSing` is like `SomeDoor` in that it is an existentially quantified
    singleton:

    ```haskell
    data SomeSing DoorState :: Type where
        SomeSing :: Sing s -> SomeSing DoorState

    -- or, more accurately, since `SomeSing` is polykinded
    data SomeSing :: k -> Type where
        SomeSing :: Sing (a :: k) -> SomeSing k
    ```

It does this by defining a type class (actually, a "kind class"), `SingKind`,
associating each type to the corresponding datakinds-generated kind.  The
`SingKind` instance for `DoorState` links the type `DoorState` to the kind
`DoorState`.

The library also defines a neat type synonym, `type SDoorState = Sing`, so you
can do `SDoorState 'Opened` instead of `Sing 'Opened`, if you wish.

There are definitely more useful utility functions, but we will investigate
these later on in the series!  For now, you can look at the [documentation][]
for the library to see more interesting utility functions!

[documentation]: http://hackage.haskell.org/package/singletons/docs/Data-Singletons.html

The Singularity
---------------

In this post, at shortcomings in the usage of phantom types, and then saw how
singletons could help us with these.  Then, we looked at how the *singletons*
**library** makes using this pattern extremely easy and smooth to integrate
into your existing code.

You can see all of the "manual singletons" code in this post
[here][manual-door], and then see the code re-implemented using the
*singletons* library [here][singletons-door].

!!![manual-door]:singletons/Door.hs
!!![singletons-door]:singletons/DoorSingletons.hs

However, full expressively with phantom types is still out of our reach.  If we
want to express more complicated relationships and to be able to treat phantom
types (and *types*, in general) as first-class values, and delve into the
frighteningly beautiful world of "type-level programming", we are going to have
to dig a bit deeper.  Come back for the next post to see how!  Singletons will
be our tool, and we'll also see how the singletons library is a very clean
unification of a lot of concepts.

As always, let me know in the comments if you have any questions!  You can also
usually find me idling on the freenode `#haskell` channel, as well, as *jle\`*.
The *singletons* [issue tracker][singgh] is also very active.
Happy haskelling!

[singgh]: https://github.com/goldfirere/singletons/issues

Exercises
---------

Click on the links in the corner of the text boxes for solutions!

These should be written in the singletons library style, with `Sing` instead of
`SingDS` and `SingI` instead of `SingDSI`.  Review the [singletons
file][singletons-door] for a comparison, if you are still unfamiliar.

1.  Write a function to unlock a door, but only if the user enters an odd
    number (as a password).

    ```haskell
    !!!singletons/DoorSingletons.hs "unlockDoor ::"1
    ```

    It should return a closed door in `Just` if the caller gives an odd number,
    or `Nothing` otherwise.

2.  Write a function that can open any door, taking a password.

    ```haskell
    !!!singletons/DoorSingletons.hs "openAnyDoor ::"1
    ```

    This should be written in terms of `unlockDoor` and `openDoor`.

    If the door is already unlocked or opened, it should ignore the `Int`
    input.

3.  Implement `withSomeDoor` for our "new" existentially quantified `SomeDoor`
    type.

    ```haskell
    !!!singletons/DoorSingletons.hs "withSomeDoor ::"1
    ```

4.  Implement `openAnySomeDoor`, which should work like `lockAnySomeDoor`, just
    wrapping an application of `openAnyDoor` inside a `SomeDoor`.

    ```haskell
    !!!singletons/DoorSingletons.hs "openAnySomeDoor ::"1
    ```

    Note that because we wrote `openAnyDoor` in "implicit style", we might have
    to convert between `SingI s =>` and `Sing s ->` style, using `withSingI`.

