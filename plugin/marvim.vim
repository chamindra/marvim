" MARVIM - MAcro Repository for VIM <marvim.vim>
" Macro and Template saving, lookup and launch script for VIM

" Load the script if it is needed. {{{
if exists("g:loaded_marvim")
    finish
endif
let g:loaded_marvim = 1
" script loading end }}}

" Set default values. {{{
if !exists('g:marvim_register')
    let g:marvim_register = 'q'
endif

if !exists('g:marvim_use_find_key')
    let g:marvim_use_find_key = v:true
endif

if !exists('g:marvim_find_key')
    let g:marvim_find_key = '<F2>'
endif

if !exists('g:marvim_use_store_key')
    let g:marvim_use_store_key = v:true
endif

if !exists('g:marvim_store_key')
    let g:marvim_store_key = '<F3>'
endif

if !exists('g:marvim_prefix')
    let g:marvim_prefix = 1
endif

" OS Specific configuration.
if has('win16') || has('win32') || has('win64') || has ('win95')
    let s:marvim_store = $HOME.'\marvim\' " Under your documents and settings
    let s:path_seperator = '\'
else " Assume UNIX based
    let s:marvim_store = $HOME."/.marvim/"
    let s:path_seperator = '/'
endif
if exists('g:marvim_store')
    if g:marvim_store[-1:] != s:path_seperator
        " Add a trailing directory slash if it does not exist.
        let g:marvim_store = g:marvim_store.s:path_seperator
    else
        let g:marvim_store = g:marvim_store
    endif
else
    let g:marvim_store = s:marvim_store
endif
" default values end }}}

" Set mappings. {{{
if g:marvim_use_store_key && !empty(g:marvim_store_key)
    execute 'nnoremap ' . g:marvim_store_key . ' :call marvim#macro_store()<CR>'
    execute 'vnoremap ' . g:marvim_store_key . ' y:call marvim#template_store()<CR>'
endif

if g:marvim_use_find_key && !empty(g:marvim_find_key)
    execute 'nnoremap ' . g:marvim_find_key . ' :call marvim#search()<CR>'
    execute 'vnoremap ' . g:marvim_find_key . ' :norm@'.g:marvim_register.'<CR>'
endif

if has('menu')
    menu &Macro.&Find :call marvim#search()<CR>
    nmenu &Macro.&Store\ Macro :call marvim#macro_store()<CR>
    vmenu &Macro.&Store\ Template y:call marvim#template_store()<CR>
    nmenu &Macro.&Store\ Template :call marvim#template_store()<CR>
endif
" mappings end. }}}

" Create default directory. {{{
if !isdirectory(g:marvim_store)
    " Need to strip end slash before call the mkdir function.
    call mkdir(strpart(g:marvim_store, 0 , strlen(g:marvim_store)-1), "p")
endif
" directory creation end. }}}
