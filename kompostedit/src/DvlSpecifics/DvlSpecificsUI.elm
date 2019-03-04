module DvlSpecifics.DvlSpecificsUI exposing (editSpecifics, showSpecifics)

import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Select as Select
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Common.StaticVariables
import Common.UIFunctions exposing (selectItems)
import DvlSpecifics.Msg exposing (Msg(..))
import Source.Msg exposing (Msg(..))
import Html exposing (..)
import Html.Attributes exposing (class)
import Models.BaseModel exposing (..)
import Models.Msg exposing (Msg(..))
import Navigation.Page as Page exposing (Page)


editSpecifics : Komposition -> Html DvlSpecifics.Msg.Msg
editSpecifics kompo =
    let
        specificsUI =
            Form.form [ class "container" ]
                [ h1 [] [ text "Editing Specifics" ]
                , (wrapping "Name" (Input.text [ Input.id "Name", Input.value kompo.name, Input.onInput DvlSpecifics.Msg.SetKompositionName, Input.disabled (kompo.revision /= "") ]))
                , (wrapping "Revision" (Input.text [ Input.id "Revision", Input.value kompo.revision, Input.disabled True ]))
                , (wrapping "BPM" (Input.number [ Input.id "bpm", Input.value (String.fromFloat kompo.bpm), Input.onInput SetBpm ]))
                , (wrapping "Type" (Select.select [ Select.onChange DvlSpecifics.Msg.SetDvlType ] (selectItems kompo.dvlType Common.StaticVariables.komposionTypes)))
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
                        , (wrapping "Width" (Input.number [ Input.id "width", Input.value (String.fromInt kompo.config.width), Input.onInput DvlSpecifics.Msg.SetWidth ]))
                        , (wrapping "Height" (Input.number [ Input.id "height", Input.value (String.fromInt kompo.config.height), Input.onInput DvlSpecifics.Msg.SetHeight ]))
                        , (wrapping "Framerate" (Input.number [ Input.id "framerate", Input.value (String.fromInt kompo.config.framerate), Input.onInput DvlSpecifics.Msg.SetFramerate ]))
                        , (wrapping "Extension Type"
                            (Select.select [ Select.id "segmentId", Select.onChange DvlSpecifics.Msg.SetExtensionType ]
                                (selectItems kompo.config.extensionType Common.StaticVariables.extensionTypes)
                            )
                          )
                        , h3 [] [ text "Beat Pattern" ]
                        , (wrapping "From BPM" (Input.number [ Input.id "frombpm", Input.value (String.fromInt bpm.fromBeat), Input.onInput DvlSpecifics.Msg.SetFromBpm ]))
                        , (wrapping "To BPM" (Input.number [ Input.id "tobpm", Input.value (String.fromInt bpm.toBeat), Input.onInput DvlSpecifics.Msg.SetToBpm ]))
                        , (wrapping "Master BPM" (Input.number [ Input.id "masterbpm", Input.value (String.fromFloat bpm.masterBPM), Input.onInput DvlSpecifics.Msg.SetMasterBpm ]))
                        ]

                _ ->
                    div [] []
    in
    div []
        [ specificsUI
        , configUI
        , Button.button [ Button.primary, Button.onClick (DvlSpecifics.Msg.InternalNavigateTo Page.KompostUI) ] [ text "<- Back" ]
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
                [ Html.map Models.Msg.SourceMsg (Button.button [ Button.secondary, Button.onClick (Source.Msg.EditMediaFile "") ] [ text "New Source" ])
                ]
            ]
        ]

showMediaFileList : List Models.BaseModel.Source -> Html Msg
showMediaFileList mediaFile =
    div [] (List.map showSingleMediaFile mediaFile)


showSingleMediaFile : Models.BaseModel.Source -> Html Msg
showSingleMediaFile mf =
    Grid.row []
        [ Grid.col []
            [ Html.map SourceMsg
                (Button.button [ Button.secondary, Button.small, Button.onClick (EditMediaFile mf.id) ] [ text mf.id ])
            ]
        , Grid.col []
            [ Html.map SourceMsg
                (Button.button
                    [ Button.secondary, Button.small, Button.onClick (FetchAndLoadMediaFile mf.id) ]
                    [ text "Fetch" ]
                )
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
