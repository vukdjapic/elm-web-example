module Users exposing (..)

import Http
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, hardcoded, optional, required)
import Json.Encode as Jsone


type alias Model =
    { users : List User }


type Msg
    = UsersRetrieved (Result Http.Error (List User))
    | RegisterUser User


type alias Flags =
    { baseUrl : String }


type alias User =
    { id : Int
    , name : String
    , username : String
    , email : String
    , address : Address
    , phone : String
    , website : String
    , company : Company
    }


type alias Address =
    { street : String
    , suite : String
    , city : String
    , zipcode : String
    , geo : Geo
    }


type alias Company =
    { name : String
    , catchPhrase : Maybe String
    , bs : String
    }


type alias GeoPosition =
    { lat : String, lng : String }


type Geo
    = NorthEast
    | NorthWest
    | SouthEast
    | SouthWest
    | Unknown String String


userDecoder : Decoder User
userDecoder =
    decode User
        |> required "id" int
        |> required "name" string
        |> required "username" string
        |> required "email" string
        |> required "address" addressDecoder
        |> required "phone" string
        |> required "website" string
        |> required "company" companyDecoder


userEncoder : User -> Jsone.Value
userEncoder user =
    Jsone.object
        [ ( "id", Jsone.int user.id )
        , ( "name", Jsone.string user.name )
        , ( "username", Jsone.string user.username )
        , ( "email", Jsone.string user.email )
        , ( "address", addressEncoder user.address )
        , ( "phone", Jsone.string user.phone )
        , ( "website", Jsone.string user.website )
        , ( "company", companyEncoder user.company )
        ]


companyDecoder : Decoder Company
companyDecoder =
    decode Company
        |> required "name" string
        |> required "catchPhrase" (nullable string)
        |> required "bs" string


companyEncoder : Company -> Jsone.Value
companyEncoder company =
    Jsone.object
        [ ( "name", Jsone.string company.name )
        , ( "catchPhrase", nullEncoder Jsone.string company.catchPhrase )
        , ( "bs", Jsone.string company.bs )
        ]


addressDecoder : Decoder Address
addressDecoder =
    decode Address
        |> required "street" string
        |> required "suite" string
        |> required "city" string
        |> required "zipcode" string
        |> required "geo" geoDecoder


addressEncoder : Address -> Jsone.Value
addressEncoder address =
    Jsone.object
        [ ( "street", Jsone.string address.street )
        , ( "suite", Jsone.string address.suite )
        , ( "city", Jsone.string address.city )
        , ( "zipcode", Jsone.string address.zipcode )
        , ( "geo", Jsone.string <| toString address.geo )
        ]


geoDecoder : Decoder Geo
geoDecoder =
    map2 GeoPosition (field "lat" string) (field "lng" string)
        |> andThen geoPositionToGeo


geoPositionToGeo : GeoPosition -> Decoder Geo
geoPositionToGeo gp =
    let
        rlat =
            String.toFloat gp.lat

        rlng =
            String.toFloat gp.lng

        calcLong =
            \lat rlng ->
                case rlng of
                    Ok lng ->
                        if lat > 0 then
                            if lng > 0 then
                                NorthEast
                            else
                                NorthWest
                        else if lng > 0 then
                            SouthEast
                        else
                            SouthWest

                    Err _ ->
                        Unknown gp.lat gp.lng
    in
    case rlat of
        Ok lat ->
            succeed <| calcLong lat rlng

        Err _ ->
            succeed <| Unknown gp.lat gp.lng


nullEncoder : (a -> Jsone.Value) -> Maybe a -> Jsone.Value
nullEncoder encoder val =
    case val of
        Just v ->
            encoder v

        Nothing ->
            Jsone.null
