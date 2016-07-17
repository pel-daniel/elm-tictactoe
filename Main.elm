module Main exposing (main)

import Html exposing (Html, table, text, td, tr)
import Styles exposing (cellStyles)


board =
    [ [ "", "", "" ]
    , [ "", "", "" ]
    , [ "", "", "" ]
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
            td [ cellStyles ] [ text cell ]
    in
        tr
            []
            (List.map cellView row)
