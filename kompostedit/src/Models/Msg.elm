module Models.Msg exposing (Msg(..))

import DvlSpecifics.Msg exposing (Msg)
import Http exposing (Error)
import Models.BaseModel exposing (..)
import Browser exposing (UrlRequest(..))
import Browser.Navigation
import Navigation.AppRouting exposing (Page)
import RemoteData exposing (WebData)
import Segment.Model exposing (Msg)
import Url exposing (Url)


type Msg
    = ListingsUpdated (WebData DataRepresentation)
    | LocationChanged Browser.Navigation.Key
    | NavigateTo Page
    | ChooseDvl String
    | EditSpecifics
    | NewKomposition
    | ChangeKompositionType String
    | StoreKomposition
    | DeleteKomposition
    | KompositionUpdated (WebData Komposition)
    | SegmentListUpdated (WebData Komposition)
    | CreateSegment
    | CouchServerStatus (WebData CouchStatusMessage)
    | DvlSpecificsMsg DvlSpecifics.Msg.Msg
    | SegmentMsg Segment.Model.Msg
    | ETagResponse (Result Http.Error String)
    | CreateVideo
    | ShowKompositionJson
    | ClickedLink UrlRequest
    | ChangedUrl Url
