module Main exposing (main)

import Html exposing (Html, div, h1, p, table, text, td, tr)
import Html.App as Html
import Html.Events exposing (onClick)
import Styles exposing (appStyles, cellStyles, headerStyles)


boardSize =
    3


board =
    List.repeat (boardSize * boardSize) ""


type alias Model =
    List String


main : Program Never
main =
    Html.beginnerProgram
        { model = board
        , view = appView
        , update = update
        }


type Msg
    = MakeMove Int


update : Msg -> Model -> Model
update msg model =
    case msg of
        MakeMove index ->
            Debug.log "MakeMove" model


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
        (List.indexedMap boardCell model)


boardCell : Int -> String -> Html Msg
boardCell index cell =
    td
        [ cellStyles, onClick (MakeMove index) ]
        [ text cell ]
