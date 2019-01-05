# ipynb_notedown.vim

[Vim][1]/[Neovim][2] plugin for editing [Jupyter notebook][3] (ipynb) files
through [notedown][4].

<http://www.vim.org/scripts/script.php?script_id=5506>

**This plugin is obsolete: use [jupytext.vim](https://github.com/goerz/jupytext.vim) instead**


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


## jupytext.vim ##

The [`jupytext`][5] utility is an alternative to [`notedown`][4] that has considerably less shortcomings. In particular, it guarantees the roundtrip conversion ipynb → markdown → ipynb to be lossless (metadata is preserved, consecutive markdown cells are possible). This is achieved by the markdown file containing only the notebook inputs, and the conversion back to the notebook format using the data from the original notebook file for the outputs.  The [`jupytext.vim` plugin][6] provides similar capabilities to `ipynb_notedown.vim`, but using [`jupytext`][5] instead of [`notedown`][4] by default. If you still want to use [`notedown`][4] over [`jupytext`][5], e.g. because you need cell outputs to be contained in the markdown representation, you can still use the new [`jupytext.vim`][6] plugin, with the following custom configuration in your `~/.vimrc`:

    let g:jupytext_command = 'notedown'
    let g:jupytext_fmt = 'markdown'
    let g:jupytext_to_ipynb_opts = '--to=notebook'

Thus, [`jupytext.vim`][6] supersedes the `ipynb_notedown.vim` entirely, and should be used instead of it.

[1]: http://www.vim.org
[2]: https://neovim.io
[3]: http://jupyter.org
[4]: https://github.com/aaren/notedown
[5]: https://github.com/mwouts/jupytext
[6]: https://github.com/goerz/jupytext.vim
