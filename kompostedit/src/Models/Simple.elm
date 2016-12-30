module Models.Simple exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, classList, type_)
import Html.Events exposing (..)
import Http
import Models.KompostApi exposing (..)

type alias Model =
    { name : String
    , start : Int
    , end : Int
    , segments : List Segment
    }


type Msg
    = Update
    | GetFailed Http.Error
    | FetchKompost  (Result Http.Error Komposition)
    | StoreKomposition
    | HandleSaved (Result Http.Error Komposition)

initModel : ( Model, Cmd Msg )
-- initModel = ( Model "" "" "" [], (storeKompost (storeKompostRequest "http://localhost:9099/store/kompost" "Send this")) )
initModel = (Model "" -2 0 [], getKompo 1 FetchKompost)

-- storeKompost : Task.Task Http.Error (List String) -> Cmd Msg

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

        FetchKompost res ->
                     case res of
                         Result.Ok komposition ->
                             ( { model
                                 | name = komposition.name
                                 , start = komposition.start
                                 , end = komposition.end
                                 , segments = komposition.segments
                               }, Cmd.none )

                         Result.Err err ->
                             let _ = Debug.log "Error retrieving komposition" err
                             in
                                 (model, Cmd.none)

        StoreKomposition ->
                    case model.start of
                        start ->
                            ( model, updateKompo (Komposition model.name start model.end model.segments) FetchKompost )


        HandleSaved res ->
            case res of
                Result.Ok komposition ->
                    ( { model
                        | start = komposition.start
                        , name = komposition.name
                      }
                    , Cmd.none --no Navigation: Routes.navigate Routes.ArtistListingPage
                    )

                Result.Err err ->
                    let _ = Debug.log "Error saving komposition" err
                    in
                        (model, Cmd.none)


view : Model -> Html Msg
view model =
    Html.form [] [
     div [] [ text (model.name ++ " " ++ (toString model.start) ++ " " ++ (toString model) )] , --++ String.join "," model.segments
      div [ ] [ button [ type_ "button", onClick StoreKomposition ] [ text "Store Komposition" ] ]
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