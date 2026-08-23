PROMPT='%F{166}%B%n@%m:%~$ %b%f' # %F{166} sets text color to Dark Orange 3 -> Based on 256 Xterm color code | %B turns bold on | %n = usernatme | %m = hostname | %~ = current dir (~ if under home) | $ + space = literal | %b turns bold off | %f resets color back to default

export LS_COLORS="di=01;32:ln=01;35:ex=01;33:fi=01;36" # di = directories = bold green | ln = symlinks = bold magenta | ex = executables/binaries = bold yellow | fi = regular files = bold cyan -> we are using ANSI Codes here

alias ls='ls --color=auto' # makes ls actually apply LS_COLORS; without this, colors won't show even if LS_COLORS is set

source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh # loads the plugin that colors commands as you type them; must be sourced, and near the end of .zshrc for it to work correctly