module Source.View exposing (..)

import Bootstrap.Button as Button
import Bootstrap.Grid as Grid
import Html exposing (Html, div, text)
import Models.BaseModel exposing (Source)
import Models.Msg exposing (Msg(..))
import Source.Msg exposing (Msg(..))

sourceNewButton :Html Models.Msg.Msg
sourceNewButton =
        Grid.row []
            [ Grid.col [] []
            , Grid.col [] 
                [ Html.map Models.Msg.SourceMsg (Button.button [ Button.primary, Button.small, Button.onClick (Source.Msg.EditMediaFile "") ] [ text "New Source" ])
                ]
            , Grid.col []
                [ Button.button [ Button.info, Button.small, Button.onClick ShowMultimediaSearch ] [ text "Browse Multimedia" ]
                ]
            ]


multimediaSearchButtons : Html Models.Msg.Msg
multimediaSearchButtons =
    Grid.row []
        [ Grid.col [] []
        , Grid.col []
            [ Button.button [ Button.info, Button.small, Button.onClick ShowMultimediaSearch ] [ text "Search Library (Modal)" ]
            ]
        , Grid.col []
            [ Button.button [ Button.secondary, Button.small, Button.onClick ShowMultimediaSearch ] [ text "Search Library (Page)" ]
            ]
        ]

editSources : List Source -> Html Models.Msg.Msg
editSources sources =
        showSourceList sources

showSourceList : List Source -> Html Models.Msg.Msg
showSourceList source =
    div [] (List.map showSingleSource source)


showSingleSource : Source -> Html Models.Msg.Msg
showSingleSource source =
    Grid.row []
        [ Grid.col []
            [ Html.map SourceMsg
                (Button.button [ Button.secondary, Button.small, Button.onClick (EditMediaFile source.id) ] [ text source.id ])
            ]
        ]
