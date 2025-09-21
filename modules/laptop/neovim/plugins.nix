{ colors, ... }:

{
  programs.nixvim.plugins = {
    # search
    telescope.enable = true;

    # explorer
    nvim-tree.enable = true;

    # lualine
    lualine.enable = true;

    # icons
    web-devicons.enable = true;

    # bufferline
    bufferline.enable = true;
    bufferline.settings = {
      highlights = {
        fill.bg = "#${colors.bg0}";
        buffer_selected.bg = "#${colors.bg0}";
        buffer_visible.bg = "#${colors.bg0}";
      };
      options = {
        numbers = "buffer_id";
        separator_style = null;
        enforce_regular_tabs = true;
        indicator.style = "none";
        offsets = [
          {
            filetype = "NvimTree";
            text = "Explorer";
            highlight = "Directory";
          }
        ];
      };
    };

    # tree-sitter
    treesitter.enable = true;
    treesitter.settings = {
      highlight.enable = true;
      indent.enable = false;
    };

    # completions
    cmp.enable = true;
    cmp = {
      autoEnableSources = true;
      settings.sources = [
        { name = "nvim_lsp"; }
        { name = "path"; }
        { name = "buffer"; }
      ];
    };

    # none-ls
    none-ls.enable = true;
    none-ls.sources = {
      formatting.black.enable = true;
      formatting.isort.enable = true;
      formatting.nixfmt.enable = true;
    };

    # lsps
    lsp.enable = true;
    lsp.servers = {
      # nix
      nixd.enable = true;

      # python
      pyright.enable = true;

      # rust
      rust_analyzer.enable = true;
      rust_analyzer = {
        installRustc = false;
        installCargo = false;
      };
    };
  };

  programs.nixvim.withPython3 = true;
  programs.nixvim.extraPython3Packages = ps: [
    ps.black
    ps.isort
  ];
}
