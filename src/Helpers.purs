module Helpers
  ( cycleIndex
  , elemPos
  ) where

import Prelude

import Data.Array as Array
import Data.Maybe (fromMaybe)
import Partial.Unsafe (unsafePartial)

cycleIndex :: forall a. Array a -> Int -> a
cycleIndex arr i =
  unsafePartial (Array.unsafeIndex arr (i `mod` Array.length arr))

elemPos :: forall a. Eq a => Array a -> a -> Int
elemPos arr el = fromMaybe 0 (Array.elemIndex el arr)
