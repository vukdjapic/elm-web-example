module View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Users exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "Users" ]
        , div [] <| List.map userRow model.users
        ]


userRow : User -> Html Msg
userRow user =
    div [ class "user" ]
        [ div [ class "user__name" ] [ text user.name ]
        , p [] [ em [] [ text user.email ] ]
        , p []
            [ span [] [ text <| user.address.street ++ ", " ]
            , span [] [ text <| user.address.suite ++ ", " ]
            , span [] [ text user.address.city ]
            , span [ class "user__position" ] [ text <| toString user.address.geo ]
            ]
        , p []
            [ em [] [ text "Company " ]
            , span [] [ text user.company.name ]
            , em [] [ text " Website " ]
            , span [] [ text user.website ]
            ]
        , div [] [ button [ onClick <| RegisterUser user ] [ text "Register" ] ]
        ]
