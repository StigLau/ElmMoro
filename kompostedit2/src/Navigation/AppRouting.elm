module Navigation.AppRouting exposing (..)

import Navigation exposing (Location)
import Route exposing ((:=), match)


--- Router ---


type Page
    = ListingsUI
    | KompostUI
    | KompositionJsonUI
    | SegmentUI
    | DvlSpecificsUI
    | MediaFileUI
    | NotFound


routeParsers =
    { listings = ListingsUI := Route.static "Main.elm#listings"
    , kompost = KompostUI := Route.static "Main.elm#kompost"
    , kompositionJson = KompositionJsonUI := Route.static "Main.elm#kompostjson"
    , segment = SegmentUI := Route.static "Main.elm#segment"
    , dvlSpecificsUI = DvlSpecificsUI := Route.static "Main.elm#dvlSpecificsUI"
    , mediaFileUI = MediaFileUI := Route.static "Main.elm#mediaFileUI"
    }


router : Route.Router Page
router =
    Route.router
        [ routeParsers.listings
        , routeParsers.kompost
        , routeParsers.kompositionJson
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
        ListingsUI ->
            Route.reverse routeParsers.listings []

        KompostUI ->
            Route.reverse routeParsers.kompost []

        KompositionJsonUI ->
            Route.reverse routeParsers.kompositionJson []

        SegmentUI ->
            Route.reverse routeParsers.segment []

        DvlSpecificsUI ->
            Route.reverse routeParsers.dvlSpecificsUI []

        MediaFileUI ->
            Route.reverse routeParsers.mediaFileUI []

        NotFound ->
            "/"
    )
        |> Navigation.newUrl
