module DvlSpecifics.SourcesUI exposing (showMediaFileList, editSpecifics)

import Html exposing (..)
import Html.Attributes exposing (class, href, src, style, type_, placeholder)
import Html.Events exposing (onInput, onClick)
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Checkbox as Checkbox
import Bootstrap.Button as Button
import Models.BaseModel exposing (Model, Source)
import Models.Msg exposing (Msg(DvlSpecificsMsg))
import Bootstrap.Form.Select as Select exposing (onChange)
import Common.UIFunctions exposing (selectItems)
import Common.StaticVariables exposing (extensionTypes)
import DvlSpecifics.Msg as SpecificsMsg exposing (Msg(EditMediaFile, SaveSource, DeleteSource, FetchAndLoadMediaFile, OrderChecksumEvalutation))


editSpecifics : Model -> Html SpecificsMsg.Msg
editSpecifics model =
    let
        mediaFile =
            model.editingMediaFile
        sourceSnippetText = case mediaFile.isSnippet of
            True -> "Snippet"
            False -> "Source"
    in
        div []
            [ h1 [] [ (Checkbox.checkbox [ Checkbox.onCheck SpecificsMsg.SetSnippet, Checkbox.checked mediaFile.isSnippet ] ("Editing " ++ sourceSnippetText)) ]
            , Form.form [ class "container" ]
                [ (wrapping "ID" (Input.text [ Input.id "id", Input.defaultValue mediaFile.id, Input.onInput SpecificsMsg.SetId ]))
                , (wrapping "URL" (Input.text [ Input.id "URLz", Input.defaultValue mediaFile.url, Input.onInput SpecificsMsg.SetURL ]))
                , (wrapping "Starting Offset"
                    (Input.text
                        [ Input.id "Starting Offset"
                        , Input.defaultValue (toString mediaFile.startingOffset)
                        , Input.onInput SpecificsMsg.SetOffset
                        ]
                    )
                  )
                , (wrapping "Checksums" (Input.text [ Input.id "Checksumz", Input.defaultValue mediaFile.checksum, Input.onInput SpecificsMsg.SetChecksum ]))
                , (wrapping "Extension Type"
                    (Select.select [ Select.id "segmentId", Select.onChange SpecificsMsg.SetSourceExtensionType ]
                        (selectItems mediaFile.extensionType Common.StaticVariables.extensionTypes)
                    )
                  )
                , (wrapping "Media type"
                    (Select.select [ Select.id "Media type", Select.onChange SpecificsMsg.SetSourceMediaType ]
                        (selectItems mediaFile.mediaType Common.StaticVariables.mediaTypes)
                    )
                  )
                , Form.row []
                    [ Form.colLabel [ Col.xs4 ]
                        []
                    , Form.col []
                        [ Button.button [ Button.primary, Button.small, Button.onClick SaveSource ] [ text "Back" ] ]
                    , Form.col []
                        []
                    , Form.col []
                        [ Button.button [ Button.warning, Button.small, Button.onClick (DeleteSource mediaFile.id) ] [ text "Remove" ] ]
                    , Form.col []
                        [ (Button.button [ Button.small, Button.onClick (OrderChecksumEvalutation mediaFile.id) ] [ text "Evaluate Checksum" ]) ]
                    ]
                ]
            ]


showMediaFileList : List Models.BaseModel.Source -> Bool -> Html Models.Msg.Msg
showMediaFileList mediaFile showSnippets =
    div []
        ((List.filter (\source -> showSnippets == source.isSnippet) mediaFile)
            |> List.map showSingleMediaFile
        )


showSingleMediaFile : Models.BaseModel.Source -> Html Models.Msg.Msg
showSingleMediaFile mf =
    Grid.row []
        [ Grid.col []
            [ Html.map Models.Msg.DvlSpecificsMsg
                (Button.button [ Button.secondary, Button.small, Button.onClick (EditMediaFile mf.id) ] [ text mf.id ])
            ]
        , Grid.col []
            [ Html.map Models.Msg.DvlSpecificsMsg
                (Button.button
                    [ Button.secondary, Button.small, Button.onClick (FetchAndLoadMediaFile mf.id) ]
                    [ text "Fetch" ]
                )
            ]
        ]


wrapping identifier funk =
    Form.row []
        [ Form.colLabel [ Col.xs4 ]
            [ text identifier ]
        , Form.col [ Col.xs8 ]
            [ funk ]
        ]
