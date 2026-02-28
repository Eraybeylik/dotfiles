return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = false,
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = false,
          treesitter = true,
          telescope = {
            enabled = true,
          },
          mini = {
            enabled = true,
          },
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
