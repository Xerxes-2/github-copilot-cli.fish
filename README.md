# github-copilot-cli.fish

Make GitHub Copilot CLI's alias work for Fish shell. The current Copilot CLI only supports bash, zsh and pwsh.

## How to install

### Via fisher

```fish
fisher install xerxes-2/github-copilot-cli.fish
```

### Manually

Copy the file `conf.d/github-copilot-cli.fish` to `$__fish_config_dir/conf.d/` on your machine.

## How to use

Identical to the [original Copilot CLI Aliases](https://github.com/github/gh-copilot#set-up-optional-helpers) for bash, zsh and pwsh.

- `ghcs` - `gh copilot suggest`
- `ghce` - `gh copilot explain`

### Use your own aliases

If you don't want the default aliases, what you can do now is to put these in your config.fish:

```fish
functions -e ghcs ghce
```

And use your own aliases, for example, to use `,`:

```fish
alias ,s ghcs
alias ,e ghce
```
