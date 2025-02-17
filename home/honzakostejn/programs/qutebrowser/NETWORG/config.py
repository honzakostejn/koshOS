config.load_autoconfig(False)

c.auto_save.session = True
c.scrolling.smooth = True

c.tabs.last_close = "startpage"
c.tabs.position = "left"
c.tabs.show = "switching"

c.url.default_page = "about:blank"
c.url.start_pages = ["about:blank"]

c.content.blocking.method = "both"
# don't forget to run :adblock-update on the first run

c.window.hide_decoration = True
c.colors.webpage.preferred_color_scheme = "dark"
import theme
theme.setup(c, 'latte')

c.content.pdfjs = True
c.downloads.location.directory = "~/Downloads"

c.fonts.default_size = "12pt"

c.url.searchengines['DEFAULT'] = "https://google.com/search?q={}"
c.url.searchengines['gh'] = "https://github.com/search?q={}"
c.url.searchengines['ad'] = "https://dev.azure.com/thenetworg/_search?action=contents&type=code&text={}"
