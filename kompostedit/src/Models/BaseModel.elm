module Models.BaseModel exposing (..)

import Navigation.AppRouting exposing (Page)
import RemoteData exposing (WebData)
import Set


type alias Model =
    { listings : WebData DataRepresentation
    , kompost : Komposition
    , statusMessage : List String
    , activePage : Page
    , editableSegment : Bool
    , segment : Segment
    , editingMediaFile : Source
    , subSegmentList : Set.Set String
    , showSnippets : Bool
    }


type alias Komposition =
    { name : String
    , revision : String
    , dvlType : String
    , bpm : Float
    , segments : List Segment
    , sources : List Source
    , config : VideoConfig
    , beatpattern : Maybe BeatPattern --Only used by komposition
    }


type alias Source =
    { id : String
    , url : String
    , startingOffset : Float
    , checksum : String
    , extensionType : String
    , mediaType : String
    , isSnippet : Bool
    }


type alias Segment =
    { id : String
    , sourceId : String
    , start : Int
    , duration : Int
    , end : Int
    }

type alias SegmentGap =
    { id: String
    , isGap: Bool
    , start: Int
    , end: Int
    }


type alias VideoConfig =
    { width : Int
    , height : Int
    , framerate : Int
    , extensionType : String
    }


type alias BeatPattern =
    { fromBeat : Int
    , toBeat : Int
    , masterBPM : Float
    }



{--Status from Couch server --}


type alias CouchStatusMessage =
    { id : String
    , ok : Bool
    , rev : String
    }



{--Listings --}


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
