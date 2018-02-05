module UI.KompostListingsUI exposing (listings)

import Html exposing (..)
import Html.Attributes exposing (class, href, type_)
import Http
import Json.Decode as JsonD
import RemoteData exposing (WebData)
import Bootstrap.Button as Button exposing (onClick)
import Bootstrap.Grid as Grid
import Bootstrap.CDN
import Html.Attributes exposing (style)
import Models.Msg exposing (Msg(ChooseDvl, NewKomposition))
import Models.BaseModel exposing (Model, DataRepresentation, Row)



listings : Model -> Html Msg
listings model =
    div [ class "listings" ]
        [ h1 [] [ text ("Dvls in ") ]
        , table [ class "table table-striped" ]
            [ thead []
                [ tr []
                    [ th [] [ text "Id" ]
                    , case RemoteData.toMaybe model.listings of
                        Just listings ->
                            tbody [] (List.map (chooseDvlButton model) listings.docs)

                        Nothing ->
                            text "loading."
                    , Grid.simpleRow [ Grid.col [] [ Button.button [ Button.primary, Button.small, Button.onClick NewKomposition ] [ text "New Komposition" ] ] ]
                    ]
                ]
            ]
        ]


chooseDvlButton : Model -> Row -> Html Msg
chooseDvlButton model row =
    Button.button
        [ Button.attrs [ style [ ( "margin-top", "auto" ) ] ]
        , Button.secondary
        , onClick <| (ChooseDvl row.id)
        ]
        [ text row.id ]
