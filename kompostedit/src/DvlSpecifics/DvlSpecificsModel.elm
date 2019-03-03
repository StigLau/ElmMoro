module DvlSpecifics.DvlSpecificsModel exposing (extractFromOutmessage, setSource, update)

import Common.StaticVariables exposing (evaluateMediaType)
import DvlSpecifics.Msg exposing (Msg(..))
import Models.BaseModel exposing (BeatPattern, Komposition, Model, OutMsg(..), Source)
import Models.KompostApi exposing (fetchETagHeader, getDvlSegmentList)
import Models.Msg exposing (Msg)
import Navigation.Page as Page exposing (Page)


extractFromOutmessage : Maybe OutMsg -> Maybe Page
extractFromOutmessage childMsg =
    case childMsg of
        Just (OutNavigateTo page) ->
            Just page

        _ ->
            Nothing


update : DvlSpecifics.Msg.Msg -> Model -> ( Model, Cmd Models.Msg.Msg, Maybe OutMsg )
update msg model =
    case msg of
        SetKompositionName name ->
            let
                kompost =
                    model.kompost
            in
            ( { model | kompost = { kompost | name = name } }, Cmd.none, Nothing )

        SetId id ->
            let
                source =
                    model.editingMediaFile
            in
            ( setSource { source | id = id } model, Cmd.none, Nothing )

        SetURL url ->
            let
                source =
                    model.editingMediaFile
            in
            ( setSource { source | url = url } model, Cmd.none, Nothing )

        SetSnippet isSnippet ->
            let
                source =
                    model.editingMediaFile
            in
            ( setSource { source | isSnippet = isSnippet } model, Cmd.none, Nothing )

        SetDvlType dvlType ->
            let
                kompost =
                    model.kompost
            in
            ( { model | kompost = { kompost | dvlType = dvlType } }, Cmd.none, Nothing )

        SetBpm value ->
            let
                kompost =
                    model.kompost
            in
            ( { model | kompost = { kompost | bpm = standardFloat value } }, Cmd.none, Nothing )

        SetChecksum checksum ->
            let
                source =
                    model.editingMediaFile
            in
            ( setSource { source | checksum = checksum } model, Cmd.none, Nothing )

        SetOffset value ->
            let
                source =
                    model.editingMediaFile
            in
            ( setSource { source | startingOffset = standardFloat value } model, Cmd.none, Nothing )

        SetSourceExtensionType value ->
            let
                source =
                    model.editingMediaFile
            in
            ( setSource { source | extensionType = value, mediaType = evaluateMediaType value } model, Cmd.none, Nothing )

        SetSourceMediaType value ->
            let
                source =
                    model.editingMediaFile
            in
            ( setSource { source | mediaType = value } model, Cmd.none, Nothing )

        --Config
        SetWidth value ->
            let
                config =
                    model.kompost.config
            in
            ( setConfig { config | width = standardInt value } model, Cmd.none, Nothing )

        SetHeight value ->
            let
                config =
                    model.kompost.config
            in
            ( setConfig { config | height = standardInt value } model, Cmd.none, Nothing )

        SetFramerate value ->
            let
                config =
                    model.kompost.config
            in
            ( setConfig { config | framerate = standardInt value } model, Cmd.none, Nothing )

        SetExtensionType value ->
            let
                config =
                    model.kompost.config
            in
            ( setConfig { config | extensionType = value } model, Cmd.none, Nothing )

        -- Beat Pattern
        SetFromBpm value ->
            let
                beatpattern =
                    extractBeatPattern model
            in
            setBeatPattern { beatpattern | fromBeat = standardInt value } model

        SetToBpm value ->
            let
                beatpattern =
                    extractBeatPattern model
            in
            setBeatPattern { beatpattern | toBeat = standardInt value } model

        SetMasterBpm value ->
            let
                beatpattern =
                    extractBeatPattern model
            in
            setBeatPattern { beatpattern | masterBPM = standardFloat value } model

        InternalNavigateTo page ->
            let
                _ =
                    Debug.log "Navigating to" page

                _ =
                    Debug.log "BPM is" model.kompost.bpm
            in
            ( model, Cmd.none, Just (OutNavigateTo Page.KompostUI) )

        EditMediaFile id ->
            let
                theMediaFile =
                    case containsMediaFile id model.kompost of
                        [ mediaFile ] ->
                            Debug.log "We found preexisting media file" mediaFile

                        _ ->
                            Source "" "" 0 "" "" "" False
            in
            ( { model | editingMediaFile = theMediaFile }, Cmd.none, Just (OutNavigateTo Page.MediaFileUI) )

        FetchAndLoadMediaFile id ->
            let
                unusedMediaFile =
                    case containsMediaFile id model.kompost of
                        [ mediaFile ] ->
                            Debug.log "We found preexisting media file" mediaFile

                        _ ->
                            Debug.log "Reusing Editing Media File" model.editingMediaFile
            in
            ( model, getDvlSegmentList id, Nothing )

        SaveSource ->
            case containsMediaFile model.editingMediaFile.id model.kompost of
                [] ->
                    Debug.log "Adding MediaFile []: "
                        ( performMediaFileOnModel model.editingMediaFile addMediaFileToKomposition model, Cmd.none, Just (OutNavigateTo Page.KompostUI) )

                [ x ] ->
                    let
                        deleted =
                            performMediaFileOnModel model.editingMediaFile deleteMediaFileFromKomposition model

                        addedTo =
                            performMediaFileOnModel model.editingMediaFile addMediaFileToKomposition deleted
                    in
                    Debug.log "Updating mediaFile [x]: " ( addedTo, Cmd.none, Just (OutNavigateTo Page.KompostUI) )

                head :: tail ->
                    Debug.log "Seggie heads tails: " ( model, Cmd.none, Just (OutNavigateTo Page.KompostUI) )

        DeleteSource id ->
            let
                modifiedModel =
                    performMediaFileOnModel model.editingMediaFile deleteMediaFileFromKomposition model
            in
            ( modifiedModel, Cmd.none, Just (OutNavigateTo Page.KompostUI) )

        OrderChecksumEvalutation id ->
            ( model, fetchETagHeader id, Nothing )


