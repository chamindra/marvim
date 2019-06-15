" MARVIM - MAcro Repository for VIM <marvim.vim>
" Macro and Template saving, lookup and launch script for VIM
"
" Script Info and Documentation  {{{
"=========================================================================
"    Copyright: Copyright (C) 2007 & 2008 Chamindra de Silva
"      License: GPL v2
" Name Of File: marvim.vim
"  Description: MAcro Repository Vim Plugin
"   Maintainer: Chamindra de Silva <chamindra@gmail.com>
"          URL: http://chamindra.googlepages.com/marvim
"  Last Change: 2008 Sep 28
"      Version: 0.4 Beta
"
"        Usage:
"
" Installation:
" -------------
"
" o Download Marvim to your VIM plugin ($VIMRUNTIME/plugin) directory
"   or source it explicity. Below is an example if you place it in
"   the home directory
"
"   source $HOME/marvim.vim
"
" o Start vim and this will automatically create the base marvim macro
"   repository in your home directory. Based on the OS it will be
"   located as follows:
"
"   LINUX     ~/.marvim
"   WINDOWS   C:\Document and Settings\Username\marvim
"   MAC OSX   ~/.marvim
"
" o (optional) Copy predefined macro/template directories into the base
"   marvin macro directory. Marvim uses recursive directory search so
"   you can nest the directories as you wish.
"
" o (optional) if you want to change the default hotkeys see below
"
" Hotkeys:
" --------
" <F2>        - Find and execute a macro or insert template from repository
" Visual <F2> - Replays last macro for each line selected
" <F3>        - Save default macro register by name to the macro repository
" Visual <F3> - Save selection as template by name to the macro repository
" <Tab>       - On the Macro command line for cycling through autocomplete
" <Control>+D - On the Macro command line for listing autocomplete options
"
" Usage:
" ------
" o Store a new macro to the repository
"
" 1)  record macro as usual into q register
"     (i.e. qq..<macro keystrokes>..q)
" 2)  press save macro key <F3> (default) in normal mode
" 3)  enter the macro name when prompted after the prefix
"     (a prefix will be provided based on the filetype)
" 4)  macro is now store in the repository
"
" o Save template into repository
"
" 1)  select area you want to save in visual mode
" 2)  press the macro save button <F3> (default) in visual mode
" 3)  enter the template name when prompted
"     (a prefix will be provided based on the filetype)
" 4)  template is now saved in repository
"
" o Recall macro/template through a search
"
" 1)  press the macro find key <F2> (default) in normal mode
" 2)  enter a search string when prompted
"     (a prefix will be put by default, which can be deleted)
" 3)  press <tab> or <Control-D> to auto-complete until you find the macro
" 4)  macro is now run and also loaded for further use into the q register
"
" o Replay last loaded macro on multiple lines for each line
"
" 1)  select the area you want the macro to run on in visual mode
" 2)  press the macro find key <F3> (default) in visual mode
" 3)  macro in q register is replayed for every line
"
" Macro Namespace:
" ----------------
" You can organize the macros by a namespace. To save a macro in the name
" space X, simply us X:macro_name when saving the macro. This will create
" a subdirectory called X in your mavim repository as save this macro there
" You can also create namespaces by putting a collection of macros in a
" subdirectory of the mavim repository. This will permit you to organize
" your macros accordingly
"
" Changing the default hotkeys, repository and macro register:
" ------------------------------------------------------------
" Optionally place the following lines in your vimrc before the location
" you source the marvim.vim script (don't worry about location if
" the script is in the vim plugin directory).
"
"   " to change the macro storage location use the following
"   let marvim_store = '/usr/local/share/projectX/marvim'
"   let marvim_find_key = '<Space>' " change find key from <F2> to 'space'
"   let marvim_store_key = 'ms'     " change store key from <F3> to 'ms'
"   let marvim_register = 'c'       " change used register from 'q' to 'c'
"   let marvim_prefix = 0           " disable default syntax based prefix
"
"   source $HOME/marvim.vim   " omit if marvim.vim is in the plugin dir
"
" Tips:
" -----
"  o <Space> can be very effective as the macro find key
"  o use the namespaces to organize a directory for each language
"  o use a naming convention for your macros to make it easy to find. e.g.:
"
"    php:if-block
"    php:strip-tags
"    php:mysql-select-block
"    php:mysql-update-block
"
"  o if multiple people are working on the same project, consider a shared
"    marvim store to share templates and macros to improve team
"    productivity
"
"  o share your marvim marco stores with each other and also with the
"    central repository at http://chamindra.googlepages.com/marvim
"
" Bugs, Patches, Help and Suggestions:
" ------------------------------------
" If you find any bugs, have new patches or need some help, please send
" and email to chamindra [at] opensource.lk and put the word marvim in the
" subject line. Also we welcome you to share your repositories.
"
" Freeze? I'm a robot, not a refrigerator" - Marvin the Paranoid Android
" http://chamindra.googlepages.com/marvim
"
" Change Log:
" -----------
" v0.4
" - Now supports autocompletion when searching for macros
" - The filetype gives the default namespace for storage and retrival
" - Refactoring of functions for namespace to directory mappings
" v0.3
" - New namespace features for macro that map to macro sub-directories
" - Supported the creation of macros and templates in a namespace
" - Creates namespace directories if they do not exist
" - Added the ability to point to a different macro store
" - The above permits a shared macro/template repository within a team
" - Refactored code to make macro and template saving a function
" - Fixed bug on windows listing of macros without whole path name
" v0.2
" - Made script windows compatible
" - Makes the macro home directory if it does not exist
" - Recursively looks up base repository subdirectories for macros
" - Creates a macro menu for the GUI versions
" - Changed defauly macro input register to q
" - Made it easy to define configuration details in vimrc
" - Abstracted hotkeys so that they can be defined in the vimrc easily
" - Fixed the breaking on spaces in directory paths
" - Changed template extension to mvt for ease
" - Changed naming conventions to avoid namespace conflict
" v0.1
" - Platform independant script (almost ;-)
" - recording of vim version with macro
" - redefinition of macro_home and macro_register
"
"=============================================================================
" }}}
" TODOs: {{{
" * Add a specific option for calling up templates or macros separately.
" * Before running over already exists template/macro, ask the user for
"   conformation.
" * If there are template file and macro file with the same name, the macro file
"   will always be used. Add a conformation there as well.
" * Add better explanation about what are templates.
" * check vim version number when running macro
" * Add flags about whether the plugin should work for macros only, templates
"   only, or both.
" }}}

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

if !exists('g:marvim_find_key')
    let g:marvim_find_key = '<F2>'
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
execute 'nnoremap ' . g:marvim_store_key . ' :call marvim#macro_store()<CR>'
execute 'vnoremap ' . g:marvim_store_key . ' y:call marvim#template_store()<CR>'
execute 'nnoremap ' . g:marvim_find_key . ' :call marvim#search()<CR>'
execute 'vnoremap ' . g:marvim_find_key . ' :norm@'.g:marvim_register.'<CR>'

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
