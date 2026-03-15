import baseConfig
baseConfig.load(config, c)

import theme
theme.setup(c, 'mocha')

c.url.searchengines['DEFAULT'] = "https://google.com/search?q={}"
c.url.searchengines['np'] = "https://search.nixos.org/packages?channel=unstable&sort=relevance&type=packages&query={}"
c.url.searchengines['hm'] = "https://home-manager-options.extranix.com/?query={}&release=master"
c.url.searchengines['gh'] = "https://github.com/search?q={}"
c.url.searchengines['yt'] = "https://www.youtube.com/results?search_query={}"
