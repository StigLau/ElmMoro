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
    , currentKomposition : Maybe String
    , currentSegment : Maybe String
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
                (listingModel, cmd, childMsg) = Listing.update msg model.listing
                --_ = Debug.log "WTF? " (Kompost.update (Kompost.NewOrUpdate))
            in
                ({model | listing = listingModel, currentKomposition = Listing.extractFromOutmessage childMsg }, Cmd.map ListingMsg cmd)

init : ( Model, Cmd Msg )
init =
    let
        ( segment, segmentCmd ) = Segment.init
        ( kompo, kompoCmd ) = Kompost.init
        ( listing, listingCmd ) = Listing.init
    in
        ( Model segment kompo listing Nothing Nothing
        , Cmd.batch [
            Cmd.map SegmentMsg segmentCmd
            , Cmd.map KompostMsg kompoCmd
            , Cmd.map ListingMsg listingCmd
            ] )

view : Model -> Html Msg
view model =
    div [ ]
        [ h1 [] [ text "Multiview" ]
        , text ("Komposition selection by Main: " ++ toString model.currentKomposition)
        , Html.map ListingMsg (Listing.view model.listing)
        , case model.currentKomposition of
            Just _ ->
                Html.map KompostMsg (Kompost.view model.kompo)
            Nothing ->
                h2 [] [text "No komposition to show" ]
        , case model.currentSegment of
            Just _ ->
                Html.map SegmentMsg (Segment.view model.segment)
            Nothing ->
                h2 [] [text "No Segment to show" ]
        , h2 [] [text "Main model" ]
        , text (toString model)
        ]


subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

main : Program Never Model Msg
main = program { init = init, update = update, view = view, subscriptions = subscriptions}
