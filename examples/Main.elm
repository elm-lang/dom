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
    { verticalPos : String }


init : ( Model, Cmd Msg )
init =
    ( Model "", Cmd.none )



-- UPDATE


type Msg
    = DoAction Example String
    | NoOp (Result Dom.Error ())
    | NoOpFloat Scroll (Result Dom.Error Float)


type Example
    = Focus
    | ScrollVerticalToBottom
    | ScrollVerticalToTop
    | ScrollVerticalToY
    | ScrollVerticalY
    | ScrollToRight
    | ScrollToLeft


type Scroll
    = Vertical


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

                        ScrollVerticalToY ->
                            let
                                toY =
                                    Dom.Scroll.toY id 150
                            in
                                [ Task.attempt (\result -> NoOp result) toY ]

                        ScrollVerticalY ->
                            let
                                y =
                                    Dom.Scroll.y id
                            in
                                [ Task.attempt (\result -> NoOpFloat Vertical result) y ]

                        ScrollToRight ->
                            let
                                toRight =
                                    Dom.Scroll.toRight id
                            in
                                [ Task.attempt (\result -> NoOp result) toRight ]

                        ScrollToLeft ->
                            let
                                toLeft =
                                    Dom.Scroll.toLeft id
                            in
                                [ Task.attempt (\result -> NoOp result) toLeft ]
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

        NoOpFloat scroll (Err error) ->
            let
                debug68 =
                    Debug.log "_" error
            in
                model ! []

        NoOpFloat scroll (Ok float) ->
            let
                debug83 =
                    Debug.log "OK" "OK"

                position =
                    "Position " ++ (toString float)

                new_model =
                    case scroll of
                        Vertical ->
                            { model | verticalPos = position }
            in
                new_model ! []



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


exampleScrollVertical : Model -> Html Msg
exampleScrollVertical model =
    div []
        [ h2 [] [ text "Example Scroll Vertical" ]
        , button [ DoAction ScrollVerticalToBottom "list-vertical" |> onClick ] [ text "To Bottom" ]
        , button [ DoAction ScrollVerticalToTop "list-vertical" |> onClick ] [ text "To Top" ]
        , button [ DoAction ScrollVerticalToY "list-vertical" |> onClick ] [ text "To Y (150px)" ]
        , button [ DoAction ScrollVerticalY "list-vertical" |> onClick ] [ text "Show Y Pos" ]
        , text model.verticalPos
        , List.range 0 100
            |> List.map (\index -> li [] [ toString index |> text ])
            |> ul [ style [ ( "max-height", "300px" ), ( "overflow", "auto" ) ], id "list-vertical" ]
        ]


exampleScrollHorizontal : Model -> Html Msg
exampleScrollHorizontal model =
    div []
        [ h2 []
            [ text "Example Scroll Horizontal" ]
        , button [ DoAction ScrollToRight "table-horizontal" |> onClick ] [ text "To Right" ]
        , button [ DoAction ScrollToLeft "table-horizontal" |> onClick ] [ text "To Left" ]
        , div [ style [ ( "max-width", "80%" ), ( "overflow", "auto" ) ], id "table-horizontal" ]
            [ table []
                [ List.range 0 200
                    |> List.map (\index -> td [] [ toString index |> text ])
                    |> tr []
                ]
            ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Examples" ]
        , exampleFocus
        , exampleScrollVertical model
        , exampleScrollHorizontal model
        ]
