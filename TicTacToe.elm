module TicTacToe exposing (main)

import Html exposing (Html, button, div, h1, p, table, text, td, tr)
import Html.App as Html
import Html.Events exposing (onClick)
import Styles exposing (appStyles, cellStyles, headerStyles)
import Utils


boardSize =
    3



-- TYPES


type Msg
    = MakeMove Int
    | NewGame


type Player
    = X
    | O


type GameStatus
    = InProgress (List Player)
    | Draw
    | Winner Player


type alias Cell =
    Maybe Player


type alias Board =
    List Cell


type alias SlicedBoard =
    List (List Cell)


type alias TicTacToe =
    { board : Board
    , status : GameStatus
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
    , status = InProgress allMoves
    }


board : Board
board =
    List.repeat (boardSize * boardSize) Nothing


allMoves : List Player
allMoves =
    List.repeat 5 X
        |> List.intersperse O



-- UPDATE


update msg { board, status } =
    case ( msg, status ) of
        ( MakeMove index, InProgress (player :: nextMoves) ) ->
            let
                newBoard =
                    List.take index board
                        ++ [ Just player ]
                        ++ List.drop (index + 1) board
            in
                { board = newBoard
                , status = updateStatus player nextMoves newBoard
                }

        ( NewGame, _ ) ->
            init

        ( _, _ ) ->
            { board = board, status = status }


updateStatus : Player -> List Player -> Board -> GameStatus
updateStatus currentPlayer nextMoves board =
    let
        slicedBoard =
            Utils.slice boardSize board

        winner =
            winnerInRows currentPlayer slicedBoard
                || winnerInColumns currentPlayer slicedBoard
                || winnerInDiagonals currentPlayer slicedBoard
    in
        case ( winner, nextMoves ) of
            ( True, _ ) ->
                Winner currentPlayer

            ( False, [] ) ->
                Draw

            ( False, nextMoves ) ->
                InProgress nextMoves


winnerInRows : Player -> SlicedBoard -> Bool
winnerInRows player slicedBoard =
    List.any (winnerInRow player) slicedBoard


winnerInColumns : Player -> SlicedBoard -> Bool
winnerInColumns player slicedBoard =
    Utils.transpose slicedBoard
        |> List.any (winnerInRow player)


winnerInDiagonals : Player -> SlicedBoard -> Bool
winnerInDiagonals player slicedBoard =
    case slicedBoard of
        [ [ x1, x2, x3 ], [ y1, y2, y3 ], [ z1, z2, z3 ] ] ->
            List.any (winnerInRow player) [ [ x1, y2, z3 ], [ x3, y2, z1 ] ]

        _ ->
            Debug.crash "Strange board encountered"


winnerInRow : Player -> List Cell -> Bool
winnerInRow player row =
    row == List.repeat boardSize (Just player)



-- VIEW


appView { board, status } =
    div
        [ appStyles ]
        [ header
        , statusBar status
        , boardView board
        ]


header =
    h1
        [ headerStyles ]
        [ text "Tic tac toe" ]


statusBar : GameStatus -> Html Msg
statusBar status =
    case status of
        Winner player ->
            div
                []
                [ text <| "Player '" ++ (toString player) ++ "' wins."
                , button
                    [ onClick NewGame ]
                    [ text "New Game" ]
                ]

        InProgress (nextPlayer :: _) ->
            div
                []
                [ text <| "Player '" ++ (toString nextPlayer) ++ "' turn." ]

        Draw ->
            div
                []
                [ text "Draw."
                , button
                    [ onClick NewGame ]
                    [ text "New Game" ]
                ]

        _ ->
            div
                []
                [ text "Error." ]


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
                [ text (toString marker) ]
