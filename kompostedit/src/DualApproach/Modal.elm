module DualApproach.Modal exposing (..)

import Html exposing (Html, div, button, text, i, input, map)
import Html.Attributes exposing (class, classList, attribute, type_, id, disabled)
import Html.Events exposing (onClick, on, onInput)
-- import Events exposing (onClickStopPropagation)
import DualApproach.Slide as Slide exposing (..)
import Http exposing (Response)


type alias Model =
    { show : Bool
    , id : String
    , slide : Slide.Model
    }


init : ( Model, Cmd Msg )
init =
    ( Model False "MediaInputId" Slide.initModel, Cmd.none )


type Msg
    = Show
    | Hide
    | Edit Slide.Model
    | CreateResponse (Result Http.Error String)
    | CurrentSlide Slide.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Show ->
            ( { model | show = True }, Cmd.none )

        Hide ->
            init

        Edit editSlide ->
            let
                newModel =
                    { model | slide = editSlide }
            in
                update Show newModel


        CreateResponse (Err _) ->
            ( model, Cmd.none )

        CreateResponse (Ok _) ->
            update Hide model

        CurrentSlide msg ->
            let
                ( newSlide, newCmd ) =
                    Slide.update msg model.slide
            in
                ( { model | slide = newSlide }, Cmd.map CurrentSlide newCmd )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map CurrentSlide <| Slide.subscriptions model.slide



icon : String -> Html msg
icon c =
    i [ class <| "icon-" ++ c ] []


isEmpty : Slide.Model -> Bool
isEmpty m =
    if m.body == "" then
        True
    else
        False


view : Model -> Html Msg
view model =
    div [ class "slide slide--new-slide", onClick Show ]
        [ div [ class "slide__content slide__content--new-slide" ] []
        , div [ classList [ ( "modal", True ), ( "modal--visible", model.show ) ] ]
            [  ]
        ]




showModalContent : Model -> Html Msg
showModalContent model =
    div [ class "modal__content" ]
        [ map CurrentSlide (Slide.editView model.slide)
        ]


