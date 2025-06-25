module MultimediaSearch.SimpleModal exposing (view)

import Bootstrap.Button as Button
import Bootstrap.Grid as Grid
import Bootstrap.Modal as Modal
import Html exposing (Html, div, h4, p, text)
import Html.Attributes exposing (class, style)
import Models.BaseModel exposing (Model, Source, MultimediaSearchState)
import Models.Msg exposing (Msg(..))
import MultimediaSearch.MultimediaSearch as MultimediaSearch
import Menu


view : Model -> Html Msg
view model =
    Modal.config (ShowMultimediaSearch)
        |> Modal.large
        |> Modal.h4 [] [ text "Browse Multimedia Library" ]
        |> Modal.body []
            [ Grid.container []
                [ Grid.row []
                    [ Grid.col []
                        [ p [] [ text "Search your multimedia library and select items to add as sources." ]
                        , Html.map MultimediaSearchMsg (MultimediaSearch.view (stateToModel model.multimediaSearchState))
                        ]
                    ]
                ]
            ]
        |> Modal.footer []
            [ Button.button 
                [ Button.secondary
                , Button.onClick ShowMultimediaSearch
                ] 
                [ text "Cancel" ]
            , Button.button 
                [ Button.primary
                , Button.onClick AddSelectedMultimediaSource
                ] 
                [ text "Add to Sources" ]
            ]
        |> Modal.view (if model.showMultimediaModal then Modal.shown else Modal.hidden)


-- Convert MultimediaSearchState to MultimediaSearch.Model
stateToModel : MultimediaSearchState -> MultimediaSearch.Model
stateToModel state =
    { sources = state.sources
    , autoState = Menu.empty
    , howManyToShow = 10
    , query = state.query
    , selectedSource = state.selectedSource
    , showMenu = state.showMenu
    , isLoading = state.isLoading
    , filters = { mediaType = state.mediaTypeFilter }
    }


searchInterface : MultimediaSearchState -> Html Msg
searchInterface searchState =
    div [ class "multimedia-search-interface", style "margin-bottom" "20px" ]
        [ div [ class "search-filters", style "margin-bottom" "10px" ]
            [ text "Media Type: All | Audio | Video (filters coming soon)" ]
        , div [ class "search-input" ]
            [ text "Search: (search functionality coming soon)" ]
        , if searchState.isLoading then
            div [ class "loading" ] [ text "Loading..." ]
          else
            text ""
        ]


searchResults : MultimediaSearchState -> Html Msg
searchResults searchState =
    div [ class "multimedia-search-results" ]
        [ if List.isEmpty searchState.sources then
            div [ class "no-results", style "padding" "20px", style "text-align" "center", style "color" "#6c757d" ]
                [ text "No multimedia items found. Try searching for something." ]
          else
            div []
                [ h4 [] [ text "Search Results:" ]
                , div [] (List.map viewSource searchState.sources)
                ]
        ]


viewSource : Source -> Html Msg
viewSource source =
    div 
        [ class "source-item"
        , style "padding" "10px"
        , style "border" "1px solid #dee2e6"
        , style "border-radius" "4px"
        , style "margin-bottom" "5px"
        , style "cursor" "pointer"
        ]
        [ div [ style "font-weight" "bold" ] [ text source.id ]
        , div [ style "font-size" "0.9em", style "color" "#6c757d" ] 
            [ text (source.mediaType ++ " - " ++ source.url) ]
        ]