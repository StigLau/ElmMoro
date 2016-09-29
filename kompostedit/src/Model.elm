module Model exposing (..)

import Random exposing (..)

--Komposition and segments

type alias DvlKomposition =
  { reference: String
  , start: String
  , mediaFile: MediaFile
  , segments: List Segment
  }

type alias MediaFile =
  { fileName: String
  , extension: String
  }

type alias Segment =
  { id: String
  , start: Int
  , end: Int
  }


testMediaFile = MediaFile "https://www.youtube.com/watch?v=Scxs7L0vhZ4" "mp4"
testSegment1 = Segment "Purple Mountains Clouds" 7541667 19750000
testSegment2 = Segment "Besseggen" 21250000  27625000


--End Komposition and segments



initModel : DvlKomposition
initModel =

    DvlKomposition "NORWAY-A_Time-Lapse_Adventure" "2" testMediaFile [testSegment1, testSegment2]

