module Models.SegmentUI exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href, src, style, type_, placeholder)
import Html.Events exposing (onInput, onClick)
import MsgModel exposing (Segment, Config, Msg(..), Model)


--asStartIn : Segment -> String -> Segment
asStartIn = flip setStart
asEndIn = flip setEnd
asNameIn = flip setName

--setStart : String -> Segment -> Segment
setStart newStart segment = { segment | start = ( validNr newStart ) }
setEnd newEnd segment = { segment | end = ( validNr newEnd ) }
setName newName segment = { segment | name = newName }

setCurrentSegment : Segment -> Model -> Model
setCurrentSegment newSegment model = { model | segment = newSegment }

asCurrentSegmentIn : Model -> Segment -> Model
asCurrentSegmentIn = flip setCurrentSegment

validNr : String -> Int
validNr value =
  case String.toInt value of
    Ok int ->
      int
    Err _ ->
      -1

segmentForm : MsgModel.Config msg -> Html Msg
segmentForm model =
    Html.form []
        [ h1 [] [ text "Segment editor" ]
        , input
            [ type_ "text"
            , placeholder "Segment Name"
            , onInput SetSegmentName
            , Html.Attributes.value model.segment.name
            ]
            []
        , input
            [ type_ "text"
            , placeholder "Start"
            , onInput SetSegmentStart
            , Html.Attributes.value (toString model.segment.start)
            ]
            []
        , input
            [ type_ "number"
            , placeholder "End"
            , onInput SetSegmentEnd
            , Html.Attributes.value (toString model.segment.end)
            ]
            []
        , button [ type_ "button", onClick UpdateSegment ] [ text "UpdateSegment" ]
        ]
