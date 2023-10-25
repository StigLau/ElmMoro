module CustomerMedia.FileUpload exposing (..)

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

--    InternalNavigateTo page ->
--        ( model, Cmd.none )



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
--    , Button.button [ Button.primary, Button.onClick (InternalNavigateTo Page.KompostUI) ] [ text "<- Back" ]
    ]


filesDecoder : D.Decoder (List File)
filesDecoder =
  D.at ["target","files"] (D.list File.decoder)

uploadMedia : File -> String -> Cmd Msg
uploadMedia fileId apiToken =
    Http.request
          { method = "PUT"
          , headers = [Http.header "Authy" apiToken]
          , url = "/kompo-storage/" ++ File.name fileId
          , body = Http.fileBody fileId
          , expect = Http.expectWhatever Uploaded
          , timeout = Nothing
          , tracker = Nothing
        }
