module Models.Segment exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Models.KompostApi exposing (..)
import Functions exposing (validNr)
import Models.KompostModels exposing (Komposition)

type alias Model =
    { name : String
    , revision : String
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
initModel = Model "Backend not functional" "none" -2

init : ( Model, Cmd Msg )
init = (initModel, (getKompo "4317d37968f8b991c5cd28a86e71d9ca" FetchKompost))

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Update -> ( model, Cmd.none )

        GetFailed _ ->
            ( model, Cmd.none )

        FetchKompost res ->
                     case res of
                         Result.Ok komp ->
                             ( { model
                                 | name = komp.name
                                 , revision = komp.revision
                               }, Cmd.none )

                         Result.Err err ->
                             let _ = Debug.log "Error retrieving komposition" err
                             in
                                 (model, Cmd.none)

        HandleSaved res ->
            case res of
                Result.Ok komp ->
                    (  model



                    , Cmd.none --no Navigation: Routes.navigate Routes.ArtistListingPage
                    )

                Result.Err err ->
                    let _ = Debug.log "Error saving komposition" err
                    in
                        (model, Cmd.none)

        SetSegmentName name ->
            ( { model | name = name }, Cmd.none )

        SetSegmentStart revision ->
            ( { model | revision = revision }, Cmd.none )

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
        [ h1 [] [ text "Segment editor" ]
        , input
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
            , Html.Attributes.value (toString model.revision)
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