~~~haskell
module AlgebraicDataTypes where
~~~

Algebraic Data Types
====================

While we have only scratched the surface of Haskell up to this point, we are in
a prime position to talk about its most powerful feature: algebraic data types
(ADTs, not to be confused with abstract data types).  An algebraic data type
does the following:

1.  Declares a new type.
2.  Defines a finite collection of constructors that are values of that
    type (constants) or functions that build values of that type.

For example, we might declare a simple algebraic data type that emulates
booleans that we are already familiar with:

~~~haskell
data MyBool   -- N.B., the Haskell boolean type is `Bool`
  = MyTrue    -- ...with True and False as values!
  | MyFalse
~~~

`MyTrue` and `MyFalse` are both values of type MyBool, which we can verify in
ghci with the :type command:

~~~shell
*AlgebraicDataTypes> :type MyTrue
MyTrue :: MyBool
*AlgebraicDataTypes> :type MyFalse
MyFalse :: MyBool
~~~

What can we do with a value that is an algebraic data type?  We can perform
_case analysis_ on it, a process called _pattern matching_:

~~~haskell
myBoolToBool :: MyBool -> Bool
myBoolToBool MyTrue  = True
myBoolToBool MyFalse = False
~~~

Note that pattern matching is how we processed lists in our previous reading.
We performed simultaneous case analysis on the shape of the list (whether it
was empty or non-empty) and in the non-empty case, we automatically extracted
out the head and tail of the list.

~~~haskell
myLength :: [a] -> Int
myLength []       = 0
myLength (_ : xs) = 1 + myLength xs
~~~

Indeed, here is the definition of a list in Haskell as an algebraic data
type:

~~~haskell
data List a
  = Nil
  | Cons a (List a)
~~~

The `Cons` constructor, unlike Nil, takes two arguments, one of type `a` and
the other of type `List a`.  In other words, `Cons` is a function of type:

~~~shell
*AlgebraicDataTypes> :type Cons
Cons :: a -> List a -> List a
~~~

The Haskell standard syntax for lists corresponds to the following algebraic
data type definition:

~~~haskell
-- N.B., this is not valid Haskell code---we show it
-- to compare to the List type we previously defined.
-- data [a]
--   = []
--   | (:) a [a]
~~~

So why are algebraic data types useful?  They're useful because they concisely
capture the notion of a type that has a finite set of alternatives. Much of the
world's data can be modeled in such a way, _e.g._,

+   Sorts of employees in an office.
+   NPcs in a game
+   Kinds of abstract syntax in a programming language
+    Animals in a nature simulation

With pattern matching, we define behavior by case analysis on these
structures concisely and directly.

As another example, consider the `Maybe` algebraic data type which represents
whether an operation failed or succeeded:

~~~haskell
-- data Maybe a     -- Defined in the standard library!
--   | Nothing
--   | Just a
~~~

A `Maybe a` is either:

+   `Nothing`, representing a failed computation.
+   `Just` a, representing a successful computation as a box containing the
    result `a`.

For example the `take` function over lists is not well-defined for some inputs.
  Rather than hiding this problem by throwing errors at runtime, we can
  manifest the partial nature of the function in its type:

~~~haskell
safeTake :: Int -> [a] -> Maybe [a]
safeTake 0 []       = Just []
safeTake n (x : xs) =
  case safeTake (n - 1) xs of
    Nothing  -> Nothing
    Just xs' -> Just (x : xs')
safeTake _ _        = Nothing
~~~

Our safe implementation of take now returns `Nothing` when given invalid
arguments and produces `Just` a list that is the `n`-length prefix of the input
list when the arguments are valid.  The structure of the function uses a few
additional language features.

+   Rather than pattern matching as alternatives to a function's
    implementation, we can pattern match at the expression-level with the
    `case` expression.  Haskell is whitespace sensitive, so the indentation in
    the case is load-bearing!
+   Patterns in a pattern match are processed in top-down order, similar to a
    case statement in C-like languages.  As a result, we take advantage of
    wildcards ('_') to express the "else" behavior that when the arguments do
    not match, we return `Nothing`.  Note that if we analyze the cases of the
    function, this occurs precisely when `safeTake` is invoked with 0 and a
    non-empty list.

Exercises
---------

Below is a definition of an algebraic data type corresponding to the days of
the week.

~~~haskell
data Day
  = Monday
  | Tuesday
  | Wednesday
  | Thursday
  | Friday
  | Saturday
  | Sunday
~~~

Complete the function definitions below.  Make sure to test your implementation
in the Haskell interpreter (`ghci`).  You'll need this first function to be
able to convert a day to a string so the interpreter can print it out.

~~~haskell
-- dayToString d converts a `Day` into an appropriate string representing that
-- day.
dayToString :: Day -> String
dayToString = undefined

-- isWeekend d returns True iff d is a weekend day.
isWeekend :: Day -> Bool
isWeekend = undefined

-- nextDay d returns the next day of the week
nextDay :: Day -> Day
nextDay = undefined

-- nextNDays n d returns the day that is n days from the input day.
nextNDays :: Int -> Day -> Day
nextNDays = undefined
~~~
