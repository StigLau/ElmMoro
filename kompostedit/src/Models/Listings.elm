module Models.Listings exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Http
import Json.Decode as JsonD


type alias Model = {
    total_rows: Int,
    offset: Int,
    rows: List Row
    }

type Msg =
    FetchKompostResponseHandler (Result Http.Error DvlRef)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchKompostResponseHandler res ->
            case res of
                Result.Ok dvlRef ->(
                    { model
                    | total_rows = dvlRef.total_rows
                    , offset = dvlRef.offset
                    , rows = dvlRef.rows
                    }, Cmd.none )

                Result.Err err ->
                     let _ = Debug.log "Error retrieving komposition" err
                     in
                         (model, Cmd.none)



view : Model -> Html Msg
view model =
    div [ class "listings" ]
        [ h1 [] [ text "Listing stuff" ]
        , div [] [ text "What I get: " ]
        , text (toString model)
        , div [] [ ]
        ]



init : ( Model, Cmd Msg )
init = ( Model -1 -2 [ testrow ], (listDvlIds FetchKompostResponseHandler) )

testrow = Row "one" "two"

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

main : Program Never Model Msg
main = program { init = init, update = update, view = view, subscriptions = subscriptions}


listDvlIds : (Result Http.Error DvlRef -> msg) -> Cmd msg
listDvlIds msg = Http.get ("http://heap.kompo.st/_all_docs") dvlRefDecoder
        |> Http.send msg

dvlRefDecoder : JsonD.Decoder DvlRef
dvlRefDecoder = JsonD.map3 DvlRef
                           (JsonD.field "total_rows" JsonD.int)
                           (JsonD.field "offset" JsonD.int)
                           (JsonD.field "rows" <| JsonD.list rowDecoder)
                -- _ = Debug.log "testing out stuff" komp

rowDecoder : JsonD.Decoder Row
rowDecoder = JsonD.map2 Row
                           (JsonD.field "id" JsonD.string)
                           (JsonD.field "key" JsonD.string)

type alias DvlRef =
  { total_rows: Int
  , offset: Int
  , rows: List Row
  --, config: Config
  --, mediaFile: Mediafile
  --, segments: List Segment
  }

type alias Row =
    { id: String
    , key: String
    }