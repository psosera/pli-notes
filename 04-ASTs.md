~~~haskell
module ASTs where
~~~

Abstract Syntax Trees
=====================

So far, we have seen that one of the cornerstones of typed, functional
programming is algebraic data types.  Furthermore, we have seen that algebraic
data types are excellent at representing tree-like data.  One such data are
programming languages themselves which is the origin of the joke:

    Functional programming languages were created by compiler writers for
    compiler writers to write their compilers with.

We've seen that functional programming languages are useful for much more than
this, but I'd argue that many problems, even though they may not be directly
related to programming languages, are actually compilers in disguise!  Thus, we
will spend some time talking about compilation and programming language
implementation as an exemplar of algebraic data types.

A Brief Introduction to Compilers
---------------------------------

In short, a compiler is a *translator* from one form of data to another.
More practically speaking, compilers transform source code into a final
program via a series of intermediate translations or *passes*.  We call a
collection of such passes a _pipeline_, an example of which is shown below:

~~~
   source code
        |
        | (lexing)
        V
   lexical stream
        |               ---
        | (parsing)    /   \
        V             |     |  Typechecking
   abstract syntax tree     |  Optimization
        |             ^     |  Interpretation
        | (lowering)   \   /
        V               ---
   intermediate rep. (IR) <-
        |               \   \  Optimization
        | (code gen)     ----
        V
   machine code
~~~

Describing this pipeline in more detail:

1.  Our program begins life as source code that we enter into a file. The
    first pass of a compiler is called the _lexer_ which turns our file
    (really, a long string) into a collection of _tokens_ or a
    _lexical stream_. In many languages, tokens constitute logical units of
    text separated by whitespace.
2.  Next, the compiler takes the lexical stream and performs a pass called
    _parsing_ where the linear collection of tokens are turned into a tree-like
    data structure called an _abstract syntax tree_ (AST).  The AST is named as
    such because it captures essential information about the structure of the
    program (_e.g._, an assignment statement) and ignores the inessential parts
    (semicolons at the end of a statement).
3.  Many operations are performed over the AST.  For example, we can optimize
    our program by analyzing the AST and transforming it in different ways. We
    can also take our AST and perform "summary" operations over it such as
    type-checking (producing the "type" of our program if it is well-typed) or
    interpretation (producing the final value resulting from evaluating the
    program).
4.  From the AST, the compiler then _lowers_ the tree into some sort of
    intermediate representation (IR) which sits between the high-level nature
    of the AST and the low-level nature of raw machine code.  Frequently the
    IR is design to help the compiler perform optimizations of different
    sorts.
5.  Finally, from IR, the compiler performs a final pass over and creates
    optimized machine code for a particular computer architecture.
    Alternatively, the compiler may generate *bytecode* which can then be
    interpreted by a virtual machine (really, another sort of compiler). Java
    is the canonical example of compilation to a bytecode language, Java
    Bytecodes, which is then interpreted by the Java Virtual machine.

In a complete compilers course, we would spend our entire time discussing
each of these passes in detail.  However, for our present purposes, we will
explore the compiler operations over the AST of our program.  This gives us
an opportunity to contextualize ASTs and gives us insight into how we might
build new language features and analysis tools.

A Simple Arithmetic Language
----------------------------

Let's begin by defining a simple language of arithmetic expressions:

~~~
e ::= lit | e1 + e2
~~~

We'll define the language with a _grammar_ describing the set of possible
language constructs and the legal ways of forming a program from these
constructs.  A grammar consists of a collection of _productions_ which describe
each of these constructs and the different ways we can form such a construct.

In our arithmetic language above, we have defined a single production,
expressions, which we label with `e`.  The production above says that we can
form an expression by choosing among two _alternatives_.  The first says we any
integer literal is an expression.  The second alternative says that we we can
form an expression by creating two sub-expressions recursively and then join
them together with '+', traditionally denoting addition.

This language definition has a simple definition as an algebraic data type:

~~~haskell
data Exp
  = ELit Int
  | EAdd Exp Exp
  deriving (Eq, Show)
