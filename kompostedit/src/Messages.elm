module Messages exposing (..)

import Model exposing (..)

type Msg
    = SetSegmentName String
    | SetSegmentStart String
    | SetSegmentEnd String
    | DeleteSegment Segment
    | Create
    | Save
--    | Cancel
