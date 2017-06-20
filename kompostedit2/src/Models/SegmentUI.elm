module Models.SegmentUI exposing (asStartIn, asIdIn, asCurrentSegmentIn, asEndIn, containsSegment, addSegmentToModel, segmentForm, showSegmentList)

import Html exposing (..)
import Html.Attributes exposing (class, href, src, style, type_, placeholder)
import Html.Events exposing (onInput, onClick)
import MsgModel exposing (Config, Msg(..), Model)
import Models.KompostModels exposing (Komposition, Segment)
import RemoteData exposing (succeed)
import Bootstrap.Grid.Col as Col
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Button as Button
import Bootstrap.Grid as Grid


--asStartIn : Segment -> String -> Segment
asStartIn = flip setStart
asEndIn = flip setEnd
asIdIn = flip setId

--setStart : String -> Segment -> Segment
setStart newStart segment = { segment | start = ( validNr newStart ) }
setEnd newEnd segment = { segment | end = ( validNr newEnd ) }
setId newId segment = { segment | id = newId }

setCurrentSegment : Segment -> Model -> Model
setCurrentSegment newSegment model = { model | segment = newSegment }

asCurrentSegmentIn : Model -> Segment -> Model
asCurrentSegmentIn = flip setCurrentSegment

containsSegment: String ->  RemoteData.WebData Komposition -> List Models.KompostModels.Segment
containsSegment id webKomposition =
    case RemoteData.toMaybe webKomposition of
        Just komposition ->  List.filter  (\ seg -> seg.id == id ) komposition.segments
        _ -> []

addSegmentToModel: Segment -> Model -> Model
addSegmentToModel segment model =
    case RemoteData.toMaybe model.kompost of
        Just komp -> { model | kompost = succeed (addSegmentToKomposition segment komp) }
        _ -> model

addSegmentToKomposition: Segment -> Komposition ->  Komposition
addSegmentToKomposition segment komposition =
        {komposition | segments = (Segment segment.id segment.start segment.end) :: komposition.segments}


validNr : String -> Int
validNr value =
  case String.toInt value of
    Ok int ->
      int
    Err _ ->
      -1

segmentForm : Config msg -> Html Msg
segmentForm config =
    div []
    [ h1 [] [ text "Editing Segment" ]
    , Form.form [ class "container" ]
        [ Form.row [ Form.rowSuccess ]
            [ Form.colLabel [ Col.xs4 ] [ text "Segment ID:" ]
            , Form.col [ Col.xs8 ]
                [ Input.text
                    [ Input.id "segmentId", Input.defaultValue config.segment.id, Input.success, Input.onInput SetSegmentId ]
                ]
            ]
        , Form.row []
            [ Form.colLabelSm [ Col.xs4 ] [ text "Start and end" ]
            , Form.col [ Col.xs4 ]
                [ Input.number [ Input.small, Input.defaultValue (toString config.segment.start), Input.onInput SetSegmentStart, Input.attrs [ placeholder "Start" ]]
                ]
            , Form.col [ Col.xs4 ]
                [ Input.number [ Input.small, Input.defaultValue (toString config.segment.end), Input.onInput SetSegmentEnd, Input.attrs [ placeholder "End" ] ]
                ]
            ]
        , Form.row [ Form.rowWarning ]
            [ Form.colLabel [ Col.xs4 ] [  ]
            , Form.col []
                    [ Button.button
                      [ Button.success, Button.small, Button.onClick UpdateSegment]
                      [ text "Store" ]
                    ]
                ]
            ]
        ]

showSegmentList : List Segment -> Html msg
showSegmentList segs =
  div [] (segs |> List.map showSingleSegment)


showSingleSegment: Segment -> Html msg
showSingleSegment segment =
    Grid.row []
        [ Grid.col [] [ text segment.id]
        , Grid.col [] [ text <| toString segment.start ]
        , Grid.col [] [ text <| toString segment.end ]
        ]