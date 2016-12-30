module DualApproach.Slide exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, classList, style, type_, id, value, draggable, placeholder, disabled, attribute, src)
import Html.Events exposing (onClick, onInput, on)
import Json.Decode.Extra exposing ((|:))
import Json.Decode exposing (Decoder, succeed, string, bool, field)
import Http
import Json.Encode as Encode exposing (Value, encode)
import DualApproach.Events as Events exposing (onClickStopPropagation)
-- import Ports exposing (FileData, fileSelected, fileUploadSucceeded, fileUploadFailed)


type alias Model =
    { id : String
    , title : String
    , body : String
    , visible : Bool
    , index : String
    , type_ : String
    }


initModel : Model
initModel =
    Model "" "" "" False "" ""


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.none )


type Msg
    = EditResponse (Result Http.Error Model)
    | CreateResponse (Result Http.Error Model)
    | DeleteResponse (Result Http.Error String)
    | Delete
    | Edit
    | Title String
    | Body String
    | Index String
    | TextSlide
    | MediaSlide


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Edit ->
            ( model, edit model EditResponse )

        EditResponse _ ->
            ( model, Cmd.none )

        CreateResponse _ ->
            ( model, Cmd.none )

        Delete ->
            ( model, delete model )

        DeleteResponse _ ->
            ( model, Cmd.none )

        Title newTitle ->
            ( { model | title = newTitle }, Cmd.none )

        Body newBody ->
            ( { model | body = newBody }, Cmd.none )

        Index newIndex ->
            ( { model | index = newIndex }, Cmd.none )

        TextSlide ->
            ( { model | type_ = "text" }, Cmd.none )

        MediaSlide ->
            ( { model | type_ = "media" }, Cmd.none )



decoder : Decoder Model
decoder =
    succeed Model
        |: field "_id" string
        |: field "title" string
        |: field "body" string
        |: field "visible" bool
        |: field "index" string
        |: field "type" string


encodeSlide : Model -> Value
encodeSlide model =
    Encode.object <|
        List.append
            (if model.id == "" then
                []
             else
                [ ( "_id", Encode.string model.id ) ]
            )
            [ ( "title", Encode.string model.title )
            , ( "body", Encode.string model.body )
            , ( "visible", Encode.bool model.visible )
            , ( "index", Encode.string model.index )
            , ( "type", Encode.string model.type_ )
            ]


edit : Model -> (Result.Result Http.Error Model -> msg) -> Cmd msg
edit model msg =
    let
        s =
            Debug.log "edit" <| encodeSlide model
    in
        Http.send msg <|
            Http.request
                { method = "PUT"
                , headers = []
                , url = "/slides/" ++ model.id
                , body = Http.jsonBody <| encodeSlide model
                , expect = Http.expectJson decoder
                , timeout = Nothing
                , withCredentials = False
                }


create : Model -> (Result.Result Http.Error Model -> msg) -> Cmd msg
create model msg =
    Http.send msg <|
        Http.request
            { method = "POST"
            , headers = []
            , url = "/slides"
            , body = Http.jsonBody <| encodeSlide model
            , expect = Http.expectJson decoder
            , timeout = Nothing
            , withCredentials = False
            }


createOrEditSlide : Model -> (Result.Result Http.Error Model -> msg) -> Cmd msg
createOrEditSlide model msg =
    if model.id == "" then
        create model msg
    else
        edit model msg


delete : Model -> Cmd Msg
delete model =
    Http.send DeleteResponse <|
        Http.request
            { method = "DELETE"
            , headers = []
            , url = "/slides/" ++ model.id
            , body = Http.emptyBody
            , expect = Http.expectString
            , timeout = Nothing
            , withCredentials = False
            }


subscriptions : Model -> Sub Msg
subscriptions model = Sub.none


icon : String -> Html msg
icon c =
    i [ class <| "icon-" ++ c ] []


view : Model -> Html Msg
view model =
    case model.type_ of
        "text" ->
            viewText model

        "image" ->
            viewImage model

        _ ->
            viewVideo model




editButton : Model -> Html Msg
editButton model =
    button [ class "slide__edit", onClickStopPropagation Edit ] [ icon "pencil" ]


slideIndex : Model -> Html Msg
slideIndex model =
    div [ class "slide__index" ] [ text model.index ]


viewText : Model -> Html Msg
viewText model =
    li
        [ class "slide"
        ]
        [ div
            [ classList
                [ ( "slide__content", True )
                , ( "slide__content--visible", model.visible )
                ]
            ]
            [ div [ class "slide__title" ] [ text model.title ]
            , div [ class "slide__body" ] [ text model.body ]
            ]
            , slideIndex model
        ]


viewImage : Model -> Html Msg
viewImage model =
    li
        [ class "slide slide--image"
        ]
        [ div
            [ classList
                [ ( "slide__content slide__content--image", True )
                , ( "slide__content--visible", model.visible )
                ]
            , style [ ( "background-image", "url(" ++ model.body ++ ")" ) ]
            ]
            []
            , slideIndex model
        ]


viewVideo : Model -> Html Msg
viewVideo model =
    li
        [ class "slide slide--video"
        ]
        [ div
            [ classList
                [ ( "slide__content slide__content--video", True )
                , ( "slide__content--visible", model.visible )
                ]
            ]
            [ video
                [ src model.body
                , attribute "autoplay" "true"
                , attribute "loop" "true"
                , class "slide__video"
                ]
                []
            ]
            , slideIndex model
        ]


editView : Model -> Html Msg
editView model =
    if model.type_ == "text" then
        editTextView model
    else
        editMediaView model


editMediaView : Model -> Html Msg
editMediaView model =
    div []
        [ div [ class "tabs" ]
            [ button
                [ class "tabs__tab tabs__tab--active"
                , disabled True
                ]
                [ text "Media" ]
            ]
        , div [ class "modal__slide" ]
            [ input
                [ type_ "text"
                , class "input modal__index"
                , onInput Index
                , value model.index
                , placeholder "Index"
                ]
                []

            ]
        ]


editTextView : Model -> Html Msg
editTextView model =
    div []
        [ div [ class "tabs" ]
            [ button
                [ ]
                [ text "Text" ]
            ]
        , div [ class "modal__slide" ]
            [ input
                [ type_ "text"
                , class "input modal__index"
                , onInput Index
                , value model.index
                , placeholder "Index"
                ]
                []
            , input
                [ type_ "text"
                , class "input modal__title"
                , onInput Title
                , value model.title
                , placeholder "Title"
                ]
                []
            , textarea
                [ onInput Body
                , class "input modal__body"
                , value model.body
                , placeholder "Body"
                ]
                []
            ]
        ]
