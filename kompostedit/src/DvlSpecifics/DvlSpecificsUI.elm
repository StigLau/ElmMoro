module DvlSpecifics.DvlSpecificsUI exposing (editSpecifics, showSpecifics)

import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Select as Select
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Common.StaticVariables
import Common.UIFunctions exposing (selectItems)
import DvlSpecifics.Msg as SpecificsMsg exposing (Msg)
import DvlSpecifics.SourcesUI exposing (showMediaFileList)
import Html exposing (..)
import Html.Attributes exposing (class)
import Models.BaseModel exposing (..)
import Models.Msg exposing (Msg(..))
import Navigation.Page as Page exposing (Page)


editSpecifics : Komposition -> Html SpecificsMsg.Msg
editSpecifics kompo =
    let
        specificsUI =
            Form.form [ class "container" ]
                [ h1 [] [ text "Editing Specifics" ]
                , (wrapping "Name" (Input.text [ Input.id "Name", Input.value kompo.name, Input.onInput SpecificsMsg.SetKompositionName, Input.disabled (kompo.revision /= "") ]))
                , (wrapping "Revision" (Input.text [ Input.id "Revision", Input.value kompo.revision, Input.disabled True ]))
                , (wrapping "BPM" (Input.number [ Input.id "bpm", Input.value (String.fromFloat kompo.bpm), Input.onInput SpecificsMsg.SetBpm ]))
                , (wrapping "Type" (Select.select [ Select.onChange SpecificsMsg.SetDvlType ] (selectItems kompo.dvlType Common.StaticVariables.komposionTypes)))
                ]

        bpm =
            case kompo.beatpattern of
                Just theBpm ->
                    theBpm

                Nothing ->
                    BeatPattern 0 0 0

        configUI =
            case kompo.dvlType of
                "Komposition" ->
                    Form.form [ class "container" ]
                        [ h3 [] [ text "Video Config" ]
                        , (wrapping "Width" (Input.number [ Input.id "width", Input.value (String.fromInt kompo.config.width), Input.onInput SpecificsMsg.SetWidth ]))
                        , (wrapping "Height" (Input.number [ Input.id "height", Input.value (String.fromInt kompo.config.height), Input.onInput SpecificsMsg.SetHeight ]))
                        , (wrapping "Framerate" (Input.number [ Input.id "framerate", Input.value (String.fromInt kompo.config.framerate), Input.onInput SpecificsMsg.SetFramerate ]))
                        , (wrapping "Extension Type"
                            (Select.select [ Select.id "segmentId", Select.onChange SpecificsMsg.SetExtensionType ]
                                (selectItems kompo.config.extensionType Common.StaticVariables.extensionTypes)
                            )
                          )
                        , h3 [] [ text "Beat Pattern" ]
                        , (wrapping "From BPM" (Input.number [ Input.id "frombpm", Input.value (String.fromInt bpm.fromBeat), Input.onInput SpecificsMsg.SetFromBpm ]))
                        , (wrapping "To BPM" (Input.number [ Input.id "tobpm", Input.value (String.fromInt bpm.toBeat), Input.onInput SpecificsMsg.SetToBpm ]))
                        , (wrapping "Master BPM" (Input.number [ Input.id "masterbpm", Input.value (String.fromFloat bpm.masterBPM), Input.onInput SpecificsMsg.SetMasterBpm ]))
                        ]

                _ ->
                    div [] []
    in
    div []
        [ specificsUI
        , configUI
        , Button.button [ Button.primary, Button.onClick (SpecificsMsg.InternalNavigateTo Page.KompostUI) ] [ text "<- Back" ]
        ]


showSpecifics : Model -> Html Models.Msg.Msg
showSpecifics model =
    Grid.container []
        [ addRow "Name" (text model.kompost.name)
        , addRow "Revision" (text model.kompost.revision)
        , addRow "BPM" (text (String.fromFloat model.kompost.bpm))
        , Grid.row [] [ Grid.col [] [], Grid.col [] [], Grid.col [] [ Button.button [ Button.secondary, Button.onClick Models.Msg.EditSpecifics ] [ text "Edit Specifics" ] ] ]
        , h4 [] [ text "Original Sources:" ]
        , showMediaFileList model.kompost.sources
        , Grid.row []
            [ Grid.col [] []
            , Grid.col [] []
            , Grid.col []
                [ Html.map Models.Msg.SourceMsg (Button.button [ Button.secondary, Button.onClick (SpecificsMsg.EditMediaFile "") ] [ text "New Source" ])
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
