module MultimediaSearch.Modal exposing (view)

import Bootstrap.Button as Button
import Bootstrap.Grid as Grid
import Bootstrap.Modal as Modal
import Html exposing (Html, div, h4, p, text)
import Html.Attributes exposing (class, style)
import Models.BaseModel exposing (Model, Source)
import Models.Msg exposing (Msg(..))
import MultimediaSearch.MultimediaSearch as MultimediaSearch


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
                        , Html.map MultimediaSearchMsg (MultimediaSearch.view model.multimediaSearch)
                        , selectedSourceInfo model.multimediaSearch
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
                , Button.onClick (addSelectedToKompost model)
                ] 
                [ text "Add to Sources" ]
            ]
        |> Modal.view (Modal.shown model.showMultimediaModal)


selectedSourceInfo : MultimediaSearch.Model -> Html Msg
selectedSourceInfo searchModel =
    case MultimediaSearch.getSelectedSource searchModel of
        Just source ->
            div [ class "multimedia-selected-info", style "margin-top" "20px", style "padding" "10px", style "background-color" "#f8f9fa", style "border-radius" "4px" ]
                [ h4 [] [ text "Selected:" ]
                , p [] 
                    [ text ("ID: " ++ source.id)
                    ]
                , p [] 
                    [ text ("Type: " ++ source.mediaType)
                    ]
                , p [] 
                    [ text ("URL: " ++ source.url)
                    ]
                ]
        
        Nothing ->
            div [ class "multimedia-no-selection", style "margin-top" "20px", style "padding" "10px", style "border" "1px dashed #ccc", style "border-radius" "4px" ]
                [ p [ style "margin" "0", style "color" "#6c757d" ] 
                    [ text "No item selected. Search and click on a result to select it." ]
                ]


addSelectedToKompost : Model -> Msg
addSelectedToKompost model =
    case MultimediaSearch.getSelectedSource model.multimediaSearch of
        Just source ->
            -- This would add the source to the kompost and close the modal
            -- For now, we'll just close the modal (the actual source addition would be implemented in Main.elm)
            ShowMultimediaSearch
        
        Nothing ->
            ShowMultimediaSearch