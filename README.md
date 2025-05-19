# Alex's NeoVim Configuration

Hi you! (probably Alex) in this `README.md` I want to show you how you have setted up your own **NeoVim** configuration.

## File Distribution

You probably will forget how this project's structure is set up, so here is a remainder:

- [**`README.md`**](./README.md): This `README.md`
- [**`.luarc.json`**](./.luarc.json): The `lua` local configuration file. For now we use it to add `vim` to the globals.
- [**`.stylua.toml`**](./.stylua.toml): The `stylua` local configuration file. Is like a `prettier.rc` file.
- [**`.lazy-lock.json`**](./.lazy-lock.json): Like a `package-lock.json` but for `Lazy`, your `NeoVim` package manager.
- [**`init.lua`**](./init.lua): The origin of all the `NeoVim` configuration. As you will see, it only imports two things: the `Lazy` configuration and our `core` arguments.
- [**`lua/`**](./lua/): This is a directory that contains the `alex/` directory or my configuration. It has been intended that way so that one can have more than one configuration.
  - [**`alex/`**](./lua/alex/): My real configuration folder.
    - [**`core/`**](./lua/alex/core/): A folder to contain all the general settings.
      - [**`init.lua`**](./lua/alex/core/init.lua): A file similar to `__init__.py`, it imports from `keymaps.lua` and `options.lua` so that we can later import just `alex.core`.
      - [**`keymaps.lua`**](./lua/alex/core/keymaps.lua): Where all the non-plugin associated keymaps are stored. You should go take a look.
      - [**`options.lua`**](./lua/alex/core/options.lua): This is where we can find all non-plugin related options. You should go take a look.
    - [**`lazy.lua`**](./lua/alex/lazy.lua): This file is where `Lazy`, you package manager is set-up. As you'll see, it ensures we import all plugins from `alex.plugins` and `alex.plugins.lsp`.
    - [**`plugins`**](./lua/alex/plugins/): In this folder we will find all of our plugins. You can find a description of all of them in the [plugins](#plugins) section

## Plugins

Probably the heart of any `NeoVim` configuration. Here I will show you all of what you have installed.

- [**α alpha-nvim**]("https://github.com/goolord/alpha-nvim"): The greeting page for your `NeoVim`.
- [**🗒️ AutoSession**]("https://github.com/rmagatti/auto-session"): Apparently a plugin to recreate past sessions. It uses the `<leader>w` keymap.
- [**nvim-autopairs**]("https://github.com/windwp/nvim-autopairs"): Automatic closing for parenthesis. Actually a very simple plugin.
- [**bufferline.nvim**]("https://github.com/akinsho/bufferline.nvim"): The tabs you can see on the very top.
-
