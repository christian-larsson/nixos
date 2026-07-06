{ config, pkgs, inputs, lib, ... }:

{
  wayland.windowManager.hyprland = {
    enable          = true;
    package         = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
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

      bind = [
        "SUPER, Return, exec, ghostty"
        "SUPER, Q, killactive"
        "SUPER SHIFT, M, exit"
        "SUPER, V, togglefloating"
        "SUPER, F, fullscreen, 1"
        "SUPER SHIFT, F, fullscreen"
        "SUPER, P, pseudo"
        "SUPER, X, layoutmsg, togglesplit"

        "SUPER, Space, exec, fuzzel"
        "SUPER, B, exec, google-chrome-stable"
        "SUPER SHIFT, E, exec, zed"

        "SUPER, C, exec, cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"

        ", Print, exec, grimblast copy area"
        "SHIFT, Print, exec, grimblast save area"
        "SUPER, Print, exec, grimblast copy screen"

        # Focus — arrow keys only (hjkl are workspace switches)
        "SUPER, left,  movefocus, l"
        "SUPER, right, movefocus, r"
        "SUPER, up,    movefocus, u"
        "SUPER, down,  movefocus, d"

        # Move window — SHIFT + arrow keys
        "SUPER SHIFT, left,  movewindow, l"
        "SUPER SHIFT, right, movewindow, r"
        "SUPER SHIFT, up,    movewindow, u"
        "SUPER SHIFT, down,  movewindow, d"

        # Workspaces on home row
        "SUPER, A, workspace, 1"
        "SUPER, S, workspace, 2"
        "SUPER, D, workspace, 3"
        "SUPER, F, workspace, 4"
        "SUPER, G, workspace, 5"
        "SUPER, H, workspace, 6"
        "SUPER, J, workspace, 7"
        "SUPER, K, workspace, 8"
        "SUPER, L, workspace, 9"

        "SUPER SHIFT, A, movetoworkspace, 1"
        "SUPER SHIFT, S, movetoworkspace, 2"
        "SUPER SHIFT, D, movetoworkspace, 3"
        "SUPER SHIFT, F, movetoworkspace, 4"
        "SUPER SHIFT, G, movetoworkspace, 5"
        "SUPER SHIFT, H, movetoworkspace, 6"
        "SUPER SHIFT, J, movetoworkspace, 7"
        "SUPER SHIFT, K, movetoworkspace, 8"
        "SUPER SHIFT, L, movetoworkspace, 9"

        # Scratchpad
        "SUPER, Z, togglespecialworkspace, magic"
        "SUPER SHIFT, Z, movetoworkspace, special:magic"

        "SUPER, mouse_down, workspace, e+1"
        "SUPER, mouse_up,   workspace, e-1"

        "SUPER, N, exec, makoctl dismiss"
        "SUPER SHIFT, N, exec, makoctl dismiss --all"

        "SUPER, Escape, exec, swaylock"

        # Disable standalone PageUp/PageDown — awkwardly placed next to arrows on X1
        ", Prior, exec, true"
        ", Next, exec, true"
      ];

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];

      binde = [
        "SUPER ALT, right, resizeactive,  30 0"
        "SUPER ALT, left,  resizeactive, -30 0"
        "SUPER ALT, up,    resizeactive,  0 -30"
        "SUPER ALT, down,  resizeactive,  0  30"
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
          timezone       = "Europe/Stockholm";
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
  # Colors and font are set by Stylix; only layout settings here.
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
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
  # Colors and font are set by Stylix; only behaviour settings here.
  services.mako = {
    enable = true;
    settings = {
      border-radius   = 8;
      default-timeout = 5000;
      max-visible     = 5;
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
