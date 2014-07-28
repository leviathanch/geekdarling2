{-# LANGUAGE OverloadedStrings #-}

module Geekdarling.Handler.Profile where

import Geekdarling.Import

import Control.Monad
import Data.Maybe
import Data.Text.Encoding
import qualified Data.ByteString.Base64 as B64


data ProfileData = ProfileData
  { about :: Textarea
  }

getProfileR :: Handler Html
getProfileR = do
  Just uid <- maybeAuthId
  profile  <- fmap entityVal ! runDB . getBy $ UniqueUserProfile uid
  editGet  <- lookupGetParam "edit" 
  let edit = isNothing profile || isJust editGet
  (formWidget, enctype) <- generateFormPost . renderDivs $ profileForm profile
  defaultLayout $ do
    setTitle "Your Profile"
    $(widgetFile "profile")

postProfileR :: Handler Html
postProfileR = do
  Just uid <- maybeAuthId
  profile  <- fmap entityVal ! runDB . getBy $ UniqueUserProfile uid
  rnd <- liftIO $ decodeLatin1 . B64.encode . randomBS 6
  ((result, formWidget), enctype) <- runFormPost . renderDivs $ profileForm profile
  let edit = True
  case (result, profile) of
    (FormSuccess form, Just _ ) -> do
      runDB $ updateWhere [ProfileUser ==. uid]
        [ ProfileAbout =. (Just . unTextarea $ about form)
        ]
    (FormSuccess form, Nothing) -> do
      runDB $ insert Profile
        { profileUser  = uid
        , profileMask  = rnd
        , profileAbout = Just . unTextarea $ about form
        }
      return ()
    _ -> return ()
  defaultLayout $ do
    setTitle "Your Profile"
    $(widgetFile "profile")

profileForm :: Maybe Profile -> AForm Handler ProfileData
profileForm profile = ProfileData
  <$> areq textareaField "Please tell us more about you:"
      (Textarea ! join $ profileAbout . profile)