module App exposing (main, init, update, view)

import Html exposing (Html, div, text)
import RemoteData exposing (succeed, isLoading, RemoteData(..))
import Navigation exposing (Location)
import Models.MsgModel exposing (Msg(..), Model, Config)
import Navigation.AppRouting as AppRouting exposing (navigateTo, Page(Listings, Kompost, NotFound))
import Models.KompostModels exposing (Komposition, Segment)
import Models.KompostApi exposing (getKomposition, updateKompo)
import UI.SegmentUI exposing (..)
import UI.KompostUI exposing (..)
import UI.KompostListingsUI exposing (..)
import UI.DvlSpecificsUI exposing (..)
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.CDN as CDN


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( { listings = RemoteData.Loading
      , kompost = testKomposition
      , dvlId = Nothing
      , activePage = AppRouting.Listings
      , isLoading = True
      , editableSegment = False
      , segment = Segment "SegmentId" 1 2
      }
    , Cmd.batch [ getListings ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "Debugmsg " msg of
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

        GotoKompositionPage ->
            model ! [navigateTo Kompost]

        ChooseDvl id ->
            { model | dvlId = Just id, activePage = Kompost } ! [ getKomposition id ]

        KompositionUpdated webKomposition ->
            let newModel = case RemoteData.toMaybe webKomposition of
                                Just kompost -> { model | kompost = kompost}
                                _ -> model
            in newModel ! [ navigateTo Kompost ]

        StoreKomposition ->
                model ! [updateKompo model.kompost]

        EditSpecifics ->
            model ! [ navigateTo AppRouting.DvlSpecificsUI ]

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

        CreateSegment ->
            let
                editableModel  = {model | editableSegment = True }
            in
                editableModel ! [ navigateTo AppRouting.Segment ]

        EditSegment id ->
                    let
                        segment = case (containsSegment id model.kompost) of
                            [ segment ] -> segment
                            _ -> model.segment
                    in
                        { model | segment = segment, editableSegment=False } ! [ navigateTo AppRouting.Segment ]

        UpdateSegment ->
            case (containsSegment model.segment.id model.kompost) of
                [] ->
                    Debug.log "Adding segment []: " performSegmentOnModel model.segment UI.SegmentUI.addSegmentToKomposition model ! [ navigateTo Kompost ]

                [ x ] ->
                    let
                        deleted = performSegmentOnModel model.segment UI.SegmentUI.deleteSegmentFromKomposition model
                        addedTo = performSegmentOnModel model.segment UI.SegmentUI.addSegmentToKomposition deleted
                    in
                        Debug.log "Updating segment [x]: "  addedTo ! [ navigateTo Kompost ]

                head :: tail ->
                    Debug.log "Seggie heads tails: " model ! [ navigateTo Kompost ]

        DeleteSegment ->
            Debug.log "Deleting segment: " performSegmentOnModel model.segment UI.SegmentUI.deleteSegmentFromKomposition model ! [ navigateTo Kompost ]

        CouchServerStatus serverstatus ->
            let (newModel, navigation) = case RemoteData.toMaybe serverstatus of
                    Just status ->
                        let kompost = model.kompost
                        in ({ model | kompost = { kompost | revision = status.rev} }, Kompost)
                    _ -> (model, NotFound)
            in newModel ! [ navigateTo navigation ]

        DvlSpecificsMsg msg ->
                    let
                        (newModel, cmd, childMsg) = UI.DvlSpecificsUI.update msg model
                        cmds = case UI.DvlSpecificsUI.extractFromOutmessage childMsg of
                            Just page -> [navigateTo page]
                            Nothing ->  []
                    in
                        newModel ! cmds

---- VIEW ----


uiConfig : Model -> Config Msg
uiConfig model =
    { onClickViewListings = NavigateTo Listings
    , onClickChooseDvl = ChooseDvl
    , onClickgotoKompositionPage = GotoKompositionPage
    , onClickCreateSegment = CreateSegment
    , onClickEditSegment = EditSegment
    , onClickUpdateSegment = UpdateSegment
    , onClickDeleteSegment = DeleteSegment
    , onClickSetSegmentID = SetSegmentId
    , onClickSetSegmentStart = SetSegmentStart
    , onClickSetSegmentEnd = SetSegmentEnd
    , onClickEditSpecifics = EditSpecifics
    , onClickStoreKomposition = StoreKomposition
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
                pageWrapper <| UI.SegmentUI.segmentForm (uiConfig model) model.editableSegment

            AppRouting.DvlSpecificsUI ->
                Html.map DvlSpecificsMsg(pageWrapper <| UI.DvlSpecificsUI.editSpecifics model.kompost)

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



-- Offline testdata
--testListings = MsgModel.DataRepresentation 1 0 [testRow]
--testRow = MsgModel.Row "id123" "key123"

testKomposition = Models.KompostModels.Komposition "Name" "Revision01" (Just "123") testMediaFile [testSegment1, testSegment2]
--initModel = Model "dvlRef" "name" "revision" 0 1234  testConfig testMediaFile [testSegment1, testSegment2]
--testConfig = MsgModel.Config 1280 1080 24 "mp4" 1234
testMediaFile = Models.KompostModels.Mediafile "https://www.youtube.com/watch?v=Scxs7L0vhZ4" 0 "A Checksum"
testSegment1 = Segment "Purple Mountains Clouds" 7541667 19750000
testSegment2 = Segment "Besseggen" 21250000  27625000

