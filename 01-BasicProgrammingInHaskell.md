~~~haskell
module BasicProgrammingInHaskell where
~~~

Basic Programming in Haskell
============================

Haskell is an advanced functional programming language created in the 1980s to
consolidate the designs of various functional programming languages that
existed at the time. Today, the language is widely used in academia as a
vehicle for exploring new language features, in particular, advanced type
systems. It is also gaining traction in industry due to its safety guarantees,
vibrant community and constantly-evolving ecosystem.

This file is a _Literate Haskell file_. In a standard Haskell file,
code is interspersed with comments. In contrast, a Literate Haskell file is
text interspersed with code. The text in question is [Markdown](https://www.markdownguide.org/),
a common markup language designed for plaintext entry. Haskell code is enclosed
in _fenced code blocks_ delimited with triple backticks and the `haskell` tag.
You can also run this file directly in `ghci` by using the `markdown-unlit`
package:

1.  First, install the `markdown-unlit` package with `cabal`:

    ~~~shell
    $> cabal update && cabal install markdown-unlit
    ~~~

2.  Next, a technicality: `ghci` will only read files with a `.lhs` extension
    but Github will only render `.md`  files as Markdown! To get around this,
    you will need to create _symbolic links_ to versions of these Markdown
    files but with the `.lhs` extension. The `make-symlinks.sh` script in
    this repository does this for you.

    ~~~shell
    $> ./make-symlinks.sh
    ~~~

3.  Now, you can either run `ghci` with a flag telling it to use `markdown-unlit`
    on the `.lhs` version of the file.

    ~~~shell
    $> ghci -pgmL markdown-unlit 01-BasicProgrammingInHaskell.lhs
    ~~~

    You can also elide the flag if you invoke `ghci` in this repository because
    the `.ghci` file will instruct `ghci` to toggle this flag automatically.

I encourage you not just to read this file but also to load it in `ghci` and
play around with the definitions and exercises. As they say, "programming is
not a spectator sport," so make sure you are getting your practice in!

The Glasgow Haskell Compiler (GHC)
----------------------------------

The main compiler for Haskell (which comes with the Haskell Platform
distribution) is the Glasgow Haskell Compiler—GHC for short. There are two
command-line programs we'll use to interpret and compile our Haskell programs:

+   `ghci`: the GHC interpreter which allows us to load Haskell source files and
    interact with them.
+   `ghc`: the GHC compiler which transform Haskell source files into executable
    programs.

For now, we'll use the GHC interpreter. You can pass Haskell source files to
the interpreter, _e.g._, this source file:

~~~shell
$> ghci 01-BasicProgrammingInHaskell.md.lhs
[1 of 1] Compiling Main             ( 01-BasicProgarmmingInHaskell.md.lhs, interpreted )
Ok, modules loaded: Main.
*BasicProgrammingInHaskell>
~~~

At the `ghci` prompt you can type in Haskell code snippets (later we'll talk
about exactly what syntactic context we're operating in when we're at the
`ghci` prompt) as well as additional `ghci` specific commands. You can get
a list of these commands with the `:help` command:

~~~shell
*BasicProgrammingInHaskell> :help
 Commands available from the prompt:

(Lots and lots of spew)
~~~

Here are a few of the most helpful `ghci` commands that you'll need as you
start out:

+   `:quit` or `:q`: Quits `ghci`.
+   `:load <filename>` or `:l <filename>`: Loads the given Haskell source file.
    The file extension should not be given.
+   `:reload` or `:r`: Reloads the currently loaded file. Very useful for
    incremental editing of a program.
+   `:type <expr>` or `:t <expr>`: Reports the type of the given expression.

Composability in Languages
--------------------------

Composition is the process of putting together components to form a completed
thing. Typically, the set of components that we draw from is small in size, but
carefully chosen to maximize the set of possible things we can build.

In contrast to more traditional languages that possess many language
constructs, functional programming languages emphasize composability at two
levels:

+   **Syntax**: functional programming languages feature a small set of
    language constructs from which we can build our programs.
+   **Libraries**: functional programming languages provide a small set of
    highly reusable library functions that allow us to concisely describe
    solutions to problems.

The upside to having a language that is highly composable is that there isn't
much to memorize in the way of elementary things. The downside is that we'll
need to learn to adopt our problem solving strategies to the compositional style
of programming that Haskell promotes.

Expressions
-----------

Like Racket, Haskell is a functional language. A _functional programming
language_ is one where the predominate way of organizing a program is through
the composition of mathematical functions. The basic building block of a
program in this paradigm is the _expression_ which is simply a programming
construct that evaluates to a value. For example, here are a number of
expressions typed out at the `ghci` prompt:

~~~shell
*BasicProgrammingInHaskell> 3 + 5 / 2
5.5
*BasicProgrammingInHaskell> 1 + 1
2
*BasicProgrammingInHaskell> True
True
*BasicProgrammingInHaskell> True && False
False
*BasicProgrammingInHaskell> 3.5 / 1.9 + 1 * 2
3.8421052631578947
*BasicProgrammingInHaskell> "hello " ++ "world!"
"hello world!"
*BasicProgrammingInHaskell> even 5
False
~~~

`ghci` kindly evaluates expressions that you give it down to their final
`values`. The expression language is somewhat similar to other languages that
you have seen, _e.g._, in Java. One notable exception is that function
invocation or _function application_ is written without parentheses. For
example, the snippet `even 5` is the application of the function `even` to the
argument `5`. If a function takes multiple arguments, then they are separated
by spaces, _e.g._,

~~~shell
*BasicProgrammingInHaskell> mod 4217 5
2
~~~

Here `mod` is equivalent `%` operator found in Java. As a convenience, we can
write any binary function (a function that takes two arguments) as an infix
operator by surrounding the function name in backticks, _e.g._,

~~~shell
*BasicProgrammingInHaskell> 4217 `mod` 5
2
~~~

Dually, we can treat any infix operator as a regular function by surrounding it
in parentheses

~~~shell
*BasicProgrammingInHaskell> (+) 3 5
8
~~~

In Haskell, conditionals are also expressions, _e.g._

~~~shell
*BasicProgrammingInHaskell> if True then 3 else 5
3
*BasicProgrammingInHaskell> 1 + if False then 3 else 5
6
~~~

Finally, if we wanted to embed these expressions into this Haskell file, we
cannot simply type them out as Haskell does not allow bare expressions at the
top level. Instead, we must _bind_ them to a variable, _e.g._, for all of the
expressions we've seen so far:

~~~haskell
e1 = 3 + 5 / 2
e2 = 1 + 1
e3 = True
e4 = True && False
e5 = 3.5 / 1.9 + 1 * 2
e6 = "hello " ++ "world!"
e7 = even 5
~~~

Like other languages, we can use these variables in expressions, build up
expressions in terms of smaller expressions, _etc._

Types
-----

Unlike Racket, Haskell is statically-typed language. This means that every
expression has a type associated with it. This type classifies the value that
the expression eventually evaluates to. As mentioned above, we can use the `:t`
command in `ghci` to have the compiler print the type of an expression for us:

~~~shell
*BasicProgrammingInHaskell> :t e1
e1 :: Double
*BasicProgrammingInHaskell> :t e2
e2 :: Integer
*BasicProgrammingInHaskell> :t e3
e3 :: Bool
*BasicProgrammingInHaskell> :t e4
e4 :: Bool
*BasicProgrammingInHaskell> :t e5
e5 :: Double
*BasicProgrammingInHaskell> :t e6
e6 :: [Char]
*BasicProgrammingInHaskell> :t e7
e7 :: Bool
~~~

Note that the type of a string in Haskell is really a `[Char]` which is a list
of characters.

Being a statically-typed language, Haskell ensures that we don't compose
expressions in such a way that the types don't make sense. For example:

~~~shell
*BasicProgrammingInHaskell> e6
"Hello World!"
*BasicProgrammingInHaskell> 1 + e6

<interactive>:30:3:
    No instance for (Num [Char]) arising from a use of ‘+’
    In the expression: 1 + e6
    In an equation for ‘it’: it = 1 + e6
~~~

We'll get used to reading Haskell's somewhat cryptic error messages as the
course progresses. Here, we can see that by reading the error message from
bottom-to-top Haskell pinpoints the problem to the use of the `+` operator. The
"No instance" part of the error message refers to the fact that a list of
characters (type `[Num]`) cannot be treated as a number which is the error in
the program.

Function types in Haskell are written in a particular way, for example with
`mod`:

~~~shell
*BasicProgrammingInHaskell> :t mod
mod :: Integral a => a -> a -> a
~~~

`mod` has type `Integral a => a -> a -> a`. If we think of the `Integral a`
part as a specification saying "`a` must be an `Integer`", then we can read the
type as `Integer -> Integer -> Integer`. We write the types of arguments of the
function in order followed by the return type, separated by arrows. Thus `mod`
is a two-argument function that takes two `Integer`s and returns an `Integer`.
Likewise, `abs` has type:

~~~shell
*BasicProgrammingInHaskell> :t abs
abs :: Num a => a -> a
~~~

Interpreting `a` as "Number" (either an integer or a floating-point value),
`abs` takes a Number as an argument and produces a Number as a result.

Function Definitions
--------------------

Because we write so many functions in Haskell, function declaration has a very
concise notation. For example, here is the declaration for an increment
function:

~~~haskell
inc1 x = x + 1
~~~

`inc1` is a function that takes an argument, call it `x`, and produces the value
`x + 1`. We can inspect the type of `inc1` with `:t`:

~~~shell
*BasicProgrammingInHaskell> :t inc1
inc1 :: Num a => a -> a
~~~

And find that even though we didn't write a type down, Haskell _inferred_ a
suitable type for it anyways. We can (and should) also write down the type
explicitly before giving the implementation of the function:

~~~haskell
inc2 :: Integer -> Integer
inc2 x = x + 1
~~~

We give multiple arguments to a function by separating them with spaces:

~~~haskell
myAdd :: Integer -> Integer -> Integer
myAdd x y = x + y
~~~

Lists
-----

Functions and basic expressions are pretty standard in Haskell. Things start
getting interesting with _lists_. Recall that a list is a _sequential,
homogeneous, arbitrary-sized_ data type. That is:

1.  The elements of the list have an order,
2.  They all share the same type, and
3.  The list can be as large as we'd like.

We use lists so much in Haskell that the language provides direct syntax for
working with them. To create a list, we can use a _list literal_:

~~~haskell
exampleList1 = [0, 1, 2, 3, 4, 5]
~~~

Alternatively, if we are creating a list that encompasses a range of values, we
can use `..` to have Haskell fill in the values for us:

~~~haskell
exampleList2 = [0 .. 5]       -- [0, 1, 2, 3, 4, 5]
exampleList3 = [1, 3 .. 10]   -- [1, 3, 5, 7, 9]
~~~

Finally, we can use a _list comprehension_ to build a list in such a way we
might specify the elements of a set in mathematical notation:

~~~haskell
exampleList4 = [x + y | x <- [0 .. 5], y <- [0 .. 5]]
~~~

`exampleList4` contains 25 values where the values are drawn from all possible
combinations of sums of values for `x` and `y`.

We can use a list comprehension to _transform_ the elements of a list to another
type or selectively _filter_ the elements of a list. For example, consider
starting with a list of names:

~~~haskell
names :: [String]
names = ["John", "Jane", "Jo", "Janet", "Joss", "Jupiter", "Jimmy", "Jenkins"]
~~~

We can transform this list into a list of the lengths of these strings with the
`length` function along with a comprehension:

~~~haskell
lengthsOfNames :: [Int]
lengthsOfNames = [length n | n <- names]
~~~

Finally, we can find the average length of these names using the `sum` function
and some arithmetic:

~~~haskell
averageLengthOfNames = (sum lengthsOfNames) `div` (length lengthsOfNames)
~~~

Here we need to use the `div` function which performs integral, rather than
fractional division.

If we wanted to only consider all of the names that have odd length, we can add
filter for those names.

~~~haskell
oddLengthNames :: [String]
oddLengthNames = [n | n <- names, odd (length n)]
~~~

For each `n` in `names`, the comprehension keeps that `n` as long as `odd
(length n)` evaluates to `True`.

To work with lists, Haskell provides a number of list manipulation functions in
its standard prelude (the part of the standard library that is automatically
imported for you). Rather than listing them out in detail here, I'll refer you
to the documentation for a complete list:

+   [Prelude: List Operations](https://hackage.haskell.org/package/base-4.15.0.0/docs/Prelude.html#g:13)

Exercises
---------

Here are some exercises to help you put together some of these basic Haskell
programming constructs. In the fragments below, `undefined` is a placeholder
constant in the standard library that throws an exception whenever it is
evaluated. Fill it in with an appropriate function signature and
implementation. Make sure to test out your code in `ghci` as well!

1.  Write a function `cToF` that takes an `Float` that is an amount in Celsius
    and returns a `Float` that is the corresponding temperature in Fahrenheit.

~~~haskell
cToF = undefined
~~~

2.  Write a function `countInRange` that takes a list of `Float`s and two
    additional `Float`s—a `min` and `max` value—and returns the number of
    values in the list that are in the range `min < x < max`. Use this function
    to compute the number of temperature values recorded for New Haven that are
    between 50 and 52 degrees.

~~~haskell
-- Average yearly temperatures for New Haven from 1912--1971
-- http://vincentarelbundock.github.io/Rdatasets/datasets.html
nhtemp = [ 49.9, 52.3, 49.4, 51.1, 49.4, 47.9, 49.8, 50.9, 49.3, 51.9, 50.8
         , 49.6, 49.3, 50.6, 48.4, 50.7, 50.9, 50.6, 51.5, 52.8, 51.8, 51.1
         , 49.8, 50.2, 50.4, 51.6, 51.8, 50.9, 48.8, 51.7, 51, 50.6, 51.7
         , 51.5, 52.1, 51.3, 51, 54, 51.4, 52.7, 53.1, 54.6, 52, 52
         , 50.9, 52.6, 50.2, 52.6, 51.6, 51.9, 50.5, 50.9, 51.7, 51.4, 51.7
         , 50.8, 51.9, 51.8, 51.9, 53 ]

countInRange = undefined
~~~

3.  Recall that tuples are sequential structures that are heterogeneous but
    fixed-size, for example the `exampleTuple` variable below. Write
    a function, assignIndices that takes a string and creates a *list of pairs
    of integers and characters* where the `i`th character is paired with
    integer value `i`.

~~~haskell
exampleTuple :: (Int, Bool, [Char])
exampleTuple = (1, True, "hello")

assignIndices = undefined
~~~

4.  Use `assignIndices` to write a function `pruneEveryOther` that takes a string
    and produces a new string that removes every other character of the string,
    starting with the second.

~~~haskell
pruneEveryOther = undefined
~~~

5.  Write a function `fizzbuzz` that takes an integer `n` and returns a list of
    strings. The ith element of this list should be:
    +    "fizz" if the number is a multiple of 3.
    +    "buzz" if the number is a multiple of 5.
    +    "fizzbuzz" if the number is a multiple of both 3 and 5.
    +    The original number if the number is neither a multiple of 3 nor 5.

~~~haskell
fizzbuzz = undefined
~~~
