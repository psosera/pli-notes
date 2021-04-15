Programming Language Implementation Self-Study Notes
====================================================

# Getting Started

*   [Haskell](https://www.haskell.org/downloads/)
    +   _Haskell Platform_ is reasonable for a no-fuss setup.
    +   _Ghcup_ is good for a minimal installation.
    +   Eventually you'll want to consider _Stack_ for Haskell projects.
    +   [Repl.it](https://replit.com/languages/haskell) is good as a one-off
        testing.
*   Development Environment
    +   Terminal-based editing
        -   Emacs/Vim/pick-your-poison and [Ghcid](https://github.com/ndmitchell/ghcid)
    +   [Visual Studio Code](https://code.visualstudio.com/) with the
        [Haskell](https://marketplace.visualstudio.com/items?itemName=haskell.haskell)
        extension is a good compromise between flexible term-based environments
        and a usable GUI.
*   [Learning Resources](https://www.haskell.org/documentation/)
    +   Free courses
        -   [CIS 194 @ UPenn](https://www.seas.upenn.edu/~cis194/fall16/)
        -   [CSCI 360 @ Hendrix College](http://ozark.hendrix.edu/~yorgey/360/f16/)
    +   Free books
        -   [Learn You a Haskell for Great Good!](http://learnyouahaskell.com/)
        -   [Real World Haskell](http://book.realworldhaskell.org/read/)

# Recommended Topic Progression

(_Note_: this is the general progression PM uses for his courses that introduce
Haskell, splashed with compilers/interpreter topics.)

1.  Functional programming in Haskell
    +   Expressions and types
    +   Basic datatypes and operations
    +   Higher-order functions
    +   Recursion over lists

2.  Algebraic datatypes
    +   Generalized recursion over ADTs
    +   Common ADTs, e.g., Maybe

3.  Abstract syntax trees and interpretation
    +   The compilation pipeline
    +   Arithmetic as an AST
    +   Basic language features, e.g., more types, operations

4.  Polymorphism
    +   Parametricity: reasoning about polymorphic code

5.  The road to monads
    +   Typeclasses
    +   Functors and applicative functors
    +   Monads and their applications

6.  Parsing and Parser Combinators
    +   Formal grammars

7.  Type Systems
    +   Formal specification of type systems
    +   Advanced types: Type families, GADTs, and dependent types
