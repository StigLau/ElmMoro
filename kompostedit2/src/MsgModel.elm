module MsgModel exposing (Msg(..), Model, Config, Product, DataRepresentation, Row, Segment)

import RemoteData exposing (WebData)
import AppRouting exposing (Page)
import Navigation exposing (Location)
import Models.KompostModels exposing (Komposition)


---- MODEL ----


type alias Model =
    { products : WebData (List Product)
    , cart : WebData (List Product)
    , listings : WebData ( DataRepresentation)
    , kompost : WebData (Komposition)
    , dvlId: Maybe String
    , activePage : Page
    , isLoading : Bool
    , segment : Segment
    }


type Msg
    = NoOp
    | ProductsChanged (WebData (List Product))
    | CartChanged (WebData (List Product))
    | ListingsUpdated (WebData ( DataRepresentation))
    | AddToCart String
    | RemoveFromCart String
    | LocationChanged Location
    | NavigateTo Page
    | ChooseDvl String
    | EditSegment String
    | KompositionUpdated (WebData ( Komposition))
    | SetSegmentName String
    | SetSegmentStart String
    | SetSegmentEnd String
    | UpdateSegment


{-| A Product isn't too complex. It's got an id, a name, an image, and it costs a few tacos. Yum, 🌮s.
-}
type alias Product =
    { id : String
    , displayName : String
    , tacos : Float
    , image : String
    }


{-| The config contains functions and messages that the UI can use to send messages to the update function,
as well as some other necessary information for rendering the rest of the UI.
-}
type alias Config msg =
    { onAddToCart : String -> msg
    , onRemoveFromCart : String -> msg
    , onClickViewCart : msg
    , onClickViewListings : msg
    , onClickViewProducts : msg
    , onClickChooseDvl : String ->  msg
    , onClickEditSegment : String ->  msg
    , products : WebData (List Product)
    , cart : WebData (List Product)
    , listings : WebData ( DataRepresentation)
    , kompost : WebData (Komposition)
    , loadingIndicator : Bool
    , segment : Segment
    }


type alias DataRepresentation =
  { total_rows: Int
  , offset: Int
  , rows: List Row
  }

type alias Row =
    { id: String
    , key: String
    }

type alias Segment =
    { name : String
    , start : Int
    , end : Int
    }