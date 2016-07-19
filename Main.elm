module Main exposing (main)

import Html exposing (Html, div, h1, p, table, text, td, tr)
import Html.App as Html
import Html.Events exposing (onClick)
import Styles exposing (appStyles, cellStyles, headerStyles)
import Utils


boardSize =
    3


board =
    List.repeat (boardSize * boardSize) Nothing


type alias Cell =
    Maybe String


type alias Board =
    List Cell


type alias TicTacToe =
    { board : Board
    , turnNumber : Int
    }


main : Program Never
main =
    Html.beginnerProgram
        { model = init
        , view = appView
        , update = update
        }


init =
    { board = board
    , turnCount = 0
    }


type Msg
    = MakeMove Int


update msg { board, turnCount } =
    case msg of
        MakeMove index ->
            { board =
                List.take index board
                    ++ [ Just (marker turnCount) ]
                    ++ List.drop (index + 1) board
            , turnCount = turnCount + 1
            }


marker : Int -> String
marker turnCount =
    case turnCount `rem` 2 of
        0 ->
            "x"

        _ ->
            "o"


appView { board, turnCount } =
    div
        [ appStyles ]
        [ header
        , statusBar turnCount
        , boardView board
        ]


header =
    h1
        [ headerStyles ]
        [ text "Tic tac toe" ]


statusBar status =
    p
        []
        [ text (toString status) ]


boardView : Board -> Html Msg
boardView board =
    table
        []
        (List.indexedMap boardCell board
            |> Utils.slice boardSize
            |> List.map (tr [])
        )


boardCell : Int -> Cell -> Html Msg
boardCell index cell =
    case cell of
        Nothing ->
            td
                [ cellStyles, onClick (MakeMove index) ]
                [ text "" ]

        Just marker ->
            td
                [ cellStyles ]
                [ text marker ]
