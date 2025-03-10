{
  config,
  inputs,
  pkgs,
  pkgs-unstable,
  ...
}: let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in {
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  #Systemd-boot
  #systemd = {
  #  sleep.extraConfig = ''
  #    AllowSuspend=no
  #    AllowHibernation=no
  #    AllowHybridSleep=no
  #    AllowSuspendThenHibernate=no
  #  '';
  #};

  #boot.loader.systemd-boot.enable = true;
  #boot.loader.systemd-boot.consoleMode = "keep";
  #boot.loader.systemd-boot.configurationLimit = 10;
  #boot.loader.systemd-boot.extraEntries ={
  #      "windows.conf"=''
  #      title Windows
  #      efi /dev/nvme0n1p1@/efi/Microsoft/Boot/bootmgfw.efi
  #      sort-key o_memtest
  #      '';
  #};

  #boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.devices = ["nodev"];
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;

  boot.supportedFilesystems = ["ntfs"];

  networking.hostName = "nixos"; # Define your hostname.
  networking.firewall = {
    allowedTCPPorts = [2222 443 8080];
    enable = false;
  };
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Bucharest";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ro_RO.UTF-8";
    LC_IDENTIFICATION = "ro_RO.UTF-8";
    LC_MEASUREMENT = "ro_RO.UTF-8";
    LC_MONETARY = "ro_RO.UTF-8";
    LC_NAME = "ro_RO.UTF-8";
    LC_NUMERIC = "ro_RO.UTF-8";
    LC_PAPER = "ro_RO.UTF-8";
    LC_TELEPHONE = "ro_RO.UTF-8";
    LC_TIME = "ro_RO.UTF-8";
  };

  services.xserver.videoDrivers = ["nvidia"];
  services.xserver = {
    desktopManager.gnome.enable = true;
    enable = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd Hyprland";
        user = "greeter";
      };
    };
  };
  console = {
    colors = [
      "343F44"
      "E67E80"
      "A7C080"
      "DBBC7F"
      "7FBBB3"
      "D699B6"
      "83C092"
      "D3C6AA"
      "5C6A72"
      "F85552"
      "8DA101"
      "DFA000"
      "3A94C5"
      "DF69BA"
      "35A77C"
      "DFDDC8"
    ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ionut = {
    isNormalUser = true;
    description = "ionut";
    extraGroups = [
      "input"
      "audio"
      "networkmanager"
      "wheel"
      "video"
    ];
    packages = with pkgs; [];
  };

  #default shell also bash
  users.defaultUserShell = pkgs.zsh;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix.settings.warn-dirty = false;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  # List packages installed in system profile.

  environment.systemPackages =
    (with pkgs; [
      #bluetooth and sound
      pipewire
      wireplumber
      alsa-lib
      pavucontrol
      pwvucontrol
      bluez-tools
      bluez

      #Utils
      rar
      unzip
      zip
      brillo

      brightnessctl
      networkmanager
      networkmanagerapplet
      speedtest-cli
      calcurse

      lazygit
      git
      starship
      wl-clipboard
      peek
      grim
      slurp
      nsxiv
      zathura
      lf
      kitty
      trash-cli
      pistol
      imagemagick
      ghostscript
      poppler
      hplipWithPlugin
      cups

      tmux
      mpv
      lsd
      cmatrix
      cava
      lshw
      pandoc
      texliveTeTeX

      #obsidian
      obs-studio
      ffmpeg

      #utilities
      entr
      udiskie
      udisks
      ncdu
      btop
      nvitop

      asusctl

      discord
      signal-desktop
      jre
      # Javascriptar
      #pnpm
      #nodejs
      nodePackages.live-server

      neovim
      inkscape
      libreoffice
      librecad

      #GNOME extensions
      gnome-tweaks
      gnomeExtensions.forge
      gnomeExtensions.unite
      gnomeExtensions.appindicator
      gnomeExtensions.blur-my-shell
      gnomeExtensions.gsconnect
      gnomeExtensions.just-perfection
      gnomeExtensions.quick-settings-tweaker

      gnome-calculator
      gnome-calendar

      firefox

      fastfetch

      #Dev
      platformio

      lutris
      inputs.pollymc.packages.${pkgs.system}.pollymc

      xboxdrv
      heroic
      wine
      wine-wayland
      wineWowPackages.stable
      wineWowPackages.waylandFull

      bottles
      fragments
      alacritty

      prusa-slicer
      #Tiganie pt freecad
      (pkgs.symlinkJoin {
        name = "FreeCAD";
        paths = [pkgs.freecad-wayland];
        buildInputs = [pkgs.makeWrapper];
        postBuild = ''
          wrapProgram $out/bin/FreeCAD \
          --set __GLX_VENDOR_LIBRARY_NAME mesa \
          --set __EGL_VENDOR_LIBRARY_FILENAMES ${pkgs.mesa.drivers}/share/glvnd/egl_vendor.d/50_mesa.json
        '';
        meta.mainProgram = "FreeCAD";
      })

      wget
      gnome-clocks
      nautilus
      xfce.thunar
      xfce.tumbler
      gvfs

      #Dev
      marp-cli
      clang
      llvm
      gcc
      cmake
      gnumake
      fd
      bat
      #Blender stuf
      mesa
      libGL
      vulkan-loader

      #style formatter
      lua54Packages.luacheck
      lua54Packages.luarocks
      lua-language-server
      stylua
      eslint

      shellcheck
      #nodePackages_latest.prettier

      #GTK
      gtk2
      gtk3
      gtk4
      glib
      #lxappearance-gtk2
      gnome-themes-extra
      adwaita-icon-theme
      gtk-engine-murrine
      gruvbox-gtk-theme
      gruvbox-dark-gtk

      #Hyprland rice
      qt5.qtwayland
      qt6.qtwayland
      pkgs.dunst
      waybar

      #hyprpanel
      nwg-displays
      wofi
      pam
      mpd

      #X11 stuff
      xwayland-run
      wlogout
      hypridle
      hyprlock
      hyprpaper
      xdg-utils
      libnotify
      bibata-cursors

      #Secure boot
      #sbctl
      #niv

      #Nix Stuff
      home-manager
      nh
      alejandra
    ])
    ++ (with pkgs-unstable; [
      rustc
      rust-analyzer
      rustfmt

      blender
      cargo

      waypaper
    ]);

  #fonts
  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [
        "JetBrainsMono"
        "CascadiaMono"
        "Noto"
        "GeistMono"
      ];
    })
  ];
  #Wayland
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk];

  # Services

  security.rtkit.enable = true;

  services.power-profiles-daemon.enable = false;

  services = {
    printing.enable = true;
    printing.drivers = [pkgs.hplipWithPlugin];

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "never";
        };
      };
    };

    logind = {
      lidSwitch = "suspend";
      lidSwitchDocked = "suspend";
      lidSwitchExternalPower = "suspend";
    };
    flatpak.enable = true;

    pipewire = {
      enable = true;
      audio.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.extraConfig = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.roles" = ["hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag"];
        };
      };
    };

    blueman.enable = true;

    asusd = {
      enable = true;
      profileConfig = "Quiet";
      enableUserService = true;
      userLedModesConfig = "rainbow-cycle";
    };

    udisks2.enable = true;
    udev.packages = [
      pkgs.platformio-core
      pkgs.openocd
    ];

    mpd = {
      enable = true;
      startWhenNeeded = true;
    };
  };

  #programs
  programs.zsh.enable = true;

  programs.fish = {
    enable = true;
    shellAbbrs = {
      preloadw = "hyprctl hyprpaper preload";
      wall = "hyprctl hyprpaper wallpaper";
    };
  };
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/ionut/.config/home-manager";
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  #SSH config
  programs.ssh = {
    startAgent = true;
  };
  #users.users."ionut".openssh.authorizedKeys.keyFiles = [
  #  #./etc/ssh/keygen
  #];

  # Enable  the OpenSSH daemon.
  services.openssh.enable = true;

  programs.xwayland.enable = true;
  #Hyprland setup
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  programs.steam = {
    enable = true;
  };
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  environment.sessionVariables = {
    KWIN_DRM_NO_AMS = "1";
    WLR_NO_HARDWARE_CURSOR = "1";
    NIXOS_OZONE_WL = "1";
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  hardware = {
    graphics.enable = true;
    cpu.amd.updateMicrocode = true;

    pulseaudio.enable = false;
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
    bluetooth.settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;

      prime = {
        sync.enable = true;
        #change offload when need to be separte
        #offload = {
        #  enable = true;
        #  enableOffloadCmd = true;
        #};
        amdgpuBusId = "PCI:5:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      #package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      #  version = "555.58.02";
      #  sha256_64bit = "sha256-xctt4TPRlOJ6r5S54h5W6PT6/3Zy2R4ASNFPu8TSHKM=";
      #  sha256_aarch64 = "sha256-wb20isMrRg8PeQBU96lWJzBMkjfySAUaqt4EgZnhyF8=";
      #  openSha256 = "sha256-8hyRiGB+m2hL3c9MDA/Pon+Xl6E788MZ50WrrAGUVuY=";
      #  settingsSha256 = "sha256-ZpuVZybW6CFN/gz9rx+UJvQ715FZnAOYfHn5jt5Z2C8=";
      #  persistencedSha256 = "sha256-a1D7ZZmcKFWfPjjH1REqPM5j/YLWKnbkP9qfRyIyxAw=";
      #};
    };
  };
  environment.etc = {
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
