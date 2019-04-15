module Source.Msg exposing (..)


type Msg
    = EditMediaFile String
    | FetchAndLoadMediaFile String
    | SaveSource
    | DeleteSource String
    | JumpToSourceKomposition String
    | SetChecksum String
    | OrderChecksumEvalutation String

    | SetSourceMediaType String
    | SetSourceExtensionType String

    | SetId String
    | SetOffset String
    | SetSnippet Bool
