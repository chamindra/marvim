# MARVIM - MAcro Repository for VIM

## Justification
Helps us VIM users to store complex VIM macros and templates into persistent
storage for future search and load.

## Features
* Recording of VIM macros into persistent storage for future use
* Auto-complete based recursive search and load of stored VIM macros
* Visually select and save templates into persistent storage
* Macro name-spaces, to permit organization of macros
* Support for a default namespace based on filetype
* Supports a shared macro repository for a team on a shared directory
* Macro menu items in GVIM version for all main actions

## Installation

### Vundle
Add this to your Vundle configuration:
``` vim
Plugin 'chamindra/marvim'
```

#### Pathogen
Add this to your pathogen configuration:
``` vim
git clone https://github.com/chamindra/marvim.git ~/.vim/bundle/marvim
```

### Manual
* Download the plugin
    * For neovim or vim 8 and above:
        * Clone the repository into the plugin directory. Example for such directory
            is:
        ```bash
        ~/.vim/pack/bundle/start/marvim
        ```
        You can change parts of the name of the directory, or parts of its path.
        You can read more about this directory
        [here](https://vi.stackexchange.com/questions/613/how-do-i-install-a-plugin-in-vim-vi)
        and in vim's help on packages.
    * For vim before 8:
        * Clone the repository into the plugins directory in your home:
          ```bash
          ~/.vim/plugin
          ```
        * Note that this make the plugin always load all its files. It will
            probably won't affect you (since it is small), but if you want it to
            load the relevant parts only when needed, you will need to separate
            the repository. Put any file in the repository in a directory with
            the same name in the ~/.vim directory.
            For example:
            ```bash
            mkdir -p ~/.vim/autoload
            mv $MARVIM_DIRECTORY/autoload/marvim.vim ~/.vim/autoload
            ```
            (if you are starting to do this, it is probably bettor to download
            one of the plugin manegers plugin (like Vundle or Pathogen).

* Start vim and this will automatically create the base marvim macro
  repository in your home directory. Based on the OS it will be
  located as follows:

  UNIX      ~/.marvim
  WINDOWS   C:\Document and Settings\Username\marvim

  (This can be configured, see below for details).

* (optional) Copy predefined macro/template directories into the base
  marvin macro directory. Marvim uses recursive directory search so
  you can nest the directories as you wish.

* (optional) if you want to change the default hotkeys see below

## Hotkeys
    <F2>        - Find and execute a macro or insert template from repository
    Visual <F2> - Replays last macro for each line selected
    <F3>        - Save default macro register by name to the macro repository
    Visual <F3> - Save selection as template by name to the macro repository
    <Tab>       - On the Macro command line for cycling through autocomplete
    <Control>+D - On the Macro command line for listing autocomplete options

## Usage:
* Store a new macro to the repository
    1. Record macro as usual into q register (i.e. qq..<macro keystrokes>..q)
    2. Press save macro key <kbd>F3</kbd> (default) in normal mode
    3. Enter the macro name when prompted after the prefix (a prefix will be
       provided based on the filetype)
    4. Macro is now store in the repository

* Save template into repository
    1. Select area you want to save in visual mode
    2. Press the macro save button <kbd>F3</kbd> (default) in visual mode
    3. Enter the template name when prompted (a prefix will be provided based
       on the filetype)
    4. Template is now saved in repository

* Recall macro/template through a search
    1. Press the macro find key <kbd>F2</kbd> (default) in normal mode
    2. Enter a search string when prompted (a prefix will be put by default,
       Which can be deleted)
    3. Press <Tab> or <Control-D> to auto-complete until you find the macro
    4. Macro is now run and also loaded for further use into the q register

* Replay last loaded macro on multiple lines for each line
    1. Select the area you want the macro to run on in visual mode
    2. Press the macro find key <kbd>F3</kbd> (default) in visual mode
    3. Macro in q register is replayed for every line

## Macro Namespace:
You can organize the macros by a namespace. To save a macro in the name
space X, simply us X:macro_name when saving the macro. This will create
a sub-directory called X in your marvim repository as save this macro there
You can also create namespaces by putting a collection of macros in a
sub-directory of the marvim repository. This will permit you to organize
your macros accordingly

## Changing the default hotkeys, repository and macro register
Optionally place the following lines in your vimrc before the location
you source the marvim.vim script (don't worry about location if
the script is in the vim plugin directory or you used one of the plugin manager
plugins).

``` vim
let g:marvim_store = '/usr/local/.marvim' " change store place.
let g:marvim_find_key = '<Space>' " change find key from <F2> to 'space'
let g:marvim_store_key = 'ms'     " change store key from <F3> to 'ms'
let g:marvim_register = 'c'       " change used register from 'q' to 'c'
let g:marvim_prefix = 0           " disable default syntax based prefix

source $HOME/marvim.vim   " omit if marvim.vim is in the plugin dir
```

## Tips
* Spacebar can be very effective as the macro find key
* use the namespaces to organize a directory for each language
* use a naming convention for your macros to make it easy to find. E.g.:

  php:if-block
  php:strip-tags
  php:mysql-select-block
  php:mysql-update-block

* if multiple people are working on the same project, consider a shared
  marvim store to share templates and macros to improve team
  productivity

* share your marvim marco stores with each other and also with the
  central repository at the plugin in github.

* You can use wildcards for macros names (when searching for them). It can
  let you type only part of the macro file name. For info on the wildcards
  See |wildcards| for the use of special characters.

## Bugs, Patches, Help and Suggestions
If you find any bugs, have new patches or need some help, please open an issue
at the [repository at github](https://github.com/chamindra/marvim) or send an
email to chamindra [at] gmail.com and put the word marvim in the subject
line. Also we welcome you to share your repositories.

"Freeze? I'm a robot, not a refrigerator" - Marvin the Paranoid Android

## Change Log

### v0.5 Beta
* Refactorted to support latest plugin format of VIM 8
* Added help files and changed the readme to be markdown
* Fixed issues with files with multiple dots in them and other fixes
* You can now pull plugin from github chamindra/marvim
* Special kudos to @omrisarig13 for VIM 8 plugin refactor 
### v0.4
* Now supports autocompletion when searching for macros
* The filetype gives the default namespace for storage and retrieval
* Refactoring of functions for namespace to directory mappings
### v0.3
* New namespace features for macro that map to macro sub-directories
* Supported the creation of macros and templates in a namespace
* Creates namespace directories if they do not exist
* Added the ability to point to a different macro store
* The above permits a shared macro/template repository within a team
* Refactored code to make macro and template saving a function
* Fixed bug on windows listing of macros without whole path name
### v0.2
* Made script windows compatible
* Makes the macro home directory if it does not exist
* Recursively looks up base repository sub-directories for macros
* Creates a macro menu for the GUI versions
* Changed default macro input register to q
* Made it easy to define configuration details in vimrc
* Abstracted hotkeys so that they can be defined in the vimrc easily
* Fixed the breaking on spaces in directory paths
* Changed template extension to mvt for ease
* Changed naming conventions to avoid namespace conflict
### v0.1
* Platform independent script (almost ;-)
* recording of vim version with macro
* redefinition of macro_home and macro_register
