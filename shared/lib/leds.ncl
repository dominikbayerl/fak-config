let util = import "fak/util_functions.ncl" in
let { BoundedInt, Uint8, Uint32, .. } = import "fak/util_types.ncl" in
let rec lib = {
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
        
    HSV_to_RGB : Array Number -> Array Number = fun arg =>
        let [ h, s, v, a ] = arg in
        if s > 0.0 then
            let h = if h == 1.0 then 0.0 else h in
            let i = std.number.truncate (h * 6.0) in
            let f = h * 6.0 - i in
    
            let w = v * (1.0 - s) in
            let q = v * (1.0 - s * f) in
            let t = v * (1.0 - s * (1.0 - f)) in

            match {
                0 => [v, t, w, a],
                1 => [q, v, w, a],
                2 => [w, v, t, a],
                3 => [w, q, v, a],
                4 => [t, w, v, a],
                _ => [v, w, q, a]
            } i
        else [v, v, v, a],
    Float_To_Uint8 : Number -> Uint8 = fun val => 
        std.number.truncate (255 * val) | Uint8,
    RGB_to_Int : Array Number -> Uint32 = fun arg => 
        let [ r, g, b, a ] = std.array.map Float_To_Uint8 arg in
        let Integer = std.number.Integer in
        (
              (util.bit.shift a 24) 
            + (util.bit.shift r 16)
            + (util.bit.shift g  8)
            + (util.bit.shift b  0)
        ) | Uint32,
    Rainbow : Number -> Number -> Number -> Array Uint32 = fun N s v =>
        std.array.generate ( fun i => let h = i/N in (HSV_to_RGB([h, s, v, 1.0]) |> RGB_to_Int)) N,
} in lib
