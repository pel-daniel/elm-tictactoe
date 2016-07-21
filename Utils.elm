module Utils exposing (diagonal, inverseDiagonal, slice, transpose)


diagonal : List (List a) -> List a
diagonal =
    List.indexedMap unsafeAt


inverseAt : Int -> List a -> a
inverseAt index list =
    let
        size =
            (List.length list) - 1
    in
        unsafeAt (size - index) list


inverseDiagonal : List (List a) -> List a
inverseDiagonal =
    List.indexedMap inverseAt


slice : Int -> List a -> List (List a)
slice pieces list =
    slice' pieces list []


slice' pieces list acc =
    case list of
        [] ->
            acc

        list ->
            slice' pieces (List.drop pieces list) (acc ++ [ List.take pieces list ])


unsafeAt : Int -> List a -> a
unsafeAt index list =
    List.drop index list |> unsafeHead


unsafeHead : List a -> a
unsafeHead list =
    case list of
        head :: tail ->
            head

        _ ->
            Debug.crash "Transposing non-square matrix"


unsafeTail : List a -> List a
unsafeTail list =
    case list of
        head :: tail ->
            tail

        _ ->
            Debug.crash "Transposing non-square matrix"


{-| From http://stackoverflow.com/questions/31932683/transpose-in-elm-without-maybe
-}
transpose : List (List a) -> List (List a)
transpose matrix =
    case matrix of
        (x :: xs) :: xss ->
            (x :: List.map unsafeHead xss) :: transpose (xs :: List.map unsafeTail xss)

        _ ->
            []
