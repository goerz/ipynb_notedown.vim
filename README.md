# ipynb_notedown.vim

vim plugin for editing jupyter notebook (ipynb) files through [notedown][1].

<http://www.vim.org/scripts/script.php?script_id=5506>


## Installation ##

1. Copy the `ipynb_notedown.vim` script to your vim plugin directory (e.g.
   `$HOME/.vim/plugin`).  Refer to `:help add-plugin`,
   `:help add-global-plugin` and `:help runtimepath` for more details about
   Vim plugins.
2. Restart Vim.


## Usage ##

When you open a Jupyter Notebook (`*.ipynb`) file, it is automatically
converted from json to markdown through the [`notedown` utility][1]. Upon saving
the file, the content is converted back to the json notebook format.

The purpose of this plugin is to allow editing notebooks directly in vim.
The conversion json → markdown → json is relatively lossless, although
some of the restrictions of the `notedown` utility apply. In particular,
notebook and cell metadata are lost, and consecutive markdown cells are
merged into once cell.


## Configuration ##

The `--match` command line option of `notedown` is specified by the value
of the variable `g:notedown_code_match`, which you may set in your `.vimrc`
file. It defaults to 'all'. There are known problems with using the value
'strict', but e.g.

    g:notedown_code_match='fenced'

may be a good alternative if you need code blocks in markdown.

[1]: https://github.com/aaren/notedown
