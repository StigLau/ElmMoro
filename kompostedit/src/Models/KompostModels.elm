module Models.KompostModels exposing (..)

type alias Model =
    { name: String
    , start: Int
    , end: Int
    , config: Config
    , mediaFile: Mediafile
    , segments: List Segment
    }

type alias Komposition =
    { name: String
    --, config: Config
    , mediaFile: Mediafile
    , segments: List Segment
    }

type alias Config =
    { width : Int
    , height : Int
    , framerate : Int
    , extensionType : String
    , duration : Int
    }

type alias Mediafile =
    { fileName: String
    , startingOffset: Float
    , checksum: String
    }

type alias Segment =
    { id: String
    , start: Int
    , end: Int
    }

type alias KompositionRequest a =
    { a
        | name : String
        , mediaFile : Mediafile
        , segments : List Segment
    }