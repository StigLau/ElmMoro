module Models.Simple exposing (..)

import List exposing (length)
import Html exposing (..)
import Html.Attributes exposing (class, classList, type_)
import Json.Decode exposing (..)
import Time exposing (Time, second, millisecond)
import Task
import Html exposing (..)
import Html.Events exposing (..)
import Http
import Json.Encode
import Json.Decode
import Json.Decode exposing (..)
import JsonDecoding exposing (..)
import Process exposing (sleep)
import Models.KompostApi exposing (..)
import Models.ServerApi exposing (updateArtist)

type alias Model =
    { name : String
    , start : Int
    , end : Int
    , hats : List String
    }


type Msg
    = Update
    | GetFailed Http.Error
    | GetSucceeded (List String)
    | FetchKompost  (Result Http.Error Komposition)
    | SaveArtist
    | HandleSaved (Result Http.Error Artist)

type alias Artist =
    { id : Int
    , name : String
    }


initModel : ( Model, Cmd Msg )
-- initModel = ( Model "" "" "" [], (storeKompost (storeKompostRequest "http://localhost:9099/store/kompost" "Send this")) )
initModel = (Model "" -2 0 [], getKompo 1 FetchKompost)

-- storeKompost : Task.Task Http.Error (List String) -> Cmd Msg
-- storeKompost request = Task.perform GetFailed GetSucceeded request

{--
storeKompostRequest : String -> String -> Task.Task Http.Error (List String)
storeKompostRequest requestString destination =
    Http.post (list string) destination (Http.stringBody requestString)
--}

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Update ->
            ( model, Cmd.none )

        GetFailed _ ->
            ( model, Cmd.none )

        GetSucceeded strings ->
            ( { model | hats = strings }, Cmd.none )

        FetchKompost res ->
                     case res of
                         Result.Ok komposition ->
                             ( { model
                                 | name = komposition.name
                                 , start = komposition.start
                                 , end = komposition.end
                               }, Cmd.none )

                         Result.Err err ->
                             let _ = Debug.log "Error retrieving artist" err
                             in
                                 (model, Cmd.none)

        SaveArtist ->
                    case model.start of
                        start ->
                            ( model, updateArtist (Artist start model.name) HandleSaved )


        HandleSaved res ->
            case res of
                Result.Ok artist ->
                    ( { model
                        | start = artist.id
                        , name = artist.name
                      }
                    , Cmd.none --no Navigation: Routes.navigate Routes.ArtistListingPage
                    )

                Result.Err err ->
                    let _ = Debug.log "Error saving artist" err
                    in
                        (model, Cmd.none)


view : Model -> Html Msg
view model =
    Html.form [] [
     div [] [ text (model.name ++ " " ++ (toString model.start) ++ " " ++ (toString model) ++ String.join "," model.hats)] ,
      div [ ] [ button [ type_ "button", onClick SaveArtist ] [ text "Save" ] ]
    ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

main : Program Never Model Msg
main =
    program
        { init = initModel
        , view = view
        , update = update
        , subscriptions = subscriptions
        }