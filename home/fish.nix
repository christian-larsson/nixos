{ pkgs, ... }:

{
  programs.fish = {
    enable = true;

    plugins = [
      { name = "bass";     src = pkgs.fishPlugins.bass.src; }
      { name = "done";     src = pkgs.fishPlugins.done.src; }
      { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
    ];

    shellAliases = {
      # Modern replacements
      ls   = "eza --icons=auto";
      ll   = "eza -lah --icons=auto --git";
      la   = "eza -a --icons=auto";
      lt   = "eza --tree --icons=auto";
      cat  = "bat --paging=never";
      grep = "rg";
      find = "fd";
      ps   = "procs";
      top  = "btm";
      df   = "duf";
      du   = "dust";

      # Git shortcuts
      g    = "git";
      gs   = "git status -sb";
      ga   = "git add";
      gc   = "git commit";
      gp   = "git push";
      gl   = "git lg";
      gd   = "git diff";

      # Nix shortcuts
      nrs  = "sudo nixos-rebuild switch --flake ~/nixos#thinkpad-x1";
      nrt  = "sudo nixos-rebuild test --flake ~/nixos#thinkpad-x1";
      nfu  = "nix flake update ~/nixos";
      ngc  = "sudo nix-collect-garbage -d";

      # Navigation
      ".."  = "cd ..";
      "..." = "cd ../..";
      v     = "zed";
    };

    interactiveShellInit = ''
      set fish_greeting ""

      # Fish syntax highlight colors are set by Stylix (modules/system/stylix.nix).

      # fzf: use fd for file finding and Catppuccin Mocha colors
      set -gx FZF_DEFAULT_COMMAND  "fd --type f --hidden --follow --exclude .git"
      set -gx FZF_CTRL_T_COMMAND   "$FZF_DEFAULT_COMMAND"
      set -gx FZF_ALT_C_COMMAND    "fd --type d --hidden --follow --exclude .git"
      set -gx FZF_DEFAULT_OPTS "
        --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
        --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
        --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
        --border rounded
        --prompt '  '
        --pointer '▶'
        --marker '✓'
        --height 40%
        --layout reverse
        --info inline
      "

      fish_add_path "$HOME/.cargo/bin"
      fish_add_path "$HOME/.local/bin"
    '';

  };
}
