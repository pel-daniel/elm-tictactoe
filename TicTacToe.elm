module TicTacToe exposing (main)

import Html exposing (Html, button, div, h1, p, table, text, td, tr)
import Html.App as Html
import Html.Events exposing (onClick)
import Styles
    exposing
        ( appStyles
        , buttonStyles
        , cellStyles
        , headerStyles
        , statusBarStyles
        )
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


init : TicTacToe
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


update : Msg -> TicTacToe -> TicTacToe
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
    List.any
        (winnerInRow player)
        [ Utils.diagonal slicedBoard, Utils.inverseDiagonal slicedBoard ]


winnerInRow : Player -> List Cell -> Bool
winnerInRow player row =
    row == List.repeat boardSize (Just player)



-- VIEW


appView : TicTacToe -> Html Msg
appView { board, status } =
    div
        [ appStyles ]
        [ header
        , statusBar status
        , boardView board
        ]


header : Html Msg
header =
    h1
        [ headerStyles ]
        [ text "Tic tac toe" ]


statusBar : GameStatus -> Html Msg
statusBar status =
    div
        [ statusBarStyles ]
        (statusBarMessage status)


statusBarMessage : GameStatus -> List (Html Msg)
statusBarMessage status =
    case status of
        Winner player ->
            [ text <| "Player '" ++ (toString player) ++ "' wins."
            , button
                [ onClick NewGame, buttonStyles ]
                [ text "New Game" ]
            ]

        InProgress (nextPlayer :: _) ->
            [ text <| "Player '" ++ (toString nextPlayer) ++ "' turn." ]

        Draw ->
            [ text "Draw."
            , button
                [ onClick NewGame, buttonStyles ]
                [ text "New Game" ]
            ]

        _ ->
            Debug.crash "No more moves for InProgress game"


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
