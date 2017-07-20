# Mess with the DOM

This package gives you a couple ways to mess with the DOM.


## Focus

```elm
import Dom

type Msg = OpenEditor | NoOp

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
  	NoOp ->
  	  ( model, Cmd.none )

    OpenEditor ->
      ( model, focusEditor )

focusEditor : Cmd Msg
focusEditor =
  Task.attempt (\_ -> NoOp) (Dom.focus "editor")
```


## Scroll

Other times you want to be able to control how things **scroll**.
