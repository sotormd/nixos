{ colors, ... }:

{
  programs.nixvim.defaultEditor = true;
  programs.nixvim.viAlias = true;
  programs.nixvim.vimAlias = true;
  programs.nixvim.waylandSupport = true;

  programs.nixvim.opts = {
    number = true;
    relativenumber = true;
    cursorline = true;
    laststatus = 3;
    showmode = false;
  };

  programs.nixvim.extraConfigLua = ''
    --    vim.opt.fillchars = {
    --      horiz = " ",       -- horizontal split
    --      horizup = " ",     -- horizontal split top junction
    --      horizdown = " ",   -- horizontal split bottom junction
    --      vert = " ",        -- vertical split
    --      vertleft = " ",    -- vertical split left junction
    --      vertright = " ",   -- vertical split right junction
    --      verthoriz = " ",   -- junction between horiz + vert
    --      eob = " ",         -- end of buffer
    --    }

        vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#${colors.bg2}", bold = true })

        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#${colors.bg2}" })   -- set float background
  '';
}
