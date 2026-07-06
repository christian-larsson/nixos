{ pkgs, ... }:

let
  rustToolchain = pkgs.rust-bin.stable.latest.default.override {
    extensions = [ "rust-src" "rust-analyzer" "clippy" "rustfmt" ];
    targets    = [ "x86_64-unknown-linux-gnu" ];
  };
in
{
  home.packages = with pkgs; [
    # ── Shell utilities ────────────────────────────────────────────────────────
    fzf
    fd
    ripgrep
    jq
    yq-go
    delta
    eza
    zoxide
    starship
    tealdeer
    bottom
    dust
    duf
    procs
    tokei
    hyperfine

    # ── Development ────────────────────────────────────────────────────────────
    rustToolchain
    uv
    python3
    ruff             # Python linter + formatter (used by home/zed.nix)
    nodejs_22
    gcc
    cmake
    pkg-config
    gnumake
    openssl.dev

    # ── Editor / Browser ───────────────────────────────────────────────────────
    zed-editor
    google-chrome
    claude-code   # Claude CLI (neovim is managed via programs.neovim in neovim.nix)

    # ── Wayland / Desktop ──────────────────────────────────────────────────────
    # ghostty is managed via programs.ghostty in home/hyprland.nix
    grimblast
    grim
    slurp
    wl-clipboard
    xdg-utils
    playerctl
    pavucontrol
    brightnessctl
    networkmanagerapplet
    polkit_gnome
    swaybg

    # ── Files / Archives ───────────────────────────────────────────────────────
    p7zip
    unzip
    zip
    file
    tree

    # ── Network ────────────────────────────────────────────────────────────────
    wget
    curl
    httpie
    nmap

    # ── Media ──────────────────────────────────────────────────────────────────
    mpv
    imv
    ffmpeg

    # ── Nix tooling ────────────────────────────────────────────────────────────
    nix-output-monitor
    nvd
    alejandra
  ];

  programs.starship = {
    enable = true;
    settings = {
      add_newline     = true;
      command_timeout = 2000;
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol   = "[❯](bold red)";
      };
      git_branch.symbol = " ";
      rust.symbol       = " ";
      python.symbol     = " ";
      nix_shell = {
        symbol     = " ";
        impure_msg = "[impure](bold red)";
        pure_msg   = "[pure](bold green)";
      };
    };
  };

  programs.zoxide = {
    enable                = true;
    enableFishIntegration = true;
  };

  programs.eza = {
    enable                = true;
    enableFishIntegration = true;
    icons                 = "auto";
    git                   = true;
    extraOptions          = [ "--group-directories-first" "--color=always" ];
  };

  programs.direnv = {
    enable            = true;
    nix-direnv.enable = true;
  };
}
