module UI.MakeShitApp exposing (..)

import Models.MsgModel exposing (Msg, Config, Msg(..))
import Html exposing (..)
import Html.Attributes exposing (class, href, type_, placeholder)
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.CDN as CDN
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Select as Select
import Bootstrap.Form.Checkbox as Chk
import Bootstrap.Button as Button


gridForm : Config msg -> Html Msg
gridForm config =
    div []
        [ h1 [] [ text "Editing Segment" ]
        , Form.form [ class "container" ]
            [ h3 [] [ text "Header in form" ]
            , Form.row [ Form.rowSuccess ]
                [ Form.colLabel [ Col.xs4 ] [ text "Segment ID:" ]
                , Form.col [ Col.xs8 ]
                    [ Input.text
                        [ Input.id "segmentId", Input.success, Input.onInput SetSegmentId ]
                    , Form.validationText [] [ text "This was cool !" ]
                    , Form.help [] [ text "Should be something..." ]
                    ]
                ]
            , Form.row []
                [ Form.colLabelSm [ Col.xs4 ] [ text "Start and end" ]
                , Form.col [ Col.xs4 ]
                    [ Input.number [ Input.small, Input.onInput SetSegmentStart, Input.attrs [ placeholder "Start" ]]
                    , Form.help [] [ text "5 digits" ]
                    ]
                , Form.col [ Col.xs4 ]
                    [ Input.number [ Input.small, Input.onInput SetSegmentEnd, Input.attrs [ placeholder "End" ] ]
                    ]
                ]
            , Form.row [ Form.rowWarning ]
                [ Form.colLabel [ Col.xs4 ] [  ]
                , Form.col []
                        [ Button.button
                          [ Button.success, Button.small, Button.onClick UpdateSegment]
                          [ text "Store" ]
                        ]
                    ]
                ]
            ]