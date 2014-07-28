
module Geekdarling.Util where

import qualified Data.ByteString as S 
import Prelude
import System.IO


randomBS :: Int -> IO S.ByteString
randomBS i = do
  hdl <- openFile "/dev/urandom" ReadMode
  str <- S.hGet hdl i
  hClose hdl
  return str
