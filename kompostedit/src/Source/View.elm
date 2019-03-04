module Source.View exposing (..)


import Bootstrap.Button as Button
import Bootstrap.Grid as Grid
import Html exposing (Html, div, text)
import Models.Msg exposing (Msg(..))
import Source.Msg exposing (Msg(..))

--showMediaFileList : List  Source.Msg.Msg -> Html Msg
showMediaFileList mediaFile =
    div [] (List.map showSingleMediaFile mediaFile)


--showSingleMediaFile : Models.BaseModel.Source -> Html Msg
showSingleMediaFile mf =
    Grid.row []
        [ Grid.col []
            [ Html.map SourceMsg
                (Button.button [ Button.secondary, Button.small, Button.onClick (EditMediaFile mf.id) ] [ text mf.id ])
            ]
        , Grid.col []
            [ Html.map SourceMsg
                (Button.button
                    [ Button.secondary, Button.small, Button.onClick (FetchAndLoadMediaFile mf.id) ]
                    [ text "Fetch" ]
                )
            ]
        ]
