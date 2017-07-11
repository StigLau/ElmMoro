module Main exposing (main, init, update, view)

import Html exposing (Html, div, text)
import RemoteData exposing (succeed, RemoteData(..))
import Navigation exposing (Location)
import Models.Msg exposing (Msg(..))
import Models.BaseModel exposing (..)
import Models.DvlSpecificsModel exposing (update, extractFromOutmessage)
import Models.KompostApi exposing (getKomposition, updateKompo, createKompo, deleteKompo, getDataFromRemoteServer)
import Segment.SegmentUI exposing (segmentForm)
import Segment.Model exposing (update)
import UI.KompostUI exposing (..)
import UI.KompostListingsUI exposing (..)
import UI.DvlSpecificsUI exposing (..)
import UI.MediaFileUI exposing (editSpecifics)
import Navigation.AppRouting as AppRouting exposing (navigateTo, Page(Listings, Kompost, NotFound))
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.CDN as CDN


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( { listings = RemoteData.Loading
      , kompost = emptyKompostion
      , dvlId = Nothing
      , activePage = AppRouting.Listings
      , editableSegment = False
      , segment = testSegment1
      , editingMediaFile = testMediaFile
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
            { model | dvlId = Just id, activePage = Kompost } ! [ getKomposition id ]

        NewKomposition -> { model | kompost = emptyKompostion } ! [ navigateTo AppRouting.DvlSpecificsUI ]

        KompositionUpdated webKomposition ->
            let newModel = case RemoteData.toMaybe webKomposition of
                                Just kompost -> { model | kompost = kompost}
                                _ -> model
            in newModel ! [ navigateTo Kompost ]

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
            let
                editableModel  = {model | editableSegment = True }
            in
                editableModel ! [ navigateTo AppRouting.Segment ]

        CouchServerStatus serverstatus ->
            let (newModel, navigation) = case RemoteData.toMaybe serverstatus of
                    Just status ->
                        let kompost = model.kompost
                        in ({ model | kompost = { kompost | revision = status.rev} }, Kompost)
                    _ -> (model, AppRouting.Kompost)
            in newModel ! [ navigateTo navigation ]

        DvlSpecificsMsg msg ->
                    let
                        (newModel, cmd, childMsg) = Models.DvlSpecificsModel.update msg model
                        cmds = case Models.DvlSpecificsModel.extractFromOutmessage childMsg of
                            Just page -> [navigateTo page]
                            Nothing ->  []
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
           ( model, Cmd.none)

        DataBackFromRemoteServer (Err _) ->
              (model, Cmd.none)

---- VIEW Base ----
view : Model -> Html Msg
view model =
    div []
        [ case model.activePage of
            AppRouting.Listings ->
                pageWrapper <| UI.KompostListingsUI.listings <| model

            AppRouting.Kompost ->
                pageWrapper <| UI.KompostUI.kompost model

            AppRouting.Segment ->
                Html.map SegmentMsg(pageWrapper <| Segment.SegmentUI.segmentForm model model.editableSegment)

            AppRouting.DvlSpecificsUI ->
                Html.map DvlSpecificsMsg(pageWrapper <| UI.DvlSpecificsUI.editSpecifics model.kompost)

            AppRouting.MediaFileUI ->
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

emptyKompostion = Komposition "" "" 0 testMediaFile [testSegment1, testSegment2] [testMediaFile, testMediaFile]
--initModel = Model "dvlRef" "name" "revision" 0 1234  testConfig testMediaFile [testSegment1, testSegment2]
--testConfig = MsgModel.Config 1280 1080 24 "mp4" 1234
testMediaFile = Mediafile "https://www.not.configured.com/watch?v=Scxs7L0vhZ4" 0 "No checksum"
testSegment1 = Segment "First segment" 7541667 19750000
testSegment2 = Segment "Second segment" 21250000  27625000

