{ config, pkgs, inputs, lib, ... }:

{
  wayland.windowManager.hyprland = {
    enable          = true;
    package         = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
    systemd.enable  = true;

    settings = {
      # Adjust resolution/hz/scale to match your panel.
      # Run `hyprctl monitors` after first login to get the exact connector name.
      monitor = "eDP-1,2560x1600@120,0x0,2";

      general = {
        gaps_in          = 4;
        gaps_out         = 8;
        border_size      = 2;
        # col.active_border and col.inactive_border are set by Stylix
        layout           = "dwindle";
        resize_on_border = true;
      };

      decoration = {
        rounding         = 8;
        active_opacity   = 1.0;
        inactive_opacity = 0.92;
        shadow = {
          enabled      = true;
          range        = 12;
          render_power = 3;
          color        = "rgba(1a1a2eee)";
        };
        blur = {
          enabled           = true;
          size              = 8;
          passes            = 2;
          new_optimizations = true;
        };
      };

      animations = {
        enabled = true;
        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "linear, 0.0, 0.0, 1.0, 1.0"
        ];
        animation = [
          "windows, 1, 5, wind, slide"
          "windowsIn, 1, 6, winIn, slide"
          "windowsOut, 1, 5, winOut, slide"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 1, linear"
          "borderangle, 1, 180, linear, loop"
          "fade, 1, 10, default"
          "workspaces, 1, 5, wind"
        ];
      };

      input = {
        kb_layout    = "us";
        kb_options   = "caps:escape"; # Caps Lock → Escape
        follow_mouse = 1;
        sensitivity  = 0;
        touchpad = {
          natural_scroll       = true;
          disable_while_typing = true;
          tap-to-click         = true;
          scroll_factor        = 0.5;
        };
      };

      gestures = {
        workspace_swipe          = true;
        workspace_swipe_fingers  = 3;
        workspace_swipe_distance = 300;
      };

      dwindle = {
        pseudotile     = true;
        preserve_split = true;
        smart_split    = true;
      };

      misc = {
        force_default_wallpaper  = 0;
        disable_hyprland_logo    = true;
        disable_splash_rendering = true;
        vfr                      = true;
        vrr                      = 1;
      };

      xwayland.force_zero_scaling = true;

      env = [
        # Cursor size/theme is set by Stylix via the systemd user environment
        "GDK_SCALE,2"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
      ];

      exec-once = [
        "waybar"
        "mako"
        "nm-applet --indicator"
        "blueman-applet"
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        # Wallpaper is managed by Stylix (stylix.image in modules/system/stylix.nix).
        # If you want to override it temporarily:
        #   swaybg -m fill -i ~/Pictures/wallpaper.jpg
      ];

      windowrulev2 = [
        "float, class:^(pavucontrol)$"
        "float, class:^(blueman-manager)$"
        "float, class:^(nm-connection-editor)$"
        "float, title:^(File Upload)$"
        "float, title:^(Open File)$"
        "float, title:^(Picture-in-Picture)$"
        "pin,   title:^(Picture-in-Picture)$"
        "move 73% 72%, title:^(Picture-in-Picture)$"
        "size 25% 25%, title:^(Picture-in-Picture)$"
        "idleinhibit focus, class:^(mpv)$"
        "idleinhibit fullscreen, class:^(google-chrome)$"
      ];

      layerrule = [
        "blur, waybar"
      ];

      "$mod"      = "SUPER";
      "$terminal" = "ghostty";
      "$browser"  = "google-chrome-stable";
      "$editor"   = "zed";
      "$launcher" = "fuzzel";

      bind = [
        "$mod, Return, exec, $terminal"
        "$mod, Q, killactive"
        "$mod SHIFT, M, exit"
        "$mod, V, togglefloating"
        "$mod, F, fullscreen, 1"
        "$mod SHIFT, F, fullscreen"
        "$mod, P, pseudo"
        "$mod, J, togglesplit"

        "$mod, Space, exec, $launcher"
        "$mod, B, exec, $browser"
        "$mod SHIFT, E, exec, $editor"

        "$mod, C, exec, cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"

        ", Print, exec, grimblast copy area"
        "SHIFT, Print, exec, grimblast save area"
        "$mod, Print, exec, grimblast copy screen"

        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"
        "$mod, left,  movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up,    movefocus, u"
        "$mod, down,  movefocus, d"

        "$mod SHIFT, h, movewindow, l"
        "$mod SHIFT, l, movewindow, r"
        "$mod SHIFT, k, movewindow, u"
        "$mod SHIFT, j, movewindow, d"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"

        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up,   workspace, e-1"

        "$mod, N, exec, makoctl dismiss"
        "$mod SHIFT, N, exec, makoctl dismiss --all"

        "$mod SHIFT, L, exec, swaylock"

        # Disable standalone PageUp/PageDown — they sit next to the arrow keys
        # on the X1 and cause accidental presses. Remove these lines if you ever
        # want them back.
        ", Prior, exec, true"
        ", Next, exec, true"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      binde = [
        "$mod ALT, l, resizeactive,  30 0"
        "$mod ALT, h, resizeactive, -30 0"
        "$mod ALT, k, resizeactive,  0 -30"
        "$mod ALT, j, resizeactive,  0  30"
      ];

      bindel = [
        ", XF86AudioRaiseVolume,  exec, wpctl set-volume @DEFAULT_AUDIO_SINK@   5%+"
        ", XF86AudioLowerVolume,  exec, wpctl set-volume @DEFAULT_AUDIO_SINK@   5%-"
        ", XF86AudioMute,         exec, wpctl set-mute   @DEFAULT_AUDIO_SINK@   toggle"
        ", XF86AudioMicMute,      exec, wpctl set-mute   @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86MonBrightnessUp,   exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ", XF86AudioPlay,  exec, playerctl play-pause"
        ", XF86AudioPrev,  exec, playerctl previous"
        ", XF86AudioNext,  exec, playerctl next"
      ];
    };
  };

  # ── Waybar ────────────────────────────────────────────────────────────────────
  # Stylix waybar target is disabled (home/stylix.nix), so we own the full style.
  # Colors here are the Catppuccin Mocha palette and match stylix.base16Scheme.
  programs.waybar = {
    enable   = true;
    settings = {
      mainBar = {
        layer    = "top";
        position = "top";
        height   = 32;
        spacing  = 4;

        modules-left   = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right  = [
          "idle_inhibitor" "pulseaudio" "network" "cpu" "memory"
          "temperature" "backlight" "battery" "bluetooth" "tray"
        ];

        "hyprland/workspaces" = {
          format       = "{icon}";
          format-icons = {
            active  = "";
            urgent  = "";
            default = "";
          };
          persistent-workspaces."*" = 5;
        };

        "hyprland/window" = {
          max-length       = 50;
          separate-outputs = true;
        };

        clock = {
          timezone       = "Europe/Stockholm"; # REPLACE
          format         = "{:%H:%M}";
          format-alt     = "{:%A, %B %d  %H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };

        battery = {
          states          = { warning = 30; critical = 15; };
          format          = "{capacity}% {icon}";
          format-charging = "{capacity}%  ";
          format-plugged  = "{capacity}%  ";
          format-alt      = "{time} {icon}";
          format-icons    = [ "" "" "" "" "" ];
        };

        backlight = {
          format       = "{percent}% {icon}";
          format-icons = [ "" "" "" "" "" "" "" "" "" ];
        };

        network = {
          format-wifi         = "{essid} ({signalStrength}%)  ";
          format-ethernet     = "{ipaddr}/{cidr}  ";
          format-disconnected = "Disconnected  ";
          format-alt          = "{ifname}: {ipaddr}/{cidr}";
          on-click            = "nm-connection-editor";
        };

        pulseaudio = {
          format           = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon} ";
          format-muted     = " ";
          format-icons     = { default = [ "" "" "" ]; };
          on-click         = "pavucontrol";
        };

        cpu    = { format = "{usage}%  "; interval = 2; on-click = "ghostty -e btm"; };
        memory = { format = "{percentage}%  "; interval = 5; on-click = "ghostty -e btm"; };

        temperature = {
          critical-threshold = 80;
          format-critical    = "{temperatureC}°C {icon}";
          format             = "{temperatureC}°C {icon}";
          format-icons       = [ "" "" "" ];
        };

        bluetooth = {
          format           = " {status}";
          format-disabled  = "";
          format-connected = " {num_connections}";
          on-click         = "blueman-manager";
        };

        idle_inhibitor = {
          format       = "{icon}";
          format-icons = { activated = ""; deactivated = ""; };
        };

        tray = { spacing = 10; };
      };
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", "Noto Sans";
        font-size: 13px;
        border: none;
        border-radius: 0;
        min-height: 0;
      }
      window#waybar {
        background: rgba(30, 30, 46, 0.9);
        color: #cdd6f4;
      }
      .modules-left, .modules-center, .modules-right { margin: 2px 6px; }
      #workspaces button {
        padding:    0 6px;
        color:      #6c7086;
        background: transparent;
        transition: all 0.15s ease;
      }
      #workspaces button.active  { color: #89b4fa; font-weight: bold; }
      #workspaces button.urgent  { color: #f38ba8; }
      #clock          { color: #a6e3a1; font-weight: bold; }
      #battery        { color: #a6e3a1; }
      #battery.warning { color: #f9e2af; }
      #battery.critical { color: #f38ba8; animation: blink 0.5s steps(1) infinite; }
      @keyframes blink { to { opacity: 0; } }
      #cpu, #memory   { color: #89b4fa; }
      #temperature    { color: #fab387; }
      #temperature.critical { color: #f38ba8; }
      #network        { color: #94e2d5; }
      #pulseaudio     { color: #f5c2e7; }
      #bluetooth      { color: #89dceb; }
      #backlight      { color: #f9e2af; }
      #tray           { padding: 0 4px; }
      #idle_inhibitor { color: #6c7086; }
      #idle_inhibitor.activated { color: #f38ba8; }
    '';
  };

  # ── Fuzzel ────────────────────────────────────────────────────────────────────
  # Colors are set by Stylix; only layout/font settings here.
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font        = "JetBrainsMono Nerd Font:size=12";
        terminal    = "ghostty";
        width       = 35;
        lines       = 10;
        prompt      = "  ";
        placeholder = "Search...";
      };
      border = {
        radius = 8;
        width  = 2;
      };
    };
  };

  # ── Mako ─────────────────────────────────────────────────────────────────────
  # Colors are set by Stylix; only behaviour/font settings here.
  services.mako = {
    enable = true;
    settings = {
      border-radius   = 8;
      default-timeout = 5000;
      max-visible     = 5;
      font            = "JetBrainsMono Nerd Font 11";
      sort            = "-time";
    };
  };

  # ── Clipboard ─────────────────────────────────────────────────────────────────
  services.cliphist.enable = true;

  # ── Screen lock (swaylock-effects) ───────────────────────────────────────────
  # Stylix swaylock target is disabled (home/stylix.nix) because we use
  # swaylock-effects rather than plain swaylock.
  programs.swaylock = {
    enable   = true;
    package  = pkgs.swaylock-effects;
    settings = {
      color        = "1e1e2e";
      ring-color   = "89b4fa";
      inside-color = "1e1e2e";
      text-color   = "cdd6f4";
      line-color   = "1e1e2e";
      key-hl-color = "a6e3a1";
      bs-hl-color  = "f38ba8";
      font         = "JetBrainsMono Nerd Font";
    };
  };

  services.swayidle = {
    enable   = true;
    timeouts = [
      { timeout = 300; command = "${pkgs.swaylock-effects}/bin/swaylock -f"; }
      {
        timeout       = 360;
        command       = "hyprctl dispatch dpms off";
        resumeCommand = "hyprctl dispatch dpms on";
      }
    ];
    events = [
      { event = "before-sleep"; command = "${pkgs.swaylock-effects}/bin/swaylock -f"; }
      { event = "lock";         command = "${pkgs.swaylock-effects}/bin/swaylock -f"; }
    ];
  };

  # ── bat ───────────────────────────────────────────────────────────────────────
  # Theme is set by Stylix; only behaviour config here.
  programs.bat = {
    enable = true;
    config = {
      italic-text = "always";
      pager       = "less -FR";
    };
  };

  # ── Ghostty terminal ──────────────────────────────────────────────────────────
  # Using programs.ghostty so Stylix can configure colours automatically.
  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "JetBrainsMono Nerd Font";
      font-size   = 13;
      # Colors are injected by Stylix
    };
  };
}
