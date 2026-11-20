# Place Config at ~/.config/fish/config.fish

if status is-interactive
	# Commands to run in interactive sessions can go here
	set -gx LS_COLORS "di=01;32:ln=01;35:ex=01;33:fi=01;36" # di = directories = bold green | ln = symlinks = bold magenta | ex = executables/binaries = bold yellow | fi = regular files = bold cyan -> we are using ANSI Codes here
end
