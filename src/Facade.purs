module Facade (kinInfo) where

import Prelude

import Kins (Kin(..), findAnalogo, findAntipoda, findFamilia, findGuia, findOculto, kinIndex, ondaEncantada, readKin, seloColor)
import Maya (YMD, kinByDate)

type Info =
  { number :: Int
  , name :: String
  , seal :: String
  , tone :: String
  , color :: String
  , guide :: String
  , analog :: String
  , antipode :: String
  , hidden :: String
  , wavespell :: Array String
  , family :: Array String
  }

kinInfo :: YMD -> Info
kinInfo ymd =
  let
    kin = kinByDate ymd

    Kin selo tom = kin
  in
    { number: kinIndex kin
    , name: readKin kin
    , seal: show selo
    , tone: show tom
    , color: show (seloColor selo)
    , guide: readKin (findGuia kin)
    , analog: readKin (findAnalogo kin)
    , antipode: readKin (findAntipoda kin)
    , hidden: readKin (findOculto kin)
    , wavespell: map readKin (ondaEncantada kin)
    , family: map show (findFamilia kin)
    }
