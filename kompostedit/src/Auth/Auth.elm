module Auth.Auth exposing (init, update)

{-| The content editor client top module.

@docs init, update, subscriptions, view, Model, Msg

-}

import AWS.Auth as AWSAuth
import Auth.Msg exposing (..)
import AuthAPI
import Process
import Task
import Update3
import TheSett.Laf as Laf

-- Initialization


{-| Initializes the application state by setting it to the default Auth state
of LoggedOut.
Requests that an Auth refresh be performed to check what the current
authentication state is, as the application may be able to re-authenticate
from a refresh token held as a cookie, without needing the user to log in.
-}
init : ( AuthModel, Cmd Msg )
init =
    let
        authInitResult =
            AWSAuth.api.init
              { clientId = "6kn07ks3o2nj12chchdn69qko1"
                , region = "us-east-1"
                , userIdentityMapping =
                    Just
                        { userPoolId = "us-east-1_bVaZeRtlh"
                        , identityPoolId = "us-east-1:a1a1d225-9ce0-414a-a422-6e9fd3445843"
                        , accountId = "908262071533"
                        }
                }
    in
    case authInitResult of
        Ok authInit ->
            ( Initialized
                { laf = Laf.init
                , auth = authInit
                , session = AuthAPI.LoggedOut
                , username = ""
                , password = ""
                , passwordVerify = ""
                }
            , Process.sleep 1000 |> Task.perform (always InitialTimeout)
            )

        Err errMsg ->
            ( Error errMsg, Cmd.none )


update : Msg -> AuthModel -> ( AuthModel, Cmd Msg )
update action model =
    case model of
        Error _ ->
            ( model, Cmd.none )

        Restoring initModel ->
            updateInitialized action initModel
                |> Tuple.mapFirst Initialized

        Initialized initModel ->
            updateInitialized action initModel
                |> Tuple.mapFirst Initialized


updateInitialized : Msg -> InitializedModel -> ( InitializedModel, Cmd Msg )
updateInitialized action model =
    case Debug.log "msg" action of
        LafMsg lafMsg ->
            Laf.update LafMsg lafMsg model.laf
                |> Tuple.mapFirst (\laf -> { model | laf = laf })

        AuthMsg msg ->
            Update3.lift .auth (\x m -> { m | auth = x }) AuthMsg AWSAuth.api.update msg model
                |> Update3.evalMaybe (\status -> \nextModel -> ( { nextModel | session = status }, Cmd.none )) Cmd.none

        InitialTimeout ->
            ( model, AWSAuth.api.refresh |> Cmd.map AuthMsg )

        LogIn ->
            ( model, AWSAuth.api.login { username = model.username, password = model.password } |> Cmd.map AuthMsg )

        RespondWithNewPassword ->
            case model.password of
                "" ->
                    ( model, Cmd.none )

                newPassword ->
                    ( model, AWSAuth.api.requiredNewPassword newPassword |> Cmd.map AuthMsg )

        TryAgain ->
            ( clear model, AWSAuth.api.unauthed |> Cmd.map AuthMsg )

        LogOut ->
            ( clear model, AWSAuth.api.logout |> Cmd.map AuthMsg )

        Refresh ->
            ( model, AWSAuth.api.refresh |> Cmd.map AuthMsg )

        UpdateUsername str ->
            ( { model | username = str }, Cmd.none )

        UpdatePassword str ->
            ( { model | password = str }, Cmd.none )

        UpdatePasswordVerificiation str ->
            ( { model | passwordVerify = str }, Cmd.none )

        NavigateTo page ->
            (model, Cmd.none) --Handled in /Main.update



clear : InitializedModel -> InitializedModel
clear model =
    { model | username = "", password = "", passwordVerify = "" }

