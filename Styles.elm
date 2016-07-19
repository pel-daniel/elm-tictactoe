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


appStyles =
    styles
        [ margin2 (px 0) auto
        , width (px 320)
        ]


buttonStyles =
    styles
        [ backgroundColor primaryColor
        , fontSize (px 15)
        , marginLeft (px 15)
        , padding (px 5)
        ]


cellStyles =
    styles
        [ border3 (px 1) solid primaryColor
        , fontSize (px markerSize)
        , height (px cellSize)
        , textAlign center
        , textTransform uppercase
        , width (px cellSize)
        ]


headerStyles =
    styles
        [ textAlign center ]


statusBarStyles =
    styles
        [ lineHeight (px 40) ]
