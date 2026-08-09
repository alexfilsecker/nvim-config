# Alex's NeoVim Configuration

Hi you! (probably Alex) — this is how your NeoVim config is put together.

## Keymaps

Leader is `<Space>`. Every leader prefix means exactly one thing, and nothing
here is reachable two ways. `<leader>sk` fuzzy-searches this list live; pressing
`<leader>` and waiting 300ms shows the same tree, and `<BS>` walks back up it.

### Groups

| Prefix | Meaning |
| --- | --- |
| `<leader>b` | buffer |
| `<leader>c` | code (LSP, format, lint) |
| `<leader>f` | find / file |
| `<leader>g` | git (`gh` = hunks) |
| `<leader>q` | quit |
| `<leader>s` | search |
| `<leader>u` | UI toggles |
| `<leader>w` | window |
| `<leader>x` | lists |

Group labels are declared in one place, `opts.spec` in
[`which-key.lua`](./lua/plugins/which-key.lua). The mappings themselves stay in
whichever plugin spec owns them — `lazy.nvim` uses `keys` to decide when to load
a plugin, so hoisting them into a central file would load everything at startup.

### find / file

| Key | Action |
| --- | --- |
| `<leader>e` | file explorer |
| `<leader>ff` | find files |
| `<leader>fg` | find git files |
| `<leader>fr` | recent files |
| `<leader>fb` | buffers |
| `<leader>ft`, `<C-/>` | terminal |

### search

| Key | Action |
| --- | --- |
| `<leader>sg` | grep |
| `<leader>sw` | grep word or selection |
| `<leader>sb` | buffer lines |
| `<leader>sB` | grep open buffers |
| `<leader>sh` | help pages |
| `<leader>sk` | keymaps |
| `<leader>sm` | marks |
| `<leader>sj` | jumps |
| `<leader>si` | icons |
| `<leader>su` | undo history |
| `<leader>sr` | resume last picker |
| `<leader>s/` | search history |
| `<leader>s:` | command history |
| `<leader>sC` | commands |
| `<leader>ss` | LSP symbols |
| `<leader>sS` | LSP workspace symbols |

### code

| Key | Action |
| --- | --- |
| `<leader>cd` | line diagnostics |
| `<leader>cr` | rename (same as `grn`) |
| `<leader>ca` | code action (same as `gra`) |
| `<leader>cf` | format file or range |
| `<leader>cl` | lint file |
| `<leader>cx` | `source.fixAll`, every client — slow, deliberate |
| `<leader>cR` | restart LSP |
| `<leader>ci` / `<leader>co` | incoming / outgoing calls |

### git

| Key | Action |
| --- | --- |
| `<leader>gg` | lazygit |
| `<leader>gs` | git status |
| `<leader>gl` | git log |
| `<leader>gL` | git log (line) |
| `<leader>gf` | git log (file) |
| `<leader>gb` | blame line |
| `<leader>ghs` / `<leader>ghr` | stage / reset hunk (also visual) |
| `<leader>ghS` / `<leader>ghR` | stage / reset buffer |
| `<leader>ghp` / `<leader>ghi` | preview hunk / inline |
| `<leader>ghd` / `<leader>ghD` | diff this / against `~` |
| `<leader>ghq` | all hunks to quickfix |
| `]h` / `[h` | next / previous hunk |
| `ih` | hunk text object |

### buffer

| Key | Action |
| --- | --- |
| `]b` / `[b` | next / previous buffer (tabline order) |
| `<leader>bb` | pick buffer |
| `<leader>bd` | delete buffer |
| `<leader>bc` | pick and close |
| `<leader>bo` | close other buffers |
| `<leader>bp` | toggle pin |
| `<leader>bh` / `<leader>bl` | move buffer left / right |

### UI toggles

`<leader>u` then: `s` spelling · `w` wrap · `l` line numbers · `L` relative
numbers · `d` diagnostics · `c` conceallevel · `h` inlay hints · `g` indent
guides · `T` treesitter · `b` dark background · `D` dimming · `B` line blame ·
`W` word diff · `C` colorschemes · `n` notification history.

### lists, window, quit

| Key | Action |
| --- | --- |
| `<leader>xx` / `<leader>xX` | diagnostics — workspace / buffer |
| `<leader>xq` / `<leader>xl` | quickfix / location list |
| `<leader>wv` / `<leader>ws` | split vertically / horizontally |
| `<leader>we` / `<leader>wd` | equalize / close window |
| `<leader>qq` | quit all |

