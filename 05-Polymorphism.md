~~~haskell
{-# LANGUAGE ExistentialQuantification #-}

module Polymorphism where
~~~

# Polymorphism

Next, we'll take a deep dive into parametric polymorphism. Recall that
parametric polymorphism results from parameterizing values by types so that
a single value can operate over many different types, _i.e._, generics in Java.
In addition to allowing us to use one piece of code over many types,
polymorphism, when used appropriately, can give us strong guarantees about the
behavior of our code.

Polymorphism as Uniformity of Behavior
--------------------------------------

Haskell provides very simple syntax for specifying a polymorphic function.
Any name used in a type that is not recognized as an already preexisting
type is interpreted as a type variable.

~~~haskell
id1 :: a -> a
id1 a = a
~~~

For example, the `a` in the type signature of `id1` is not a preexisting
type, therefore it is interpreted as a type variable.  Thus, we can read the
type of `id1` as follows: "give `id1` a value of an arbitrary type and it'll
return a value of that same arbitrary type".  Note that we could've used a
different name for the type variable, _e.g._, `dog`:

~~~haskell
id2 :: dog -> dog
id2 x = x
~~~

And this works fine.  However, by convention, we tend to use single letter
names for our type variables, in particular `a` and `b`.

In reality, the type `a -> a` is a type parameterized by another type.  We can
make this explicit with the `forall` type which explicitly quantifies a type by
one or more type variables.

~~~haskell
id3 :: forall a. a -> a
id3 x = x
~~~

Although in practice we do not use this explicit quantifier as it has other
purposes (in particular, when used in conjunction with algebraic data types, we
counter-intuitively obtain existential types)!  Note that the `forall` type
syntax is not standard Haskell; it is enabled by specifying the
`ExistentialQuantification` language pragma at the top of this file.

From the client's perspective, `id` is a very general function that operates
over many types.  From the implementor-of-the-function's perspective, however,
we have a very constrained function.  In particular, because:

1.  The input and output are of an arbitrary type.
2.  The input type and output type must match.

The function cannot return a specific value, _e.g._, `5`, because while the
function may be instantiated to `Int` some of the time, this implementation
won't make sense if the user instantiated the function to a different type such
as `String`.  It has to return something of the arbitrary type `a`. The only
value of type `a` available is the parameter to the function and so we are
forced to return it!

A Note on Non-Termination
-------------------------

Before continuing, it is worthwhile to note that this wasn't the only option for
the implementation of `id`!  Here is an implementation of `id` that successfully
type checks:

~~~haskell
id4 :: a -> a
id4 x = id4 x
~~~

This implementation is simply an infinite loop!  Note that because `id` takes
an `a` and returns and `a`, we can simply chain calls of `id` together:

~~~haskell
id5 :: a -> a
id5 x = id5 (id5 x)
~~~

Recall that the composition operator `(.)` allows us to compose functions
together, so `id6` is equivalent to `id5`:

~~~haskell
id6 :: a -> a
id6 = id6 . id6
~~~

And it is immediately clear that an infinite number of such functions is
possible. But really, why do we need to compose `id` calls together? The
following definition works as well as the others:

~~~haskell
id7 :: a -> a
id7 = id7
~~~

All of these programs are infinite loops. In Haskell, we refer to these
programs—and in general, any computation that does not complete successfully—as
_bottom_. In logic, we write bottom as ⊥, a value that has any type.

~~~haskell
bottom :: a
bottom = bottom
~~~

Indeed, you might recognize this type (`forall a. a`): it is the type of the
`undefined` constant we use as a placeholder for functions to fill in later!

Because every type includes the `bottom` value, all of our forthcoming claims
about the possible outputs of polymorphic functions must include "...and
`bottom` too". Thus, rather than caveatting all of our future claims assume the
absence of infinite loops or the `bottom` value.  Putting it another way, we
assume that all of the potential functions that we write are total or
terminating.

Reasoning About Polymorphic Types
---------------------------------

Our intuition is that code that possesses values of polymorphic type can only
shuffle said values around.  In particular, the code cannot inspect the value
and make decisions based on its contents.  To put it another way, we cannot
make any assumptions about the shape of values of polymorphic type or the
operations that such values support.

These constraints are powerful for both the user and designer of the programs
that use polymorphic types.  For the user, the type signature of the program
now makes strong guarantees about the behavior of the function.  For the
implementor, the types greatly constrain what programs might typecheck

**Exercise**: for each of the following function signatures, describe the
likely behavior of the function in its comment. To do this, describe how the
function must produce its output in terms of its input.

~~~haskell
-- TODO: fill me in
f1 :: a -> b -> a

-- TODO: fill me in
f2 :: (a -> b) -> a -> b

-- TODO: fill me in
f3 :: (a -> b) -> (b -> c) -> a -> c

-- TODO: fill me in
f4 :: (a -> b -> c) -> b -> a -> c
~~~

In type-directed programming, the structure of our types dictates the design
of our programs. By leveraging the fact that Haskell has a rich static type
system where the compiler enforces that our program is well-typed, we can
frequently get away with simply getting our program to typecheck.

One way that GHC allows us to perform type-directed programming is with its
hole construct.  When writing a function, we can use an underscore in place
of an expression `(_)`.  When compiling the program, GHC will flag an error
for each hole, giving information about the intended type of the hole as
well as relevant context information: the types of local variables that are
in scope.

To see this in action, try replace `undefined` with `_` in the body of `id8`
below as an example:

~~~haskell
id8 :: a -> a
id8 x = undefined   -- TODO: Replace me with _ to see an example of a hole!
                    --       Implement me once you are done so you can
                    --       continue compiling this file!
~~~

When I do this on my machine, I receive the following error:

~~~shell
   • Found hole: _ :: a
     Where: ‘a’ is a rigid type variable bound by
              the type signature for:
                id8 :: forall a. a -> a
              at /Users/osera/Scratch/Polymorphism.hs:165:1-13
   • In the expression: _
     In an equation for ‘id8’: id8 x = _
   • Relevant bindings include
       x :: a (bound at /Users/osera/Scratch/Polymorphism.hs:166:5)
       id8 :: a -> a
         (bound at /Users/osera/Scratch/Polymorphism.hs:166:1)
     Valid hole fits include
       x :: a (bound at /Users/osera/Scratch/Polymorphism.hs:166:5)
       bottom :: forall a. a
         with bottom @a
         (defined at /Users/osera/Scratch/Polymorphism.hs:102:1)

      |
  166 | id8 x = _
      |         ^
~~~

The error notes that:

+   I need to fill in an expression of type `a` in place of the hole.
+   Relevant bindings include `x` and `id8`, and
+   Valid completions include `x` and `bottom`.

Rather than having to manually track the types of all relevant variables and my
goal, the compiler reports this information through holes!  As a side note, you
might note that there are quite a number of valid completions that are not
reported by the compiler.  As a thought experiment, you should think about why
this might be the case!

**Exercise**: Program holes are a powerful tool for program design. Use them in
an incremental fashion to implement the functions below by first replacing the
`undefined` occurrences with holes, then refine your program incrementally,
using sub-holes whenever there are pieces of your program that you aren't sure
how to implement.

~~~haskell
-- f1 :: a -> b -> a
f1 x y = undefined

-- f2 :: (a -> b) -> a -> b
f2 f x = undefined

-- f3 :: (a -> b) -> (b -> c) -> a -> c
f3 f g x = undefined

-- f4 :: (a -> b -> c) -> b -> a -> c
f4 f x y = undefined
~~~

**Exercise**: in the above cases, there is a single choice of non-trivial
implementation because of the structure of the types.  Here are more
complicated examples where multiple implementations are possible.  For example,
in `f5` below, a perfectly valid implementation is to return the third argument
of type `a`.

However, this is not a desirable implementation since we don't use all of
the arguments in a productive way!  Ideally, we should use all of the
arguments in our implementation in a meaningful way.  Find an implementation
for the functions below that satisfies this criteria, describing its
behavior in its comment. Use holes to guide your way when you get stuck!

(Hint: recall that you can use recursion on functions and pattern matching
on algebraic data types as necessary.  Note that algebraic data type
constructors do not usually appear in the completion list when using holes.)

~~~haskell
f5 :: (a -> Bool) -> (a -> a) -> a -> a
f5 f g x = undefined

f6 :: Int -> a -> [a]
f6 n x = undefined

f7 :: (b -> a -> b) -> b -> [a] -> b
f7 f x l = undefined

f8 :: b -> (a -> Maybe b) -> a -> b
f8 d f x = undefined

f9 :: (a -> Maybe b) -> [a] -> [b]
f9 f l = undefined
~~~
