let { DirectPinKey, OutputPin, PhysicalEncoder, .. } = import "fak/keyboard.ncl" in
let { CH552G, .. } = import "fak/mcus.ncl" in
let { WS2812B, .. } = import "lib/leds.ncl" in
{
  mcu = CH552G,
  usb_dev = {
    vendor_id = 51966,  # 0xCAFE
    product_id = 47806, # 0xBABE
    product_ver = 256,  # 0x0100
  },
  encoders = [
    PhysicalEncoder 15 14 6,
  ],
  keys =
    let D = DirectPinKey in
    [
        D 30, D 11, D 33,
        D 31, D 17, D 16
    ],
  leds = WS2812B (OutputPin 34) 18,
}