### Outside the leader

| Key | Action |
| --- | --- |
| `<C-h/j/k/l>` | move between splits and tmux panes |
| `<M-h/j/k/l>` | resize split |
| `<Esc>` | clear search highlight |
| `K` | peek fold, or hover off a fold |
| `zR` / `zM` | open / close all folds |
| `gd` | goto definition |
| `J` / `K` (visual) | move selection down / up |
| `<leader>y` / `<leader>p` | yank / paste, system clipboard |
| `<leader>+` / `<leader>-` | increment / decrement number |
| `<leader>.` / `<leader>S` | scratch buffer / pick scratch |
| `<C-x>` (terminal) | back to normal mode |

`<C-a>` is the tmux prefix and never reaches nvim, which is why increment and
decrement need leader mappings.

### Left to Neovim

Neovim 0.11+ ships these, so the config deliberately doesn't re-map them —
re-implementing them mostly risks shadowing them, which a `gr` mapping carrying
`nowait` used to do, taking rename and code action with it:

`grn` rename · `gra` code action · `grr` references · `gri` implementation ·
`grt` type definition · `grx` codelens · `gO` document symbols ·
`]d` / `[d` diagnostics · `]q` / `[q` quickfix · `gc` / `gcc` comment.

## File Distribution

- [`init.lua`](./init.lua): the entry point. Requires `core` and `lazy-init`.
- [`lua/core/`](./lua/core/): everything not owned by a plugin.
  - [`options.lua`](./lua/core/options.lua): non-plugin options.
  - [`keymaps.lua`](./lua/core/keymaps.lua): non-plugin keymaps, and the
    prefix scheme every plugin spec follows.
  - [`lsp-servers.lua`](./lua/core/lsp-servers.lua): the server list, shared
    between `mason.lua` (installs them) and `nvim-lspconfig.lua` (configures).
  - [`lsp-fix-all.lua`](./lua/core/lsp-fix-all.lua): synchronous
    `source.fixAll` for `BufWritePre`, driven from conform so the
    eslint/prettier order is fixed in one place.
  - [`preview-buffer.lua`](./lua/core/preview-buffer.lua): VS Code style
    preview buffers — files opened from a picker are transient until edited.
- [`lua/lazy-init.lua`](./lua/lazy-init.lua): bootstraps and configures `lazy.nvim`.
- [`lua/plugins/`](./lua/plugins/): one file per plugin.
- [`.luarc.json`](./.luarc.json): lua_ls settings.
- [`.stylua.toml`](./.stylua.toml): formatter settings, like a `.prettierrc`.
- [`selene.toml`](./selene.toml) / [`vim.yml`](./vim.yml): linter settings and
  the `vim` global definitions it reads.
- [`lazy-lock.json`](./lazy-lock.json): like `package-lock.json`, for plugins.

## Plugins

**Editing** — [nvim-autopairs](https://github.com/windwp/nvim-autopairs),
[Comment.nvim](https://github.com/numToStr/Comment.nvim),
[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter),
[nvim-ufo](https://github.com/kevinhwang91/nvim-ufo) (folding),
[smart-splits.nvim](https://github.com/mrjones2014/smart-splits.nvim),
[vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator).

**LSP & completion** — [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig),
[mason.nvim](https://github.com/williamboman/mason.nvim),
[nvim-cmp](https://github.com/hrsh7th/nvim-cmp),
[lazydev.nvim](https://github.com/folke/lazydev.nvim) (lua_ls for this config),
[conform.nvim](https://github.com/stevearc/conform.nvim) (formatting),
[nvim-lint](https://github.com/mfussenegger/nvim-lint),
[copilot.vim](https://github.com/github/copilot.vim).

**UI** — [snacks.nvim](https://github.com/folke/snacks.nvim) (explorer, pickers,
dashboard, notifier, terminal, toggles — most of the config's surface),
[bufferline.nvim](https://github.com/akinsho/bufferline.nvim),
[lualine.nvim](https://github.com/nvim-lualine/lualine.nvim),
[which-key.nvim](https://github.com/folke/which-key.nvim),
[render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim),
[nightfox.nvim](https://github.com/EdenEast/nightfox.nvim) and
[tokyonight.nvim](https://github.com/folke/tokyonight.nvim) (themes).

**Git** — [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim),
[lazygit.nvim](https://github.com/kdheepak/lazygit.nvim).
