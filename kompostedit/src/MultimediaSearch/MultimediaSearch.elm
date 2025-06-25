module MultimediaSearch.MultimediaSearch exposing
    ( Model
    , Msg(..)
    , init
    , update
    , view
    , getSelectedSource
    , isSearching
    )

import Browser.Dom as Dom
import Html exposing (Html, div, input, text)
import Html.Attributes as Attrs
import Html.Events as Events
import Json.Decode as Decode
import Menu
import Models.BaseModel exposing (Source)
import String
import Task


type alias Model =
    { sources : List Source
    , autoState : Menu.State
    , howManyToShow : Int
    , query : String
    , selectedSource : Maybe Source
    , showMenu : Bool
    , isLoading : Bool
    , filters : SearchFilters
    }


type alias SearchFilters =
    { mediaType : String  -- "audio", "video", "all"
    }


init : Model
init =
    { sources = []
    , autoState = Menu.empty
    , howManyToShow = 10
    , query = ""
    , selectedSource = Nothing
    , showMenu = False
    , isLoading = False
    , filters = { mediaType = "all" }
    }


type Msg
    = SetQuery String
    | SetAutoState Menu.Msg
    | SetMediaTypeFilter String
    | Wrap Bool
    | Reset
    | HandleEscape
    | SelectSourceKeyboard String
    | SelectSourceMouse String
    | PreviewSource String
    | OnFocus
    | NoOp
    | SearchMultimedia String String  -- query, mediaType
    | MultimediaReceived (List Source)
    | SearchError String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetQuery newQuery ->
            let
                showMenu =
                    not (List.isEmpty (acceptableSources newQuery model.sources))
                
                -- Trigger search when query has content or is empty (for initial load)
                searchCmd = 
                    if String.length newQuery >= 2 || String.isEmpty newQuery then
                        Task.perform (\_ -> SearchMultimedia newQuery model.filters.mediaType) (Task.succeed ())
                    else
                        Cmd.none
            in
            ( { model
                | query = newQuery
                , showMenu = showMenu
                , selectedSource = Nothing
                , isLoading = String.length newQuery >= 2 || String.isEmpty newQuery
              }
            , searchCmd
            )

        SetMediaTypeFilter mediaType ->
            let
                newFilters = { mediaType = mediaType }
                searchCmd = 
                    if String.length model.query >= 2 then
                        Task.perform (\_ -> SearchMultimedia model.query mediaType) (Task.succeed ())
                    else
                        Cmd.none
            in
            ( { model | filters = newFilters, isLoading = String.length model.query >= 2 }
            , searchCmd
            )

        SearchMultimedia query mediaType ->
            -- This will be handled by parent component to make API call
            ( model, Cmd.none )

        MultimediaReceived sources ->
            let
                -- Show menu if we have sources, regardless of query length for initial load
                showMenu = not (List.isEmpty sources)
            in
            ( { model 
                | sources = sources
                , showMenu = showMenu
                , isLoading = False
              }
            , Cmd.none
            )

        SearchError error ->
            ( { model | isLoading = False, showMenu = False }, Cmd.none )

        SetAutoState autoMsg ->
            let
                ( newState, maybeMsg ) =
                    Menu.update updateConfig
                        autoMsg
                        model.howManyToShow
                        model.autoState
                        (acceptableSources model.query model.sources)

                newModel =
                    { model | autoState = newState }
            in
            maybeMsg
                |> Maybe.map (\updateMsg -> update updateMsg newModel)
                |> Maybe.withDefault ( newModel, Cmd.none )

        HandleEscape ->
            let
                validOptions =
                    not (List.isEmpty (acceptableSources model.query model.sources))

                handleEscape =
                    if validOptions then
                        model
                            |> removeSelection
                            |> resetMenu
                    else
                        resetInput model

                escapedModel =
                    case model.selectedSource of
                        Just source ->
                            if model.query == source.id then
                                resetInput model
                            else
                                handleEscape

                        Nothing ->
                            handleEscape
            in
            ( escapedModel, Cmd.none )

        Wrap toTop ->
            case model.selectedSource of
                Just source ->
                    update Reset model

                Nothing ->
                    if toTop then
                        ( { model
                            | autoState =
                                Menu.resetToLastItem updateConfig
                                    (acceptableSources model.query model.sources)
                                    model.howManyToShow
                                    model.autoState
                            , selectedSource =
                                acceptableSources model.query model.sources
                                    |> List.take model.howManyToShow
                                    |> List.reverse
                                    |> List.head
                          }
                        , Cmd.none
                        )
                    else
                        ( { model
                            | autoState =
                                Menu.resetToFirstItem updateConfig
                                    (acceptableSources model.query model.sources)
                                    model.howManyToShow
                                    model.autoState
                            , selectedSource =
                                acceptableSources model.query model.sources
                                    |> List.take model.howManyToShow
                                    |> List.head
                          }
                        , Cmd.none
                        )

        Reset ->
            ( { model
                | autoState = Menu.reset updateConfig model.autoState
                , selectedSource = Nothing
              }
            , Cmd.none
            )

        SelectSourceKeyboard id ->
            let
                newModel =
                    setQuery model id
                        |> resetMenu
            in
            ( newModel, Cmd.none )

        SelectSourceMouse id ->
            let
                newModel =
                    setQuery model id
                        |> resetMenu
            in
            ( newModel, Task.attempt (\_ -> NoOp) (Dom.focus "multimedia-search-input") )

        PreviewSource id ->
            ( { model
                | selectedSource =
                    Just (getSourceAtId model.sources id)
              }
            , Cmd.none
            )

        OnFocus ->
            ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


