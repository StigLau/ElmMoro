module Models.SegmentUI exposing (asStartIn, asIdIn, asCurrentSegmentIn, asEndIn, containsSegment, addSegmentToModel, segmentForm)

import Html exposing (..)
import Html.Attributes exposing (class, href, src, style, type_, placeholder)
import Html.Events exposing (onInput, onClick)
import MsgModel exposing (Config, Msg(..), Model)
import Models.KompostModels exposing (Komposition, Segment)
import RemoteData exposing (succeed)


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

segmentForm : MsgModel.Config msg -> Html Msg
segmentForm model =
    Html.form []
        [ h1 [] [ text "Segment editor" ]
        , input
            [ type_ "text"
            , placeholder "Segment Id"
            , onInput SetSegmentId
            , Html.Attributes.value model.segment.id
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
