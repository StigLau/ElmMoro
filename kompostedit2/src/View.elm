module View exposing (products, cart, listings, kompost)

{-| GUI Entrails


# Views

@docs products, cart

-}

import MsgModel exposing (Product, Config, Row, Msg)
import AppRouting exposing (Page(Home))
import Bootstrap.Button exposing (onClick)
import Bootstrap.CDN
import Bootstrap.Card as Card
import CDN
import Html exposing (..)
import Html.Attributes exposing (class, href, src, style, type_, placeholder)
import RemoteData exposing (RemoteData(..), WebData, isLoading)
import Html.Events exposing (onInput)


url : String
url =
    "https://hipstore.now.sh/"


theme : Bool -> Html msg
theme showLoadingIndicator =
    let
        paceConfig =
            Html.node "script" [] [ text """
window.paceOptions = {
    ajax: {
        trackMethods: ["GET", "POST", "PUT", "DELETE", "REMOVE"]
    },
    restartOnRequestAfter: true
};

        """ ]

        paceTheme =
            Html.node "style" [] [ text """
.pace {
  -webkit-pointer-events: none;
  pointer-events: none;

  -webkit-user-select: none;
  -moz-user-select: none;
  user-select: none;

  position: fixed;
  top: 0;
  left: 0;
  width: 100%;

  -webkit-transform: translate3d(0, -50px, 0);
  -ms-transform: translate3d(0, -50px, 0);
  transform: translate3d(0, -50px, 0);

  -webkit-transition: -webkit-transform .5s ease-out;
  -ms-transition: -webkit-transform .5s ease-out;
  transition: transform .5s ease-out;
}

.pace.pace-active {
  -webkit-transform: translate3d(0, 0, 0);
  -ms-transform: translate3d(0, 0, 0);
  transform: translate3d(0, 0, 0);
}

.pace .pace-progress {
  display: block;
  position: fixed;
  z-index: 2000;
  top: 0;
  right: 100%;
  width: 100%;
  height: 10px;
  background: #8776dd;

  pointer-events: none;
}        """ ]

        loading =
            if showLoadingIndicator then
                [ paceConfig
                , Html.node "script" [ Html.Attributes.src "https://cdnjs.cloudflare.com/ajax/libs/pace/1.0.2/pace.min.js" ] []
                , paceTheme
                ]
            else
                [ text "" ]
    in
        span [] <|
            [ Bootstrap.CDN.stylesheet
            , .css CDN.fontAwesome
            ]
                ++ loading


product : Config msg -> Product -> Html msg
product config p =
    Card.config
        []
        |> Card.block []
            [ Card.text []
                [ img [ src <| url ++ p.image, style [ ( "max-width", "100%" ), ( "border-radius", "3px" ) ] ] []
                ]
            , Card.text [] [ strong [] [ text p.displayName ] ]
            , Card.text []
                [ Html.p []
                    [ text "Costs: "
                    , text "\x1F32E"
                    , text (toString p.tacos)
                    ]
                ]
            ]
        |> Card.footer []
            [ Bootstrap.Button.button
                [ Bootstrap.Button.attrs [ style [ ( "margin-top", "auto" ) ] ]
                , onClick <| config.onAddToCart p.id
                , Bootstrap.Button.secondary
                , Bootstrap.Button.block
                ]
                [ text "Add to Cart \x1F6D2" ]
            ]
        |> Card.view


{-| This function will render a nice, full-page view of the products that are passed into it.
The second argument, the bool, represents whether or not something is currently loading (for rendering a nice loading indicator.) The third argument is a WebData of the Products, and the fourth is a WebData of the products currently in the cart.
-}
products : Config msg -> Html msg
products config =
    div
        [ style
            [ ( "display", "grid" )
            , ( "grid-template-rows", "min-content min-content 1fr min-content" )
            , ( "height", "100vh" )
            , ( "color", "#616161" )
            ]
        ]
        [ theme config.loadingIndicator
        , div
            [ style
                [ ( "display", "flex" )
                , ( "align-items", "center" )
                , ( "justify-content", "center" )
                , ( "height", "75px" )
                , ( "padding", "0 2rem" )
                ]
            ]
            [ h4 [ style [ ( "flex", "1" ) ] ] [ text "Products" ]
            , Bootstrap.Button.button
                [ Bootstrap.Button.secondary
                , Bootstrap.Button.onClick config.onClickViewCart
                ]
                [ text "\x1F6D2"
                , case RemoteData.toMaybe config.cart of
                    Just cart ->
                        text <| " " ++ (toString <| List.length cart) ++ " items"

                    Nothing ->
                        text ""
                ]
            , text " "

            , Bootstrap.Button.button
                [ Bootstrap.Button.secondary
                , Bootstrap.Button.onClick config.onClickViewListings
                ]
                [ text "\x1F6D2"
                ,


                let _ = Debug.log "Error retrieving komposition" config.listings
                in
                    case RemoteData.toMaybe config.listings of
                        Just listings ->
                            text <| " " ++ (toString <| List.length listings.rows) ++ " Listings"

                        Nothing ->
                            text "Loading"
                ]
            ]
        , div
            [ style
                [ ( "padding", "0 2rem" )
                , ( "overflow", "scroll" )
                , ( "padding-bottom", "2rem" )
                ]
            ]
            [ case config.products of
                NotAsked ->
                    text "Waiting to be told to load."

                Loading ->
                    text "Loading, please wait."

                Failure e ->
                    text <| toString e

                Success products ->
                    div
                        [ style
                            [ ( "display", "grid" )
                            , ( "grid-template-columns", "1fr 1fr 1fr" )
                            , ( "grid-auto-rows", "min-content" )
                            , ( "grid-gap", "2rem" )
                            ]
                        ]
                        (List.map (product config) products)
            ]
        ]


