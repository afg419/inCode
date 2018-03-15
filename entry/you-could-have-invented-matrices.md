You Could Have Invented Matrices!
=================================

> Originally posted by [Justin Le](https://blog.jle.im/).
> [Read online!](https://blog.jle.im/entry/you-could-have-invented-matrices.html)

You could have invented matrices!

Let's talk about vectors. A **vector** (denoted as
![\\mathbf{x}](https://latex.codecogs.com/png.latex?%5Cmathbf%7Bx%7D "\mathbf{x}"),
a lower-case bold italicized letter) is an element in a **vector space**, which
means that it can be "scaled", like
![c \\mathbf{x}](https://latex.codecogs.com/png.latex?c%20%5Cmathbf%7Bx%7D "c \mathbf{x}")
(the ![c](https://latex.codecogs.com/png.latex?c "c") is called a "scalar" ---
creative name, right?) and added, like
![\\mathbf{x} + \\mathbf{y}](https://latex.codecogs.com/png.latex?%5Cmathbf%7Bx%7D%20%2B%20%5Cmathbf%7By%7D "\mathbf{x} + \mathbf{y}").

In order for vector spaces and their operations to be valid, they just have to
obey some [common-sense
rules](https://en.wikipedia.org/wiki/Vector_space#Definition) (like
associativity, commutativity, distributivity, etc.) that allow us to make
meaningful conclusions.

Dimensionality
--------------

One neat thing about vector spaces is that, in *some* of them, you have the
ability to "decompose" any vector in it as a weighted sum of some set of **basis
vectors**. If this is the case for your vector space, then the size of smallest
possible set of basis vectors is known as the **dimension** of that vector
space.

For example, for a 3-dimensional vector space
![V](https://latex.codecogs.com/png.latex?V "V"), any vector
![\\mathbf{x}](https://latex.codecogs.com/png.latex?%5Cmathbf%7Bx%7D "\mathbf{x}")
can be described as a weighted sum of three basis vectors. If we call them
![\\mathbf{v}\_1](https://latex.codecogs.com/png.latex?%5Cmathbf%7Bv%7D_1 "\mathbf{v}_1"),
![\\mathbf{v}\_2](https://latex.codecogs.com/png.latex?%5Cmathbf%7Bv%7D_2 "\mathbf{v}_2"),
![\\mathbf{v}\_3](https://latex.codecogs.com/png.latex?%5Cmathbf%7Bv%7D_3 "\mathbf{v}_3"),
then:

![
\\mathbf{x} = a \\mathbf{v}\_1 + b \\mathbf{v}\_2 + c \\mathbf{v}\_3
](https://latex.codecogs.com/png.latex?%0A%5Cmathbf%7Bx%7D%20%3D%20a%20%5Cmathbf%7Bv%7D_1%20%2B%20b%20%5Cmathbf%7Bv%7D_2%20%2B%20c%20%5Cmathbf%7Bv%7D_3%0A "
\mathbf{x} = a \mathbf{v}_1 + b \mathbf{v}_2 + c \mathbf{v}_3
")

Where ![a](https://latex.codecogs.com/png.latex?a "a"),
![b](https://latex.codecogs.com/png.latex?b "b"), and
![c](https://latex.codecogs.com/png.latex?c "c") are scalars of
![V](https://latex.codecogs.com/png.latex?V "V").

Dimensionality is really a statement about being able to *decompose* any vector
in that vector space into a combination of a set of basis vectors. For a
3-dimensional vector space, you can make a bases that can reproduce *any* vector
in your space...but that's only possible with at least three vectors. a
4-dimensional vector space, you'd need at least four vectors.

Some examples:

-   In physics, we often treat reality as taking place in a three-dimensional
    vector space. The basis vectors are often called
    ![\\hat{\\mathbf{i}}](https://latex.codecogs.com/png.latex?%5Chat%7B%5Cmathbf%7Bi%7D%7D "\hat{\mathbf{i}}"),
    ![\\hat{\\mathbf{j}}](https://latex.codecogs.com/png.latex?%5Chat%7B%5Cmathbf%7Bj%7D%7D "\hat{\mathbf{j}}"),
    and
    ![\\hat{\\mathbf{k}}](https://latex.codecogs.com/png.latex?%5Chat%7B%5Cmathbf%7Bk%7D%7D "\hat{\mathbf{k}}"),
    and so we say that we can describe our 3D physics vectors as
    ![\\mathbf{r} = r\_x \\hat{\\mathbf{i}} + r\_y \\hat{\\mathbf{j}} + r\_x \\hat{\\mathbf{k}}](https://latex.codecogs.com/png.latex?%5Cmathbf%7Br%7D%20%3D%20r_x%20%5Chat%7B%5Cmathbf%7Bi%7D%7D%20%2B%20r_y%20%5Chat%7B%5Cmathbf%7Bj%7D%7D%20%2B%20r_x%20%5Chat%7B%5Cmathbf%7Bk%7D%7D "\mathbf{r} = r_x \hat{\mathbf{i}} + r_y \hat{\mathbf{j}} + r_x \hat{\mathbf{k}}").

-   The set of all polynomials
    (![5 p\^2 - 3 p + 2](https://latex.codecogs.com/png.latex?5%20p%5E2%20-%203%20p%20%2B%202 "5 p^2 - 3 p + 2"),
    etc.) is an infinite-dimensional vector space, whose scalars are set of
    possible coefficients. Polynomials can be scaled and added together. One
    possible basis are the polynomials
    ![1, p, p\^2, p\^3 \\ldots](https://latex.codecogs.com/png.latex?1%2C%20p%2C%20p%5E2%2C%20p%5E3%20%5Cldots "1, p, p^2, p^3 \ldots"),
    etc.; every other polynomial can be made as a weighted combination of these
    polynomials.

-   N-Tuples of
    ![\\mathbb{R}](https://latex.codecogs.com/png.latex?%5Cmathbb%7BR%7D "\mathbb{R}")
    (ordered sequences of real numbers of a given length) are a vector space
    (denoted as
    ![\\mathbb{R}\^N](https://latex.codecogs.com/png.latex?%5Cmathbb%7BR%7D%5EN "\mathbb{R}^N")),
    and they're one of the more common examples of a vector space with a basis.
    One possible basis for
    ![\\mathbb{R}\^3](https://latex.codecogs.com/png.latex?%5Cmathbb%7BR%7D%5E3 "\mathbb{R}^3")
    is
    ![(1,0,0), (0,1,0), (0,0,1)](https://latex.codecogs.com/png.latex?%281%2C0%2C0%29%2C%20%280%2C1%2C0%29%2C%20%280%2C0%2C1%29 "(1,0,0), (0,1,0), (0,0,1)").
    Any N-tuple of real numbers can be expressed as a weighted sum of these.
    (There are many possible basis sets; another is
    ![(2,0,0), (1,2,1), (-1,0,1)](https://latex.codecogs.com/png.latex?%282%2C0%2C0%29%2C%20%281%2C2%2C1%29%2C%20%28-1%2C0%2C1%29 "(2,0,0), (1,2,1), (-1,0,1)"))

### Encoding

One neat thing that physicists take advantage of all the time is that if we
*agree* on a set of basis vectors and a specific ordering, we can actually
*encode* any vector
![\\mathbf{x}](https://latex.codecogs.com/png.latex?%5Cmathbf%7Bx%7D "\mathbf{x}")
in terms of those basis vectors.

For example:

-   In physics, we can say "Let's encode vectors in terms of sums of scalings of
    ![\\hat{\\mathbf{i}}](https://latex.codecogs.com/png.latex?%5Chat%7B%5Cmathbf%7Bi%7D%7D "\hat{\mathbf{i}}"),
    ![\\hat{\\mathbf{j}}](https://latex.codecogs.com/png.latex?%5Chat%7B%5Cmathbf%7Bj%7D%7D "\hat{\mathbf{j}}"),
    and
    ![\\hat{\\mathbf{k}}](https://latex.codecogs.com/png.latex?%5Chat%7B%5Cmathbf%7Bk%7D%7D "\hat{\mathbf{k}}"),
    in that order." Then, we can *write*
    ![\\mathbf{r}](https://latex.codecogs.com/png.latex?%5Cmathbf%7Br%7D "\mathbf{r}")
    as
    ![\\langle r\_x, r\_y, r\_z \\rangle](https://latex.codecogs.com/png.latex?%5Clangle%20r_x%2C%20r_y%2C%20r_z%20%5Crangle "\langle r_x, r_y, r_z \rangle"),
    and understand that we really mean
    ![\\mathbf{r} = r\_x \\hat{\\mathbf{i}} + r\_y \\hat{\\mathbf{j}} + r\_x \\hat{\\mathbf{k}}](https://latex.codecogs.com/png.latex?%5Cmathbf%7Br%7D%20%3D%20r_x%20%5Chat%7B%5Cmathbf%7Bi%7D%7D%20%2B%20r_y%20%5Chat%7B%5Cmathbf%7Bj%7D%7D%20%2B%20r_x%20%5Chat%7B%5Cmathbf%7Bk%7D%7D "\mathbf{r} = r_x \hat{\mathbf{i}} + r_y \hat{\mathbf{j}} + r_x \hat{\mathbf{k}}").

-   For polynomials, we can say "Let's encode polynomials in terms of sums of
    scalings of ![1](https://latex.codecogs.com/png.latex?1 "1"),
    ![p](https://latex.codecogs.com/png.latex?p "p"),
    ![p\^2](https://latex.codecogs.com/png.latex?p%5E2 "p^2"), etc., in that
    order." Then, we can *write*
    ![\\mathbf{x}](https://latex.codecogs.com/png.latex?%5Cmathbf%7Bx%7D "\mathbf{x}")
    as
    ![\\langle 2, -3, 5, 0, 0, \\ldots \\rangle](https://latex.codecogs.com/png.latex?%5Clangle%202%2C%20-3%2C%205%2C%200%2C%200%2C%20%5Cldots%20%5Crangle "\langle 2, -3, 5, 0, 0, \ldots \rangle"),
    and understand that we really mean
    ![5 p\^2 - 3p + 2](https://latex.codecogs.com/png.latex?5%20p%5E2%20-%203p%20%2B%202 "5 p^2 - 3p + 2").

-   For
    ![\\mathbb{R}\^3](https://latex.codecogs.com/png.latex?%5Cmathbb%7BR%7D%5E3 "\mathbb{R}^3"),
    we can encode the n-tuples in terms of sums of scalings of
    ![(1,0,0)](https://latex.codecogs.com/png.latex?%281%2C0%2C0%29 "(1,0,0)"),
    ![(0,1,0)](https://latex.codecogs.com/png.latex?%280%2C1%2C0%29 "(0,1,0)"),
    and
    ![(0,0,1)](https://latex.codecogs.com/png.latex?%280%2C0%2C1%29 "(0,0,1)").
    Then, we can *write*
    ![\\mathbf{x}](https://latex.codecogs.com/png.latex?%5Cmathbf%7Bx%7D "\mathbf{x}")
    as
    ![\\langle x\_1, x\_2, x\_3 \\rangle](https://latex.codecogs.com/png.latex?%5Clangle%20x_1%2C%20x_2%2C%20x_3%20%5Crangle "\langle x_1, x_2, x_3 \rangle"),
    and understand that we really mean
    ![(x\_1, x\_2, x\_3)](https://latex.codecogs.com/png.latex?%28x_1%2C%20x_2%2C%20x_3%29 "(x_1, x_2, x_3)").

    This is a somewhat of a silly encoding, but it only looks so "trivial"
    because of our choice of bases.

    If we chose a different set of basis vectors for
    ![\\mathbf{R}\^3](https://latex.codecogs.com/png.latex?%5Cmathbf%7BR%7D%5E3 "\mathbf{R}^3"),
    the encoding would not be so trivial!

    For example, if we choose
    ![(2,0,0), (1,2,1), (-1,0,1)](https://latex.codecogs.com/png.latex?%282%2C0%2C0%29%2C%20%281%2C2%2C1%29%2C%20%28-1%2C0%2C1%29 "(2,0,0), (1,2,1), (-1,0,1)")
    as our basis set, when we write
    ![\\langle x\_1, x\_2, x\_3\\rangle](https://latex.codecogs.com/png.latex?%5Clangle%20x_1%2C%20x_2%2C%20x_3%5Crangle "\langle x_1, x_2, x_3\rangle"),
    we really mean:

    ![
    x\_1 (2,0,0) + x\_2 (1,2,1) + x\_3 (-1,0,1)
    ](https://latex.codecogs.com/png.latex?%0Ax_1%20%282%2C0%2C0%29%20%2B%20x_2%20%281%2C2%2C1%29%20%2B%20x_3%20%28-1%2C0%2C1%29%0A "
    x_1 (2,0,0) + x_2 (1,2,1) + x_3 (-1,0,1)
    ")

    In this basis, we can write the tuple
    ![(-8,-6,-2)](https://latex.codecogs.com/png.latex?%28-8%2C-6%2C-2%29 "(-8,-6,-2)")
    as
    ![\\langle -2, -3, 1\\rangle](https://latex.codecogs.com/png.latex?%5Clangle%20-2%2C%20-3%2C%201%5Crangle "\langle -2, -3, 1\rangle"),
    because:

    ![
    (-8,-6,2) = - 2 (2,0,0) - 3 (1, 2, 1) + 1 (-1,0,1)
    ](https://latex.codecogs.com/png.latex?%0A%28-8%2C-6%2C2%29%20%3D%20-%202%20%282%2C0%2C0%29%20-%203%20%281%2C%202%2C%201%29%20%2B%201%20%28-1%2C0%2C1%29%0A "
    (-8,-6,2) = - 2 (2,0,0) - 3 (1, 2, 1) + 1 (-1,0,1)
    ")

It should be made clear that
![\\langle x\_1, x\_2, x\_3 \\rangle](https://latex.codecogs.com/png.latex?%5Clangle%20x_1%2C%20x_2%2C%20x_3%20%5Crangle "\langle x_1, x_2, x_3 \rangle")
is **not** the same thing as the *vector*
![\\mathbf{x}](https://latex.codecogs.com/png.latex?%5Cmathbf%7Bx%7D "\mathbf{x}").
It is *an encoding* of that vector, which only makes sense once we choose to
*agree* on a specific set of basis. If we chose a different basis, we'd have a
different encoding.

In the general case, for an N-dimensional vector space, this means that, with a
minimum of N items, we can represent any vector in that space. And, if we agree
on those N items, we can devise an encoding, such that:

![
\\langle x\_1, x\_2 \\dots x\_N \\rangle
](https://latex.codecogs.com/png.latex?%0A%5Clangle%20x_1%2C%20x_2%20%5Cdots%20x_N%20%5Crangle%0A "
\langle x_1, x_2 \dots x_N \rangle
")

will *encode* the vector:

![
x\_1 \\mathbf{v}\_1 + x\_2 \\mathbf{v}\_2 + \\ldots + x\_N \\mathbf{v}\_N
](https://latex.codecogs.com/png.latex?%0Ax_1%20%5Cmathbf%7Bv%7D_1%20%2B%20x_2%20%5Cmathbf%7Bv%7D_2%20%2B%20%5Cldots%20%2B%20x_N%20%5Cmathbf%7Bv%7D_N%0A "
x_1 \mathbf{v}_1 + x_2 \mathbf{v}_2 + \ldots + x_N \mathbf{v}_N
")

Note that what this encoding represents is *completely dependent* on what
![\\mathbf{v}\_1, \\mathbf{v}\_2 \\ldots \\mathbf{v}\_N](https://latex.codecogs.com/png.latex?%5Cmathbf%7Bv%7D_1%2C%20%5Cmathbf%7Bv%7D_2%20%5Cldots%20%5Cmathbf%7Bv%7D_N "\mathbf{v}_1, \mathbf{v}_2 \ldots \mathbf{v}_N")
we pick, and in what order. The basis vectors we pick are arbitrary, and
determine what our encoding looks like.

To highlight this, note that the same vector
![\\mathbf{x}](https://latex.codecogs.com/png.latex?%5Cmathbf%7Bx%7D "\mathbf{x}")
has many different potential encodings --- all you have to do is pick a
different set of basis vectors, or even just re-arrange or re-scale the ones you
already have. However, all of those encodings correspond go the same vector
![\\mathbf{v}](https://latex.codecogs.com/png.latex?%5Cmathbf%7Bv%7D "\mathbf{v}").
For instance, in the example earlier, we saw an
![\\mathbb{R}\^3](https://latex.codecogs.com/png.latex?%5Cmathbb%7BR%7D%5E3 "\mathbb{R}^3")
vector
![(-8,-6,-2)](https://latex.codecogs.com/png.latex?%28-8%2C-6%2C-2%29 "(-8,-6,-2)")
with two different encodings.

One interesting consequence of this is that any N-dimensional vector space whose
scalars are in
![\\mathbb{R}](https://latex.codecogs.com/png.latex?%5Cmathbb%7BR%7D "\mathbb{R}")
is actually isomorphic to
![\\mathbb{R}\^N](https://latex.codecogs.com/png.latex?%5Cmathbb%7BR%7D%5EN "\mathbb{R}^N")
(the vector space of N-tuples of real numbers). This means that we can basically
treat any N-dimensional vector space with
![\\mathbb{R}](https://latex.codecogs.com/png.latex?%5Cmathbb%7BR%7D "\mathbb{R}")
scalars as if it was
![\\mathbb{R}\^N](https://latex.codecogs.com/png.latex?%5Cmathbb%7BR%7D%5EN "\mathbb{R}^N"),
*once we decide* on the basis vectors. Because of this, we often call *all*
N-dimensional vector spaces (whose scalars are in
![\\mathbb{R}](https://latex.codecogs.com/png.latex?%5Cmathbb%7BR%7D "\mathbb{R}"))
![\\mathbb{R}\^N](https://latex.codecogs.com/png.latex?%5Cmathbb%7BR%7D%5EN "\mathbb{R}^N").
You will often hear physicists saying that the three-dimensional vector spaces
they use are
![\\mathbb{R}\^3](https://latex.codecogs.com/png.latex?%5Cmathbb%7BR%7D%5E3 "\mathbb{R}^3").
However, what they really mean is that their vector spaces is *isomorphic* to
![\\mathbb{R}\^3](https://latex.codecogs.com/png.latex?%5Cmathbb%7BR%7D%5E3 "\mathbb{R}^3").

Linear Transformations
----------------------

Now, one of the most interesting things in mathematics is the idea of the
**linear transformation**. Linear transformations are useful to study because:

1.  They are ubiquitous. They come up everywhere in engineering, physics,
    mathematics, data science, economics, and pretty much any mathematical
    theory. And there are even more situations which can be *approximated* by
    linear transformations.
2.  They are mathematically very nice to work with and study, in practice.

A linear transformation,
![f(\\mathbf{x})](https://latex.codecogs.com/png.latex?f%28%5Cmathbf%7Bx%7D%29 "f(\mathbf{x})"),
is a function that "respects" addition and scaling:

![
\\begin{aligned}
f(c\\mathbf{x}) & = c f(\\mathbf{x}) \\\\
f(\\mathbf{x} + \\mathbf{y}) & = f(\\mathbf{x}) + f(\\mathbf{y})
\\end{aligned}
](https://latex.codecogs.com/png.latex?%0A%5Cbegin%7Baligned%7D%0Af%28c%5Cmathbf%7Bx%7D%29%20%26%20%3D%20c%20f%28%5Cmathbf%7Bx%7D%29%20%5C%5C%0Af%28%5Cmathbf%7Bx%7D%20%2B%20%5Cmathbf%7By%7D%29%20%26%20%3D%20f%28%5Cmathbf%7Bx%7D%29%20%2B%20f%28%5Cmathbf%7By%7D%29%0A%5Cend%7Baligned%7D%0A "
\begin{aligned}
f(c\mathbf{x}) & = c f(\mathbf{x}) \\
f(\mathbf{x} + \mathbf{y}) & = f(\mathbf{x}) + f(\mathbf{y})
\end{aligned}
")

This means that if you scale the input, the output is scaled by the same amount.
And also, if you transform the sum of two things, it's the same as the sum of
the transformed things (it "distributes").

Note that I snuck in vector notation, because the concept of vectors are
*perfectly suited* for studying linear transformations. That's because talking
about linear transformations requires talking about scaling and adding,
and...hey, that's just exactly what vectors have!

From now on, we'll talk about linear transformations specifically on
*N-dimensional vector spaces* (vector spaces that have dimensions and bases we
can use).

Some common examples of linear transformations include:

-   Simply scaling a vector is a linear transformation from vector space to the
    same vector space. Scaling a scaled vector is scaling the scaled vector;
    scaling a sum of vectors is the sum of scaling vectors.
-   Taking the derivative of a polynomial
    ![\\frac{d}{dp](https://latex.codecogs.com/png.latex?%5Cfrac%7Bd%7D%7Bdp "\frac{d}{dp")
    is a linear transformation from the vector space of polynomials to itself:
    the derivative of
    ![5 p\^2 - 3 p + 2](https://latex.codecogs.com/png.latex?5%20p%5E2%20-%203%20p%20%2B%202 "5 p^2 - 3 p + 2")
    w.r.t ![p](https://latex.codecogs.com/png.latex?p "p") is
    ![10 p - 3](https://latex.codecogs.com/png.latex?10%20p%20-%203 "10 p - 3").
    Taking the derivative of a scaled polynomial is the scaled derivative of the
    polynomial; taking the derivative of the sum of two polynomials is the sum
    of the derivatives of the two polynomials.
-   For N-tuples, keeping and dropping certain components are linear
    transformations. For example,
    ![f(x,y,z) = (x,y)](https://latex.codecogs.com/png.latex?f%28x%2Cy%2Cz%29%20%3D%20%28x%2Cy%29 "f(x,y,z) = (x,y)")
    is a linear transformation from the vector space of 3-tuples to the vector
    space of 2-tuples.

### Studying linear transformations

From first glance, a linear transformation's description doesn't look too useful
or analyzable. All you have is
![f(\\mathbf{x})](https://latex.codecogs.com/png.latex?f%28%5Cmathbf%7Bx%7D%29 "f(\mathbf{x})").
It could be anything! Right? Just a black box function?

But, actually, we can exploit its linearity and the fact that we're in a vector
space with a basis to analyze the heck out of any linear transformation, and see
that all of them actually have to follow some specific pattern.

Let's say that
![A(\\mathbf{x})](https://latex.codecogs.com/png.latex?A%28%5Cmathbf%7Bx%7D%29 "A(\mathbf{x})")
is a linear transformation from N-dimensional vector space
![V](https://latex.codecogs.com/png.latex?V "V") to M-dimensional vector space
![U](https://latex.codecogs.com/png.latex?U "U"). That is,
![A : V \\rightarrow U](https://latex.codecogs.com/png.latex?A%20%3A%20V%20%5Crightarrow%20U "A : V \rightarrow U").

Because we know that, once we pick a set of basis vectors
![\\mathbf{v}\_i](https://latex.codecogs.com/png.latex?%5Cmathbf%7Bv%7D_i "\mathbf{v}_i"),
any vector
![\\mathbf{x}](https://latex.codecogs.com/png.latex?%5Cmathbf%7Bx%7D "\mathbf{x}")
in ![V](https://latex.codecogs.com/png.latex?V "V") can be decomposed as
![x\_1 \\mathbf{v}\_1 + x\_2 \\mathbf{v}\_2 + \\ldots x\_n \\mathbf{v}\_N](https://latex.codecogs.com/png.latex?x_1%20%5Cmathbf%7Bv%7D_1%20%2B%20x_2%20%5Cmathbf%7Bv%7D_2%20%2B%20%5Cldots%20x_n%20%5Cmathbf%7Bv%7D_N "x_1 \mathbf{v}_1 + x_2 \mathbf{v}_2 + \ldots x_n \mathbf{v}_N"),
we really can just look at how a transformation
![A](https://latex.codecogs.com/png.latex?A "A") acts on this decomposition. For
example, if ![V](https://latex.codecogs.com/png.latex?V "V") is
three-dimensional:

![
A(\\mathbf{x}) = A(x\_1 \\mathbf{v}\_1 + x\_2 \\mathbf{v}\_2 + x\_3 \\mathbf{v}\_3)
](https://latex.codecogs.com/png.latex?%0AA%28%5Cmathbf%7Bx%7D%29%20%3D%20A%28x_1%20%5Cmathbf%7Bv%7D_1%20%2B%20x_2%20%5Cmathbf%7Bv%7D_2%20%2B%20x_3%20%5Cmathbf%7Bv%7D_3%29%0A "
A(\mathbf{x}) = A(x_1 \mathbf{v}_1 + x_2 \mathbf{v}_2 + x_3 \mathbf{v}_3)
")

Hm. Doesn't seem very insightful, does it?

### A simple definition

But! We can exploit the linearity of
![A](https://latex.codecogs.com/png.latex?A "A") (that it distributes and
scales) to rewrite that as:

![
A(\\mathbf{x}) = x\_1 A(\\mathbf{v}\_1) + x\_2 A(\\mathbf{v}\_2) + x\_3 A(\\mathbf{v}\_3)
](https://latex.codecogs.com/png.latex?%0AA%28%5Cmathbf%7Bx%7D%29%20%3D%20x_1%20A%28%5Cmathbf%7Bv%7D_1%29%20%2B%20x_2%20A%28%5Cmathbf%7Bv%7D_2%29%20%2B%20x_3%20A%28%5Cmathbf%7Bv%7D_3%29%0A "
A(\mathbf{x}) = x_1 A(\mathbf{v}_1) + x_2 A(\mathbf{v}_2) + x_3 A(\mathbf{v}_3)
")

Okay, take a moment to pause and take that all in. This is actually a pretty big
deal! This just means that, to study
![A](https://latex.codecogs.com/png.latex?A "A"), **all you need to study** is
how ![A](https://latex.codecogs.com/png.latex?A "A") acts on our *basis
vectors*. If you know how ![A](https://latex.codecogs.com/png.latex?A "A") acts
on our basis vectors of our vector space, that's really "all there is" about
![A](https://latex.codecogs.com/png.latex?A "A")! Not such a black box anymore!

That is, if I were to ask you, "Hey, what is
![A](https://latex.codecogs.com/png.latex?A "A") like?", *all you'd have to tell
me* is the result of
![A(\\mathbf{v}\_1)](https://latex.codecogs.com/png.latex?A%28%5Cmathbf%7Bv%7D_1%29 "A(\mathbf{v}_1)"),
![A(\\mathbf{v}\_2](https://latex.codecogs.com/png.latex?A%28%5Cmathbf%7Bv%7D_2 "A(\mathbf{v}_2"),
and
![A(\\mathbf{v}\_3)](https://latex.codecogs.com/png.latex?A%28%5Cmathbf%7Bv%7D_3%29 "A(\mathbf{v}_3)").
Just give me those three *vectors*, and we *uniquely determine
![A](https://latex.codecogs.com/png.latex?A "A")*.

To put in another way, *any linear transformation* from a three-dimensional
vector space is uniquely characterized and determined by *three vectors*:
![A(\\mathbf{v}\_1)](https://latex.codecogs.com/png.latex?A%28%5Cmathbf%7Bv%7D_1%29 "A(\mathbf{v}_1)"),
![A(\\mathbf{v}\_2)](https://latex.codecogs.com/png.latex?A%28%5Cmathbf%7Bv%7D_2%29 "A(\mathbf{v}_2)"),
and
![A(\\mathbf{v}\_3)](https://latex.codecogs.com/png.latex?A%28%5Cmathbf%7Bv%7D_3%29 "A(\mathbf{v}_3)").

Those three vectors *completely define*
![A](https://latex.codecogs.com/png.latex?A "A").

In general, we see that *any linear transformation* from an N-dimensional vector
space can be *completely defined* by N vectors: the N results of that
transformation on each of N basis vectors we choose.

For our previous examples:

Looking at the previous example, how does one actually take the derivative of a
polynomial? Well, you really only need to look at the derivative of
![1, p, p\^2, p\^3 \\ldots](https://latex.codecogs.com/png.latex?1%2C%20p%2C%20p%5E2%2C%20p%5E3%20%5Cldots "1, p, p^2, p^3 \ldots"),
etc.; if you know those, then you can compute the derivative of *any*
polynomial. If I told you that
![\\frac{d}{dp} p\^n = n p\^{n - 1}](https://latex.codecogs.com/png.latex?%5Cfrac%7Bd%7D%7Bdp%7D%20p%5En%20%3D%20n%20p%5E%7Bn%20-%201%7D "\frac{d}{dp} p^n = n p^{n - 1}")
(the good ol' trusty [power rule](https://en.wikipedia.org/wiki/Power_rule)),
then you could compute the derivative of any polynomial. This is the essence of
the *[formal derivative](https://en.wikipedia.org/wiki/Formal_derivative)*.

### Enter the Matrix

Okay, so how do we "give"/define/state those N vectors?

Well, recall that the result of
![A(\\mathbf{x})](https://latex.codecogs.com/png.latex?A%28%5Cmathbf%7Bx%7D%29 "A(\mathbf{x})")
and
![A(\\mathbf{v}\_1)](https://latex.codecogs.com/png.latex?A%28%5Cmathbf%7Bv%7D_1%29 "A(\mathbf{v}_1)"),
etc. are *themselves* vectors, in M-dimensional vector space
![U](https://latex.codecogs.com/png.latex?U "U"). Let's say that
![U](https://latex.codecogs.com/png.latex?U "U") is 2-dimensional, for now.

This means that any vector
![\\mathbf{y}](https://latex.codecogs.com/png.latex?%5Cmathbf%7By%7D "\mathbf{y}")
in ![U](https://latex.codecogs.com/png.latex?U "U") can be represented as
![y\_1 \\mathbf{u}\_1 + y\_2 \\mathbf{u}\_2](https://latex.codecogs.com/png.latex?y_1%20%5Cmathbf%7Bu%7D_1%20%2B%20y_2%20%5Cmathbf%7Bu%7D_2 "y_1 \mathbf{u}_1 + y_2 \mathbf{u}_2"),
where
![\\mathbf{u}\_1](https://latex.codecogs.com/png.latex?%5Cmathbf%7Bu%7D_1 "\mathbf{u}_1")
and
![\\mathbf{u}\_2](https://latex.codecogs.com/png.latex?%5Cmathbf%7Bu%7D_2 "\mathbf{u}_2")
is an arbitrary choice of basis vectors.

This means that
![A(\\mathbf{v}\_1)](https://latex.codecogs.com/png.latex?A%28%5Cmathbf%7Bv%7D_1%29 "A(\mathbf{v}_1)")
etc. can also all be represented in terms of these basis vectors. So, laying it
all out:

![
\\begin{aligned}
A(\\mathbf{v}\_1) & = a\_{11} \\mathbf{u}\_1 + a\_{21} \\mathbf{u}\_2 \\\\
A(\\mathbf{v}\_2) & = a\_{12} \\mathbf{u}\_1 + a\_{22} \\mathbf{u}\_2 \\\\
A(\\mathbf{v}\_3) & = a\_{13} \\mathbf{u}\_1 + a\_{23} \\mathbf{u}\_2
\\end{aligned}
](https://latex.codecogs.com/png.latex?%0A%5Cbegin%7Baligned%7D%0AA%28%5Cmathbf%7Bv%7D_1%29%20%26%20%3D%20a_%7B11%7D%20%5Cmathbf%7Bu%7D_1%20%2B%20a_%7B21%7D%20%5Cmathbf%7Bu%7D_2%20%5C%5C%0AA%28%5Cmathbf%7Bv%7D_2%29%20%26%20%3D%20a_%7B12%7D%20%5Cmathbf%7Bu%7D_1%20%2B%20a_%7B22%7D%20%5Cmathbf%7Bu%7D_2%20%5C%5C%0AA%28%5Cmathbf%7Bv%7D_3%29%20%26%20%3D%20a_%7B13%7D%20%5Cmathbf%7Bu%7D_1%20%2B%20a_%7B23%7D%20%5Cmathbf%7Bu%7D_2%0A%5Cend%7Baligned%7D%0A "
\begin{aligned}
A(\mathbf{v}_1) & = a_{11} \mathbf{u}_1 + a_{21} \mathbf{u}_2 \\
A(\mathbf{v}_2) & = a_{12} \mathbf{u}_1 + a_{22} \mathbf{u}_2 \\
A(\mathbf{v}_3) & = a_{13} \mathbf{u}_1 + a_{23} \mathbf{u}_2
\end{aligned}
")

Or, to use our bracket notation from before:

![
\\begin{aligned}
A(\\mathbf{v}\_1) & = \\langle a\_{11}, a\_{21} \\rangle \\\\
A(\\mathbf{v}\_2) & = \\langle a\_{12}, a\_{22} \\rangle \\\\
A(\\mathbf{v}\_3) & = \\langle a\_{13}, a\_{23} \\rangle
\\end{aligned}
](https://latex.codecogs.com/png.latex?%0A%5Cbegin%7Baligned%7D%0AA%28%5Cmathbf%7Bv%7D_1%29%20%26%20%3D%20%5Clangle%20a_%7B11%7D%2C%20a_%7B21%7D%20%5Crangle%20%5C%5C%0AA%28%5Cmathbf%7Bv%7D_2%29%20%26%20%3D%20%5Clangle%20a_%7B12%7D%2C%20a_%7B22%7D%20%5Crangle%20%5C%5C%0AA%28%5Cmathbf%7Bv%7D_3%29%20%26%20%3D%20%5Clangle%20a_%7B13%7D%2C%20a_%7B23%7D%20%5Crangle%0A%5Cend%7Baligned%7D%0A "
\begin{aligned}
A(\mathbf{v}_1) & = \langle a_{11}, a_{21} \rangle \\
A(\mathbf{v}_2) & = \langle a_{12}, a_{22} \rangle \\
A(\mathbf{v}_3) & = \langle a_{13}, a_{23} \rangle
\end{aligned}
")

So, we now see two facts:

1.  A linear transformation from an N dimensional vector space to an M
    dimensional vector space can be *defined* using N vectors.
2.  Each of those N vectors can, themselves, be defined using M scalars each.

Our final conclusion: *any* linear transformation from an N dimensional vector
space to an M dimensional vector space can be completely defined using
![N M](https://latex.codecogs.com/png.latex?N%20M "N M") scalars.

That's right -- *all* possible linear transformations from a 3-dimensional
vector space to a 2-dimensional are parameterized by only *six* scalars! These
six scalars uniquely determine and define our linear transformation, given a set
of basis vectors that we agree on. All linear transformations
![\\mathbb{R}\^3 \\rightarrow \\mathbb{R}\^2](https://latex.codecogs.com/png.latex?%5Cmathbb%7BR%7D%5E3%20%5Crightarrow%20%5Cmathbb%7BR%7D%5E2 "\mathbb{R}^3 \rightarrow \mathbb{R}^2")
can be defined/encoded/expressed with just six real numbers.

These six numbers are pretty important. Just like how we often talk about
3-dimensional vectors in terms of the encoding of their three coefficients, we
often talk about linear transformations from 3-d space to 2-d space in terms of
their six defining coefficients.

We group these things up in something called a *matrix*.

If our linear transformation ![A](https://latex.codecogs.com/png.latex?A "A")
from a 3-dimensional vector space to a 2-dimensional vector space is defined by:

![
\\begin{aligned}
A(\\mathbf{v}\_1) & = a\_{11} \\mathbf{u}\_1 + a\_{21} \\mathbf{u}\_2 \\\\
A(\\mathbf{v}\_2) & = a\_{12} \\mathbf{u}\_1 + a\_{22} \\mathbf{u}\_2 \\\\
A(\\mathbf{v}\_3) & = a\_{13} \\mathbf{u}\_1 + a\_{23} \\mathbf{u}\_2
\\end{aligned}
](https://latex.codecogs.com/png.latex?%0A%5Cbegin%7Baligned%7D%0AA%28%5Cmathbf%7Bv%7D_1%29%20%26%20%3D%20a_%7B11%7D%20%5Cmathbf%7Bu%7D_1%20%2B%20a_%7B21%7D%20%5Cmathbf%7Bu%7D_2%20%5C%5C%0AA%28%5Cmathbf%7Bv%7D_2%29%20%26%20%3D%20a_%7B12%7D%20%5Cmathbf%7Bu%7D_1%20%2B%20a_%7B22%7D%20%5Cmathbf%7Bu%7D_2%20%5C%5C%0AA%28%5Cmathbf%7Bv%7D_3%29%20%26%20%3D%20a_%7B13%7D%20%5Cmathbf%7Bu%7D_1%20%2B%20a_%7B23%7D%20%5Cmathbf%7Bu%7D_2%0A%5Cend%7Baligned%7D%0A "
\begin{aligned}
A(\mathbf{v}_1) & = a_{11} \mathbf{u}_1 + a_{21} \mathbf{u}_2 \\
A(\mathbf{v}_2) & = a_{12} \mathbf{u}_1 + a_{22} \mathbf{u}_2 \\
A(\mathbf{v}_3) & = a_{13} \mathbf{u}_1 + a_{23} \mathbf{u}_2
\end{aligned}
")

(for arbitrary choice of bases
![\\mathbf{v}\_i](https://latex.codecogs.com/png.latex?%5Cmathbf%7Bv%7D_i "\mathbf{v}_i")
and
![\\mathbf{u}\_i](https://latex.codecogs.com/png.latex?%5Cmathbf%7Bu%7D_i "\mathbf{u}_i"))

We "encode" it as the matrix:

![
\\begin{bmatrix}
a\_{11} & a\_{12} & a\_{13} \\\\
a\_{21} & a\_{22} & a\_{23}
\\end{bmatrix}
](https://latex.codecogs.com/png.latex?%0A%5Cbegin%7Bbmatrix%7D%0Aa_%7B11%7D%20%26%20a_%7B12%7D%20%26%20a_%7B13%7D%20%5C%5C%0Aa_%7B21%7D%20%26%20a_%7B22%7D%20%26%20a_%7B23%7D%0A%5Cend%7Bbmatrix%7D%0A "
\begin{bmatrix}
a_{11} & a_{12} & a_{13} \\
a_{21} & a_{22} & a_{23}
\end{bmatrix}
")

And that's why we use matrices in linear algebra -- like how
![\\langle x, y, z \\rangle](https://latex.codecogs.com/png.latex?%5Clangle%20x%2C%20y%2C%20z%20%5Crangle "\langle x, y, z \rangle")
is a convenient way to represent and define a *vector* (once we agree on a
bases), a
![M \\times N](https://latex.codecogs.com/png.latex?M%20%5Ctimes%20N "M \times N")
matrix is a convenient way to represent and define a *linear transformation*
from an N-dimensional vector space to a M-dimensional vector space (once we
agree on the bases in both spaces).

### Examples

For our polynomial example, we said that the derivative
![\\frac{d}{dp}](https://latex.codecogs.com/png.latex?%5Cfrac%7Bd%7D%7Bdp%7D "\frac{d}{dp}")
of a polynomial was a linear transformation. Taking
![1, p, p\^2, p\^3, \\ldots](https://latex.codecogs.com/png.latex?1%2C%20p%2C%20p%5E2%2C%20p%5E3%2C%20%5Cldots "1, p, p^2, p^3, \ldots")
as our basis, we were told that we can just look at
![\\frac{d}{dp} 1](https://latex.codecogs.com/png.latex?%5Cfrac%7Bd%7D%7Bdp%7D%201 "\frac{d}{dp} 1"),
![\\frac{d}{dp} p](https://latex.codecogs.com/png.latex?%5Cfrac%7Bd%7D%7Bdp%7D%20p "\frac{d}{dp} p"),
![\\frac{d}{dp} p\^2](https://latex.codecogs.com/png.latex?%5Cfrac%7Bd%7D%7Bdp%7D%20p%5E2 "\frac{d}{dp} p^2"),
etc.

In that case, we have:

![
\\begin{aligned}
\\frac{d}{dp} 1 & = 0 + 0 p + 0 p\^2 + 0 p\^3 + \\ldots \\\\
\\frac{d}{dp} p & = 1 + 0 p + 0 p\^2 + 0 p\^3 + \\ldots \\\\
\\frac{d}{dp} p\^2 & = 0 + 2 p + 0 p\^2 + 0 p\^3 + \\ldots \\\\
\\frac{d}{dp} p\^3 & = 0 + 0 p + 3 p\^2 + 0 p\^3 + \\ldots \\\\
\\frac{d}{dp} p\^4 & = 0 + 0 p + 0 p\^2 + 4 p\^3 + \\ldots
\\end{aligned}
](https://latex.codecogs.com/png.latex?%0A%5Cbegin%7Baligned%7D%0A%5Cfrac%7Bd%7D%7Bdp%7D%201%20%26%20%3D%200%20%2B%200%20p%20%2B%200%20p%5E2%20%2B%200%20p%5E3%20%2B%20%5Cldots%20%5C%5C%0A%5Cfrac%7Bd%7D%7Bdp%7D%20p%20%26%20%3D%201%20%2B%200%20p%20%2B%200%20p%5E2%20%2B%200%20p%5E3%20%2B%20%5Cldots%20%5C%5C%0A%5Cfrac%7Bd%7D%7Bdp%7D%20p%5E2%20%26%20%3D%200%20%2B%202%20p%20%2B%200%20p%5E2%20%2B%200%20p%5E3%20%2B%20%5Cldots%20%5C%5C%0A%5Cfrac%7Bd%7D%7Bdp%7D%20p%5E3%20%26%20%3D%200%20%2B%200%20p%20%2B%203%20p%5E2%20%2B%200%20p%5E3%20%2B%20%5Cldots%20%5C%5C%0A%5Cfrac%7Bd%7D%7Bdp%7D%20p%5E4%20%26%20%3D%200%20%2B%200%20p%20%2B%200%20p%5E2%20%2B%204%20p%5E3%20%2B%20%5Cldots%0A%5Cend%7Baligned%7D%0A "
\begin{aligned}
\frac{d}{dp} 1 & = 0 + 0 p + 0 p^2 + 0 p^3 + \ldots \\
\frac{d}{dp} p & = 1 + 0 p + 0 p^2 + 0 p^3 + \ldots \\
\frac{d}{dp} p^2 & = 0 + 2 p + 0 p^2 + 0 p^3 + \ldots \\
\frac{d}{dp} p^3 & = 0 + 0 p + 3 p^2 + 0 p^3 + \ldots \\
\frac{d}{dp} p^4 & = 0 + 0 p + 0 p^2 + 4 p^3 + \ldots
\end{aligned}
")

And so, in that
![1, p, p\^2, p\^3, \\ldots](https://latex.codecogs.com/png.latex?1%2C%20p%2C%20p%5E2%2C%20p%5E3%2C%20%5Cldots "1, p, p^2, p^3, \ldots")
basis, the derivative of a polynomial can be represented as the matrix:

![
\\begin{bmatrix}
0 & 1 & 0 & 0 & 0 & \\ldots \\\\
0 & 0 & 2 & 0 & 0 & \\ldots \\\\
0 & 0 & 0 & 3 & 0 & \\ldots \\\\
0 & 0 & 0 & 0 & 4 & \\ldots \\\\
\\vdots & \\vdots & \\vdots & \\vdots & \\vdots & \\ddots
\\end{bmatrix}
](https://latex.codecogs.com/png.latex?%0A%5Cbegin%7Bbmatrix%7D%0A0%20%26%201%20%26%200%20%26%200%20%26%200%20%26%20%5Cldots%20%5C%5C%0A0%20%26%200%20%26%202%20%26%200%20%26%200%20%26%20%5Cldots%20%5C%5C%0A0%20%26%200%20%26%200%20%26%203%20%26%200%20%26%20%5Cldots%20%5C%5C%0A0%20%26%200%20%26%200%20%26%200%20%26%204%20%26%20%5Cldots%20%5C%5C%0A%5Cvdots%20%26%20%5Cvdots%20%26%20%5Cvdots%20%26%20%5Cvdots%20%26%20%5Cvdots%20%26%20%5Cddots%0A%5Cend%7Bbmatrix%7D%0A "
\begin{bmatrix}
0 & 1 & 0 & 0 & 0 & \ldots \\
0 & 0 & 2 & 0 & 0 & \ldots \\
0 & 0 & 0 & 3 & 0 & \ldots \\
0 & 0 & 0 & 0 & 4 & \ldots \\
\vdots & \vdots & \vdots & \vdots & \vdots & \ddots
\end{bmatrix}
")

For our "drop the last component" linear transformation,
![f(x,y,z) = (x,y)](https://latex.codecogs.com/png.latex?f%28x%2Cy%2Cz%29%20%3D%20%28x%2Cy%29 "f(x,y,z) = (x,y)"),
we can interpret things in the
![(1,0,0), (0,1,0), (0,0,1)](https://latex.codecogs.com/png.latex?%281%2C0%2C0%29%2C%20%280%2C1%2C0%29%2C%20%280%2C0%2C1%29 "(1,0,0), (0,1,0), (0,0,1)")
basis in the source space and the
![(1,0), (0,1)](https://latex.codecogs.com/png.latex?%281%2C0%29%2C%20%280%2C1%29 "(1,0), (0,1)")
basis in the target space, and see that:

![
\\begin{aligned}
f(1,0,0) & = (1, 0) & = 1 (1,0) + 0 (0,1) \\\\
f(0,1,0) & = (0, 1) & = 0 (1,0) + 1 (0,1)
f(0,0,1) & = (0, 0) & = 0 (1,0) + 0 (0,1)
\\end{aligned}
](https://latex.codecogs.com/png.latex?%0A%5Cbegin%7Baligned%7D%0Af%281%2C0%2C0%29%20%26%20%3D%20%281%2C%200%29%20%26%20%3D%201%20%281%2C0%29%20%2B%200%20%280%2C1%29%20%5C%5C%0Af%280%2C1%2C0%29%20%26%20%3D%20%280%2C%201%29%20%26%20%3D%200%20%281%2C0%29%20%2B%201%20%280%2C1%29%0Af%280%2C0%2C1%29%20%26%20%3D%20%280%2C%200%29%20%26%20%3D%200%20%281%2C0%29%20%2B%200%20%280%2C1%29%0A%5Cend%7Baligned%7D%0A "
\begin{aligned}
f(1,0,0) & = (1, 0) & = 1 (1,0) + 0 (0,1) \\
f(0,1,0) & = (0, 1) & = 0 (1,0) + 1 (0,1)
f(0,0,1) & = (0, 0) & = 0 (1,0) + 0 (0,1)
\end{aligned}
")

So this is the matrix:

![
\\begin{bmatrix}
1 & 0 & 0 \\\\
0 & 1 & 0
\\end{bmatrix}
](https://latex.codecogs.com/png.latex?%0A%5Cbegin%7Bbmatrix%7D%0A1%20%26%200%20%26%200%20%5C%5C%0A0%20%26%201%20%26%200%0A%5Cend%7Bbmatrix%7D%0A "
\begin{bmatrix}
1 & 0 & 0 \\
0 & 1 & 0
\end{bmatrix}
")

To illustrate that the matrix encoding depends on the choice of basis, let's
switch to the
![(2,0,0), (1,2,1), (-1,0,1)](https://latex.codecogs.com/png.latex?%282%2C0%2C0%29%2C%20%281%2C2%2C1%29%2C%20%28-1%2C0%2C1%29 "(2,0,0), (1,2,1), (-1,0,1)")
in the source space, and the
![(-1,3), (2,2)](https://latex.codecogs.com/png.latex?%28-1%2C3%29%2C%20%282%2C2%29 "(-1,3), (2,2)")
basis in the target space.

In that case, we need only look at:

![
\\begin{aligned}
f( 2, 0, 0) & = ( 2, 0) & = -\\frac{1}{2} (-1,3) + \\frac{3}{4} (2,2) \\\\
f( 1, 2, 1) & = ( 1, 2) & =  \\frac{1}{4} (-1,3) + \\frac{5}{8} (2,2) \\\\
f(-1, 0,-1) & = (-1, 0) & =  \\frac{1}{4} (-1,3) - \\frac{5}{8} (2,2)
\\end{aligned}
](https://latex.codecogs.com/png.latex?%0A%5Cbegin%7Baligned%7D%0Af%28%202%2C%200%2C%200%29%20%26%20%3D%20%28%202%2C%200%29%20%26%20%3D%20-%5Cfrac%7B1%7D%7B2%7D%20%28-1%2C3%29%20%2B%20%5Cfrac%7B3%7D%7B4%7D%20%282%2C2%29%20%5C%5C%0Af%28%201%2C%202%2C%201%29%20%26%20%3D%20%28%201%2C%202%29%20%26%20%3D%20%20%5Cfrac%7B1%7D%7B4%7D%20%28-1%2C3%29%20%2B%20%5Cfrac%7B5%7D%7B8%7D%20%282%2C2%29%20%5C%5C%0Af%28-1%2C%200%2C-1%29%20%26%20%3D%20%28-1%2C%200%29%20%26%20%3D%20%20%5Cfrac%7B1%7D%7B4%7D%20%28-1%2C3%29%20-%20%5Cfrac%7B5%7D%7B8%7D%20%282%2C2%29%0A%5Cend%7Baligned%7D%0A "
\begin{aligned}
f( 2, 0, 0) & = ( 2, 0) & = -\frac{1}{2} (-1,3) + \frac{3}{4} (2,2) \\
f( 1, 2, 1) & = ( 1, 2) & =  \frac{1}{4} (-1,3) + \frac{5}{8} (2,2) \\
f(-1, 0,-1) & = (-1, 0) & =  \frac{1}{4} (-1,3) - \frac{5}{8} (2,2)
\end{aligned}
")

Do verify that
![-\\frac{1}{2} (-1, 3) + \\frac{3}{4} (2, 2)](https://latex.codecogs.com/png.latex?-%5Cfrac%7B1%7D%7B2%7D%20%28-1%2C%203%29%20%2B%20%5Cfrac%7B3%7D%7B4%7D%20%282%2C%202%29 "-\frac{1}{2} (-1, 3) + \frac{3}{4} (2, 2)")
is indeed equal to
![(2,0)](https://latex.codecogs.com/png.latex?%282%2C0%29 "(2,0)")!

Anyway, with these funky basis sets, we can encode the *same* "drop the last
component" linear transformation as:

![
\\begin{bmatrix}
-\\frac{1}{2} & \\frac{1}{4} &  \\frac{1}{4} \\\\
 \\frac{3}{4} & \\frac{5}{8} & -\\frac{5}{8}0
\\end{bmatrix}
](https://latex.codecogs.com/png.latex?%0A%5Cbegin%7Bbmatrix%7D%0A-%5Cfrac%7B1%7D%7B2%7D%20%26%20%5Cfrac%7B1%7D%7B4%7D%20%26%20%20%5Cfrac%7B1%7D%7B4%7D%20%5C%5C%0A%20%5Cfrac%7B3%7D%7B4%7D%20%26%20%5Cfrac%7B5%7D%7B8%7D%20%26%20-%5Cfrac%7B5%7D%7B8%7D0%0A%5Cend%7Bbmatrix%7D%0A "
\begin{bmatrix}
-\frac{1}{2} & \frac{1}{4} &  \frac{1}{4} \\
 \frac{3}{4} & \frac{5}{8} & -\frac{5}{8}0
\end{bmatrix}
")

It's a different numerical matrix, but it represents the same linear
transformation!

Matrix Operations
-----------------

In this light, we can understand the definition of the common matrix operations.

### Matrix-Vector Multiplication

Matrix-vector multiplication is essentially the *decoding* of the linear
transformation that the matrix represents.

Let's look at the
![2 \\times 3](https://latex.codecogs.com/png.latex?2%20%5Ctimes%203 "2 \times 3")
example. Recall that we had:

![
f(\\mathbf{x}) = x\_1 f(\\mathbf{v}\_1) + x\_2 f(\\mathbf{v}\_2) + x\_3 f(\\mathbf{v}\_3)
](https://latex.codecogs.com/png.latex?%0Af%28%5Cmathbf%7Bx%7D%29%20%3D%20x_1%20f%28%5Cmathbf%7Bv%7D_1%29%20%2B%20x_2%20f%28%5Cmathbf%7Bv%7D_2%29%20%2B%20x_3%20f%28%5Cmathbf%7Bv%7D_3%29%0A "
f(\mathbf{x}) = x_1 f(\mathbf{v}_1) + x_2 f(\mathbf{v}_2) + x_3 f(\mathbf{v}_3)
")

And we say that ![A](https://latex.codecogs.com/png.latex?A "A") is completely
defined by:

![
\\begin{aligned}
f(\\mathbf{v}\_1) & = a\_{11} \\mathbf{u}\_1 + a\_{21} \\mathbf{u}\_2 \\\\
f(\\mathbf{v}\_2) & = a\_{12} \\mathbf{u}\_1 + a\_{22} \\mathbf{u}\_2 \\\\
f(\\mathbf{v}\_3) & = a\_{13} \\mathbf{u}\_1 + a\_{23} \\mathbf{u}\_2
\\end{aligned}
](https://latex.codecogs.com/png.latex?%0A%5Cbegin%7Baligned%7D%0Af%28%5Cmathbf%7Bv%7D_1%29%20%26%20%3D%20a_%7B11%7D%20%5Cmathbf%7Bu%7D_1%20%2B%20a_%7B21%7D%20%5Cmathbf%7Bu%7D_2%20%5C%5C%0Af%28%5Cmathbf%7Bv%7D_2%29%20%26%20%3D%20a_%7B12%7D%20%5Cmathbf%7Bu%7D_1%20%2B%20a_%7B22%7D%20%5Cmathbf%7Bu%7D_2%20%5C%5C%0Af%28%5Cmathbf%7Bv%7D_3%29%20%26%20%3D%20a_%7B13%7D%20%5Cmathbf%7Bu%7D_1%20%2B%20a_%7B23%7D%20%5Cmathbf%7Bu%7D_2%0A%5Cend%7Baligned%7D%0A "
\begin{aligned}
f(\mathbf{v}_1) & = a_{11} \mathbf{u}_1 + a_{21} \mathbf{u}_2 \\
f(\mathbf{v}_2) & = a_{12} \mathbf{u}_1 + a_{22} \mathbf{u}_2 \\
f(\mathbf{v}_3) & = a_{13} \mathbf{u}_1 + a_{23} \mathbf{u}_2
\end{aligned}
")

This means that:

![
\\begin{aligned}
f(\\mathbf{x}) & = x\_1 (a\_{11} \\mathbf{u}\_1 + a\_{21} \\mathbf{u}\_2) \\\\
              & + x\_2 (a\_{12} \\mathbf{u}\_1 + a\_{22} \\mathbf{u}\_2) \\\\
              & + x\_3 (a\_{13} \\mathbf{u}\_1 + a\_{23} \\mathbf{u}\_2)
\\end{aligned}
](https://latex.codecogs.com/png.latex?%0A%5Cbegin%7Baligned%7D%0Af%28%5Cmathbf%7Bx%7D%29%20%26%20%3D%20x_1%20%28a_%7B11%7D%20%5Cmathbf%7Bu%7D_1%20%2B%20a_%7B21%7D%20%5Cmathbf%7Bu%7D_2%29%20%5C%5C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%26%20%2B%20x_2%20%28a_%7B12%7D%20%5Cmathbf%7Bu%7D_1%20%2B%20a_%7B22%7D%20%5Cmathbf%7Bu%7D_2%29%20%5C%5C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%26%20%2B%20x_3%20%28a_%7B13%7D%20%5Cmathbf%7Bu%7D_1%20%2B%20a_%7B23%7D%20%5Cmathbf%7Bu%7D_2%29%0A%5Cend%7Baligned%7D%0A "
\begin{aligned}
f(\mathbf{x}) & = x_1 (a_{11} \mathbf{u}_1 + a_{21} \mathbf{u}_2) \\
              & + x_2 (a_{12} \mathbf{u}_1 + a_{22} \mathbf{u}_2) \\
              & + x_3 (a_{13} \mathbf{u}_1 + a_{23} \mathbf{u}_2)
\end{aligned}
")

Which is itself a vector in ![U](https://latex.codecogs.com/png.latex?U "U"), so
let's write this as a combination of its components
![\\mathbf{u}\_1](https://latex.codecogs.com/png.latex?%5Cmathbf%7Bu%7D_1 "\mathbf{u}_1")
and
![\\mathbf{u}\_2](https://latex.codecogs.com/png.latex?%5Cmathbf%7Bu%7D_2 "\mathbf{u}_2"),
by distributing and rearranging terms:

![
\\begin{aligned}
f(\\mathbf{v}) & = (v\_1 a\_{11} + v\_2 a\_{12} + v\_3 a\_{13}) \\mathbf{u}\_1 \\\\
              & + (v\_1 a\_{21} + v\_2 a\_{22} + v\_3 a\_{23}) \\mathbf{u}\_2
\\end{aligned}
](https://latex.codecogs.com/png.latex?%0A%5Cbegin%7Baligned%7D%0Af%28%5Cmathbf%7Bv%7D%29%20%26%20%3D%20%28v_1%20a_%7B11%7D%20%2B%20v_2%20a_%7B12%7D%20%2B%20v_3%20a_%7B13%7D%29%20%5Cmathbf%7Bu%7D_1%20%5C%5C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%26%20%2B%20%28v_1%20a_%7B21%7D%20%2B%20v_2%20a_%7B22%7D%20%2B%20v_3%20a_%7B23%7D%29%20%5Cmathbf%7Bu%7D_2%0A%5Cend%7Baligned%7D%0A "
\begin{aligned}
f(\mathbf{v}) & = (v_1 a_{11} + v_2 a_{12} + v_3 a_{13}) \mathbf{u}_1 \\
              & + (v_1 a_{21} + v_2 a_{22} + v_3 a_{23}) \mathbf{u}_2
\end{aligned}
")

And this is exactly the formula for matrix-vector multiplication!

![
\\begin{bmatrix}
a\_{11} & a\_{12} & a\_{13} \\\\
a\_{21} & a\_{22} & a\_{23}
\\end{bmatrix}
\\begin{bmatrix}
x\_1 \\\\
x\_2 \\\\
x\_3
\\end{bmatrix}
=
\\begin{bmatrix}
x\_1 a\_{11} + x\_2 a\_{12} + x\_3 a\_{13} \\\\
x\_2 a\_{21} + x\_2 a\_{22} + x\_3 a\_{23}
\\end{bmatrix}
](https://latex.codecogs.com/png.latex?%0A%5Cbegin%7Bbmatrix%7D%0Aa_%7B11%7D%20%26%20a_%7B12%7D%20%26%20a_%7B13%7D%20%5C%5C%0Aa_%7B21%7D%20%26%20a_%7B22%7D%20%26%20a_%7B23%7D%0A%5Cend%7Bbmatrix%7D%0A%5Cbegin%7Bbmatrix%7D%0Ax_1%20%5C%5C%0Ax_2%20%5C%5C%0Ax_3%0A%5Cend%7Bbmatrix%7D%0A%3D%0A%5Cbegin%7Bbmatrix%7D%0Ax_1%20a_%7B11%7D%20%2B%20x_2%20a_%7B12%7D%20%2B%20x_3%20a_%7B13%7D%20%5C%5C%0Ax_2%20a_%7B21%7D%20%2B%20x_2%20a_%7B22%7D%20%2B%20x_3%20a_%7B23%7D%0A%5Cend%7Bbmatrix%7D%0A "
\begin{bmatrix}
a_{11} & a_{12} & a_{13} \\
a_{21} & a_{22} & a_{23}
\end{bmatrix}
\begin{bmatrix}
x_1 \\
x_2 \\
x_3
\end{bmatrix}
=
\begin{bmatrix}
x_1 a_{11} + x_2 a_{12} + x_3 a_{13} \\
x_2 a_{21} + x_2 a_{22} + x_3 a_{23}
\end{bmatrix}
")

Again, remember that what we are doing is manipulating *specific encodings* of
our vectors and our linear transformations. Namely, we encode linear
transformations as matrices, and vectors in their component encoding. The reason
we can do these is that we agree upon a set of bases for our source and target
vector spaces, and express these encodings in terms of those.

The magic we get out of this is that we can manipulate things in our "encoding
world", which correspond to things in the "real world".

### Addition of linear transformations

One neat thing about linear transformation is that they "add" well -- you can
add them together by simply applying them both and adding the results. The
result is another linear transformation.

![
(f + g)(\\mathbf{x}) \\equiv f(\\mathbf{x}) + g(\\mathbf{x})
](https://latex.codecogs.com/png.latex?%0A%28f%20%2B%20g%29%28%5Cmathbf%7Bx%7D%29%20%5Cequiv%20f%28%5Cmathbf%7Bx%7D%29%20%2B%20g%28%5Cmathbf%7Bx%7D%29%0A "
(f + g)(\mathbf{x}) \equiv f(\mathbf{x}) + g(\mathbf{x})
")

If
![f : V \\rightarrow U](https://latex.codecogs.com/png.latex?f%20%3A%20V%20%5Crightarrow%20U "f : V \rightarrow U")
and
![g : V \\rightarrow U](https://latex.codecogs.com/png.latex?g%20%3A%20V%20%5Crightarrow%20U "g : V \rightarrow U")
are linear transformations between the *same* vector spaces, then
![f + g : V \\rightarrow U](https://latex.codecogs.com/png.latex?f%20%2B%20g%20%3A%20V%20%5Crightarrow%20U "f + g : V \rightarrow U"),
as we defined it, is also one:

![
\\begin{aligned}
(f + g)(c \\mathbf{x}) & = f(c \\mathbf{x}) + g(c \\mathbf{x}) \\\\
                      & = c f(\\mathbf{x}) + c g(\\mathbf{x}) \\\\
                      & = c ( f(\\mathbf{x}) + g(\\mathbf{x}) ) \\\\
(f + g)(c \\mathbf{x}) & = c (f + g)(\\mathbf{x})
\\end{aligned}
](https://latex.codecogs.com/png.latex?%0A%5Cbegin%7Baligned%7D%0A%28f%20%2B%20g%29%28c%20%5Cmathbf%7Bx%7D%29%20%26%20%3D%20f%28c%20%5Cmathbf%7Bx%7D%29%20%2B%20g%28c%20%5Cmathbf%7Bx%7D%29%20%5C%5C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%26%20%3D%20c%20f%28%5Cmathbf%7Bx%7D%29%20%2B%20c%20g%28%5Cmathbf%7Bx%7D%29%20%5C%5C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%26%20%3D%20c%20%28%20f%28%5Cmathbf%7Bx%7D%29%20%2B%20g%28%5Cmathbf%7Bx%7D%29%20%29%20%5C%5C%0A%28f%20%2B%20g%29%28c%20%5Cmathbf%7Bx%7D%29%20%26%20%3D%20c%20%28f%20%2B%20g%29%28%5Cmathbf%7Bx%7D%29%0A%5Cend%7Baligned%7D%0A "
\begin{aligned}
(f + g)(c \mathbf{x}) & = f(c \mathbf{x}) + g(c \mathbf{x}) \\
                      & = c f(\mathbf{x}) + c g(\mathbf{x}) \\
                      & = c ( f(\mathbf{x}) + g(\mathbf{x}) ) \\
(f + g)(c \mathbf{x}) & = c (f + g)(\mathbf{x})
\end{aligned}
")

(Showing that it respects addition is something you can look at if you want to
have some fun!)

So, if ![f](https://latex.codecogs.com/png.latex?f "f") is encoded as matrix
![\\hat{A}](https://latex.codecogs.com/png.latex?%5Chat%7BA%7D "\hat{A}") for
given bases, and ![g](https://latex.codecogs.com/png.latex?g "g") is encoded as
matrix
![\\hat{B}](https://latex.codecogs.com/png.latex?%5Chat%7BB%7D "\hat{B}"), what
is the encoding of
![f + g](https://latex.codecogs.com/png.latex?f%20%2B%20g "f + g") ?

Let's say that, if ![V](https://latex.codecogs.com/png.latex?V "V") and
![U](https://latex.codecogs.com/png.latex?U "U") are 3-dimensional and
2-dimensional, respectively:

![
\\begin{aligned}
f(\\mathbf{x}) & = (x\_1 a\_{11} + x\_2 a\_{12} + x\_3 a\_{13}) \\mathbf{u}\_1 \\\\
              & + (x\_1 a\_{21} + x\_2 a\_{22} + x\_3 a\_{23}) \\mathbf{u}\_2 \\\\
g(\\mathbf{x}) & = (x\_1 b\_{11} + x\_2 b\_{12} + x\_3 b\_{13}) \\mathbf{u}\_1 \\\\
              & + (x\_1 b\_{21} + x\_2 b\_{22} + x\_3 b\_{23}) \\mathbf{u}\_2
\\end{aligned}
](https://latex.codecogs.com/png.latex?%0A%5Cbegin%7Baligned%7D%0Af%28%5Cmathbf%7Bx%7D%29%20%26%20%3D%20%28x_1%20a_%7B11%7D%20%2B%20x_2%20a_%7B12%7D%20%2B%20x_3%20a_%7B13%7D%29%20%5Cmathbf%7Bu%7D_1%20%5C%5C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%26%20%2B%20%28x_1%20a_%7B21%7D%20%2B%20x_2%20a_%7B22%7D%20%2B%20x_3%20a_%7B23%7D%29%20%5Cmathbf%7Bu%7D_2%20%5C%5C%0Ag%28%5Cmathbf%7Bx%7D%29%20%26%20%3D%20%28x_1%20b_%7B11%7D%20%2B%20x_2%20b_%7B12%7D%20%2B%20x_3%20b_%7B13%7D%29%20%5Cmathbf%7Bu%7D_1%20%5C%5C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%26%20%2B%20%28x_1%20b_%7B21%7D%20%2B%20x_2%20b_%7B22%7D%20%2B%20x_3%20b_%7B23%7D%29%20%5Cmathbf%7Bu%7D_2%0A%5Cend%7Baligned%7D%0A "
\begin{aligned}
f(\mathbf{x}) & = (x_1 a_{11} + x_2 a_{12} + x_3 a_{13}) \mathbf{u}_1 \\
              & + (x_1 a_{21} + x_2 a_{22} + x_3 a_{23}) \mathbf{u}_2 \\
g(\mathbf{x}) & = (x_1 b_{11} + x_2 b_{12} + x_3 b_{13}) \mathbf{u}_1 \\
              & + (x_1 b_{21} + x_2 b_{22} + x_3 b_{23}) \mathbf{u}_2
\end{aligned}
")

Then the breakdown of
![f + g](https://latex.codecogs.com/png.latex?f%20%2B%20g "f + g") is:

![
\\begin{aligned}
(f + g)(\\mathbf{v}) & = (x\_1 a\_{11} + x\_2 a\_{12} + x\_3 a\_{13}) \\mathbf{u}\_1 \\\\
                    & + (x\_1 a\_{21} + x\_2 a\_{22} + x\_3 a\_{23}) \\mathbf{u}\_2 \\\\
                    & + (x\_1 b\_{11} + x\_2 b\_{12} + x\_3 b\_{13}) \\mathbf{u}\_1 \\\\
                    & + (x\_1 b\_{21} + x\_2 b\_{22} + x\_3 b\_{23}) \\mathbf{u}\_2 \\\\
(f + g)(\\mathbf{v}) & = (x\_1 \[a\_{11} + b\_{11}\] + x\_2 \[a\_{12} + b\_{12}\] + x\_3 \[a\_{13} + b\_{13}\]) \\mathbf{u}\_1 \\\\
                    & + (x\_1 \[a\_{21} + b\_{21}\] + x\_2 \[a\_{22} + b\_{22}\] + x\_3 \[a\_{23} + b\_{23}\]) \\mathbf{u}\_2
\\end{aligned}
](https://latex.codecogs.com/png.latex?%0A%5Cbegin%7Baligned%7D%0A%28f%20%2B%20g%29%28%5Cmathbf%7Bv%7D%29%20%26%20%3D%20%28x_1%20a_%7B11%7D%20%2B%20x_2%20a_%7B12%7D%20%2B%20x_3%20a_%7B13%7D%29%20%5Cmathbf%7Bu%7D_1%20%5C%5C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%26%20%2B%20%28x_1%20a_%7B21%7D%20%2B%20x_2%20a_%7B22%7D%20%2B%20x_3%20a_%7B23%7D%29%20%5Cmathbf%7Bu%7D_2%20%5C%5C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%26%20%2B%20%28x_1%20b_%7B11%7D%20%2B%20x_2%20b_%7B12%7D%20%2B%20x_3%20b_%7B13%7D%29%20%5Cmathbf%7Bu%7D_1%20%5C%5C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%26%20%2B%20%28x_1%20b_%7B21%7D%20%2B%20x_2%20b_%7B22%7D%20%2B%20x_3%20b_%7B23%7D%29%20%5Cmathbf%7Bu%7D_2%20%5C%5C%0A%28f%20%2B%20g%29%28%5Cmathbf%7Bv%7D%29%20%26%20%3D%20%28x_1%20%5Ba_%7B11%7D%20%2B%20b_%7B11%7D%5D%20%2B%20x_2%20%5Ba_%7B12%7D%20%2B%20b_%7B12%7D%5D%20%2B%20x_3%20%5Ba_%7B13%7D%20%2B%20b_%7B13%7D%5D%29%20%5Cmathbf%7Bu%7D_1%20%5C%5C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%26%20%2B%20%28x_1%20%5Ba_%7B21%7D%20%2B%20b_%7B21%7D%5D%20%2B%20x_2%20%5Ba_%7B22%7D%20%2B%20b_%7B22%7D%5D%20%2B%20x_3%20%5Ba_%7B23%7D%20%2B%20b_%7B23%7D%5D%29%20%5Cmathbf%7Bu%7D_2%0A%5Cend%7Baligned%7D%0A "
\begin{aligned}
(f + g)(\mathbf{v}) & = (x_1 a_{11} + x_2 a_{12} + x_3 a_{13}) \mathbf{u}_1 \\
                    & + (x_1 a_{21} + x_2 a_{22} + x_3 a_{23}) \mathbf{u}_2 \\
                    & + (x_1 b_{11} + x_2 b_{12} + x_3 b_{13}) \mathbf{u}_1 \\
                    & + (x_1 b_{21} + x_2 b_{22} + x_3 b_{23}) \mathbf{u}_2 \\
(f + g)(\mathbf{v}) & = (x_1 [a_{11} + b_{11}] + x_2 [a_{12} + b_{12}] + x_3 [a_{13} + b_{13}]) \mathbf{u}_1 \\
                    & + (x_1 [a_{21} + b_{21}] + x_2 [a_{22} + b_{22}] + x_3 [a_{23} + b_{23}]) \mathbf{u}_2
\end{aligned}
")

Note that if we say that
![f + g](https://latex.codecogs.com/png.latex?f%20%2B%20g "f + g") is encoded as
matrix
![\\hat{C}](https://latex.codecogs.com/png.latex?%5Chat%7BC%7D "\hat{C}"), and
call the components
![c\_{11}](https://latex.codecogs.com/png.latex?c_%7B11%7D "c_{11}"),
![c\_{12}](https://latex.codecogs.com/png.latex?c_%7B12%7D "c_{12}"), etc., then
we can rewrite that as:

![
\\begin{aligned}
(f + g)(\\mathbf{x}) & = (x\_1 c\_{11} + x\_2 c\_{12} + x\_3 c\_{13}) \\mathbf{u}\_1 \\\\
                    & + (x\_1 c\_{21} + x\_2 c\_{22} + x\_3 c\_{23}) \\mathbf{u}\_2
\\end{aligned}
](https://latex.codecogs.com/png.latex?%0A%5Cbegin%7Baligned%7D%0A%28f%20%2B%20g%29%28%5Cmathbf%7Bx%7D%29%20%26%20%3D%20%28x_1%20c_%7B11%7D%20%2B%20x_2%20c_%7B12%7D%20%2B%20x_3%20c_%7B13%7D%29%20%5Cmathbf%7Bu%7D_1%20%5C%5C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%26%20%2B%20%28x_1%20c_%7B21%7D%20%2B%20x_2%20c_%7B22%7D%20%2B%20x_3%20c_%7B23%7D%29%20%5Cmathbf%7Bu%7D_2%0A%5Cend%7Baligned%7D%0A "
\begin{aligned}
(f + g)(\mathbf{x}) & = (x_1 c_{11} + x_2 c_{12} + x_3 c_{13}) \mathbf{u}_1 \\
                    & + (x_1 c_{21} + x_2 c_{22} + x_3 c_{23}) \mathbf{u}_2
\end{aligned}
")

Where
![c\_{11} = a\_{11} + b\_{11}](https://latex.codecogs.com/png.latex?c_%7B11%7D%20%3D%20a_%7B11%7D%20%2B%20b_%7B11%7D "c_{11} = a_{11} + b_{11}"),
![c\_{12} = a\_{12} + b\_{13}](https://latex.codecogs.com/png.latex?c_%7B12%7D%20%3D%20a_%7B12%7D%20%2B%20b_%7B13%7D "c_{12} = a_{12} + b_{13}"),
etc.

So, if ![\\hat{A}](https://latex.codecogs.com/png.latex?%5Chat%7BA%7D "\hat{A}")
and ![\\hat{B}](https://latex.codecogs.com/png.latex?%5Chat%7BB%7D "\hat{B}")
encode linear transformations ![f](https://latex.codecogs.com/png.latex?f "f")
and ![g](https://latex.codecogs.com/png.latex?g "g"), then we can encode
![f + g](https://latex.codecogs.com/png.latex?f%20%2B%20g "f + g") as matrix
![\\hat{C}](https://latex.codecogs.com/png.latex?%5Chat%7BC%7D "\hat{C}"), where
the components of
![\\hat{C}](https://latex.codecogs.com/png.latex?%5Chat%7BC%7D "\hat{C}") are
just the sum of their corresponding components in
![\\hat{A}](https://latex.codecogs.com/png.latex?%5Chat%7BA%7D "\hat{A}") and
![\\hat{B}](https://latex.codecogs.com/png.latex?%5Chat%7BB%7D "\hat{B}").

And that's why we define
![\\hat{A} + \\hat{B}](https://latex.codecogs.com/png.latex?%5Chat%7BA%7D%20%2B%20%5Chat%7BB%7D "\hat{A} + \hat{B}"),
matrix-matrix addition, as component-wise addition: component-wise addition
perfectly "simulates" the addition of the linear transformation!

What's happening here is we can represent manipulations of the functions
themselves by manipulating *their encodings*.

And, again, the magic here is that, by manipulating things in our "encoding
world", we can make meaningful manipulations in the "real world" of linear
transformations.

![
\\begin{bmatrix}
a\_{11} & a\_{12} & a\_{13} \\\\
a\_{21} & a\_{22} & a\_{23}
\\end{bmatrix}
+
\\begin{bmatrix}
b\_{11} & b\_{12} & b\_{13} \\\\
b\_{21} & b\_{22} & b\_{23}
\\end{bmatrix}
=
\\begin{bmatrix}
a\_{11}+b\_{11} & a\_{12}+b\_{12} & a\_{13}+b\_{13} \\\\
a\_{21}+b\_{21} & a\_{22}+b\_{22} & a\_{23}+b\_{23}
\\end{bmatrix}
](https://latex.codecogs.com/png.latex?%0A%5Cbegin%7Bbmatrix%7D%0Aa_%7B11%7D%20%26%20a_%7B12%7D%20%26%20a_%7B13%7D%20%5C%5C%0Aa_%7B21%7D%20%26%20a_%7B22%7D%20%26%20a_%7B23%7D%0A%5Cend%7Bbmatrix%7D%0A%2B%0A%5Cbegin%7Bbmatrix%7D%0Ab_%7B11%7D%20%26%20b_%7B12%7D%20%26%20b_%7B13%7D%20%5C%5C%0Ab_%7B21%7D%20%26%20b_%7B22%7D%20%26%20b_%7B23%7D%0A%5Cend%7Bbmatrix%7D%0A%3D%0A%5Cbegin%7Bbmatrix%7D%0Aa_%7B11%7D%2Bb_%7B11%7D%20%26%20a_%7B12%7D%2Bb_%7B12%7D%20%26%20a_%7B13%7D%2Bb_%7B13%7D%20%5C%5C%0Aa_%7B21%7D%2Bb_%7B21%7D%20%26%20a_%7B22%7D%2Bb_%7B22%7D%20%26%20a_%7B23%7D%2Bb_%7B23%7D%0A%5Cend%7Bbmatrix%7D%0A "
\begin{bmatrix}
a_{11} & a_{12} & a_{13} \\
a_{21} & a_{22} & a_{23}
\end{bmatrix}
+
\begin{bmatrix}
b_{11} & b_{12} & b_{13} \\
b_{21} & b_{22} & b_{23}
\end{bmatrix}
=
\begin{bmatrix}
a_{11}+b_{11} & a_{12}+b_{12} & a_{13}+b_{13} \\
a_{21}+b_{21} & a_{22}+b_{22} & a_{23}+b_{23}
\end{bmatrix}
")

Symbolically, if we write function application as matrix-vector multiplication,
we say that
![\\hat{A} + \\hat{B}](https://latex.codecogs.com/png.latex?%5Chat%7BA%7D%20%2B%20%5Chat%7BB%7D "\hat{A} + \hat{B}")
is defined so that
![(\\hat{A} + \\hat{B})\\mathbf{x} = \\hat{A} \\mathbf{x} + \\hat{B} \\mathbf{x}](https://latex.codecogs.com/png.latex?%28%5Chat%7BA%7D%20%2B%20%5Chat%7BB%7D%29%5Cmathbf%7Bx%7D%20%3D%20%5Chat%7BA%7D%20%5Cmathbf%7Bx%7D%20%2B%20%5Chat%7BB%7D%20%5Cmathbf%7Bx%7D "(\hat{A} + \hat{B})\mathbf{x} = \hat{A} \mathbf{x} + \hat{B} \mathbf{x}").

### Multiplication of linear transformations

We might be tempted to define *multiplication* of linear transformations the
same way. However, this doesn't quite make sense.

Remember that we talked about adding linear transformations as the addition of
their results. However, we can't talk about multiplying linear transformations
as the multiplication of their results because the idea of a vector space
doesn't come with any notion of multiplication.

However, even if we talk specifically about linear transformations to *scalars*,
this still doesn't quite work:

![
\\begin{aligned}
(f \* g)(c \\mathbf{x}) & = f(c \\mathbf{x}) \* g(c \\mathbf{x}) \\\\
                      & = c f(\\mathbf{x}) \* c g(\\mathbf{x}) \\\\
                      & = c\^2 ( f(\\mathbf{x}) \* g(\\mathbf{x}) ) \\\\
(f \* g)(c \\mathbf{x}) & = c\^2 (f \* g)(\\mathbf{x})
\\end{aligned}
](https://latex.codecogs.com/png.latex?%0A%5Cbegin%7Baligned%7D%0A%28f%20%2A%20g%29%28c%20%5Cmathbf%7Bx%7D%29%20%26%20%3D%20f%28c%20%5Cmathbf%7Bx%7D%29%20%2A%20g%28c%20%5Cmathbf%7Bx%7D%29%20%5C%5C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%26%20%3D%20c%20f%28%5Cmathbf%7Bx%7D%29%20%2A%20c%20g%28%5Cmathbf%7Bx%7D%29%20%5C%5C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%26%20%3D%20c%5E2%20%28%20f%28%5Cmathbf%7Bx%7D%29%20%2A%20g%28%5Cmathbf%7Bx%7D%29%20%29%20%5C%5C%0A%28f%20%2A%20g%29%28c%20%5Cmathbf%7Bx%7D%29%20%26%20%3D%20c%5E2%20%28f%20%2A%20g%29%28%5Cmathbf%7Bx%7D%29%0A%5Cend%7Baligned%7D%0A "
\begin{aligned}
(f * g)(c \mathbf{x}) & = f(c \mathbf{x}) * g(c \mathbf{x}) \\
                      & = c f(\mathbf{x}) * c g(\mathbf{x}) \\
                      & = c^2 ( f(\mathbf{x}) * g(\mathbf{x}) ) \\
(f * g)(c \mathbf{x}) & = c^2 (f * g)(\mathbf{x})
\end{aligned}
")

That's right,
![f \* g](https://latex.codecogs.com/png.latex?f%20%2A%20g "f * g"), defined
point-wise, does *not* yield a linear transformation.

So, *there is no matrix* that could would even represent or encode
![f \* g](https://latex.codecogs.com/png.latex?f%20%2A%20g "f * g"), as we
defined it. So, since
![f \* g](https://latex.codecogs.com/png.latex?f%20%2A%20g "f * g") isn't even
representable as a matrix in our encoding scheme, it doesn't make sense to treat
it as a matrix operation.

### Composition of linear transformations

Since linear transformations are functions, we can compose them:

![
(f \\circ g)(\\mathbf{x}) \\equiv f(g(\\mathbf{x}))
](https://latex.codecogs.com/png.latex?%0A%28f%20%5Ccirc%20g%29%28%5Cmathbf%7Bx%7D%29%20%5Cequiv%20f%28g%28%5Cmathbf%7Bx%7D%29%29%0A "
(f \circ g)(\mathbf{x}) \equiv f(g(\mathbf{x}))
")

Is the composition of linear transformations also a linear transformation?

![
\\begin{aligned}
(f \\circ g)(c \\mathbf{x}) & = f(g(c \\mathbf{x})) \\\\
                      & = f(c g(\\mathbf{x})) \\\\
                      & = c f(g(\\mathbf{x})) \\\\
(f \\circ g)(c \\mathbf{x}) & = c (f \\circ g)(\\mathbf{x})
\\end{aligned}
](https://latex.codecogs.com/png.latex?%0A%5Cbegin%7Baligned%7D%0A%28f%20%5Ccirc%20g%29%28c%20%5Cmathbf%7Bx%7D%29%20%26%20%3D%20f%28g%28c%20%5Cmathbf%7Bx%7D%29%29%20%5C%5C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%26%20%3D%20f%28c%20g%28%5Cmathbf%7Bx%7D%29%29%20%5C%5C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%26%20%3D%20c%20f%28g%28%5Cmathbf%7Bx%7D%29%29%20%5C%5C%0A%28f%20%5Ccirc%20g%29%28c%20%5Cmathbf%7Bx%7D%29%20%26%20%3D%20c%20%28f%20%5Ccirc%20g%29%28%5Cmathbf%7Bx%7D%29%0A%5Cend%7Baligned%7D%0A "
\begin{aligned}
(f \circ g)(c \mathbf{x}) & = f(g(c \mathbf{x})) \\
                      & = f(c g(\mathbf{x})) \\
                      & = c f(g(\mathbf{x})) \\
(f \circ g)(c \mathbf{x}) & = c (f \circ g)(\mathbf{x})
\end{aligned}
")

Yes! (Well, once you prove that it respects addition. I'll leave the fun to
you!)

Okay, so we know that
![f \\circ g](https://latex.codecogs.com/png.latex?f%20%5Ccirc%20g "f \circ g")
is indeed a linear transformation. That means that it can *also* be encoded as a
matrix.

So, let's say that
![f : U \\rightarrow W](https://latex.codecogs.com/png.latex?f%20%3A%20U%20%5Crightarrow%20W "f : U \rightarrow W"),
then
![g : V \\rightarrow U](https://latex.codecogs.com/png.latex?g%20%3A%20V%20%5Crightarrow%20U "g : V \rightarrow U").
![f](https://latex.codecogs.com/png.latex?f "f") is a linear transformation from
![U](https://latex.codecogs.com/png.latex?U "U") to
![W](https://latex.codecogs.com/png.latex?W "W"), and
![g](https://latex.codecogs.com/png.latex?g "g") is a linear transformation from
![V](https://latex.codecogs.com/png.latex?V "V") to
![U](https://latex.codecogs.com/png.latex?U "U"). That means that
![f \\circ g : V \\rightarrow W](https://latex.codecogs.com/png.latex?f%20%5Ccirc%20g%20%3A%20V%20%5Crightarrow%20W "f \circ g : V \rightarrow W")
is a linear transformation from ![V](https://latex.codecogs.com/png.latex?V "V")
to ![W](https://latex.codecogs.com/png.latex?W "W").

Let's say that ![V](https://latex.codecogs.com/png.latex?V "V") is
3-dimensional, ![U](https://latex.codecogs.com/png.latex?U "U") is
2-dimensional, and ![W](https://latex.codecogs.com/png.latex?W "W") is
4-dimensional.

If ![f](https://latex.codecogs.com/png.latex?f "f") is encoded by the
![4 \\times 2](https://latex.codecogs.com/png.latex?4%20%5Ctimes%202 "4 \times 2")
matrix
![\\hat{A}](https://latex.codecogs.com/png.latex?%5Chat%7BA%7D "\hat{A}"), and
![g](https://latex.codecogs.com/png.latex?g "g") is encoded by
![2 \\times 3](https://latex.codecogs.com/png.latex?2%20%5Ctimes%203 "2 \times 3")
matrix
![\\hat{B}](https://latex.codecogs.com/png.latex?%5Chat%7BB%7D "\hat{B}"), then
we can represent
![f \\circ g](https://latex.codecogs.com/png.latex?f%20%5Ccirc%20g "f \circ g")
as the
![4 \\times 3](https://latex.codecogs.com/png.latex?4%20%5Ctimes%203 "4 \times 3")
matrix
![\\hat{C}](https://latex.codecogs.com/png.latex?%5Chat%7BC%7D "\hat{C}").

If you've taken a linear algebra class, you might recognize this pattern.
Combining a
![4 \\times 2](https://latex.codecogs.com/png.latex?4%20%5Ctimes%202 "4 \times 2")
and a
![2 \\times 3](https://latex.codecogs.com/png.latex?2%20%5Ctimes%203 "2 \times 3")
to make a
![4 \\times 3](https://latex.codecogs.com/png.latex?4%20%5Ctimes%203 "4 \times 3")
?

We *can* compute
![\\hat{C}](https://latex.codecogs.com/png.latex?%5Chat%7BC%7D "\hat{C}") using
only the encodings
![\\hat{A}](https://latex.codecogs.com/png.latex?%5Chat%7BA%7D "\hat{A}") and
![\\hat{B}](https://latex.codecogs.com/png.latex?%5Chat%7BB%7D "\hat{B}")! We
call this **matrix multiplication**. It's typically denoted as
![\\hat{C} = \\hat{A} \\hat{B}](https://latex.codecogs.com/png.latex?%5Chat%7BC%7D%20%3D%20%5Chat%7BA%7D%20%5Chat%7BB%7D "\hat{C} = \hat{A} \hat{B}").

That's exactly what *matrix multiplication* is defined as. If:

-   ![\\hat{A}](https://latex.codecogs.com/png.latex?%5Chat%7BA%7D "\hat{A}") is
    a
    ![O \\times M](https://latex.codecogs.com/png.latex?O%20%5Ctimes%20M "O \times M")
    matrix representing a linear transformation from a M-dimensional space to an
    O-dimensional space
-   ![\\hat{B}](https://latex.codecogs.com/png.latex?%5Chat%7BB%7D "\hat{B}") is
    an
    ![M \\times N](https://latex.codecogs.com/png.latex?M%20%5Ctimes%20N "M \times N")
    matrix representing a linear transformation from an N-dimensional space to
    an M-dimensional space

Then:

-   ![\\hat{C} = \\hat{A}\\hat{B}](https://latex.codecogs.com/png.latex?%5Chat%7BC%7D%20%3D%20%5Chat%7BA%7D%5Chat%7BB%7D "\hat{C} = \hat{A}\hat{B}")
    is a
    ![O \\times N](https://latex.codecogs.com/png.latex?O%20%5Ctimes%20N "O \times N")
    matrix representing a linear transformation from an N-dimensional space to
    an O-dimensional space.

Again -- manipulation of our *encodings* can manifest the manipulation in the
*linear transformations* that we want.

Symbolically, if we treat function application as matrix-vector multiplication,
this means that
![\\hat{A}\\hat{B}](https://latex.codecogs.com/png.latex?%5Chat%7BA%7D%5Chat%7BB%7D "\hat{A}\hat{B}")
is defined such that
![(\\hat{A}\\hat{B})\\mathbf{x} = \\hat{A}(\\hat{B}\\mathbf{x})](https://latex.codecogs.com/png.latex?%28%5Chat%7BA%7D%5Chat%7BB%7D%29%5Cmathbf%7Bx%7D%20%3D%20%5Chat%7BA%7D%28%5Chat%7BB%7D%5Cmathbf%7Bx%7D%29 "(\hat{A}\hat{B})\mathbf{x} = \hat{A}(\hat{B}\mathbf{x})").

In that notation, it kinda looks like the associativity of multiplication,
doesn't it? Don't be fooled!
![\\hat{A} \\hat{B}](https://latex.codecogs.com/png.latex?%5Chat%7BA%7D%20%5Chat%7BB%7D "\hat{A} \hat{B}"),
matrix-matrix multiplication, is a completely different type of operation than
![\\hat{B}\\mathbf{v}](https://latex.codecogs.com/png.latex?%5Chat%7BB%7D%5Cmathbf%7Bv%7D "\hat{B}\mathbf{v}").
One is the symbolic manipulation on *two encodings* of of a linear
transformation, and the other is an *application* of an encoding of a linear
transformation on encoding of a vector.

If you're familiar with Haskell idioms, matrix-matrix multiplication is like `.`
(function composition), and matrix-vector multiplication is like `$`, or
function application. One is a "higher order function": taking two functions (at
least, the encodings of them) and returning a new function. The other is an
application of a function to its input.

And, like in Haskell:

``` {.haskell}
(f . g) x = f (g x)
```

We won't go over the actual process of computing the matrix-matrix product, but
it's something that you can work out just in terms of the definitions of the
encodings. Just manually apply out everything and group together common factors
of the basis vectors of the destination space.

The Big Picture
---------------

At the highest level here, what we're doing is taking a *function* and encoding
it as *data* -- a parameterization of that function. Essentially, we take the
properties of the type of functions we are looking at and find out that it can
be defined/represented in a limited number of parameters

Then, the breakthrough is that we look at useful higher-order functions and
manipulations of those transformations. Then, we see how we can implement those
*transformations* by symbolically manipulating the *encodings*!

This is actually a dance we do all the time in programming. Instead of working
with functions, we work with reified data that represent those functions. And,
instead of direct higher order functions, we transform that data in a way that
makes it encodes the function we want to produce.

Matrices are exactly that. Linear transformations are the functions we want to
analyze, and we realize that we can completely specify/define any linear
transformation with a matrix (against a choice of bases).

Then, we realize that there are some nice manipulations we can do on linear
transformations; we can combine them to create new linear transformations in
useful ways.

However, because those manipulations all produce *new* linear transformations,
we know that their results can all be encoded in *new* matrices. So, we see if
we can just directly apply those manipulations by directly working on those
matrices!

I hope this post serves to demystify matrices, matrix addition, and
multiplication for you, and help you see why they are defined the way that they
are. Furthermore, I hope that it gives some insight on why matrices are useful
in linear algebra, and also how similar encodings can help you with manipulating
other types of functions!