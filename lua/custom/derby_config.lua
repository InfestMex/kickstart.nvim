local java_home = os.getenv 'JAVA_HOME'
local java_bin = java_home and (java_home .. '/bin/java.exe') or 'java'
local derby_jar = 'C:/DEV_HOME/TOOLS/db-derby-10.17.1.0-bin/lib/derbyrun.jar'

-- 1. Main Command Construction
vim.cmd(string.format(
  [[
  function! DerbyAdapterMain(url)
    let l:user = matchstr(a:url, 'derby://\zs[^:]*\ze:')
    let l:pass = matchstr(a:url, 'derby://[^:]*:\zs[^@]*\ze@')
    let l:db_path = substitute(a:url, '^derby://[^@]*@', 'jdbc:derby:', '')

    let l:cmd =['%s', 
          \ '-Djdbc.drivers=org.apache.derby.jdbc.EmbeddedDriver',
          \ '-Dij.showNoConnections=true']
    
    if !empty(l:user)
      call add(l:cmd, '-Dij.user=' . l:user)
      call add(l:cmd, '-Dij.password=' . l:pass)
    endif

    call add(l:cmd, '-Dij.database=' . l:db_path)
    call extend(l:cmd,['-jar', '%s', 'ij'])
    
    return l:cmd
  endfunction
]],
  java_bin,
  derby_jar
))

-- 2. Dadbod Registration
vim.g.db_adapter_derby = 'DerbyAdapter'

vim.cmd [[
  " Used for starting an interactive console (:DB without a query)
  function! DerbyAdapterinteractive(url, ...)
    return DerbyAdapterMain(a:url)
  endfunction

  " Used for piping non-interactive queries (e.g., visual selection or :DB <query>)
  function! DerbyAdapterfilter(url, ...)
    return DerbyAdapterMain(a:url)
  endfunction

  " Dadbod hook to format/modify the query string before it is piped
  function! DerbyAdaptermassage(input, ...)
    let l:query = type(a:input) == type([]) ? join(a:input, "\n") : a:input
    
    " 1. Derby requires every statement to end with a semicolon
    if l:query !~# ';\s*$'
      let l:query .= ';'
    endif
    
    " 2. Force ij to exit after running the query, preventing hangs
    let l:query .= "\nexit;\n"
    
    return l:query
  endfunction

  " Used by vim-dadbod-ui for the sidebar
  function! DerbyAdapterlist_objects(url, ...)
    return "SELECT tablename FROM sys.systables WHERE tabletype = 'T';"
  endfunction
]]
