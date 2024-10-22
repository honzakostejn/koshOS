return {
  keys = {
    -- Emulate other programs (Zed, VSCode, ...)
    { key = 'P', mods = 'CMD|SHIFT', action = wezterm.action.ActivateCommandPalette },

    -- paste from the clipboard
    { key = 'v', mods = 'CTRL', action = wezterm.action.PasteFrom 'Clipboard' },

    -- paste from the primary selection
    { key = 'v', mods = 'CTRL', action = wezterm.action.PasteFrom 'PrimarySelection' },

    -- copy
    { key = 'c', mods = 'CTRL', action = wezterm.action.CopyTo 'ClipboardAndPrimarySelection' },
  },
  
  -- Workaround for https://github.com/NixOS/nixpkgs/issues/336069#issuecomment-2299008280
  -- Remove later.
  front_end = "WebGpu",

  enable_wayland = false,
  -- use_ime = true
}