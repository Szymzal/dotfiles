# To jest plik konfiguracyjny shella bash, ktory jest ustawiony jako domyslny
# Prosze o nie zmienianie tego pliku chyba, ze wiesz co robisz

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

alias luamake=/home/szymzal/.dotfiles/nvim/.config/nvim/lua-language-server/3rd/luamake/luamake

export VULKAN_SDK=/home/szymzal/vulkan/1.2.189.0/x86_64
export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
export LIBGL_ALWAYS_INDIRECT=1

if [[ $(ps --no-header --pid=$PPID --format=cmd) != "fish" && -z ${BASH_EXECUTION_STRING} ]]
then
	exec fish
fi
