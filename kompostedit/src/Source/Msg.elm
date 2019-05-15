module Source.Msg exposing (..)

import Common.AutoComplete

type Msg
    = EditMediaFile String
    | FetchSourceList String
    | SaveSource
    | DeleteSource String
    | JumpToSourceKomposition String
    | SetChecksum String
    | OrderChecksumEvalutation String

    | SetSourceMediaType String
    | SetSourceExtensionType String

    | SetSourceId String
    | SetOffset String
    | SourceSearchVisible Bool
    | AutoComplete Common.AutoComplete.Msg
