module Models.Segment exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Models.KompostApi exposing (..)
import Functions exposing (validNr)

type alias Model =
    { name : String
    , start : Int
    , end : Int
    }

type Msg
    = Update
    | GetFailed Http.Error
    | FetchKompost  (Result Http.Error Komposition)
    | HandleSaved (Result Http.Error Komposition)

    | SetSegmentName String
    | SetSegmentStart String
    | SetSegmentEnd String

initModel: Model
initModel = Model "Backend not functional" -2 -2

init : ( Model, Cmd Msg )
init = (initModel, Cmd.none)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Update -> ( model, Cmd.none )

        GetFailed _ ->
            ( model, Cmd.none )

        FetchKompost res ->
                     case res of
                         Result.Ok komposition ->
                             ( { model
                                 | name = komposition.name
                                 , start = komposition.start
                                 , end = komposition.end
                               }, Cmd.none )

                         Result.Err err ->
                             let _ = Debug.log "Error retrieving komposition" err
                             in
                                 (model, Cmd.none)

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

        SetSegmentName name ->
            ( { model | name = name }, Cmd.none )

        SetSegmentStart start ->
            ( { model | start = (validNr start) }, Cmd.none )

        SetSegmentEnd end ->
            ( { model | end = (validNr end) }, Cmd.none )


view : Model -> Html Msg
view model =
    Html.form [] [
     segmentForm model
     --, div [ ] [ button [ type_ "button", onClick StoreKomposition ] [ text "Store Komposition" ] ]
    ]


segmentForm : Model -> Html Msg
segmentForm model =
    Html.form []
        [ input
            [ type_ "text"
            , placeholder "Segment Name"
            , onInput SetSegmentName
            , Html.Attributes.value model.name
            ]
            []
        , input
            [ type_ "number"
            , placeholder "Start"
            , onInput SetSegmentStart
            , Html.Attributes.value (toString model.start)
            ]
            []
        , input
            [ type_ "number"
            , placeholder "End"
            , onInput SetSegmentEnd
            , Html.Attributes.value (toString model.end)
            ]
            []
        --, button [ type_ "button", onClick Save ] [ text "Save" ]
        ]

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }