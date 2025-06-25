module Main exposing (init, main, update, view)

import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Browser
import Browser.Navigation as Nav
import Common.AutoComplete
import Common.StaticVariables exposing (audioTag, kompositionTag)
import Debug exposing (log)
import DvlSpecifics.DvlSpecificsModel exposing (update)
import DvlSpecifics.DvlSpecificsUI
import Html exposing (Html, div, text)
import Models.BaseModel exposing (..)
import Models.JsonCoding as JsonCoding
import Models.KompostApi as KompostApi exposing (createVideo, deleteKompo, fetchKompositionList, fetchSource, updateKompo, fetchMultimediaList)
import Models.Msg exposing (Msg(..))
import MultimediaSearch.MultimediaSearch as MultimediaSearch
import MultimediaSearch.SimpleModal as MultimediaModal
import Navigation.AppRouting as AppRouting exposing (replaceUrl)
import Navigation.Page as Page exposing (Page)
import RemoteData exposing (RemoteData(..))
import Segment.Model exposing (update)
import Segment.SegmentUI
import Set
import Source.SourcesUI exposing (update)
import UI.KompostListingsUI
import UI.KompostUI
import Url exposing (Url)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "Root.update" msg of
        ListingsUpdated (Success kompositionList) ->
            ( { model | listings = kompositionList }, Cmd.none )

        ListingsUpdated (Failure err) ->
            let
                _ =
                    Debug.log "Fetching komposition list failed marvellously" err
            in
            ( model, Cmd.none )

        ListingsUpdated NotAsked ->
            Debug.log "Initialising KompositionList" ( model, Cmd.none )

        ListingsUpdated Loading ->
            Debug.log "Loading" ( model, Cmd.none )

        NavigateTo page ->
            let
                _ =
                    Debug.log "NavigateTo" page
            in
            ( { model | activePage = page }
            , replaceUrl page model.key
            )

        FetchLocalIntegration integrationDestination ->
            let
                empModel =
                    emptyModel model.key model.url model.apiToken
            in
            ( { empModel | activePage = Page.KompostUI, listings = model.listings }
            , KompostApi.getFromURL integrationDestination model.apiToken
            )

        NewKomposition ->
            let
                empModel =
                    emptyModel model.key model.url model.apiToken
            in
            ( { model | kompost = empModel.kompost, activePage = Page.DvlSpecificsUI }
            , replaceUrl Page.DvlSpecificsUI model.key
            )

        ChangeKompositionType searchType ->
            ( model
            , fetchKompositionList searchType model.apiToken
            )

        ChangedIntegrationId integrationId ->
            ( { model | integrationDestination = integrationId }, Cmd.none )

        ChangedIntegrationFormat formatId ->
            ( { model | integrationFormat = formatId }, Cmd.none )

        KompositionUpdated webKomposition ->
            ( case RemoteData.toMaybe webKomposition of
                Just kompost ->
                    { model | kompost = kompost }

                _ ->
                    model
            , replaceUrl Page.KompostUI model.key
            )

        SourceUpdated webKomposition ->
            ( case RemoteData.toMaybe webKomposition of
                Just kompost ->
                    { model | subSegmentList = Set.fromList (List.map (\segment -> segment.id) kompost.segments) }

                _ ->
                    model
            , replaceUrl Page.KompostUI model.key
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
                    Debug.log "SegmentListUpdated" (List.map (\segment -> segment.id) newModel.kompost.segments)
            in
            ( { model | subSegmentList = Set.fromList segmentNames }
            , Cmd.none
            )

        StoreKomposition ->
            let -- Set a minimal id when storing
                updateId = case model.kompost.name of
                    "" -> model.kompost.name ++ ".json"
                    _  -> model.kompost.name
                kompost = model.kompost
            in
                ( model
                , updateKompo { kompost | id = updateId } model.apiToken
                )

        DeleteKomposition ->
            ( { model | activePage = Page.ListingsUI }
            , log "Deleting komposition" deleteKompo model.kompost model.apiToken
            )

        EditSpecifics ->
            ( { model | activePage = Page.DvlSpecificsUI }
            , replaceUrl Page.DvlSpecificsUI model.key
            )

        CreateSegment ->
            ( { model | editableSegment = True, segment = emptySegment, activePage = Page.SegmentUI }
            , Cmd.none
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
                            ( { model | kompost = { kompost | revision = status.rev } }, Page.KompostUI )

                        _ ->
                            ( model, Page.KompostUI )
            in
            ( newModel
            , replaceUrl page model.key
            )

        SourceMsg theMsg ->
            let
                ( newModel, sourceMsg, childMsg ) =
                    Source.SourcesUI.update theMsg model
            in
            case DvlSpecifics.DvlSpecificsModel.extractFromOutmessage childMsg of
                Just page ->
                    ( { newModel | activePage = page }, sourceMsg )

                Nothing ->
                    ( newModel, sourceMsg )

        DvlSpecificsMsg theMsg ->
            let
                ( newModel, childMsg ) =
                    DvlSpecifics.DvlSpecificsModel.update theMsg model
            in
            case DvlSpecifics.DvlSpecificsModel.extractFromOutmessage childMsg of
                Just page ->
                    ( { newModel | activePage = page }, Cmd.none )

                Nothing ->
                    ( newModel, Cmd.none )

        SegmentMsg theMsg ->
            case Segment.Model.update theMsg model of
                ( newModel, _, Just (OutNavigateTo page) ) ->
                    ( { newModel | activePage = page }, Cmd.none )

                ( newModel, _, Just (FetchSourceListMsg sourceId) ) ->
                    ( newModel, fetchSource sourceId model.apiToken )

                ( newModel, command, childMsg ) ->
                    let
                        _ =
                            Debug.log "Extracting outmessage failed" childMsg
                    in
                    ( newModel, command )

        CreateVideo ->
            let
                _ =
                    Debug.log "Creating video" model.kompost
            in
            ( model
            , createVideo model.kompost model.apiToken
            )

        ShowKompositionJson ->
            ( { model | activePage = Page.KompositionJsonUI }
            , replaceUrl Page.KompositionJsonUI model.key
            )

        ETagResponse (Ok checksum) ->
            --Stripping surrounding ampersands
            let
                source =
                    model.editingMediaFile

                modifiedSource =
                    { source | checksum = checksum }
            in
            ( { model | editingMediaFile = modifiedSource }, Cmd.none )

        ETagResponse (Err err) ->
            --( { model | statusMessage = [ err ] }, Cmd.none ) -- TODO To fix
            ( model, Cmd.none )

        ClickedLink urlRequest ->
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
                            Debug.log "BrowserInternal"
                                ( model
                                , Nav.pushUrl model.key (Url.toString url)
                                )

                Browser.External href ->
                    Debug.log "To BrowserExternal"
                        ( model
                        , Nav.load href
                        )

        ShowMultimediaSearch ->
            if model.showMultimediaModal then
                -- Closing modal
                ( { model | showMultimediaModal = False }, Cmd.none )
            else
                -- Opening modal - trigger initial search
                let
                    searchState = model.multimediaSearchState
                    updatedSearchState = { searchState | isLoading = True, query = "", mediaTypeFilter = "all" }
                in
                ( { model | showMultimediaModal = True, multimediaSearchState = updatedSearchState }
                , fetchMultimediaList "" "all" model.apiToken
                )

        MultimediaSearchMsg multimediaMsg ->
            case multimediaMsg of
                MultimediaSearch.SearchMultimedia query mediaType ->
                    let
                        searchState = model.multimediaSearchState
                        updatedSearchState = { searchState | query = query, isLoading = True, mediaTypeFilter = mediaType }
                    in
                    ( { model | multimediaSearchState = updatedSearchState }
                    , fetchMultimediaList query mediaType model.apiToken
                    )
                
                MultimediaSearch.MultimediaReceived sources ->
                    let
                        searchState = model.multimediaSearchState
                        updatedSearchState = { searchState | sources = sources, isLoading = False }
                    in
                    ( { model | multimediaSearchState = updatedSearchState }, Cmd.none )
                
                MultimediaSearch.SetQuery query ->
                    let
                        searchState = model.multimediaSearchState
                        updatedSearchState = { searchState | query = query }
                    in
                    ( { model | multimediaSearchState = updatedSearchState }, Cmd.none )
                
                _ ->
                    ( model, Cmd.none )

        MultimediaApiResponse result ->
            case result of
                Ok sources ->
                    -- Forward the API response to the MultimediaSearch component
                    update (MultimediaSearchMsg (MultimediaSearch.MultimediaReceived sources)) model
                
                Err error ->
                    -- Forward the error to the MultimediaSearch component
                    let
                        searchState = model.multimediaSearchState
                        updatedSearchState = { searchState | isLoading = False }
                    in
                    ( { model | multimediaSearchState = updatedSearchState }, Cmd.none )

        AddSelectedMultimediaSource ->
            case model.multimediaSearchState.selectedSource of
                Just selectedSource ->
                    -- Add the selected source to the komposition's sources list
                    let
                        currentKomposition = model.kompost
                        updatedSources = selectedSource :: currentKomposition.sources
                        updatedKomposition = { currentKomposition | sources = updatedSources }
                        searchState = model.multimediaSearchState
                        updatedSearchState = { searchState | selectedSource = Nothing }
                    in
                    ( { model 
                        | kompost = updatedKomposition
                        , showMultimediaModal = False -- Close the modal after adding
                        , multimediaSearchState = updatedSearchState
                      }
                    , Cmd.none
                    )
                
                Nothing ->
                    -- No source selected, just close the modal
                    ( { model | showMultimediaModal = False }, Cmd.none )

        ChangedUrl url ->
            let
                _ =
                    Debug.log "ChangedUrl" url
            in
            changeRouteTo (AppRouting.fromUrl url) model


changeRouteTo : Maybe Page -> Model -> ( Model, Cmd Msg )
changeRouteTo maybePage model =
    case maybePage of
        Nothing ->
            let
                _ =
                    Debug.log "changeRouteTo to Nothing"
            in
            ( model, Cmd.none )

        Just anotherPage ->
            --TODO Use updateWith
            let
                _ =
                    Debug.log "Routing towards" anotherPage
            in
            ( model, AppRouting.replaceUrl anotherPage model.key )



---- VIEW Base ----


view : Model -> Browser.Document Msg
view model =
    { title = "KompostEdit"
    , body = findOutWhatPageToView model
    }


findOutWhatPageToView : Model -> List (Html Msg)
findOutWhatPageToView model =
    let
        _ =
            Debug.log "Moving on to " model.activePage
    in
    [ case model.activePage of
        Page.ListingsUI ->
            pageWrapper <| UI.KompostListingsUI.listings model

        Page.KompostUI ->
            pageWrapper <| UI.KompostUI.kompost model

        Page.KompositionJsonUI ->
            text (JsonCoding.kompositionEncoder model.kompost)

        Page.SegmentUI ->
            Html.map SegmentMsg (pageWrapper <| Segment.SegmentUI.segmentForm model)

        Page.DvlSpecificsUI ->
            Html.map DvlSpecificsMsg (pageWrapper <| DvlSpecifics.DvlSpecificsUI.editSpecifics model.kompost)

        Page.MediaFileUI ->
            Html.map SourceMsg (pageWrapper <| Source.SourcesUI.editSpecifics model)

        Page.NotFound ->
            div [] [ text "Sorry, nothing< here :(" ]
    , MultimediaModal.view model
    ]


pageWrapper : Html msg -> Html msg
pageWrapper forwaredPage =
    Grid.container []
        [ CDN.stylesheet
        , CDN.fontAwesome
        , forwaredPage
        ]



---- PROGRAM ----


init : String -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flag url navKey =
    ( emptyModel navKey url flag
    , Cmd.batch [ fetchKompositionList kompositionTag flag ]
    )


main : Program String Model Msg
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



{--
-- Basis model and offline testdata
-- These are the data points that one will see when one creates a new Komposion! If the GUI lacks default data, this is where one punches that in.
--}


emptyModel : Nav.Key -> Url -> String -> Model
emptyModel navKey theUrl apiGatewayToken =
    { listings = DataRepresentation [ Row "demokompo1" "rev1", Row "demokomp2" "rev1" ] "" ""
    , kompost = Komposition "" "Example" "" "Video" 120 defaultSegments [] (VideoConfig 0 0 0 "") (Just (BeatPattern 0 0 0))
    , statusMessage = []
    , activePage = Page.ListingsUI
    , editableSegment = False
    , checkboxVisible = False
    , segment = emptySegment
    , editingMediaFile = Source "" "" Nothing "" "" "" audioTag Nothing Nothing
    , subSegmentList = Set.empty
    , url = theUrl
    , key = navKey
    , accessibleAutocomplete = Common.AutoComplete.init
    , currentFocusAutoComplete = None
    , apiToken = apiGatewayToken
    , integrationDestination = "Sj3fFoojcnQ"
    , integrationFormat = "136"
    , kompoUrl = "/heap/"
    , metaUrl = "/meta/"
    , cacheUrl = "/fetch/"
    , multimediaSearchState = initMultimediaSearchState
    , showMultimediaModal = False
    }


initMultimediaSearchState : MultimediaSearchState
initMultimediaSearchState =
    { sources = []
    , query = ""
    , selectedSource = Nothing
    , showMenu = False
    , isLoading = False
    , mediaTypeFilter = "all"
    }


emptySegment =
    Segment "" "" 0 0 0


defaultSegments : List Segment
defaultSegments =
    [ Segment "Empty" "http://jalla1" 0 16 16
    ]
