module DvlSpecifics.Msg exposing (..)

import Navigation.AppRouting exposing (Page)

type Msg
    = SetKompositionName String
    | SetFileName String
    | SetBpm String
    | SetChecksum String
    | SetOffset String
    | InternalNavigateTo Page
    | EditMediaFile String
    | FetchAndLoadMediaFile String
    | SaveMediaFile
    | DeleteMediaFile String