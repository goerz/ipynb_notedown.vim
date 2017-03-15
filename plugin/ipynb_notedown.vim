" ipynb_notedown.vim:
" Plugin for editing Jupyter notebook (ipynb) files through notedown.
"
" Maintainer:   Michael Goerz <vimscripts@mail.michaelgoerz.net>
" URL:          https://michaelgoerz.net
" Script URL:   http://www.vim.org/scripts/script.php?script_id=5506
" Github:       https://github.com/goerz/ipynb_notedown.vim
" Last Change:  2016/12/26
" Version:      0.1.1
"
" Installation:
"    1. Copy the ipynb_notedown.vim script to your vim plugin directory (e.g.
"       $HOME/.vim/plugin).  Refer to ':help add-plugin', ':help
"       add-global-plugin' and ':help runtimepath' for more details about Vim
"       plugins.
"    2. Restart Vim.
"
" Usage:
"    When you open a Jupyter Notebook (*.ipynb) file, it is automatically
"    converted from json to markdown through the `notedown` utility
"    (https://github.com/aaren/notedown). Upon saving the file, the content is
"    converted back to the json notebook format.
"
"    The purpose of this plugin is to allow editing notebooks directly in vim.
"    The conversion json -> markdown -> json is relatively lossless, although
"    some of the restrictions of the `notedown` utility apply. In particular,
"    notebook and cell metadata are lost, and consecutive markdown cells are
"    merged into once cell
"
" Configuration:
"    The following settings in your ~/.vimrc may be used to configure the
"    plugin:
"
"    *  g:notedown_enable=1
"
"       You may disable the automatic conversion between the notebook json
"       format and markdown (i.e., deactivate this plugin) by setting this to
"       0.
"
"    *  g:notedown_code_match='all'
"
"       Value for the `--match` command line option of `notedown`.
"       There are known problems with using the value 'strict', but 'fenced'
"       may be a good alternative if you need code blocks in markdown.


" if plugin is already loaded then, not load plugin.
if exists("loaded_ipynb") || &cp || exists("#BufReadPre#*.ipynb")
    finish
endif
let loaded_ipynb = 1


" configuration
if !exists('g:notedown_enable')
    let g:notedown_enable = 1
endif
if !exists('g:notedown_code_match')
    let g:notedown_code_match = 'all'
endif


" set autocmd
augroup ipynb
    " Remove all ipynb autocommands
    au!

    autocmd BufReadPre,FileReadPre      *.ipynb    setlocal bin
    autocmd BufReadPost,FileReadPost    *.ipynb    call s:read_ipynb_json()
    autocmd BufWritePost,FileWritePost  *.ipynb    call s:write_ipynb_json()

augroup END


" Function to check that 'notedown' is available
" The result is cached in s:have_notedown for speed.
fun s:check_notedown()
    if !exists("s:have_notedown")
        let e = executable("notedown")
        if e < 0
            let r = system("notedown");
            let e = (r !~ "not found" && r != "")
        endif
        exe "let s:have_notedown=" . e
    endif
    exe "return s:have_notedown"
endfun


" after reading ipynb file, convert to markdown
fun s:read_ipynb_json()
    if !g:notedown_enable
        return
    endif
    if !s:check_notedown()
        echoerr("notedown not available. Install with `pip install notedown`")
        return
    endif
    " make 'patchmode' empty, we don't want a copy of the written file
    let pm_save = &pm
    set pm=
    " remove 'a' and 'A' from 'cpo' to avoid the alternate file changes
    let cpo_save = &cpo
    set cpo-=a cpo-=A
    " set 'modifiable'
    let ma_save = &ma
    setlocal ma

    " when filtering the whole buffer, it will become empty
    let empty = line("'[") == 1 && line("']") == line("$")

    let tmp = tempname()
    let tmpe = tmp . "." . expand("<afile>:e")

    " write the just read lines to a temp file
    execute "silent '[,']w " . tmpe

    " convert tmpe to text file
    let r =  system("notedown \"" . tmpe .
    \               "\" --from notebook --to markdown > \"" . tmp . "\"")
    if (r != "")
        echom r
        return
    endif

    " delete the compressed lines; remember the line number
    let l = line("'[") - 1
    if exists(":lockmarks")
        lockmarks '[,']d _
    else
        '[,']d _
    endif

    " read in the uncompressed lines "'[-1r tmp"
    setlocal bin
    if exists(":lockmarks")
        execute "silent lockmarks " . l . "r " . tmp
    else
        execute "silent " . l . "r " . tmp
    endif

    " if buffer became empty, delete trailing blank line
    if empty
        silent $delete _
        1
    endif
    " delete the temp file and the used buffers
    call delete(tmp)
    call delete(tmpe)
    silent! exe "bwipe " . tmp
    silent! exe "bwipe " . tmpe
    let &pm = pm_save
    let &cpo = cpo_save
    let &l:ma = ma_save
    " When uncompressed the whole buffer, do autocommands
    if empty
        if &verbose >= 8
            execute "doau BufReadPost " . expand("%:r")
        else
            execute "silent! doau BufReadPost " . expand("%:r")
        endif
    endif
endfun


" after writing file, convert back to ipynb json.
fun s:write_ipynb_json()
    if (!g:notedown_enable)
        return
    endif
    if !s:check_notedown()
        echoerr("notedown not available")
        return
    endif
    let nm = expand("<afile>")
    let nmt = tempname()
    if rename(nm, nmt) == 0
        let r = system("notedown --from markdown --to notebook --match=" .
        \              g:notedown_code_match . " \""  . nmt . "\" > \"". nm
        \              . "\"")
        if (r != "")
            echom r
        endif
        call rename(nmt . "." . expand("<afile>:e"), nm)
    endif
endfun

" vim: set sw=4 :
