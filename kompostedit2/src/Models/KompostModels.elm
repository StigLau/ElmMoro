module Models.KompostModels exposing (..)


type alias Komposition =
    { name : String
    , revision : String

    --, config: Config
    , mediaFile : Mediafile
    , segments : List Segment
    }


type alias Mediafile =
    { fileName : String
    , startingOffset : Float
    , checksum : String
    }


type alias Segment =
    { id : String
    , start : Int
    , end : Int
    }
