{-# LANGUAGE OverloadedStrings #-}

module Handler.Index where

import Import


getIndexR :: Handler Html
getIndexR = do
  authorized <- maybeAuthId
  defaultLayout $ do
    setTitle "Welcome to Geekdarling"
    $(widgetFile "frontpage") 
