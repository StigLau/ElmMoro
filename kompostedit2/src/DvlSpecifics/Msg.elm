module DvlSpecifics.Msg exposing (..)

import Navigation.AppRouting exposing (Page)

type Msg
    = SetKompositionName String
    | SetDvlType String
    | SetChecksum String
--Source
    | SetId String
    | SetURL String
    | SetBpm String
    | SetOffset String
--Config
    | SetWidth String
    | SetHeight String
    | SetFramerate String
    | SetExtensionType String
--Other
    | InternalNavigateTo Page
    | EditMediaFile String
    | FetchAndLoadMediaFile String
    | SaveSource
    | DeleteSource String
    | OrderChecksumEvalutation String