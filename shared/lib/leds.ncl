{
    WS2812B = fun p n => std.array.generate (fun x => ({
        type = 'ws2812b,
        data = {
            pin = p,
            num = x + 1,
        }
    })) n,
    HexValue = fun label value =>
        value
        |> std.string.lowercase
        |> std.string.characters
        |> std.array.reverse
        |> std.array.map_with_index (fun i x => (std.number.pow 16 i) * 
            match {
                "0" =>  0,
                "1" =>  1,
                "2" =>  2,
                "3" =>  3,
                "4" =>  4,
                "5" =>  5,
                "6" =>  6,
                "7" =>  7,
                "8" =>  8,
                "9" =>  9,
                "a" => 10,
                "b" => 11,
                "c" => 12,
                "d" => 13,
                "e" => 14,
                "f" => 15,
                _   => let msg = "invalid hex value" in std.contract.blame_with_message msg label,
            } x
        )
        |> std.array.fold_left (+) 0,
}
