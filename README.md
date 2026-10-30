# ASKobayashi's Dot Files

This dotfile repo is based on [chezmoi](https://www.chezmoi.io/)


## Usage

To install on a new machine:

```sh
chezmoi init --apply https://github.com/ASKobayashi/dotFiles.git
```


To update a machine from the repo:

```sh
chezmoi update -v
```

## Updating config files

To add a new config file:

```sh
chezmoi add <path to file>
```

To update an already commited file:

```sh
chezmoi re-add <path to file>
```

To push config changes
```sh
# change to the chezmoi git dir, then use normal git flow
chezmoi cd 
git add .
git commit -m "message"
git push
```



## Shells

Primary shell is zsh (`~/.zshenv` for env/PATH in all shells, `~/.zshrc` for
interactive). Fish config is still managed here as a fallback. Switch with
`chsh -s /bin/zsh` (macOS) or `chsh -s $(which zsh)` (Linux).

When moving a machine off fish, merge its history once: `fish2zshhist`
(deploys to `~/.local/bin`). zsh runs on Oh My Zsh with config, theme, and
plugins in `~/.config/zsh/omz`; chezmoi fetches Oh My Zsh itself (except on
Linux work machines, which ship their own) and the autosuggestions and
syntax-highlighting plugins (see `.chezmoiexternal.toml.tmpl`).

## Machine-specific settings

Anything work- or machine-specific goes in untracked local files, which the
tracked configs source when present: `~/.zshenv.local`, `~/.zshrc.local`, and
`~/.config/fish/local.fish`. They are listed in `.chezmoiignore`, so they are
never committed. Copy them to a new machine by hand.
