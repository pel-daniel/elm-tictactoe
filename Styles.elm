module Styles exposing (..)

import Css exposing (..)
import Html.Attributes


cellSize =
    100


markerSize =
    cellSize - 20


styles =
    asPairs >> Html.Attributes.style


cellStyles =
    styles
        [ border2 (px 1) solid
        , fontSize (px markerSize)
        , height (px cellSize)
        , textAlign center
        , textTransform uppercase
        , width (px cellSize)
        ]
