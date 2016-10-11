module Controller exposing (..)

import Messages exposing (..)
import Model exposing (Model, Config, Mediafile, Segment)
import String
import Debug
import Http
import JsonDecoding exposing (decodeJson, JsonKomposition)
import Task


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

        DeleteSegment segment ->
              deleteSegment model segment

        FetchSuccess response ->
                      response.komposition

        FetchFail _ -> model
        FetchKomposition -> model

--                    ( (toString error), Cmd.none )

--        FetchKomposition ->
--                    ( "fetching reference ...", randomJoke )




save : Model -> Model
save model =
      case (isInputfieldsValid model, (isEditingExistingSegment model))
      of
        (True, False) -> add model
        (True, True)  -> updateChanges model
        _ -> model


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


validateSegmentFields: Model -> Bool
validateSegmentFields model = (String.isEmpty model.name)


isEditingExistingSegment: Model-> Bool
isEditingExistingSegment model =
  List.length( List.filter (\s -> s.id == model.name) model.segments ) == 1


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


deleteSegment : Model -> Segment -> Model
deleteSegment model segment =
    let
        updatedSegments =
          List.filter (\s -> s.id /= segment.id) model.segments
    in
        { model | segments = updatedSegments }


randomJoke : Cmd Msg
randomJoke =
    let
        url = "https://raw.githubusercontent.com/StigLau/ElmMoro/master/kompostedit/test/resources/example.json"
        task =
            -- Http.getString url
            Http.get decodeJson url

        cmd =
            Task.perform FetchFail FetchSuccess task
    in
        cmd