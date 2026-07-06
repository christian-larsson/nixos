{ ... }:

{
  # Opt out of Stylix targets where we manage theming ourselves.
  # Everything not listed here is handled automatically by Stylix
  # (fish colors, bat theme, GTK/Qt, Hyprland borders, mako, fuzzel, ghostty…).

  stylix.targets.waybar.enable  = false; # we keep a custom CSS style
  stylix.targets.swaylock.enable = false; # using swaylock-effects; colours set manually
  stylix.targets.zed.enable     = false;  # configured via xdg.configFile JSON
}
