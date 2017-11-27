module Segment.SegmentRendering exposing (calculateSegmentGaps, gapVisualizer)

import Models.BaseModel exposing (Model, Segment, SegmentGap)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)
import Html.Attributes exposing (style)
import Html exposing (Html, div, text, p)


calculateSegmentGaps : List Segment -> List SegmentGap
calculateSegmentGaps segmentlist =
    case segmentlist of
        head :: tail ->
            quarnUnknown head tail

        alone ->
            let
                _ =
                    Debug.log "alone is " alone
            in
                [ SegmentGap "Alone" 5 -5 ]


quarnUnknown : Segment -> List Segment -> List SegmentGap
quarnUnknown head tail =
    case tail of
        second :: rest ->
            (quarnTwo head second) :: (quarnUnknown second rest)

        [] ->
            []


quarnTwo : Segment -> Segment -> SegmentGap
quarnTwo first second =
    let
        width =
            second.start - first.end
    in
        SegmentGap (toString first.id ++ " " ++ toString second.id) first.end (abs width)


gapVisualizer : Model -> Html msg
gapVisualizer model =
    let
        width =
            case model.kompost.beatpattern of
                Just bpm ->
                    toString ( bpm.toBeat + bpm.toBeat)

                _ ->
                    "800"
    in
        svg [ viewBox "0 0 100 200", Svg.Attributes.width (width ++ "px") ]
            ((drawSegmentGaps model) ++ (drawSegmentGapsText model))


drawSegmentGaps : Model -> List (Svg msg)
drawSegmentGaps model =
    List.map (\gap -> drawRect gap.id gap.start gap.width) (calculateSegmentGaps model.kompost.segments)


drawSegmentGapsText : Model -> List (Svg msg)
drawSegmentGapsText model =
    List.map (\gap -> drawLegendText gap.id 0 gap.start) (calculateSegmentGaps model.kompost.segments)


drawRect : String -> Int -> Int -> Svg msg
drawRect text startInt widthInt =
    let
        color =
            if widthInt > 0 then
                "#023963"
            else if widthInt < 0 then
                "#0B79CE"
            else
                "#AAAAAA"

        start =
            toString startInt

        widthZ =
            toString (abs widthInt)
    in
        rect [ x "10", y start, width "10", height widthZ, fill color ] []


drawLegendText : String -> Int -> Int -> Svg msg
drawLegendText text positionX positionY =
    Svg.text_
        [ pointerEvents "none" -- prevents typing cursor (and mousedown-capture, though this is behind all other objects so that doesn't matter)
        , x (toString positionX)
        , y (toString positionY)
        , fontSize "4"
        , Html.Attributes.style
            [ ( "-webkit-user-select", "none" ) ]
        ]
        [ Svg.tspan [ x "20", dy "1.2em" ] [ Svg.text text ] ]



--https://github.com/oresmus/elm-examples/blob/master/svg-drag-1/svg-drag-1.elm
