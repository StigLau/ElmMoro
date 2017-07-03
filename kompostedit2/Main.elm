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
      , kompost = RemoteData.Loading --succeed testKomposition
      , dvlId = Nothing
      , activePage = AppRouting.Listings --AppRouting.Kompost
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
            let
                _ =
                    Debug.log "Chose DVL and ready to load komposition " id
            in
                { model | dvlId = Just id, activePage = Kompost } ! [ getKomposition id ]

        KompositionUpdated komposition ->
            { model | kompost = komposition } ! [ navigateTo Kompost ]

        StoreKomposition ->
            let
                kompo = case RemoteData.toMaybe model.kompost of
                    Just kompo -> kompo
                    _ -> testKomposition
            in
                model ! [updateKompo kompo]

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
            let (navigation, rev) = case RemoteData.toMaybe serverstatus of
                         Just status ->  (Kompost, status.rev)
                         _ -> (NotFound, "")
                _ = Debug.log "new Revision" rev

                kompost = case RemoteData.toMaybe model.kompost of
                    Just komposition -> komposition
                    _ -> testKomposition
                kompost2 = { kompost | revision = rev}
                model2 = { model | kompost = succeed kompost2 }
            in model2 ! [ navigateTo navigation ]

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
                case RemoteData.toMaybe model.kompost of
                    Just komposition ->
                        pageWrapper <| UI.DvlSpecificsUI.editSpecifics komposition (uiConfig model)
                    _ ->
                        text "Komposition not rendereable"

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

