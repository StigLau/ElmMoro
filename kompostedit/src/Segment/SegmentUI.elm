module Segment.SegmentUI exposing (segmentForm, showSegmentList)

import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Select as Select
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Common.StaticVariables
import Common.UIFunctions exposing (selectItems)
import Html exposing (..)
import Html.Attributes exposing (class, for, placeholder)
import Models.BaseModel exposing (..)
import Segment.Model exposing (Msg(..))
import Segment.SegmentRendering exposing (gapVisualizer)
import Set exposing (Set)


segmentForm : Model -> Bool -> Html Segment.Model.Msg
segmentForm model editableSegmentId =
    div []
        [ h1 [] [ text "Editing Segment" ]
        , Form.form [ class "container" ]
            [ Form.label [ for "segmentId" ] [ text "Segment ID" ]
            , segmentIdSelection model
            , sourceIdSelection model
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
        , gapVisualizer model
        ]


showSegmentList : List Segment -> Html Segment.Model.Msg
showSegmentList segs =
    div []
        (Grid.row []
            [ Grid.col [] [ text "Segment" ], Grid.col [] [ text "Start" ], Grid.col [] [ text "Duration" ] ]
            :: (List.sortBy .start segs |> List.map showSingleSegment)
        )


showSingleSegment : Segment -> Html Segment.Model.Msg
showSingleSegment segment =
    Grid.row []
        [ Grid.col [] [ Button.button [ Button.secondary, Button.small, Button.onClick (EditSegment segment.id) ] [ text segment.id ] ]
        , Grid.col [] [ text <| String.fromInt segment.start ]
        , Grid.col [] [ text <| String.fromInt segment.duration ]
        ]


segmentIdSelection : Model -> Html Segment.Model.Msg
segmentIdSelection model =
    if Common.StaticVariables.isKomposition model.kompost then
        Select.select [ Select.id "segmentId", Select.onChange SetSegmentId ]
            (selectItems model.segment.id
                (case Set.toList model.subSegmentList of
                    [] ->
                        [ "Fetch Sources if Segment list is unpopulated" ]

                    subSegmentList ->
                        subSegmentList
                )
            )

    else
        Input.text [ Input.small, Input.value model.segment.id, Input.onInput SetSegmentId, Input.attrs [ placeholder "Id" ] ]


sourceIdSelection : Model -> Html Segment.Model.Msg
sourceIdSelection model =
    Select.select [ Select.id "sourceId", Select.onChange SetSourceId ]
        --setSourceId
        (selectItems model.segment.sourceId (sourceList model))


sourceList model =
    List.map (\segment -> segment.id) model.kompost.sources



--{ model | subSegmentList = Set.fromList segmentNames } ! []
