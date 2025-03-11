port module Main exposing (..)

import Browser
import Html exposing (Html, div, input, text)
import Html.Attributes exposing (placeholder, value)
import Html.Events exposing (onInput)
import Time

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
    | Tick Time.Posix

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

        Tick _ ->
            ( model
            , checkPrime model.input
            )

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ primeResult GotPrimeResult
        , Time.every 100 Tick  -- 100 milliseconds = 0.1 seconds
        ]

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
