module Messages exposing (..)

import Model exposing (..)
import Http
import JsonDecoding exposing  (..)

type Msg
    = SetSegmentName String
    | SetSegmentStart String
    | SetSegmentEnd String
    | DeleteSegment Segment
    | Create
    | Save
    | FetchSuccess JsonKomposition
    | FetchFail Http.Error
    | FetchKomposition