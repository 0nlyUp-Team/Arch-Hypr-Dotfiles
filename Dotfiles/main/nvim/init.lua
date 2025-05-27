vim.opt.rtp:prepend("~/.local/share/nvim/site/pack/lazy/start/lazy.nvim")
require("lazy").setup({
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = {
          width = 30,
          side = "left",
        },
      })
      vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
    end,
  },
})
vim.cmd[[hi Normal guibg=NONE ctermbg=NONE]] vim.cmd[[hi NormalNC guibg=NONE ctermbg=NONE]] vim.cmd[[hi EndOfBuffer guibg=NONE ctermbg=NONE]]
