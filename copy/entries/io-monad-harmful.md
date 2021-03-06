---
title: IO Monad Considered Harmful
categories: Haskell
tags: haskell, functional programming, monads, io
series: Haskell Mythbusters
create-time: 2015/01/20 22:08:11
date: 2015/01/22 10:01:17
modified-time: 2015/01/22 22:20:44
identifier: io-monad-harmful
slug: io-monad-considered-harmful
old-slugs: 
entry-id: 31
---

In the tradition of "considered harmful" posts, this post's title is
intentionally misleading and designed to incite controversy --- or at least
grab your attention.  Because of this, please take my exaggerations in this
article for what they are :)  In following tradition I will try to leave as
many quotes and soundbytes as possible that can be easily taken terribly out
of context and twisted.

Anyways, I don't mean that this "IO Monad" is something to be avoid.  In fact,
there's a lot I rather like about it.  What I mean is that the phrase "IO
Monad"...it's got to go.  It has its usages, but 99.9% of times it is used, it
is used improperly, with much damaging effects. So let's go ahead with
stopping this nonsense once and for all, okay?

So I'll say it here:

**The phrase "IO monad" considered harmful.  Please do not use
it.**[^never][^sometimes]

In most circumstances, an *IO action* of an *IO type*[^iotype] is the more
helpful and more correct answer.

[^iotype]: Note here, I am referring to the *IO type*, not the *`IO` type
constructor*.  The actual abstract data type, and not the `IO :: * -> *` type
constructor that you use in type signatures.  When we talk about the "Map
type", we talk about the abstract data type, the underlying binary search
tree, and the API that it offers...we don't really talk about the
`Map :: * -> * -> *` *type constructor*.

I'm going to say that this is probably **the single most harmful and damaging
thing** in Haskell and the community, with regards to pedagogy, practice,
public perception, and kittens.  Not even kidding.  It's actually literally
the worst and everyone in the world is worse off every time someone says it.
Not only is this a problem in and of itself, but it is at the core root of 90%
(+/- 80%) of Haskell's problems.

[^never]: In any case, ever, for any circumstance or reason.
[^sometimes]: Just kidding.  Only a sith deals in absolutes.

Please, Not the "IO Monad"
--------------------------

Let's say someone comes to you and asks you the question: "How does Haskell do
things like print a string?"

The answer is: **Definitely not with the IO monad.**

This is literally one of the simplest questions a new person to Haskell could
possibly ask.  There are many incorrect answers you could give, but "the IO
Monad" is one of the most incorrect answers possible.

For one, one of the most beautiful things about Haskell is that IO actions are
all [first-class normal data objects][fcs], like lists or integers or
booleans.

[fcs]: http://blog.jle.im/entry/first-class-statements

The answer to this is that you use something of an IO action -- somethign of
an `IO` type.

You use an *IO action* (of the *IO type*)

~~~haskell
ghci> :t putStrLn "hello world"
putStrLn "hello world" :: IO ()
~~~

There is nothing that has to do with monads at all in printing a string.  The
idea that `putStrLn "hello world"` is monadic is as absurd as saying that
`[1,2,3]` is monadic.

Saying that the answer is the "IO monad" implies that the monad part is
something important.  **It's not.**

**IO in Haskell has nothing to do with monads.**

::::: {.note}
**Aside**

Okay, so the truth is a *little* more complicated than this.

IO's monadic interface is intimately intertwined with its history.  It can be
said that the *reason* why the model for IO that Haskell has was chosen is
*because* of its monadic interface.  The fact that this IO model admits a
monadic interface was a major factor in its adoption as *the* IO model for
Haskell.

So, monads "have something to do" with the design decisions of IO in Haskell.
But it is still true that IO doesn't need to have a monadic interface in order
to do IO.  But that isn't as nice of a one-liner/sound byte now, is it?

Special thanks to Chris Allen and Kevin Hammond for this important
clarification.

:::::

You could take away monads and even the entire monadic interface from Haskell
and Haskell could *still* do IO *with the same IO type*.

The ability for Haskell to work with IO comes from the fact that we have a
regular ol' data type that represents IO actions, in the same way that `Bool`
represents a boolean or `Integer` represents an integer.

Saying "the IO monad" is literally the most misleading thing you could
possibly say.  IO in Haskell has nothing to do with monads.[^seeaside]

[^seeaside]: See the aside for a qualification.

How did this idea become so prevalent and pervasive?  I cannot say!  But
somehow, somewhere, this idea happened, and it is persistent now.  Please do
not add anything to this misconception and further propagate this dangerous
myth.

Saying "IO monad" is very misleading and awful pedagogy because when someone
new to Haskell reads that you print strings or do IO actions using "the IO
monad", the natural question is: "What is a monad?"

Not only is that question completely *irrelevant* to doing IO at all, it's
also a question that has [historically lead to much confusion][mtf].  I
consider it one of the worst "sidequests" you could embark on in learning
Haskell.  Seeking an intuitive grasp of what a monad is is not only worthless
for learning practical Haskell (at the start), but one that can lead to many
false answers, confusing and contradictory answers, and just a lot of headache
in general.  Before I even ever heard about Haskell, I heard about the
infamous "IO monad".  I read, "monads are a crazy hard-to-understand subject,
but once you understand it, Haskell becomes amazing."  Haskell is Haskell and
is useful before you ever introduce Monad into the picture...and a quote like
that implies that understanding monads is important to understanding Haskell
or IO.

[mtf]: https://byorgey.wordpress.com/2009/01/12/abstraction-intuition-and-the-monad-tutorial-fallacy/

It just simply *isn't*.  If you want to "understand Monads" (whatever that
means), then go ahead; try.  But please don't think that it'll help you **even
a single bit** in understanding IO in Haskell.

