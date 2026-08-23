PROMPT='%F{166}%B%n@%m:%~$ %b%f' # %F{166} sets text color to Dark Orange 3 -> Based on 256 Xterm color code | %B turns bold on | %n = username | %m = hostname | %~ = current dir (~ if under home) | $ + space = literal | %b turns bold off | %f resets color back to default

export LS_COLORS="di=01;32:ln=01;35:ex=01;33:fi=01;36" # di = directories = bold green | ln = symlinks = bold magenta | ex = executables/binaries = bold yellow | fi = regular files = bold cyan -> we are using ANSI Codes here

alias ls='ls --color=auto' # makes ls actually apply LS_COLORS; without this, colors won't show even if LS_COLORS is set

# Applying syntax highlighting -> cmd download using sudo apt install zsh-syntax-highlighting

source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh # loads the plugin that colors commands as you type them; must be sourced, and near the end of .zshrc for it to work correctly

# Applying History Feature

HISTFILE=~/.zsh_history # History Save Location
HISTSIZE=10000 # Number of cmds kept in memory during a session
SAVEHIST=10000 # Number of cmds saved to the file
setopt SHARE_HISTORY # share the history across multiple open terminal tabs / sessions
setopt HIST_IGNORE_DUPS # don't save a command if it's identical to the previous one
setopt APPEND_HISTORY # append to history file instead of overwriting on exit