-- Helper functions
resetInput : Model -> Model
resetInput model =
    { model | query = "" }
        |> removeSelection
        |> resetMenu


removeSelection : Model -> Model
removeSelection model =
    { model | selectedSource = Nothing }


getSourceAtId : List Source -> String -> Source
getSourceAtId sources id =
    List.filter (\source -> source.id == id) sources
        |> List.head
        |> Maybe.withDefault (Source "" "" Nothing "" "" "" "" Nothing Nothing)


setQuery : Model -> String -> Model
setQuery model id =
    let
        source = getSourceAtId model.sources id
    in
    { model
        | query = source.id ++ " - " ++ (source.url |> String.split "/" |> List.reverse |> List.head |> Maybe.withDefault "")
        , selectedSource = Just source
    }


resetMenu : Model -> Model
resetMenu model =
    { model
        | autoState = Menu.empty
        , showMenu = False
    }


acceptableSources : String -> List Source -> List Source
acceptableSources query sources =
    if String.isEmpty query then
        -- Show all sources when query is empty (initial load)
        sources
    else
        let
            lowerQuery = String.toLower query
        in
        List.filter (sourceMatchesQuery lowerQuery) sources


sourceMatchesQuery : String -> Source -> Bool
sourceMatchesQuery lowerQuery source =
    let
        searchableText = String.toLower (source.id ++ " " ++ source.url ++ " " ++ source.mediaType)
    in
    String.contains lowerQuery searchableText


