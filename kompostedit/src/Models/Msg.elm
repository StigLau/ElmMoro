module Models.Msg exposing (Msg(..))

import Browser exposing (UrlRequest(..))
import DvlSpecifics.Msg
import Http exposing (Error)
import Models.BaseModel exposing (..)
import MultimediaSearch.MultimediaSearch
import Navigation.Page exposing (Page)
import RemoteData exposing (WebData)
import Segment.Msg
import Source.Msg
import Url exposing (Url)


type Msg
    = ListingsUpdated (WebData DataRepresentation)
    | NavigateTo Page
    | FetchLocalIntegration IntegrationDestination
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
    | ChangedIntegrationId String
    | ChangedIntegrationFormat String
    | ShowMultimediaSearch
    | MultimediaSearchMsg MultimediaSearch.MultimediaSearch.Msg
    | MultimediaApiResponse (Result Http.Error (List Source))
