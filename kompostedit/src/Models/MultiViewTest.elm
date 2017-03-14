module Models.MultiViewTest exposing (..)

import Html exposing (..)
import Models.Segment as Segment
import Models.KompostModels as KompostModels
import Models.Kompost as Kompost
import Models.Listings as Listing

type alias Model = {
    segment : Segment.Model
    , kompo : KompostModels.Model
    , listing : Listing.Model
    }

type Msg
    = SegmentMsg Segment.Msg
    | KompostMsg Kompost.Msg
    | ListingMsg Listing.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SegmentMsg msg ->
            let
                ( segment, cmd ) = Segment.update msg model.segment
            in
                ( { model | segment = segment }, Cmd.map SegmentMsg cmd )

        KompostMsg msg ->
            let
                (kompModel, cmd) = Kompost.update msg model.kompo
            in
                ({model | kompo = kompModel}, Cmd.map KompostMsg cmd)

        ListingMsg msg ->
            let
                (listingModel, cmd) = Listing.update msg model.listing
            in
                ({model | listing = listingModel }, Cmd.map ListingMsg cmd)

init : ( Model, Cmd Msg )
init =
    let
        ( segment, segmentCmd ) = Segment.init
        ( kompo, kompoCmd ) = Kompost.init
        ( listing, listingCmd ) = Listing.init
    in
        ( Model segment kompo listing, Cmd.batch [
            Cmd.map SegmentMsg segmentCmd,
            Cmd.map KompostMsg kompoCmd,
            Cmd.map ListingMsg listingCmd ] )

view : Model -> Html Msg
view model =
    div [ ]
        [ h1 [] [ text "Multiview" ]
        , text "Multiview Model: "
        , text (toString model)
        , Html.map SegmentMsg (Segment.view model.segment)
        , Html.map KompostMsg (Kompost.view model.kompo)
        , Html.map ListingMsg (Listing.view model.listing)
        ]


subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

main : Program Never Model Msg
main = program { init = init, update = update, view = view, subscriptions = subscriptions}
