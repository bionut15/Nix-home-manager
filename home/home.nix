{
  config,
  pkgs,
  ...
}: let
  gruvbox-dark = import ./theme/gruvbox-plus.css;
  unstable = import <nixos-unstable> {};
in {
  home.username = "ionut";
  home.homeDirectory = "/home/ionut";
  home.pointerCursor = {
    gtk.enable = true;
    name = "Bibata-modern-ice";
    package = pkgs.bibata-cursors;
    size = 22;
    x11.defaultCursor = "Bibata-modern-ice";
  };
  #Theming
  #GTK
  gtk = {
    theme.package = pkgs.gruvbox-dark-gtk;
    theme.name = "Gruvbox-Material-Dark";
    enable = true;
    cursorTheme.package = pkgs.bibata-cursors;
    cursorTheme.name = "Bibata-Modern-Ice";
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
    gtk4 = {
      #extraCss = gruvbox-dark;
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
  };

  #QT config
  qt.enable = true;
  qt.platformTheme.name = "gtk";
  qt.style.name = "adwaita-dark";
  qt.style.package = pkgs.adwaita-qt;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/ionut/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    VISUAL = "nvim";
    EDITOR = "nvim";
    NIXOS_OZONE_WL = "1";
  };
  #XDG settings
  xdg.mime.enable = true;
  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "application/pdf" = ["org.pwmt.zathura.desktop"];
    };
    defaultApplications = {
      "application/pdf" = ["org.pwmt.zathura.desktop"];
    };
  };
  #Programs configs
  programs.git = {
    enable = true;
    userName = "Ionut";
    userEmail = "barborionut15@gmail.com";
  };
  programs.neovim.defaultEditor = true;

  programs.starship = {
    enable = true;
    # Configuration written to ~/.config/starship.toml
    settings = {
      add_newline = false;
      format = "$shlvl $shell$username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$cmd_duration$character";
      shlvl = {
        disabled = false;
        symbol = "ﰬ ";
        style = "bright-red bold";
      };
      shell = {
        disabled = false;
        format = "$indicator";
        fish_indicator = "[](bright-yellow)";
        bash_indicator = "[](bright-white) ";
      };
      username = {
        style_user = "bright-white bold";
        style_root = "bright-red bold";
      };
      hostname = {
        style = "bright-green bold";
        ssh_only = true;
      };
      nix_shell = {
        symbol = " ";
        format = "[$symbol$name]($style) ";
        style = "bright-purple bold";
      };
      git_branch = {
        only_attached = true;
        format = "[$symbol$branch]($style) ";
        symbol = " ";
        style = "bright-yellow bold";
      };
      git_commit = {
        only_detached = true;
        format = "[ﰖ $hash]($style) ";
        style = "bright-yellow bold";
      };
      git_state = {
        style = "bright-purple bold";
      };
      git_status = {
        style = "bright-green bold";
      };
      directory = {
        read_only = " ";
        truncation_length = 0;
      };
      cmd_duration = {
        format = "[$duration]($style) ";
        style = "bright-blue";
      };
      jobs = {
        style = "bright-green bold";
      };
      character = {
        success_symbol = "[❯](bright-green bold)";
        error_symbol = "[❯](bright-red bold)";
      };
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    initExtra = "
		if [ -f $HOME/.config/home-manager/dotfiles/.bashrc ];
		then
		  source $HOME/.config/home-manager/dotfiles/.bashrc
		fi
		export VISUAL=nvim
		export EDITOR=nvim
	";
    shellAliases = {
      v = "nvim";
      homec = "nvim .config/home-manager/home.nix";
      nconfig = "nvim $HOME/.config/home-manager/nixos/configuration.nix";
    };
  };
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      set -Ux EDITOR nvim
      set -Ux VISUAL nvim
      starship init fish | source'';
    shellAliases = {
      v = "nvim";
      n = "nnn";
      N = "sudo nnn";
      home = "cd $HOME";
      devel = "cd $HOME/Devel";
      ls = "lsd";
      ll = "lsd -l";
      la = "lsd -a";
      c = "clear";
      homec = "nvim $HOME/.config/home-manager/home/home.nix";
      nconfig = "nvim $HOME/.config/home-manager/nixos/configuration.nix";

      #Nix allias
      hm = "home-manager";
    };
  };
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    mouse = true;
    terminal = "tmux-256color";
    shell = "${pkgs.fish}/bin/fish";
    extraConfig = ''
               set -g prefix  C-s

      bind c new-window -c "#{pane_current_path}"
               bind % split-window -v -c "#{pane_current_path}"
               bind '"' split-window -h -c "#{pane_current_path}"

               bind-key h select-pane -L
               bind-key j select-pane -D
               bind-key k select-pane -U
               bind-key l select-pane -L
    '';
    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.tmux-colors-solarized
      tmuxPlugins.better-mouse-mode
    ];
  };

  programs.wlogout = {
    enable = true;
    style = ''
                   * {
                   	box-shadow: none;
                   }

                   window {
                   	background-color: rgba(12, 12, 12, 0.9);

          			backdrop-filter: blur(10px);
        opacity: 0.8;
                   }

                   button {
                       border-radius: 55px;
                       border-color: black;
                   	text-decoration-color: #FFFFFF;
                       color: #FFFFFF;
                   	background-color: #1E1E1E;
                   	border-style: solid;
      margin: 182px 5px;
                   	border-width: 1px;
                   	background-repeat: no-repeat;
                   	background-position: center;
                   	background-size: 25%;
                   }

                   button:focus, button:active, button:hover {
                   	background-color: #3700B3;
                   	outline-style: none;
                   }

    '';
  };
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 34;
        spacing = 2;
        output = [
          "HDMI-A-1"
          "eDP-1"
        ];
        modules-left = ["hyprland/workspaces" "hyprland/window"];
        modules-center = [];
        modules-right = ["tray" "cpu" "memory" "backlight" "pulseaudio" "battery" "clock" "custom/power"];
        "hyprland/workspaces" = {
          socket = "/tmp/hypr/hypr/_1717678063_1305633501/.socket2.sock";
        };
        "hyprland/window" = {
          socket = "/tmp/hypr/hypr/_1717678063_1305633501/.socket.sock";
        };
        "clock" = {
          tooltip-format = " {:%H:%M} ";
          tooltip = true;
          format-alt = " {:%A, %B %d, %Y} ";
          format = " {:%I:%M %p} ";
        };
        "custom/power" = {
          format = "   ";
          on-click = "wlogout";
          tooltip = true;
        };
        "cpu" = {
          format = " {usage}%  ";
          tooltip = true;
        };
        "battery" = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = " {capacity}% {icon} ";
          format-charging = " {capacity}%  ";
          format-plugged = " {capacity}%  ";
          format-alt = " {time} {icon} ";
          format-icons = [" " " " " " " " " "];
        };
        "pulseaudio" = {
          format = " {volume}% {icon}{format_source} ";
          format-bluetooth = " {volume}% {icon} {format_source} ";
          format-bluetooth-muted = " 󰝟  {icon} {format_source} ";
          format-muted = " 󰝟  {format_source} ";
          format-source = " {volume}% ";
          format-source-muted = " ";
          format-icons = {
            headphone = " ";
            headset = " ";
            phone = "";
            portable = "";
            car = " ";
            default = [" " " " " "];
          };
          on-click = "pavucontrol";
        };
        "backlight" = {
          format = " {percent}% {icon}";
          format-icons = [" " " " " " " " " " " " " " " " " "];
          tooltip = true;
          #on-click = "";
        };
        "memory" = {
          format = " {}%   ";
        };
        "tray" = {
          "spacing" = 10;
          "icon-size" = 19;
        };
        "network" = {
          format-wifi = " ({signalStrength}%)   ";
          format-ethernet = " {essid};  󰈀  ";
          tooltip-format = " {ifname} via {gwaddr} ";
          format-linked = " {ifname} (No IP) ";
          format-disconnected = " Disconnected ⚠ ";
          format-alt = " {ifname}: {ipaddr}/{cidr} ";
        };
      };
    };
    style = ''
                 * {
                     font-family: JetBrainsMono Nerd Font;
                     font-size: 13px;
                     font-weight: bold;
                 }

                 window#waybar {
                     background-color: #1f2223;
                     border-bottom: 8px solid #191c1d;
                     color: #ebdbb2;
                     transition-property: background-color;
                     transition-duration: .5s;
                 }

                 window#waybar.hidden {
                     opacity: 0.2;
                 }
                 button {
                     all: unset;
                     background-color: #689d6a;
                     color: #282828;
                     border: none;
                     border-bottom: 8px solid #518554;
                     border-radius: 4px;
                     margin-left: 4px;
                     margin-bottom: 3px;
                     margin-top: 0px;
                     font-family: JetBrainsMono Nerd Font, sans-sherif;
                     font-weight: bold;
                     font-size: 14px;
                     padding-left: 12px;
                     padding-right: 12px;
                     transition: transform 0.1s ease-in-out;
                 }

                 button:hover {
                     background: inherit;
                     background-color: #8ec07c;
                     border-bottom: 8px solid #76a765;
                 }

                 button.active {
                     background: inherit;
                     background-color: #7db37e;
                     border-bottom: 8px solid #659a68;
                 }

                 #mode {
                     background-color: #64727D;
                     border-bottom: 3px solid #ffffff;
                 }

                 #clock,
         #custom-power,
                 #battery,
                 #cpu,
                 #memory,
                 #backlight,
                 #network,
                 #pulseaudio,
                 #tray,
                 #mode,
                 #window,
                 #workspaces {
                     margin: 0 1px;
                     margin-top: 2px;
                 }

                 /* If workspaces is the leftmost module, omit left margin */
                 .modules-left > widget:first-child > #workspaces {
                     margin-left: 0;
                 }

                 /* If workspaces is the rightmost module, omit right margin */
                 .modules-right > widget:last-child > #workspaces {
                     margin-right: 0;
                 }

                 #window {
                     background-color: #303030;
                     color: #ebdbb2;
                     font-family: JetBrainsMono Nerd Font, monospace;
                     font-size: 15px;
                     font-weight: bold;
                     border: none;
                     border-bottom: 8px solid #272727;
                     border-radius: 4px;
                     margin-top: 2px;
                     margin-bottom: 2px;
                     padding-left: 10px;
                     padding-right: 10px;
                 }
            #custom-power{
                     background-color: #fb4934;
                     color: #282828;
                     font-family: JetBrainsMono Nerd Font, monospace;
                     font-size: 15px;
                     font-weight: bold;
                     border: none;
                     border-bottom: 8px solid #cc241d;
                     border-radius: 4px;
      margin-left: 0px;
      margin-right:0px;
                     margin-bottom: 2px;
            }
                 #clock {
                     background-color: #98971a;
                     color: #282828;
                     font-family: JetBrainsMono Nerd Font, monospace;
                     font-size: 15px;
                     font-weight: bold;
                     border: none;
                     border-bottom: 8px solid #828200;
                     border-radius: 4px;
                     margin-bottom: 2px;
                     margin-right: 4px;
                 }

                 #battery {
                     background-color: #5d9da0;
                     color: #282828;
                     font-family: JetBrainsMono Nerd Font, monospace;
                     font-size: 15px;
                     font-weight: bold;
                     border: none;
                     border-bottom: 8px solid #458588;
                     border-radius: 4px;
                     margin-bottom: 2px;
                 }

                 @keyframes blink {
                     to {
                         background-color: #ffffff;
                         color: #000000;
                     }
                 }

                 #battery.critical:not(.charging) {
                     background-color: #e23c2c;
                     color: #282828;
                     font-family: JetBrainsMono Nerd Font, monospace;
                     font-size: 15px;
                     font-weight: bold;
                     border: none;
                     border-bottom: 8px solid #cc241d;
                     border-radius: 4px;
                     margin-bottom: 2px;
                 }

                 label:focus {
                     background-color: #000000;
                 }

                 #cpu {
                     background-color: #689d6a;
                     color: #282828;
                     font-family: JetBrainsMono Nerd Font, monospace;
                     font-size: 15px;
                     font-weight: bold;
                     border: none;
                     border-bottom: 8px solid #518554;
                     border-radius: 4px;
                     margin-bottom: 2px;
                 }

                 #memory {
                     background-color: #c8779b;
                     color: #282828;
                     font-family: JetBrainsMono Nerd Font, monospace;
                     font-size: 15px;
                     font-weight: bold;
                     border: none;
                     border-bottom: 8px solid #b16286;
                     border-radius: 4px;
                     margin-bottom: 2px;
                 }

                 #disk {
                     background-color: #964B00;
                 }

                 #backlight {
                     background-color: #98bbad;
                     color: #282828;
                     font-family: JetBrainsMono Nerd Font, monospace;
                     font-size: 15px;
                     font-weight: bold;
                     border: none;
                     border-bottom: 8px solid #80a295;
                     border-radius: 4px;
                     margin-bottom: 2px;
                 }

                 #network {
                     background-color: #2980b9;
                     color: #282828;
                     font-family: JetBrainsMono Nerd Font, monospace;
                     font-size: 15px;
                     font-weight: bold;
                     border: none;
                     border-bottom: 8px solid #80a295;
                     border-radius: 4px;
                     margin-bottom: 2px;
                 }

                 #network.disconnected {
                     background-color: #f53c3c;
                 }

                 #pulseaudio {
                     background-color: #f2b13c;
                     color: #282828;
                     font-family: JetBrainsMono Nerd Font, monospace;
                     font-size: 15px;
                     font-weight: bold;
                     border: none;
                     border-bottom: 8px solid #d79921;
                     border-radius: 4px;
                     margin-bottom: 2px;
                 }

                 #wireplumber {
                     background-color: #fff0f5;
                     color: #000000;
                 }

                 #wireplumber.muted {
                     background-color: #f53c3c;
                 }

                 #custom-media {
                     background-color: #66cc99;
                     color: #2a5c45;
                     min-width: 100px;
                 }

                 #custom-media.custom-spotify {
                     background-color: #66cc99;
                 }

                 #custom-media.custom-vlc {
                     background-color: #ffa000;
                 }

                 #temperature {
                     background-color: #f0932b;
                 }

                 #temperature.critical {
                     background-color: #eb4d4b;
                 }

                 #tray {
                     background-color: #ec7024;
                     color: #282828;
                     font-family: JetBrainsMono Nerd Font, monospace;
                     font-size: 15px;
                     font-weight: bold;
                     border: none;
                     border-bottom: 8px solid #d05806;
                     border-radius: 4px;
                     margin-bottom: 2px;
                     padding-left: 8px;
                     padding-right: 4px;
                 }

                 #tray > .passive {
                     -gtk-icon-effect: dim;
                 }

                 #tray > .needs-attention {
                     -gtk-icon-effect: highlight;
                     background-color: #eb4d4b;
                 }


                 tooltip {
                   background-color: #1f2223;
                   border: none;
                   border-bottom: 8px solid #191c1d;
                   border-radius: 4px;
                 }

                 tooltip decoration {
                   box-shadow: none;
                 }

                 tooltip decoration:backdrop {
                   box-shadow: none;
                 }

                 tooltip label {
                   color: #ebdbb2;
                   font-family: JetBrainsMono Nerd Font, monospace;
                   font-size: 16px;
                   padding-left: 5px;
                   padding-right: 5px;
                   padding-top: 0px;
                   padding-bottom: 5px;
                 }
    '';
  };
  programs.wofi = {
    enable = true;
    settings = {
    };
    style = ''
      window {
      margin: 0px;
      border-radius:0.4em;
      border: 1px solid #928374;
      background-color: #282828;
      }

      #input {
      margin: 5px;
      border: none;
      color: #ebdbb2;
      background-color: #1d2021;
      }

      #inner-box {
      margin: 5px;
      border: none;
      background-color: #282828;
      }

      #outer-box {
      margin: 5px;
      border: none;
      background-color: #282828;
      }

      #scroll {
      margin: 0px;
      border: none;
      }

      #text {
      margin: 5px;
      border: none;
      color: #ebdbb2;
      }

      #entry:selected {
      background-color: #1d2021;
      }
      #entry:unselected {
      color: black;
      }
    '';
  };

  programs.lf = {
    enable = true;
    settings = {
      preview = true;
      hidden = false;
      drawbox = false;
      icons = true;
      ignorecase = true;
      ratios = "2:3:5";
      number = true;
      relativenumber = true;
      dircounts = true;
      scrolloff = 10;
      sixel = true;
    };
    keybindings = {
      "." = "set hidden!";
      "<esc>" = "cmd-escape";
      "<enter>" = "open";
      c = "copy";
      x = "cut";
      D = "%trash-put $fx";
    };
    commands = {
    };
    cmdKeybindings = {
    };
    extraConfig = let
      previewer = pkgs.writeShellScriptBin "pv.sh" ''
        file=$1
        w=$2
        h=$3
        x=$4
        y=$5

        if [[ "$( ${pkgs.file}/bin/file -Lb --mime-type "$file")" =~ ^image ]]; then
            ${pkgs.kitty}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
            exit 1
        fi

        ${pkgs.pistol}/bin/pistol "$file"
      '';
      cleaner = pkgs.writeShellScriptBin "clean.sh" ''
        ${pkgs.ctpv}/bin/ctpvclear
        ${pkgs.kitty}/bin/kitty +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
      '';
    in ''
      set cleaner ${cleaner}/bin/clean.sh
           set previewer ${previewer}/bin/pv.sh
    '';
  };

  programs.kitty = {
    enable = true;
    settings = {
      background_blur = "7";
      dynamic_background_opacity = true;
      background_opacity = "0.75";
      shell = "fish";
      window_margin_width = "0";
      window_border_width = "0";
      window_padding_width = "0";
      resize_in_steps = "yes";
    };
    shellIntegration.enableFishIntegration = true;
    font.name = "JetBrainsMono Nerd Font";
    font.size = 12;
    theme = "Gruvbox Dark";
  };
  programs.alacritty = {
    enable = true;
    # custom settings
    settings = {
      #optional fish config
      shell = {
        program = "/run/current-system/sw/bin/fish";
      };
      env.TERM = "xterm-256color";
      window.opacity = 0.85;
      window.padding = {
        x = 2;
        y = 2;
      };
      colors.primary = {
        background = "#282828";
        foreground = "#ebdbb2";
      };
      colors.normal = {
        black = "#282828";
        red = "#cc241d";
        green = "#98971a";
        yellow = "#d79921";
        blue = "#458588";
        magenta = "#b16286";
        cyan = "#689d6a";
        white = "#a89984";
      };
      colors.bright = {
        black = "#928374";
        red = "#fb4934";
        green = "#b8bb26";
        yellow = "#fabd2f";
        blue = "#83a598";
        magenta = "#d3869b";
        cyan = "#8ec07c";
        white = "#ebdbb2";
      };
      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        size = 12;
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
      keyboard = {
        bindings = [
          {
            key = "F11";
            action = "ToggleFullscreen";
          }
        ];
      };
    };
  };

  #Services
  services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    tray = "auto";
  };
  services.dunst = {
    enable = true;
    settings = {
      global = {
        rounded = "yes";
        origin = "top-right";
        alignment = "left";
        vertical_alignment = "center";
        width = "400";
        height = "500";
        scale = 0;
        gap_size = 0;
        progress_bar = true;
        transparency = 1;
        text_icon_padding = 0;
        separator_color = "frame";
        sort = "yes";
        idle_threshold = 120;
        line_height = 0;
        markup = "full";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = "no";
        stack_duplicates = true;
        sticky_history = "yes";
        history_length = 20;
        always_run_script = true;
        corner_radius = 6;
        follow = "mouse";
        font = "JetBrainsMono";
        format = "<span foreground='#f8f8ff'><b>%s</b>\\n%b"; #format = "<span foreground='#f3f4f5'><b>%s %p</b></span>\n%b"
        frame_color = "#8ec07c";
        frame_width = 3;
        offset = "15x15";
        horizontal_padding = 10;
        icon_position = "left";
        indicate_hidden = "yes";
        min_icon_size = 0;
        max_icon_size = 64;
        mouse_left_click = "do_action, close_current";
        mouse_middle_click = "close_current";
        mouse_right_click = "close_all";
        padding = 10;
        plain_text = "no";
        separator_height = 2;
        show_indicators = "yes";
        shrink = "no";
        word_wrap = "yes";
        browser = "/usr/bin/env firefox -new-tab";
      };

      fullscreen_delay_everything = {fullscreen = "delay";};

      urgency_critical = {
        background = "#3c3836";
        foreground = "#f8f8ff";
      };
      urgency_low = {
        background = "#3c3836";
        foreground = "#f8f8ff";
      };
      urgency_normal = {
        background = "#3c3836";
        foreground = "#f8f8ff";
      };
    };
  };

  imports = [
  ];

  programs.home-manager.enable = true;
}
