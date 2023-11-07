module CustomerMedia.FileUpload exposing (..)

import Bootstrap.Button as Button
import Bootstrap.Grid as Grid
import Browser
import File exposing (File)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as D
import RemoteData exposing (RemoteData(..), WebData)

main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
    { files:List File
    , orphans: List String
    , auth: String
    , mediaContentBucket: String
    }

init : String -> (Model, Cmd Msg)
init authKey =
  (Model [] ["No Orphans"] authKey "kompo-customer-storage", Cmd.batch [ fetchOrphans authKey ] )



-- UPDATE


type Msg
  = GotFiles (List File)
  | Uploaded (Result Http.Error ())
  | ConvertToSource File
  | OrpansUpdated (WebData (List String))
  | ProcessOrphan String
  --| InternalNavigateTo Page


update : Msg -> Model -> (Model, Cmd Msg) -- ( Model, Cmd Msg, Maybe OutMsg ) -- or ( Model, Maybe OutMsg ) -- or
update msg model =
  case msg of
    GotFiles files ->
        let
            upload = case files of
                [head] -> uploadMedia head model.auth
                _ -> Debug.log "ONLY uploading one at a time!"  Cmd.none
          in
          ({model| files = files, auth = model.auth}, upload)

    Uploaded result->
        let _ = Debug.log "Upload result" result
        in (model, Cmd.none)

    ConvertToSource file ->
        (model, createMeta model file)

    OrpansUpdated (Success orphans) ->
        ({model|orphans = orphans}, Cmd.none)

    OrpansUpdated _ ->
        ({model|orphans=["noone found"]}, Cmd.none)

    ProcessOrphan orphanId->
        (model, convertOrphan orphanId model)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ input
        [ type_ "file", multiple True, on "change" (D.map GotFiles filesDecoder)
        ]
        []
    , div [] [ text (Debug.toString model) ]
    --, Html.map SegmentMsg (Segment.SegmentUI.showSegmentList model.kompost.segments)
    --, div [] (List.map showSingleSegment model.files)
    , div [] [showOrphanList model, showSegmentList model]

--    , Button.button [ Button.primary, Button.onClick (InternalNavigateTo Page.KompostUI) ] [ text "<- Back" ]
    ]

showSegmentList : Model -> Html Msg
showSegmentList model =
    div []
        (Grid.row []
            [ Grid.col [] [ text "Segment" ], Grid.col [] [ text "Start" ], Grid.col [] [ text "Duration" ] ]
            ::  List.map showSingleSegment model.files
        )

showOrphanList : Model -> Html Msg
showOrphanList model =
    div []
        (Grid.row []
            [ Grid.col [] [ text "Extract Metadata" ] ]
            ::  List.map showSingleOrphan model.orphans
        )


showSingleSegment : File -> Html Msg
showSingleSegment file  =
    Grid.row []
        [ Grid.col [] [ Button.button [ Button.secondary, Button.small, Button.onClick (ConvertToSource file) ] [ text <| File.name file ] ]
        , Grid.col [] [  ]
        , Grid.col [] [  ]
        ]

showSingleOrphan : String -> Html Msg
showSingleOrphan orphanId  =
    Grid.row []
        [ Grid.col [] [ Button.button [ Button.secondary, Button.small, Button.onClick (ProcessOrphan orphanId) ] [ text orphanId ] ]
        , Grid.col [] [  ]
        , Grid.col [] [  ]
        ]

filesDecoder : D.Decoder (List File)
filesDecoder =
  D.at ["target","files"] (D.list File.decoder)

uploadMedia : File -> String -> Cmd Msg
uploadMedia fileId apiToken =
    Http.request
          { method = "PUT"
          , headers = [Http.header "Authy" apiToken]
          , url = "/functions/kompo-storage/" ++ File.name fileId
          , body = Http.fileBody fileId
          , expect = Http.expectWhatever Uploaded
          , timeout = Nothing
          , tracker = Nothing
        }

createMeta : Model -> File -> Cmd Msg
createMeta model fileId =
    Http.request
          { method = "POST"
          , headers = [Http.header "Authy" model.auth]
          , url = "/functions/metadata-extractor/" ++ model.mediaContentBucket ++ "/" ++ File.name fileId
          , body = Http.emptyBody
          , expect = Http.expectWhatever Uploaded
          , timeout = Nothing
          , tracker = Nothing
        }

fetchOrphans : String -> Cmd Msg
fetchOrphans apiToken =
    let
        _ = Debug.log "Starting the orphaned engines " apiToken
    in Http.request
          { method = "POST"
          , headers = [Http.header "Authy" apiToken]
          , url = "/functions/orphans"
          , body = Http.emptyBody
          , expect = Http.expectJson (RemoteData.fromResult >> OrpansUpdated) stringListDecoder
          , timeout = Nothing
          , tracker = Nothing
        }



convertOrphan : String -> Model -> Cmd Msg
convertOrphan orphanId model =
    Http.request
          { method = "POST"
          , headers = [Http.header "Authy" model.auth]
          , url = "/functions/metadata-extractor/" ++ model.mediaContentBucket ++ "/" ++ orphanId
          , body = Http.emptyBody
          , expect = Http.expectWhatever Uploaded --Http.expectJson (RemoteData.fromResult >> OrpansUpdated) stringListDecoder
          , timeout = Nothing
          , tracker = Nothing
        }


stringListDecoder : D.Decoder (List String)
stringListDecoder =
    D.list D.string