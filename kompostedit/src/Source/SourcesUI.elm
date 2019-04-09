module Source.SourcesUI exposing (editSpecifics, update)

import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Form.Checkbox as Checkbox
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Select as Select
import Bootstrap.Grid.Col as Col
import Common.StaticVariables exposing (evaluateMediaType)
import Common.UIFunctions exposing (selectItems)
import Html exposing (..)
import Html.Attributes exposing (class)
import Models.BaseModel exposing (Komposition, Model, OutMsg(..), Source)
import Models.KompostApi exposing (fetchETagHeader, getDvlSegmentList)
import Models.Msg
import Navigation.Page as Page
import Source.Msg exposing (Msg(..))

update : Source.Msg.Msg -> Model -> ( Model, Cmd Models.Msg.Msg, Maybe OutMsg )
update msg model =
    case msg of
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
                _ =
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
            ( model, fetchETagHeader id, Nothing)

        JumpToSourceKomposition mediaId ->
            let _ = Debug.log "Navigating to Komposition" mediaId
            in ({ model | activePage = Page.KompostUI}, Models.KompostApi.getKomposition mediaId, Nothing)


editSpecifics : Model -> Html Msg
editSpecifics model =
    let
        mediaFile =
            model.editingMediaFile

        sourceSnippetText =
            case mediaFile.isSnippet of
                True ->
                    "Snippet"

                False ->
                    "Source"
    in
    div []
        [ h1 [] [ Checkbox.checkbox [ Checkbox.onCheck SetSnippet, Checkbox.checked mediaFile.isSnippet ] ("Editing " ++ sourceSnippetText) ]
        , Form.form [ class "container" ]
            [ Form.row []
                [ Form.colLabel [Col.xs3  ][ text "ID" ]
                , Form.col [Col.xs1] [ Button.button [ Button.primary, Button.small, Button.onClick (JumpToSourceKomposition mediaFile.id)] [ text "Navigate To" ] ]
                , Form.col [Col.xs8] [(Input.text [ Input.id "id", Input.value mediaFile.id, Input.onInput SetId ])]
                ]
            , wrapping "URL" (Input.text [ Input.id "URLz", Input.value mediaFile.url, Input.onInput SetURL ])
            , wrapping "Starting Offset"
                (Input.text
                    [ Input.id "Starting Offset"
                    , Input.value (String.fromFloat mediaFile.startingOffset)
                    , Input.onInput SetOffset
                    ]
                )
            , wrapping "Checksums" (Input.text [ Input.id "Checksumz", Input.value mediaFile.checksum, Input.onInput SetChecksum ])
            , wrapping "Extension Type"
                (Select.select [ Select.id "segmentId", Select.onChange SetSourceExtensionType ]
                    (selectItems mediaFile.extensionType Common.StaticVariables.extensionTypes)
                )
            , wrapping "Media type"
                (Select.select [ Select.id "Media type", Select.onChange SetSourceMediaType ]
                    (selectItems mediaFile.mediaType Common.StaticVariables.mediaTypes)
                )
            , Form.row []
                [ Form.colLabel [ Col.xs4 ]
                    []
                , Form.col []
                    [ Button.button [ Button.primary, Button.small, Button.onClick SaveSource ] [ text "Back" ] ]
                , Form.col []
                    []
                , Form.col []
                    [ Button.button [ Button.warning, Button.small, Button.onClick (DeleteSource mediaFile.id) ] [ text "Remove" ] ]
                , Form.col []
                    [ Button.button [ Button.small, Button.onClick (OrderChecksumEvalutation mediaFile.id) ] [ text "Evaluate Checksum" ] ]
                ]
            ]
        ]


wrapping identifier funk =
    Form.row []
        [ Form.colLabel [ Col.xs4 ]
            [ text identifier ]
        , Form.col [ Col.xs8 ]
            [ funk ]
        ]

setSource funk model =
    { model | editingMediaFile = funk }

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

standardFloat value =
    Maybe.withDefault 0 (String.toFloat value)
