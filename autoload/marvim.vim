" Global variables {{{
" specify macro extension by major vim version number
let s:macro_file_extension = '.mv'.strpart(v:version,0,1)
" template extension
let s:template_extension = '.mvt'
" The path separator for the specific OS.
if has('win16') || has('win32') || has('win64') || has ('win95')
    let s:path_seperator = '\'
else " Assume UNIX based
    let s:path_seperator = '/'
endif
" }}}

" Functions {{{
" Function: s:input {{{
" @brief: Get input from the user, start it with the filetype if needed.
" @param prompt: The prompt to use for the input.
" @returns: The input got from the user.
function! s:input(prompt)

    " use a default prefix by filetype unless it has been disabled
    if ( &filetype == '' || !g:marvim_prefix )
        let l:namespace = ''
    else
        let l:namespace = &filetype.':'
    endif

    " get the input with custom autocompletion
    return input(a:prompt, l:namespace, "customlist,marvim#completion")

endfunction
" s:input end }}}

" Function: s:get_directory {{{
" @brief: Get the directory name of the full file path without last slash
" @param full_file_name: The full name of the file.
" @returns: The directory name of the file, without its last slash.
function! s:get_directory(full_file_name)

    let l:lastslash = strridx(a:full_file_name, s:path_seperator)

    return strpart( a:full_file_name, 0, l:lastslash)

    return l:dirname

endfunction
" s:get_directory end }}}

" Function: s:get_filename {{{
" @brief: Get the file name from the directory path
" @param full_file_name: The full path to the file.
" @returns: Only the file name itself, without any precedes directory.
function! s:get_filename(full_file_name)

    let l:lastslash = strridx(a:full_file_name, s:path_seperator)

    let l:filename = strpart( a:full_file_name, l:lastslash+1)

    return l:filename

endfunction
" s:get_filename end }}}

" Function: s:ns_to_filenames {{{
" @brief: Get the file paths from the marvim path syntax.
" @description: This function would change any ':' in the file name to the
"  regular OS separator, to make the string a valid file name string. Later, it
"  would add the marvim base directory to it, and add the needed extension. For
"  example, it would change the string of "php:deletebrackets" to be
"  "/home/user/.marvim/php/deletebrackets.mvt"
" @param marvim_path: The string used in marvim to represent the file path.
"  E.g. php:deletebrackets
" @returns: A list with all the file paths that matches the given pattern. In
"  case there won't be any matching files the list would be empty.
function! s:ns_to_filenames(marvim_path)

    let l:name = s:to_os_path(a:marvim_path)

    let l:prefix = g:marvim_store . l:name

    return glob(l:prefix.".mv?", v:false, v:true)

endfunction
" s:ns_to_filenames end }}}

" Function: s:save_file {{{
" @brief: Save the macro/template file to the disk.
" @description: Write the data into a file by the given name. It would
"  add the extension to the file name, and use the binary write flags
"  accordingly.
" @param file_path: The full name of the file to write.
" @param data: The data to write to the given file.
" @param extension: The extension of the file.
" @returns: None
function! s:save_file(file_path, data, extension)

    " Set the variables of the function.
    let l:name = s:to_os_path(a:file_path)
    let l:full_file_name = g:marvim_store . l:name . a:extension
    let l:dirname = s:get_directory(l:full_file_name)

    " Create a new directory in case it is needed for the new file.
    if !isdirectory(l:dirname)

        call mkdir (l:dirname, "p")

    endif

    " Write the file to the disk.
    if ( a:extension == s:macro_file_extension ) " if this is a macro

        call writefile(a:data, l:full_file_name, 'b')

    else " else if it a template
        call writefile(a:data, l:full_file_name)
    endif

endfunction
" s:save_file end }}}

