module App exposing (main, init, update, view)

import Html exposing (Html, div, text)
import RemoteData exposing (succeed, isLoading, RemoteData(..))
import Navigation exposing (Location)
import Models.MsgModel exposing (Msg(..), Model, Config)
import Navigation.AppRouting as AppRouting exposing (navigateTo, Page(Listings, Kompost, NotFound))
import Models.KompostModels exposing (Komposition, Segment)
import Models.KompostApi exposing (getKomposition)
import UI.SegmentUI exposing (..)
import UI.KompostUI exposing (..)
import UI.KompostListingsUI exposing (..)
import UI.MakeShitApp exposing (..)
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.CDN as CDN


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( { listings = RemoteData.Loading
      , kompost = RemoteData.Loading --succeed testKomposition
      , dvlId = Nothing
      , activePage = AppRouting.Listings --AppRouting.Kompost
      , isLoading = True
      , segment = Segment "SegmentId" 1 2
      }
    , Cmd.batch [ getListings ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "Debugmsg: " msg of
        NoOp ->
            model ! []

        ListingsUpdated newWebData ->
            { model
                | listings = newWebData
                , isLoading = False
            }
                ! []

        LocationChanged loc ->
            { model | activePage = AppRouting.routeFromLocation loc } ! []

        NavigateTo page ->
            model ! [ navigateTo page ]

        ChooseDvl id ->
            let
                _ =
                    Debug.log "Chose DVL and ready to load komposition " id
            in
                { model | dvlId = Just id, activePage = Kompost } ! [ getKomposition id ]

        EditSegment id ->
            let
                seg2 =
                    model.segment

                segment =
                    { seg2 | id = id }
            in
                { model | segment = segment } ! [ navigateTo AppRouting.Segment ]

        KompositionUpdated komposition ->
            { model | kompost = komposition } ! [ navigateTo Kompost ]

        ShowTestpage ->
            model ! [ navigateTo AppRouting.MakeShitApp ]

        SetSegmentId id ->
            let
                newModel =
                    id
                        |> asIdIn model.segment
                        |> asCurrentSegmentIn model
            in
                newModel ! []

        SetSegmentStart start ->
            let
                newModel =
                    start
                        |> asStartIn model.segment
                        |> asCurrentSegmentIn model
            in
                newModel ! []

        SetSegmentEnd end ->
            let
                newModel =
                    end
                        |> asEndIn model.segment
                        |> asCurrentSegmentIn model
            in
                newModel ! []

        UpdateSegment ->
            case (containsSegment model.segment.id model.kompost) of
                [] ->
                    Debug.log "Seggie []: " performSegmentOnModel model.segment UI.SegmentUI.addSegmentToKomposition model ! [ navigateTo Kompost ]

                [ x ] ->
                    performSegmentOnModel (Segment model.segment.id model.segment.start model.segment.end) UI.SegmentUI.addSegmentToKomposition model ! [ navigateTo Kompost ]

                head :: tail ->
                    Debug.log "Seggie heads tails: " model ! [ navigateTo Kompost ]

        DeleteSegment ->
            Debug.log "Deleting segment: " performSegmentOnModel model.segment UI.SegmentUI.addSegmentToKomposition model ! [ navigateTo Kompost ]



---- VIEW ----


uiConfig : Model -> Config Msg
uiConfig model =
    { onClickViewListings = NavigateTo Listings
    , onClickChooseDvl = ChooseDvl
    , onClickEditSegment = EditSegment
    , onClickUpdateSegment = UpdateSegment
    , onClickDeleteSegment = DeleteSegment
    , onClickSetSegmentID = SetSegmentId
    , onClickSetSegmentStart = SetSegmentStart
    , onClickSetSegmentEnd = SetSegmentEnd
    , onClickGotoTestpage = ShowTestpage
    , listings = model.listings
    , kompost = model.kompost
    , loadingIndicator = True
    , segment = model.segment
    }


view : Model -> Html Msg
view model =
    div []
        [ case model.activePage of
            AppRouting.Listings ->
                pageWrapper <| UI.KompostListingsUI.listings <| uiConfig model

            AppRouting.Kompost ->
                pageWrapper <| UI.KompostUI.kompost <| uiConfig model

            AppRouting.Segment ->
                pageWrapper <| UI.SegmentUI.segmentForm (uiConfig model) False

            AppRouting.MakeShitApp ->
                pageWrapper <| UI.MakeShitApp.gridForm <| uiConfig model

            NotFound ->
                div [] [ text "Sorry, nothing here :(" ]
        ]


pageWrapper : Html msg -> Html msg
pageWrapper forwaredPage =
    Grid.container []
        [ CDN.stylesheet
        , CDN.fontAwesome
        , forwaredPage
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Navigation.program LocationChanged
        { view = view
        , init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        }



{--Offline testdata
testListings = MsgModel.DataRepresentation 1 0 [testRow]
testRow = MsgModel.Row "id123" "key123"

testKomposition = Models.KompostModels.Komposition "Name" "Revision01" testMediaFile [testSegment1, testSegment2]
initModel = Model "dvlRef" "name" "revision" 0 1234  testConfig testMediaFile [testSegment1, testSegment2]
testConfig = MsgModel.Config 1280 1080 24 "mp4" 1234
testMediaFile = Models.KompostModels.Mediafile "https://www.youtube.com/watch?v=Scxs7L0vhZ4" 0 "A Checksum"
testSegment1 = Segment "Purple Mountains Clouds" 7541667 19750000
testSegment2 = Segment "Besseggen" 21250000  27625000
--}
