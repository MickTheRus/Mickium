if status is-interactive
    # Commands to run in interactive sessions can go here
end

# TokyoNight Color Palette
set -l foreground cdd6f4
set -l selection 313244
set -l comment 7f849c
set -l red f38ba8
set -l orange fab387
set -l yellow f9e2af
set -l green a6e3a1
set -l purple cba6f7
set -l cyan 89dceb
set -l pink f5c2e7

# Syntax Highlighting Colors
set -g fish_color_normal $foreground
set -g fish_color_command $cyan
set -g fish_color_keyword $pink
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_error $red
set -g fish_color_param $purple
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $pink
set -g fish_color_autosuggestion $comment
    
# Completion Pager Colors
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment

# Some config
set -g fish_greeting

# Git config
set -g __fish_git_prompt_show_informative_status 1
set -g __fish_git_prompt_showupstream informative
set -g __fish_git_prompt_showdirtystate yes
set -g __fish_git_prompt_char_stateseparator ' '
set -g __fish_git_prompt_char_cleanstate '✔ '
set -g __fish_git_prompt_char_dirtystate '✚ '
set -g __fish_git_prompt_char_invalidstate '✖ '
set -g __fish_git_prompt_char_stagedstate '● '
set -g __fish_git_prompt_char_stashstate '⚑ '
set -g __fish_git_prompt_char_untrackedfiles '? '
set -g __fish_git_prompt_char_upstream_ahead ' '
set -g __fish_git_prompt_char_upstream_behind ' '
set -g __fish_git_prompt_char_upstream_diverged 'ﱟ '
set -g __fish_git_prompt_char_upstream_equal ' '
set -g __fish_git_prompt_char_upstream_prefix ''''


# Directory abbreviations
abbr -a -g l 'ls'
abbr -a -g la 'ls -a'
abbr -a -g ll 'ls -l'
abbr -a -g lal 'ls -al'
abbr -a -g d 'dirs'
abbr -a -g h 'cd $HOME'

# Locale
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Exports
export VISUAL="nvim"
export EDITOR="$VISUAL"

# Term
export TERM="alacritty"

# Launch GPG agent 
export GPG_TTY=$(tty)

# User abbreviations
abbr -a -g ytdlx 'youtube-dl --extract-audio --audio-format mp3'				# Convert/Download YT videos as mp3
abbr -a -g please 'sudo'																						# Polite way to sudo
abbr -a -g fucking 'sudo'																						# Rude way to sudo
abbr -a -g untar 'tar -zxvf'																					# Untar
abbr -a -g genpass 'openssl rand -base64 20'													# Generate a random, 20-charactered password
abbr -a -g sha 'shasum -a 256'																			# Test checksum
abbr -a -g ips 'ip link show'																					# Get network interfaces information
abbr -a -g v 'nvim'

# Set XDG Variables
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# Cleanup my $HOME 
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export GOPATH="$XDG_DATA_HOME"/go
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export LESSHISTFILE="$XDG_CACHE_HOME"/less/history
export OMNISHARPHOME="$XDG_CONFIG_HOME"/omnisharp
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME"/npm/npmrc
export SPACEMACSDIR="$XDG_CONFIG_HOME"/spacemacs


# Add things to path
fish_add_path -a -g "$HOME/.local/bin"
fish_add_path -a -g "$XDG_DATA_HOME/cargo/bin"
fish_add_path -a -g "$XDG_DATA_HOME/gem/ruby/3.1.0/bin"
fish_add_path -a -g "$XDG_CONFIG_HOME/emacs/bin"

# Make su launch fish
function su
   command su --shell=/usr/bin/fish $argv
end

#Source FNM
fnm env --use-on-cd | source

# Initialize Starship 
starship init fish | source
