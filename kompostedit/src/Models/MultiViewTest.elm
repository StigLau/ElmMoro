module Models.MultiViewTest exposing (..)

import Html exposing (..)
import Models.Simple as Segment exposing (..)

type alias Model = { segment : Segment.Model }

type Msg
    = Segmenti Segment.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Segmenti msg ->
            let
                ( segment, cmd ) = Segment.update msg model.segment
            in
                ( { model | segment = segment }, Cmd.map Segmenti cmd )


init : ( Model, Cmd Msg )
init =
    let
        ( segment, segmentCmd ) = Segment.init
    in
        ( Model segment, Cmd.batch [ Cmd.map Segmenti segmentCmd ] )


view : Model -> Html Msg
view model =
    div [ ]
        [ h1 [] [ text "Kompost dvl editor" ]
        , text "What I gots: "
        , text (toString model)
        ]


subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

main : Program Never Model Msg
main = program { init = init, update = update, view = view, subscriptions = subscriptions}