containsMediaFile : String -> Komposition -> List Source
containsMediaFile id komposition =
    List.filter (\mediaFile -> mediaFile.id == id) komposition.sources


performMediaFileOnModel mf function model =
    { model | kompost = function mf model.kompost }


addMediaFileToKomposition : Source -> Komposition -> Komposition
addMediaFileToKomposition mediaFile komposition =
    { komposition | sources = [ mediaFile ] ++ komposition.sources }


deleteMediaFileFromKomposition : Source -> Komposition -> Komposition
deleteMediaFileFromKomposition mediaFile komposition =
    { komposition | sources = List.filter (\n -> n.id /= mediaFile.id) komposition.sources }


setConfig funk model =
    let
        kompost =
            model.kompost
    in
    { model | kompost = { kompost | config = funk } }


setSource funk model =
    { model | editingMediaFile = funk }


setBeatPattern funk model =
    let
        kompost =
            model.kompost

        beatpattern =
            case kompost.beatpattern of
                Just bpm ->
                    bpm

                Nothing ->
                    BeatPattern 0 0 0
    in
    ( { model | kompost = { kompost | beatpattern = Just funk } }, Cmd.none, Nothing )


standardInt value =
    Maybe.withDefault 0 (String.toInt value)


standardFloat value =
    Maybe.withDefault 0 (String.toFloat value)


extractBeatPattern : Model -> BeatPattern
extractBeatPattern model =
    case model.kompost.beatpattern of
        Just bpm ->
            bpm

        Nothing ->
            BeatPattern 0 0 0
