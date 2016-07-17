module Styles exposing (..)

import Css exposing (..)
import Html.Attributes


cellSize =
    100


markerSize =
    cellSize - 20


primaryColor =
    hex "#d3d3d3"


styles =
    asPairs >> Html.Attributes.style


cellStyles =
    styles
        [ border3 (px 1) solid primaryColor
        , fontSize (px markerSize)
        , height (px cellSize)
        , textAlign center
        , textTransform uppercase
        , width (px cellSize)
        ]
