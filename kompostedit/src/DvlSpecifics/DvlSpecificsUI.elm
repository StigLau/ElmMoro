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
import Models.Msg exposing (Msg(EditSpecifics, DvlSpecificsMsg))
import DvlSpecifics.Msg as SpecificsMsg exposing (Msg)
import DvlSpecifics.SourcesUI exposing (showMediaFileList)
import Navigation.AppRouting exposing (Page(KompostUI))
import Common.UIFunctions exposing (selectItems)
import Common.StaticVariables


editSpecifics : Komposition -> Html SpecificsMsg.Msg
editSpecifics kompo =
    let
        specificsUI =
            Form.form [ class "container" ]
                [ h1 [] [ text "Editing Specifics" ]
                , (wrapping "Name" (Input.text [ Input.id "Name", Input.defaultValue kompo.name, Input.onInput SpecificsMsg.SetKompositionName, Input.disabled (kompo.revision /= "") ]))
                , (wrapping "Revision" (Input.text [ Input.id "Revision", Input.defaultValue kompo.revision, Input.disabled True ]))
                , (wrapping "BPM" (Input.number [ Input.id "bpm", Input.defaultValue (toString kompo.bpm), Input.onInput SpecificsMsg.SetBpm ]))
                , (wrapping "Type" (Select.select [ Select.onChange SpecificsMsg.SetDvlType ] (selectItems kompo.dvlType Common.StaticVariables.komposionTypes)))
                ]

        bpm =
            case kompo.beatpattern of
                Just bpm ->
                    bpm

                Nothing ->
                    BeatPattern 0 0 0

        configUI =
            case kompo.dvlType of
                "Komposition" ->
                    Form.form [ class "container" ]
                        [ h3 [] [ text "Video Config" ]
                        , (wrapping "Width" (Input.number [ Input.id "width", Input.defaultValue (toString kompo.config.width), Input.onInput SpecificsMsg.SetWidth ]))
                        , (wrapping "Height" (Input.number [ Input.id "height", Input.defaultValue (toString kompo.config.height), Input.onInput SpecificsMsg.SetHeight ]))
                        , (wrapping "Framerate" (Input.number [ Input.id "framerate", Input.defaultValue (toString kompo.config.framerate), Input.onInput SpecificsMsg.SetFramerate ]))
                        , (wrapping "Extension Type"
                            (Select.select [ Select.id "segmentId", Select.onChange SpecificsMsg.SetExtensionType ]
                                (selectItems kompo.config.extensionType Common.StaticVariables.extensionTypes)
                            )
                          )
                        , h3 [] [ text "Beat Pattern" ]
                        , (wrapping "From BPM" (Input.number [ Input.id "frombpm", Input.defaultValue (toString bpm.fromBeat), Input.onInput SpecificsMsg.SetFromBpm ]))
                        , (wrapping "To BPM" (Input.number [ Input.id "tobpm", Input.defaultValue (toString bpm.toBeat), Input.onInput SpecificsMsg.SetToBpm ]))
                        , (wrapping "Master BPM" (Input.number [ Input.id "masterbpm", Input.defaultValue (toString bpm.masterBPM), Input.onInput SpecificsMsg.SetMasterBpm ]))
                        ]

                _ ->
                    div [] []
    in
        div []
            [ specificsUI
            , configUI
            , Button.button [ Button.primary, Button.onClick (SpecificsMsg.InternalNavigateTo KompostUI) ] [ text "<- Back" ]
            ]


showSpecifics : Model -> Html Models.Msg.Msg
showSpecifics model =
    let
        sourcesText =
            case model.showSnippets of
                False ->
                    "Original Sources:"

                True ->
                    "Snippets:"
    in
        Grid.container []
            [ addRow "Name" (text model.kompost.name)
            , addRow "Revision" (text model.kompost.revision)
            , addRow "BPM" (text (toString model.kompost.bpm))
            , Grid.row [] [ Grid.col [] [], Grid.col [] [], Grid.col [] [ Button.button [ Button.secondary, Button.onClick Models.Msg.EditSpecifics ] [ text "Edit Specifics" ] ] ]
            , h4 [] [ text sourcesText ]
            , showMediaFileList model.kompost.sources model.showSnippets
            , Grid.row []
                [ Grid.col [] []
                , Grid.col [] []
                , Grid.col []
                    [ Html.map Models.Msg.DvlSpecificsMsg (Button.button [ Button.secondary, Button.onClick (SpecificsMsg.EditMediaFile "") ] [ text "New Source" ])
                    ]
                ]
            ]


addRow title htmlIsh =
    Grid.row []
        [ Grid.col [] [ text title ]
        , Grid.col [] [ htmlIsh ]
        ]


wrapping identifier funk =
    Form.row []
        [ Form.colLabel [ Col.xs4 ]
            [ text identifier ]
        , Form.col [ Col.xs8 ]
            [ funk ]
        ]
