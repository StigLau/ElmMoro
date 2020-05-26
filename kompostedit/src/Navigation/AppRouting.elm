module Navigation.AppRouting exposing (replaceUrl, fromUrl, fromUrlString)

import Browser.Navigation as Navigation
import Url
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s)
import Navigation.Page exposing (..)

--- Router ---



parser : Parser (Page -> a) a
parser =
    oneOf
        [ Parser.map AuthUI (s "auth")
        , Parser.map ListingsUI Parser.top
        , Parser.map KompostUI (s "kompost")
        , Parser.map KompositionJsonUI (s "kompostjson")
        , Parser.map SegmentUI (s "segment")
        , Parser.map DvlSpecificsUI (s "dvlSpecifics")
        , Parser.map MediaFileUI (s "media")
        --, Parser.map DvlSpecificsUI (s "profile" </> Username.urlParser) Not in use
        --, Parser.map NotFound (s "article" </> Slug.urlParser) Not in use
        ]

fromUrlString : String -> Page
fromUrlString yrl =
        let anUrl = case (Url.fromString yrl) of
                Just yay -> yay
                Nothing ->
                    let  _ = Debug.log "Opps: Navigation.fromUrlString " Nothing
                    in { protocol = Url.Http
                                     , host = "OOPS"
                                     , port_ = Nothing
                                     , path = "aPath"
                                     , query = Nothing
                                     , fragment = Nothing
                                     }
        in
            case fromUrl anUrl of
                   Just page -> page
                   Nothing -> NotFound


fromUrl : Url.Url -> Maybe Page
fromUrl url =
    -- The RealWorld spec treats the fragment like a path.
    -- This makes it *literally* the path, so we can proceed
    -- with parsing as if it had been a normal path all along.
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
        |> Parser.parse parser


replaceUrl : Page -> Navigation.Key -> Cmd msg
replaceUrl page navKey  =
    let
      _ = Debug.log "Approuting.replaceUrl" page
    in
        Navigation.replaceUrl navKey (routeToString page)

routeToString : Page -> String
routeToString page =
    let
        pieces =
            case page of
                AuthUI ->
                    ["auth"]
                ListingsUI ->
                    --replaceUrl navKey page
                    ["listings"] -- Main.elm#listings
                            --Route.reverse routeParsers.listings []

                KompostUI ->
                    --Route.reverse routeParsers.kompost []
                    ["Main.elm", "kompost"]

                KompositionJsonUI -> ["kompositionjson"]

                SegmentUI -> ["segment"]

                DvlSpecificsUI -> ["dvlspecifics"]

                MediaFileUI -> ["mediafile"]

                NotFound ->
                    let _ = Debug.log "routeToString dead end" NotFound
                    in []

    in
        Debug.log "routeToString " ("#/" ++ String.join "/" pieces)

