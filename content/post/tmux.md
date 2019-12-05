+++
title = "Configuring tmux"
date = "2019-11-12T11:43:49Z"
tags = ["linux","terminal","environment","installation"]
categories = ["computing"]
description = "My tmux configuration"
draft=false
+++

## Introduction

To have multiple windows and panes in my terminal, I use the terminal multiplexer [`tmux`](https://github.com/tmux/tmux/wiki).
I installed it with

```sh
sudo dnf install tmux
```

## Configuration

The `tmux` configuration is stored at `~/.tmux.conf`.
I initially customised it as

```sh
$ vi ~/.tmux.conf
```

```sh
# Set zsh as default shell
set -g default-shell /bin/zsh

# Set indexing to match the keyboard
set -g base-index 1

# Automatically set window title
setw -g automatic-rename on
set -g set-titles on

# Mouse mode
set -g mouse on

# Alt-arrow without prefix key to switch panes
bind -n M-Left select-pane -L
bind -n M-Down select-pane -D 
bind -n M-Up select-pane -U
bind -n M-Right select-pane -R

# Shift-arrow without prefix key to switch windows
bind -n S-Left  previous-window
bind -n S-Right next-window

# Reload tmux config
bind r source-file ~/.tmux.conf
bind R source ~/.tmux.conf
```

I left the prefix as the default, `Ctrl`+`b`, as I prefer using separate hands for the modifier and letter keys, unlike the commonly used `screen` default of `Crtl`+`a`.

## Plugins

I use the `tmux` package manager [`tpm`](https://github.com/tmux-plugins/tpm).
I installed it by 

```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

then adding the following to the end of `~/.tmux.conf`

```sh
# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'tmux-plugins/tmux-pain-control'
set -g @plugin 'tmux-plugins/tmux-prefix-highlight'

# Initialize tmux plugin manager (keep this line at the very bottom of tmux.conf!)
run -b '~/.tmux/plugins/tpm/tpm'
```

and reloading `tmux` with `prefix`+`R`.

This includes a few starter plugins:

* [`sensible`](https://github.com/tmux-plugins/tmux-sensible) gives some... sensible defaults.
* [`pain-control`](https://github.com/tmux-plugins/tmux-pain-control) provides some sane pane controls.
* [`prefix-highlight`](https://github.com/tmux-plugins/tmux-prefix-highlight) changes the colour of the leftmost section of the infobar at the bottom when `prefix` is engaged.

New plugins are loaded with `prefix`+`I`.


## Persistence

I use [`resurrect`](https://github.com/tmux-plugins/tmux-resurrect) to remember my `tmux` configuration over reboots.
The restore/save is manually performed by `prefix`+`Ctrl`+`r`/`s`.
[`continuum`](https://github.com/tmux-plugins/tmux-continuum) automates the process so I don't need to manually save and restore sessions.
It saves the session automatically and can autorestore with

```sh
echo -e "set -g @continuum-restore 'on'\n$(cat ~/.tmux.conf)" >> ~/.tmux.conf
```

where the fancy echo is to prepend the line to the file since `tpm` must be initialised at the end of the file.
The `-e` just [allows us to use the newline character](https://ss64.com/bash/echo.html) `\n`.
These packages are installed by adding the following to `~/.tmux.conf`

```sh
set -g @plugin 'tmux-plugins/tmux-resurrect'
set -g @plugin 'tmux-plugins/tmux-continuum'
```

and reloading with `prefix`+`I` then `prefix`+`Ctrl`+`r`.

## Powerline

I installed [`powerline`](https://github.com/powerline/powerline) for `tmux` with

```sh
sudo dnf install tmux-powerline
echo -e 'source "/usr/share/tmux/powerline.conf"\n$(cat ~/.tmux.conf)' >> ~/.tmux.conf
```
<!--
```
sudo npm install -g jsonlint
mkdir ~/.config/powerline/
```

and configured it as

```sh
$ vi ~/.config/powerline/config.json
```

I checked the configuration with

```sh
jsonlint ~/.config/powerline/config.json
powerline-lint
```
-->
## Colours

To use `truecolor`, I set up `tmux` as follows.
`zprezto` (see [shell configuration](../shell)) sets the `TERM` variable

```sh
$ echo $TERM
xterm-256color
```

I enabled `truecolor` in `tmux` with

```sh
echo -e 'set-option -ga terminal-overrides ",xterm-256color:Tc"\n$(~/.tmux.conf)' >> ~/.tmux.conf
```

I confirmed this worked by restarting `tmux` and running

```sh
$ tmux info | grep Tc
203: Tc: (flag) true
```

## Copying

I use `Shift`+ `highlight with mouse cursor` then `Ctrl`+`Shift`+`c` to copy and `Ctrl`+`Shift`+`v` to paste in a `tmux` session.
