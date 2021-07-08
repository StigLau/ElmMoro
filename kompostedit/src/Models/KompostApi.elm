module Models.KompostApi exposing (createKompo, createVideo, deleteKompo, fetchHeaderParam, fetchKompositionList, getDvlSegmentList, getKomposition, fetchSource, kompoUrl, updateKompo)

import Debug
import Dict
import Http exposing (Error, Response)
import MD5
import Models.BaseModel exposing (Komposition)
import Models.JsonCoding exposing (..)
import Models.Msg exposing (Msg(..))
import RemoteData


kompoUrl : String
kompoUrl = "/kompost/"



kvaernUrl = "/kvaern"



fetchKompositionList : String -> Cmd Msg
fetchKompositionList typeIdentifier =
    Http.post
        { url = kompoUrl ++ "_find"
        , body = Http.stringBody "application/json" (searchEncoder typeIdentifier)
        , expect = Http.expectJson (RemoteData.fromResult >> ListingsUpdated) kompositionListDecoder
        }

getKomposition : String -> Cmd Msg
getKomposition id =
     Http.get
            { url = kompoUrl ++ id
            , expect = Http.expectJson (RemoteData.fromResult >> KompositionUpdated) kompositionDecoder
            }


fetchSource : String -> Cmd Msg
fetchSource id =
    Http.get
        { url = kompoUrl ++ id
        , expect = Http.expectJson (RemoteData.fromResult >> SourceUpdated) kompositionDecoder
        }



getDvlSegmentList : String -> Cmd Msg
getDvlSegmentList id =
    let
        _ =
            Debug.log "getDvlSegmentList" (kompoUrl ++ id)
    in
    Http.get
        { url = kompoUrl ++ id
        , expect = Http.expectJson (RemoteData.fromResult >> SegmentListUpdated) kompositionDecoder
        }


createKompo : Komposition -> Cmd Msg
createKompo komposition =
     Http.post
        { url = kompoUrl
        , body = (Http.stringBody "application/json" <| kompositionEncoder komposition)
        , expect = Http.expectJson (RemoteData.fromResult >> CouchServerStatus) couchServerStatusDecoder
        }


createVideo : Komposition -> Cmd Msg
createVideo komposition =
        Http.post
                { url = kvaernUrl ++ "/createvideo?" ++ komposition.name
                , body = Http.stringBody "application/json" <| kompositionEncoder komposition
                , expect = Http.expectJson (RemoteData.fromResult >> CouchServerStatus) couchServerStatusDecoder
                }


updateKompo : Komposition -> Cmd Msg
updateKompo komposition =
   Http.request
    { method = "PUT"
    , headers = []
    , url = kompoUrl ++ komposition.name
    , body = Http.stringBody "application/json" <| kompositionEncoder komposition
    , expect = Http.expectJson (RemoteData.fromResult >> CouchServerStatus) couchServerStatusDecoder
    , timeout = Nothing
    , tracker = Nothing
    }


deleteKompo : Komposition -> Cmd Msg
deleteKompo komposition =
    Http.request
    {  method = "DELETE"
    , headers = []
    , url = kompoUrl ++ komposition.name ++ "?rev=" ++ komposition.revision
    , body = Http.emptyBody
    , expect = Http.expectJson (RemoteData.fromResult >> CouchServerStatus) couchServerStatusDecoder
    , timeout = Nothing
    , tracker = Nothing
    }

fetchHeaderParam:String -> String -> Cmd Msg
fetchHeaderParam urlId headerName =
  Http.get
    { url = kompoUrl ++ urlId
    , expect = Http.expectStringResponse ETagResponse (extractHeaderResponse headerName Ok)
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
