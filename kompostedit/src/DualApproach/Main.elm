module DualApproach.Main exposing (..)

import Html exposing (Html, program, map, div, h1, text, ul)
import Html.Attributes exposing (class)
import DualApproach.Slides as Slides


type alias Model = { slides : Slides.Model }


init : ( Model, Cmd Msg )
init =
    let
        ( slides, slidesCmd ) =
            Slides.init
    in
        ( Model slides
        , Cmd.batch [ Cmd.map SlideList slidesCmd ]
        )


type Msg
    = SlideList Slides.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SlideList msg ->
            let
                ( slides, cmd ) =
                    Slides.update msg model.slides
            in
                ( { model | slides = slides }, Cmd.map SlideList cmd )




view : Model -> Html Msg
view model =
    let
        slides =
            List.map (\slide -> map SlideList slide) <| Slides.view model.slides

    in
        div []
            [ h1 [] [ text "Switcharoo" ]
            , ul [ class "slides" ] <| slides
            , text (toString slides )
            ]


subscriptions : Model -> Sub Msg
subscriptions model = Sub.map SlideList <| Slides.subscriptions model.slides


main : Program Never Model Msg
main = program { init = init, view = view, update = update, subscriptions = subscriptions }
