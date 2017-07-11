module Navigation.AppRouting exposing (..)

import Navigation exposing (Location)
import Route exposing ((:=), match)


--- Router ---


type Page
    = Listings
    | Kompost
    | Segment
    | DvlSpecificsUI
    | MediaFileUI
    | NotFound


routeParsers =
    { listings = Listings := Route.static "Main.elm#listings"
    , kompost = Kompost := Route.static "Main.elm#kompost"
    , segment = Segment := Route.static "Main.elm#segment"
    , dvlSpecificsUI = DvlSpecificsUI := Route.static "Main.elm#dvlSpecificsUI"
    , mediaFileUI = MediaFileUI := Route.static "Main.elm#mediaFileUI"
    }


router : Route.Router Page
router =
    Route.router
        [ routeParsers.listings
        , routeParsers.kompost
        , routeParsers.segment
        , routeParsers.dvlSpecificsUI
        , routeParsers.mediaFileUI
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

        DvlSpecificsUI ->
            Route.reverse routeParsers.dvlSpecificsUI []

        MediaFileUI ->
            Route.reverse routeParsers.mediaFileUI []

        NotFound ->
            "/"
    )
        |> Navigation.newUrl
