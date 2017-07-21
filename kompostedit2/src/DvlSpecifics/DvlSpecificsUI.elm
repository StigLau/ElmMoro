module DvlSpecifics.DvlSpecificsUI exposing (showSpecifics, editSpecifics)

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
import DvlSpecifics.Msg as SpecificsMsg exposing (Msg)
import DvlSpecifics.SourcesUI exposing (showMediaFileList)
import Navigation.AppRouting exposing (Page(KompostUI))
import Common.UIFunctions exposing (selectItems)
import Common.StaticVariables

editSpecifics : Komposition -> Html SpecificsMsg.Msg
editSpecifics kompo =
    let editable = case kompo.revision of
            "" -> False
            _ -> True
    in
        div [] [ h1 [] [ text "Editing Specifics" ]
        , Form.form [ class "container" ]
            [(wrapping "Name" (Input.text [ Input.id "Name", Input.defaultValue kompo.name, Input.onInput SpecificsMsg.SetKompositionName, Input.disabled editable]))
            , (wrapping "Revision" (Input.text [ Input.id "Revision", Input.defaultValue kompo.revision, Input.disabled True]))
            , (wrapping "BPM" (Input.number [ Input.id "bpm", Input.defaultValue (toString kompo.bpm), Input.onInput SpecificsMsg.SetBpm ]))
            , (wrapping "Type" (Select.select [ Select.onChange SpecificsMsg.SetDvlType ] (selectItems kompo.dvlType Common.StaticVariables.komposionTypes) ))
            , Button.button [ Button.secondary, Button.onClick (SpecificsMsg.InternalNavigateTo KompostUI) ] [ text "<- Back" ]
            ]
        ]

showSpecifics : Komposition -> Html Models.Msg.Msg
showSpecifics kompo =
    Grid.container []
        [ addRow "Name" (text kompo.name)
        , addRow "Revision" (text kompo.revision)
        , addRow "BPM" (text (toString kompo.bpm))
        , Grid.row [] [ Grid.col [] [], Grid.col [] [], Grid.col [] [ Button.button [ Button.secondary, Button.onClick Models.Msg.EditSpecifics ] [ text "Edit Specifics" ] ]]
        , h4 []  [ text "Sources:" ]
        , showMediaFileList kompo.sources
        , Grid.row [] [ Grid.col [] [ ] , Grid.col [] [], Grid.col []
            [ Html.map Models.Msg.DvlSpecificsMsg(Button.button [ Button.secondary, Button.onClick (SpecificsMsg.EditMediaFile "") ] [ text "New Source" ])
            ] ]
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