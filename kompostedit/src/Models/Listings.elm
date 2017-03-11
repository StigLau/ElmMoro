module Models.Listings exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (class)
import Http
import Models.KompostApi exposing (getKompo, Komposition)


type alias Model = {
    something: String
    }

type Msg =
    FetchKompostResponseHandler (Result Http.Error Komposition)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchKompostResponseHandler res ->
            case res of
                Result.Ok komposition ->
                     ( model, Cmd.none )

                Result.Err err ->
                     let _ = Debug.log "Error retrieving komposition" err
                     in
                         (model, Cmd.none)



view : Model -> Html Msg
view model =
    div [ class "listings" ]
        [ h1 [] [ text "Listing stuff" ]
        , div [] [ text "Komposition: " ]
        , text (toString model)
        , div [] [ ]
        ]



init : ( Model, Cmd Msg )
init = ( Model "Somethingss", (getKompo "Init" FetchKompostResponseHandler) )


subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

main : Program Never Model Msg
main = program { init = init, update = update, view = view, subscriptions = subscriptions}
