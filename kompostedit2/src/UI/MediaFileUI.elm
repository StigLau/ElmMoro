module UI.MediaFileUI exposing (showMediaFileList, editSpecifics)

import Html exposing (..)
import Html.Attributes exposing (class, href, src, style, type_, placeholder)
import Html.Events exposing (onInput, onClick)
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Button as Button
import Models.BaseModel exposing (Komposition, Mediafile)
import Models.Msg exposing (Msg)
import Models.DvlSpecificsModel as DvlSpecificsModel exposing (Msg(EditMediaFile))
import Navigation.AppRouting exposing (Page(Kompost))

editSpecifics : Komposition -> Html DvlSpecificsModel.Msg
editSpecifics kompo =
    let editable = case kompo.revision of
            "" -> False
            _ -> True
    in
        div [] [ h1 [] [ text "Editing Specifics" ]
        , Form.form [ class "container" ]
            [ (wrapping "Name" (Input.text [ Input.id "Name", Input.defaultValue kompo.name, Input.onInput DvlSpecificsModel.SetKompositionName, Input.disabled editable]))
            , (wrapping "Revision" (Input.text [ Input.id "Revision", Input.defaultValue kompo.revision, Input.disabled True]))
            , (wrapping "BPM" (Input.number [ Input.id "bpm", Input.defaultValue (toString kompo.bpm), Input.onInput DvlSpecificsModel.SetBpm ]))
            , (wrapping "Media link" (Input.text [ Input.id "Media link", Input.defaultValue kompo.mediaFile.fileName, Input.onInput DvlSpecificsModel.SetFileName ]))
            , (wrapping "Checksum" (Input.text [ Input.id "Checksum", Input.defaultValue kompo.mediaFile.checksum, Input.onInput DvlSpecificsModel.SetChecksum ]))
            , Button.button [ Button.secondary, Button.onClick (DvlSpecificsModel.InternalNavigateTo Kompost) ] [ text "Save" ]
            ]
        ]

showMediaFileList : List Models.BaseModel.Mediafile -> Html Models.Msg.Msg
showMediaFileList mediaFile =
    div [] (mediaFile |> List.map showSingleMediaFile)


showSingleMediaFile : Models.BaseModel.Mediafile -> Html Models.Msg.Msg
showSingleMediaFile mf =
    Grid.row []
        [ Grid.col [] [ Html.map Models.Msg.DvlSpecificsMsg(Button.button [ Button.secondary, Button.small, Button.onClick (EditMediaFile mf.fileName) ] [ text mf.fileName ]) ]
        , Grid.col [] [ text <| toString mf.startingOffset ]
        , Grid.col [] [ text <| toString mf.checksum ]
        ]

wrapping identifier funk =
    Form.row [  ]
        [ Form.colLabel [ Col.xs4 ]
            [ text identifier ]
        , Form.col [ Col.xs8 ]
            [ funk ]
        ]