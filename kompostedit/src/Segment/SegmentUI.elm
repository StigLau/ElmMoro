module Segment.SegmentUI exposing (segmentForm, showSegmentList)

import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Form.Checkbox as Checkbox
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Select as Select
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Common.UIFunctions exposing (selectItems)
import Html exposing (..)
import Html.Attributes exposing (class, for, placeholder)
import Models.BaseModel exposing (..)
import Segment.SegmentRendering exposing (gapVisualizer)
import Segment.Msg as Msg exposing (..)
import Set exposing (Set)


segmentForm : Model -> Html Msg
segmentForm model =
    div []
        [ h1 [] [ text "Editing Segment" ]
        , Form.form [ class "container" ]
            [ Form.label [ for "segmentId" ] []
            , Form.row []
                [ Form.colLabel [ Col.xs2 ] [text "Segment ID"]
                , Form.col [] [ Checkbox.checkbox [ Checkbox.onCheck SegmentSearchVisible, Checkbox.checked model.checkboxVisible ] ("Search" ) ] ]
            , if model.checkboxVisible then Html.div [] [sourceSelection model, segmentIdSelection model]
                else Html.div [] [Form.row [] [ Form.col [Col.xs8] [(Input.text [ Input.id "id", Input.value model.segment.id, Input.onInput SetSegmentId ])]]]
            , Form.row []
                [ Form.colLabelSm [ Col.xs4 ] [ text "Start" ]
                , Form.colLabelSm [ Col.xs4 ] [ text "Duration" ]
                , Form.colLabelSm [ Col.xs4 ] [ text "End" ]
                ]
            , Form.row []
                [ Form.colLabelSm [ Col.xs4 ]
                    [ Input.number
                        [ Input.small
                        , Input.value (String.fromInt model.segment.start)
                        , Input.onInput SetSegmentStart
                        , Input.attrs [ placeholder "Start" ]
                        ]
                    ]
                , Form.col []
                    [ Input.number
                        [ Input.small
                        , Input.value (String.fromInt model.segment.duration)
                        , Input.onInput SetSegmentDuration
                        , Input.attrs [ placeholder "Duration" ]
                        ]
                    ]
                , Form.col []
                    [ Input.number
                        [ Input.small
                        , Input.value (String.fromInt model.segment.end)
                        , Input.onInput SetSegmentEnd
                        , Input.attrs [ placeholder "End" ]
                        ]
                    ]
                ]
            , Form.row []
                [ Form.colLabel [ Col.xs4 ]
                    []
                , Form.col []
                    [ Button.button [ Button.primary, Button.small, Button.onClick UpdateSegment ] [ text "Back" ] ]
                , Form.col []
                    []
                , Form.col []
                    [ Button.button [ Button.warning, Button.small, Button.onClick DeleteSegment ] [ text "Remove" ] ]
                ]
            ]
        ]


showSegmentList : List Segment -> Html Msg
showSegmentList segs =
    div []
        (Grid.row []
            [ Grid.col [] [ text "Segment" ], Grid.col [] [ text "Start" ], Grid.col [] [ text "Duration" ] ]
            :: (List.sortBy .start segs |> List.map showSingleSegment)
        )


showSingleSegment : Segment -> Html Msg
showSingleSegment segment =
    Grid.row []
        [ Grid.col [] [ Button.button [ Button.secondary, Button.small, Button.onClick (EditSegment segment.id) ] [ text segment.id ] ]
        , Grid.col [] [ text <| String.fromInt segment.start ]
        , Grid.col [] [ text <| String.fromInt segment.duration ]
        ]

sourceSelection : Model -> Html Msg
sourceSelection model =
        Select.select [ Select.id "sourceId", Select.onChange SetSourceId ]
            (selectItems model.segment.sourceId (List.map (\segment -> segment.id) model.kompost.sources))

segmentIdSelection : Model -> Html Msg
segmentIdSelection model =
        Select.select [ Select.id "segmentId", Select.onChange SetSegmentId ]
            (selectItems model.segment.id (Set.toList model.subSegmentList ))
