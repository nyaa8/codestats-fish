🐟 codestats-fish
=================

A simple [Fish shell](https://fishshell.com/) *plugin* for [Code::Stats](https://codestats.net/).
Currently only counts characters from executed commands (sheesh)

Inspired a bit by the [Code::Stats plugin for ZSH](https://gitlab.com/code-stats/code-stats-zsh)

Installation
------------

Using [fisher](https://github.com/jorgebucaran/fisher):

```sh
fisher add nyaa8/codestats-fish
```

With [fundle](https://github.com/danhper/fundle):

```sh
fundle plugin nyaa8/codestats-fish
```

Requirements
------------
* cURL
* fish 🙂

Configuration
-------------

Set `CODESTATS_API_KEY` to a token
```sh
set -U CODESTATS_API_KEY "SFMyNTY.OEotWWdnPT0jI01qaz0.X0wVEZquh8Ogau1iTtBihYqqL71FD8N6p5ChQiIpaxQ"
```

