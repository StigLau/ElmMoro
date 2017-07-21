module Models.BaseModel exposing (..)

import Navigation.AppRouting exposing (Page)
import RemoteData exposing (WebData)
import Set


type alias Model =
    { listings : WebData DataRepresentation
    , kompost : Komposition
    , statusMessage: List String
    , activePage : Page
    , editableSegment : Bool
    , segment : Segment
    , editingMediaFile: Mediafile
    , subSegmentList: (Set.Set String)
    }

type alias Komposition =
    { name : String
    , revision : String
    , bpm : Float

    --, config: Config
    , segments : List Segment
    , sources : List Mediafile
    }


type alias Mediafile =
    { id: String
    , url : String
    , startingOffset : Float
    , checksum : String
    }


type alias Segment =
    { id : String
    , start : Int
    , end : Int
    }

{-- Status from Couch server --}
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

{--Navigation between pages--}
type OutMsg
    = OutNavigateTo Page
