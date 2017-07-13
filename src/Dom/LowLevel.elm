module Dom.LowLevel exposing
  ( documentBubble
  , documentCapture
  , windowBubble
  , windowCapture
  , Handler(..)
  )

{-| This is not for general use. It backs libraries like `elm-lang/mouse` and
`elm-lang/window` which should cover your needs in most cases.

In the rare case that those packages do not seem to cover your scenario, first
bring it up with the community. Ask around and learn stuff. If folks agree that
it could be covered better, please report an issue so I know about it too! Only
get into these functions after all that.

# Event Listeners on `document`
@docs documentBubble, documentCapture

# Event Listeners on `window`
@docs windowBubble, windowCapture

# Event Handlers
@docs Handler

-}

import Elm.Kernel.Dom
import Json.Decode as Decode
import Task exposing (Task)



-- DOCUMENT


{-| Add an event handler on the `document`. The resulting task will never end,
and when you kill the process it is on, it will detach the relevant JavaScript
event listener.

**Note:** Bubble is the **default** event handling strategy when you use
`addEventListener` in JavaScript. It is almost always the one you want, but you
can read more about it [here][] to be sure!

[here]: https://www.quirksmode.org/js/events_order.html
-}

documentBubble : String -> Handler msg -> (msg -> Task Never ()) -> Task Never Never
documentBubble =
  Elm.Kernel.Dom.onDocument False


{-| Add an event handler on the `document`. The resulting task will never end,
and when you kill the process it is on, it will detach the relevant JavaScript
event listener.

**Note:** Capture is the weird event handling strategy that exists for
historical reasons. You probably want `documentBubble` instead, but you can learn
more about the differences [here][] and decide for yourself!

[here]: https://www.quirksmode.org/js/events_order.html
-}
documentCapture : String -> Handler msg -> (msg -> Task Never ()) -> Task Never Never
documentCapture =
  Elm.Kernel.Dom.onDocument True



-- WINDOW


{-| Add an event handler on `window`. The resulting task will never end, and
when you kill the process it is on, it will detach the relevant JavaScript
event listener.

**Note:** Bubble is the **default** event handling strategy when you use
`addEventListener` in JavaScript. It is almost always the one you want, but you
can read more about it [here][] to be sure!

[here]: https://www.quirksmode.org/js/events_order.html
-}
windowBubble : String -> Handler msg -> (msg -> Task Never ()) -> Task Never Never
windowBubble =
  Elm.Kernel.Dom.onWindow False


{-| Add an event handler on `window` in the capture phase. The resulting task
will never end, and when you kill the process it is on, it will detach the
relevant JavaScript event listener.

**Note:** Capture is the weird event handling strategy that exists for
historical reasons. You probably want `windowBubble` instead, but you can learn
more about the differences [here][] and decide for yourself!

[here]: https://www.quirksmode.org/js/events_order.html
-}
windowCapture : String -> Handler msg -> (msg -> Task Never ()) -> Task Never Never
windowCapture =
  Elm.Kernel.Dom.onWindow True



-- EVENT HANDLERS


{-| When creating event handlers, you can customize the event behavior a bit.
There are two ways to do this:

  - [`stopPropagation`][sp] means the event stops traveling through the DOM.
  So if propagation of a click is stopped, it will not trigger any other event
  listeners.

  - [`preventDefault`][pd] means any built-in browser behavior related to the
  event is prevented. This can be handy with key presses or touch gestures.

**Note:** A [passive][] event listener will be created if you use `Normal`
or `MayStopPropagation`. In both cases `preventDefault` cannot be used, so
we can enable optimizations for touch, scroll, and wheel events in some
browsers.

[sp]: https://developer.mozilla.org/en-US/docs/Web/API/Event/stopPropagation
[pd]: https://developer.mozilla.org/en-US/docs/Web/API/Event/preventDefault
[passive]: https://github.com/WICG/EventListenerOptions/blob/gh-pages/explainer.md
-}
type Handler msg
  = Normal (Json.Decoder msg)
  | MayStopPropagation (Json.Decoder (msg, Bool))
  | MayPreventDefault (Json.Decoder (msg, Bool))
  | Custom (Json.Decoder { message : msg, stopPropagation : Bool, preventDefault : Bool })
