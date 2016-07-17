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
        , update = update
        }


type Msg
    = NoOp


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model


appView : Model -> Html Msg
appView model =
    div
        [ appStyles ]
        [ header
        , statusBar "Player 1 turn"
        , boardView model
        ]


header =
    h1
        [ headerStyles ]
        [ text "Tic tac toe" ]


statusBar status =
    p
        []
        [ text status ]


boardView : Model -> Html Msg
boardView model =
    table
        []
        (List.map boardRow model)


boardRow : List String -> Html msg
boardRow row =
    let
        cellView cell =
            td [ cellStyles ] [ text cell ]
    in
        tr
            []
            (List.map cellView row)
