#Алиасы:
	alias untar='tar -xvf'
	editbashrc(){
		echo "Starting Editing ~/.bashrc via nvim!"
		nvim "$HOME/.bashrc"
		source "$HOME/.bashrc"
	}
	# DWM Aliases
		alias dwmnitrogen='nitrogen ~/Wallpapers'
		alias dwmedit='cd .github/dwm-arch-setup/dwm-6.5; sudo vim config.h'
		alias dwmcompile='cd .github/dwm-arch-setup/dwm-6.5;sh compile.sh'
		alias dwmstart='startx ~/.xinitrc dwm'

	alias git_revert='git revert HEAD'
	alias git_push='git push origin main'
	git_commit() {
 	    git add .
  	    git commit -m "$*"
    	}
	alias service_log='sudo journalctl -xeu'
	alias ff='clear;fastfetch -c $HOME/.config/fastfetch/config.jsonc'
  alias conf='cd ~/.config;clear;ls'
  alias randomfetch='sh .config/hypr/scripts/fastfetch.sh'
	# Yay
		alias ysearch='yay -Ss'
		alias yclear='yay -Scc --noconfirm'
		alias yremove='yay -Rns --noconfirm'
		alias yinstall='yay -S --needed --noconfirm'
		alias ysync='yay -Sy --noconfirm'
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
psearch <пакет>   -  Найти Pacman пакет\n\
premove <пакет>   -  Удалить Pacman пакет\n\
pinstall <пакет>  -  Установить Pacman пакет\n\
pclear            -  Очистить Кеш Pacman\n\n\
# AUR Helper Aliases\n\
ysearch <пакет>   -  Найти AUR пакет\n\
yremove <пакет>   -  Удалить AUR пакет\n\
yinstall <пакет>  -  Установить AUR пакет\n\
yclear            -  Очистить Кеш AUR"'
	alias suspend='systemctl suspend'
	alias colors='./.config/hypr/scripts/show-pywal-colors.sh'
	alias rel='kitty @ set-colors --all ~/.config/kitty/kitty.conf
'
	#alias pywalfox="~/.local/pipx/venvs/pywalfox/bin/pywalfox"
# Enable the subsequent settings only in interactive sessions
case $- in
  *i*) ;;
    *) return;;
esac

# Path to your oh-my-bash installation.
export OSH='/home/unner/.oh-my-bash'

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-bash is loaded.
#OSH_THEME="font"
#OSH_THEME="random"
OSH_THEME="hawaii50"
#OSH_THEME="unner"
# If you set OSH_THEME to "random", you can ignore themes you don't like.
# OMB_THEME_RANDOM_IGNORED=("powerbash10k" "wanelo")

# Uncomment the following line to use case-sensitive completion.
# OMB_CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# OMB_HYPHEN_SENSITIVE="false"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_OSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you don't want the repository to be considered dirty
# if there are untracked files.
# SCM_GIT_DISABLE_UNTRACKED_DIRTY="true"

# Uncomment the following line if you want to completely ignore the presence
# of untracked files in the repository.
# SCM_GIT_IGNORE_UNTRACKED="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.  One of the following values can
# be used to specify the timestamp format.
# * 'mm/dd/yyyy'     # mm/dd/yyyy + time
# * 'dd.mm.yyyy'     # dd.mm.yyyy + time
# * 'yyyy-mm-dd'     # yyyy-mm-dd + time
# * '[mm/dd/yyyy]'   # [mm/dd/yyyy] + [time] with colors
# * '[dd.mm.yyyy]'   # [dd.mm.yyyy] + [time] with colors
# * '[yyyy-mm-dd]'   # [yyyy-mm-dd] + [time] with colors
# If not set, the default value is 'yyyy-mm-dd'.
# HIST_STAMPS='yyyy-mm-dd'

# Uncomment the following line if you do not want OMB to overwrite the existing
# aliases by the default OMB aliases defined in lib/*.sh
# OMB_DEFAULT_ALIASES="check"

# Would you like to use another custom folder than $OSH/custom?
# OSH_CUSTOM=/path/to/new-custom-folder

# To disable the uses of "sudo" by oh-my-bash, please set "false" to
# this variable.  The default behavior for the empty value is "true".
OMB_USE_SUDO=true

# To enable/disable display of Python virtualenv and condaenv
# OMB_PROMPT_SHOW_PYTHON_VENV=true  # enable
# OMB_PROMPT_SHOW_PYTHON_VENV=false # disable

# To enable/disable Spack environment information
# OMB_PROMPT_SHOW_SPACK_ENV=true  # enable
# OMB_PROMPT_SHOW_SPACK_ENV=false # disable

# Which completions would you like to load? (completions can be found in ~/.oh-my-bash/completions/*)
# Custom completions may be added to ~/.oh-my-bash/custom/completions/
# Example format: completions=(ssh git bundler gem pip pip3)
# Add wisely, as too many completions slow down shell startup.
completions=(
  git
  composer
  ssh
)

# Which aliases would you like to load? (aliases can be found in ~/.oh-my-bash/aliases/*)
# Custom aliases may be added to ~/.oh-my-bash/custom/aliases/
# Example format: aliases=(vagrant composer git-avh)
# Add wisely, as too many aliases slow down shell startup.
aliases=(
  general
)

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-bash/plugins/*)
# Custom plugins may be added to ~/.oh-my-bash/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  bashmarks
)

# Which plugins would you like to conditionally load? (plugins can be found in ~/.oh-my-bash/plugins/*)
# Custom plugins may be added to ~/.oh-my-bash/custom/plugins/
# Example format:
#  if [ "$DISPLAY" ] || [ "$SSH" ]; then
#      plugins+=(tmux-autoattach)
#  fi

source "$OSH"/oh-my-bash.sh

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-bash libs,
# plugins, and themes. Aliases can be placed here, though oh-my-bash
# users are encouraged to define aliases within the OSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias bashconfig="mate ~/.bashrc"
# alias ohmybash="mate ~/.oh-my-bash"

# Created by `pipx` on 2025-04-04 11:56:55
export PATH="$PATH:/home/unner/.local/bin"

export PATH=$PATH:/home/unner/.spicetify
