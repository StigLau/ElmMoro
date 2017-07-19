module Main exposing (main, init, update, view)

import Html exposing (Html, div, text)
import RemoteData exposing (succeed, RemoteData(..))
import Navigation exposing (Location)
import Models.Msg exposing (Msg(..))
import Models.BaseModel exposing (..)
import Models.DvlSpecificsModel exposing (update, extractFromOutmessage)
import Models.KompostApi exposing (getKomposition,getDvlSegmentList, updateKompo, createKompo, deleteKompo, getDataFromRemoteServer)
import Segment.SegmentUI exposing (segmentForm)
import Segment.Model exposing (update)
import UI.KompostUI exposing (..)
import UI.KompostListingsUI exposing (..)
import UI.DvlSpecificsUI exposing (..)
import UI.MediaFileUI exposing (editSpecifics)
import Navigation.AppRouting as AppRouting exposing (navigateTo, Page(..))
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.CDN as CDN
import Set


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( { listings = RemoteData.Loading
      , kompost = emptyKompostion
      , dvlId = Nothing
      , activePage = KompostUI
      , editableSegment = False
      , segment = testSegment1
      , editingMediaFile = testMediaFile
      , subSegmentList = Set.empty
      }
    , Cmd.batch [ getListings ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "Debugmsg " msg of
        ListingsUpdated newWebData ->
            { model | listings = newWebData } ! []

        LocationChanged loc ->
            { model | activePage = AppRouting.routeFromLocation loc } ! []

        NavigateTo page ->
            model ! [ navigateTo page ]

        ChooseDvl id ->
            { model | dvlId = Just id, activePage = KompostUI } ! [ getKomposition id ]

        NewKomposition -> { model | kompost = emptyKompostion } ! [ navigateTo AppRouting.DvlSpecificsUI ]

        KompositionUpdated webKomposition ->
            let newModel = case RemoteData.toMaybe webKomposition of
                    Just kompost -> { model | kompost = kompost}
                    _ -> model
            in newModel ! [ navigateTo KompostUI ]

        SegmentListUpdated webKomposition ->
            let newModel = case RemoteData.toMaybe webKomposition of
                    Just kompost -> { model | kompost = kompost}
                    _ -> model
                segmentNames = Debug.log "SegmentListUpdated" List.map (\segment -> segment.id) newModel.kompost.segments
            in { model | subSegmentList = Set.fromList segmentNames } ! [ ]

        StoreKomposition ->
            let
                command = case model.kompost.revision of
                    "" -> createKompo model.kompost
                    _  -> updateKompo model.kompost
            in
                model ! [command]

        DeleteKomposition -> model ! [deleteKompo model.kompost]

        EditSpecifics ->
            model ! [ navigateTo AppRouting.DvlSpecificsUI ]

        CreateSegment ->
            {model | editableSegment = True } ! [ navigateTo SegmentUI ]

        CouchServerStatus serverstatus ->
            let (newModel, navigation) = case RemoteData.toMaybe serverstatus of
                    Just status ->
                        let kompost = model.kompost
                        in ({ model | kompost = { kompost | revision = status.rev} }, KompostUI)
                    _ -> (model, KompostUI)
            in newModel ! [ navigateTo navigation ]

        DvlSpecificsMsg msg ->
            let
                (newModel, cmd, childMsg) = Models.DvlSpecificsModel.update msg model
                cmds = case Models.DvlSpecificsModel.extractFromOutmessage childMsg of
                        Just page -> [navigateTo page]
                        Nothing ->  [cmd]
            in
                newModel ! cmds

        SegmentMsg msg ->
            let
                ( newModel, _, childMsg ) = Segment.Model.update msg model
                cmds = case Segment.Model.extractFromOutmessage childMsg of
                       Just (page)  -> [navigateTo page]
                       Nothing ->  []
            in
                newModel ! cmds

        FetchStuffFromRemoteServer ->
            (model, getDataFromRemoteServer "cats")

        DataBackFromRemoteServer (Ok newUrl) ->
            (model, Cmd.none)

        DataBackFromRemoteServer (Err _) ->
            (model, Cmd.none)

---- VIEW Base ----
view : Model -> Html Msg
view model =
    div []
        [ case model.activePage of
            ListingsUI ->
                pageWrapper <| UI.KompostListingsUI.listings <| model

            KompostUI ->
                pageWrapper <| UI.KompostUI.kompost model

            SegmentUI ->
                Html.map SegmentMsg(pageWrapper <| Segment.SegmentUI.segmentForm model model.editableSegment)

            DvlSpecificsUI ->
                Html.map DvlSpecificsMsg(pageWrapper <| UI.DvlSpecificsUI.editSpecifics model.kompost)

            MediaFileUI ->
                Html.map DvlSpecificsMsg(pageWrapper <| UI.MediaFileUI.editSpecifics model)

            NotFound ->
                div [] [ text "Sorry, nothing< here :(" ]
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

emptyKompostion = Komposition "" "" 0 testMediaFile [testSegment1, testSegment2] [testMediaFile]
--initModel = Model "dvlRef" "name" "revision" 0 1234  testConfig testMediaFile [testSegment1, testSegment2]
--testConfig = MsgModel.Config 1280 1080 24 "mp4" 1234
testMediaFile = Mediafile "https://www.not.configured.com/watch?v=Scxs7L0vhZ4" 0 "No checksum"
testSegment1 = Segment "First segment" 7541667 19750000
testSegment2 = Segment "Second segment" 21250000  27625000

