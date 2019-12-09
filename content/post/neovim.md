+++
title = "Configuring Neovim"
date = "2019-12-05T11:12:27Z"
tags = ["linux","environment","installation","terminal"]
categories = ["computing"]
description = "Setting up a new flavour of Vi"
+++

## Introduction

I've been using [`vim`](https://www.vim.org/) as one of my go-to text editors for some time.
I decided to replace it with [Neovim](https://github.com/neovim/neovim), or `nvim`, and configure it from scratch using [`vim-bootstrap`](https://github.com/editor-bootstrap/vim-bootstrap).
`vim-bootstrap` uses [`vim-plug`](https://github.com/junegunn/vim-plug) as the `(n)vim` package manager, which is what I was using previously with `vim`.

## Installation

I installed `nvim` and prerequisites for packages and `vim-bootstrap`

```sh
sudo dnf install ncurses-devel git ctags-etags curl neovim python3-neovim python3-pyflakes python3-jedi python3-flake8 vim-go ripgrep
sudo npm install -g neovim
```

## Change default

I set `nvim` as the default terminal text editor and aliased calls to `vi` and `vim`

```sh
echo "EDITOR=nvim\nVISUAL=nvim\nalias vi=nvim\nalias vim=nvim" >> ~/.zshrc
```

## Initial configuration

`nvim` settings are at `~/.config/nvim/init.vim`.
I used `vim-bootstrap` to generate the initial configuration

```sh
go get github.com/avelino/vim-bootstrap
cd $GOPATH/src/github.com/avelino/vim-bootstrap
go build
mkdir ~/.config/nvim
vim-bootstrap -langs=c,go,html,javascript,python -editor=nvim >! ~/.config/nvim/init.vim
```

## Plugins

`vim-bootstrap` sets up `vim-plug` as the `nvim` package manager.
`vim-plug` will install all packages in the new configuration file the first time `nvim` is run.

## Customisation

When using `vim-bootstrap`, custom settings are in `~/.config/nvim/local_init.vim`.
I edited it to include the following

```sh
 $ vi ~/.config/nvim/local_init.vim
```

```sh
# Enable mouse
set mouse=a

# Stop any hiding
let g:indentLine_setConceal=0

# Make the powerline use the solarized colour scheme
let g:airline_theme='solarized'

# Get fancy powerline symbols
let g:airline_powerline_fonts=1

# Stop csv syntax highlighting for Sherpa *.dat runcards
au BufRead,BufNewFile *.dat set filetype=text
```

Custom plugins are defined in `~/.config/nvim/local_bundles.vim`.
I added

```sh
$ vi ~/.config/nvim/local_bundles.vim
```

```sh
Plug 'terryma/vim-multiple-cursors'
```

## Colours

I use the [solarised colour scheme](https://github.com/altercation/solarized) for my terminal.
I use `nvim` in `tmux`, which is set up to use `truecolor` as described [here](../tmux).
This `tmux` configuration is required for the following.

To get a `truecolor` `solarized` colour palette working in `nvim`, I used [NeoSolarized](https://github.com/iCyMind/NeoSolarized).
I added it as a `vim-plug` plugin by adding

```sh
echo "Plug 'iCyMind/NeoSolarized'" >> ~/.config/nvim/local_bundles.vim
```

then running `:PlugUpdate` in `nvim`.
I enabled `truecolor` in `nvim` with

```sh
echo "set termguicolors" >> ~/.config/nvim/local_init.vim
```

and set the colour palette with

```sh
echo "colorscheme NeoSolarized" >> ~/.config/nvim/local_init.vim
```

Following [this](https://github.com/iCyMind/NeoSolarized#truecolor-test), I tested that it was working by opening a terminal in `nvim` by `:terminal` and running

```sh
awk 'BEGIN{
    s="/\\/\\/\\/\\/\\"; s=s s s s s s s s;
    for (colnum = 0; colnum<77; colnum++) {
        r = 255-(colnum*255/76);
        g = (colnum*510/76);
        b = (colnum*255/76);
        if (g>255) g = 510-g;
        printf "\033[48;2;%d;%d;%dm", r,g,b;
        printf "\033[38;2;%d;%d;%dm", 255-r,255-g,255-b;
        printf "%s\033[0m", substr(s,colnum+1,1);
    }
    printf "\n";
}'
```

which shows a colour bar of smoothly changing colour in `truecolor` and discrete colour blocks elsewise.

## Result

Now `nvim` looks like

<a href="../../images/nvim.png">
<img alt="image of nvim" src="../../images/nvim.png" width="100%"/>
</a>

