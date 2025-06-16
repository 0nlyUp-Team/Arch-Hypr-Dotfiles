# ==== Custom Aliases and Functions ====

alias dwmc_start='startx $HOME/.xinitrc dwmc'
alias dwm_start='startx $HOME/.xinitrc dwm'
alias bspwm_start='startx $HOME/.xinitrc bspwm'

# Aliases:
	# Systemctl aliases
		alias srestart='sudo systemctl restart'
		alias senable='sudo systemctl enable --now'
		alias sdisable='sudo systemctl disable --now'
	# Web Aliases
		alias websdir='clear;cd /etc/nginx;ls'
		alias wwwdir='clear;cd /var/www;ls'
		alias flow.conf='sudo vim /etc/nginx/sites-available/flow.conf'
		alias unner.conf='sudo vim /etc/nginx/sites-available/unner.conf'
		alias osint.conf='sudo vim /etc/nginx/sites-available/osint.conf'
		alias chat.conf='sudo vim /etc/nginx/sites-available/chat.conf'
alias untar='tar -xvf'
alias nv='nvim'

editzshrc(){
  echo "Editing ~/.zshrc"
  nvim "$HOME/.zshrc"
  source "$HOME/.zshrc"
  clear
}

# DWM Aliases
alias dwmnitrogen='nitrogen $HOME/Wallpapers'
alias picomedit='nvim $HOME/.config/picom/picom.conf'
alias dwmedit='cd $HOME/.github/dwm-arch-setup/dwm-6.5; nvim config.h'
alias dwmfedit='cd $HOME/.github/dwm-arch-setup'
alias dwmcompile='cd $HOME/.github/dwm-arch-setup;sh compile.sh'
alias dwmb='cd $HOME/.github/dwm-arch-setup/dwmblocks;clear;tree'
alias dwm='cd $HOME/.github/dwm-arch-setup/dwm-6.5;clear;tree'
alias das='cd $HOME/.github/dwm-arch-setup;clear;tree'

alias revert='git revert HEAD'
alias push='git push origin main'
commit() {
	git add .
	git commit -m "$*"
}

alias service_log='sudo journalctl -xeu'
alias randomfetch='sh .config/hypr/scripts/fastfetch.sh'

# Yay
alias ysearch='yay -Ss'
alias yclear='yay -Scc --noconfirm'
alias yremove='yay -Rns --noconfirm'
alias yinstall='yay -S --needed --noconfirm'
alias ysync='yay -Sy'
alias yreinstall='yay -S --noconfirm'

# Pacman
alias psearch='sudo pacman -Ss'
alias pclear='sudo pacman -Scc --noconfirm'
alias premove='sudo pacman -Rns --noconfirm'
alias psync='sudo pacman -Sy --noconfirm'
alias pinstall='sudo pacman -S --needed --noconfirm'
alias preinstall='sudo pacman -S --noconfirm'
alias update='sudo pacman -Syu --noconfirm'

alias helper='echo -e "\
# Pacman Helper Aliases\n\
  psearch <пакет>    -  Найти Pacman пакет\n\
  premove <пакет>    -  Удалить Pacman пакет\n\
  pinstall <пакет>   -  Установить Pacman пакет\n\
  preinstall <пакет> -  Переустановить Pacman Пакет\n\
  psync	  	     -  Обновить Базу Данных\n\
  pclear             -  Очистить Кеш Pacman\n\n\
# AUR Helper Aliases\n\
  ysearch <пакет>    -  Найти AUR пакет\n\
  yremove <пакет>    -  Удалить AUR пакет\n\
  yinstall <пакет>   -  Установить AUR пакет\n\
  yreinstall <пакет> -  Переустановить AUR Пакет\n\
  ysync	             -  Обновить Базу Данных\n\
  yclear             -  Очистить Кеш AUR"'

alias suspend='systemctl suspend'

			# OHMYZSH
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
