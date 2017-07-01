module UI.DvlSpecificsUI exposing (showSpecifics, editSpecifics)

import Models.MsgModel exposing (Msg, Config,  Msg(..))
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
import Models.KompostModels exposing (Komposition)
import RemoteData exposing (WebData)

editSpecifics : Komposition -> Config msg -> Html msg
editSpecifics kompo config =
    div [] [ h1 [] [ text "Editing Specifics" ]
        , Form.form [ class "container" ]
            [ editableRow "Name" kompo.name config.onClickSetSegmentID
            , editableRow "Revision" kompo.revision config.onClickSetSegmentID
            , let bpm = case kompo.bpm of
                    Just bpm -> bpm
                    _ -> ""
              in editableRow "BPM" bpm config.onClickSetSegmentID
            , editableRow "Media link" kompo.mediaFile.fileName config.onClickSetSegmentID
            , editableRow "Checksum" kompo.mediaFile.checksum config.onClickSetSegmentID
            , Button.button [ Button.secondary, Button.onClick (config.onClickgotoKompositionPage) ] [ text "Back" ]
            , Button.button [ Button.primary, Button.small, Button.onClick (config.onClickEditSpecifics) ] [ text "Save" ]
            ]
        ]

showSpecifics kompo config =
    Grid.container []
        [ addRow "Name" (text kompo.name)
        , addRow "Revision" (text kompo.revision)
        , let bpm = case kompo.bpm of
                            Just bpm -> bpm
                            _ -> ""
                      in addRow "BPM" (text bpm)
        , addRow "Media link" (a [ Html.Attributes.href kompo.mediaFile.fileName ] [ text kompo.mediaFile.fileName ])
        , addRow "Checksum" (text kompo.mediaFile.checksum)
        , Button.button [ Button.primary, Button.small, Button.onClick (config.onClickEditSpecifics) ] [ text "Edit Specifics" ]
        ]

addRow title htmlIsh =
    Grid.row []
        [ Grid.col [] [ text title ]
        , Grid.col [] [ htmlIsh ]
        ]

editableRow identifier defaultValue action =
        Form.row [  ]
          [ Form.colLabel [ Col.xs4 ]
              [ text identifier ]
          , Form.col [ Col.xs8 ]
              [ Input.text [ Input.id identifier, Input.defaultValue defaultValue, Input.onInput action ] ]
          ]