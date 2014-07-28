
module Geekdarling.Functor
  ( module Control.Applicative
  , (.), (!), (&), (?), (<<$>>)
  ) where

import Control.Applicative hiding (empty)
import Prelude hiding ((.))


-- | (r ->) is an instance of Functor
-- This version of (.) works as a very weak infix operator
-- for fmap and composes functions as well
(.) :: (Functor f) => (a -> b) -> f a -> f b
(.) = fmap
infixr 9 .

-- | Ultimate infix operator for fmap
(!) :: (Functor f) => (a -> b) -> f a -> f b
(!) = fmap
infixr 0 !

-- | Penetrates two functors:
-- [not <<$>> Just $ False]
--   ==  not <<$>> Just <$> [False]
(<<$>>) :: (Functor f, Functor g) => (a -> b) -> f (g a) -> f (g b)
(<<$>>) = fmap <$> fmap
infixr 3 <<$>>

-- | C-style syntax for if..then..else, the following holds:
-- False ? False $ True ? True $ False
(?) :: Bool -> a -> a -> a
(?) True e _ = e
(?) _    _ e = e
infixr 1 ?

-- | Apply the second argument to the first
(&) :: a -> (a -> b) -> b
x & f = f x
infixl 1 &
