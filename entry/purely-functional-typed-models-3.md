A Purely Functional Typed Approach to Trainable Models (Part 3)
===============================================================

> Originally posted by [Justin Le](https://blog.jle.im/).
> [Read online!](https://blog.jle.im/entry/purely-functional-typed-models-3.html)

Hi again! Today we're going to jump straight into tying together the functional
framework described in this series and see how it can give us some interesting
insight, as well as wrapping it up by talking about the scaffolding needed to
turn this all into a working system you can apply today.

The name of the game is a purely functional typed approach to writing trainable
models using differentiable programming. Be sure to check out [Part
1](https://blog.jle.im/entry/purely-functional-typed-models-1.html) and [Part
2](https://blog.jle.im/entry/purely-functional-typed-models-2.html) if you
haven't, because this is a direct continuation.

My favorite part about this system really is how we have pretty much free reign
over how we can combine and manipulate our models, since they are just
functions. Combinators --- a word I'm going to be using to mean higher-order
functions that return functions --- tie everything together so well. And the
best part is that they're never *necessary*; just *helpful*.

Combinator Fun
--------------

### Recurrence

Here's one example of how the freedom that "normal functions" gives you can help
reveal insight. While working through this approach, I stumbled upon an
interesting way of defining recurrent neural networks --- a lot of times, a
"recurrent neural network" really just means that some function of the
*previous* output is used as an "extra input".

This sounds like we can really write a recurrent model as a "normal" model, and
then use a combinator to feed it back into itself.

To say in types:

``` {.haskell}
recurrently
    :: Model  p   (a :& b) b
    -> ModelS p b  a       b
```

A "normal, non-stateful model" taking an `a :& b` and returning a `b` can really
be turned into a stateful model with state `b` (the *previous output*) and only
taking in an `a` input.

This sort of combinator is a joy to write in Haskell because it's a "follow the
types" kinda deal --- you set up the function, and the compiler pretty much
writes it for you, because the types guide the entire implementation:

``` {.haskell}
-- source: https://github.com/mstksg/inCode/tree/master/code-samples/functional-models/model.hs#L328-L334

recurrently
    :: (Backprop a, Backprop b)
    => Model  p   (a :& b) b
    -> ModelS p b  a       b
recurrently f p x yLast = (y, y)
  where
    y = f p (x #& yLast)
```

In general though, it'd be nice to have *some function* of the previous output
be stored as the state. We can write this combinator as well, taking the
function that transforms the previous output into the stored state:

``` {.haskell}
-- source: https://github.com/mstksg/inCode/tree/master/code-samples/functional-models/model.hs#L336-L343

recurrentlyWith
    :: (Backprop a, Backprop b)
    => (forall z. Reifies z W => BVar z c -> BVar z b)
    -> Model  p   (a :& b) c
    -> ModelS p b  a       c
recurrentlyWith store f p x yLast = (y, store y)
  where
    y = f p (x #& yLast)
```

Again, once we figure out the *type* our combinator has...the function *writes
itself*. The joys of Haskell! I wouldn't dare try to write this in a language
without static types and type inference. But it's a real treat to write this out
in a language like Haskell.

`recurrentlyWith` takes a `c -> b` function and turns a pure model taking an
`a :& b` into a stateful model with state `b` taking in an `a`. The `c -> b`
tells you how to turn the previous output into the new state.

To me, `recurrentlyWith` captures the "essence" of what a recurrent model or
recurrent neural network is --- the network is allowed to "see" some form of its
previous output.

How is this useful? Well, we can use this to define a fully connected recurrent
neural network layer as simply a recurrent version of a normal fully connected
feed-forward layer.

We can redefine a pre-mapped version of `feedForward` which takes a tuple of two
vectors and concatenates them before doing anything:

``` {.haskell}
-- | Concatenate two vectors
(#) :: BVar s (R i) -> BVar s (R o) -> BVar s (R (i + o))
-- source: https://github.com/mstksg/inCode/tree/master/code-samples/functional-models/model.hs#L345-L351

ffOnSplit
    :: forall i o. (KnownNat i, KnownNat o)
    => Model _ (R i :& R o) (R o)
ffOnSplit p rIrO = feedForward @(i + o) p (rI # rO)
  where
    rI = rIrO ^^. t1
    rO = rIrO ^^. t2
```

`ffOnSplit` is a feed-forward layer taking an `R (i + o)`, except we pre-map it
to take a tuple `R i :& R o` instead.

Now our fully connected recurrent layer is just
`recurrentlyWith logistic ffOnSplit`:

``` {.haskell}
fcrnn'
    :: (KnownNat i, KnownNat o)
    => ModelS _ (R o) (R i) (R o)
fcrnn' = recurrentlyWith logistic ffOnSplit
```

Basically just a recurrent version of `feedForward`! If we factor out some of
the manual uncurrying and pre-mapping, we get a nice functional definition:

``` {.haskell}
-- source: https://github.com/mstksg/inCode/tree/master/code-samples/functional-models/model.hs#L353-L356

fcrnn'
    :: (KnownNat i, KnownNat o)
    => ModelS _ (R o) (R i) (R o)
fcrnn' = recurrentlyWith logistic (\p -> feedForward p . uncurryT (#))
```

### Lag

Another interesting result -- we can write a "lagged" combinator that takes a
model expecting a vector as an input, and turn it into a stateful model taking a
*single* input, and feeding the original model that input and also a history of
the `n` most recent inputs.

If that sounds confusing, let's just try to state it out using types:

``` {.haskell}
lagged :: Model  p       (R (n + 1)) b
       -> ModelS p (R n) Double      b
```

The result is a `ModelS p (R n) Double b`; the state is the `n` most recent
inputs, and it feeds that in at every step and keeps it updated. Let's write it
using `headTail` and `&`, which splits a vector and adds an item to the end,
respectively.

``` {.haskell}
-- source: https://github.com/mstksg/inCode/tree/master/code-samples/functional-models/model.hs#L358-L366

lagged
    :: (KnownNat n, 1 <= n)
    => Model  p       (R (n + 1)) b
    -> ModelS p (R n) Double      b
lagged f p x xLasts = (y, xLasts')
  where
    fullLasts    = xLasts & x
    y            = f p fullLasts
    (_, xLasts') = headTail fullLasts
```

What can we do with this? Well... we can write a general autoregressive model
AR(p) of *any* degree, simply by lagging a fully connected ANN layer:

``` {.haskell}
-- source: https://github.com/mstksg/inCode/tree/master/code-samples/functional-models/model.hs#L368-L370

ar :: (KnownNat n, 1 <= n)
   => ModelS _ (R n) Double Double
ar = lagged (\p -> fst . headTail @_ @1 . feedForward p)
```

(using `fst . headTail` to extract the first `Double` from an `R 1`)

And that's it! Our original AR(2) `ar2` is just `ar @2` ... and we can write can
write an AR(10) model by just using `ar @10`, and AR(20) model with `ar @20`,
etc.

``` {.haskell}
-- source: https://github.com/mstksg/inCode/tree/master/code-samples/functional-models/model.hs#L372-L373

ar2' :: ModelS _ (R 2) Double Double
ar2' = ar @2
```

Who would have thought that an autoregressive model is just a fully connected
neural network layer with lag?

Take a fully connected ANN layer and add recurrence --- you get a fully
connected RNN layer. Take a fully connected ANN layer and add lag --- you get an
autoregressive model from statistics!

There are many more such combinators possible! Combinators like
`recurrentlyWith` and `lagged` just scratch the surface. Best of all, they help
reveal to us that seemingly exotic things really are just simple applications of
combinators from other basic things.

::: {.note}
**Aside: Unified Representation**

This is a small aside for those familiar with Haskell techniques like DataKinds
and dependent types!

One ugly thing you might have noticed was that we had to give different "types"
for both our `Model` and `ModelS`, so we cannot re-use useful functions on both.
For example, `mapS` only works on `ModelS`, but not `Model`. `(<~)` only works
on `Model`s, `(<*~*)` only works on two `ModelS`s, and we had to define a
different combinator `(<*~)`.

This is not a fundamental limitation! With *DataKinds* and dependent types we
can unify these both under a common type. If we had:

``` {.haskell}
type Model (p :: Type) (a :: Type) (b :: Type) =
       forall z. Reifies z W
    => BVar z p
    -> BVar z a
    -> BVar z b

type ModelS (p :: Type) (s :: Type) (a :: Type) (b :: Type) =
       forall z. Reifies z W
    => BVar z p
    -> BVar z a
    -> BVar z s
    -> (BVar z b, BVar z s)
```

We can unify them by making either the `p` or `s` be optional, a `Maybe Type`,
and using the `Option` type from
*[Data.Type.Option](https://hackage.haskell.org/package/type-combinators/docs/Data-Type-Option.html)*,
from the
*[type-combinators](https://hackage.haskell.org/package/type-combinators)*
package:

``` {.haskell}
type Model' (p :: Maybe Type) (s :: Maybe Type) (a :: Type) (b :: Type) =
       forall z. Reifies z W
    => Option (BVar z) p
    -> BVar z a
    -> Option (BVar z) s
    -> (BVar z b, Option (BVar z) s)
```

`Option f a` contains a value if `a` is `'Just`, and does not if `a` is
`'Nothing`. More precisely, if `a` is `'Just b`, it will contain an `f b`. So if
`p` is `'Just p'`, an `Option (BVar z) p` will contain a `BVar s p'`.

We can then re-define our previous types:

``` {.haskell}
type Model  p   = Model' ('Just p) 'Nothing
type ModelS p s = Model' ('Just p) ('Just s)
```

And now that we have unified everything under the same type, we can write `mapS`
that takes both stateful and non-stateful models, merge `(<~)`, `(<*~*)` and
`(<*~)`, etc., thanks to the power of dependent types.

As an added benefit, we also can unify parameterless functions too, which are
often useful for composition:

``` {.haskell}
type Func a b = forall z. Reifies z W => BVar z a -> BVar z b
-- or
type Func     = Model' 'Nothing 'Nothing
```

and we can use this with our unified `(<~)` etc. to implement functions like
`mapS` for free.

Note that dependent types and DataKind shenanigans aren't necessary for any of
this to work --- it just has the possibility to make things even more seamless
and unified!
:::

A Practical Framework
---------------------

At the end of it all, I really think that we don't ever "need" a "neural network
library" or a "neural network framework". I don't want to be hemmed into a
specific opaque interface with a compositional API that requires me to learn new
rules of composition or application or clunky object methods.

To be able to utilize this all today, you really only need a few things.

-   A handful of small primitive models expressed as normal functions (like
    `linReg`, `fullyConnected`, `convolution`, `lstm` etc.)

    The number of small primitives might be surprisingly small, given the
    combinators that we are able to write. However, basic fundamental primitives
    are important to be able to jump in and write any model you might need.

-   Some useful higher-order functions acting as utility combinators to common
    patterns of function composition, like `map`, `<~`, etc.

    These are never *required* --- just convenient, since the functional API is
    already fully featured as it is. They are all defined "within the language",
    in that you can always just implement them using normal function application
    and definition.

    Having these handy will make certain workflows simpler, and also help to
    de-duplicate common patterns that come up often.

    With these, models that seem seemingly very different can be defined in
    terms of simple combinator applications of other models, and that simple
    base models can be used to derive other models in surprising ways (like how
    a feed-forward layer can be turned into a recurrent layer or an
    autoregressive model)

-   A handy collection of (differentiable) *loss functions*; in this post, we
    only used squared error, but in other situations there might be other useful
    ones like cross-entropy. Just having common loss functions (and combinators
    to manipulate loss functions) at hand is useful for quick prototyping.

    Loss functions can be combined with regularizing terms from parameters, if
    the regularization functions themselves are differentiable.

-   A handy collection of *optimizers*, allowing you to take a loss function, a
    set of samples, and a model, and return the optimal parameters using
    performant optimizers.

    In this post we only used stochastic gradient descent, but other great
    optimizers out there are also worth having available, like momentum, adam,
    adagrad, etc.

    These optimizers should be easily usable with different data streams for
    observations.

That's really it, I feel! Just the models *as functions*, the combinators, and
methods to evaluate and train those functions. No "objects" defining layers as
data (they're not data, they're functions!); just the full freedom of expressing
a model as any old function you want.[^1]

A Path Forward
--------------

Thank you for making it to the end! I hope at this point you have been able to
gain some appreciation for differential programming in a purely functional
style, and see the sort of doors that this opens.

To tie it all together, I want to restate that a lot of things have to come
together to make this all practical and useful. And, without any one of these,
the whole thing would become clumsy.

1.  **Functional Programming**. Higher-order functions and combinators that take
    functions and return functions. Again, this allows us to draw from
    mathematical models directly, but also full control over how we reshape,
    redefine, manipulate our models.

    We aren't forced to adhere to a limited API provided for our models; it all
    is just normal function application and higher-order functions --- something
    that functional programming is very, very good at dealing with. In addition,
    writing our models as "just functions" means we can re-use functional
    programming staples like `foldl` (left folds) and `mapAccumL`.

    Combinators are powerful --- we saw how many models were just
    "combinator-applied" versions of simpler models.

    Functional programming also forces us to consider state *explicitly*,
    instead of being an implicit part of the runtime. This makes combinators
    like `zeroState`, `unroll`, `recurrently`, and `lagged` possible. Because
    state is not a magic part of the system, it is something that we can
    *explicitly talk about* and *transform*, just as a first-class thing.

2.  **Differentiable Programming**. This should go without saying that nothing
    here would work without our functions all being differentiable. This is what
    allows us to train our models using gradient descent.

    Again, I really don't know if this is best when supported at the
    language/compiler level or at the library level. For this exploration, it is
    done at the library level, and I really don't think it's too bad!

    In any case, I want to emphasize again that functional programming is a
    natural fit for differentiable programming, and the combination of them
    together is what makes this approach very powerful.

3.  **Purely functional programming** is, again, what lets us draw the
    correspondence between mathematical models and the models we describe here.
    And, as seen in the last part, this constraint forces us to consider
    alternatives to implicit state, which ends up yielding very fruitful
    results.

    In impure languages, this is something that we have to always explicitly
    state as a property of our models. Purity is a *benefit*, especially when
    reasoning with stateful models. Tying the state of our models with the
    implicit state functionality of a programming language's runtime system?
    Definitely a recipe for confusion and disaster.

4.  **Strong expressive static type system** with type inference makes this all
    possible to work with at the practical level.

    I couldn't imagine doing any of this without the help of a compiler that
    keeps track of your types for you. Most of our combinators manipulate state
    types of functions, many of them manipulate parameter types, and almost all
    of them manipulate input and output types. Having a compiler that keeps
    track of this for you and lets you ask questions about them is essential.
    The compiler also *helps you write your code* --- it tells you what
    combinators are available to use for what models you have.

    And if you can state your desired model in terms of its types, sometimes the
    combinator applications and functions write themselves. They all act
    together as edges of puzzle pieces; and best of all, the compiler can tell
    you exactly what pieces you have available fit with what you have,
    automatically. Additionally, the process of thinking of types (within the
    language) can guide you in *writing* new combinators.

    This method requires some complex types when you write non-trivial models;
    type inference frees you from the burden of keeping track of your parameter
    and state type, and has the compiler handle the work and the memory for you.
    And, at the end, when you have your finished model, your compiler will
    verify things like providing the right parameter to the right model,
    generating the correct parameter shape, etc.

In the end, this is all something that I'm still actively exploring. In a year
now, my opinions might be very different. However, I've reached a point where I
truly believe the future of differentiable programming and deep learning is
functional, pure, and typed. For me, however, functional, pure, and typed
differentiable programming is *my present*. Its contributions to my
understanding of models and building new models is something that I take
advantage of every day in my own modeling and research. I hope it can be helpful
to you, as well!

[^1]: This is the basis behind my work-in-progress
    [opto](https://github.com/mstksg/opto) and
    [backprop-learn](https://github.com/mstksg/backprop-learn) libraries.
