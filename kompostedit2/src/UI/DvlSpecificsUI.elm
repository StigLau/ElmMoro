module UI.DvlSpecificsUI exposing (showSpecifics, editSpecifics)

import Models.BaseModel exposing ( ..)
import Html exposing (..)
import Html.Attributes exposing (class, href)
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.CDN as CDN
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Select as Select
import Bootstrap.Form.Checkbox as Chk
import Bootstrap.Button as Button
import Models.DvlSpecificsModel as DvlSpecificsModel exposing (..)
import RemoteData exposing (WebData)
import Navigation.AppRouting exposing (Page(Kompost))

editSpecifics : Komposition -> Html DvlSpecificsModel.Msg
editSpecifics kompo =
    div [] [ h1 [] [ text "Editing Specifics" ]
        , Form.form [ class "container" ]
            [ immutableRow "Name" kompo.name
            , immutableRow "Revision" kompo.revision
            , Form.row [  ]
                        [ Form.colLabel [ Col.xs4 ]
                            [ text "Bpm" ]
                        , Form.col [ Col.xs8 ]
                            [ Input.number [ Input.id "bpm", Input.defaultValue (toString kompo.bpm), Input.onInput DvlSpecificsModel.SetBpm ] ]
                        ]
            , editableRow "Media link" kompo.mediaFile.fileName SetFileName
            , editableRow "Checksum" kompo.mediaFile.checksum SetChecksum
            , Button.button [ Button.secondary, Button.onClick (DvlSpecificsModel.InternalNavigateTo Kompost) ] [ text "Save" ]
            ]
        ]

showSpecifics kompo config =
    Grid.container []
        [ addRow "Name" (text kompo.name)
        , addRow "Revision" (text kompo.revision)
        , addRow "BPM" (text (toString kompo.bpm))
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

immutableRow identifier defaultValue =
        Form.row [  ]
          [ Form.colLabel [ Col.xs4 ]
              [ text identifier ]
          , Form.col [ Col.xs8 ]
              [ Input.text [ Input.id identifier, Input.defaultValue defaultValue, Input.disabled True] ]
          ]

