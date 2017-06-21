module Models.MsgModel exposing (Msg(..), Model, Config)

import RemoteData exposing (WebData)
import Navigation.AppRouting exposing (Page)
import Navigation exposing (Location)
import Models.KompostModels exposing (Komposition, Segment)
import Models.KompostListing exposing (DataRepresentation)


---- MODEL ----


type alias Model =
    { listings : WebData ( DataRepresentation)
    , kompost : WebData (Komposition)
    , dvlId: Maybe String
    , activePage : Page
    , isLoading : Bool
    , segment : Segment
    }


type Msg
    = NoOp
    | ListingsUpdated (WebData ( DataRepresentation))
    | LocationChanged Location
    | NavigateTo Page
    | ChooseDvl String
    | EditSegment String
    | ShowTestpage
    | KompositionUpdated (WebData ( Komposition))
    | SetSegmentId String
    | SetSegmentStart String
    | SetSegmentEnd String
    | UpdateSegment




{-| The config contains functions and messages that the UI can use to send messages to the update function,
as well as some other necessary information for rendering the rest of the UI.
-}
type alias Config msg =
    { onClickViewListings : msg
    , onClickChooseDvl : String ->  msg
    , onClickEditSegment : String ->  msg
    , onClickUpdateSegment : msg
    , onClickSetSegmentID : String ->  msg
    , onClickSetSegmentStart : String ->  msg
    , onClickSetSegmentEnd : String ->  msg
    , onClickGotoTestpage : msg
    , listings : WebData ( DataRepresentation)
    , kompost : WebData (Komposition)
    , loadingIndicator : Bool
    , segment : Segment
    }