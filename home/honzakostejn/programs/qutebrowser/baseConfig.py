def load(config, c):
  config.load_autoconfig(False)

  c.auto_save.session = True
  c.scrolling.smooth = True

  c.tabs.last_close = "startpage"
  c.tabs.position = "left"
  c.tabs.show = "switching"

  # c.statusbar.show = "in-mode" # hides statusbar - handy for screenshots

  c.url.default_page = "about:blank"
  c.url.start_pages = ["about:blank"]

  c.content.blocking.method = "both"
  # don't forget to run :adblock-update on the first run

  c.window.hide_decoration = True

  c.colors.webpage.preferred_color_scheme = "dark"

  c.content.pdfjs = True
  c.downloads.location.directory = "~/Downloads"

  c.fonts.default_size = "12pt"

  c.spellcheck.languages = [ 'en-US', 'cs-CZ' ]

  c.bindings.commands['caret'] = {
    # vim-like bindings were moved to home-row
    'j': 'move-to-prev-char',
    'k': 'move-to-next-line',
    'l': 'move-to-prev-line',
    ';': 'move-to-next-char',

    'J': 'scroll left',
    'K': 'scroll down',
    'L': 'scroll up',
    ':': 'scroll right',
  }

  c.bindings.commands['normal'] = {
    # vim-like bindings were moved to home-row
    'j': 'scroll left',
    'k': 'scroll down',
    'l': 'scroll up',
    ';': 'scroll right',

    'J': 'back',
    'K': 'tab-next',
    'L': 'tab-prev',
    ':': 'forward',
    
    # ':' was used to enter command mode,
    # command mode is now entered with 'h'
    'h': 'cmd-set-text :',

    'gK': 'tab-move +',
    'gL': 'tab-move -',

    '<Ctrl-r>': 'spawn --userscript take-screenshot',
    '<Ctrl-p>': 'spawn --userscript qute-bitwarden',
    '<Ctrl-Shift-p>u': 'spawn --userscript qute-bitwarden --username-only',
    '<Ctrl-Shift-p>p': 'spawn --userscript qute-bitwarden --password-only',
  }
