module Models.Functions exposing (..)

import Models.KompostModels exposing (Model, Segment)
import String

add : Model -> Model
add model =
    let
        segment =
            Segment model.name model.start model.end

        newSegments =
            segment :: model.segments
    in
        { model
            | segments = newSegments
            , name = ""
            , start = 0
            , end = 0
        }

updateChanges : Model -> Model
updateChanges model =
    let
        newSegments =
            List.map
                (\segment ->
                    if segment.id == model.name then
                        { segment | start = model.start, end = model.end }
                    else
                        segment
                )
                model.segments
    in
        { model
            | segments = newSegments
            , name = ""
            , start = 0
            , end = 0
        }


isInputfieldsValid: Model -> Bool
isInputfieldsValid model =
  not(validateSegmentFields model)
        && model.end > model.start

validNr : String -> Int
validNr value =
  case String.toInt value of
    Ok int ->
      int
    Err _ ->
      -1

validateSegmentFields: Model -> Bool
validateSegmentFields model = (String.isEmpty model.name)


isEditingExistingSegment: Model-> Bool
isEditingExistingSegment model =
  List.length( List.filter (\s -> s.id == model.name) model.segments ) == 1
