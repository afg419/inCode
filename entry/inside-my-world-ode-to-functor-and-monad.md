Inside My World (Ode to Functor and Monad)
==========================================

> Originally posted by [Justin Le](https://blog.jle.im/) on May 19, 2014.
> [Read online!](https://blog.jle.im/entry/inside-my-world-ode-to-functor-and-monad.html)

I like Haskell because it lets me live inside my world.

There are a lot of special worlds out there! And Haskell lets me stay in those
worlds, and use all of the tools I normally have when I'm not there. I get to
transform normal tools into tools that work in my world.

(This post is meant to be approachable by people unfamiliar with Haskell! That
being said, if there is a concept you don't understand, feel free to leave a
comment, [tweet](https://twitter.com/mstk) me, stop by on irc at freenode's
\#haskell, or give [Learn You a Haskell](http://learnyouahaskell.com/) a quick
read!)

Stuck in Maybe
--------------

(Feel free to play along with the code in this section by [loading it into
ghci](https://github.com/mstksg/inCode/tree/master/code-samples/inside/maybe.hs),
the Haskell interpreter!)

In Haskell, we have a type called `Maybe a`:

~~~haskell data Maybe a = Nothing | Just a ~~~

This says that `Maybe a` is like an Enumerable type of sorts; The `|` reads like
"*or*".

This is like saying

~~~haskell data Bool = False | True ~~~

to define a `Bool` data type. If I have something of type `Bool`, it can be
(literally) `False` or `True`. If I have something of type `Maybe a`, it can be
`Nothing` (nothing is there, it's empty) or `Just x` (it contains a value `x`).

If you are used to an OOP language with templates or generics, this is similar
to saying `Maybe<a>` -- `Maybe<a>` is a parameterized type over some `a`.

This type is useful for functions that might fail:

~~~haskell -- source:
https://github.com/mstksg/inCode/tree/master/code-samples/inside/maybe.hs\#L23-41
-- interactive: https://www.fpcomplete.com/user/jle/inside-my-world --
divideMaybe: Takes two integers and returns -- possibly -- their integer --
quotient. It succeeds if the denominator is not zero, and fails if -- it is.
divideMaybe :: Int -&gt; Int -&gt; Maybe Int divideMaybe \_ 0 = Nothing
divideMaybe x y = Just (x `div` y)

-- headMaybe: Takes a list and returns -- possibly -- its first element. --
Fails if the list is empty, and succeeds with the first element -- otherwise.
headMaybe :: \[a\] -&gt; Maybe a headMaybe \[\] = Nothing headMaybe (x:\_) =
Just x

-- halveMaybe: Takes an integer and returns -- possibly -- its half. Fails -- if
it is an odd number. halveMaybe :: Int -&gt; Maybe Int halveMaybe x | x `mod` 2
== 0 = Just (x `div` 2) | otherwise = Nothing ~~~

&lt;div class="note"&gt; **Aside**

Oh hi!

For people new to Haskell:

~~~haskell foo :: Int -&gt; Bool foo x = ... ~~~

declares a function named `foo` of type `Int -> Bool` --- we use `::` to specify
type signatures. `Int -> Bool` means that it takes an `Int` (named `x`) and
returns a `Bool`.

I'll often just say `bar :: Bool` to say "the value `bar` (of type `Bool`)"; you
could just read `::` as "type of".

So `divideMaybe :: Int -> Int -> Maybe Int` means that `divideMaybe` takes two
`Int`s and returns something of type `Maybe Int`.

You might have also noticed the pattern matching construct, `headMaybe (x:_)`.
This matches the first element in the list to the name `x`, and the rest of the
list to the wildcard, `_`. &lt;/div&gt;

When you want to return a value of type `Maybe a`, you can either return
`Just x` or `Nothing` (where `x :: a`) --- they both are members of type
`Maybe a`. That's what `Maybe Int` means --- an `Int` that might or might not be
there!

If I had something of type `Maybe Int`, would you know for sure if that `Int`
was there or not (from just the type)? You wouldn't! You are living in the world
of uncertainties.

Welcome to the world of uncertainty.\[^dundundun\]

### The Problem

Okay, well, I have a `Maybe Int`. Which is nice and all...but...I want to do
normal inty-things with it.

That is...I have all these functions that work only on `Int`!

~~~haskell -- source:
https://github.com/mstksg/inCode/tree/master/code-samples/inside/maybe.hs\#L43-50
-- interactive: https://www.fpcomplete.com/user/jle/inside-my-world addThree ::
Int -&gt; Int addThree = (+ 3)

square :: Int -&gt; Int square = (^ 2)

showInt :: Int -&gt; String showInt = show ~~~

But...I can't do these things on `Maybe Int`!

~~~haskell ghci&gt; addThree (Just 5) \*\*\* SCARY ERROR! \*\*\* addThree takes
an Int but you gave it a Maybe Int. \*\*\* What are you trying to do anyway,
wise guy. ~~~

&lt;div class="note"&gt; **Aside**

In this post, commands at the interactive Haskell interpreter (REPL) ghci are
prefaced with the prompt `ghci>`. If you see `ghci>`, it means that this is
something you'd enter at ghci. If not, it is normal Haskell source code!

In `ghci`, we also have this command `:t` that you'll be seeing often that lets
you find the type of something:

~~~haskell ghci&gt; :t True True :: Bool ~~~ &lt;/div&gt;

In most other languages, to get around this, you would "exit" your uncertain
world. That is, you would turn your uncertain 5 into either a certain 5 or an
error. Or you would turn your uncertain 5 into either a certain 5 or some
"default" value.

That is, you would use functions like these to exit your world:\[^fjfm\]

~~~haskell -- source:
https://github.com/mstksg/inCode/tree/master/code-samples/inside/maybe.hs\#L76-82
-- interactive: https://www.fpcomplete.com/user/jle/inside-my-world certaintify
:: Maybe a -&gt; a certaintify (Just x) = x certaintify Nothing = error "Nothing
was there, you fool!"

certaintifyWithDefault :: a -&gt; Maybe a -&gt; a certaintifyWithDefault \_
(Just x) = x certaintifyWithDefault d Nothing = d ~~~

And then you can just willy-nilly use your normal `Int -> Int` functions on what
you pull out...using various "error handling" mechanisms if it was `Nothing`.

~~~haskell ghci&gt; addThree (certaintify (headMaybe \[1,2,3\])) 4 ghci&gt;
square (certaintify (halveMaybe 7)) \*\*\* Exception: Nothing was there, you
fool! ghci&gt; square (certaintifyWithDefault 0 (halveMaybe 7)) 0 ~~~

But...work with me here. Let's say I want to live in my uncertain world.

There are a lot of reasons why one might want to do that.

Let's say you had a function that looked up a person from a database given their
ID number. But not all ID numbers have a person attached, so the function might
fail and not lookup anyone.

~~~haskell personFromId :: ID -&gt; Maybe Person ~~~

And you also had a function that returned the age of a given person:

~~~haskell age :: Person -&gt; Int ~~~

What if you wanted to write a function that looked up *the age of the person in
that database with that ID*. The result is going to also be in a `Maybe`,
because the given ID might not correspond to anyone to have an age for.

~~~haskell ageFromId :: ID -&gt; Maybe Int ~~~

In this case, it would make no sense to "exit" the world of uncertainty as soon
as we get a `Maybe Person`, and then "re-enter" it somehow when you return the
`Maybe Int`. Our entire answer is shrouded in uncertainty, so we need to *stay
inside this world* the entire time. We want to find a way to deal with values
inside a world *without leaving it*.

So we have a function `Person -> Int`, and a `Maybe Person`...darnit. How do we
use our `age` function, without leaving `Maybe`? We certainly want to re-use the
same function somehow, and not write it again from scratch!

### Can I have a lift?

So the problem: I have a function `a -> b` that I want to be able to use on a
`Maybe a`...I want to stay in my `Maybe` world and use that function on the
uncertain value.

If you look at this carefully, we want some sort of "function transformer". Give
our transformer an `a -> b`, it'll output a new function `Maybe a -> Maybe b`.
The new function takes an `a` that may or may not be there, and outputs a `b`
that may or not be there.

We want a function of type `(a -> b) -> (Maybe a -> Maybe b)`

Let's make one! It'll apply the function to the value inside a `Just`, and leave
a `Nothing` alone.

~~~haskell -- source:
https://github.com/mstksg/inCode/tree/master/code-samples/inside/maybe.hs\#L84-88
-- interactive: https://www.fpcomplete.com/user/jle/inside-my-world inMaybe ::
(a -&gt; b) -&gt; (Maybe a -&gt; Maybe b) inMaybe f = liftedF where liftedF
(Just x) = Just (f x) liftedF Nothing = Nothing ~~~

What can we do with it?

~~~haskell ghci&gt; let addThreeInMaybe = inMaybe addThree ghci&gt;
addThreeInMaybe (Just 7) Just 10 ghci&gt; addThreeInMaybe Nothing Nothing
ghci&gt; (inMaybe square) (Just 9) Just 81 ghci&gt; (inMaybe showInt) Nothing
Nothing ghci&gt; (inMaybe showInt) (Just 8) Just "8" ~~~

Wow! We can now use normal functions and still stay inside my uncertain world.
We could even write our `ageFromId`:

~~~haskell -- source:
https://github.com/mstksg/inCode/tree/master/code-samples/inside/maybe.hs\#L68-69
-- interactive: https://www.fpcomplete.com/user/jle/inside-my-world ageFromId ::
ID -&gt; Maybe Int ageFromId i = (inMaybe age) (personFromId i) ~~~

Now we are no longer afraid of dealing with uncertainty. It's a scary realm, but
as long as we have `inMaybe`...all of our normal tools apply!

~~~haskell ghci&gt; let x = headMaybe \[2,3,4\] -- x = Just 2 ghci&gt; let y =
(inMaybe square) x -- y = Just 4 ghci&gt; let z = (inMaybe addThree) y -- z =
Just 7 ghci&gt; (inMaybe (&gt; 5)) z Just True ghci&gt; let x' = halveMaybe 7 --
x' = Nothing ghci&gt; let y' = (inMaybe square) x' -- y' = Nothing ghci&gt; let
z' = (inMaybe addThree) y' -- z' = Nothing ghci&gt; (inMaybe (&gt; 5)) z'
Nothing ~~~

### Functor

This concept of "bringing functions into worlds" is actually a useful and
generalizable concept. In fact, in the standard libraries, there's a typeclass
(which is like an interface, sorta, for you Java/OOP people) that provides a
common API/interface for "worlds that you can bring functions into."

We call it `Functor`, and this "bring into world" function is called `fmap`.

It should come as no surprise that `Maybe` is a Functor, so `fmap` *does* take
any function `a -> b` and "lifts" it into the `Maybe` world, turning it into a
`Maybe a -> Maybe b`.

`fmap` for `Maybe` is incidentally exactly our `inMaybe`.

~~~haskell ghci&gt; (fmap square) (headMaybe \[4,5,6\]) Just 16 ghci&gt; (fmap
square) (halveMaybe 7) Nothing ~~~

&lt;div class="note"&gt; **Aside**

Any "legitimate" instance of `Functor` must satisfy a couple of properties ---
"laws", so to speak. These laws basically ensure that whatever instance you
define is useful and sensible, and follow what sort of meaning `fmap` is
supposed to convey.

1.  `fmap (f . g)` should equal `fmap f . fmap g`; that is, lifting composed
    functions be the same as composing lifted functions. (`(.)` is the function
    composition operator)
2.  `fmap id thing` should leave `thing` unchanged.

&lt;/div&gt;

Some notes before we move on!

First of all, even though we have been writing things like `(fmap f) x`, the
parentheses are actually unnecessary due to the way Haskell associates function
calls. So `(fmap f) x` is the same as `fmap f x`, and we'll be writing it that
way from now on.

Secondly, an infix operator alias for `fmap` exists: `(<$>)`. That way, you can
write `fmap f x` as `f <$> x`, which is meant to look similar to `f $ x`:

~~~haskell ghci&gt; addThree $ 7 10 ghci&gt; addThree &lt;$&gt; Just 7 Just 10
ghci&gt; addThree &lt;$&gt; Nothing Nothing ~~~

(For those unfamiliar, `f $ x` = `f x`)

### Sort of a big deal

Let's pause and reflect to see that this is sort of a big deal, and see what
problem `Functor` just solved.

In another language, you might somehow have a `Maybe<Int>` (using generics
syntax). And you have lots and lots and lots of functions that take `Int`s.
Heck, why would you even ever have a function take a `Maybe<Int>`? A function
would be like:

~~~java class Monster { void deal\_damage(int damage) {}; } ~~~

where your `deal_damage` function would take an integer. So `Maybe Int` is
useless! You either have to re-write `deal_damage` to take a `Maybe Int`, and
have *two versions* of it, or you turn your `Maybe Int` into an `Int` somehow.

In this light, `Maybe` is a huge nuisance. It is a big, annoying thing to deal
with and it probably results in a lot of boilerplate, making you either
duplicate functions or extract `Maybe` values every time you get one.

But now...*now*, `Maybe` is not a nuisance, and there is *no boilerplate*. All
your functions now...*just work*, as they are!

And this is a big deal.

"Pre-lifting"
-------------

Okay, so we now can turn `a -> b` into `Maybe a -> Maybe b`.

That might be nice, but if you scroll up just a bit, you might see that there
are other functions that might be interesting to apply on a `Maybe a`.

What about `halveMaybe :: Int -> Maybe Int`? Can I use `halveMaybe` on a
`Maybe Int`?

~~~haskell ghci&gt; let x = divideMaybe 12 3 -- x = Just 4 :: Maybe Int ghci&gt;
halveMaybe x \*\*\* SCARY ERROR! \*\*\* halveMaybe takes an Int but you gave it
\*\*\* a Maybe Int. Please think about your life. ~~~

Oh no! Maybe we can't really stay inside our `Maybe` world after all!

This might be important! Let's imagine this trip down our world of uncertainty
--- let's say we wanted a function `halfOfAge`

~~~haskell halfOfAge :: ID -&gt; Maybe Int ~~~

That returns (possibly), half of the age of the person corresponding to that ID
(and `Nothing` if the person looked up has an odd age. Because odd ages don't
have halves, of course.). Well, we already have `ageFromId :: ID -> Maybe Int`,
but we want to apply `halveMaybe` to that `Maybe Int`. But we can't! Because
`halveMaybe` only works on `Int`!

We can't even use `fmap`, because:

~~~haskell ghci&gt; :t fmap halveMaybe fmap halveMaybe :: Maybe Int -&gt; Maybe
(Maybe Int) ~~~

Wrong wrong wrong! We don't want a `Maybe Int -> Maybe (Maybe Int)`, we want a
`Maybe Int -> Maybe Int`! `fmap` lifts "both sides" of the function, but we only
want, in this case, to "lift" the input.

This is a disaster!

But wait, calm down. We have overcome similar things before. With our recent
journey to Functor enlightenment in mind, let's try to look for a similar path.

We had an `a -> b` that we wanted to apply to a `Maybe a`, we used `fmap` to
turn it into a `Maybe a -> Maybe b`. So we have a `a -> Maybe b` here that we
want to apply to a `Maybe a`. The plan is simple! We turn an `a -> Maybe b` into
a `Maybe a -> Maybe b`. Let's pretend we had such a function.

~~~haskell liftInput :: (a -&gt; Maybe b) -&gt; (Maybe a -&gt; Maybe b) ~~~

How should we expect this to behave?

Well, let's think this through case-by-case.

If we want to apply `halveMaybe` to a number that isn't there...well...it should
also return a number that isn't there. It should propagate the not-thereness.

If we want to apply `halveMaybe` to a number that *is* there...well, just apply
it to that number, and take that result! If the result is there, then you have a
result there. If the result is not there, then you don't.

We have enough to write this out ourselves:

~~~haskell -- source:
https://github.com/mstksg/inCode/tree/master/code-samples/inside/maybe.hs\#L90-94
-- interactive: https://www.fpcomplete.com/user/jle/inside-my-world liftInput ::
(a -&gt; Maybe b) -&gt; (Maybe a -&gt; Maybe b) liftInput f = liftedF where
liftedF Nothing = Nothing liftedF (Just x) = f x ~~~

~~~haskell ghci&gt; :t liftInput halveMaybe Maybe Int -&gt; Maybe Int ghci&gt;
let x = divideMaybe 12 3 -- x = Just 4 :: Maybe Int ghci&gt; (liftInput
halveMaybe) x Just 2 ghci&gt; let y = divideMaybe 12 0 -- y = Nothing :: Maybe
Int ghci&gt; (liftInput halveMaybe) y Nothing ~~~

Neat! Now we don't have to fear `a -> Maybe b`'s...we can use them and *still
stay in our world*, without leaving our world of uncertainty!

~~~haskell -- source:
https://github.com/mstksg/inCode/tree/master/code-samples/inside/maybe.hs\#L71-72
-- interactive: https://www.fpcomplete.com/user/jle/inside-my-world halfOfAge ::
ID -&gt; Maybe Int halfOfAge i = (liftInput halveMaybe) (ageFromId i) ~~~

### Monad

Like with Functor and `fmap`, this general pattern of turning an `a -> f b` into
an `f a -> f b` is also useful to generalize.

In general, you can think functions `a -> world b` as functions that "bring you
into your world". We would like to turn it, in general, into
`world a -> world b`. Lifting the input only, so to speak.

We say that if a world has such a way of lifting the input of such a function
(plus some other requirements), it implements the `Monad`
typeclass\[^othermonad\].

Monad is a typeclass (which is kinda like an interface), so that means that if
`Maybe` is a Monad, it "implements" that way to turn a `a -> Maybe b` into a
`Maybe a -> Maybe b`.

We call this `(a -> Maybe b) -> (Maybe a -> Maybe b)` function "bind".

Now, embarrassingly enough, "bind" actually isn't called `bind` in the standard
library...it actually only exists as an operator, `(=<<)`.

(Remember how there was an operator form of `fmap`? We have both `fmap` and
`(<$>)`? Well, in this case, we *only* have the operator form of `bind`,
`(=<<)`. Yeah, I know. But we live with it just fine!).

`(=<<)` is exactly our `liftInput` for `Maybe`. Let's try it out:

~~~haskell ghci&gt; :t (=&lt;&lt;) halveMaybe Maybe Int -&gt; Maybe Int ghci&gt;
let x = divideMaybe 12 3 -- x = Just 4 :: Maybe Int

-- use it as a prefix function ghci&gt; (=&lt;&lt;) halveMaybe x Just 2 ghci&gt;
let y = divideMaybe 12 0 -- y = Nothing :: Maybe Int

-- use it as an infix operator ghci&gt; halveMaybe =&lt;&lt; y Nothing ~~~

And now maybe we can finally rest easy knowing that we can "stay inside `Maybe`"
and never have to leave it.

&lt;div class="note"&gt; **Aside**

The "other thing" that Monad has to have (the other thing that the "interface"
demands, besides `(=<<)`) is a way to "bring a value into your world".

This function is called `return`.

For example, for `Maybe`, we need a way to take a normal value like an `Int` and
"bring it into" our world of uncertainty --- an `Int -> Maybe Int`. For `Maybe`,
semantically, to bring something like `7` into the world of uncertainty...well,
we already know the `7` is there. So to bring a `7` into `Maybe`, it's just
`Just 7`

For an instance of `Monad` to be considered legitimate, there are a few
rules/laws that `return` and `(=<<)` must obey when used together in order to be
useful (just like for `Functor`). If you define nonsensical `return` and
`(=<<)`, of course, your instance won't be very useful anyway, and you wouldn't
be able to reason with how they work together. The laws sort of are some way of
ensuring that your instance is useful and sensible, and that `(=<<)` and
`return` make sense at all. &lt;/div&gt;

&lt;div class="note"&gt; **Aside**

Now, for some strange reason, it is actually much more popular to use `(>>=)`
over `(=<<)`; `(>>=)` is just `(=<<)` backwards:

~~~haskell ghci&gt; halveMaybe =&lt;&lt; Just 8 Just 4 ghci&gt; Just 8 &gt;&gt;=
halveMaybe Just 4 ~~~

This is really weird! I mean...really *really* weird! Why would you ever put the
function you are applying *after* the value you are applying it to? That's like
having `x :: a` and `f :: a -> b`, and doing `x f` or something!

Why is this style the norm? Who knows!\[^whoknows\] People are just weird!

For the rest of this article, we will be using `(=<<)`; just be aware that you
might see `(>>=)` out in the wild more often! &lt;/div&gt;

Recap
-----

Thanks to Functor and Monad, we now have a way to confidently stay in our world
of uncertainty and still use normal functions on our uncertain values --- we
only have to use the right "lifters".

If you have an `x :: Maybe a` and you have a:

-   `f :: a -> b`, then use `fmap` or `(<$>)` --- `fmap f x` or `f <$> x`

-   `f :: a -> Maybe b`, then use `(=<<)` --- `f =<< x`

Armed with these two, you can comfortably stay in `Maybe` without ever having to
"get out of it"!

### A big picture

Again, the big picture is this: sometimes we get values inside contexts, or
worlds. But we have functions like `a -> world b` that *produce values inside
your world*.

Which normally would leave you "high and dry", because you can't, say, apply
that same function twice. You either have to write a new `world a -> world b`
version or some other boilerplate.

With Functor, we can make normal functions treat our world values like normal
values; with Monad, we can do the same with functions that "bring us into"
worlds. With these two together...maybe contexted values aren't so bad after
all!

Other Worlds
------------

### on Worlds

You might have noticed that up until now I have used the word "world" pretty
vaguely.

When I say that a value is "inside" a "world", I mean that it "lives" inside the
context of what that world represents. A `Maybe a` is an `a` living in the
`Maybe` "world" --- it is an `a` that can exist or not exist. `Maybe` represents
a context of existing-or-not-existing.\[^worlds\]

But there are other worlds, and other contexts too. And though I have shown you
what Functor and Monad look like for `Maybe`...you probably need to see a few
more examples to be really convinced that these are general design patterns that
you can apply to multiple "values in contexts".

It's important to remember that `fmap` and `(=<<)` don't really have any
inherent semantic meaning...and their usefulness and "meaning" come from just
the specific instance. We saw what they "did" for `Maybe`, but their meaning
came from `Maybe` itself. For other worlds, as we will see, we can make them
mean completely different things.

&lt;div class="note"&gt; **Aside**

There are some important nuances that might trip you up! Though useful worlds
are instances of Monad, it is improper to say that "Monads are worlds/values in
contexts". That's not what Monads *are*. Monads are just Monads (the two
functions and their laws), no more and no less.

In our usage here, Functor and Monad mean only "these things implement some sort
of `fmap` and `(=<<)`, etc., and those two are useful." That is, the interface
offered by Functor and Monad are useful for our specific world. But there are
plenty of Functors and Monads that are not "worlds". &lt;/div&gt;

Anyways, here is a whirlwind tour of different worlds, to help you realize how
often you'll actually want to live in these worlds in Haskell, and why having
`fmap` and `(=<<)` are so useful!

### The world of future values

(Play along with this section too by [loading the
source](https://github.com/mstksg/inCode/tree/master/code-samples/inside/reader.hs)!)

In Haskell, we have a `Reader r` world. You can think of `(Reader r) a` as a
little machine that "waits" for something of type `r`, then *uses* it to
(purely) make an `a`. The `a` doesn't exist yet; it's a future `a` that will
exist as soon as you give it an `r`.

~~~haskell -- source:
https://github.com/mstksg/inCode/tree/master/code-samples/inside/reader.hs\#L17-27
-- interactive: https://www.fpcomplete.com/user/jle/inside-my-world --
futureLength: A future `Int` that will be the length of whatever the -- list it
is waiting for will be. futureLength :: (Reader \[a\]) Int

-- futureHead: An future `a` that will be the first element of whatever the --
list it is waiting for will be. futureHead :: (Reader \[a\]) a

-- futureOdd: A future `Bool` that will be whether the `Int` it is waiting --
for is odd or not. futureOdd :: (Reader Int) Bool ~~~

`futureLength` is a "future `Int`"; an `Int` waiting (for an `[a]`) to be
realized. `futureHead` is a "future `a`", waiting for an `[a]`.

We use the function `runReader` to "force" the `a` out of the `(Reader r) a`:

~~~haskell -- given a `(Reader r) a` and an `r`, uses that `r` to finally get
the `a`: runReader :: (Reader r) a -&gt; r -&gt; a ~~~

~~~haskell ghci&gt; runReader futureLength \[1,2,3\] 3 ghci&gt; runReader
futureHead \[1,2,3\] 1 ghci&gt; runReader futureOdd 6 False ghci&gt; runReader
futureOdd 5 True ~~~

Welcome to the world of future values.

&lt;div class="note"&gt; **Aside**

It is important to note here that `(Reader Int) Bool` and `(Reader [Int]) Bool`
*do not exist* in the same world. One lives in a `Reader Int` world --- a world
of future values awaiting an `Int`. The other lives in a `Reader [Int]` world
--- a world of future values awaiting an `[Int]`. &lt;/div&gt;

Let's say I have a future `Int`. Say, `futureLength`, waiting on an `[a]`. And I
have a function `(< 5) :: Int -> Bool`. Can I apply `(< 5)` to my future `Int`,
in order to get a future `Bool`?

At first, no! This future `Int` is useless! I can't even use it in *any* of my
normal functions! Time to reach for the exit button?

Oh --- but, because `Reader [a]` is a Functor, I can use `fmap` to turn
`(< 5) :: Int -> Bool` into
`fmap (< 5) :: (Reader [a]) Int -> (Reader [a]) Bool`!

~~~haskell -- source:
https://github.com/mstksg/inCode/tree/master/code-samples/inside/reader.hs\#L34-38
-- interactive: https://www.fpcomplete.com/user/jle/inside-my-world
futureShorterThan :: Int -&gt; (Reader \[a\]) Bool futureShorterThan n = fmap
(&lt; n) futureLength

futureShorterThan5 :: (Reader \[a\]) Bool futureShorterThan5 = futureShorterThan
5 ~~~

~~~haskell ghci&gt; runReader futureShorterThan5 \[1,2,3\] True ghci&gt;
runReader (futureShorterThan 3) \[1,2,3,4\] False ~~~

And voilà, we have a future `Bool`. We turned an `Int -> Bool` into a function
that takes a future `Int` and returns a future `Bool`. We *applied `(< 5)` to
our future length*, to get a future `Bool` telling us if that length is less
than 5.

So `futureShorterThan` is a function that takes an `Int` and turns it into a
future `Bool`. Let's go...deeper. What if I wanted to apply `futureShorterThan`
to a *future* `Int`? To *still* get a future `Bool`?

I can't apply `futureShorterThan` to a future `Int` straight-up, because it only
takes `Int`. Boo! But, wait --- `Reader [Int]` is a Monad, so that means I can
take the `Int -> (Reader [a]) Bool` and turn it into a
`(Reader [a]) Int -> (Reader [a]) Bool` using `(=<<)`!

Using `(=<<)`, we turned a function from `Int` to a future `Bool` to a function
from a future `Int` to a future `Bool`.

~~~haskell futureShorterThan :: Int -&gt; (Reader \[a\]) Bool (=&lt;&lt;)
futureShorterThan :: (Reader \[a\]) Int -&gt; (Reader \[a\]) Bool ~~~

Hm. Let's try this out on a future `Int` we have...we can use
`futureHead :: (Reader [Int]) Int`.

~~~haskell -- source:
https://github.com/mstksg/inCode/tree/master/code-samples/inside/reader.hs\#L40-41
-- interactive: https://www.fpcomplete.com/user/jle/inside-my-world
futureShorterThanHead :: (Reader \[Int\]) Bool futureShorterThanHead =
futureShorterThan =&lt;&lt; futureHead ~~~

So, we are applying `futureShorterThan` to the `Int` we got from `futureHead`.
And so we get a future `Bool` that tells us if that future `Int` we got from the
input list is shorter than the input list.

~~~haskell ghci&gt; runReader futureShorterThanHead \[1,2,3\] False ghci&gt;
runReader futureShorterThanHead \[5,2,3\] True ~~~

Neat!

Now, we can live in a world of "future values", and now use all of our "normal"
functions on future values!

In another language, we might have had to do this complicated dance of "forcing"
futures to get the value (to "exit" the world of future values), applying
functions to that value, and going "back into" the future.

But now, we *don't have to be scared of future values*. We can work with them
just as well as if they were normal values, and "leave" them as futures the
entire time, without ever forcing them until when we really need to, and only
force them *once*.

Who said futures were complicated, anyway?

### The world of "IO"

(The source code for this section is [also available
online](https://github.com/mstksg/inCode/tree/master/code-samples/inside/io.hs)
for you to play with!)

And now we go into the most infamous of Haskell worlds, `IO`.

`IO` is "kind of like" our `Reader r` world --- an `IO Int` is an `Int` that
*doesn't yet exist*...but that will be computed by a CPU/computer *when a CPU
executes it*.

In this sense, an `IO Int` is kind of like a little packet of Assembly or C code
--- it contains instructions (assembly commands, machine language) for a
computer to do this and that and eventually produce an `Int`. An `IO String`
could, for example, be a little packet of C code that reads a file and outputs
the contents of that file. The `String` doesn't exist yet --- but it will, once
the computer executes those commands.

If you've ever used a Unix operating system, there is a shell command `ls` that
lists the contents of a directory. The actual `ls` program is kind of like an
`IO [FilePath]`. The `[FilePath]` does not "exist" inside" `ls` --- rather, `ls`
is a program that promises a list of `FilePath`s when it is executed by the
computer or interpreter.

So an `IO String` doesn't "contain" a `String` --- it is a program that
*promises* a `String` in the future, when a computer eventually executes
it,\[^exitio\].

One common IO object we are given is `getLine :: IO String`. `getLine` is kind
of like the Unix program `cat` --- it promises a `String`, and it gets that
`String` by taking in from standard input. That is, it is a program that, when
executed by a computer, pulls a line from stdin, and returns that as the
`String` it promises. `getLine` contains instructions for a computer to get a
`String` from stdin. A future/promised `String`.

We want to apply `length :: String -> Int` to that future/promised `String`, to
get us a future/promised `Int`. Again, we can't apply `length` to `getLine`
directly --- but because `IO` is a Functor, we can use
`fmap length :: IO String -> IO Int`.

~~~haskell getLine :: IO String length :: String -&gt; Int fmap length :: IO
String -&gt; IO Int fmap length getLine :: IO Int ~~~

Neat!

We had a function that only worked on `String`, but we made it work the
"future/promised" `String` of `IO String`

Let's look at a function returning an IO action `wc`, which takes a filename and
returns a program that, when executed, promises an `Int` --- the number of lines
in that file.

~~~haskell -- source:
https://github.com/mstksg/inCode/tree/master/code-samples/inside/io.hs\#L19-19
-- interactive: https://www.fpcomplete.com/user/jle/inside-my-world wc :: String
-&gt; IO Int ~~~

So `wc "file.txt"` would evaluate to a computation that, when executed by a
computer, produces an `Int` (by loading the file from disk using system calls,
reading it, and counting the lines).

`wc` is a function that takes a (non-future, normal) `String`.

But what if we wanted to apply `wc` to `getLine`, the `IO String` we had? We
want to apply `wc` to that "future `String`". We can't apply it directly. We
want to turn our `String -> IO Int` into an `IO String -> IO Int`.

Luckily, `IO` is a Monad, so we have `(=<<)` at our disposal.

~~~haskell getLine :: IO String wc :: String -&gt; IO Int (=&lt;&lt;) wc :: IO
String -&gt; IO Int wc =&lt;&lt; getLine :: IO Int ~~~

Neat!

What does `wc =<< getLine` do, as a program? How does it compute that `Int`?

Conceptually, it all sort of "makes sense" if you look at it from a high level
view. `getLine` is an `IO String` --- a future `String`. `wc` takes a `String`
and returns a future `Int`. If we "applied `wc` to `getLine`", we would be
applying `wc` to that future `String`, to get a future `Int`.

And so there we have it --- we *don't ever have to* actually work "directly"
with computed values `a` that are received from IO. All we ever have to do is
work with `IO a`, and we can use *all of our normal functions* on that `IO a`,
as if they were normal `a`s.

In that way, we don't have to be scared of working with "future computable
values" --- we can use all of our normal tools on them!

Even more
---------

There are lots of other worlds besides just `Maybe`, `Reader r`, and `IO`. Each
one comes with their own unique semantics/meanings/contexts, and their own
answer for what `fmap` and `(=<<)` are supposed to "mean".

Here are some others --- with brief descriptions.

1.  The world of `Either e`, which is like `Maybe` in which things may or may
    not be there. But in `Either e`, when things aren't there, they come with a
    reason why they are not (of type `e`).

2.  The world of `[]`, where things are the results of computations that have
    ambiguous answers. I wrote a [series of
    posts](http://blog.jle.im/entries/series/+monadplus-success-failure-monads)
    on this :)

3.  The world of `State s`, which is a world of future things awaiting an `s`,
    which modify the `s` in the process.

4.  The world of `Parser`, which is a world of things that an input string will
    be parsed into.

There are many more! The great thing about Haskell is that with `fmap` and
`(=<<)`, it is easy to work with values inside these worlds with all of your
normal functions, without any real extra effort. Normal functions, normal
values, values inside worlds...we have them all at our disposal.

Haskell lets me stay *inside my world*!

Final Notes
-----------

For some further reading, Gabriel Gonzalez's ["Functor Design
Pattern"](http://www.haskellforall.com/2012/09/the-functor-design-pattern.html)
post covers a similar concept for people more familiar with Haskell and explains
it more elegantly than I ever could have.

Don't forget as you're reading and moving on that it's not correct to say
"Functors are worlds", or "Monads are worlds". As I mentioned before in an
aside, Monads aren't "anything" other than the functions and the laws. Rather,
if we look at `Maybe`, etc. as a "world", then *having a Monad
interface/instance* allows us to do cool things with that world.

Feel free to again [play around
with](https://github.com/mstksg/inCode/tree/master/code-samples/inside) the code
used here and load it in ghci yourself!

Experienced readers might have noted an unconventional omission of "Applicative
Functors", which (since 2008-ish) traditionally goes somewhere in between the
section on Functor and the section on Monad. Applicative Functors, in this
context, are handy in that they let you combine two values in worlds together;
that is, if you have a `Maybe a` and a `Maybe b`, it allows you to use an
`a -> b -> c` to "squash" them into a `Maybe c`. This squashing action is called
`liftA2`.

As always, if you have any questions, leave them in the comments, or come find
me on freenode's \#haskell --- I go by *jle\`* :)

(Special thanks to c\_wraith and rhaps0dy for their time reviewing this post)
