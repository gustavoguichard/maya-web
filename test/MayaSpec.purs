module Test.MayaSpec (mayaSpec) where

import Prelude

import Data.Array (length)
import Data.Date (diff)
import Data.Time.Duration (Days(..))
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

import Kins (Kin(..), Selo(..), Tom(..), findKin, kinIndex, ondaEncantada, tzolkin)
import Maya (kinByDate, kinIndexByDate, makeDate)

mayaSpec :: Spec Unit
mayaSpec = describe "Maya kin calculator" do
  it "diff returns 11 days between 2013-01-01 and 2012-12-21" do
    diff (makeDate 2013 1 1) (makeDate 2012 12 21) `shouldEqual` Days 11.0

  it "kinByDate 2012-12-21 is Kin 207 (Mao Cristal)" do
    kinIndexByDate { year: 2012, month: 12, day: 21 } `shouldEqual` 207
    kinByDate { year: 2012, month: 12, day: 21 } `shouldEqual` Kin Mao Cristal

  it "Feb 29 and Mar 1 of 2024 produce the same kin" do
    kinByDate { year: 2024, month: 2, day: 29 }
      `shouldEqual` kinByDate { year: 2024, month: 3, day: 1 }

  it "tzolkin has 260 kins" do
    length tzolkin `shouldEqual` 260

  it "ondaEncantada has 13 kins" do
    length (ondaEncantada (findKin 100)) `shouldEqual` 13

  it "findKin 1 is Kin Dragao Magnetico" do
    findKin 1 `shouldEqual` Kin Dragao Magnetico

  it "findKin 260 is Kin Sol Cosmico" do
    findKin 260 `shouldEqual` Kin Sol Cosmico

  it "kinIndex is the inverse of findKin" do
    kinIndex (findKin 83) `shouldEqual` 83
    kinIndex (findKin 207) `shouldEqual` 207
