Abstract Validating Forms with Free Applicative/Alternative
===========================================================

> Originally posted by [Justin Le](https://blog.jle.im/).
> [Read online!](https://blog.jle.im/entry/forms-with-free-applicative-alternative.html)

One tool I've been finding myself using a lot recently is the *Free Applicative*
(and *Free Alternative*), from the
*[free](https://hackage.haskell.org/package/free)* package.

Free Monads are great, and they're often used to implement the "interpreter
pattern" (although I personally prefer
*[operational](https://hackage.haskell.org/package/operational)*, as I wrote
about in a [previous blog
post](https://blog.jle.im/entry/interpreters-a-la-carte-duet.html), for that
design pattern). However, Free Applicatives are really a completely different
type of thing, and the use cases for each are pretty disjoint.

If I had to make a general statement, I'll say that free monads are especially
good at representing the idea of abstract *sequential* generators (sequences
that are chained dependently one after the other), and that free applicatives
are especially good at representing the idea of abstract *parallel* generators
(things operating in parallel without any interconnected data dependences).

For this post, I'll be talking about using the Free Applicative `Ap` (and the
Free Alternative, `Alt`) with an abstract representation of a form element in
order to generate an abstract representation of a validating form, and
leveraging this representation to realize these forms in terminal IO, JSON/YAML,
PDF documents, and even on the browser using *ghcjs* and
*[miso](https://hackage.haskell.org/package/miso)*.

Overview
--------

The general approach to utilizing the Free Applicative is to start with some
Functor `F` (`F a` represents the act of generating a value of type `a`). Once
you throw `F` into `Ap` to get `Ap F`, you now are able to *combine `F`s in
parallel* with `<$>`, `<*>`, `liftA2`, `sequence`, `traverse`, etc., even though
`F` normally could not support such combinations. Then, finally, you have the
ability to provide a concrete generator function
`forall a. Applicative f => F a -> f a` (given `F a`, return an actual generator
of `a`s in some `Applicative`), and the magic of the Free Applicative will go in
and actually run all of your combined `F` actions "in parallel". The trick is
that, with the same value of `Ap F a`, you can *run multiple different concrete
generators* on it, so you can realize `Ap F` in multiple different contexts and
situations, adapting it for whatever you need.

So, in our case, we're going to be making a Functor representing a form element:

``` {.haskell}
data FormElem a
```

Where a `FormElem a` represents a *single form element* producing an `a`. A
`FormElem Int`, for instance, will represent a single form element producing an
`Int`.

Then, we can create, using
[Ap](https://hackage.haskell.org/package/free/docs/Control-Applicative-Free.html):

``` {.haskell}
type Form = Ap FormElem
```

And now we have a type where `Form a` is *whole form with multiple elements*
that all work together to produce a value of type `a`!

For example, if we had `intElem :: FormElem Int`, then
`liftAp intElem :: Form Int`, a single-item form that makes an `Int`:

``` {.haskell}
intElem :: FormELem Int

intForm :: Form Int
intForm = liftAp intElem
```

We can now do all of our Applicativey stuff with it, to generate, for instance,
a form with two items that produces their sum:

``` {.haskell}
-- | A form with two elements, whose overal result is the sum of the two
-- element's inputs
addingForm :: Form Int
addingForm = (+) <$> intForm <*> intForm
```

Or, we can even generate a form with many 'Int' elements, and produce a list of
all of their items:

``` {.haskell}
-- | A form with five elements, whose result is a list of all of their inputs
bunchaInts :: Form [Int]
bunchaInts = replicateM 5 intForm
```

Of course, in real life, forms usually have *Alternative* instances, which
allows you to use `<|>` to "chose" a result between potentially invalid entries,
and also create "optional" entries for free using `optional`. To do that, we
actually use the *Free Alternative*,
*[Alt](https://hackage.haskell.org/package/free/docs/Control-Alternative-Free-Final.html)*,
instead:

``` {.haskell}
type Form = Alt FormElem

intForm :: Form Int
intForm = liftAlt intElem
```

And now we get the ability to represent forms with multiple options with `<|>`:

``` {.haskell}
eitherInt :: Form (Either Int Int)
eitherInt = (Left <$> intForm) <|> (Right <$> intForm)
```

From multiple forms, with `choice`:

``` {.haskell}
oneOfMany :: Form Int
oneOfMany = choice [intForm1, intForm2, intForm3]
```

And create "optional" entries:

``` {.haskell}
optionalInt :: Form (Maybe Int)
optionalInt = optional intForm
```

We get all of these capabilities *for free*! All we did was *define a single
form element*, and `Alt` gives us the ability to combine them with `<*>`/`<$>`,
create optional form items with `optional`, and create multiple form options
with `<|>`!
