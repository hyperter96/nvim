local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "plugins" },

    -- coding
    { import = "lazyvim.plugins.extras.coding.neogen" },
    { import = "lazyvim.plugins.extras.coding.yanky" },
    { import = "lazyvim.plugins.extras.coding.mini-surround" },
    { import = "lazyvim.plugins.extras.coding.mini-comment" },

    -- editor
    { import = "lazyvim.plugins.extras.editor.leap" },
    { "junegunn/fzf", dir = "~/.fzf", build = "./install --all", name = "fzf" },
    { import = "lazyvim.plugins.extras.editor.navic" },
    { import = "lazyvim.plugins.extras.editor.illuminate" },
    { import = "lazyvim.plugins.extras.editor.telescope" },

    -- formatting
    { import = "lazyvim.plugins.extras.formatting.prettier" },

    -- dap
    { import = "lazyvim.plugins.extras.dap.core" },

    -- lsp
    { import = "lazyvim.plugins.extras.lsp.none-ls" },
    {
      "stevearc/conform.nvim",
      optional = false,
      opts = {
        formatters_by_ft = {
          ["python"] = { "black" },
          lua = { "stylua" },
          javascript = { "dprint", { "prettierd", "prettier" } },
          javascriptreact = { "dprint" },
          typescript = { "dprint", { "prettierd", "prettier" } },
          typescriptreact = { "dprint" },
          go = { "goimports", "gofumpt", "goimports-reviser" },
          less = { { "prettierd", "prettier" } },
          html = { { "prettierd", "prettier" } },
          json = { { "prettierd", "prettier" } },
          jsonc = { { "prettierd", "prettier" } },
          yaml = { { "prettierd", "prettier" } },
          markdown = { { "prettierd", "prettier" } },
          ["c"] = { "clang_format" },
          ["cpp"] = { "clang_format" },
          ["c++"] = { "clang_format" },
          rust = { "rustfmt"},
        },
        formatters = {
          dprint = {
            condition = function(_, ctx)
              return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
            end,
          },
        },
      },
    },
    {
      "mfussenegger/nvim-lint",
      opts = {
        linters_by_ft = {
          lua = { "selene", "luacheck" },
          cmake = { "cmakelint" },
          proto = { "protolint"},
        },
        linters = {
          selene = {
            condition = function(ctx)
              local root = LazyVim.root.get({ normalize = true })
              if root ~= vim.uv.cwd() then
                return false
              end
              return vim.fs.find({ "selene.toml" }, { path = root, upward = true })[1]
            end,
          },
          luacheck = {
            condition = function(ctx)
              local root = LazyVim.root.get({ normalize = true })
              if root ~= vim.uv.cwd() then
                return false
              end
              return vim.fs.find({ ".luacheckrc" }, { path = root, upward = true })[1]
            end,
          },
        },
      },
    },

    -- lang
    { import = "lazyvim.plugins.extras.lang.ansible" },
    { import = "lazyvim.plugins.extras.lang.docker" },
    { import = "lazyvim.plugins.extras.lang.git" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.yaml" },
    { import = "lazyvim.plugins.extras.lang.helm" },
    { import = "lazyvim.plugins.extras.lang.tailwind" },
    { import = "lazyvim.plugins.extras.lang.toml" },
    -- { import = "lazyvim.plugins.extras.lang.cmake" },

    -- linting
    { import = "lazyvim.plugins.extras.linting.eslint" },

    -- UI
    -- { import = "lazyvim.plugins.extras.ui.edgy" },

    -- util
    { import = "lazyvim.plugins.extras.util.project" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
  },
  install = { colorscheme = { "catppuccin", "habamax" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
