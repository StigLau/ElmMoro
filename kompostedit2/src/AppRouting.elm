module AppRouting exposing (..)

import Navigation exposing (Location)
import Route exposing ((:=), match)


--- Router ---


type Page
    = Listings
    | Kompost
    | Segment
    | MakeShitApp
    | NotFound


routeParsers =
    { listings = Listings := Route.static "Main.elm#listings"
    , kompost = Kompost := Route.static "Main.elm#kompost"
    , segment = Segment := Route.static "Main.elm#segment"
    , makeshitapp = MakeShitApp := Route.static "Main.elm#makeshitapp"
    }


router : Route.Router Page
router =
    Route.router
        [ routeParsers.listings
        , routeParsers.kompost
        , routeParsers.segment
        , routeParsers.makeshitapp
        ]


routeFromLocation : Location -> Page
routeFromLocation location =
    (location.pathname ++ location.hash)
        |> match router
        |> Maybe.withDefault NotFound


navigateTo : Page -> Cmd msg
navigateTo page =
    (case page of
        Listings ->
            Route.reverse routeParsers.listings []

        Kompost ->
            Route.reverse routeParsers.kompost []

        Segment ->
            Route.reverse routeParsers.segment []

        MakeShitApp ->
            Route.reverse routeParsers.makeshitapp []

        NotFound ->
            "/"
    )
        |> Navigation.newUrl
