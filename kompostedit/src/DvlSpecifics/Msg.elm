module DvlSpecifics.Msg exposing (Msg(..))

import Navigation.Page exposing (Page)

type Msg
    = SetKompositionName String
    | SetDvlType String
      --Config
    | SetWidth String
    | SetHeight String
    | SetFramerate String
    | SetExtensionType String
      -- Beat Pattern
    | SetBpm String
    | SetFromBpm String
    | SetToBpm String
    | SetMasterBpm String
      --Other
    | InternalNavigateTo Page
