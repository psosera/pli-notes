module Interp where

data Exp
  = ELit Int
  | ETrue
  | EFalse
  | EPlus Exp Exp
  | ELt Exp Exp
  | EIf Exp Exp Exp
  deriving (Show, Eq)

data Val
  = VInt Int
  | VBool Bool
  deriving (Show, Eq)

evaluate :: Exp -> Maybe Val
evaluate (ELit n)       = Just $ VInt n
evaluate ETrue          = Just $ VBool True
evaluate EFalse         = Just $ VBool False
evaluate (EPlus e1 e2)  =
  evaluate e1 >>=
    \v1 -> evaluate e2 >>=
      \v2 -> case (v1, v2) of
               (VInt n1, VInt n2) ->
                 Just $ VInt (n1 + n2)
               _ -> Nothing
evaluate (ELt e1 e2)    = do
  v1 <- evaluate e1
  v2 <- evaluate e2
  case (v1, v2) of
    (VInt n1, VInt n2) -> Just $ VBool $ n1 < n2
    _                  -> Nothing
evaluate (EIf e1 e2 e3) = do
  v1 <- evaluate e1
  case v1 of
    VBool True  -> evaluate e2
    VBool False -> evaluate e3
    _           -> Nothing

-----

-- Referential Transparency, "pure"
--
-- Same inputs => Same outputs
-- cos(0) = 1
-- cos(0) = 1
-- cos(0) = 1
--
-- seed :: mutable Int
--
-- random :: () -> Int
-- random () = let (seed', output) = f(seed)
--               seed := seed'; output
--
-- random() = 0
-- random() = 1
-- random() = 2
--
-- Why?
-- What causes it (to not be)?

-- Composability
-- f . g

-- Composability =
--   Referential transparency + laziness
--
-- Laziness
-- -> generators
-- -> iterators (sort of)

fix :: (a -> a) -> a
fix f = f (fix f)

fact rec 0 = 1
fact rec n = n * rec (n-1)

--      (fix fact) 5
-- -->  (fact (fix fact) 5)
-- -->* 5 * (fix fact) 4
-- -->  5 * (fact (fix fact) 4)
-- -->  5 * 4 * ...

--
--
--     1 + 2 * 3 - 4
--
--    (x+1) * (x+1)
--
--    l =  5 :: 4 :: 3 :: 2 :: 1 :: []
--    l' = 6 :: l
--
-- Graph model of execution
-- versus
-- Substitutive model
-- Environment-based model
-- Stack-based models

(>>=) :: Maybe a -> (a -> Maybe b) -> Maybe b
(>>=) x f =
  case x of
    Just v -> f v
    Nothing -> Nothing
