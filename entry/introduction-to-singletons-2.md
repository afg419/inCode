Introduction to Singletons (Part 2)
===================================

> Originally posted by [Justin Le](https://blog.jle.im/).
> [Read online!](https://blog.jle.im/entry/introduction-to-singletons-2.html)

Welcome back to our journey through the singleton design pattern and the great
*[singletons](http://hackage.haskell.org/package/singletons)* library!

This post is a direct continuation of [Part
1](https://blog.jle.im/entry/introduction-to-singletons-1.html), so be sure to
check that out first if you haven’t already! If you hare just jumping in now, I
suggest taking some time to to through the exercises if you haven’t already!

Again, code is built on *GHC 8.2.2* with the
*[lts-10.0](https://www.stackage.org/lts-10.0)* snapshot (so, singletons-2.3.1).

Review
------

Let’s return to our `Door` type:

``` {.haskell}
-- source: https://github.com/mstksg/inCode/tree/master/code-samples/singletons/Door2.hs#L17-23
$(singletons [d|
  data DoorState = Opened | Closed | Locked
    deriving (Show, Eq)
  |])

data Door :: DoorState -> Type where
    UnsafeMkDoor :: { doorMaterial :: String } -> Door s
```

First, this derives the *type* `DoorState` with the values `Opened`, `Closed`,
and `Locked`, and also the *kind* `DoorState` with the *types* `'Opened`,
`'Closed`, and `'Locked`. We then also derive the singletons (and implicit-style
typeclass instances, reflectors, etc.) with the template haskell.

Then, there’s `Door`. `Door` is great! It is an *indexed data type* (indexed by
a type of kind `DoorState`) in that picking a different type variable gives a
different “type” of Door:

-   `Door 'Opened` is a type that represents the type of an opened door
-   `Door 'Closed` is a *different* type that represents the type of a *closed*
    door
-   `Door 'Locked` is yet another (third) type that represents the type of a
    *locked* door.

So, really, when we define `Door s`, we really are defining *three distinct*
types (and also a not-so-obvious fourth one, which we will discuss later).

This is great and all, but isn’t Haskell a language with static, compile-time
types? Doesn’t that mean that we have to know if our doors are opened, closed,
or locked at compile-time?

This is something we can foresee being a big issue. It’s easy enough to create a
`Door s` if you know `s` at compile-time by just typing in a type annotation
(`UnsafeMkDoor "Oak" :: Door 'Opened`). But what if we *don’t* know `s` at
compile-time?

To learn how to do this, we first need to learn how to *not care*.

Ditching the Phantom
--------------------

Sometimes we don’t *actually* care about the state of the door in the *type* of
the door. We don’t want `Door 'Opened` and `Door 'Closed`…we want a type to just
represent a door, without the status in its type.

This might come about a bunch of different ways. Maybe you’re reading a `Door`
data from a serialization format, and you want to be able to parse *any* door
(whatever door is serialized).

More concretely, we’ve seen this in `lockAnyDoor`, as well – `lockAnyDoor`
doesn’t care about the type of its input (it can be *any* `Door`). It only cares
about the type of its output (`Door 'Locked`).

To learn how to not care, we can describe a type for a door that does *not* have
its status in its type.

We have a couple of options here. First, we can create a new type `SomeDoor`
that is the same as `Door`, except instead of keeping its status in its type, it
keeps it as a runtime value:

``` {.haskell}
data SomeDoor = MkSomeDoor
    { someDoorState    :: DoorState
    , someDoorMaterial :: String
    }

-- or, in GADT syntax
data SomeDoor :: Type where
    MkSomeDoor ::
      { someDoorState    :: DoorState
      , someDoorMaterial :: String
      } -> SomeDoor
```

Note the similarity of `SomeDoor`’s declaration to `Door`’s declaration above.
It’s mostly the same, except, instead of `DoorState` being a type parameter, it
is instead a runtime value inside `SomeDoor`.

Now, this is actually a type that we *could* have been using this entire time,
if we didn’t care about type safety. In the real world and in real applications,
we actually might have written `SomeDoor` *before* we ever thought about `Door`
with a phantom type. It’s definitely the more typical “standard” Haskell thing.

`SomeDoor` is great. But because it’s a completely different type, we can’t
re-use any of our `Door` functions on this `SomeDoor`. We potentially have to
write the same function twice for both `Door` and `SomeDoor`, because they have
different implementations.

### The Existential Datatype

However, there’s another path we can take. With the power of singletons, we can
actually implement `SomeDoor` *in terms of* `Door`, using an **existential data
type**:

``` {.haskell}
-- using existential constructor syntax
data SomeDoor = forall s. MkSomeDoor (Sing s) (Door s)

-- or, using GADT syntax (preferred)
-- source: https://github.com/mstksg/inCode/tree/master/code-samples/singletons/Door2.hs#L57-58
data SomeDoor :: Type where
    MkSomeDoor :: Sing s -> Door s -> SomeDoor
```

`MkSomeDoor` is a constructor for an existential data type, meaning that the
data type “hides” a type variable `s`. Note the type
(`Sing s -> Door s -> SomeDoor`) and how the result type (`SomeDoor`) *forgets*
the `s` and hides all traces of it.

Note the similarities between our original `SomeDoor` and this one.

``` {.haskell}
-- | Re-implementing door
data SomeDoor where
    MkSomeDoor :: DoorState -> String -> SomeDoor

-- | Re-using Door, as an existential type
data SomeDoor where
    MkSomeDoor  :: Sing s  -> Door s -> SomeDoor
                            -- ^ data Door s = UnsafeMkDoor String
```

Basically, our type before re-implements `Door`. But the new one actually
directly uses the original `Door s`. This means we can *directly* re-use our
`Door` functions on `SomeDoor`s, without needing to convert our implementations.

In Haskell, existential data types are pretty nice, syntactically, to work with.
Let’s write some basic functions to see. First, a function to “make” a
`SomeDoor` from a `Door`:

``` {.haskell}
-- source: https://github.com/mstksg/inCode/tree/master/code-samples/singletons/Door2.hs#L60-64
fromDoor :: Sing s -> Door s -> SomeDoor
fromDoor = MkSomeDoor

fromDoor_ :: SingI s => Door s -> SomeDoor
fromDoor_ = MkSomeDoor sing
```

So that’s how we *make* one…how do we *use* it? Let’s port our `Door` functions
to `SomeDoor`, by re-using our pre-existing functions whenever we can:

``` {.haskell}
-- source: https://github.com/mstksg/inCode/tree/master/code-samples/singletons/Door2.hs#L66-73
closeSomeOpenedDoor :: SomeDoor -> Maybe SomeDoor
closeSomeOpenedDoor (MkSomeDoor s d) = case s of
    SOpened -> Just . fromDoor_ $ closeDoor d
    SClosed -> Nothing
    SLocked -> Nothing

lockAnySomeDoor :: SomeDoor -> SomeDoor
lockAnySomeDoor (MkSomeDoor s d) = fromDoor_ $ lockAnyDoor s d
```

Using an existential wrapper with a singleton makes this pretty simple – just a
simple unwrapping and re-wrapping! Imagine having to re-implement all of these
functions for a completely different type, and having to re-implement all of our
previous `Door` functions!

It’s important to remember that the secret ingredient here is the `Sing s` we
store inside `MkSomeDoor` – it gives our pattern matchers the ability to deduce
the `s` type. Without it, the `s` would be lost forever.

Imagine if `MkSomeDoor` did not have the `Sing`:

``` {.haskell}
data SomeDoor where
    MkSomeDoor  :: Door s -> SomeDoor
```

It would then be impossible to write `closeSomeOpenedDoor`:

``` {.haskell}
closeSomeOpenedDoor :: SomeDoor -> Maybe SomeDoor
closeSomeOpenedDoor (MkSomeDoor d) =
            -- is the door opened, closed, or locked?
            -- there's no awy to know!
```

### The Link

It’s important to remember that our original separate-implementation `SomeDoor`
is, functionally, identical to the new code-reusing `Door`. All of the contents
are isomorphic with each other, and you could write a function converting one to
the other. The reason why they are the same is that *having an existentially
quantified singleton is the same as having a value of the corresponding type.*
Having an existentially quantified `SingDS s` is *the same as* having a value of
type `DoorState`.

In fact, the *singletons* library gives us a direct existential wrapper:

``` {.haskell}
-- from singletons (not the actual definition)
data SomeSing DoorState :: Type where
    SomeSing :: Sing s -> SomeSing DoorState
```

There are three values of type `SomeSing DoorState`:

``` {.haskell}
SomeSing SOpened :: SomeSing DoorState
SomeSing SClosed :: SomeSing DoorState
SomeSing SLocked :: SomeSing DoorState
```

A value of type `SomeSing DoorState` (which contains an existentially quantified
`Sing s` – a `SingDS`) is *the same* as a value of type `DoorState`. The two
types are identical! (Or, well, isomorphic. As a fun exercise, write out the
explicit isomorphism – the `SomeSing DoorState -> DoorState` and the
`DoorState -> SomeSing DoorState`).

Our new `SomeDoor` containing an existentially quantified `Sing s` is the same
as our first `SomeDoor` containing just a `DoorState`.

#### Why Bother

If they’re identical, why use a `Sing` or the new `SomeDoor` at all? Why not
just use a `DoorState` value?

The main reason (besides allowing code-reuse) is that *using the singleton lets
us directly recover the type*. Essentially, a `Sing s` not only contains whether
it is Opened/Closed/Locked (like a `DoorState` would)…it contains it in a way
that GHC can use to *bring it all back* to the type level.

A `forall s. SomeDoor (Sing s) (Door s)` essentially contains `s` *with*
`Door s`. When you see this, you *should read this as*
`forall s. SomeDoor s (Door s)` (and, indeed, this is similar to how it is
written in dependently typed languages.)

It’s kind of like how, when you’re used to reading Applicative style, you start
seeing `f <$> x <*> y` and reading `f x y`. When you see
`forall s. SomeDoor (Sing s) (Door s)`, you should read (the pseudo-haskell)
`forall s. SomeDoor s (Door s)`. The role of `Sing s` there is, like in Part 1,
simply to be a run-time stand-in for the type `s` itself.

So, for our original `Door s` functions, we need to know `s` at runtime –
storing the `Sing s` gives GHC exactly that. Once you get the `Sing s` back, you
can now use it in all of our type-safe functions from Part 1, and you’re back in
type-safe land.

### Some Lingo

In the language of dependently typed programming, we call `SomeDoor` a
**dependent sum**, because you can imagine it basically as a sum type:

``` {.haskell}
data SomeDoor = SDOpened (Door 'Opened)
              | SDClosed (Door 'Closed)
              | SDLocked (Door 'Locked)
```

A three-way sum between a `Door 'Opened`, a `Door 'Closed`, and a
`Door 'Locked`, essentially. If you have a `SomeDoor`, it’s *either* an opened
door, a closed door, or a locked door. Try looking at this new `SomeDoor` until
you realize that this type is the same type as the previous `SomeDoor`!

You might also see `SomeDoor` called a **dependent pair** – it’s a “tuple” where
the *type* of the second item (our `Door s`) is determined by the *value* of the
first item (our `Sing s`).

In Idris, we could write `SomeDoor` as a type alias, using its native dependent
sum syntax, as `s ** Door s`. The *value* of the first item reveals to us
(through a pattern match, in Haskell) the *type* of the second.

### Types at Runtime

With this last tool, we finally have enough to build a function to “make” a door
with the status unknown until runtime:

``` {.haskell}
mkSomeDoor :: DoorState -> String -> SomeDoor
mkSomeDoor = \case
    Opened -> MkSomeDoor SOpened . mkDoor SOpened
    Closed -> MkSomeDoor SClosed . mkDoor SClosed
    Locked -> MkSomeDoor SLocked . mkDoor SLocked
```

``` {.haskell}
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

### The Existential Type

An *existentially quantified* type is one that is hidden to the user/consumer,
but directly chosen by the producer. The producer chooses the type, and the user
has to handle any possible type that the producer gave.

This is in direct contrast to the *universally quantified* type (which most
Haskellers are used to seeing), where the type is directly chosen by the *user*.
The user chooses the type, and the producer has to handle any possible type that
the user asks for.

For example, a function like:

``` {.haskell}
read :: Read a => String -> a
```

Is universally quantified over `a`: The *caller* of `read` gets to pick which
type is given. The implementor of `read` has to be able to handle whatever `a`
the user picks.

But, for a value like:

``` {.haskell}
myDoor :: SomeDoor
```

The type variable `s` is existentially quantified. The person who *made*
`myDoor` picked what `s` was. And, if you *use* `myDoor`, you have to be ready
to handle *any* `s` they could have chosen.

In Haskell, there’s another way to express an existentially quantified type: the
CPS-style encoding. To help us understand it, let’s compare a basic function in
both styles. We saw earlier `mkSomeDoor`, which takes a `DoorState` and a
`String` and returns an existentially quantified `Door` in the form of
`SomeDoor`:

``` {.haskell}
mkSomeDoor
    :: DoorState
    -> String
    -> SomeDoor
mkSomeDoor s m = case s of
    Opened -> MkSomeDoor SOpened (mkDoor SOpened m)
    Closed -> MkSomeDoor SClosed (mkDoor SClosed m)
    Locked -> MkSomeDoor SLocked (mkDoor SLocked m)
```

The caller of the function can then break open the `SomeDoor` and must handle
whatever `s` they find inside.

We can write the same function using a CPS-style existential instead:

``` {.haskell}
withDoor
    :: DoorState
    -> String
    -> (forall s. Sing s -> Door s -> r) -> r
withDoor s m f = case s of
    Opened -> f SOpened (mkDoor SOpened m)
    Closed -> f SClosed (mkDoor SClosed m)
    Locked -> f SLocked (mkDoor SLocked m)
```

With a Rank-N Type, `withDoor` takes a `DoorState` and a `String` and a
*function to handle one polymorphically*. The caller of `withDoor` must provide
a handler that can handle *any* `s`, in a uniform and parametrically polymorphic
way. It then gives the result of the handler function called on the resulting
`Sing s` and `Door s`.

``` {.haskell}
ghci> withDoor Opened "Birch" $ \s d -> case s of
         SOpened -> "Opened door!"
         SClosed -> "Closed door!"
         SLocked -> "Locked door!"
Opened door!
```

### Reification

The general pattern we are exploiting here is called **reification** – we’re
taking a dynamic run-time value, and lifting it to the type level as a type
(here, the type variable `s`). You can think of reification as the opposite of
*reflection*, and imagine the two as being the “gateway” between the type-safe
and unsafe world. In the dynamic world of a `DoorState` term-level value, you
have no type safety. You live in the world of `SomeDoor`, `closeSomeOpenedDoor`,
`lockAnySomeDoor`, etc. But, you can *reify* your `DoorState` value to a *type*,
and enter the type-safe world of `Door s`, `closeDoor`, `lockDoor`, and
`lockAnyDoor`.

The *singletons* library automatically generates functions to directly reify
`DoorState` values:

``` {.haskell}
toSing       :: DoorState -> SomeSing DoorState
withSomeSing :: DoorState -> (forall s. Sing s -> r) -> r
```

The first one reifies a `DoorState` as an existentially quantified data type,
and the second one reifies in CPS-style, without the intermediate data type.

We can use these to write `mkSomeDoor` and `withDoor`:

``` {.haskell}
-- source: https://github.com/mstksg/inCode/tree/master/code-samples/singletons/Door2.hs#L78-83
mkSomeDoor :: DoorState -> String -> SomeDoor
mkSomeDoor ds = case toSing ds of
    SomeSing s -> MkSomeDoor s . mkDoor s

withDoor :: DoorState -> String -> (forall s. Sing s -> Door s -> r) -> r
withDoor ds m f = withSomeSing ds $ \s -> f s (UnsafeMkDoor m)
```

Zooming Out
-----------

Alright! We’ve spent two blog posts going over a lot of different things in the
context of our humble `Door s` type. Let’s zoom out and take a large-scale look
at how *singletons* (the design pattern, and the library) helps us in general.

### Sing

The crux of everything is the `Sing :: Type -> Type` indexed type. If you see a
value of type `Sing s`, you should really just think “a runtime witness for
`s`”. If you see:

``` {.haskell}
lockAnyDoor :: Sing s -> Door s -> Door 'Locked
MkSomeDoor  :: Sing s -> Door s -> SomeDoor
```

You should read it as (in pseudo-Haskell)

``` {.haskell}
lockAnyDoor :: { s } -> Door s -> Door 'Locked
MkSomeDoor  :: { s } -> Door s -> SomeDoor
```

This is seen clearly if we look at the partially applied type signatures:

``` {.haskell}
lockAnyDoor SOpened :: Door 'Opened -> Door 'Locked
MkSomeDoor  SLocked :: Door 'Locked -> SomeDoor
```

If you squint, this kinda looks like:

``` {.haskell}
lockAnyDoor 'Opened :: Door 'Opened -> Door 'Locked
MkSomeDoor  'Locked :: Door 'Locked -> SomeDoor
```

And indeed, when we get real dependent types in Haskell, we will really be
directly passing types (that act as their own runtime values) instead of
singletons.

It is important to remember that `Sing` is poly-kinded, so we can have
`Sing 'Opened`, but also `Sing 'True`, `Sing 5`, and
`Sing '['Just 3, 'Nothing, 'Just 0]` as well. This is the real benefit of using
the *singletons* library instead of writing our own singletons – we get to work
uniformly with singletons of all kinds.

#### SingI

`SingI` is a bit of typeclass trickery that lets us implicitly pass `Sing`s to
functions:

``` {.haskell}
class SingI s where
    sing :: Sing s
```

If you see:

``` {.haskell}
lockAnyDoor :: Sing  s -> Door s -> Door 'Locked
MkSomeDoor  :: Sing  s -> Door s -> SomeDoor
```

These are *identical* to

``` {.haskell}
lockAnyDoor :: SingI s => Door s -> Door 'Locked
MkSomeDoor  :: SingI s => Door s -> SomeDoor
```

Either way, you’re passing in the ability to get a runtime witness on `s` – just
in one way, it is asked for as an explicit argument, and the second way, it is
passed in using a typeclass.

We can *convert* from `SingI s ->` style to `SingI s =>` style using `sing`:

``` {.haskell}
-- source: https://github.com/mstksg/inCode/tree/master/code-samples/singletons/Door2.hs#L48-64
lockAnyDoor_ :: SingI s => Door s -> Door 'Locked
lockAnyDoor_ = lockAnyDoor sing

fromDoor_ :: SingI s => Door s -> SomeDoor
fromDoor_ = MkSomeDoor sing
```

And we can convert from `SingI s =>` style to `SingI s ->` style using
`withSingI`:

``` {.haskell}
lockAnyDoor :: Sing s -> Door s -> Door 'Locked
lockAnyDoor s d = withSingI s (lockAnyDoor_ d)

fromDoor :: Sing s -> Door s -> SomeDoor
fromDoor s d = withSingI s (fromDoor_ d)
```

Again, the same function – just two different styles of calling them.

### Reflection and Reification

Reflection is the process of bringing a type-level thing to a value at the term
level (“losing” the type information in the process) and reification is the
process of bringing a value-level Reification is the process of going from a
value at the *term level* to the *type level*.

You can think of reflection and reification as being the “gateways” between the
untyped/unsafe world and the typed/safe world. Reflection takes you from the
typed world to the untyped world (from `Sing s` to `DoorState`) and reification
takes you from the untyped world to the typed world (from `DoorState` to
`Sing s`).

One limitation in Haskell is that there is no actual link between the type
`DoorState` and its *values* with the *kind* `DoorState` with its *types*. Sure,
the constructors have the same names, but the language doesn’t actually link
them together for us.

#### SingKind

The *singletons* library handles this by using a typeclass with associated types
to implement a generalized reflection and reification process. It gives us the
`SingKind` “kindclass”:

``` {.haskell}
class SingKind k where
    -- | Associate a kind k with its reflected type
    type Demote k = (r :: Type)

    -- | Reflect a singleton to its term-level value
    fromSing :: Sing (a :: k) -> Demote k

    -- | Reflect a singleton to its term-level value
    toSing :: Demote k -> SomeSing k
```

Instances of `SingKind` are promoted kinds like `Bool`, `DoorState`, etc., and
`Demote` is an associated type/type family that associates each instance with
the *type* it is promoted from.

For example, remember how `data DoorState = Opened | Closed | Locked` created
the *type* `DoorState` (with value constructors `Opened`, `Closed`, and
`Locked`), and also the *kind* `DoorState` (with *type* constructors `'Opened`,
`'Closed`, and `'Locked`). Our *kind* `DoorState` would be the instance of
`SingKind`, and `Demote DoorState` would be the *type* `DoorState`.

The reason we need an explicit `Demote` associated type is, again, that GHC
doesn’t actually link the type and its promoted kind. `Demote` lets us
explicitly specify what type a `Kind` should expect its term-level reflected
values to be.

#### Examples

To illustrate explicitly, here is the automatically generated instance of
`SingKind` for the `DoorState` *kind*:

``` {.haskell}
instance SingKind DoorState where       -- the *kind* DoorState
    type Demote DoorState = DoorState   -- the *type* DoorState

    fromSing
        :: Sing (s :: DoorState)        -- the *kind* DoorState
        -> DoorState                    -- the *type* DoorState
    fromSing = \case
        SOpened -> Opened
        SClosed -> Closed
        SLocked -> Locked

    toSing
        :: DoorState                    -- the *type* DoorState
        -> SomeSing DoorState           -- the *kind* DoorState
    toSing = \case
        Opened -> SomeSing SOpened
        Closed -> SomeSing SClosed
        Locked -> SomeSing SLocked
```

If you are unfamiliar with how associated types work,
`type Demote DoorState = DoorState` means that wherever we see
`Demote DoorState` (with `DoorState` the *kind*), we replace it with `DoorState`
(the *type*). That’s why the type of our reflection function
`fromSing :: Sing s -> Demote DoorState` can be simplified to
`fromSing :: Sing s -> DoorState`.

Let’s take a look at the instance for `Bool`, to compare:

``` {.haskell}
-- Bool singletons have two constructors:
SFalse :: Sing 'False
STrue  :: Sing 'True

instance SingKind Bool where    -- the *kind* Bool
    type Demote Bool = Bool     -- the *type* Bool

    fromSing
        :: Sing (b :: Bool)        -- the *kind* Bool
        -> Bool                    -- the *type* Bool
    fromSing = \case
        SFalse -> False
        STrue  -> True

    toSing
        :: Bool                    -- the *type* Bool
        -> SomeSing Bool           -- the *kind* Bool
    toSing = \case
        False -> SomeSing SFalse
        True  -> SomeSing STrue
```

And a more sophisticated example, let’s look at the instance for `Maybe`:

``` {.haskell}
-- Maybe singletons have two constructors:
SNothing :: Sing 'Nothing
SJust    :: Sing x -> Sing ('Just x)

instance SingKind a => SingKind (Maybe a) where     -- the *kind* Maybe
    type Demote (Maybe a) = Maybe (Demote a)        -- the *type* Maybe

    fromSing
        :: Sing (m :: Maybe a)        -- the *kind* Maybe
        -> Maybe a                    -- the *type* Maybe
    fromSing = \case
        SNothing -> Nothing
        SJust sx -> Just (fromSing sx)

    toSing
        :: Maybe (Demote a)             -- the *type* Maybe
        -> SomeSing (Maybe a)           -- the *kind* Maybe
    toSing = \case
        Nothing -> SomeSing SNothing
        Just x  -> case toSing x of
          SomeSing sx -> SomeSing (SJust sx)
```

This definition, I think, is a real testament to the usefulness of having all of
our singletons be unified under the same system. Because of how `SingKind`
works, `Demote (Maybe DoorState)` is evaluated to `Maybe (Demote DoorState)`,
which is simplified to `Maybe DoorState`. This means that if we have a way to
reify `DoorState` values, we also have a way to reify `Maybe DoorState` values!
And, if we have a way to reflect `DoorState` singletons, we also have a way to
reflect `Maybe DoorState` singletons!

#### SomeSing

Throughout all of this, we utilize `SomeSing` as a generic poly-kinded
existential wrapper:

``` {.haskell}
data SomeSing :: Type -> Type where
    SomeSing :: Sing (x :: k) -> SomeSing k
```

Basically, this says that `SomeSing k` contains a `Sing x`, where `x` is of kind
`k`. This is why we had, earlier:

``` {.haskell}
SomeSing :: Sing (s :: DoorState) -> SomeSing DoorState
```

If we use `SomeSing` with, say, `SClosed`, we get
`SomeSing :: Sing 'Closed -> SomeSing DoorState` `SomeSing` is an indexed type
that tells us the *kind* of the type variable we existentially quantifying over.
The value `SomeSing STrue` would have the type `SomeSing Bool`. The value
`SomeSing (SJust SClosed)` would have the type `SomeSing (Maybe DoorState)`.

<!-- 3.  Implement `withSomeDoor` for the existentially quantified `SomeDoor` type. -->
<!--     ```haskell -->
<!--     !!!singletons/DoorSingletons.hs "data SomeDoor" "withSomeDoor ::"1 -->
<!--     ``` -->
<!-- 4.  Implement `openAnySomeDoor`, which should work like `lockAnySomeDoor`, just -->
<!--     wrapping an application of `openAnyDoor` inside a `SomeDoor`. -->
<!--     ```haskell -->
<!--     !!!singletons/DoorSingletons.hs "openAnySomeDoor ::"1 -->
<!--     ``` -->
<!--     You **shouild not** use `UnsafeMkDoor` directly. -->
<!--     Note that because we wrote `openAnyDoor` in "implicit style", we might have -->
<!--     to convert between `SingI s =>` and `Sing s ->` style, using `withSingI`. -->
<!-- However, full expressively with phantom types is still out of our reach.  If we -->
<!-- want to express more complicated relationships and to be able to treat phantom -->
<!-- types (and *types*, in general) as first-class values, and delve into the -->
<!-- frighteningly beautiful world of "type-level programming", we are going to have -->
<!-- to dig a bit deeper.  Come back for the next post to see how!  Singletons will -->
<!-- be our tool, and we'll also see how the singletons library is a very clean -->
<!-- unification of a lot of concepts. -->
<!-- ### A Reflection on Subtyping -->
<!-- Without phantom types you might have imagined being able to do something like -->
<!-- this: -->
<!-- ```hskell -->
<!-- data DoorOpened = MkDoorOpened { doorMaterial :: String } -->
<!-- data DoorClosed = MkDoorClosed { doorMaterial :: String } -->
<!-- data DoorLocked = MkDoorLocked { doorMaterial :: String } -->
<!-- ``` -->
<!-- Which is even possible now with `-XDuplicateRecordFields`.  And, for the most -->
<!-- part, you get a similar API: -->
<!-- ```haskell -->
<!-- closeDoor :: DoorOpened -> DoorClosed -->
<!-- lockDoor  :: DoorClosed -> DoorLocked -->
<!-- ``` -->
<!-- But what about writing things that take on "all" door types? -->
<!-- The only real way (besides typeclass magic) would be to make some sum type -->
<!-- like: -->
<!-- ```haskell -->
<!-- data SomeDoor = DO DoorOpened | DC DoorClosed | DL DoorLocked -->
<!-- lockAnyDoor :: SomeDoor -> DoorLocked -->
<!-- ``` -->
<!-- However, we see that if we parameterize a single `Door` type, we can have it -->
<!-- stand in *both* for a "known status" `Door` *and* for a "polymorphic status" -->
<!-- `Door`. -->
<!-- This actually leverages Haskell's *subtyping* system.  We say that `forall s. -->
<!-- Door s` (a `Door` that is polymorphic on all `s`) is a *subtype* of `Door -->
<!-- 'Opened`.  This means that a `forall s. Door s` can be used anywhere a function -->
<!-- would expect a `Door 'Opened`...but not the other way around. -->

