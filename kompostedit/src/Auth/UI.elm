module Auth.UI exposing (view)

import AWS.Auth as AWSAuth
import AWS.Credentials exposing (Credentials)
import Auth.Msg exposing (AuthModel(..), InitializedModel, Msg(..))
import AuthAPI
import Html.Styled exposing (Html)
import Html.Styled exposing (div, form, styled, text, toUnstyled)
import Navigation.Page
import TheSett.Debug
import TheSett.Buttons as Buttons
import TheSett.Cards as Cards
import TheSett.Textfield as Textfield
import Css
import Css.Global
import Grid
import Html
import Html.Styled.Attributes
import Html.Styled.Events exposing (onClick, onInput)
import Responsive
import Styles exposing (md, sm)
import TheSett.Laf as Laf exposing (devices, fonts, responsiveMeta)

view : AuthModel -> Html.Html Msg
view autModel =
            toUnstyled (styledBody autModel)

initializedView : InitializedModel -> Html.Styled.Html Msg
initializedView model =
    case model.session of
        AuthAPI.LoggedOut ->
            loginView model

        AuthAPI.Failed _ ->
            notPermittedView model

        AuthAPI.LoggedIn state ->
            authenticatedView model state

        AuthAPI.Challenged AWSAuth.NewPasswordRequired ->
            requiresNewPasswordView model


styledBody : AuthModel -> Html.Styled.Html Msg
styledBody model =
    let
        innerView =
            [ responsiveMeta
            , fonts
            , Laf.style devices
            , Css.Global.global global
            , case model of
                Error errMsg ->
                    errorView errMsg

                Restoring initModel ->
                    initialView

                Initialized initModel ->
                    initializedView initModel
            ]

        debugStyle =
            Css.Global.global <|
                TheSett.Debug.global Laf.devices
    in
    div [] innerView


errorView errMsg =
    framing <|
        [ card "images/data_center-large.png"
            "Initialization Error"
            [ text ("App failed to initialize: " ++ errMsg) ]
            []
            devices
        ]

paperWhite =
    Css.rgb 248 248 248


global : List Css.Global.Snippet
global =
    [ Css.Global.each
        [ Css.Global.html ]
        [ Css.height <| Css.pct 100
        , Responsive.deviceStyle devices
            (\device ->
                let
                    headerPx =
                        Responsive.rhythm 9.5 device
                in
                Css.property "background" <|
                    "linear-gradient(rgb(120, 116, 120) 0%, "
                        ++ String.fromFloat headerPx
                        ++ "px, rgb(225, 212, 214) 0px, rgb(208, 212, 214) 100%)"
            )
        ]
    ]

initialView : Html.Styled.Html Msg
initialView =
    framing <|
        [ card "images/data_center-large.png"
            "Attempting to Restore"
            [ text "Attempting to restore authentication using a local refresh token." ]
            []
            devices
        ]


loginView : { a | laf : Laf.Model, username : String, password : String } -> Html.Styled.Html Msg
loginView model =
    framing <|
        [ card "images/data_center-large.png"
            "Log In"
            [ form []
                [ Textfield.text
                    LafMsg
                    [ 1 ]
                    model.laf
                    [ Textfield.value model.username ]
                    [ onInput UpdateUsername
                    ]
                    [ text "Username" ]
                    devices
                , Textfield.password
                    LafMsg
                    [ 2 ]
                    model.laf
                    [ Textfield.value model.password
                    ]
                    [ onInput UpdatePassword
                    ]
                    [ text "Password" ]
                    devices
                ]
            ]
            [ Buttons.button [] [ onClick LogIn ] [ text "Log In" ] devices
            ]
            devices
        ]


notPermittedView : { a | laf : Laf.Model, username : String, password : String } -> Html.Styled.Html Msg
notPermittedView model =
    framing <|
        [ card "images/data_center-large.png"
            "Not Authorized"
            [ form []
                [ Textfield.text
                    LafMsg
                    [ 1 ]
                    model.laf
                    [ Textfield.disabled
                    , Textfield.value model.username
                    ]
                    [ onInput UpdateUsername
                    ]
                    [ text "Username" ]
                    devices
                , Textfield.password
                    LafMsg
                    [ 2 ]
                    model.laf
                    [ Textfield.disabled
                    , Textfield.value model.password
                    ]
                    [ onInput UpdatePassword
                    ]
                    [ text "Password" ]
                    devices
                ]
            ]
            [ Buttons.button [] [ onClick TryAgain ] [ text "Try Again" ] devices ]
            devices
        ]

accessKey : Credentials -> String
accessKey creds = creds.accessKeyId

secretAccessKey : Credentials -> String
secretAccessKey creds = creds.secretAccessKey