Saying "IO Monad" implies that understanding monads is some prerequisite to
understanding IO, or at the very least that IO in Haskell is inherently tied
to monads.  **Both are untrue**.

Another commonly mis-answered question is, "How does Haskell, a pure language,
handle impure side-effects?"

Again, the answer is **anything except "the IO Monad"**.  If I were to make a
list of the most misleading, incorrect, dangerous, and disgusting possible
answers, this would be on the top spot.  The *IO type itself* is what enables
this.  Not the monadic interface.

Bringing in the idea of "monads" into the idea really only leads to confusion,
because they literally contribute *nothing* to the subject.  And yet, why do I
see people answering, "Haskell handles IO and impurity with monads"?  I'm sure
you've heard at least one person saying this.  But it's 100% wrong.  **Monads
actually have nothing to do with it**, and I'm not even exaggerating here.

If anything it adds to the perceived learning barrier of Haskell.  **If
something as simple as IO requires *category theory* to understand, then
something must be way off.** (Luckily, it doesn't)  This really only *adds
more* to the perception of Haskell as an academic language that people learn
only to be able to feel smarter.  Haskell already has a huge PR problem as it
is; we don't need people going around doing this and making it even worse.
Please, do not contribute to this.

Furthermore, imagine someone new to Haskell asked you, "Can I store a sequence
of numbers?"

One good answer would be, "Yes, with a list!", or the list type.

One bad answer would be, "Yes, with the List Monad!"

Now someone who wants to be able to do something simple like `[1, 2, 3]` will
think that something like `[1, 2, 3]` in Haskell is inherently tied to monads
in some way.

But having a list like `[1,2,3]` has nothing to do with monads.  Calling every
list "the list monad", or calling every situation where a list would be useful
a situation where "you want the List monad" is misleading, false, and just
leads to more confusion.

I need to find all even numbers from one to one hundred.

Right: Use a list and `filter even` over a list from one to one
hundred.

Wrong: Use the list monad and `filter even` over a list from one to one
hundred.

Even more wrong but you couldn't really get more wrong in the first place: Use
the list monoid and `filter even` over a list from one to one hundred.

Why would you ever do that?

What good does it do?

What good has it ever done anyone?

Really, why?

Why do people say the IO monad?

Why did people start saying that in the first place?

Why doesn't this world make any sense?

Please, please, stop saying "the IO monad".

Some side notes
---------------

*   "State monad" and "Writer monad" and "Reader monad" are just as bad when
    abused, and you know it.  Shame on you.

*   A good time to use the "(something) monad" is when you are referring in
    particular to the monad instance or its monadic interface.

*   I have qualms with the "monad" part of "IO monad", but sometimes, I even
    wonder about the "IO" part.  Yes, Haskell can do IO through the IO type,
    but it's really possible to program effectful code interfacing with IO
    without ever directly working with the IO type; one could even just think
    of IO as a nice "intermediate data structure" that GHC or whatever Haskell
    compiler you are using can understand.  Use a library or DSL or whatever
    to write your IO-based code, just make sure your library has a function to
    transform it into an IO.  Already, many real-world Haskell code that "does
    IO" doesn't ever directly work with the IO type itself.

*   For those confused at this point there are some appropriate times to use
    "the X monad".  It's in the cases where you take advantage of the monadic
    interface.  Just like you call an array an iterator when you use the
    Iterator interface.  Here are some examples:

    *   "I have to print a string": No; use the "primitive" `putStrLn`.
    *   "I have to turn an IO action returning an `Int` into an IO action
        returning a `Bool` (if it's even)": No; use [`fmap`][imw] to
        "map" your `Int -> Bool` onto the `IO Int`.
    *   "I have to print a string twice, or multiple strings": Kinda.  You can
        use the monadic interface to do this using *do* notation, or `mapM_`
        or `(>>)`.  I say abuse because while using the monadic interface to
        do this is possible, it is a little overkill; `(*>)` and `traverse_`
        do the trick as well.
    *   "I want to combine two IO actions, two programs, into one that does
        both of the original ones one after the other": See the above.
    *   "I have to do line-by-line constant-memory text processing of a large
        file": No; please use a streaming combinator library like *pipes* or
        *conduit*.  (Working directly with) the `IO` type is actually
        notoriously bad at this.  Don't use it; and of course, don't use its
        monad instance either.
    *   "I have to directly use the result of one IO action in order to decide
        which IO action should happen next": Yes, this is a use case for IO's
        monadic interface.
    *   "What is one type can I use with a *do* block": Yes, IO Monad.
        Because only monads can be used with *do* blocks.
    *   "What is a Monad I can use as the underlying monad for my monad
        transformer?": Yes, IO Monad.  Because you need a monad in particular.
    *   "What is best way to get to the grocery store?": No; use Google Maps
        or something like that.
    *   "What is a word that begins with I and rhymes with 'Bio Monad'?":
        Yes, IO Monad.
*   **Edit**: So a lot of people seem to be getting the impression that I
    advocate not using the word "monad" to describe things like "binding"
    expressions, do blocks, using `(>>=)` with `IO`, etc.  I am not really
    quite for this.  I do advise that if you are talking specifically about
    monadic things, you should say that they are monadic things.  Hiding
    things from people isn't going to help anyone and only leads to more
    confusion, and I think it might get in the way of learning and making
    important connections.

    However, what I *am* against is saying "monad" to describe things that are
    clearly not monadic.  Like printing a string, or sequencing a bunch of
    independent actions.

    In short: use Monad when you are talking about IO's monadic properties;
    don't use it when you aren't.  Simple, right?

[imw]: http://blog.jle.im/entry/inside-my-world-ode-to-functor-and-monad




