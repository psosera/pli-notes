module Shapes where

{- Using Type Classes -}
class Shape a where
  area :: a -> Float
  perimeter :: a -> Float

data Rectangle = Rectangle Float Float

instance Shape Rectangle where
  area (Rectangle width height) = width * height
  perimeter (Rectangle width height) = (2 * width) + (2 * height)

data Circle = Circle (Float, Float) Float -- center, radius

instance Shape Circle where
  area (Circle _ r) = pi * r * r
  perimeter (Circle _ r) = 2 * pi * r

-- ... data types and instances for other shapes

{- Using ADT -}
data Shape2
  = Rectangle2 Float Float
  | Circle2 (Float, Float) Float

area2 :: Shape2 -> Float
area2 (Rectangle2 width height) = width * height
area2 (Circle2 _ r) = pi * r * r

perimeter2 :: Shape2 -> Float
perimeter2 (Rectangle2 width height) = undefined
perimeter2 (Circle2 _ r) = undefined

{- Using record bag of functions -}
data Shape3 = Shape3
  { area3 :: Float,
    perimeter3 :: Float
  }

rectangle :: Float -> Float -> Shape3
rectangle width height = Shape3 (width * height) (2 * width + 2 * height)

circle :: Float -> Shape3
circle r = Shape3 (pi * r * r) (2 * pi * r)
