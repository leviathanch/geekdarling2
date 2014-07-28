
module Geekdarling.Handler.ProfileOther where

import Geekdarling.Import

import Data.Maybe


getProfileOtherR :: Text -> Handler Html
getProfileOtherR mask = do
  profile <- fmap entityVal ! runDB . getBy $ UniqueProfile mask
  let own = False
  defaultLayout $ do
    setTitle "Profile"
    $(widgetFile "profile")

postProfileOtherR :: Text -> Handler Html
postProfileOtherR = error "Not yet implemented: postProfileOtherR"