~~~

A production becomes an algebraic data type and each alternative becomes a
constructor to that ADT.  The `deriving` clause below the definition of
`Exp` tells the compiler to automatically generate sensible defaults for
the `(==)` and `show` functions which implement equality between `Exp`s and
"toString" for `Exp`s, respectively.

Here are examples of some arithmetic programs translated into `Exp` values.

~~~haskell
-- 42
e1 = ELit 42
-- 1 + 1
e2 = EAdd (ELit 1) (ELit 1)
-- 1 + (2 + 3)
e3 = EAdd (ELit 1) (EAdd (ELit 2) (ELit 3))
-- (1 + 2) * 3
e4 = EAdd (EAdd (ELit 1) (ELit 2)) (ELit 3)
~~~

Note that precedence is encoded in our AST via its branching structure.  For
example, the AST for `e3` is:

~~~
       +
      / \
     1   +
        / \
       2   3
~~~

Here, we evaluate `2 + 3` first and then add `1`. In contrast, the AST for
`e4` is:

~~~
       +
      / \
     +   3
    / \
   1   2
~~~

Where we evaluate `1 + 2` first and then add `3`. Note that the parentheses
that appeared in the _concrete syntax_ of the language is made implicit by
the tree-like nature of the _abstract syntax tree_.

We can recover the linear nature of the concrete syntax with a pretty-printing
function that takes an `Exp` and produces a fully parenthesized expression
string.

~~~haskell
prettyPrintExp :: Exp -> String
prettyPrintExp (ELit n) = show n
prettyPrintExp (EAdd e1 e2) =
  "(" ++ prettyPrintExp e1 ++ " + " ++ prettyPrintExp e2 ++ ")"
~~~

And here are the results of translating the four simple programs we created
above:

~~~haskell
s1 = prettyPrintExp e1    -- "42"
s2 = prettyPrintExp e2    -- "(1 + 1)"
s3 = prettyPrintExp e3    -- "(1 + (2 + 3))"
s4 = prettyPrintExp e4    -- "((1 + 2) + 3)"
~~~

Interpretation
--------------

Pretty printing is an example of pass over the AST, producing a single string
as a result.  Another example of a pass is _interpretation_ which *evaluates*
the program encoded by the AST down to a final value.  In essence,
interpretation allows us to run programs without actually compiling the program
down to some lower-level representation.  This is convenient when we are
interested in quickly prototyping language features without having to fill out
the full compilation pipeline for each feature we add to the language.

Like pretty printing, interpretation is a straightforward recursive function
over the structure of the ADT:

~~~haskell
interpret :: Exp -> Int
interpret (ELit n) = n
interpret (EAdd e1 e2) = interpret e1 + interpret e2
~~~

Along with examples of running our interpreter over our sample programs:

~~~haskell
i1 = interpret e1   -- 42
i2 = interpret e2   -- 2
i3 = interpret e3   -- 6
i4 = interpret e4   -- 6
~~~

Exercise: Enriching the Arithmetic Language
-------------------------------------------

While our current language is only contains numbers and addition, we've
faithfully covered the essence of representing programs in a compiler along
with operations over that representation, in particular, interpretation.

To get practice with algebraic data types as well as better understand
abstract syntax trees, let's extend the language we defined above with
additional operations and features.

a.  Extend `Exp` with a multiplication operator over integers.  Make sure
    to appropriately extend `prettyPrintExp` and `interpret` as well.

b.  Extend `Exp` with booleans, a comparison operator, and conditionals.
    More specifically, extend the language with the following constructs:

    ~~~
    e ::= ... | true | false | e1 < e2 | if e1 else e2 else e3
    ~~~

    and extend `prettyPrintExp` and `interpret` with these additional
    features.  Make sure to test your extensions by writing down
    expressions that exercise all of these constructs. This will require
    that you change the type of `interpret` to accurately reflect that
    the function will produce either a boolean or integer. You can use am
    algebraic data type to capture this idea!
