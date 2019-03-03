module Main exposing (init, main, update, view)

import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import DvlSpecifics.DvlSpecificsModel exposing (setSource, update)
import DvlSpecifics.DvlSpecificsUI as SpecificsUI exposing (..)
import DvlSpecifics.SourcesUI as SourcesUI
import Html exposing (Html, div, text)
import Models.BaseModel exposing (..)
import Models.KompostApi as KompostApi exposing (..)
import Models.Msg exposing (Msg(..))
import Browser
import Browser.Navigation as Nav
import Navigation.AppRouting as AppRouting exposing (Page(..), replaceUrl)
import RemoteData exposing (RemoteData(..))
import Segment.Model exposing (update)
import Segment.SegmentUI
import Set
import UI.KompostListingsUI exposing (..)
import UI.KompostUI exposing (..)
import Url exposing (Url)
import RemoteData exposing (WebData)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "Debugmsg " msg of
        ListingsUpdated (Success kompositionList) ->
            ( { model | listings = kompositionList }, Cmd.none)

        ListingsUpdated (Failure err) ->
                let
                    _ = Debug.log "Fetching komposition list failed marvellously" err
                in
                    ( model, Cmd.none)

        ListingsUpdated NotAsked ->
                Debug.log "Initialising KompositionList" (model, Cmd.none)

        ListingsUpdated Loading ->
                Debug.log "Loading" (model, Cmd.none)



        LocationChanged loc ->

            let _ = Debug.log "Trying to change location" loc
            in
            ( { model | activePage = AppRouting.fromUrlString "" }, Cmd.none) --TODO check this out!!

        NavigateTo page ->
            let _ = Debug.log "NavigateTo" page
            in  ( {model | activePage = page }
                , replaceUrl page model.key
                )

        ChooseDvl id ->
            let
                empModel = emptyModel model.key model.url
            in
            ( { empModel | activePage = KompostUI, listings = model.listings }
            , KompostApi.getKomposition id
            )

        NewKomposition ->
            let
                empModel = emptyModel model.key model.url
            in
                ( { model | kompost = empModel.kompost, activePage = KompostUI}
            , replaceUrl AppRouting.DvlSpecificsUI model.key
            )

        ChangeKompositionType searchType ->
            ( model
            , fetchKompositionList searchType
            )

        KompositionUpdated webKomposition ->
            ( case RemoteData.toMaybe webKomposition of
                  Just kompost ->
                      { model | kompost = kompost }
                  _ ->
                      model
            , replaceUrl KompostUI model.key
            )

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
            ( { model | subSegmentList = Set.fromList segmentNames }
            , Cmd.none
            )

        StoreKomposition ->
            let
                command =
                    case model.kompost.revision of
                        "" ->
                            KompostApi.createKompo model.kompost

                        _ ->
                            updateKompo model.kompost
            in
            ( model
            , command
            )

        DeleteKomposition ->
            ( model
            , deleteKompo model.kompost
            )

        EditSpecifics ->
            ( { model | activePage = DvlSpecificsUI }
            , replaceUrl AppRouting.DvlSpecificsUI model.key
            )

        CreateSegment ->
            ( { model | editableSegment = True, segment = emptySegment }
            , replaceUrl SegmentUI model.key
            )

        CouchServerStatus serverstatus ->
            let
                ( newModel, page ) =
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
            ( newModel
            , replaceUrl page model.key
            )

        DvlSpecificsMsg theMsg ->
            let
                ( newModel, cmd, childMsg ) =
                    DvlSpecifics.DvlSpecificsModel.update theMsg model

                cmds =
                    case DvlSpecifics.DvlSpecificsModel.extractFromOutmessage childMsg of
                        Just page ->
                            [ replaceUrl page model.key ]

                        Nothing ->
                            [ cmd ]
            in
            ( { newModel | activePage = KompostUI }
            , Cmd.batch cmds
            )

        SegmentMsg theMsg ->
            let
                ( newModel, _, childMsg ) =
                    Segment.Model.update theMsg model

                cmds =
                    case Segment.Model.extractFromOutmessage childMsg of
                        Just page ->
                            [ replaceUrl page model.key ]

                        Nothing ->
                            []
            in
            ( newModel
            , Cmd.batch cmds
            )

        CreateVideo ->
            ( model
            , createVideo model.kompost
            )

        ShowKompositionJson ->
            ( model
            , replaceUrl KompositionJsonUI model.key
            )

        ETagResponse (Ok checksum) ->
            --Stripping surrounding ampersands
            let
                source =
                    model.editingMediaFile
            in
            ( setSource { source | checksum = checksum } model, Cmd.none )

        ETagResponse (Err err) ->
            --( { model | statusMessage = [ err ] }, Cmd.none ) -- TODO To fix
            (model, Cmd.none)

        ( ClickedLink urlRequest ) ->
            case urlRequest of
                Browser.Internal url ->
                    case url.fragment of
                        Nothing ->
                            -- If we got a link that didn't include a fragment,
                            -- it's from one of those (href "") attributes that
                            -- we have to include to make the RealWorld CSS work.
                            --
                            -- In an application doing path routing instead of
                            -- fragment-based routing, this entire
                            -- `case url.fragment of` expression this comment
                            -- is inside would be unnecessary.
                            ( model, Cmd.none )

                        Just _ ->
                            Debug.log "BrowserInternal" ( model
                            , Nav.pushUrl model.key (Url.toString url)
                            )

                Browser.External href ->
                    Debug.log "To BrowserExternal" ( model
                    , Nav.load href
                    )

        ChangedUrl url ->
            Debug.log "Tried ChangedUrl" (changeRouteTo (AppRouting.fromUrl url) model)


changeRouteTo : Maybe Page -> Model -> ( Model, Cmd Msg )
changeRouteTo maybePage model =
    case maybePage of
        Nothing ->
            Debug.log "changeRouteTo to Nothing" ( model, Cmd.none )


        Just anotherPage ->
            --TODO Use updateWith
                let
                    _ = Debug.log "Routing towards" anotherPage
                in
                    ( model, AppRouting.replaceUrl anotherPage model.key)


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> Model -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg model ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )

---- VIEW Base ----


view : Model -> Browser.Document Msg
view model =
    { title = "KompostEdit"
    , body = findOutWhatPageToView model
    }

findOutWhatPageToView : Model -> List (Html Msg)
findOutWhatPageToView model =
    let
        _ = Debug.log "Moving on to " model.activePage
    in
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
init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url navKey =
    (  emptyModel navKey url
    , Cmd.batch [ fetchKompositionList "Komposition" ]
    )

main =
    Browser.application
            { init = init
            , update = update
            , view = view
            , onUrlChange = ChangedUrl
            , onUrlRequest = ClickedLink
            , subscriptions = subscriptions
            }

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


-- Offline testdata
emptyModel : Nav.Key -> Url -> Model
emptyModel  navKey theUrl =
    { listings = DataRepresentation [] "" ""
    , kompost = Komposition "" "" "" 0 defaultSegments [] (VideoConfig 0 0 0 "") (Just (BeatPattern 0 0 0))
    , statusMessage = []
    , activePage = ListingsUI
    , editableSegment = False
    , segment = emptySegment
    , editingMediaFile = Source "" "" 0 "" "" "" False
    , subSegmentList = Set.empty
    , url = theUrl
    , key = navKey
    }


emptySegment =
    Segment "" "" 0 0 0 Nothing


defaultSegments : List Segment
defaultSegments =
    [ Segment "Empty" "http://jalla1" 0 16 16 (Just "A Segment")
    ]
