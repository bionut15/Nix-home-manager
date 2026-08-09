{
  config,
  pkgs,
  ...
}: let
  unstable = import <nixos-unstable> {};
in {
  home.username = "ionut";

  home.homeDirectory = "/home/ionut";

  home.pointerCursor = {
    gtk.enable = true;
  };

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
  ];

  home.file = {
  };

  home.sessionVariables = {
    VISUAL = "nvim";
    EDITOR = "nvim";
    NIXOS_OZONE_WL = "1";
  };

  #XDG settings
  xdg.enable = false;
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
    settings.user.name = "bionut15";
     settings.user.email = "barborionut15@gmail.com";
    signing.format = "ssh";
    signing.key = "~/.ssh/id";
  };
  programs.neovim.defaultEditor = true;

  programs.starship = {
    enable = true;
    # Configuration written to ~/.config/starship.toml
    settings = {
      add_newline = false;
      format = "$shlvl $username$hostname$nix_shell$git_branch$git_commit$git_state$git_status$directory$jobs$character";
      shlvl = {
        disabled = false;
        symbol = "s";
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
      hm = "home-manager";
      homec = "nvim .config/home-manager/home.nix";
      nconfig = "nvim $HOME/.config/home-manager/nixos/configuration.nix";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = ''
      # Start ssh-agent if not running
      if [ -z "$SSH_AUTH_SOCK" ]; then
        eval "$(ssh-agent -s)" >/dev/null
      fi

      # Add key only if not already added
      ssh-add -l >/dev/null 2>&1 || ssh-add ~/.ssh/id >/dev/null 2>&1

                  eval "$(starship init zsh)"

                      export LIBCLANG_PATH=${pkgs.llvmPackages.libclang.lib}/lib
                      export LLVM_CONFIG_PATH=${pkgs.llvmPackages.llvm}/bin/llvm-config
                      export LD_LIBRARY_PATH=${pkgs.llvmPackages.libclang.lib}/lib:$LD_LIBRARY_PATH
                      export PKG_CONFIG_PATH=${pkgs.opencv}/lib/pkgconfig

    '';
    shellAliases = {
      v = "nvim";
      n = "nnn";
      N = "sudo nnn";
      cr = "cargo run";
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
    history.size = 10000;
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
            set fish_greeting
            set -Ux EDITOR nvim
            set -Ux VISUAL nvim
      starship init fish | source
    '';
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

    shell = "${pkgs.zsh}/bin/zsh";

    escapeTime = 0;
    historyLimit = 1400;

    extraConfig = ''
         set -g base-index 1
         setw -g pane-base-index 1

         set -g default-terminal "screen-256color"
                  			   set -g default-terminal "$TERM"
                  set -ag terminal-overrides ",$TERM:Tc"
                                       set -g prefix  C-s
                                       unbind r
                                       bind r source-file ~/.config/tmux/tmux.conf


                          		bind c new-window -c "#{pane_current_path}"
                                       bind % split-window -v -c "#{pane_current_path}"
                                       bind '"' split-window -h -c "#{pane_current_path}"

                                       bind-key h select-pane -L
                                       bind-key j select-pane -D
                                       bind-key k select-pane -U
                                       bind-key l select-pane -L
                        set-option -sa terminal-overrides ",xterm*:Tc"

      set -g status-position bottom
      set -g status-justify left
      set -g status-style 'fg=yellow'

      set -g status-left ""
      set -g status-left-length 10

      set -g status-right-style "fg=black bg=yellow"
      set -g status-right "%Y-%m-%d %H:%M "
      set -g status-right-length 50

      setw -g window-status-current-style "fg=black bg=yellow"
      setw -g window-status-current-format " #I #W #F "

      setw -g window-status-style "fg=yellow bg=black"
      setw -g window-status-format " #I #[fg=white]#W #[fg=yellow]#F "
    '';
    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.better-mouse-mode
    ];
  };

  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "sleep";
        action = "systemctl sleep";
        text = "Sleep";
        keybind = "S";
      }
      {
        label = "logout";
        action = "logout";
        text = "Logout";
        keybind = "l";
      }
      {
        label = "hibernate";
        action = "systemctl hybernate";
        text = "Hybernate";
        keybind = "h";
      }
    ];
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

  programs.wofi = {
    enable = true;
    settings = {
    };
    style = ''
      window {
      margin: 0px;
      border-radius:0;
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

  programs.zathura = {
    enable = true;
    extraConfig = "set sandbox none
		set statusbar-h-padding 0
		set statusbar-v-padding 0
		set page-padding 1
		set selection-clipboard clipboard";
    mappings = {
      u = "scroll half-up";
      d = "scroll half-down";
      D = "toggle_page_mode";
      r = "reload";
      R = "rotate";
      K = "zoom in";
      J = "zoom out";
      i = "recolor";
      p = "print";
      g = "goto top";
      "[fullscreen] u" = "scroll half-up";
      "[fullscreen] d" = "scroll half-down";
      "[fullscreen] D" = "toggle_page_mode";
      "[fullscreen] r" = "reload";
      "[fullscreen] R" = "rotate";
      "[fullscreen] K" = "zoom in";
      "[fullscreen] J" = "zoom out";
      "[fullscreen] i" = "recolor";
      "[fullscreen] p" = "print";
      "[fullscreen] g" = "goto top";
    };
  };
  programs.kitty = {
    enable = true;
    settings = {
      background_blur = "8";

      dynamic_background_opacity = true;
      background_opacity = "0.85";
      shell = "fish";

      placement_strategy = "center";

      window_margin_width = "30";
      window_border_width = "0";
      window_padding_width = "0";

      single_window_padding_width = "0";
      single_window_margin = "0";
      draw_minimal_borders = "yes";
      resize_in_steps = "yes";
    };

    shellIntegration.enableFishIntegration = true;

    font.name = "JetBrainsMono Nerd Font";
    font.size = 12;
    themeFile = "GruvboxMaterialDarkHard";
  };

  programs.alacritty = {
    enable = true;
    settings = {
      terminal.shell = {
        program = "/run/current-system/sw/bin/zsh";
      };
      env.TERM = "xterm-256color";

      window = {
        blur = true;
        opacity = 0.7;
      };
      window.padding = {
        x = 35;
        y = 35;
      };

      font = {
        normal = {
          family = "IosevkaTerm Nerd Font Propo";
          style = "Regular";
        };
        bold = {
          family = "IosevkaTerm Nerd Font Propo";
          style = "Bold";
        };
        italic = {
          family = "IosevkaTerm Nerd Font Propo";
          style = "MediumItalic";
        };
        bold_italic = {
          family = "IosevkaTerm Nerd Font Propo";
          style = "BoldItalic";
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
    enable = false;

    iconTheme = {
      name = "adwaita-icon-theme";
      package = pkgs.adwaita-icon-theme;
      size = "32x32";
    };
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
        format = "<span foreground='#f8f8ff'><b>%s</b>\\n%b";
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
    };
  };

  imports = [
    ./theme/stylix.nix
    ./theme/hypr.nix
    ./theme/wayle.nix
    ./theme/hyprpaper.nix
  ];

  programs.home-manager.enable = true;
}
