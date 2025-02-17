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
theme.setup(c, 'mocha')

c.content.pdfjs = True
c.downloads.location.directory = "~/Downloads"

c.fonts.default_size = "12pt"

c.url.searchengines['DEFAULT'] = "https://google.com/search?q={}"
c.url.searchengines['np'] = "https://search.nixos.org/packages?channel=unstable&sort=relevance&type=packages&query={}"
c.url.searchengines['hm'] = "https://home-manager-options.extranix.com/?query={}&release=master"
c.url.searchengines['gh'] = "https://github.com/search?q={}"
c.url.searchengines['yt'] = "https://www.youtube.com/results?search_query={}"