" Function: s:run_file {{{
" @brief: Run the macro/template file.
" @description: Get the name of the macro/template file and run it. For macro
"  files, this function would load them into the wanted register, and run them
"  in the current file. For template files, this function would paste the
"  template content into the current file.
" @param file_name: The name of the file to run.
" @returns: One of those values, according to the function action:
"   0 - When the file is not readable.
"   1 - When the file is a valid macro file.
"   2 - When the file is a valid template file.
"   3 - The file has unknown extension.
function! s:run_file(file_name)

    " If the file does not exist or is not readable return
    let l:is_readable = filereadable(a:file_name)
    if (!l:is_readable)
        return 0
    endif

    " Get the file type for the current macro.
    let l:macro_type = split(a:file_name, '\.')[-1]

    " Run the file according to its type.
    if l:macro_type == s:macro_file_extension[1:]

        " read the macro file into the register and run it
        let l:macro_content = readfile(a:file_name,'b')
        call setreg(g:marvim_register, l:macro_content[0])
        silent execute 'normal @' . g:marvim_register
        return 1

    elseif l:macro_type == s:template_extension[1:]

        silent execute 'read ' . a:file_name
        return 2

    else

        return 3

    endif

endfunction
" s:run_file end }}}

" Function: s:new_line_echom {{{
" @brief: Echom the message in a new line.
" @param message: The message to echo.
" @returns: None.
function! s:new_line_echom(message)

    " The only function to clear the command is to run redraw, which would
    " redraw the whole screen. To avoid it and set only this window, run this
    " patch which would remove any message from there.
    normal! :<esc>
    echom a:message

endfunction
" s:new_line_echom end }}}

" Function: s:to_os_path {{{
" @brief: Change the ':' in the file name to be the line separator.
" @param marvim_path: The path in the marvim format.
" @returns: The path in the OS specific format.
" @note: This is a very simple function, but it it used in many different
"  places in the code, so it better be a function by itself.
function! s:to_os_path(marvim_path)

    return tr(a:marvim_path, ":", s:path_seperator)

endfunction

" s:to_os_path end }}}

" Function: s:list_decide {{{
" @brief: Let the user choose its wanted entry from the given list.
" @param to_choose_from: The list to choose the given entry from.
" @returns: The entry chosen from the list.
" @note: This function gets input from the user, and it would wait for it.
" @note: In case the list would be empty, the function would return empty
"  string.
function! s:list_decide(to_choose_from)

    " Handle the special cases of empty or single-entry list.
    if empty(a:to_choose_from)
        return ''
    endif
    if len(a:to_choose_from) == 1
        return a:to_choose_from[0]
    endif

    " Print the list for the user.
    echo "\nMore than one macro available."
    echo "Available macros:"
    let l:index = 0
    for l:item in a:to_choose_from
        let l:message = "[" . string(l:index) . "] - " . string(l:item)
        echo l:message
        let l:index += 1
    endfor

    " Get the user wanted input.
    let l:user_decision = input("Enter wanted macro (empty to cancel): ")
    if empty(l:user_decision)
        return ''
    endif

    let l:wanted_macro = get(a:to_choose_from, l:user_decision, '')

    " Check if the entry is valid and return the wanted input.
    if empty(l:wanted_macro)
        call s:new_line_echom("Invalid macro index. No macro run")
        return ''
    endif

    return l:wanted_macro

endfunction
" s:list_decide end }}}

" Function: marvim#completion {{{
" @brief: Custom completion function for s:input().
" @description: This function completes the names of the possible macros and
"  templates in the filesystem.
" @param ArgLead: The current data to complete.
" @param CmdLine: The current data to complete.
" @param CursorPos: The position of the cursor in the line.
" @returns: A list with all the possible completions.
function! marvim#completion(ArgLead, CmdLine, CursorPos)

    let l:c_list = []  " initialize list
    let l:file_name = s:to_os_path(a:ArgLead)
    let l:search_dir = s:get_directory(g:marvim_store.l:file_name)
    let l:search_string = s:get_filename(g:marvim_store.l:file_name)

    " Recursively search in the namespace directory to get all files
    let l:search_list_as_string = glob(l:search_dir.s:path_seperator.'**')

    let l:search_list = split(l:search_list_as_string, '\n')

    " Filter by the macro extension .mv?
    let l:macro_list = filter(l:search_list, 'v:val =~ ".mv"')

    " Translate each item to the namespace version.
    for l:item in l:macro_list

        " Get the filename.
        let l:file_split = strpart(l:item, strlen(g:marvim_store))
        let l:filename = tr(l:file_split, s:path_seperator, ":")

        " Remove trailing extension.
        let l:name_split = split (l:filename, '\.')
        " This line was created to handle the special case of multiple dots in
        " the file name.
        let l:name_split = join(l:name_split[:-2], '.')

        " Add the item to the complete list.
        call add(l:c_list, l:name_split)

    endfor

    " filter namespace list on post fix search string
    let l:complete_list = filter(l:c_list, 'v:val =~ "'.l:search_string.'"')

    return l:complete_list

