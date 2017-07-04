module Models.MsgModel exposing (Msg(..), Model, Config)

import RemoteData exposing (WebData)
import Navigation.AppRouting exposing (Page)
import Navigation exposing (Location)
import Models.KompostModels exposing (Komposition, Segment, CouchStatusMessage)
import Models.KompostListing exposing (DataRepresentation)
import Models.DvlSpecificsModel exposing (Msg)


---- MODEL ----


type alias Model =
    { listings : WebData DataRepresentation
    , kompost : Komposition
    , dvlId : Maybe String
    , activePage : Page
    , isLoading : Bool
    , editableSegment : Bool
    , segment : Segment
    }


type Msg
    = NoOp
    | ListingsUpdated (WebData DataRepresentation)
    | LocationChanged Location
    | NavigateTo Page
    | ChooseDvl String
    | GotoKompositionPage
    | EditSegment String
    | EditSpecifics
    | KompositionUpdated (WebData Komposition)
    | CouchServerStatus (WebData CouchStatusMessage)
    | SetSegmentId String
    | SetSegmentStart String
    | SetSegmentEnd String
    | CreateSegment
    | UpdateSegment
    | DeleteSegment
    | StoreKomposition
    | DvlSpecificsMsg Models.DvlSpecificsModel.Msg


{-| The config contains functions and messages that the UI can use to send messages to the update function,
as well as some other necessary information for rendering the rest of the UI.
-}
type alias Config msg =
    { onClickViewListings : msg
    , onClickChooseDvl : String -> msg
    , onClickgotoKompositionPage : msg
    , onClickEditSegment : String -> msg
    , onClickCreateSegment : msg
    , onClickUpdateSegment : msg
    , onClickDeleteSegment : msg
    , onClickSetSegmentID : String -> msg
    , onClickSetSegmentStart : String -> msg
    , onClickSetSegmentEnd : String -> msg
    , onClickEditSpecifics : msg
    , onClickStoreKomposition : msg
    , listings : WebData DataRepresentation
    , kompost : Komposition
    , loadingIndicator : Bool
    , segment : Segment
    }
