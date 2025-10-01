# History
set history save on
set history size 10000
set history filename ~/.gdb_history

# Show
set listsize 25
set print elements 0
set print demangle on
set print asm-demangle on

# Paging
set pagination off

# Aliases
alias -a ia = info args
alias -a ib = info b
alias -a ifi = info files
alias -a ifr = info frame
alias -a il = info locals
alias -a it = info threads
alias -a lo = layout

# Log
set logging file gdb.txt
python
import gdb
import datetime
now = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
gdb.execute(f"set logging file {now}.gdb.txt")
end
set logging enabled on
set trace-commands on

define hook-quit
    set confirm off
end
