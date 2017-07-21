module DvlSpecifics.SourcesUI exposing (showMediaFileList, editSpecifics)

import Html exposing (..)
import Html.Attributes exposing (class, href, src, style, type_, placeholder)
import Html.Events exposing (onInput, onClick)
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Button as Button
import Models.BaseModel exposing (Model, Mediafile)
import Models.Msg exposing (Msg(DvlSpecificsMsg))
import DvlSpecifics.Msg as SpecificsMsg exposing (Msg(EditMediaFile, SaveMediaFile, DeleteMediaFile, FetchAndLoadMediaFile, FetchStuffFromRemoteServer))

editSpecifics : Model -> Html SpecificsMsg.Msg
editSpecifics model =
        let mediaFile = model.editingMediaFile
        in div [] [ h1 [] [ text "Editing Source" ]
        , Form.form [ class "container" ]
            [ (wrapping "ID" (Input.text [ Input.id "id", Input.defaultValue mediaFile.id, Input.onInput SpecificsMsg.SetId]))
            , (wrapping "URL" (Input.text [ Input.id "URLz", Input.defaultValue mediaFile.url, Input.onInput SpecificsMsg.SetURL]))
            , (wrapping "Starting Offset" (Input.text [ Input.id "Starting Offset", Input.defaultValue (toString mediaFile.startingOffset),
                Input.onInput SpecificsMsg.SetOffset ]))
            , (wrapping "Checksum" (Input.text [ Input.id "Checksumz", Input.defaultValue mediaFile.checksum, Input.onInput SpecificsMsg.SetChecksum ]))
            , Form.row []
                [ Form.colLabel [ Col.xs4 ]
                    []
                , Form.col []
                    [ Button.button [ Button.primary, Button.small, Button.onClick SaveMediaFile ] [ text "Save" ] ]
                , Form.col []
                    [  ]
                , Form.col []
                    [ Button.button [ Button.warning, Button.small, Button.onClick (DeleteMediaFile mediaFile.id)] [ text "Delete" ] ]
                , Form.col []
                    [ ( Button.button [ Button.small, Button.onClick (FetchStuffFromRemoteServer mediaFile.id)] [ text "Evaluate Checksum" ] ) ]
                ]
            , Grid.simpleRow [Grid.col [] [text ("Status: " ++ toString model.statusMessage)]]
            ]
        ]

showMediaFileList : List Models.BaseModel.Mediafile -> Html Models.Msg.Msg
showMediaFileList mediaFile =
    div [] (mediaFile |> List.map showSingleMediaFile)


showSingleMediaFile : Models.BaseModel.Mediafile -> Html Models.Msg.Msg
showSingleMediaFile mf =
    Grid.row []
        [ Grid.col [] [ Html.map Models.Msg.DvlSpecificsMsg(
                Button.button [ Button.secondary, Button.small, Button.onClick (EditMediaFile mf.id) ] [ text mf.id ]) ]
        , Grid.col [] [ Html.map Models.Msg.DvlSpecificsMsg(Button.button
                [ Button.secondary, Button.small, Button.onClick (FetchAndLoadMediaFile mf.id) ] [ text "Fetch" ]) ]
        ]

wrapping identifier funk =
    Form.row [  ]
        [ Form.colLabel [ Col.xs4 ]
            [ text identifier ]
        , Form.col [ Col.xs8 ]
            [ funk ]
        ]