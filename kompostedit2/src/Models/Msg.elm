module Models.Msg exposing (Msg(..))

import Models.BaseModel exposing (..)
import RemoteData exposing (WebData)
import Navigation.AppRouting exposing (Page)
import Navigation exposing (Location)
import Models.DvlSpecificsModel exposing (Msg)
import Segment.Model exposing (Msg)

---- MODEL ----




type Msg
    = NoOp
    | ListingsUpdated (WebData DataRepresentation)
    | LocationChanged Location
    | NavigateTo Page
    | ChooseDvl String
    | EditSpecifics
    | NewKomposition
    | StoreKomposition
    | KompositionUpdated (WebData Komposition)
    | CreateSegment
    | CouchServerStatus (WebData CouchStatusMessage)
    | DvlSpecificsMsg Models.DvlSpecificsModel.Msg
    | SegmentMsg Segment.Model.Msg