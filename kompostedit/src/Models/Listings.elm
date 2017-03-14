module Models.Listings exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href, type_)
import Html.Events exposing (onClick)
import Http
import Json.Decode as JsonD


type alias Model =
  { total_rows: Int
  , offset: Int
  , rows: List Row
  }

type alias Row =
    { id: String
    , key: String
    }

type Msg =
    FetchDvlIdsResponseHandler (Result Http.Error Model)
    | ChooseId String

type OutMsg
    = NeedMoney String

update : Msg -> Model -> ( Model, Cmd Msg, Maybe OutMsg )
update msg model =
    case msg of
        FetchDvlIdsResponseHandler res ->
            case res of
                Result.Ok model ->( model , Cmd.none, Nothing )

                Result.Err err ->
                     let _ = Debug.log "Error retrieving komposition" err
                     in
                         (model, Cmd.none, Nothing)

        ChooseId identity ->
            let
                _ = Debug.log "Chosen " identity
            in
                ( model, Cmd.none, Just (NeedMoney "Hello") )

view : Model -> Html Msg
view model =
    div [ class "listings" ]
        [ h1 [] [ text ("Dvls in " ++ kompoUrl) ]
        , table [ class "table table-striped" ]
            [ thead []
                [ tr []
                    [ th [] [ text "Id" ]
                    , th [] []
                    , th [] []
                    ]
                ]
            , tbody [] (List.map dvlRefRow model.rows)
            ]
        ]

dvlRefRow : Row -> Html Msg
dvlRefRow row =
    tr []
          [ td []  [ button [ type_ "button", onClick (ChooseId row.id)] [ text row.id ] ] --EvictBraggis(ChooseId row.id)
        ]

kompoUrl : String
kompoUrl = "http://heap.kompo.st/"

init : ( Model, Cmd Msg )
init = ( initModel, (listDvlIds FetchDvlIdsResponseHandler) )

initModel = Model -1 -2 [ Row "No contact with" "server side" ]

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

main : Program Never Model Msg
main = program { init = init, update = myUpdate, view = view, subscriptions = subscriptions}

myUpdate:  Msg -> Model -> ( Model, Cmd Msg )
myUpdate msg model =
        let (modelz, cmd, status) = update msg model
        in (modelz, cmd)

listDvlIds : (Result Http.Error Model -> msg) -> Cmd msg
listDvlIds msg = Http.get (kompoUrl ++ "_all_docs") dvlRefDecoder |> Http.send msg

dvlRefDecoder : JsonD.Decoder Model
dvlRefDecoder = JsonD.map3 Model
                           (JsonD.field "total_rows" JsonD.int)
                           (JsonD.field "offset" JsonD.int)
                           (JsonD.field "rows" <| JsonD.list rowDecoder)

rowDecoder : JsonD.Decoder Row
rowDecoder = JsonD.map2 Row
                           (JsonD.field "id" JsonD.string)
                           (JsonD.field "key" JsonD.string)