sessionToken : Credentials -> String
sessionToken creds =
    case creds.sessionToken of
        Just stringy -> stringy
        Nothing -> "Nada session token"

authenticatedView : { a | username : String, auth : AWSAuth.Model } -> { b | scopes : List String, subject : String } -> Html.Styled.Html Msg
authenticatedView model user =
    let
        maybeAWSCredentials =
            AWSAuth.api.getAWSCredentials model.auth
                |> Debug.log "credentials"

        credentialsView =
            case maybeAWSCredentials of
                Just creds ->
                    let _ = Debug.log "OMFG sessionToken" (sessionToken creds)
                    in [ Html.Styled.li []
                        (text ("With AWS access accessKey " ++ accessKey creds)
                         :: text ("With AWS secretAccessKey " ++ secretAccessKey creds)
                         :: text ("With AWS sessionToken " ++ sessionToken creds)
                            :: Html.Styled.br [] []
                            :: []
                        )
                    ]

                Nothing ->
                    []
    in
    framing <|
        [ card "images/data_center-large.png"
            "Authenticated"
            [ Html.Styled.ul []
                (List.append
                    [ Html.Styled.li []
                        [ text "Logged In As:"
                        , Html.Styled.br [] []
                        , text model.username
                        ]
                    , Html.Styled.li []
                        [ text "With Id:"
                        , Html.Styled.br [] []
                        , text user.subject
                        ]
                    , Html.Styled.li []
                        (text "With Permissions:"
                            :: Html.Styled.br [] []
                            :: permissionsToChips user.scopes
                        )
                    ]
                    credentialsView
                )
            ]
            [ Buttons.button [] [ onClick (Auth.Msg.NavigateTo Navigation.Page.ListingsUI) ] [ text "Back" ] devices
            , Buttons.button [] [ onClick LogOut ] [ text "Log Out" ] devices
            , Buttons.button [] [ onClick Refresh ] [ text "Refresh" ] devices
            ]
            devices
        ]


requiresNewPasswordView : { a | laf : Laf.Model, password : String, passwordVerify : String } -> Html.Styled.Html Msg
requiresNewPasswordView model =
    framing <|
        [ card "images/data_center-large.png"
            "New Password Required"
            [ form []
                [ Textfield.password
                    LafMsg
                    [ 1 ]
                    model.laf
                    [ Textfield.value model.password ]
                    [ onInput UpdatePassword
                    ]
                    [ text "Password" ]
                    devices
                , Textfield.password
                    LafMsg
                    [ 2 ]
                    model.laf
                    [ Textfield.value model.passwordVerify
                    ]
                    [ onInput UpdatePasswordVerificiation
                    ]
                    [ text "Password Confirmation" ]
                    devices
                ]
            ]
            [ Buttons.button [] [ onClick RespondWithNewPassword ] [ text "Set Password" ] devices
            ]
            devices
        ]


framing : List (Html.Styled.Html Msg) -> Html.Styled.Html Msg
framing innerHtml =
    styled div
        [ Responsive.deviceStyle devices
            (\device -> Css.marginTop <| Responsive.rhythmPx 3 device)
        ]
        []
        [ Grid.grid
            [ sm [ Grid.columns 12 ] ]
            []
            [ Grid.row
                [ sm [ Grid.center ] ]
                []
                [ Grid.col
                    []
                    []
                    innerHtml
                ]
            ]
            devices
        ]


card :
    String
    -> String
    -> List (Html.Styled.Html Msg)
    -> List (Html.Styled.Html Msg)
    -> Responsive.ResponsiveStyle
    -> Html.Styled.Html Msg
card imageUrl title cardBody controls devices =
    Cards.card
        [ sm
            [ Styles.styles
                [ Css.maxWidth <| Css.vw 100
                , Css.minWidth <| Css.px 310
                , Css.backgroundColor <| paperWhite
                ]
            ]
        , md
            [ Styles.styles
                [ Css.maxWidth <| Css.px 420
                , Css.minWidth <| Css.px 400
                , Css.backgroundColor <| paperWhite
                ]
            ]
        ]
        []
        [ Cards.image
            [ Styles.height 6
            , sm [ Cards.src imageUrl ]
            ]
            []
            [ styled div
                [ Css.position Css.relative
                , Css.height <| Css.pct 100
                ]
                []
                []
            ]
        , Cards.title title
        , Cards.body cardBody
        , Cards.controls controls
        ]
        devices


permissionsToChips : List String -> List (Html.Styled.Html Msg)
permissionsToChips permissions =
    List.map
        (\permission ->
            Html.Styled.span [ Html.Styled.Attributes.class "mdl-chip mdl-chip__text" ]
                [ text permission ]
        )
        permissions

