module DvlSpecifics.DvlSpecificsModel exposing (extractFromOutmessage, update)

import DvlSpecifics.Msg exposing (Msg(..))
import Models.BaseModel exposing (BeatPattern, Komposition, Model, OutMsg(..), Source)
import Navigation.Page as Page exposing (Page)


extractFromOutmessage : Maybe OutMsg -> Maybe Page
extractFromOutmessage childMsg =
    case childMsg of
        Just (OutNavigateTo page) ->
            Just page

        _ ->
            Nothing


update : DvlSpecifics.Msg.Msg -> Model -> ( Model, Maybe OutMsg )
update msg model =
    case msg of
        SetKompositionName name ->
            let
                kompost =
                    model.kompost
            in
            ( { model | kompost = { kompost | name = name } }, Nothing )

        SetDvlType dvlType ->
            let
                kompost =
                    model.kompost
            in
            ( { model | kompost = { kompost | dvlType = dvlType } }, Nothing )

        --Config
        SetWidth value ->
            let
                config =
                    model.kompost.config
            in
            ( setConfig { config | width = standardInt value } model, Nothing )

        SetHeight value ->
            let
                config =
                    model.kompost.config
            in
            ( setConfig { config | height = standardInt value } model, Nothing )

        SetFramerate value ->
            let
                config =
                    model.kompost.config
            in
            ( setConfig { config | framerate = standardInt value } model, Nothing )

        SetExtensionType value ->
            let
                config =
                    model.kompost.config
            in
            ( setConfig { config | extensionType = value } model, Nothing )

        SetBpm value ->
            let
                kompost =
                    model.kompost
            in
            ( { model | kompost = { kompost | bpm = standardFloat value } }, Nothing )

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
            ( model, Just (OutNavigateTo Page.KompostUI) )






setConfig funk model =
    let
        kompost =
            model.kompost
    in
    { model | kompost = { kompost | config = funk } }




setBeatPattern funk model =
    let
        kompost =
            model.kompost

    in
    ( { model | kompost = { kompost | beatpattern = Just funk } }, Nothing )


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
