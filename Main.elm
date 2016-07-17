module Main exposing (main)

import Html exposing (Html, div, h1, table, text, td, tr)
import Styles exposing (appStyles, cellStyles, headerStyles)


board =
    [ [ "", "", "" ]
    , [ "", "", "" ]
    , [ "", "", "" ]
    ]


main : Html msg
main =
    div
        [ appStyles ]
        [ header
        , table
            []
            (List.map boardRow board)
        ]


header =
    h1
        [ headerStyles ]
        [ text "Tic tac toe" ]


boardRow : List String -> Html msg
boardRow row =
    let
        cellView cell =
            td [ cellStyles ] [ text cell ]
    in
        tr
            []
            (List.map cellView row)
