module UI.DvlSpecificsUI exposing (showSpecifics, editSpecifics, update, extractFromOutmessage)

import Models.MsgModel exposing ( Model)
import Html exposing (..)
import Html.Attributes exposing (class, href)
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.CDN as CDN
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Select as Select
import Bootstrap.Form.Checkbox as Chk
import Bootstrap.Button as Button
import Models.KompostModels exposing (Komposition)
import Models.DvlSpecificsModel as DvlSpecificsModel exposing (..)
import RemoteData exposing (WebData)
import Navigation.AppRouting exposing (Page(Kompost))

editSpecifics : Komposition -> Html DvlSpecificsModel.Msg
editSpecifics kompo =
    div [] [ h1 [] [ text "Editing Specifics" ]
        , Form.form [ class "container" ]
            [ immutableRow "Name" kompo.name
            , immutableRow "Revision" kompo.revision
            , let bpm = case kompo.bpm of
                    Just bpm -> bpm
                    _ -> ""
              in editableRow "BPM" bpm DvlSpecificsModel.SetBpm
            , editableRow "Media link" kompo.mediaFile.fileName SetFileName
            , editableRow "Checksum" kompo.mediaFile.checksum SetChecksum
            , Button.button [ Button.secondary, Button.onClick (DvlSpecificsModel.InternalNavigateTo Kompost) ] [ text "Save" ]
            ]
        ]

showSpecifics kompo config =
    Grid.container []
        [ addRow "Name" (text kompo.name)
        , addRow "Revision" (text kompo.revision)
        , let bpm = case kompo.bpm of
                            Just bpm -> bpm
                            _ -> ""
                      in addRow "BPM" (text bpm)
        , addRow "Media link" (a [ Html.Attributes.href kompo.mediaFile.fileName ] [ text kompo.mediaFile.fileName ])
        , addRow "Checksum" (text kompo.mediaFile.checksum)
        , Button.button [ Button.primary, Button.small, Button.onClick (config.onClickEditSpecifics) ] [ text "Edit Specifics" ]
        ]

addRow title htmlIsh =
    Grid.row []
        [ Grid.col [] [ text title ]
        , Grid.col [] [ htmlIsh ]
        ]

editableRow identifier defaultValue action =
        Form.row [  ]
          [ Form.colLabel [ Col.xs4 ]
              [ text identifier ]
          , Form.col [ Col.xs8 ]
              [ Input.text [ Input.id identifier, Input.defaultValue defaultValue, Input.onInput action ] ]
          ]

immutableRow identifier defaultValue =
        Form.row [  ]
          [ Form.colLabel [ Col.xs4 ]
              [ text identifier ]
          , Form.col [ Col.xs8 ]
              [ Input.text [ Input.id identifier, Input.defaultValue defaultValue, Input.disabled True] ]
          ]

extractFromOutmessage: Maybe DvlSpecificsModel.OutMsg -> Maybe Page
extractFromOutmessage childMsg =
    case childMsg of
        Just (DvlSpecificsModel.OutNavigateTo page) -> Just page
        _ -> Nothing


update : DvlSpecificsModel.Msg -> Model -> ( Model, Cmd DvlSpecificsModel.Msg, Maybe OutMsg )
update msg model =
    case msg of
        DvlSpecificsModel.SetBpm bpm ->
            let
                kompost = model.kompost
            in ({ model | kompost = {kompost | bpm = Just bpm}}, Cmd.none, Nothing)

        DvlSpecificsModel.SetFileName fileName ->
            let
                mediaFile = model.kompost.mediaFile
            in ((updateMediaFile { mediaFile | fileName = fileName } model), Cmd.none, Nothing)

        DvlSpecificsModel.SetChecksum checksum ->
            let
                mediaFile = model.kompost.mediaFile
            in ((updateMediaFile { mediaFile | checksum = checksum } model), Cmd.none, Nothing)

        DvlSpecificsModel.InternalNavigateTo page ->
            let _ = Debug.log "Navigating to" page
                _ = Debug.log "BPM is" model.kompost.bpm
            in (model, Cmd.none, Just (DvlSpecificsModel.OutNavigateTo Kompost))

updateMediaFile mediaFile model =
    let
        kompost = model.kompost
    in { model | kompost = {kompost | mediaFile = mediaFile}}