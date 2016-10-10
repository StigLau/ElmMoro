module Model exposing (..)

import Random exposing (..)

--Komposition and segments

type alias Model =
  { name: String
  , start: String
  , end: String
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


--End Komposition and segments
initModel : Model
initModel = Model "" "" "" testConfig testMediaFile [testSegment1, testSegment2]

testConfig = Config 1280 1080 24 "mp4" 1234
testMediaFile = Mediafile "https://www.youtube.com/watch?v=Scxs7L0vhZ4" 0 "A Checksum"
testSegment1 = Segment "Purple Mountains Clouds" 7541667 19750000
testSegment2 = Segment "Besseggen" 21250000  27625000
