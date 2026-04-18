module Kins where

import Prelude

import Data.Array ((..), filter, length)
import Data.Generic.Rep (class Generic)
import Data.Foldable (sum)
import Data.Show.Generic (genericShow)

import Helpers (cycleIndex, elemPos)

data Selo
  = Dragao
  | Vento
  | Noite
  | Semente
  | Serpente
  | EnlacadorDeMundos
  | Mao
  | Estrela
  | Lua
  | Cachorro
  | Macaco
  | Humano
  | CaminhanteDoCeu
  | Mago
  | Aguia
  | Guerreiro
  | Terra
  | Espelho
  | Tormenta
  | Sol

derive instance Eq Selo
derive instance Ord Selo
derive instance Generic Selo _
instance Show Selo where
  show = genericShow

data Tom
  = Magnetico
  | Lunar
  | Eletrico
  | AutoExistente
  | Harmonico
  | Ritmico
  | Ressonante
  | Galatico
  | Solar
  | Planetario
  | Espectral
  | Cristal
  | Cosmico

derive instance Eq Tom
derive instance Ord Tom
derive instance Generic Tom _
instance Show Tom where
  show = genericShow

data Cor
  = Vermelho
  | Branco
  | Azul
  | Amarelo

derive instance Eq Cor
derive instance Ord Cor
derive instance Generic Cor _
instance Show Cor where
  show = genericShow

data Kin = Kin Selo Tom

derive instance Eq Kin
derive instance Generic Kin _
instance Show Kin where
  show = genericShow

selos :: Array Selo
selos =
  [ Dragao, Vento, Noite, Semente, Serpente, EnlacadorDeMundos, Mao, Estrela
  , Lua, Cachorro, Macaco, Humano, CaminhanteDoCeu, Mago, Aguia, Guerreiro
  , Terra, Espelho, Tormenta, Sol
  ]

tons :: Array Tom
tons =
  [ Magnetico, Lunar, Eletrico, AutoExistente, Harmonico, Ritmico, Ressonante
  , Galatico, Solar, Planetario, Espectral, Cristal, Cosmico
  ]

cores :: Array Cor
cores = [ Vermelho, Branco, Azul, Amarelo ]

castle :: Int
castle = length tons * length cores

tzolkinLength :: Int
tzolkinLength = length selos * length tons

tzolkin :: Array Kin
tzolkin = map findKin (1 .. tzolkinLength)

ondasEncantadas :: Array Kin
ondasEncantadas = filter isMagnetico tzolkin
  where
  isMagnetico (Kin _ tom) = tom == Magnetico

seloIndex :: Selo -> Int
seloIndex selo = elemPos selos selo + 1

tomIndex :: Tom -> Int
tomIndex tom = elemPos tons tom + 1

kinIndex :: Kin -> Int
kinIndex kin = elemPos tzolkin kin + 1

ondaIndex :: Selo -> Int
ondaIndex selo = elemPos ondasEncantadas (Kin selo Magnetico) + 1

findSelo :: Int -> Selo
findSelo n = cycleIndex selos (n - 1)

findTom :: Int -> Tom
findTom n = cycleIndex tons (n - 1)

findCor :: Int -> Cor
findCor n = cycleIndex cores (n - 1)

findKin :: Int -> Kin
findKin n = Kin (findSelo n) (findTom n)

findGuia :: Kin -> Kin
findGuia (Kin selo tom) =
  findKin (start + castle * factor)
  where
  factorList = [ 1, 2, 3, 4, 0 ]
  start = kinIndex (Kin selo tom)
  tomDots = tomIndex tom `mod` 5
  factor = elemPos factorList tomDots

findAnalogo :: Kin -> Kin
findAnalogo (Kin selo tom) = Kin selo' tom
  where
  selo' = findSelo (19 - seloIndex selo)

findAntipoda :: Kin -> Kin
findAntipoda (Kin selo tom) = Kin selo' tom
  where
  selo' = findSelo (10 + seloIndex selo)

findOculto :: Kin -> Kin
findOculto (Kin selo tom) = Kin selo' tom'
  where
  selo' = findSelo (21 - seloIndex selo)
  tom' = findTom (14 - tomIndex tom)

findOndaEncantada :: Kin -> Kin
findOndaEncantada (Kin selo tom) =
  findKin (kinIndex (Kin selo tom) - tomIndex tom + 1)

findFamilia :: Kin -> Array Selo
findFamilia (Kin selo _) =
  map findSelo [ start, start + 5, start + 10, start + 15 ]
  where
  start = seloIndex selo `mod` 5

findHarmonic :: Array Int -> Kin
findHarmonic list = findKin (sum list)

seloColor :: Selo -> Cor
seloColor selo = findCor (seloIndex selo `mod` length cores)

readKin :: Kin -> String
readKin (Kin selo tom) =
  show selo <> " " <> show tom <> " " <> show (seloColor selo)

ondaEncantada :: Kin -> Array Kin
ondaEncantada kin = map findKin (start .. end)
  where
  start = kinIndex (findOndaEncantada kin)
  end = start + 12
