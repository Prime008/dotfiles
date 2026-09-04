cat << 'EOF' > ~/dotfiles/README.md
# Dotfiles & Workspace Bootstrap

Automated environment setup script and configuration files for DevOps workflows, shell enhancements, and container tooling.

## Environment Compatibility

* **Target System:** Ubuntu / Debian (specifically optimized for WSL2 / Linux VM).
* **Cross-Platform Components:** `starship.toml` configuration is OS-agnostic and fully compatible with Linux, macOS, and Windows (PowerShell / Windows Terminal).

## What It Sets Up

* **Shell & Core Framework:** Zsh managed via Oh My Zsh.
* **Productivity Plugins:**
  * `zsh-autosuggestions` (history-based autocompletion).
  * `zsh-syntax-highlighting` (visual syntax validation).
  * Built-in `git`, `docker`, and `kubectl` completion engines.
* **Terminal Prompt:** [Starship](https://starship.rs/) configured with a clean, responsive layout (directory, Git branch/status, execution time, and active Kubernetes context).
* **CLI Tooling:** `kubectl` stable binary, standard networking and debugging packages (`htop`, `jq`, `tcpdump`, `dnsutils`, `socat`, etc.).

## Quick Start (Bootstrap)

Run the script on a fresh system:

```bash
chmod +x bootstrap.sh
./bootstrap.sh
