port module Main exposing (..)

import Browser
import Html exposing (Html, div, input, text)
import Html.Attributes exposing (placeholder, value)
import Html.Events exposing (onInput)

-- PORTS
port checkPrime : String -> Cmd msg
port primeResult : (String -> msg) -> Sub msg

-- MODEL
type alias Model =
    { input : String
    , result : String
    }

init : () -> (Model, Cmd Msg)
init _ =
    ( { input = "", result = "" }
    , Cmd.none
    )

-- UPDATE
type Msg
    = InputChanged String
    | GotPrimeResult String

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        InputChanged newInput ->
            ( { model | input = newInput }
            , checkPrime newInput
            )

        GotPrimeResult result ->
            ( { model | result = result }
            , Cmd.none
            )

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions _ =
    primeResult GotPrimeResult

-- VIEW
view : Model -> Html Msg
view model =
    div []
        [ input
            [ placeholder "Enter a number"
            , value model.input
            , onInput InputChanged
            ]
            []
        , div [] [ text model.result ]
        ]

-- MAIN
main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
