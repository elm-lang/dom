-- Read more about this program in the official Elm guide:
-- https://guide.elm-lang.org/architecture/effects/random.html


module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random
import Dom
import Task


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    {}


init : ( Model, Cmd Msg )
init =
    ( Model, Cmd.none )



-- UPDATE


type Msg
    = DoAction Example String
    | NoOp (Result Dom.Error ())


type Example
    = Focus


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DoAction example id ->
            let
                command =
                    case example of
                        Focus ->
                            let
                                focus =
                                    Dom.focus id
                            in
                                [ Task.attempt (\result -> NoOp result) focus ]
            in
                model ! command

        NoOp (Err error) ->
            let
                debug68 =
                    Debug.log "_" error
            in
                model ! []

        NoOp (Ok ()) ->
            model ! []



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


exampleFocus =
    div []
        [ h2 [] [ text "Example Focus" ]
        , input [ id "example_focus" ] []
        , button [ DoAction Focus "example_focus" |> onClick ] [ text "Get Focus" ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Examples" ]
        , exampleFocus
        ]
