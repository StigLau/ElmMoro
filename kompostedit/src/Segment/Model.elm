module Segment.Model exposing (OutMsg(..), addSegmentToKomposition, asCurrentSegmentIn, asIdIn, asSourceIdIn, containsSegment, deleteSegmentFromKomposition, extractFromOutmessage, performSegmentOnModel, setCurrentSegment, setDuration, setEnd, setId, setSourceId, setStart, update)

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
            ( { model | segment = setStart start model.segment }, Nothing )

        SetSegmentEnd end ->
            ( { model | segment = setEnd end model.segment }, Nothing )

        SetSegmentDuration duration ->
            ( { model | segment = setDuration duration model.segment }, Nothing )

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
                    let _ = Debug.log "Adding segment []: "
                    in ( performSegmentOnModel model.segment addSegmentToKomposition model, Just (OutNavigateTo Page.KompostUI) )

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

asIdIn =
    \b a -> setId a b


asSourceIdIn =
    \b a -> setSourceId a b


setStart: String -> Segment -> Segment
setStart newStart segment =
    { segment | start = Maybe.withDefault 0 (String.toInt newStart)}


setEnd: String -> Segment -> Segment
setEnd newEnd segment =
    let
        end = Debug.log "newEnd" (Maybe.withDefault 0 (String.toInt newEnd))
    in { segment | end = end, duration = end - segment.start}

setDuration duration segment =
    let
        dur =
            Debug.log "duration" (Maybe.withDefault 0 (String.toInt duration))
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
