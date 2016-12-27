module Models.KompostModels exposing (..)

type alias Model =
  { name: String
  , start: Int
  , end: Int
  , config: Config
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
  , startingOffset: Int
  , checksum: String
  --, extension: String
  }

type alias Segment =
  { id: String
  , start: Int
  , end: Int
  }