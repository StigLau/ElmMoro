module Segment.Msg exposing (..)

type Msg
    = SetSegmentId String
    | SetSourceId String
    | SetSegmentStart String
    | SetSegmentEnd String
    | SetSegmentDuration String
    | EditSegment String
    | UpdateSegment
    | DeleteSegment
    | FetchAndLoadMediaFile String
    | SegmentSearchVisible Bool
