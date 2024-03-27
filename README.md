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
chezmoi re-add <path to file>`
```

To push config changes
```sh
chezmoi cd # change to the chezmoi git dir
git add .
git commit -m "message"
git push
```


