module Utils exposing (slice)


slice : Int -> List a -> List (List a)
slice pieces list =
    slice' pieces list []


slice' pieces list acc =
    case list of
        [] ->
            acc

        list ->
            slice' pieces (List.drop pieces list) (acc ++ [ List.take pieces list ])
