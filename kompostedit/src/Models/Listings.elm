module Models.Listings exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href, type_)
import Html.Events exposing (onClick)
import Http
import Json.Decode as JsonD


type alias Model =
  { dataRepresentation: DataRepresentation
  , selectedId: String
  }

type alias DataRepresentation =
  { total_rows: Int
  , offset: Int
  , rows: List Row
  }

type alias Row =
    { id: String
    , key: String
    }

type Msg =
    FetchDvlIdsResponseHandler (Result Http.Error DataRepresentation)
    | ChooseId String

type OutMsg
    = NeedMoney String

update : Msg -> Model -> ( Model, Cmd Msg, Maybe OutMsg )
update msg model =
    case msg of
        FetchDvlIdsResponseHandler res ->
            case res of
                Result.Ok dataRepresentation ->(
                    { model | dataRepresentation = dataRepresentation } , Cmd.none, Nothing )

                Result.Err err ->
                     let _ = Debug.log "Error retrieving komposition" err
                     in
                         (model, Cmd.none, Nothing)

        ChooseId selection ->
            let
                _ = Debug.log "Chosen " selection
            in
                ( { model | selectedId = selection} , Cmd.none, Just (NeedMoney selection) )

view : Model -> Html Msg
view model =
    div [ class "listings" ]
        [ h1 [] [ text ("Dvls in " ++ storeUrl) ]
        , table [ class "table table-striped" ]
            [ thead []
                [ tr []
                    [ th [] [ text "Id" ]
                    , th [] []
                    , th [] []
                    ]
                ]
            , tbody [] (List.map dvlRefRow model.dataRepresentation.rows)
            ]
        , text ("Current selection: " ++ model.selectedId)
        ]

dvlRefRow : Row -> Html Msg
dvlRefRow row =
    tr []
          [ td []  [ button [ type_ "button", onClick (ChooseId row.id)] [ text row.id ] ] --EvictBraggis(ChooseId row.id)
        ]

init : ( Model, Cmd Msg )
init = ( initModel, (listDvlIds FetchDvlIdsResponseHandler) )

initModel = Model (DataRepresentation -1 -2 [ Row "No contact with" "server side" ]) "Unselected ID"

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

main : Program Never Model Msg
main = program { init = init, update = myUpdate, view = view, subscriptions = subscriptions}

myUpdate:  Msg -> Model -> ( Model, Cmd Msg )
myUpdate msg model =
        let (modelz, cmd, status) = update msg model
        in (modelz, cmd)

listDvlIds : (Result Http.Error DataRepresentation -> msg) -> Cmd msg
listDvlIds msg = Http.get (storeUrl ++ "_all_docs") jsonBaseDecoder |> Http.send msg


-- JSON Storage
storeUrl : String
storeUrl = "http://heap.kompo.st/"

jsonBaseDecoder : JsonD.Decoder DataRepresentation
jsonBaseDecoder = JsonD.map3 DataRepresentation
                           (JsonD.field "total_rows" JsonD.int)
                           (JsonD.field "offset" JsonD.int)
                           (JsonD.field "rows" <| JsonD.list rowDecoder)

rowDecoder : JsonD.Decoder Row
rowDecoder = JsonD.map2 Row
                           (JsonD.field "id" JsonD.string)
                           (JsonD.field "key" JsonD.string)