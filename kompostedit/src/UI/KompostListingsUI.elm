module UI.KompostListingsUI exposing (listings)

import Bootstrap.Button as Button exposing (onClick)
import Bootstrap.ButtonGroup as ButtonGroup
import Bootstrap.Form.Input as Input
import Bootstrap.Grid as Grid
import Html exposing (..)
import Html.Attributes exposing (class, href, style)
import Models.BaseModel exposing (DataRepresentation, IntegrationDestination, Model, Row)
import Models.Msg as Msg exposing (Msg(..))


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
                        --Show Komposition/Video list
                    , tbody [] (List.map (chooseDvlButton model) model.listings.docs)
                    , Grid.simpleRow
                        [ Grid.col []
                            [ Button.button [ Button.primary, Button.small, Button.onClick NewKomposition ] [ text "New Komposition" ]
                            ]
                        ]
                    , Input.text [ Input.id "id", Input.value model.integrationDestination, Input.onInput Msg.ChangedIntegrationId ]
                    , Button.button [ Button.primary, onClick <| FetchLocalIntegration (IntegrationDestination model.integrationDestination model.metaUrl) ] [ text "Fetch YT metadata" ]
                    , Input.text [ Input.id "format", Input.value model.integrationFormat, Input.onInput Msg.ChangedIntegrationFormat ]
                    , Button.button [ Button.primary, onClick <| FetchLocalIntegration (IntegrationDestination (model.integrationDestination ++ "/" ++ model.integrationFormat) model.cacheUrl) ] [ text "Cache Media" ]
                    , li [] [ a [ href ("fileupload.html?authy="++model.apiToken) ] [ text "Upload file" ] ]
                    ]
                , Grid.simpleRow
                    [ Grid.col []
                        []
                    ]
                ]
            ]
        ]


chooseDvlButton : Model -> Row -> Html Msg
chooseDvlButton model row =
    Button.button
        [ Button.attrs [ style "margin-top" "auto" ]
        , Button.secondary
        , onClick <| FetchLocalIntegration (IntegrationDestination row.id model.kompoUrl)
        ]
        [ text row.id ]
