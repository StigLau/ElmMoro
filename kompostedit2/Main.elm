module App exposing (main, init, update, view)

import View exposing (products, cart, kompost)
import Html exposing (Html, div, text)
import RemoteData exposing (isLoading)
import Navigation exposing (Location)
import MsgModel exposing (Msg(..), Model, Product, Segment)
import AppRouting exposing (navigateTo, Page(Home, Cart, Listings, Kompost, NotFound))
import AppRemoting exposing (getProducts, getCart, addToCart, removeFromCart, getKomposition)
import Models.Listings exposing (..)


---- UPDATE ----


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( { products = RemoteData.Loading
      , cart = RemoteData.Loading
      , listings = RemoteData.Loading
      , kompost = RemoteData.Loading
      , dvlId = Nothing
      , activePage = AppRouting.Listings
      , isLoading = True
      , segment = Segment "SegmentId" 1 2
      }
    , Cmd.batch [ getProducts, getCart, getListings ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "Debugmsg: " msg of
        NoOp ->
            model ! []

        ProductsChanged newWebData ->
            { model
                | products = newWebData
                , isLoading = False
            }
                ! []

        ListingsUpdated newWebData ->
            { model
                | listings = newWebData
                , isLoading = False
            }
                ! []

        CartChanged newWebData ->
            { model
                | cart = newWebData
                , isLoading = False
            }
                ! []

        AddToCart id ->
            { model | isLoading = True } ! [ addToCart id ]

        RemoveFromCart id ->
            { model | isLoading = True } ! [ removeFromCart id ]

        LocationChanged loc ->
            { model | activePage = AppRouting.routeFromLocation loc } ! []

        NavigateTo page ->
            model ! [ navigateTo page ]

        ChooseDvl id ->
            let _ = Debug.log "Chose DVL and ready to load komposition " id
            in
                { model | dvlId = Just id, activePage = Kompost } ! [ getKomposition id ]

        KompositionUpdated komposition ->
            { model | kompost = komposition } ! [ navigateTo Kompost ]

        SetSegmentName name ->
            let newModel = name
              |> asNameIn model.segment
              |> asCurrentSegmentIn model
            in
                newModel ! []

        SetSegmentStart start ->
            let newModel = start
              |> asStartIn model.segment
              |> asCurrentSegmentIn model
            in
                newModel ! []

        SetSegmentEnd end ->
            let newModel = end
              |> asEndIn model.segment
              |> asCurrentSegmentIn model
            in
                newModel ! []

asStartIn : Segment -> String -> Segment
asStartIn = flip setStart

setStart : String -> Segment -> Segment
setStart newStart segment = { segment | start = ( validNr newStart ) }

asEndIn : Segment -> String -> Segment
asEndIn = flip setEnd

setEnd : String -> Segment -> Segment
setEnd newEnd segment = { segment | end = ( validNr newEnd ) }


asNameIn : Segment -> String -> Segment
asNameIn = flip setName

setName : String -> Segment -> Segment
setName newName segment = { segment | name = newName }




setCurrentSegment : Segment -> Model -> Model
setCurrentSegment newSegment model = { model | segment = newSegment }

asCurrentSegmentIn : Model -> Segment -> Model
asCurrentSegmentIn = flip setCurrentSegment


validNr : String -> Int
validNr value =
  case String.toInt value of
    Ok int ->
      int
    Err _ ->
      -1

---- VIEW ----


uiConfig : Model -> MsgModel.Config Msg
uiConfig model =
    { onAddToCart = AddToCart
    , onRemoveFromCart = RemoveFromCart
    , onClickViewCart = NavigateTo Cart
    , onClickViewListings = NavigateTo Listings
    , onClickViewProducts = NavigateTo Home
    , onClickChooseDvl = ChooseDvl
    , products = model.products
    , cart = model.cart
    , listings = model.listings
    , kompost = model.kompost
    , loadingIndicator = True
    , segment = model.segment
    }


view : Model -> Html MsgModel.Msg
view model =
    div []
        [ case model.activePage of
            Home ->
                View.products <| uiConfig model

            Cart ->
                View.cart <| uiConfig model

            Listings ->
                View.listings <| uiConfig model

            Kompost ->
                View.kompost <| uiConfig model

            NotFound ->
                div [] [ text "Sorry, nothing here :(" ]
        ]



---- PROGRAM ----


main : Program Never Model MsgModel.Msg
main =
    Navigation.program LocationChanged
        { view = view
        , init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        }
