module App exposing (main, init, update, view)

import View exposing (products, cart)
import Html exposing (Html, div, text)
import RemoteData exposing (succeed, isLoading, RemoteData(..))
import Navigation exposing (Location)
import MsgModel exposing (Msg(..), Model, Product)
import AppRouting exposing (navigateTo, Page(Home, Cart, Listings, Kompost, NotFound))
import AppRemoting exposing (getProducts, getCart, addToCart, removeFromCart)
import Models.Listings exposing (..)
import Models.SegmentUI exposing(..)
import Models.Kompost exposing(..)
import Models.Listings exposing(..)
import Models.KompostModels exposing (Komposition, Segment)


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( { products = RemoteData.Loading
      , cart = RemoteData.Loading
      , listings = RemoteData.Loading
      , kompost = succeed testKomposition
      , dvlId = Nothing
      , activePage = AppRouting.Kompost
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

        EditSegment id ->
            let
                seg2 = model.segment
                segment = { seg2 | id = id}
            in
                { model | segment = segment } ! [ navigateTo AppRouting.Segment ]

        KompositionUpdated komposition ->
            { model | kompost = komposition } ! [ navigateTo Kompost ]

        SetSegmentId id ->
            let newModel = id
              |> asIdIn model.segment
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

        UpdateSegment ->
            case (containsSegment model.segment.id model.kompost) of
                [] -> Debug.log "Seggie []: " addSegment  model.segment model ! [navigateTo Kompost]
                [x] ->
                    let
                        listOfStuff = everythingButTheSegment model.segment.id model.kompost
                        _ = Debug.log "Single [x]: " listOfStuff
                        model2 = addSegment (Segment model.segment.id model.segment.start model.segment.end) model
                    in
                        model2 ! [navigateTo Kompost]
                head :: tail -> Debug.log "Seggie heads tails: " model ! [navigateTo Kompost]

containsSegment: String ->  RemoteData.WebData Komposition -> List Models.KompostModels.Segment
containsSegment id webKomposition =
    case RemoteData.toMaybe webKomposition of
        Just komposition ->  List.filter  (\ seg -> seg.id == id ) komposition.segments
        _ -> [] --Is it a problem if we've not loaded data from server?



everythingButTheSegment: String ->  RemoteData.WebData Komposition -> List Models.KompostModels.Segment
everythingButTheSegment id webKomposition =
    case RemoteData.toMaybe webKomposition of
        Just komposition ->  List.filter  (\ seg -> not (seg.id == id )) komposition.segments
        _ -> [] --Is it a problem if we've not loaded data from server?




addSegment: Segment -> Model ->  Model
addSegment segment model =
    let
        newSegment = (Models.KompostModels.Segment segment.id segment.start segment.end)
        newKomp = {testKomposition | segments = testKomposition.segments++ [newSegment]}
    in
         {model | kompost = succeed newKomp }

---- VIEW ----


uiConfig : Model -> MsgModel.Config Msg
uiConfig model =
    { onAddToCart = AddToCart
    , onRemoveFromCart = RemoveFromCart
    , onClickViewCart = NavigateTo Cart
    , onClickViewListings = NavigateTo Listings
    , onClickViewProducts = NavigateTo Home
    , onClickChooseDvl = ChooseDvl
    , onClickEditSegment = EditSegment
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
            AppRouting.Home ->
                View.products <| uiConfig model

            AppRouting.Cart ->
                View.cart <| uiConfig model

            AppRouting.Listings ->
                Models.Listings.listings <| uiConfig model

            AppRouting.Kompost ->
                Models.Kompost.kompost <| uiConfig model

            AppRouting.Segment ->
                Models.SegmentUI.segmentForm <| uiConfig model

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

{-- Offline testdata
testListings = MsgModel.DataRepresentation 1 0 [testRow]
testRow = MsgModel.Row "id123" "key123"

testKomposition = Models.KompostModels.Komposition "Name" "Revision01" testMediaFile [testSegment1, testSegment2]
initModel = Model "dvlRef" "name" "revision" 0 1234  testConfig testMediaFile [testSegment1, testSegment2]
testConfig = MsgModel.Config 1280 1080 24 "mp4" 1234
testMediaFile = Models.KompostModels.Mediafile "https://www.youtube.com/watch?v=Scxs7L0vhZ4" 0 "A Checksum"
testSegment1 = Segment "Purple Mountains Clouds" 7541667 19750000
testSegment2 = Segment "Besseggen" 21250000  27625000
--}
testKomposition = Models.KompostModels.Komposition "Name" "Revision01" testMediaFile []
testSegment1 = Segment "Purple Mountains Clouds" 7541667 19750000
testSegment2 = Segment "Besseggen" 21250000  27625000
testMediaFile = Models.KompostModels.Mediafile "https://www.youtube.com/watch?v=Scxs7L0vhZ4" 0 "A Checksum"