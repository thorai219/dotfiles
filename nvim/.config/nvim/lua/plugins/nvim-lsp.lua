return {
  "neovim/nvim-lspconfig",
  opts = {
    inlay_hints = { enabled = false },
    servers = {
      eslint = {
        settings = {
          -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
          workingDirectory = { mode = "auto" },
        },
      },
    },
    setup = {
      eslint = function()
        -- automatically fix linting errors on save (but otherwise do not format the document)
        vim.api.nvim_create_autocmd("BufWritePre", {
          pattern = { "*.tsx", "*.ts", "*.jsx", "*.js" },
          command = "EslintFixAll",
        })
      end,
    },
  },
}
