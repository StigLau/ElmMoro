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
    , auth: String
    }

init : () -> (Model, Cmd Msg)
init _ =
  (Model [] "", Cmd.none)



-- UPDATE


type Msg
  = GotFiles (List File)
  | Uploaded (Result Http.Error ())
  | ConvertToSource File
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
            (Model files model.auth, upload)

    Uploaded result->
        let _ = Debug.log "Upload result" result
        in (model, Cmd.none)

    ConvertToSource file ->
        (model, createMeta file model.auth)


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
    , div [] [showSegmentList model.files]

--    , Button.button [ Button.primary, Button.onClick (InternalNavigateTo Page.KompostUI) ] [ text "<- Back" ]
    ]

showSegmentList : List File -> Html Msg
showSegmentList files =
    div []
        (Grid.row []
            [ Grid.col [] [ text "Segment" ], Grid.col [] [ text "Start" ], Grid.col [] [ text "Duration" ] ]
            ::  List.map showSingleSegment files
        )


showSingleSegment : File -> Html Msg
showSingleSegment file  =
    Grid.row []
        [ Grid.col [] [ Button.button [ Button.secondary, Button.small, Button.onClick (ConvertToSource file) ] [ text <| "Extract Metadata for " ++ File.name file ] ]
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

createMeta : File -> String -> Cmd Msg
createMeta fileId apiToken =
    Http.request
          { method = "PUT"
          , headers = [Http.header "Authy" apiToken]
          , url = "/functions/metadata-extractor/" ++ File.name fileId
          , body = Http.emptyBody
          , expect = Http.expectWhatever Uploaded
          , timeout = Nothing
          , tracker = Nothing
        }
