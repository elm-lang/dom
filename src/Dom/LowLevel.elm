module Dom.LowLevel exposing
  ( onDocument
  , onWindow
  , onDocumentWithOptions
  , onWindowWithOptions
  , Options
  , defaultOptions
  )

{-| This is not for general use. It backs libraries like `elm-lang/mouse` and
`elm-lang/window` which should cover your needs in most cases. In the rare
case that those packages do not seem to cover your scenario, first bring it up
with the community. Ask around and learn stuff first! Only get into these
functions after that.

# Global Event Listeners
@docs onDocument, onWindow, onDocumentWithOptions, onWindowWithOptions, Options, defaultOptions
-}

import Json.Decode as Json
import Native.Dom
import Task exposing (Task)


{-| Add an event handler on the `document`. The resulting task will never end,
and when you kill the process it is on, it will detach the relevant JavaScript
event listener.
-}
onDocument : String -> Json.Decoder msg -> (msg -> Task Never ()) -> Task Never Never
onDocument event =
  Native.Dom.onDocument event defaultOptions


{-| Add an event handler on `window`. The resulting task will never end, and
when you kill the process it is on, it will detach the relevant JavaScript
event listener.
-}
onWindow : String -> Json.Decoder msg -> (msg -> Task Never ()) -> Task Never Never
onWindow event =
  Native.Dom.onWindow event defaultOptions


{-| Same as `onDocument` but you can set a few options.
-}
onDocumentWithOptions : String -> Options -> Json.Decoder msg -> (msg -> Task Never ()) -> Task Never Never
onDocumentWithOptions =
  Native.Dom.onDocument


{-| Same as `onWindow` but you can set a few options.
-}
onWindowWithOptions : String -> Options -> Json.Decoder msg -> (msg -> Task Never ()) -> Task Never Never
onWindowWithOptions =
  Native.Dom.onWindow


{-| Options for an event listener. If `stopPropagation` is true, it means the event
stops traveling through the DOM so it will not trigger any other event listeners. If
`preventDefault` is true, any built-in browser behavior related to the event is
prevented. For example, this is used with touch events when you want to treat them
as gestures of your own, not as scrolls.
-}
type alias Options =
  { stopPropagation : Bool
  , preventDefault : Bool
  }


{-| Everything is `False` by default.

    defaultOptions =
        { stopPropagation = False
        , preventDefault = False
        }
-}
defaultOptions : Options
defaultOptions =
  { stopPropagation = False
  , preventDefault = False
  }
