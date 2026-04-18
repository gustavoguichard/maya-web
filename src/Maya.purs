module Maya where

import Prelude

import Data.Date (Date, canonicalDate, diff)
import Data.Enum (toEnum)
import Data.Foldable (sum)
import Data.Int (round)
import Data.Maybe (fromJust)
import Data.Time.Duration (Days(..))
import Partial.Unsafe (unsafePartial)

import Kins (Kin, findKin)

type YMD = { year :: Int, month :: Int, day :: Int }

kinZero :: Int
kinZero = 207

yearZero :: Int
yearZero = 2012

makeDate :: Int -> Int -> Int -> Date
makeDate y m d = unsafePartial
  ( canonicalDate
      (fromJust (toEnum y))
      (fromJust (toEnum m))
      (fromJust (toEnum d))
  )

zeroDate :: Date
zeroDate = makeDate 2012 12 21

daysFromZero :: YMD -> Int
daysFromZero { year, month, day } =
  case diff (makeDate year month day) zeroDate of
    Days n -> round n

isLeapYear :: Int -> Boolean
isLeapYear y =
  y `mod` 4 == 0 && (y `mod` 100 /= 0 || y `mod` 400 == 0)

shouldApplyBissestile :: YMD -> Boolean
shouldApplyBissestile { year, month, day } =
  isLeapYear year && isBeforeNullDay
  where
  isBeforeNullDay
    | month == 2 = day <= 28
    | otherwise = month < 2

countLeapYears :: Int -> Int
countLeapYears y = y / 4 - y / 100 + y / 400

pastNullDays :: YMD -> Int
pastNullDays { year } = countLeapYears year - countLeapYears yearZero

discountNullDays :: YMD -> Int
discountNullDays date = pastNullDays date + adjust
  where
  adjust
    | shouldApplyBissestile date = -1
    | otherwise = 0

daysFromZeroNoNullDays :: YMD -> Int
daysFromZeroNoNullDays date =
  daysFromZero date - discountNullDays date

kinIndexByDate :: YMD -> Int
kinIndexByDate ymd@{ year, month, day } =
  kinZero + daysFromZeroNoNullDays normalized
  where
  normalized
    | month == 2 && day > 28 = { year, month: 3, day: 1 }
    | otherwise = ymd

kinByDate :: YMD -> Kin
kinByDate date = findKin (kinIndexByDate date)

harmonicByDates :: Array YMD -> Kin
harmonicByDates list = findKin (sum (map kinIndexByDate list))
