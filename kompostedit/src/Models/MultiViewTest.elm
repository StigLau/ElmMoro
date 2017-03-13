module Models.MultiViewTest exposing (..)

import Html exposing (..)
import Models.Segment as Segment exposing (..)
import Models.KompostModels as KompostModels exposing (..)
import Models.Kompost as Kompost exposing(..)

type alias Model = {
    segment : Segment.Model
    , kompo : KompostModels.Model
    }

type Msg
    = Segmenti Segment.Msg
    | KompostMsg Kompost.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Segmenti msg ->
            let
                ( segment, cmd ) = Segment.update msg model.segment
            in
                ( { model | segment = segment }, Cmd.map Segmenti cmd )

        KompostMsg msg ->
            let
                (kompModel, cmd) = Kompost.update msg model.kompo
            in
                (model, Cmd.map KompostMsg cmd)

init : ( Model, Cmd Msg )
init =
    let
        ( segment, segmentCmd ) = Segment.init
        ( kompomod, kompoCmd ) = Kompost.init
    in
        ( Model segment kompomod, Cmd.batch [ Cmd.map Segmenti segmentCmd ] )


view : Model -> Html Msg
view model =
    div [ ]
        [ h1 [] [ text "Multiview" ]
        , text "Multiview Model: "
        , text (toString model)
        , Html.map Segmenti (Segment.view model.segment)
        , Html.map KompostMsg (Kompost.view model.kompo)
        ]


subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

main : Program Never Model Msg
main = program { init = init, update = update, view = view, subscriptions = subscriptions}
