module UI.KompostListingsUI exposing (listings)

import Html exposing (..)
import Html.Attributes exposing (class, href, type_)
import Http
import Json.Decode as JsonD
import RemoteData exposing (WebData)
import Bootstrap.Button as Button exposing (onClick)
import Bootstrap.Grid as Grid
import Bootstrap.ButtonGroup as ButtonGroup
import Bootstrap.CDN
import Html.Attributes exposing (style)
import Models.Msg exposing (Msg(ChooseDvl, NewKomposition, ChangeKompositionType ))
import Models.BaseModel exposing (Model, DataRepresentation, Row)



listings : Model -> Html Msg
listings model =
    div [ class "listings" ]
        [ h1 [] [ text ("Kompositions") ]
        , table [ class "table table-striped" ]
            [ thead []
                [ tr []
                    [ case RemoteData.toMaybe model.listings of
                        Just listings ->
                            tbody [] (List.map (chooseDvlButton model) listings.docs)

                        Nothing ->
                            text "loading."
                    , Grid.simpleRow [ Grid.col [] [ Button.button [ Button.primary, Button.small, Button.onClick NewKomposition ] [ text "New Komposition" ] ] ]

                    , ButtonGroup.radioButtonGroup []
                                      [ ButtonGroup.radioButton True [ Button.secondary, Button.onClick (ChangeKompositionType "Komposition") ] [ Html.text "Komposition" ]
                                      , ButtonGroup.radioButton False [ Button.warning, Button.onClick (ChangeKompositionType "Video") ] [ Html.text "Video" ]
                                      , ButtonGroup.radioButton False [ Button.success, Button.onClick (ChangeKompositionType "Audio") ] [ Html.text "Audio" ]
                                      ]
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
