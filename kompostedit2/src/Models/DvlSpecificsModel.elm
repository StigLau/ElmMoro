module Models.DvlSpecificsModel exposing (Msg(..), OutMsg(..))

import Navigation.AppRouting exposing (Page)

type Msg
    = SetFileName String
    | SetBpm String
    | SetChecksum String
    | InternalNavigateTo Page

type OutMsg
    = OutNavigateTo Page
