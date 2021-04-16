# =============
# Completion
# =============

# forces zsh to realize new commands
zstyle ':completion:*' completer _oldlist _expand _complete _match _ignored _approximate

# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# rehash if command not found (possibly recently installed)
zstyle ':completion:*' rehash true

# menu if nb items > 2
zstyle ':completion:*' menu select=2

# don't show fzf unless there are more than 4 items
zstyle ':fzf-tab:*' ignore false 4

# =============
# Shell Options
# =============

setopt interactive_comments
setopt prompt_subst
setopt extended_glob
setopt long_list_jobs
setopt auto_cd
setopt menu_complete            # Auto pick a menu match

# Set history behavior
setopt append_history           # Dont overwrite history
setopt extended_history         # Also record time and duration of commands.
setopt hist_expire_dups_first   # Clear duplicates when trimming internal hist.
setopt hist_find_no_dups        # Dont display duplicates during searches.
setopt hist_ignore_dups         # Ignore consecutive duplicates.
setopt hist_ignore_space        # Ignore items that start with a space
setopt hist_reduce_blanks       # Remove superfluous blanks.
setopt hist_save_no_dups        # Omit older commands in favor of newer ones.
setopt share_history            # Share history across terminal sessions

# =============
# Evals
# =============

# https://www.iterm2.com/documentation-shell-integration.html
source ~/.iterm2_shell_integration.zsh

eval $(brew shellenv)

source `brew --prefix zinit`/zinit.zsh

if type rbenv > /dev/null; then
	eval "$(rbenv init -)"
fi

if type asdf > /dev/null; then
  source `brew --prefix asdf`/asdf.sh
fi

# Load ~/.exports, ~/.aliases, ~/.functions and ~/.extra
# ~/.extra can be used for settings you don’t want to commit
for file in exports aliases functions extra; do
  local file="$HOME/.$file"
  [ -e "$file" ] && source "$file"
done

# ========
# Plugins
# ========

source ~/.zsh_plugins

# ===========
# Keybindings
# ===========

# TODO cache completions https://callstack.com/blog/supercharge-your-terminal-with-zsh/
# TODO look into complist
autoload -Uz compinit compaudit
compinit

bindkey "^[[A" history-substring-search-up # Up
bindkey "^[[B" history-substring-search-down # Down

# match vscode's ^k functionality
bindkey "^K" kill-line

# open up current command in EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# save current command in buffer & restore after next command is run
# https://unix.stackexchange.com/a/74381
bindkey "^e" push-input

# ===========
# Misc Config
# ===========

# https://til.hashrocket.com/posts/7evpdebn7g-remove-duplicates-in-zsh-path
typeset -aU path

# https://github.com/ohmyzsh/ohmyzsh/issues/8743
# https://unix.stackexchange.com/questions/250690/how-to-configure-ctrlw-as-delete-word-in-zsh
autoload -U select-word-style
select-word-style bash
WORDCHARS='.-'

# https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/misc.zsh
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# stop autosuggesting after ^w or ^k is pressed
ZSH_AUTOSUGGEST_IGNORE_WIDGETS+=(backward-kill-word kill-line)

# =======================================
# zsh-autosuggest & bracketed-paste-magic
# =======================================

# copied from https://github.com/zsh-users/zsh-autosuggestions/issues/351#issuecomment-588235793
# hopefully this is fixed in zsh-autosuggest in the future

# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

# https://github.com/zsh-users/zsh-autosuggestions/issues/351
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(bracketed-paste)