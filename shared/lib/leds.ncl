{
    WS2812B = fun p n => std.array.generate (fun x => ({
        type = 'ws2812b,
        data = {
            pin = p,
            num = x + 1,
        }
    })) n,
}
