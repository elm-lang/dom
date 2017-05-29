-- Read more about this program in the official Elm guide:
-- https://guide.elm-lang.org/architecture/effects/random.html


module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random
import Dom
import Dom.Scroll
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
    | ScrollVerticalToBottom
    | ScrollVerticalToTop



--| Blur


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

                        ScrollVerticalToBottom ->
                            let
                                toBottom =
                                    Dom.Scroll.toBottom id
                            in
                                [ Task.attempt (\result -> NoOp result) toBottom ]

                        ScrollVerticalToTop ->
                            let
                                toTop =
                                    Dom.Scroll.toTop id
                            in
                                [ Task.attempt (\result -> NoOp result) toTop ]

                --Blur ->
                --    let
                --        blur =
                --            Dom.blur id
                --    in
                --        [ Task.attempt (\result -> NoOp result) blur ]
            in
                model ! command

        NoOp (Err error) ->
            let
                debug68 =
                    Debug.log "_" error
            in
                model ! []

        NoOp (Ok ()) ->
            let
                debug83 =
                    Debug.log "OK" "OK"
            in
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


exampleScrollVertical =
    div []
        [ h2 [] [ text "Example Scroll Vertical" ]
        , button [ DoAction ScrollVerticalToBottom "list-vertical" |> onClick ] [ text "To Bottom" ]
        , button [ DoAction ScrollVerticalToTop "list-vertical" |> onClick ] [ text "To Top" ]
        , List.range 0 100
            |> List.map (\index -> li [] [ toString index |> text ])
            |> ul [ style [ ( "max-height", "300px" ), ( "overflow", "auto" ) ], id "list-vertical" ]
        ]



--exampleBlur =
--    div []
--        [ h2 [] [ text "Example Blur" ]
--        , input [ id "example_blur" ] []
--        , button [ DoAction Blur "example_blur" |> onClick ] [ text "Get Blur" ]
--        ]


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Examples" ]
        , exampleFocus
          --, hr [] []
          --, exampleBlur
        , exampleScrollVertical
        ]
