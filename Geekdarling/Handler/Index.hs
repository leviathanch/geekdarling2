{-# LANGUAGE OverloadedStrings #-}

module Geekdarling.Handler.Index where

import Geekdarling.Import


getIndexR :: Handler Html
getIndexR = do
  authorized <- maybeAuthId
  defaultLayout $ do
    setTitle "Welcome to Geekdarling"
    $(widgetFile "frontpage") 
