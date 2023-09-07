module Models.KompostApi exposing (createKompo, createVideo, deleteKompo, fetchHeaderParam, fetchKompositionList, getFromURL, fetchSource, updateKompo)

import Debug
import Dict
import Http exposing (Error, Header, Response   )
import MD5
import Models.BaseModel exposing (IntegrationDestination, Komposition)
import Models.JsonCoding exposing (..)
import Models.Msg exposing (Msg(..))
import RemoteData

kompoUrl:String
kompoUrl = "/kompost/"

fetchKompositionList : String -> String -> Cmd Msg
fetchKompositionList typeIdentifier token = Http.request
    { method = "POST"
    , headers = [Http.header "Authy" token ]
    , url = kompoUrl ++ "_find"
    , body = Http.stringBody "application/json" (searchEncoder typeIdentifier)
    , expect = Http.expectJson (RemoteData.fromResult >> ListingsUpdated) kompositionListDecoder
    , timeout = Nothing
    , tracker = Nothing
    }

getFromURL : IntegrationDestination -> String -> Cmd Msg
getFromURL integrationDestination apiToken = Http.request
    { method = "GET"
    , headers = [Http.header "Authy" apiToken ]
    , url = integrationDestination.urlPart ++ integrationDestination.id
    , body = Http.emptyBody
    , expect = Http.expectJson (RemoteData.fromResult >> KompositionUpdated) kompositionDecoder
    , timeout = Nothing
    , tracker = Nothing
    }


fetchSource : String -> String -> Cmd Msg
fetchSource id apiToken = Http.request
    { method = "GET"
    , headers = [Http.header "Authy" apiToken ]
    , url = kompoUrl ++ id
    , body = Http.emptyBody
    , expect = Http.expectJson (RemoteData.fromResult >> SourceUpdated) kompositionDecoder
    , timeout = Nothing
    , tracker = Nothing
    }


createKompo : Komposition -> String -> Cmd Msg
createKompo komposition apiToken = Http.request
    { method = "PUT"
    , headers = [Http.header "Authy" apiToken ]
    , url = kompoUrl ++ komposition.name
    , body = (Http.stringBody "application/json" <| kompositionEncoder komposition)
    , expect = Http.expectJson (RemoteData.fromResult >> CouchServerStatus) couchServerStatusDecoder
    , timeout = Nothing
    , tracker = Nothing
    }


createVideo : Komposition -> String -> Cmd Msg
createVideo komposition apiToken = Http.request
    { method = "POST"
    , headers = [Http.header "Authy" apiToken ]
    , url = "/kvaern/createvideo?" ++ komposition.name
    , body = Http.stringBody "application/json" <| kompositionEncoder komposition
    , expect = Http.expectJson (RemoteData.fromResult >> CouchServerStatus) couchServerStatusDecoder
    , timeout = Nothing
    , tracker = Nothing
    }


updateKompo : Komposition -> String -> Cmd Msg
updateKompo komposition apiToken = Http.request
    { method = "PUT"
    , headers = [Http.header "Authy" apiToken ]
    , url = kompoUrl ++ komposition.name
    , body = Http.stringBody "application/json" <| kompositionEncoder komposition
    , expect = Http.expectJson (RemoteData.fromResult >> CouchServerStatus) couchServerStatusDecoder
    , timeout = Nothing
    , tracker = Nothing
    }


deleteKompo : Komposition -> String -> Cmd Msg
deleteKompo komposition apiToken = Http.request
    { method = "DELETE"
    , headers = [Http.header "Authy" apiToken ]
    , url = kompoUrl ++ komposition.name ++ "?rev=" ++ komposition.revision
    , body = Http.emptyBody
    , expect = Http.expectJson (RemoteData.fromResult >> CouchServerStatus) couchServerStatusDecoder
    , timeout = Nothing
    , tracker = Nothing
    }

fetchHeaderParam:String -> String -> String -> Cmd Msg
fetchHeaderParam urlId headerName apiToken = Http.request
    { method = "GET"
    , headers = [Http.header "Authy" apiToken ]
    , url = kompoUrl ++ urlId
    , body = Http.emptyBody
    , expect = Http.expectStringResponse ETagResponse (extractHeaderResponse headerName Ok)
    , timeout = Nothing
    , tracker = Nothing
    }


extractHeaderResponse : String -> (String -> Result String a) -> Http.Response body -> Result Http.Error a
extractHeaderResponse headerName toResult response =
  case response of
    Http.BadUrl_ url -> Err (Http.BadUrl url)
    Http.Timeout_ -> Err Http.Timeout
    Http.NetworkError_ -> Err Http.NetworkError
    Http.BadStatus_ metadata _ -> Err (Http.BadStatus metadata.statusCode)
    Http.GoodStatus_ metadata body ->
        let
            header = extractSingleHeader headerName metadata.headers
            bodyval = Debug.toString body
            hex =  MD5.hex bodyval
        in Result.mapError Http.BadBody  (toResult (header ++ "," ++  hex))

extractSingleHeader: String -> Dict.Dict String String -> String
extractSingleHeader headerName headers  =
    let
        availableHeaders = Debug.toString headers
        _ = Debug.log "Printable" availableHeaders
    in case Dict.get headerName headers of
        Just header -> header
        Nothing -> Debug.log ( "Header not found: " ++ headerName)("available headers " ++ availableHeaders )

{-- Example - If needed
performGenericHttp : String -> String -> List Header -> Http.Body -> Expect Msg  -> Cmd Msg
performGenericHttp method url headers body expectation = Http.request
    { method = method
    , headers = headers
    , url = url
    , body = body
    , expect = expectation
    , timeout = Nothing
    , tracker = Nothing
    }
--}
