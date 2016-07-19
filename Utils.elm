module Utils exposing (slice, transpose)


slice : Int -> List a -> List (List a)
slice pieces list =
    slice' pieces list []


slice' pieces list acc =
    case list of
        [] ->
            acc

        list ->
            slice' pieces (List.drop pieces list) (acc ++ [ List.take pieces list ])


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
