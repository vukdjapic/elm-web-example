port module Program exposing (..)

import Html exposing (Html)
import Http
import Json.Decode as Json
import Json.Encode as Jsone
import Users exposing (..)
import View exposing (view)


main =
    Html.programWithFlags { init = init, update = update, view = view, subscriptions = subs }


port registerUser : Jsone.Value -> Cmd msg


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model [], Http.send UsersRetrieved <| getUsers flags.baseUrl )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UsersRetrieved (Ok users) ->
            ( { model | users = users }, Cmd.none )

        UsersRetrieved (Err err) ->
            Debug.log ("Error getting users: " ++ toString err) ( model, Cmd.none )

        RegisterUser user ->
            ( model, registerUser <| userEncoder user )


subs : Model -> Sub Msg
subs model =
    Sub.none


getUsers : String -> Http.Request (List User)
getUsers baseUrl =
    Http.get (baseUrl ++ "/users") (Json.list userDecoder)