productInCart : Config msg -> Product -> Html msg
productInCart config p =
    div
        [ style
            [ ( "display", "grid" )
            , ( "grid-template-columns", "100px 1fr min-content min-content" )
            , ( "grid-gap", "1rem" )
            ]
        ]
        [ img
            [ src <| url ++ p.image
            , style
                [ ( "width", "100%" )
                , ( "height", "100%" )
                , ( "border-radius", "3px" )
                ]
            ]
            []
        , strong [ style [ ( "align-self", "center" ) ] ] [ text p.displayName ]
        , span [ style [ ( "align-self", "center" ) ] ] [ text (toString p.tacos), text "\x1F32E" ]
        , Bootstrap.Button.button
            [ Bootstrap.Button.attrs
                [ style [ ( "align-self", "center" ) ]
                ]
            , onClick <| config.onRemoveFromCart p.id
            , Bootstrap.Button.danger
            ]
            [ text "Nope" ]
        ]


{-| This function will render a nice, full-page cart view of the products that are passed into it.
The second argument, the bool, represents whether or not something is currently loading (for rendering a nice loading indicator.) The third argument is a WebData of the products currently in the cart.
-}
cart : Config msg -> Html msg
cart config =
    div
        [ style
            [ ( "display", "grid" )
            , ( "grid-template-rows", "min-content min-content 1fr min-content" )
            , ( "height", "100vh" )
            , ( "color", "#616161" )
            ]
        ]
        [ theme config.loadingIndicator
        , div
            [ style
                [ ( "display", "flex" )
                , ( "align-items", "center" )
                , ( "justify-content", "center" )
                , ( "height", "75px" )
                , ( "padding", "0 2rem" )
                ]
            ]
            [ h4 [ style [ ( "flex", "1" ) ] ] [ text "Cart" ]
            , Bootstrap.Button.button
                [ Bootstrap.Button.secondary
                , Bootstrap.Button.onClick config.onClickViewProducts
                ]
                [ text "Back to Products"
                ]
            ]
        , div
            [ style
                [ ( "padding", "0 2rem" )
                , ( "overflow", "scroll" )
                ]
            ]
            [ case config.cart of
                NotAsked ->
                    text "Waiting to be told to load."

                Loading ->
                    text "Loading, please wait."

                Failure e ->
                    text <| toString e

                Success products ->
                    div
                        [ style
                            [ ( "display", "grid" )
                            , ( "grid-auto-rows", "100px" )
                            , ( "grid-gap", "2rem" )
                            , ( "overflow", "scroll" )
                            ]
                        ]
                        (List.map (productInCart config) products)
            ]
        , div
            [ style
                [ ( "display", "flex" )
                , ( "align-items", "center" )
                , ( "justify-content", "flex-end" )
                , ( "height", "75px" )
                , ( "padding", "0 2rem" )
                ]
            ]
            [ span []
                [ text "Total: "
                , case RemoteData.toMaybe config.cart of
                    Just cart ->
                        let
                            count =
                                cart
                                    |> List.map .tacos
                                    |> List.sum
                        in
                            text <| (toString count) ++ "\x1F32E"

                    Nothing ->
                        text "loading or something."
                ]
            ]
        ]


listings : Config msg -> Html msg
listings config =
    div [ class "listings" ]
        [ h1 [] [ text ("Dvls in ") ]
        , table [ class "table table-striped" ]
            [ thead []
                [ tr []
                    [ th [] [ text "Id" ]
                    , case RemoteData.toMaybe config.listings of
                                      Just listings ->
                                              tbody [] (List.map (chooseDvlButton config) listings.rows)
                                      Nothing ->
                                          text "loading."
                    ]
                ]
            ]
        ]

--Fetched from cart
kompost : Config msg -> Html msg
kompost config =
  div
        [ style
            [ ( "display", "grid" )
            , ( "grid-template-rows", "min-content min-content 1fr min-content" )
            , ( "height", "100vh" )
            , ( "color", "#616161" )
            ]
        ]
        [ theme config.loadingIndicator
        , div
            [ style
                [ ( "display", "flex" )
                , ( "align-items", "center" )
                , ( "justify-content", "center" )
                , ( "height", "75px" )
                , ( "padding", "0 2rem" )
                ]
            ]
            [ h4 [ style [ ( "flex", "1" ) ] ] [ text "Kompost:" ]
            , Bootstrap.Button.button
                [ Bootstrap.Button.secondary
                , Bootstrap.Button.onClick config.onClickViewListings
                ]
                [ text "List Komposti"
                ]
            ]
        , div
                [ style
                  [ ( "display", "flex" )
                  , ( "align-items", "center" )
                  , ( "justify-content", "flex-end" )
                  , ( "height", "75px" )
                  , ( "padding", "0 2rem" )
                  ]
                ]
                [ span []
                  [ text "Total: "
                  , case RemoteData.toMaybe config.kompost of
                      Just kompost ->
                              text <| (toString kompost) ++ "\x1F32E"

                      Nothing ->
                          text "loading or something."
                  ]
                ]
                ]




chooseDvlButton: Config msg -> Row -> Html msg
chooseDvlButton config row =  Bootstrap.Button.button
                               [ Bootstrap.Button.attrs [ style [ ( "margin-top", "auto" ) ] ]
                               , Bootstrap.Button.secondary
                               , onClick <| (config.onClickChooseDvl row.id) ]
                               [ text row.id ]
