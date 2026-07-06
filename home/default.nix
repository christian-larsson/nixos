{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    ./hyprland.nix
    ./fish.nix
    ./git.nix
    ./packages.nix
    ./neovim.nix
    ./zed.nix
    ./stylix.nix
  ];

  home.username      = "chris";
  home.homeDirectory = "/home/chris";
  home.stateVersion  = "26.05";

  programs.home-manager.enable = true;

  xdg.enable = true;
  xdg.userDirs = {
    enable            = true;
    createDirectories = true;
    desktop    = "${config.home.homeDirectory}/Desktop";
    documents  = "${config.home.homeDirectory}/Documents";
    download   = "${config.home.homeDirectory}/Downloads";
    music      = "${config.home.homeDirectory}/Music";
    pictures   = "${config.home.homeDirectory}/Pictures";
    videos     = "${config.home.homeDirectory}/Videos";
    templates  = "${config.home.homeDirectory}/Templates";
    publicShare = "${config.home.homeDirectory}/Public";
  };

  # GTK theme and cursor are set by Stylix (modules/system/stylix.nix).
  # Icon theme is not managed by Stylix, so we set it here.
  gtk = {
    enable = true;
    iconTheme = {
      name    = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
  };

  home.sessionVariables = {
    EDITOR   = "zed";
    VISUAL   = "zed";
    BROWSER  = "google-chrome-stable";
    TERMINAL = "ghostty";

    # Wayland hints for Electron/Qt/GTK apps
    NIXOS_OZONE_WL     = "1";
    GDK_BACKEND        = "wayland,x11";
    QT_QPA_PLATFORM    = "wayland;xcb";
    SDL_VIDEODRIVER    = "wayland";
    MOZ_ENABLE_WAYLAND = "1";

    # Python / uv
    UV_PYTHON_PREFERENCE = "only-managed";

    # Rust
    CARGO_HOME = "${config.home.homeDirectory}/.cargo";
  };
}
