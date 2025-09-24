
[ -f ~/.shrc ] && source ~/.shrc

# plugin
if [ -e ~/.zinit/bin/zinit.zsh ]; then
  source ~/.zinit/bin/zinit.zsh
  autoload -Uz _zinit
  (( ${+_comps} )) && _comps[zinit]=_zinit
  zinit light zsh-users/zsh-syntax-highlighting
  zinit light zsh-users/zsh-autosuggestions
  zinit light zsh-users/zsh-completions
  zinit light chrissicool/zsh-256color

  # plugin settings
  # zsh-syntax-highlighting
  typeset -A ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=cyan'
fi

# complete
setopt CORRECT
setopt COMPLETE_IN_WORD
setopt LIST_PACKED
[ -e ~/.zsh_completions.local.zsh ] && source ~/.zsh_completions.local.zsh
autoload -U compinit && compinit
autoload -U +X bashcompinit && bashcompinit
zstyle ':completion:*:default' menu select=1
zstyle ':completion::complete:*' use-cache true
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
bindkey "^P" history-beginning-search-backward
bindkey "^N" history-beginning-search-forward

# color
if [ -e /etc/DIR_COLORS ]; then
  eval `dircolors /etc/DIR_COLORS`
fi
autoload -U colors && colors
zstyle ':completion:*' list-colors "${LS_COLORS}"

# history
export HISTFILE=~/.zsh_history
export SAVEHIST=100000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt EXTENDED_HISTORY

# git
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
zstyle ':vcs_info:git:*' formats '%F{039}%b%f' # Use any powerline font such as 'Ricty for Powerline'.
zstyle ':vcs_info:*' actionformats '[%F{039}%b%f|%a]'

# alias
export LSCOLORS=gxfxcxdxbxegedabagacad
# Prompt
setopt PROMPT_SUBST
#for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
PROMPT="\$vcs_info_msg_0_:%F{050}%~%f❯ "

[ -f ~/.zshrc.local ] && source ~/.zshrc.local
[ -f ~/.functions.sh ] && source ~/.functions.sh
[ -f ~/.completions.zsh ] && source ~/.completions.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
