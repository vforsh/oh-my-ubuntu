# Oh My Ubuntu

An opinionated bash script to set up Ubuntu for a delightful dev experience.

## What it installs

- **Git**: Version control system (with completions)
- **Bun**: Fast JavaScript runtime, bundler, transpiler, and package manager (with bash completions)
- **Bat**: A `cat` clone with syntax highlighting and Git integration (aliased to `cat`)
- **fzf**: A command-line fuzzy finder with modern shell integration
- **eza**: A modern replacement for `ls` with more features and better defaults
- **Starship**: Cross-shell prompt with minimal, beautiful design and helpful features
- **zoxide**: A smarter, faster way to navigate your filesystem (like `cd` with superpowers)

## Usage

1. Clone this repository or download the script:
   ```bash
   git clone https://github.com/yourusername/oh-my-ubuntu.git
   cd oh-my-ubuntu
   ```

2. Make the script executable:
   ```bash
   chmod +x setup-ubuntu.sh
   ```

3. Run the script:
   ```bash
   ./setup-ubuntu.sh
   ```

4. After installation, either restart your terminal or run:
   ```bash
   source ~/.bashrc
   ```

## Git Features

The script enhances your Git experience with:

- **Tab Completions**: Auto-complete Git commands, branch names, and more

## Starship Prompt

The script installs and configures the [Starship](https://starship.rs/) prompt with:

- **Git Integration**: Shows branch name and status in your prompt
- **Command Duration**: Displays how long commands take to run
- **Error Status**: Changes prompt color based on the success/failure of the last command
- **Custom Configuration**: Includes a clean, minimal default configuration

You can customize the prompt further by editing `~/.config/starship.toml`.

## zoxide

The script installs [zoxide](https://github.com/ajeetdsouza/zoxide), a smarter cd command that helps you navigate your filesystem more efficiently:

- **Jump to directories**: Use `z directory_name` to jump to a directory you've visited before
- **Interactive selection**: Use `zi` to interactively select a directory to jump to
- **Ranking algorithm**: zoxide learns which directories you use most frequently
- **Seamless integration**: Works with your existing muscle memory for `cd`

Examples:
```bash
# Jump to a directory you've visited before
z projects

# Jump to a specific subdirectory
z ubuntu

# Interactive selection
zi
```

## fzf Features

The script installs fzf directly from the [official Git repository](https://github.com/junegunn/fzf), ensuring you get the latest version with all features:

- **Key bindings**:
  - `Ctrl+T`: Paste selected files/directories onto the command line
  - `Ctrl+R`: Search command history with an interactive interface
  - `Alt+C`: Change directory with fuzzy finding

- **Auto-completion**: Press Tab after trigger sequences like `**` for path completion

- **Advanced features**:
  - Preview window for files and directories
  - Multi-select mode with Tab/Shift+Tab
  - Smart case-insensitive search
  - Customizable layout and appearance

- **Auto-updates**: The script checks for and applies updates to fzf when run

## eza Aliases

The script sets up the following aliases for eza:

- `ls`: Basic eza listing (replaces standard ls)
- `ll`: Long listing format with extended details
- `la`: Long listing including hidden files
- `lt`: Tree view of the directory structure

## Utility Aliases

The script adds convenient aliases for managing your bash configuration:

- `ebc`: Edit your bashrc file (using nano)
- `sfc`: Source your bashrc file to apply changes

## Bun Completions

The script sets up bash completions for Bun, providing tab completion for:
- Bun commands and subcommands
- Package scripts from package.json
- Common options and flags

## Customization

Feel free to modify the script to add or remove tools based on your preferences. The script is designed to be easy to extend.

## Requirements

- Ubuntu (or Debian-based) system
- Sudo privileges

## License

MIT 