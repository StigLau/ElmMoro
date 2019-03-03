module Segment.Model exposing (OutMsg(..), addSegmentToKomposition, asCurrentSegmentIn, asDurationIn, asEndIn, asIdIn, asSourceIdIn, asStartIn, containsSegment, deleteSegmentFromKomposition, extractFromOutmessage, performSegmentOnModel, setCurrentSegment, setDuration, setEnd, setId, setSourceId, setStart, update)

import Models.BaseModel exposing (Komposition, Model, Segment)
import Navigation.Page as Page exposing (Page)
import Segment.Msg exposing (..)


type OutMsg
    = OutNavigateTo Page

update : Msg -> Model -> ( Model, Maybe OutMsg )
update msg model =
    case msg of
        SetSegmentId id ->
            let
                newModel =
                    id
                        |> asIdIn model.segment
                        |> asCurrentSegmentIn model
            in
            ( newModel, Nothing )

        SetSourceId id ->
            let
                newModel =
                    id
                        |> asSourceIdIn model.segment
                        |> asCurrentSegmentIn model
            in
            ( newModel, Nothing )

        SetSegmentStart start ->
            let --TODO FIX ME
                theStart = Maybe.withDefault 0 (String.toInt start)
--                theSegment = (asStartIn theStart model.segment)
                theSegment = model.segment
                newModel = asCurrentSegmentIn model theSegment
--                        |> asStartIn model.segment
--                        |> asCurrentSegmentIn model
            in
            ( newModel, Nothing )

        SetSegmentEnd end ->
            let
                newModel = --TODO Fix me
                    asCurrentSegmentIn model model.segment
--                    end
--                        |> asEndIn model.segment
--                        |> asCurrentSegmentIn model
            in
            ( newModel, Nothing )

        SetSegmentDuration value ->
            let --TODO Fix me
                newModel = asCurrentSegmentIn model model.segment
--                        |> asDurationIn model.segment
--                        |> asCurrentSegmentIn model
            in
            ( newModel, Nothing )

        EditSegment id ->
            let
                segment =
                    case containsSegment id model.kompost of
                        [ theSegment ] ->
                            theSegment

                        _ ->
                            model.segment
            in
            ( { model | segment = segment, editableSegment = False }, Just (OutNavigateTo Page.SegmentUI) )

        UpdateSegment ->
            case containsSegment model.segment.id model.kompost of
                [] ->
                    Debug.log "Adding segment []: " ( performSegmentOnModel model.segment addSegmentToKomposition model, Just (OutNavigateTo Page.KompostUI) )

                [ x ] ->
                    let
                        deleted =
                            performSegmentOnModel model.segment deleteSegmentFromKomposition model

                        addedTo =
                            performSegmentOnModel model.segment addSegmentToKomposition deleted
                    in
                    Debug.log "Updating segment [x]: " ( addedTo, Just (OutNavigateTo Page.KompostUI) )

                head :: tail ->
                    Debug.log "Seggie heads tails: " ( model, Just (OutNavigateTo Page.KompostUI) )

        DeleteSegment ->
            Debug.log "Deleting segment: " ( performSegmentOnModel model.segment deleteSegmentFromKomposition model, Just (OutNavigateTo Page.KompostUI) )


extractFromOutmessage : Maybe OutMsg -> Maybe Page
extractFromOutmessage childMsg =
    case childMsg of
        Just (OutNavigateTo page) ->
            Just page

        _ ->
            Nothing


asStartIn =
    \b a -> setStart a b


asEndIn =
    \b a -> setEnd a b


asDurationIn =
    \b a -> setDuration a b


asIdIn =
    \b a -> setId a b


asSourceIdIn =
    \b a -> setSourceId a b


setStart newStart segment =
    { segment | start = Result.withDefault 0 newStart}


setEnd newEnd segment =
    let
        end =
            Result.withDefault 0 newEnd
    in
    { segment | end = end, duration = end - segment.start }


setDuration duration segment =
    let
        dur =
            Result.withDefault 0 duration
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
    \b a -> setCurrentSegment a b


containsSegment : String -> Komposition -> List Segment
containsSegment id komposition =
    List.filter (\seg -> seg.id == id) komposition.segments


performSegmentOnModel segment function model =
    { model | kompost = function segment model.kompost }


addSegmentToKomposition : Segment -> Komposition -> Komposition
addSegmentToKomposition segment komposition =
    { komposition | segments = segment :: komposition.segments }


deleteSegmentFromKomposition : Segment -> Komposition -> Komposition
deleteSegmentFromKomposition segment komposition =
    { komposition | segments = List.filter (\n -> n.id /= segment.id) komposition.segments }
