{-# LANGUAGE OverloadedStrings #-}

module Geekdarling.Handler.Profile where

import Geekdarling.Import

import Control.Monad
import Data.Maybe
import Data.Text.Encoding
import qualified Data.ByteString.Base64 as B64


data ProfileData = ProfileData
  { about   :: Textarea
  , picture :: Maybe FileInfo
  }

getProfileR :: Handler Html
getProfileR = do
  Just uid <- maybeAuthId
  profile  <- fmap entityVal ! runDB . getBy $ UniqueUserProfile uid
  editGet  <- lookupGetParam "edit" 
  (formWidget, enctype) <- generateFormPost . renderDivs $ profileForm profile
  let own = True
  defaultLayout $ do
    setTitle "Your Profile"
    isJust profile && isNothing editGet ? $(widgetFile "profile") $ $(widgetFile "profile_edit")

postProfileR :: Handler Html
postProfileR = do
  Just uid <- maybeAuthId
  profile  <- fmap entityVal ! runDB . getBy $ UniqueUserProfile uid
  rnd <- liftIO $ decodeLatin1 . B64.encode . randomBS 6
  ((result, formWidget), enctype) <- runFormPost . renderDivs $ profileForm profile
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
    $(widgetFile "profile_edit")

profileForm :: Maybe Profile -> AForm Handler ProfileData
profileForm profile = ProfileData
  <$> areq textareaField "Please tell us more about you:"
      (Textarea ! join $ profileAbout . profile)
  <*> fileAFormOpt "We are interested in photos of you AFK"
