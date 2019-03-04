module Source.Msg exposing (..)


type Msg
    = EditMediaFile String
    | FetchAndLoadMediaFile String
    | SaveSource
    | DeleteSource String
    | SetChecksum String
    | OrderChecksumEvalutation String

    | SetSourceMediaType String
    | SetSourceExtensionType String

    | SetId String
    | SetURL String
    | SetOffset String
    | SetSnippet Bool
