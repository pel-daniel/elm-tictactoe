module Main exposing (main)

import Html exposing (Html, div, h1, p, table, text, td, tr)
import Html.App as Html
import Styles exposing (appStyles, cellStyles, headerStyles)


board =
    [ [ "", "", "" ]
    , [ "", "", "" ]
    , [ "", "", "" ]
    ]


type alias Model =
    List (List String)


main : Program Never
main =
    Html.beginnerProgram
        { model = board
        , view = appView
        , update = \_ model -> model
        }


appView : Model -> Html msg
appView model =
    div
        [ appStyles ]
        [ header
        , statusBar "Player 1 turn"
        , table
            []
            (List.map boardRow model)
        ]


header =
    h1
        [ headerStyles ]
        [ text "Tic tac toe" ]


statusBar status =
    p
        []
        [ text status ]


boardRow : List String -> Html msg
boardRow row =
    let
        cellView cell =
            td [ cellStyles ] [ text cell ]
    in
        tr
            []
            (List.map cellView row)
