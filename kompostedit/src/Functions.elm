module Functions exposing (..)

import Models.KompostModels exposing (Model, Segment)
import String

add : Model -> Model
add model =
    let
        segment =
            Segment model.name (validNr model.start) (validNr model.end)

        newSegments =
            segment :: model.segments
    in
        { model
            | segments = newSegments
            , name = ""
            , start = ""
            , end = ""
        }

updateChanges : Model -> Model
updateChanges model =
    let
        newSegments =
            List.map
                (\segment ->
                    if segment.id == model.name then
                        { segment | start = (validNr model.start), end = (validNr model.end) }
                    else
                        segment
                )
                model.segments
    in
        { model
            | segments = newSegments
            , name = ""
            , start = ""
            , end = ""
        }


isInputfieldsValid: Model -> Bool
isInputfieldsValid model =
  not(validateSegmentFields model)
      && isValidNr model.start
      && isValidNr model.end
      && (validNr model.end) > (validNr model.start)

isValidNr : String -> Bool
isValidNr value =
  case String.toInt value of
    Ok int ->
      int >= 0
    Err _ ->
      False

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
