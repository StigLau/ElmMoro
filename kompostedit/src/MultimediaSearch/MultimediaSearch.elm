module MultimediaSearch.MultimediaSearch exposing
    ( Model
    , Msg(..)
    , init
    , update
    , view
    , getSelectedSource
    , isSearching
    )

import Html exposing (Html, div, text, option, select, input, label)
import Html.Attributes as Attrs
import Html.Events as Events
import Models.BaseModel exposing (Source)
import String


type alias Model =
    { sources : List Source
    , selectedSource : Maybe Source
    , isLoading : Bool
    , filters : SearchFilters
    }


type alias SearchFilters =
    { mediaType : String  -- "audio", "video", "all"
    }


init : Model
init =
    { sources = []
    , selectedSource = Nothing
    , isLoading = False
    , filters = { mediaType = "all" }
    }


type Msg
    = SelectSource String
    | SetMediaTypeFilter String
    | SearchMultimedia String String  -- query, mediaType
    | MultimediaReceived (List Source)
    | SearchError String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectSource sourceId ->
            let
                selectedSource = 
                    if String.isEmpty sourceId then
                        Nothing
                    else
                        getSourceById model.sources sourceId
            in
            ( { model | selectedSource = selectedSource }, Cmd.none )

        SetMediaTypeFilter mediaType ->
            let
                newFilters = { mediaType = mediaType }
            in
            ( { model | filters = newFilters, isLoading = True }, Cmd.none )

        SearchMultimedia query mediaType ->
            -- This will be handled by parent component to make API call
            ( model, Cmd.none )

        MultimediaReceived sources ->
            ( { model | sources = sources, isLoading = False }, Cmd.none )

        SearchError error ->
            ( { model | isLoading = False }, Cmd.none )


-- Helper functions
getSourceById : List Source -> String -> Maybe Source
getSourceById sources id =
    List.filter (\source -> source.id == id) sources
        |> List.head


-- View
view : Model -> Html Msg
view model =
    let
        loadingIndicator =
            if model.isLoading then
                [ div [ Attrs.class "multimedia-search-loading text-muted" ] [ text "Loading multimedia..." ] ]
            else
                []

        selectedValue = 
            model.selectedSource
                |> Maybe.map .id
                |> Maybe.withDefault ""

        multimediaOptions =
            option [ Attrs.value "" ] [ text "Select multimedia..." ]
                :: List.map (\source -> 
                    option [ Attrs.value source.id ] 
                        [ text (source.id ++ " (" ++ source.mediaType ++ ")") ]
                   ) model.sources
    in
    div [ Attrs.class "multimedia-search-container" ]
        ([ div [ Attrs.class "multimedia-search-filters mb-3" ]
            [ text "Media Type: "
            , label [ Attrs.class "form-check-label me-3" ]
                [ input 
                    [ Attrs.type_ "radio"
                    , Attrs.name "mediaType"
                    , Attrs.value "all"
                    , Attrs.checked (model.filters.mediaType == "all")
                    , Attrs.class "form-check-input me-1"
                    , Events.onCheck (\_ -> SetMediaTypeFilter "all")
                    ] []
                , text " All "
                ]
            , label [ Attrs.class "form-check-label me-3" ]
                [ input 
                    [ Attrs.type_ "radio"
                    , Attrs.name "mediaType"
                    , Attrs.value "audio"
                    , Attrs.checked (model.filters.mediaType == "audio")
                    , Attrs.class "form-check-input me-1"
                    , Events.onCheck (\_ -> SetMediaTypeFilter "audio")
                    ] []
                , text " Audio "
                ]
            , label [ Attrs.class "form-check-label me-3" ]
                [ input 
                    [ Attrs.type_ "radio"
                    , Attrs.name "mediaType"
                    , Attrs.value "video"
                    , Attrs.checked (model.filters.mediaType == "video")
                    , Attrs.class "form-check-input me-1"
                    , Events.onCheck (\_ -> SetMediaTypeFilter "video")
                    ] []
                , text " Video"
                ]
            ]
        , select
            [ Attrs.class "form-select"
            , Attrs.id "multimedia-search-select"
            , Attrs.value selectedValue
            , Events.onInput SelectSource
            ]
            multimediaOptions
        ] ++ loadingIndicator)


-- Public API functions
getSelectedSource : Model -> Maybe Source
getSelectedSource model =
    model.selectedSource


isSearching : Model -> Bool
isSearching model =
    model.isLoading