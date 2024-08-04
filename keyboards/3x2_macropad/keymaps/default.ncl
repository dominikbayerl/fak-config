let { tap, hold, td, combo, encoder, .. } = import "fak/keycode.ncl" in
let { Rainbow, .. } = import "lib/leds.ncl" in

# We alias commonly used stuff, so we don't end up repeating them over and over.
let kc = tap.reg.kc in
let me = tap.custom.media in
let XXXX = tap.none & hold.none in
let TTTT = tap.trans & hold.trans in

# "cu" for custom keys. This is just a name, so it can be whatever you want.
let cu = {
  # Again, these are just names. They don't have to be 4-letter or capitalized.
  COPY = tap.reg.mod.lctl & kc.C,
  PSTE = tap.reg.mod.lctl & kc.V,
  CUT =  tap.reg.mod.lctl & kc.X,
  CLOS = tap.reg.mod.lalt & kc.F4,
  BOOT = tap.custom.fak.BOOT,

  # Yep. Such names are possible in Nickel.
  ":P" = tap.reg.mod.lctl & tap.reg.mod.lalt & kc.DEL,

  # Screenshot
  SCSH = tap.reg.mod.lgui & tap.reg.mod.lsft & kc.S,
} in

# 1 tap = play/pause. 2 taps = next track. 3 taps = prev track.
let my_playback_tap_dance = td.make 200 [
  me.PLAY,
  me.NEXT,
  me.PREV,
  # Reminder: These can be hold-taps for more complex behavior.
  # These can even be tap dances... for nested tap dances... but uh... why though?
] in

# The following keycode is a hold-tap, since it has a tap and a hold portion
# Important: All hold-taps need to have a behavior bound with `hold.reg.behavior`

let ctrl_if_held_and_space_if_tapped = 
  tap.reg.kc.SPC
  & hold.reg.mod.lctl
  & hold.reg.behavior {
    timeout_ms = 300
    # This will resolve as a hold after 300ms regardless of other keys pressed.
    # However, if released before the 300ms is up, it will resolve as a tap.
  }
in

# Keymap definition
{
  virtual_keys = [
    # Encoder
    encoder.ccw 0,
    encoder.cw 0,

    # Combo activated by the third, fourth, and fifth physical keys
    combo.make 100 [3, 4, 5],
  ],

  layers = [
    [ # Layer 0
      cu.COPY, cu.PSTE, cu.CUT,
      me.VOLU, me.VOLD, me.MUTE & hold.reg.layer 1 & hold.reg.behavior {},
      
      # Combos start here in the same order we defined them above
      me.VOLD,
      me.VOLU,
      cu.BOOT,
    ],
    [ # Layer 1
      kc.A,    kc.B,    kc.C,
      kc.D,    kc.E,    XXXX,

      me.VOLD,
      me.VOLU,
      XXXX,
    ],
  ],

  leds = 
    let c = { red = 0xAA0000, blue = 0x0000AA, black = 0x000000, grey = 0x111111 } in 
    [
      # Layer 0
      [ c.red, c.red, c.red, c.red, c.red, c.red ] @ (Rainbow 12 1.0 0.2),
      # Layer 1
      [ c.blue, c.blue, c.blue, c.blue, c.blue, c.blue ] @ (std.array.generate (fun _ => c.grey) 12),
    ],
}
