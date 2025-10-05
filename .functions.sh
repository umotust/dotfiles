function bm() {
  local URL=$(${DEVEL_PATH}/python/parse_plist_bookmark.py \
    | fzf \
    | ggrep -Eo "\"http.*\"" \
    | sed 's/"//g')
  [ -z $URL ] && return || open $URL
}

# TODO: query
function his() {
  local URL=$(sqlite3 ~/Library/Safari/History.db < <(echo \
    'select distinct items.visit_count,items.url, visits.title ' \
      'from history_items as items ' \
        'inner join history_visits as visits ' \
        'on items.id = visits.history_item ' \
        'order by items.visit_count') \
    | sort -n -k1n,1 -k2 \
    | fzf --tac --no-sort)
  [ -z $URL ] && return || open $URL
}

function cdd() {
  cd "$DEVEL_PATH/$1"
}

function cddc() {
  cd ~/Documents/$1
}

function cddw() {
  cd ~/Downloads/$1
}

function cdpc() {
  cd ~/Pictures/$1
}

function clipboard() {
  cat ${1} | pbcopy
}

function iploc() {
  curl -s http://ip-api.com/json/${1}
}

function dsh() {
  # Ex. pdsh -w 'server-[0,1,2]' ${@} | dshbak
  pdsh ${@} | dshbak
}

function sshf() {
  HOST=$(grep "Host " ~/.ssh/config | awk '{print $2}' | fzf)
  [ -z $HOST ] && return || bash -cx "ssh ${@} $HOST"
}

function trw() {
  tmux rename-window ${@}
}

function weather() {
  curl wttr.in/$@
}

function mac() {
  # $1: MAC address
  curl https://www.macvendorlookup.com/api/v2/${1}
}
