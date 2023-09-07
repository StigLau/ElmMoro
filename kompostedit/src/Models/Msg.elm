module Models.Msg exposing (Msg(..))

import Http exposing (Error)
import Models.BaseModel exposing (..)
import Browser exposing (UrlRequest(..))
import Navigation.Page exposing (Page)
import RemoteData exposing (WebData)
import Source.Msg
import DvlSpecifics.Msg
import Url exposing (Url)
import Segment.Msg


type Msg
    = ListingsUpdated (WebData DataRepresentation)
    | NavigateTo Page
    | ChooseDvl String
    | KompositionMetadataFromYT String
    | EditSpecifics
    | NewKomposition
    | ChangeKompositionType String
    | StoreKomposition
    | DeleteKomposition
    | KompositionUpdated (WebData Komposition)
    | SourceUpdated (WebData Komposition)
    | SegmentListUpdated (WebData Komposition)
    | CreateSegment
    | CouchServerStatus (WebData CouchStatusMessage)
    | SourceMsg Source.Msg.Msg
    | DvlSpecificsMsg DvlSpecifics.Msg.Msg
    | SegmentMsg Segment.Msg.Msg
    | ETagResponse (Result Http.Error String)
    | CreateVideo
    | ShowKompositionJson
    | ClickedLink UrlRequest
    | ChangedUrl Url
