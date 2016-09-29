module Controller exposing (..)

import Messages exposing (..)
import Model exposing (..)
import String


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetSegmentName name -> { model | name  = name  }
        SetSegmentStart start -> { model | start = start }
        SetSegmentEnd end -> { model | end = end }

        Create -> model

        Save ->
            if (String.isEmpty model.name) then
                model
            else
                save model



save : Model -> Model
save model =
      case not(validateSegmentFields model)
      && isValidNr model.start
      && isValidNr model.end
      && (validNr model.end) > (validNr model.start)
      of
        True -> add model
        False -> model
{--    case model.start of
        Just internalId ->
            edit model internalId

        Nothing ->
--}




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



validateSegmentFields: Model -> Bool
validateSegmentFields model = (String.isEmpty model.name)


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



