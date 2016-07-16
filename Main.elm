module Main exposing (main)

import Html exposing (Html, table, text, td, tr)


board =
    [ [ "x", "o", "x" ]
    , [ "o", "x", "o" ]
    , [ "x", "o", "x" ]
    ]


main =
    table
        []
        (List.map boardRow board)


boardRow : List String -> Html a
boardRow row =
    tr
        []
        (List.map (\cell -> td [] [ text cell ]) row)
