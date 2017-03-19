# ipynb_notedown.vim

[Vim][1]/[Neovim][2] plugin for editing [Jupyter notebook][3] (ipynb) files
through [notedown][4].

<http://www.vim.org/scripts/script.php?script_id=5506>


## Installation ##

1. Copy the `ipynb_notedown.vim` script to your vim plugin directory (e.g.
   `$HOME/.vim/plugin`).  Refer to `:help add-plugin`,
   `:help add-global-plugin` and `:help runtimepath` for more details about
   Vim plugins.
2. Restart Vim.


## Usage ##

When you open a Jupyter Notebook (`*.ipynb`) file, it is automatically
converted from json to markdown through the [`notedown` utility][4]. Upon saving
the file, the content is converted back to the json notebook format.

The purpose of this plugin is to allow editing notebooks directly in vim.
The conversion json → markdown → json is relatively lossless, although
some of the restrictions of the `notedown` utility apply. In particular,
notebook and cell metadata are lost, and consecutive markdown cells are
merged into one cell.


## Configuration ##

The following settings in your `~/.vimrc` may be used to configure the
plugin:

*  `g:notedown_enable=1`

   You may disable the automatic conversion between the notebook json
   format and markdown (i.e., deactivate this plugin) by setting this to 0.

*  `g:notedown_code_match='all'`

   Value for the `--match` command line option of `notedown`.
   There are known problems with using the value 'strict', but 'fenced'
   may be a good alternative if you need code blocks in markdown.

[1]: http://www.vim.org
[2]: https://neovim.io
[3]: http://jupyter.org
[4]: https://github.com/aaren/notedown
