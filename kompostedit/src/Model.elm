module Model exposing (..)

import Random exposing (..)

--Komposition and segments

type alias Model =
  { name: String
  , start: String
  , end: String
  , mediaFile: Mediafile
  , segments: List Segment
  }

type alias Komposition =
  { mediaFile: Mediafile
  , segments: List Segment
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


testMediaFile = Mediafile "https://www.youtube.com/watch?v=Scxs7L0vhZ4" 0 "A Checksum" --"mp4"
testSegment1 = Segment "Purple Mountains Clouds" 7541667 19750000
testSegment2 = Segment "Besseggen" 21250000  27625000


--End Komposition and segments



initModel : Model
initModel = Model "" "" "" testMediaFile [testSegment1, testSegment2]

