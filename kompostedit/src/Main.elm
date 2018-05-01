module Main exposing (main, init, update, view)

import Html exposing (Html, div, text, p)
import RemoteData exposing (succeed, RemoteData(..))
import Navigation exposing (Location)
import Models.Msg exposing (Msg(..))
import Models.BaseModel exposing (..)
import DvlSpecifics.DvlSpecificsModel exposing (update, extractFromOutmessage, setSource)
import Models.KompostApi as KompostApi exposing (..)
import Segment.SegmentUI exposing (segmentForm)
import Segment.Model exposing (update)
import UI.KompostUI exposing (..)
import UI.KompostListingsUI exposing (..)
import DvlSpecifics.DvlSpecificsUI as SpecificsUI exposing (..)
import DvlSpecifics.SourcesUI as SourcesUI exposing (editSpecifics)
import Navigation.AppRouting as AppRouting exposing (navigateTo, Page(..))
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.CDN as CDN
import Set


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( emptyModel, Cmd.batch [ fetchKompositionList "Komposition" ] )


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
            { emptyModel | activePage = KompostUI, listings = model.listings } ! [ KompostApi.getKomposition id ]

        NewKomposition ->
            { model | kompost = emptyModel.kompost } ! [ navigateTo AppRouting.DvlSpecificsUI ]

        ChangeKompositionType searchType ->
            model ! [fetchKompositionList searchType]

        KompositionUpdated webKomposition ->
            let
                newModel =
                    case RemoteData.toMaybe webKomposition of
                        Just kompost ->
                            { model | kompost = kompost }

                        _ ->
                            model
            in
                newModel ! [ navigateTo KompostUI ]

        SegmentListUpdated webKomposition ->
            let
                newModel =
                    case RemoteData.toMaybe webKomposition of
                        Just kompost ->
                            { model | kompost = kompost }

                        _ ->
                            model

                segmentNames =
                    Debug.log "SegmentListUpdated" List.map (\segment -> segment.id) newModel.kompost.segments
            in
                { model | subSegmentList = Set.fromList segmentNames } ! []

        StoreKomposition ->
            let
                command =
                    case model.kompost.revision of
                        "" ->
                            KompostApi.createKompo model.kompost

                        _ ->
                            updateKompo model.kompost
            in
                model ! [ command ]

        DeleteKomposition ->
            model ! [ deleteKompo model.kompost ]

        EditSpecifics ->
            model ! [ navigateTo AppRouting.DvlSpecificsUI ]

        CreateSegment ->
            { model | editableSegment = True, segment = emptySegment } ! [ navigateTo SegmentUI ]

        CouchServerStatus serverstatus ->
            let
                ( newModel, navigation ) =
                    case RemoteData.toMaybe serverstatus of
                        Just status ->
                            let
                                kompost =
                                    model.kompost
                            in
                                ( { model | kompost = { kompost | revision = status.rev } }, KompostUI )

                        _ ->
                            ( model, KompostUI )
            in
                newModel ! [ navigateTo navigation ]

        DvlSpecificsMsg msg ->
            let
                ( newModel, cmd, childMsg ) =
                    DvlSpecifics.DvlSpecificsModel.update msg model

                cmds =
                    case DvlSpecifics.DvlSpecificsModel.extractFromOutmessage childMsg of
                        Just page ->
                            [ navigateTo page ]

                        Nothing ->
                            [ cmd ]
            in
                newModel ! cmds

        SegmentMsg msg ->
            let
                ( newModel, _, childMsg ) =
                    Segment.Model.update msg model

                cmds =
                    case Segment.Model.extractFromOutmessage childMsg of
                        Just page ->
                            [ navigateTo page ]

                        Nothing ->
                            []
            in
                newModel ! cmds

        CreateVideo ->
            model ! [ createVideo model.kompost ]

        ShowKompositionJson ->
            model ! [ navigateTo KompositionJsonUI ]

        ETagResponse (Ok checksum) ->
            --Stripping surrounding ampersands
            let
                source =
                    model.editingMediaFile
            in
                ( setSource { source | checksum = checksum } model, Cmd.none )

        ETagResponse (Err err) ->
            ( { model | statusMessage = [ toString err ] }, Cmd.none )



---- VIEW Base ----


view : Model -> Html Msg
view model =
    div []
        [ case model.activePage of
            ListingsUI ->
                pageWrapper <| UI.KompostListingsUI.listings <| model

            KompostUI ->
                pageWrapper <| UI.KompostUI.kompost model

            KompositionJsonUI ->
                text (KompostApi.kompostJson model.kompost)

            SegmentUI ->
                Html.map SegmentMsg (pageWrapper <| Segment.SegmentUI.segmentForm model model.editableSegment)

            DvlSpecificsUI ->
                Html.map DvlSpecificsMsg (pageWrapper <| SpecificsUI.editSpecifics model.kompost)

            MediaFileUI ->
                Html.map DvlSpecificsMsg (pageWrapper <| SourcesUI.editSpecifics model)

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


emptyModel =
    { listings = RemoteData.Loading
    , kompost = Komposition "" "" "" 0 defaultSegments [] (VideoConfig 0 0 0 "") (Just (BeatPattern 0 0 0))
    , statusMessage = []
    , activePage = ListingsUI
    , editableSegment = False
    , segment = emptySegment
    , editingMediaFile = Source "" "" 0 "" "" "" False
    , subSegmentList = Set.empty
    }


emptySegment =
    Segment "" "" 0 0 0 Nothing


defaultSegments : List Segment
defaultSegments =
    [ Segment "Empty" "http://jalla1" 0 16 16 (Just "A Segment")
    ]
