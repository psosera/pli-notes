~~~haskell
module ListProgramming where
~~~

List Programming
================

Previously, we reviewed basic programming in Haskell–expressions and functions.
Over the next two days, we'll review the main programming technique used in any
functional programming: recursion.  Because functional programming languages,
especially a pure one like Haskell, discourages mutable variables, we must use
recursion to get work done.  This is convenient because many algorithms are
concisely expressed using recursion.

A Brief Note on Polymorphic Types
---------------------------------

In Java, we use parametric polymorphism, _i.e._, generics to make types that are
parameterizable by other types.  Haskell provides very lightweight syntax for
using polymorphic types.  The type of the standard `length` function over lists
is written `[a] -> Int`.  The type of a list of, _e.g._, integers is written
`[Int]`.

The length function does not care what the _carrier_ type of the list is,
_i.e._, the type of elements that the list holds.  We denote this fact by
introducing a _type variable_ into the type.  In fact, Haskell will interpreter
any identifier in a type that is not an actual declared type as a type variable,
so you can write the following implementation of the polymorphic identity
function:

~~~haskell
myId :: wee -> wee
myId x = x
~~~

Where the `wee` in the type is a type variable.  As a matter of style, however,
we usually reserve single letter names for polymorphic types, _e.g._, `a`, `b`,
and `m`.

Functions and Pattern Matching
------------------------------

We learned that conditionals are part of the expression language.  We can
combine conditionals and equality to write recursive functions over lists,
_e.g_., a function that computes the length of a list:

~~~haskell
myLength :: (Eq a) => [a] -> Int
myLength l = if l == [] then 0 else 1 + myLength (tail l)
~~~

Note that `myLength`'s type signature puts a _type class constraint_ on the
polymorphic variable `a` because we use equality `(==)` over lists which in turn
requires that the `a` implements the `Eq` type class (which provides the `(==)`
function).

This translation of how we recursively compute the length of a list in Racket
into Haskell is not incorrect, but it is not how we would actually write down
this recursive function.  Rather than using equality and the `tail` function, we
use a powerful programming construct known as _pattern matching_ to get the
job done:

~~~haskell
myLength' :: [a] -> Int
myLength' []     = 0
myLength' (x:xs) = 1 + myLength' xs
~~~

You can think of a pattern match as a conditional on the _structure_ of
a particular data type.  Here, we are breaking up the definition of `myLength'`
(note the apostrophe!) into two cases: when the input list is empty (`[]`) and
when the input list is non-empty written using the cons operator (`x:xs`).
Execution of the function proceeds by first determining which of the two
patterns match the given input, _e.g._,

~~~haskell
v1 = myLength' []         -- Evaluates to the first condition and produces 0
v2 = myLength' [1, 2, 3]  -- Evaluates to the second condition, eventually producing 3
~~~

In the second condition, `x` and `xs` are _pattern variables_ which are bound
to the appropriate components of the input list.  For example, we can view the
list `[1, 2, 3]` as a sequence of cons operations `1 : (2 : 3 : [])` so `x`
becomes bound to `1` and `xs` to `2 : 3 : []` or `[2, 3]`.

Finally, note that `myLength'` does not require a type class constraint on the
carrier type of list.  This is because we are not actually using the `==`
operator.  Instead, Haskell looks directly at the _shape_ of a list to
determine which condition of the function to evaluate.  This notion of breaking
down a value by its possible shapes is the cornerstone of a language feature
we'll discuss next week: algebraic data types.

Guards
------

Pattern matching forms a way to condition the behavior of a function.  It works
over the structure of values, however, we are unable to condition on arbitrary
behavior of a pattern, _e.g._, testing if an integer is greater than 0.

Haskell provides special syntax, called _guards_, to capture arbitrary
conditions on function alternatives.  For example, here is a Haskell
implementation of the [Ackermann function](https://en.wikipedia.org/wiki/Ackermann_function):

~~~Haskell
ack :: Int -> Int -> Int
ack m n | m == 0          = n + 1
        | m > 0 && n == 0 = ack (m-1) 1
        | otherwise       = ack (m-1) (ack m (n-1))
~~~

Guards are simply boolean conditions that are tested to see if a particular
function alternative are chosen.  This is really equivalent to an top-level
if-expression in the function body, but is arguably much more readable.  Compare
the `ack` function definition to its formal description on Wikipedia.

Exercises
---------

Fill in the definition of each of the functions below.  For the type signatures
of each of the functions, use the most general type possible (read: use
polymorphic types and type class constraints whenever possible).

1.  Write a function `myAll` that takes list of booleans as input and returns
    true iff the list only contains `True` values.

~~~haskell
all = undefined
~~~

2.  Write a function `append` that takes two lists (of the same type) as input
    and returns a new list that is the result of appending the second list onto
    the end of the first.

~~~haskell
append = undefined
~~~

3.  Write a function `contains` that takes an element and a list and returns
    `True` iff the element is in the list.  (_Hint_: what type class constraint
    do you need on the elements of the list to ensure you can compare them for
    equality?).

~~~haskell
contains = undefined
~~~

4.  Write a function `snoc` that takes an element and a list and appends that
    element _onto the end of the list_.

~~~haskell
snoc = undefined
~~~

5.  Write a function `rev` that takes a list and returns a reversed version of
    that list.  (_Hint_: can you use a previous function to do this?)

~~~haskell
rev = undefined
~~~
