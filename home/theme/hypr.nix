{
  config,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;

    xwayland = {
      enable = true;
    };

    systemd.enable = false;
    systemd.variables = ["--all"];

    settings = {
      "$mainMod" = "SUPER";

      exec-once = [
        # "hyprpaper"
        "wireplumber"
        "pipewire"
        "pipewire-pulse"
        "dbus-update-activation-environment --systemd --all"
        "hyprpanel &"
        "blueman-applet"
        "nm-applet --indicator &"
        "hyprctl setcursor Bibata-Modern-Ice 22"
        "hypridle"
        # "asusctl profile -P Quiet &"
        "[workspace 1 silent] firefox"
        "[workspace 2 silent] alacritty  -e tmux "
      ];

      monitor = [
        "eDP-1,preferred,auto,1"
        "HDMI-A-1,preferred,auto,1"
      ];

      env = [
        "Bibata-Modern-Ice,~/.icons/Bibata-modern-ice"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "QT_QPA_PLATFORM,wayland"
        "HYPRCURSOR_THEME,Bibata-Modern-Ice"
        "HYPRCURSOR_SIZE,22"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE, wayland"
        "XDG_SESSION_DESKTOP, Hyprland"
        # Nvidia

        "__GL_VRR_ALLOWED,1"
        "WLR_NO_HARDWARE_CURSORS,1"
        "WLR_DRM_NO_ATOMIC,1"
      ];

      general = {
        gaps_in = 0;
        gaps_out = 0;

        border_size = 2;

        layout = "master";
        # "col.active_border" = "rgba(6a9b8aff)";
        # "col.inactive_border" = "rgba(334f42ff)";
        "col.active_border" = "rgba(afae90ff)";
        "col.inactive_border" = "rgba(8c8b72ff)";

        allow_tearing = false;
      };

      decoration = {
        rounding = 0;

        blur = {
          enabled = true;
          size = 6;
          passes = 3;
          ignore_opacity = true;
          noise = 0.08;
          contrast = 1.5;
          xray = false;
          new_optimizations = true;
        };
      };

      master = {
        new_status = true;
        allow_small_split = true;
        mfact = 0.5;
        orientation = "left";
      };

      # gestures = {workspace_swipe = true;};

      misc = {
        force_default_wallpaper = 0;
      };

      device = {
        name = "epic-mouse-v1";
        sensitivity = "-0.5";
      };

      windowrulev2 = [
        "idleinhibit fullscreen, class:^(*)$"
        "idleinhibit fullscreen, title:^(*)$"
        "idleinhibit fullscreen, fullscreen:1"
      ];

      animations = {
        enabled = true;

        bezier = "myBezier, 0.10, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 5, myBezier, slide"
          "windowsOut, 1, 5, myBezier, slide"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      input = {
        kb_layout = "us";

        kb_options = "caps:escape";

        follow_mouse = 1;
        sensitivity = 0;

        touchpad = {
          natural_scroll = false;
        };
      };
      bind = [
        "ALT, Tab, cyclenext,"

        "$mainMod, Q, exec, alacritty"
        "$mainMod SHIFT, Q, exec, alacritty -e tmux "
        "$mainMod, C, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, E, exec, thunar"
        "$mainMod, F, togglefloating,"
        "$mainMod, S, exec, wofi --normal-window --term alacritty --show drun"
        "$mainMod, T, pseudo, # dwindle"
        "$mainMod, J, togglesplit, # dwindle"
        "$mainMod, S, exec, magic"
        "$mainMod SHIFT, S, exec, grim -g \"$(slurp -w 0)\" - | wl-copy && wl-paste > ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png | dunstify \"Screenshot of the region taken\" -t 1000"
        ", Print, exec, grim - | wl-copy && wl-paste > ~/Pictures/Screenshots/Screenshot-$(date +%F_%T).png | dunstify \"Screenshot of whole screen taken\" -t 1000 # screenshot of the whole screen"
        "$mainMod, p , exec, hyprlock"
        "$mainMod, h, movefocus, l"
        "$mainMod, j, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, l, movefocus, d"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ];
      binde = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%-"

        ",XF86MonBrightnessUp, exec, brightnessctl set +10%"
        ",XF86MonBrightnessDown, exec, brightnessctl set 10%-"
      ];
      bindm = [
        " $mainMod, mouse:272, movewindow"
        " $mainMod, mouse:273, resizewindow"
      ];
      bindl = [
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ];
    };
  };

  services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on ";
        ignore_wayland_inhibit = false;
        ignore_dbus_inhibit = false;
      };

      listener = [
        {
          timeout = 200;
          on-timeout = "brightnessctl -s set 10 ";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = 250;
          on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
          on-resume = "brightnessctl -rd rgb:kbd_backlight ";
        }
        {
          timeout = 400;
          on-timeout = "loginctl lock-session ";
        }
        {
          timeout = 480;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on ";
        }
        {
          timeout = 1800;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  programs.hyprlock = {
    enable = false;
    settings = {
      label = {
        text = "Enter your password to unlock";
        color = "rgba(200, 200, 200, 1.0)";
        font_size = 25;
        font_family = "JetBrainsMono Nerd Font";
        position = "0, 200";
        halign = "center";
        valign = "center";
      };
      background = {
        path = "~/Pictures/Minecraft_2.jpeg ";
        color = "rgba(25, 20, 20, 1.0)";

        blur_passes = "4";
        blur_size = "2";
        noise = "0.0117";
        contrast = "0.8916";
        brightness = "0.8172";
        vibrancy = "0.1696";
        vibrancy_darkness = 0.0;
      };

      input-field = [
        {
          size = "200, 50";
          outline_thickness = "1";
          dots_size = "0.2";
          dots_spacing = "0.15";
          dots_center = true;
          outer_color = "rgb(000000)";
          inner_color = "rgb(200, 200, 200)";
          font_color = "rgb(10, 10, 10)";
          fade_on_empty = true;
          placeholder_text = "<i>Input Password...</i> ";
          hide_input = false;
          position = "0, -20";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
