port module Spelling exposing (Model, Msg(..), check, init, main, subscriptions, suggestions, update, view)

import Html exposing (..)
import Html.Events exposing (..)
import String


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { word : String
    , suggestions : List String
    }


init : ( Model, Cmd Msg )
init =
    ( Model "Clarian_Ver_11_Am_Mix.mp3" [], Cmd.none )



-- UPDATE


type Msg
    = Change String
    | Check
    | Suggest (List String)


port check : String -> Cmd msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change newWord ->
            ( Model newWord [], Cmd.none )

        Check ->
            ( model, check model.word )

        Suggest newSuggestions ->
            ( Model model.word newSuggestions, Cmd.none )



-- SUBSCRIPTIONS


port suggestions : (List String -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    suggestions Suggest



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ onInput Change ] []
        , button [ onClick Check ] [ text "CheckLoaduu" ]
        , div [] [ text (String.join ", " model.suggestions) ]
        ]
