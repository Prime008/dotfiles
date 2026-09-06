cat << 'EOF' > ~/dotfiles/bootstrap.sh
#!/usr/bin/env bash
set -euo pipefail

# 1. Системные пакеты и сетевые утилиты
sudo apt update && sudo apt install -y \
  build-essential curl wget git htop jq \
  iproute2 net-tools sshuttle dnsutils traceroute tcpdump nmap socat iptables zsh # Установка базового системного стека

# 2. Oh My Zsh и внешние плагины через tarball
rm -rf ~/.oh-my-zsh && mkdir -p ~/.oh-my-zsh
curl -L https://github.com/ohmyzsh/ohmyzsh/archive/refs/heads/master.tar.gz | tar -xz -C ~/.oh-my-zsh --strip-components=1 # Развертывание Oh My Zsh

mkdir -p ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
curl -L https://github.com/zsh-users/zsh-autosuggestions/archive/refs/heads/master.tar.gz | tar -xz -C ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions --strip-components=1 # Загрузка плагина автодополнения

mkdir -p ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
curl -L https://github.com/zsh-users/zsh-syntax-highlighting/archive/refs/heads/master.tar.gz | tar -xz -C ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting --strip-components=1 # Загрузка подсветки синтаксиса

# 3. Генерация минимального чистого .zshrc с алиасами
cat << 'CONFIG' > ~/.zshrc
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
zstyle ':omz:update' mode disabled
plugins=(git docker kubectl zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# Пользовательские алиасы
alias ll='ls -lahi'

export PATH="$HOME/.local/bin:/usr/local/bin:$PATH"
eval "$(starship init zsh)"
CONFIG

# 4. Установка бинарника Starship
curl -sS https://starship.rs/install.sh | sh -s -- -y                                      # Установка starship в /usr/local/bin

# 5. Применение конфига starship.toml (однострочный компактный формат)
mkdir -p ~/.config
cat << 'CONFIG' > ~/.config/starship.toml
add_newline = false

format = """
$time\
$directory\
$git_branch\
$git_status\
$kubernetes\
$cmd_duration\
$character"""

[time]
disabled = false
format = "[$time]($style) "
time_format = "%T"
style = "bold dimmed white"

[directory]
truncation_length = 3
truncation_symbol = "…/"

[git_branch]
symbol = " "
format = "[$symbol$branch]($style) "

[git_status]
format = '([\[$all_status$ahead_behind\]]($style) )'

[kubernetes]
disabled = false
format = 'on [󱃾 $context\($namespace\)](bold cyan) '

[cmd_duration]
min_time = 2000
format = "took [$duration](bold yellow) "

[character]
success_symbol = "[➜ ](bold green)"
error_symbol = "[➜ ](bold red)"
CONFIG

# 6. Установка бинарника kubectl
K8S_VER=$(curl -L -s https://dl.k8s.io/release/stable.txt)                                # Определение последней стабильной версии k8s
curl -LO "https://dl.k8s.io/release/${K8S_VER}/bin/linux/amd64/kubectl"                   # Загрузка бинарника kubectl
chmod +x kubectl && sudo mv kubectl /usr/local/bin/                                        # Перенос бинарника в /usr/local/bin

# 7. Сброс устаревшего кэша автодополнения
rm -f ~/.zcompdump*                                                                        # Инвалидация кэша compinit

# 8. Назначение Zsh оболочкой по умолчанию
sudo chsh -s $(which zsh) $USER                                                            # Смена дефолтного шелла для текущего пользователя

echo "Setup complete. Run: exec zsh"
EOF
chmod +x ~/dotfiles/bootstrap.sh
