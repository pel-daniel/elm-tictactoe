module Main exposing (main)

import Html exposing (Html, table, text, td, tr)


board =
    [ [ "x", "o", "x" ]
    , [ "o", "x", "o" ]
    , [ "x", "o", "x" ]
    ]


main : Html msg
main =
    table
        []
        (List.map boardRow board)


boardRow : List String -> Html msg
boardRow row =
    let
        cellView cell =
            td [] [ text cell ]
    in
        tr
            []
            (List.map cellView row)
