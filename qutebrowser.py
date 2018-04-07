c.url.searchengines = {
    'DEFAULT': 'https://www.google.com/search?q={}',
    'ddg': 'https://duckduckgo.com/?q={}',
    'g': 'https://www.google.com/search?q={}',
    'wp': 'https://en.wikipedia.org/wiki/Special:Search/{}',
    'aw': 'https://wiki.archlinux.org/index.php?search={}',
    'aur': 'https://aur.archlinux.org/packages/?O=0&K={}',
}

c.url.default_page = 'about:blank'
c.url.start_pages = ['about:blank']

c.tabs.background = True

config.bind(',f', 'spawn --userscript /usr/share/qutebrowser/userscripts/password_fill')
