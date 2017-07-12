module Models.DvlSpecificsModel exposing (Msg(..), update, extractFromOutmessage)

import Navigation.AppRouting exposing (Page)
import Models.BaseModel exposing (Model, OutMsg(OutNavigateTo), Komposition, Mediafile)
import Navigation.AppRouting exposing (navigateTo, Page(MediaFileUI, Kompost))

type Msg
    = SetKompositionName String
    | SetFileName String
    | SetBpm String
    | SetChecksum String
    | InternalNavigateTo Page
    | EditMediaFile String
    | SaveMediaFile


extractFromOutmessage: Maybe OutMsg -> Maybe Page
extractFromOutmessage childMsg =
    case childMsg of
        Just (OutNavigateTo page) -> Just page
        _ -> Nothing


update : Msg -> Model -> ( Model, Cmd Msg, Maybe OutMsg )
update msg model =
    case msg of
        SetBpm bpm ->
            let
                kompost = model.kompost
                nuBpm = Result.withDefault 0 (String.toFloat bpm)
            in ({ model | kompost = {kompost | bpm = nuBpm}}, Cmd.none, Nothing)

        SetKompositionName name ->
            let kompost = model.kompost
            in ({model | kompost = {kompost | name = name }}, Cmd.none, Nothing)

        SetFileName fileName ->
            let
                mediaFile = model.editingMediaFile
            in ({model | editingMediaFile = { mediaFile | fileName = fileName }}, Cmd.none, Nothing)

        SetChecksum checksum ->
            let
                mediaFile = model.editingMediaFile
            in ({ model | editingMediaFile = {mediaFile | checksum = checksum }} , Cmd.none, Nothing)

        InternalNavigateTo page ->
            let _ = Debug.log "Navigating to" page
                _ = Debug.log "BPM is" model.kompost.bpm
            in (model, Cmd.none, Just (OutNavigateTo Navigation.AppRouting.Kompost))

        EditMediaFile id ->
            let
                mediaFile = case (containsMediaFile id model.kompost) of
                    [ mediaFile ] -> Debug.log "We found preexisting media file" mediaFile
                    _ -> Debug.log "Reusing Editing Media File" model.editingMediaFile
            in
                ({ model | editingMediaFile = mediaFile}, Cmd.none,  Just (OutNavigateTo MediaFileUI))

        SaveMediaFile  ->
            case (containsMediaFile model.editingMediaFile.fileName model.kompost) of
                [] ->
                    Debug.log "Adding MediaFile []: " (performMediaFileOnModel model.editingMediaFile addMediaFileToKomposition model, Cmd.none, Just (OutNavigateTo Kompost))

                [ x ] ->
                    let
                        deleted = performMediaFileOnModel model.editingMediaFile deleteMediaFileFromKomposition model
                        addedTo = performMediaFileOnModel model.editingMediaFile addMediaFileToKomposition deleted
                    in
                        Debug.log "Updating mediaFile [x]: "  (addedTo, Cmd.none, Just (OutNavigateTo Kompost))

                head :: tail ->
                    Debug.log "Seggie heads tails: " (model, Cmd.none, Just (OutNavigateTo Kompost))

containsMediaFile : String -> Komposition -> List Mediafile
containsMediaFile id komposition =
    List.filter (\mediaFile -> mediaFile.fileName == id) komposition.sources

performMediaFileOnModel mf function model  =
    { model | kompost = (function mf model.kompost) }

addMediaFileToKomposition : Mediafile -> Komposition -> Komposition
addMediaFileToKomposition mediaFile komposition =
    { komposition | sources = [mediaFile] ++ komposition.sources }


deleteMediaFileFromKomposition : Mediafile -> Komposition -> Komposition
deleteMediaFileFromKomposition mediaFile komposition =
    { komposition | sources = List.filter (\n -> n.fileName /= mediaFile.fileName) komposition.sources }
