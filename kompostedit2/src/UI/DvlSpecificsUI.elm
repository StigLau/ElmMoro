module UI.DvlSpecificsUI exposing (showSpecifics, editSpecifics)

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
import RemoteData exposing (WebData)
import Models.BaseModel exposing (..)
import Models.Msg exposing(Msg(EditSpecifics, DvlSpecificsMsg))
import Models.DvlSpecificsModel as DvlSpecificsModel exposing (..)
import Models.DvlSpecificsModel exposing (..)
import UI.MediaFileUI exposing (showMediaFileList)
import Navigation.AppRouting exposing (Page(Kompost))

editSpecifics : Komposition -> Html DvlSpecificsModel.Msg
editSpecifics kompo =
    let editable = case kompo.revision of
            "" -> False
            _ -> True
    in
        div [] [ h1 [] [ text "Editing Specifics" ]
        , Form.form [ class "container" ]
            [(wrapping "Name" (Input.text [ Input.id "Name", Input.defaultValue kompo.name, Input.onInput DvlSpecificsModel.SetKompositionName, Input.disabled editable]))
            , (wrapping "Revision" (Input.text [ Input.id "Revision", Input.defaultValue kompo.revision, Input.disabled True]))
            , (wrapping "BPM" (Input.number [ Input.id "bpm", Input.defaultValue (toString kompo.bpm), Input.onInput DvlSpecificsModel.SetBpm ]))
            , (wrapping "Media link" (Input.text [ Input.id "Media link", Input.defaultValue kompo.mediaFile.fileName, Input.onInput DvlSpecificsModel.SetFileName ]))
            , (wrapping "Checksum" (Input.text [ Input.id "Checksum", Input.defaultValue kompo.mediaFile.checksum, Input.onInput DvlSpecificsModel.SetChecksum ]))
            , Button.button [ Button.secondary, Button.onClick (EditMediaFile "") ] [ text "New Source" ]
            , Button.button [ Button.secondary, Button.onClick (DvlSpecificsModel.InternalNavigateTo Kompost) ] [ text "Save" ]
            ]
        ]

showSpecifics : Komposition -> Html Models.Msg.Msg
showSpecifics kompo =
    Grid.container []
        [ addRow "Name" (text kompo.name)
        , addRow "Revision" (text kompo.revision)
        , addRow "BPM" (text (toString kompo.bpm))
        , addRow "Media link" (a [ Html.Attributes.href kompo.mediaFile.fileName ] [ text kompo.mediaFile.fileName ])
        , addRow "Checksum" (text kompo.mediaFile.checksum)
        , addRow "sources" (showMediaFileList kompo.sources)
        , Grid.row [] [ Grid.col [] [ ] , Grid.col [] [  ],
            Grid.col [] [  Button.button [ Button.primary, Button.small, Button.onClick Models.Msg.EditSpecifics ] [ text "Edit Specifics" ] ] ]
        ]

addRow title htmlIsh =
    Grid.row []
        [ Grid.col [] [ text title ]
        , Grid.col [] [ htmlIsh ]
        ]

wrapping identifier funk =
    Form.row [  ]
        [ Form.colLabel [ Col.xs4 ]
            [ text identifier ]
        , Form.col [ Col.xs8 ]
            [ funk ]
        ]