-- View
view : Model -> Html Msg
view model =
    let
        upDownEscDecoderHelper : Int -> Decode.Decoder Msg
        upDownEscDecoderHelper code =
            if code == 38 || code == 40 then
                Decode.succeed NoOp
            else if code == 27 then
                Decode.succeed HandleEscape
            else
                Decode.fail "not handling that key"

        upDownEscDecoder : Decode.Decoder ( Msg, Bool )
        upDownEscDecoder =
            Events.keyCode
                |> Decode.andThen upDownEscDecoderHelper
                |> Decode.map (\msg -> ( msg, True ))

        menu =
            if model.showMenu then
                [ viewMenu model ]
            else
                []

        query =
            model.selectedSource
                |> Maybe.map (\source -> source.id ++ " - " ++ (source.url |> String.split "/" |> List.reverse |> List.head |> Maybe.withDefault ""))
                |> Maybe.withDefault model.query

        loadingIndicator =
            if model.isLoading then
                [ div [ Attrs.class "multimedia-search-loading" ] [ text "Searching..." ] ]
            else
                []

        activeDescendant attributes =
            model.selectedSource
                |> Maybe.map .id
                |> Maybe.map (Attrs.attribute "aria-activedescendant")
                |> Maybe.map (\attribute -> attribute :: attributes)
                |> Maybe.withDefault attributes
    in
    div [ Attrs.class "multimedia-search-container" ]
        ([ div [ Attrs.class "multimedia-search-filters" ]
            [ text "Media Type: "
            , input 
                [ Attrs.type_ "radio"
                , Attrs.name "mediaType"
                , Attrs.value "all"
                , Attrs.checked (model.filters.mediaType == "all")
                , Events.onCheck (\_ -> SetMediaTypeFilter "all")
                ] []
            , text " All "
            , input 
                [ Attrs.type_ "radio"
                , Attrs.name "mediaType"
                , Attrs.value "audio"
                , Attrs.checked (model.filters.mediaType == "audio")
                , Events.onCheck (\_ -> SetMediaTypeFilter "audio")
                ] []
            , text " Audio "
            , input 
                [ Attrs.type_ "radio"
                , Attrs.name "mediaType"
                , Attrs.value "video"
                , Attrs.checked (model.filters.mediaType == "video")
                , Events.onCheck (\_ -> SetMediaTypeFilter "video")
                ] []
            , text " Video"
            ]
        , input
            (activeDescendant
                [ Events.onInput SetQuery
                , Events.onFocus OnFocus
                , Events.preventDefaultOn "keydown" upDownEscDecoder
                , Attrs.value query
                , Attrs.id "multimedia-search-input"
                , Attrs.class "multimedia-search-input form-control"
                , Attrs.autocomplete False
                , Attrs.placeholder "Search multimedia library..."
                , Attrs.attribute "aria-owns" "list-of-multimedia"
                , Attrs.attribute "aria-expanded" (boolToString model.showMenu)
                , Attrs.attribute "aria-haspopup" (boolToString model.showMenu)
                , Attrs.attribute "role" "combobox"
                , Attrs.attribute "aria-autocomplete" "list"
                ]
            )
            []
        ] ++ loadingIndicator ++ menu)


viewMenu : Model -> Html Msg
viewMenu model =
    div [ Attrs.class "multimedia-search-menu" ]
        [ Html.map SetAutoState <|
            Menu.view viewConfig
                model.howManyToShow
                model.autoState
                (acceptableSources model.query model.sources)
        ]


updateConfig : Menu.UpdateConfig Msg Source
updateConfig =
    Menu.updateConfig
        { toId = .id
        , onKeyDown =
            \code maybeId ->
                if code == 38 || code == 40 then
                    Maybe.map PreviewSource maybeId
                else if code == 13 then
                    Maybe.map SelectSourceKeyboard maybeId
                else
                    Just Reset
        , onTooLow = Just (Wrap False)
        , onTooHigh = Just (Wrap True)
        , onMouseEnter = \id -> Just (PreviewSource id)
        , onMouseLeave = \_ -> Nothing
        , onMouseClick = \id -> Just (SelectSourceMouse id)
        , separateSelections = False
        }


viewConfig : Menu.ViewConfig Source
viewConfig =
    let
        customizedLi keySelected mouseSelected source =
            { attributes =
                [ Attrs.classList
                    [ ( "multimedia-search-item", True )
                    , ( "key-selected", keySelected || mouseSelected )
                    ]
                , Attrs.id source.id
                ]
            , children = 
                [ Html.div []
                    [ Html.strong [] [ text source.id ]
                    , Html.br [] []
                    , Html.small [] [ text (source.mediaType ++ " - " ++ (source.url |> String.split "/" |> List.reverse |> List.head |> Maybe.withDefault "")) ]
                    ]
                ]
            }
    in
    Menu.viewConfig
        { toId = .id
        , ul = [ Attrs.class "multimedia-search-list" ]
        , li = customizedLi
        }


-- Public API functions
getSelectedSource : Model -> Maybe Source
getSelectedSource model =
    model.selectedSource


isSearching : Model -> Bool
isSearching model =
    model.isLoading


boolToString : Bool -> String
boolToString bool =
    case bool of
        True -> "true"
        False -> "false"