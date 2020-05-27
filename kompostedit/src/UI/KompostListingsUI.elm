module UI.KompostListingsUI exposing (listings)

import Bootstrap.Button as Button exposing (onClick)
import Bootstrap.ButtonGroup as ButtonGroup
import Bootstrap.Grid as Grid
import Html exposing (..)
import Html.Attributes exposing (class, style)
import Models.BaseModel exposing (DataRepresentation, Model, Row)
import Models.Msg exposing (Msg(..))


listings : Model -> Html Msg
listings model =
    div [ class "listings" ]
        [ h1 [] [ text "Kompositions" ]
        , table [ class "table table-striped" ]
            [ thead []
                [ tr []
                    [ ButtonGroup.radioButtonGroup []
                        [ ButtonGroup.radioButton True [ Button.secondary, Button.onClick (ChangeKompositionType "Komposition") ] [ Html.text "Komposition" ]
                        , ButtonGroup.radioButton False [ Button.warning, Button.onClick (ChangeKompositionType "Video") ] [ Html.text "Video" ]
                        , ButtonGroup.radioButton False [ Button.success, Button.onClick (ChangeKompositionType "Audio") ] [ Html.text "Audio" ]
                        ]
                    , tbody [] (List.map (chooseDvlButton model) model.listings.docs)
                    , Grid.simpleRow [ Grid.col [] [ Button.button [ Button.primary, Button.small, Button.onClick NewKomposition ] [ text "New Komposition" ] ] ]                    ]
                    , Grid.simpleRow [ Grid.col [] [ Button.button [ Button.small, Button.onClick ToAuthPage ] [ text "User" ] ] ]
                ]
            ]
        ]


chooseDvlButton : Model -> Row -> Html Msg
chooseDvlButton model row =
    Button.button
        [ Button.attrs [ style "margin-top" "auto" ]
        , Button.secondary
        , onClick <| ChooseDvl row.id
        ]
        [ text row.id ]
