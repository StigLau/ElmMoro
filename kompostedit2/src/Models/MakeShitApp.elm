module Models.MakeShitApp exposing (..)

import MsgModel exposing (Msg, Config)
import Html exposing (..)
import Html.Attributes exposing (class, href, type_, placeholder)
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.CDN as CDN
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Select as Select
import Bootstrap.Form.Checkbox as Chk


gridForm : Config msg -> Html Msg
gridForm config =
    div []
        [ h1 [] [ text "Horizontal (grid) form" ]
        , Form.form [ class "container" ]
            [ h3 [] [ text "Header in form" ]
            , Form.row [ Form.rowSuccess ]
                [ Form.colLabel [ Col.xs4 ] [ text "Fill in:" ]
                , Form.col [ Col.xs8 ]
                    [ Input.text
                        [ Input.id "rowinput", Input.success ]
                    , Form.validationText [] [ text "This was cool !" ]
                    , Form.help [] [ text "Should be something..." ]
                    ]
                ]
            , Form.row []
                [ Form.colLabelSm [ Col.xs4 ] [ text "Postal" ]
                , Form.col [ Col.xs4 ]
                    [ Input.text [ Input.small ]
                    , Form.help [] [ text "5 digits" ]
                    ]
                , Form.col [ Col.xs4 ]
                    [ Input.text
                        [ Input.small, Input.attrs [ placeholder "Place" ] ]
                    ]
                ]
            , Form.row []
                [ Form.col [ Col.offsetXs4, Col.xs8 ]
                    [ Chk.custom [] "Lonely checker" ]
                ]
            , Form.row [ Form.rowWarning ]
                [ Form.colLabel [ Col.xs4 ] [ text "Row select:" ]
                , Form.col [ Col.xs8 ]
                    [ Select.custom [ Select.id "rowcustomselect" ]
                        [ Select.item [] [ text "Option 1" ]
                        , Select.item [] [ text "Option 2" ]
                        ]
                    , Form.validationText [] [ text "Can't select option 1 (:" ]
                    ]
                ]
            ]
        ]

griddy config =
    Grid.container []
            [ Grid.row []
                [ Grid.col [] [ text "1 of 2"]
                , Grid.col [] [ text "2 of 2"]
                ]
            , Grid.row []
                [ Grid.col [] [ text "1 of 3"]
                , Grid.col [] [ text "2 of 3"]
                , Grid.col [] [ text "3 of 3"]
                ]
            ]