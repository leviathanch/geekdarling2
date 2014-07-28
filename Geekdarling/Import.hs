module Geekdarling.Import
    ( module Import
    ) where

import Prelude     as Import hiding
  ( head, init, last
  , readFile, tail, writeFile
  , (.)
  )
import Yesod       as Import hiding (Route (..))
import Yesod.Auth  as Import

import Data.Text            as Import (Text)

import Geekdarling.Foundation           as Import
import Geekdarling.Functor              as Import
import Geekdarling.Model                as Import
import Geekdarling.Settings             as Import
import Geekdarling.Settings.Development as Import
import Geekdarling.Settings.StaticFiles as Import
import Geekdarling.Util                 as Import

#if __GLASGOW_HASKELL__ >= 704
import           Data.Monoid          as Import
                                                 (Monoid (mappend, mempty, mconcat),
                                                 (<>))
#else
import           Data.Monoid          as Import
                                                 (Monoid (mappend, mempty, mconcat))

infixr 5 <>
(<>) :: Monoid m => m -> m -> m
(<>) = mappend
#endif
