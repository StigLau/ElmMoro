module Auth.Msg exposing (..)
import Navigation.Page as Navigation
import TheSett.Laf as Laf
import AWS.Auth as AWS
import AuthAPI


{-| The content editor program top-level message types.
-}
type Msg
    = LafMsg Laf.Msg
    | AuthMsg AWS.Msg
    | InitialTimeout
    | LogIn
    | LogOut
    | NavigateTo Navigation.Page
    | RespondWithNewPassword
    | TryAgain
    | Refresh
    | UpdateUsername String
    | UpdatePassword String
    | UpdatePasswordVerificiation String

type alias InitializedModel =
    { laf : Laf.Model
    , auth : AWS.Model
    , session : AuthAPI.Status AWS.AuthExtensions AWS.Challenge
    , username : String
    , password : String
    , passwordVerify : String
    }

type AuthModel
    = Error String
    | Restoring InitializedModel
    | Initialized InitializedModel
