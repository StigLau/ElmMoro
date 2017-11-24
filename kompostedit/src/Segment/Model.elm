module Segment.Model exposing (..)

import Models.BaseModel exposing (Model, Komposition, Segment)
import Navigation.AppRouting as AppRouting exposing (navigateTo, Page(KompostUI, ListingsUI, SegmentUI))


type Msg
    = SetSegmentId String
    | SetSourceId String
    | SetSegmentStart String
    | SetSegmentEnd String
    | SetSegmentDuration String
    | EditSegment String
    | UpdateSegment
    | DeleteSegment


type OutMsg
    = OutNavigateTo Page


update : Msg -> Model -> ( Model, List (Cmd Msg), Maybe OutMsg )
update msg model =
    case msg of
        SetSegmentId id ->
            let
                newModel =
                    id
                        |> asIdIn model.segment
                        |> asCurrentSegmentIn model
            in
                ( newModel, [ Cmd.none ], Nothing )

        SetSourceId id ->
            let
                newModel =
                    id
                        |> asSourceIdIn model.segment
                        |> asCurrentSegmentIn model
            in
                ( newModel, [ Cmd.none ], Nothing )

        SetSegmentStart start ->
            let
                newModel =
                    start
                        |> asStartIn model.segment
                        |> asCurrentSegmentIn model
            in
                ( newModel, [ Cmd.none ], Nothing )

        SetSegmentEnd end ->
            let
                newModel =
                    end
                        |> asEndIn model.segment
                        |> asCurrentSegmentIn model
            in
                ( newModel, [ Cmd.none ], Nothing )

        SetSegmentDuration value ->
            let
                newModel =
                    value
                        |> asDurationIn model.segment
                        |> asCurrentSegmentIn model
            in
                ( newModel, [ Cmd.none ], Nothing )

        EditSegment id ->
            let
                segment =
                    case (containsSegment id model.kompost) of
                        [ segment ] ->
                            segment

                        _ ->
                            model.segment
            in
                ( { model | segment = segment, editableSegment = False }, [], Just (OutNavigateTo SegmentUI) )

        UpdateSegment ->
            case (containsSegment model.segment.id model.kompost) of
                [] ->
                    Debug.log "Adding segment []: " ( performSegmentOnModel model.segment addSegmentToKomposition model, [], Just (OutNavigateTo KompostUI) )

                [ x ] ->
                    let
                        deleted =
                            performSegmentOnModel model.segment deleteSegmentFromKomposition model

                        addedTo =
                            performSegmentOnModel model.segment addSegmentToKomposition deleted
                    in
                        Debug.log "Updating segment [x]: " ( addedTo, [], Just (OutNavigateTo KompostUI) )

                head :: tail ->
                    Debug.log "Seggie heads tails: " ( model, [], Just (OutNavigateTo KompostUI) )

        DeleteSegment ->
            Debug.log "Deleting segment: " ( performSegmentOnModel model.segment deleteSegmentFromKomposition model, [], Just (OutNavigateTo KompostUI) )


extractFromOutmessage : Maybe OutMsg -> Maybe Page
extractFromOutmessage childMsg =
    case childMsg of
        Just (OutNavigateTo page) ->
            Just page

        _ ->
            Nothing


asStartIn =
    flip setStart


asEndIn =
    flip setEnd


asDurationIn =
    flip setDuration


asIdIn =
    flip setId


asSourceIdIn =
    flip setSourceId


setStart newStart segment =
    { segment | start = Result.withDefault 0 (String.toInt newStart) }


setEnd newEnd segment =
    let
        end =
            Result.withDefault 0 (String.toInt newEnd)
    in
        { segment | end = end, duration = end - segment.start }


setDuration duration segment =
    let
        dur =
            Result.withDefault 0 (String.toInt duration)
    in
        { segment | duration = dur, end = segment.start + dur }


setId newId segment =
    { segment | id = newId }


setSourceId newSourceId segment =
    { segment | sourceId = newSourceId }


setCurrentSegment : Segment -> Model -> Model
setCurrentSegment newSegment model =
    { model | segment = newSegment }


asCurrentSegmentIn : Model -> Segment -> Model
asCurrentSegmentIn =
    flip setCurrentSegment


containsSegment : String -> Komposition -> List Segment
containsSegment id komposition =
    List.filter (\seg -> seg.id == id) komposition.segments


performSegmentOnModel segment function model =
    { model | kompost = (function segment model.kompost) }


addSegmentToKomposition : Segment -> Komposition -> Komposition
addSegmentToKomposition segment komposition =
    { komposition | segments = segment :: komposition.segments }


deleteSegmentFromKomposition : Segment -> Komposition -> Komposition
deleteSegmentFromKomposition segment komposition =
    { komposition | segments = List.filter (\n -> n.id /= segment.id) komposition.segments }
