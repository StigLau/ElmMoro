module Segment.Model exposing (addSegmentToKomposition, asCurrentSegmentIn, asIdIn, asSourceIdIn, containsSegment, deleteSegmentFromKomposition, performSegmentOnModel, setCurrentSegment, setDuration, setEnd, setId, setSourceId, setStart, update)

import Models.BaseModel exposing (Komposition, Model, OutMsg(..), Segment)
import Models.KompostApi exposing (fetchSource)
import Models.Msg
import Navigation.Page as Page exposing (Page)
import Segment.Msg exposing (..)

update : Msg -> Model -> ( Model, Cmd Models.Msg.Msg, Maybe OutMsg )
update msg model =
    case msg of
        SetSegmentId id ->
            let
                newModel =
                    id
                        |> asIdIn model.segment
                        |> asCurrentSegmentIn model
            in
            ( newModel, Cmd.none, Nothing )

        SetSourceId id ->
            let
                newModel =
                    id
                        |> asSourceIdIn model.segment
                        |> asCurrentSegmentIn model
            in
            ( newModel, Cmd.none, Just (FetchSourceListMsg id) )

        SetSegmentStart start ->
            ( { model | segment = setStart start model.segment }, Cmd.none, Nothing )

        SetSegmentEnd end ->
            ( { model | segment = setEnd end model.segment }, Cmd.none, Nothing )

        SetSegmentDuration duration ->
            ( { model | segment = setDuration duration model.segment }, Cmd.none, Nothing )

        EditSegment id ->
            let
                segment =
                    case containsSegment id model.kompost of
                        [ theSegment ] ->
                            theSegment

                        _ ->
                            model.segment
            in
            ( { model | segment = segment, editableSegment = False }, Cmd.none, Just (OutNavigateTo Page.SegmentUI) )

        UpdateSegment ->
            case containsSegment model.segment.id model.kompost of
                [] ->
                    let _ = Debug.log "Adding segment []: "
                    in ( performSegmentOnModel model.segment addSegmentToKomposition model, Cmd.none, Just (OutNavigateTo Page.KompostUI) )

                [ _ ] ->
                    let
                        deleted =
                            performSegmentOnModel model.segment deleteSegmentFromKomposition model

                        addedTo =
                            performSegmentOnModel model.segment addSegmentToKomposition deleted
                    in
                    Debug.log "Updating segment [x]: " ( addedTo, Cmd.none, Just (OutNavigateTo Page.KompostUI) )

                head :: tail ->
                    Debug.log "Seggie heads tails: " ( model, Cmd.none, Just (OutNavigateTo Page.KompostUI) )

        DeleteSegment ->
            Debug.log "Deleting segment: " ( performSegmentOnModel model.segment deleteSegmentFromKomposition model, Cmd.none, Just (OutNavigateTo Page.KompostUI) )

        FetchAndLoadMediaFile id ->
            ( model, fetchSource id model.apiToken, Nothing )

        SegmentSearchVisible isVisible ->
            ({model | checkboxVisible = isVisible }, Cmd.none, Nothing)

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
