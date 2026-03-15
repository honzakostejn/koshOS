import baseConfig
baseConfig.load(config, c)

import theme
theme.setup(c, 'latte')

c.url.searchengines['DEFAULT'] = "https://google.com/search?q={}"
c.url.searchengines['gh'] = "https://github.com/search?q={}"
c.url.searchengines['ad'] = "https://dev.azure.com/thenetworg/_search?action=contents&type=code&text={}"
