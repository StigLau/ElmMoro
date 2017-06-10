module AppRouting exposing (..)

import Navigation exposing (Location)
import Route exposing ((:=), match)


--- Router ---


type Page
    = Home
    | Cart
    | Listings
    | Kompost
    | Segment
    | NotFound


routeParsers =
    { home = Home := Route.static "Main.elm#home"
    , cart = Cart := Route.static "Main.elm#cart"
    , listings = Listings := Route.static "Main.elm#listings"
    , kompost = Kompost := Route.static "Main.elm#kompost"
    , segment = Segment := Route.static "Main.elm#segment"
    }


router : Route.Router Page
router =
    Route.router
        [ routeParsers.home
        , routeParsers.cart
        , routeParsers.listings
        , routeParsers.kompost
        , routeParsers.segment
        ]


routeFromLocation : Location -> Page
routeFromLocation location =
    (location.pathname ++ location.hash)
        |> match router
        |> Maybe.withDefault NotFound


navigateTo : Page -> Cmd msg
navigateTo page =
    (case page of
        Home ->
            Route.reverse routeParsers.home []

        Cart ->
            Route.reverse routeParsers.cart []

        Listings ->
            Route.reverse routeParsers.listings []

        Kompost ->
            Route.reverse routeParsers.kompost []

        Segment ->
            Route.reverse routeParsers.segment []

        NotFound ->
            "/"
    )
        |> Navigation.newUrl
