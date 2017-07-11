module Models.DvlSpecificsModel exposing (Msg(..), update, extractFromOutmessage)

import Navigation.AppRouting exposing (Page)
import Models.BaseModel exposing (Model, OutMsg(OutNavigateTo), Komposition, Mediafile)
import Navigation.AppRouting exposing (navigateTo, Page(MediaFileUI, Segment))

type Msg
    = SetKompositionName String
    | SetFileName String
    | SetBpm String
    | SetChecksum String
    | InternalNavigateTo Page
    | EditMediaFile String


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
                mediaFile = model.kompost.mediaFile
            in ((updateMediaFile { mediaFile | fileName = fileName } model), Cmd.none, Nothing)

        SetChecksum checksum ->
            let
                mediaFile = model.kompost.mediaFile
            in ((updateMediaFile { mediaFile | checksum = checksum } model), Cmd.none, Nothing)

        InternalNavigateTo page ->
            let _ = Debug.log "Navigating to" page
                _ = Debug.log "BPM is" model.kompost.bpm
            in (model, Cmd.none, Just (OutNavigateTo Navigation.AppRouting.Kompost))

        EditMediaFile id ->
            let
                mediaFile = case (containsMediaFile id model.kompost) of
                    [ mediaFile ] -> mediaFile
                    _ -> model.editingMediaFile
            in
                ({ model | editingMediaFile = mediaFile}, Cmd.none,  Just (OutNavigateTo MediaFileUI))


updateMediaFile mediaFile model =
    let
        kompost = model.kompost
    in { model | kompost = {kompost | mediaFile = mediaFile}}

containsMediaFile : String -> Komposition -> List Mediafile
containsMediaFile id komposition =
    List.filter (\mediaFile -> mediaFile.fileName == id) komposition.sources