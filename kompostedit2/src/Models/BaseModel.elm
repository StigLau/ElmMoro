module Models.BaseModel exposing (..)

import Navigation.AppRouting exposing (Page)
import RemoteData exposing (WebData)


type alias Model =
    { listings : WebData DataRepresentation
    , kompost : Komposition
    , dvlId : Maybe String
    , activePage : Page
    , isLoading : Bool
    , editableSegment : Bool
    , segment : Segment
    }

type alias Komposition =
    { name : String
    , revision : String
    , bpm : String

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

type alias CouchStatusMessage =
    { id: String
    , ok: Bool
    , rev: String
    }



{-- Listings --}

type alias DataRepresentation =
    { total_rows : Int
    , offset : Int
    , rows : List Row
    }


type alias Row =
    { id : String
    , key : String
    }