endfunction
" marvim#completion end }}}

" Function: marvim#template_store {{{
" @brief: Save a visually selected text as a template for later use.
" @returns: None
" @note: assumes that the template is stored in the default register.
function! marvim#template_store()

    " Get default yank buffer.
    let l:listtmp = split(@@,'\n')

    " Get the name of the template.
    let l:template_name = s:input('Enter Template Save Name -> ')
    let l:template_path = s:to_os_path(l:template_name)
    if empty(l:template_name) || empty(s:get_filename(l:template_path))
        call s:new_line_echom("Template name wasn't specify, not creating template.")
        return
    endif

    " Save the new template.
    call s:save_file(l:template_name, l:listtmp, s:template_extension)
    call s:new_line_echom('Template '.l:template_name.' Stored')

endfunction
" marvim#template_store end }}}

" Function: marvim#macro_store {{{
" @brief: Store a new macro in the macro repository.
" @description: Ask for user input for the name of the macro, and save the
"  content of register g:marvim_register in a file by that name.
" @returns: None
function! marvim#macro_store()

    " Get the name of the macro. Continue only if there is a name.
    let l:macro_name = s:input('Enter Macro Save Name -> ')
    let l:macro_path = s:to_os_path(l:macro_name)
    if empty(l:macro_name) || empty(s:get_filename(l:macro_path))
        call s:new_line_echom("Macro name wasn't specify, not creating macro.")
        return
    endif

    " Get the data macro from the register. Continue only if there is data in
    " the specify register.
    let l:macro_data = [getreg(g:marvim_register)]
    if l:macro_data[0] == ""
        call s:new_line_echom("Macro's register empty, not creating macro.")
        return
    endif

    " Save the file and output success massage.
    call s:save_file(l:macro_name, l:macro_data, s:macro_file_extension)
    call s:new_line_echom('Macro ' . l:macro_name . ' Stored')

endfunction
" marvim#macro_store end }}}

" Function: marvim#search {{{
" @brief: Search for a new macro/template in the repository.
" @description: Get the name of the macro/template file from the user and try
"  to run it. This function uses the input function to get input from the user.
" @returns: None.
" @note This function prints the result back to the user.
function! marvim#search()

    " Get the input.
    let l:macro_name = s:input('Macro Search -> ')

    " Try to run the given input. Output the results to the user.
    if !empty(l:macro_name)

        let l:macro_files = s:ns_to_filenames(l:macro_name)
        if empty(l:macro_files)

            call s:new_line_echom('Macro ' . l:macro_name . ' does not exist.')

        else

            let l:macro_file = s:list_decide(l:macro_files)

            if !empty(l:macro_file)
                let l:run_file_return = s:run_file(l:macro_file)
                if (l:run_file_return == 1)
                    call s:new_line_echom('Macro ' . l:macro_file . ' Run')
                elseif (l:run_file_return == 2)
                    call s:new_line_echom('Template ' . l:macro_file . ' Run')
                elseif (l:run_file_return == 3)
                    call s:new_line_echom('Got file with invalid extension.')
                endif
            endif

        endif

    else
        call s:new_line_echom('No macro name specify, not runnig anything.')
    endif

endfunction
" marvim#search end }}}

" Functions end }}}
