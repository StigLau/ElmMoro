module Models.BaseModel exposing (BeatPattern, CouchStatusMessage, DataRepresentation, Komposition, Model, OutMsg(..), Row, Segment, SegmentGap, Source, VideoConfig, IntegrationDestination, Focused(..))

import Navigation.Page exposing (Page)
import Set
import Url exposing (Url)
import Browser.Navigation
import Common.AutoComplete as AutoComplete



type alias Model =
    { listings : DataRepresentation
    , kompost : Komposition
    , statusMessage : List String
    , activePage : Page
    , editableSegment : Bool
    , checkboxVisible : Bool --Used to show source/Segment search
    , segment : Segment
    , editingMediaFile : Source
    , subSegmentList : Set.Set String
    , key : Browser.Navigation.Key
    , url : Url.Url
    , accessibleAutocomplete : AutoComplete.Model
    , currentFocusAutoComplete : Focused
    , apiToken : String
    , integrationDestination : String
    , kompoUrl : String
    , metaUrl : String
    }

type Focused
    = Simple
    | None


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
    , format : String
    , extensionType : String
    , mediaType : String
    }


type alias Segment =
    { id : String
    , sourceId : String
    , start : Int
    , duration : Int
    , end : Int
    }


type alias SegmentGap =
    { id : String
    , start : Int
    , width : Int
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
    { docs : List Row
    , warning : String
    , bookmark : String
    }


type alias Row =
    { id : String
    , rev : String
    }

type alias IntegrationDestination =
    { id: String
    , urlPart: String
    }

{--Navigation between pages--}


type OutMsg
    = OutNavigateTo Page
    | FetchSourceListMsg String
