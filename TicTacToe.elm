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


type Player
    = X
    | O


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
    , moves = allMoves
    , winner = Nothing
    }


board : Board
board =
    List.repeat (boardSize * boardSize) Nothing


allMoves : List Player
allMoves =
    List.repeat 5 X
        |> List.intersperse O



-- UPDATE


update msg { board, moves, winner } =
    case ( msg, moves ) of
        ( _, [] ) ->
            { board = board, moves = moves, winner = winner }

        ( MakeMove index, player :: newMoves ) ->
            let
                newBoard =
                    List.take index board
                        ++ [ Just player ]
                        ++ List.drop (index + 1) board
            in
                { board = newBoard
                , moves = newMoves
                , winner = updateWinner player newBoard
                }


updateWinner : Player -> Board -> Maybe Player
updateWinner player board =
    winnerInRows player (Utils.slice boardSize board)


winnerInRows : Player -> SlicedBoard -> Maybe Player
winnerInRows player board =
    List.map (winnerInRow player) board
        |> Maybe.oneOf


winnerInRow : Player -> List Cell -> Maybe Player
winnerInRow player row =
    case row == List.repeat boardSize (Just player) of
        True ->
            Just player

        False ->
            Nothing



-- VIEW


appView { board, winner } =
    div
        [ appStyles ]
        [ header
        , statusBar winner
        , boardView board
        ]


header =
    h1
        [ headerStyles ]
        [ text "Tic tac toe" ]


statusBar : Maybe Player -> Html Msg
statusBar winner =
    p
        []
        [ text (toString winner) ]


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
