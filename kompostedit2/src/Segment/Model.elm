module Segment.Model exposing (..)

import Models.BaseModel exposing (Model, Komposition, Segment)
import Navigation.AppRouting as AppRouting exposing (navigateTo, Page(Kompost, Listings))


type Msg
    = SetSegmentId String
    | SetSegmentStart String
    | SetSegmentEnd String
    | EditSegment String
    | UpdateSegment
    | DeleteSegment
    | InternalNavigateTo Page


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
                (newModel, [Cmd.none], Nothing)

        SetSegmentStart start ->
            let
                newModel =
                    start
                        |> asStartIn model.segment
                        |> asCurrentSegmentIn model
            in
                (newModel, [Cmd.none], Nothing)

        SetSegmentEnd end ->
            let
                newModel =
                    end
                        |> asEndIn model.segment
                        |> asCurrentSegmentIn model
            in
                (newModel, [Cmd.none], Nothing)

        EditSegment id ->
            let
                segment = case (containsSegment id model.kompost) of
                    [ segment ] -> segment
                    _ -> model.segment
            in
                ({ model | segment = segment, editableSegment=False }, [ ], Just (OutNavigateTo AppRouting.Segment) )

        UpdateSegment ->
            case (containsSegment model.segment.id model.kompost) of
                [] ->
                    Debug.log "Adding segment []: " (performSegmentOnModel model.segment addSegmentToKomposition model, [ ], Just (OutNavigateTo AppRouting.Kompost))

                [ x ] ->
                    let
                        deleted = performSegmentOnModel model.segment deleteSegmentFromKomposition model
                        addedTo = performSegmentOnModel model.segment addSegmentToKomposition deleted
                    in
                        Debug.log "Updating segment [x]: "  (addedTo, [ ], Just (OutNavigateTo AppRouting.Kompost))

                head :: tail ->
                    Debug.log "Seggie heads tails: " (model, [ ], Just (OutNavigateTo AppRouting.Kompost))

        DeleteSegment ->
            Debug.log "Deleting segment: " (performSegmentOnModel model.segment deleteSegmentFromKomposition model, [ ], Just (OutNavigateTo AppRouting.Kompost))

        InternalNavigateTo page ->
            let _ = Debug.log "Navigating to" page
                _ = Debug.log "BPM is" model.kompost.bpm
            in (model, [Cmd.none], Just (OutNavigateTo Kompost))


extractFromOutmessage: Maybe OutMsg -> Maybe Page
extractFromOutmessage childMsg =
    case childMsg of
            Just (OutNavigateTo page) -> Just page
            _ -> Nothing



asStartIn =
    flip setStart


asEndIn =
    flip setEnd


asIdIn =
    flip setId



--setStart : String -> Segment -> Segment


setStart newStart segment =
    { segment | start = (validNr newStart) }


setEnd newEnd segment =
    { segment | end = (validNr newEnd) }


setId newId segment =
    { segment | id = newId }


setCurrentSegment : Segment -> Model -> Model
setCurrentSegment newSegment model =
    { model | segment = newSegment }


asCurrentSegmentIn : Model -> Segment -> Model
asCurrentSegmentIn =
    flip setCurrentSegment


containsSegment : String -> Komposition -> List Segment
containsSegment id komposition =
    List.filter (\seg -> seg.id == id) komposition.segments


performSegmentOnModel segment function model  =
    { model | kompost = (function segment model.kompost) }

addSegmentToKomposition : Segment -> Komposition -> Komposition
addSegmentToKomposition segment komposition =
    { komposition | segments = (Segment segment.id segment.start segment.end) :: komposition.segments }


deleteSegmentFromKomposition : Segment -> Komposition -> Komposition
deleteSegmentFromKomposition segment komposition =
    { komposition | segments = List.filter (\n -> n.id /= segment.id) komposition.segments }


validNr : String -> Int
validNr value = Result.withDefault 0 (String.toInt value)
