# To jest plik konfiguracyjny shella bash, ktory jest ustawiony jako domyslny
# Prosze o nie zmienianie tego pliku chyba, ze wiesz co robisz

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

if [[ $(ps --no-header --pid=$PPID --format=cmd) != "fish" && -z ${BASH_EXECUTION_STRING} ]]
then
	exec fish
fi

alias luamake=/home/szymzal/.dotfiles/nvim/.config/nvim/lua-language-server/3rd/luamake/luamake
