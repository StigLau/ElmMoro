module DvlSpecifics.Msg exposing (Msg(..))

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
    | SetSourceExtensionType String
    | SetSourceMediaType String
    | SetSnippet Bool
      --Config
    | SetWidth String
    | SetHeight String
    | SetFramerate String
    | SetExtensionType String
      -- Beat Pattern
    | SetFromBpm String
    | SetToBpm String
    | SetMasterBpm String
      --Other
    | InternalNavigateTo Page
    | EditMediaFile String
    | FetchAndLoadMediaFile String
    | SaveSource
    | DeleteSource String
    | OrderChecksumEvalutation String
