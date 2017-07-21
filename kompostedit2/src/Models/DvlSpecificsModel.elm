module Models.DvlSpecificsModel exposing (update, extractFromOutmessage)

import Navigation.AppRouting exposing (Page)
import Models.BaseModel exposing (Model, OutMsg(OutNavigateTo), Komposition, Mediafile)
import Navigation.AppRouting exposing (navigateTo, Page(MediaFileUI, KompostUI))
import Models.KompostApi exposing (getDvlSegmentList)
import DvlSpecifics.Msg exposing (Msg(..))
import Models.Msg exposing (Msg)


extractFromOutmessage: Maybe OutMsg -> Maybe Page
extractFromOutmessage childMsg =
    case childMsg of
        Just (OutNavigateTo page) -> Just page
        _ -> Nothing


update : DvlSpecifics.Msg.Msg -> Model -> ( Model, Cmd Models.Msg.Msg, Maybe OutMsg )
update msg model =
    case msg of
        SetKompositionName name ->
            let kompost = model.kompost
            in ({model | kompost = {kompost | name = name }}, Cmd.none, Nothing)

        SetId id ->
            let
                mediaFile = model.editingMediaFile
            in ({model | editingMediaFile = { mediaFile | id = id }}, Cmd.none, Nothing)

        SetURL url ->
            let
                mediaFile = model.editingMediaFile
            in ({model | editingMediaFile = { mediaFile | url = url }}, Cmd.none, Nothing)

        SetDvlType dvlType ->
            let
                kompost = model.kompost
            in ({ model | kompost = {kompost | dvlType = dvlType}}, Cmd.none, Nothing)

        SetBpm bpm ->
            let
                kompost = model.kompost
                nuBpm = Result.withDefault 0 (String.toFloat bpm)
            in ({ model | kompost = {kompost | bpm = nuBpm}}, Cmd.none, Nothing)

        SetChecksum checksum ->
            let
                mediaFile = model.editingMediaFile
            in ({ model | editingMediaFile = {mediaFile | checksum = checksum }} , Cmd.none, Nothing)

        SetOffset value ->
            let
                mediaFile = model.editingMediaFile
            in ({ model | editingMediaFile = {mediaFile | startingOffset = Result.withDefault 0 (String.toFloat value) }} , Cmd.none, Nothing)

        InternalNavigateTo page ->
            let _ = Debug.log "Navigating to" page
                _ = Debug.log "BPM is" model.kompost.bpm
            in (model, Cmd.none, Just (OutNavigateTo Navigation.AppRouting.KompostUI))

        EditMediaFile id ->
            let
                mediaFile = case (containsMediaFile id model.kompost) of
                    [ mediaFile ] -> Debug.log "We found preexisting media file" mediaFile
                    _ -> Debug.log "Reusing Editing Media File" model.editingMediaFile
            in
                ({ model | editingMediaFile = mediaFile}, Cmd.none,  Just (OutNavigateTo MediaFileUI))

        FetchAndLoadMediaFile id ->
            let
                mediaFile = case (containsMediaFile id model.kompost) of
                    [ mediaFile ] -> Debug.log "We found preexisting media file" mediaFile
                    _ -> Debug.log "Reusing Editing Media File" model.editingMediaFile
            in
                ( model, getDvlSegmentList id, Nothing)

        SaveMediaFile  ->
            case (containsMediaFile model.editingMediaFile.id model.kompost) of
                [] ->
                    Debug.log "Adding MediaFile []: " (performMediaFileOnModel model.editingMediaFile addMediaFileToKomposition model, Cmd.none, Just (OutNavigateTo KompostUI))

                [ x ] ->
                    let
                        deleted = performMediaFileOnModel model.editingMediaFile deleteMediaFileFromKomposition model
                        addedTo = performMediaFileOnModel model.editingMediaFile addMediaFileToKomposition deleted
                    in
                        Debug.log "Updating mediaFile [x]: "  (addedTo, Cmd.none, Just (OutNavigateTo KompostUI))

                head :: tail ->
                    Debug.log "Seggie heads tails: " (model, Cmd.none, Just (OutNavigateTo KompostUI))

        DeleteMediaFile id ->
            let modifiedModel = performMediaFileOnModel model.editingMediaFile deleteMediaFileFromKomposition model
            in (modifiedModel, Cmd.none, Just (OutNavigateTo KompostUI))


containsMediaFile : String -> Komposition -> List Mediafile
containsMediaFile id komposition =
    List.filter (\mediaFile -> mediaFile.id == id) komposition.sources

performMediaFileOnModel mf function model  =
    { model | kompost = (function mf model.kompost) }

addMediaFileToKomposition : Mediafile -> Komposition -> Komposition
addMediaFileToKomposition mediaFile komposition =
    { komposition | sources = [mediaFile] ++ komposition.sources }


deleteMediaFileFromKomposition : Mediafile -> Komposition -> Komposition
deleteMediaFileFromKomposition mediaFile komposition =
    { komposition | sources = List.filter (\n -> n.id /= mediaFile.id) komposition.sources }
