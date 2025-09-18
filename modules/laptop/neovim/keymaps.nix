{
  programs.nixvim.keymaps = [
    # Telescope find files
    {
      key = "<leader>ff";
      action = "<cmd>Telescope find_files<CR>";
      options.silent = true;
    }

    # Telescope live grep
    {
      key = "<leader>fg";
      action = "<cmd>Telescope live_grep<CR>";
      options.silent = true;
    }

    # Telescope buffers
    {
      key = "<leader>fb";
      action = "<cmd>Telescope buffers<CR>";
      options.silent = true;
    }

    # Telescope help tags
    {
      key = "<leader>fh";
      action = "<cmd>Telescope help_tags<CR>";
      options.silent = true;
    }

    # Nvim-Tree toggle
    {
      key = "<leader>e";
      action = "<cmd>NvimTreeToggle<CR>";
      options.silent = true;
    }

    # Nvim-Tree focus (jump into the tree)
    {
      key = "<leader>fe";
      action = "<cmd>NvimTreeFocus<CR>";
      options.silent = true;
    }

    # Diagnostics: show float
    {
      key = "<leader>d";
      action = "<cmd>lua vim.diagnostic.open_float()<CR>";
      options.silent = true;
    }

    # Diagnostics: go to previous
    {
      key = "[d";
      action = "<cmd>lua vim.diagnostic.goto_prev()<CR>";
      options.silent = true;
    }

    # Diagnostics: go to next
    {
      key = "]d";
      action = "<cmd>lua vim.diagnostic.goto_next()<CR>";
      options.silent = true;
    }

    # Formatting: format current file
    {
      key = "<leader>cf";
      action = "<cmd>lua vim.lsp.buf.format({ async = true })<CR>";
      options.silent = true;
    }
  ];
}
