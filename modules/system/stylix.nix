{ pkgs, ... }:

{
  stylix = {
    enable = true;

    # Catppuccin Mocha — the single source of truth for all colors.
    # Stylix distributes this palette automatically to every enabled target.
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    # Placeholder wallpaper — replace with your own image:
    #   image = ./wallpaper.jpg;    (commit an image to the repo)
    #   image = /home/chris/Pictures/wallpaper.jpg;  (absolute path)
    image = pkgs.nixos-artwork.wallpapers.simple-dark-gray.gnomeFilePath;

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name    = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name    = "Noto Sans";
      };
      serif = {
        package = pkgs.noto-fonts;
        name    = "Noto Serif";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name    = "Noto Color Emoji";
      };
      sizes = {
        terminal     = 13;
        applications = 12;
        desktop      = 12;
        popups       = 12;
      };
    };

    # Cursor is declared here so Stylix propagates it to GTK, Hyprland, and
    # the systemd user environment consistently.
    cursor = {
      package = pkgs.bibata-cursors;
      name    = "Bibata-Modern-Classic";
      size    = 24;
    };
  };
}
