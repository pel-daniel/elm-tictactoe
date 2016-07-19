module TicTacToe exposing (main)

import Html exposing (Html, div, h1, p, table, text, td, tr)
import Html.App as Html
import Html.Events exposing (onClick)
import Styles exposing (appStyles, cellStyles, headerStyles)
import Utils


boardSize =
    3



-- TYPES


type Msg
    = MakeMove Int


type alias Player =
    String


type alias Cell =
    Maybe Player


type alias Board =
    List Cell


type alias SlicedBoard =
    List (List Cell)


type alias TicTacToe =
    { board : Board
    , turnNumber : Int
    , winner : Maybe Player
    }


main : Program Never
main =
    Html.beginnerProgram
        { model = init
        , view = appView
        , update = update
        }



-- INIT


init =
    { board = board
    , turnCount = 0
    , winner = Nothing
    }


board =
    List.repeat (boardSize * boardSize) Nothing



-- UPDATE


update msg { board, turnCount, winner } =
    case msg of
        MakeMove index ->
            let
                newBoard =
                    List.take index board
                        ++ [ Just (marker turnCount) ]
                        ++ List.drop (index + 1) board
            in
                { board = newBoard
                , turnCount = turnCount + 1
                , winner = updateWinner newBoard
                }


marker : Int -> String
marker turnCount =
    case turnCount `rem` 2 of
        0 ->
            "x"

        _ ->
            "o"


updateWinner : Board -> Maybe Player
updateWinner board =
    winnerInRows (Utils.slice boardSize board)


winnerInRows : SlicedBoard -> Maybe Player
winnerInRows board =
    List.map (winnerInRow "x") board
        |> Maybe.oneOf


winnerInRow : Player -> List Cell -> Maybe Player
winnerInRow marker row =
    case row == List.repeat boardSize (Just marker) of
        True ->
            Just marker

        False ->
            Nothing



-- VIEW


appView { board, turnCount, winner } =
    div
        [ appStyles ]
        [ header
        , statusBar turnCount winner
        , boardView board
        ]


header =
    h1
        [ headerStyles ]
        [ text "Tic tac toe" ]


statusBar : Int -> Maybe Player -> Html Msg
statusBar turnCount winner =
    p
        []
        [ text (toString turnCount ++ " " ++ (toString winner)) ]


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
