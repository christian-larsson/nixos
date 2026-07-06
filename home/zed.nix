{ ... }:

{
  # Zed doesn't have a home-manager module yet; configure via XDG config files.
  xdg.configFile."zed/settings.json".text = builtins.toJSON {
    theme       = "Catppuccin Mocha";
    base_keymap = "VSCode";

    ui_font_family = "Zed Plex Sans";
    ui_font_size   = 16;

    buffer_font_family = "JetBrainsMono Nerd Font";
    buffer_font_size   = 14;
    buffer_font_features = {
      calt = true;
      liga = true;
    };

    autosave        = "on_focus_change";
    format_on_save  = "on";
    tab_size        = 2;
    hard_tabs       = false;
    soft_wrap       = "editor_width";
    vim_mode        = false;

    terminal = {
      font_family = "JetBrainsMono Nerd Font";
      font_size   = 13;
      shell       = { program = "fish"; };
      env         = { TERM = "xterm-256color"; };
    };

    languages = {
      Rust = {
        format_on_save = "on";
        tab_size       = 4;
      };
      Python = {
        format_on_save = "on";
        tab_size       = 4;
        formatter      = {
          external = {
            command   = "ruff";
            arguments = [ "format" "--stdin-filename" "{buffer_path}" "-" ];
          };
        };
      };
      Nix = {
        tab_size  = 2;
        formatter = {
          external = {
            command   = "alejandra";
            arguments = [ "-" ];
          };
        };
      };
    };
  };

  xdg.configFile."zed/keymap.json".text = builtins.toJSON [
    {
      context  = "Editor";
      bindings = {
        "ctrl-shift-p" = "command_palette::Toggle";
        "ctrl-p"       = "file_finder::Toggle";
        "ctrl-`"       = "terminal_panel::ToggleFocus";
      };
    }
  ];
}
