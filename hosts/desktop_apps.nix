{
  config,
  inputs,
  pkgs,
  pkgs-unstable,
  ...
}: {
  environment.systemPackages =
    (with pkgs; [
      #bluetooth and sound
      pipewire
      wireplumber
      alsa-lib
      pkg-config
	xorg.libX11
      pavucontrol
      pwvucontrol
      bluez-tools
      bluez
      libgtop
      sbctl
      efibootmgr
      ntfs3g
      chntpw
      tk
      (python313.withPackages (python-pkgs:
        with python-pkgs; [
          pip
          tkinter
          # python312Full
          opencv4
          customtkinter
          pytesseract
          regex
        ]))
      #Utils
      rar
      unzip
      zip
      brillo
      tree
      ripgrep
      yt-dlp
      pass
      neomutt

      mutt-wizard

      brightnessctl
      networkmanager
      networkmanagerapplet
      logiops

      github-desktop
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
      poppler
      waypaper
      swww

      tmux
      mpv
      lsd
      cmatrix
      cava
      lshw
      pandoc
      texliveTeTeX
      live-server

      obsidian
      obs-studio
      ffmpeg

      #utilities
      entr
      udiskie
      udisks
      ncdu
      btop

      discord
      signal-desktop

      vscodium
      arduino-ide
      libreoffice

      firefox
      inputs.helium.defaultPackage.${system}

      fastfetch

      lutris

      wine
      wine-wayland
      wineWowPackages.stable
      wineWowPackages.waylandFull

      (bottles.override {removeWarningPopup = true;})
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
          --set __EGL_VENDOR_LIBRARY_FILENAMES ${pkgs.mesa}/share/glvnd/egl_vendor.d/50_mesa.json
        '';
        meta.mainProgram = "FreeCAD";
      })

      wget
      nodejs_24
      prettierd

      gnome-keyring
      gnome-clocks
      devtoolbox
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
      pnpm
      #Blender stuf
      libGL
      vulkan-loader

      #style formatter
      lua54Packages.luacheck
      lua54Packages.luarocks
      lua-language-server
      stylua
      eslint
      shellcheck

      #GTK
      gtk2
      gtk3
      gtk4
      glib
      font-manager
      gnome-themes-extra
      adwaita-icon-theme
      gtk-engine-murrine
      gruvbox-gtk-theme
      gruvbox-dark-gtk

      #Hyprland rice
      qt5.qtwayland
      qt6.qtwayland
      pkgs.dunst

      nwg-look
      nwg-displays
      wofi
      pam
      mpd

      #X11 stuff
      xwayland-run
      wlogout
      hypridle
      hyprlock
      wayle
      xdg-utils

      libnotify
      bibata-cursors

      libcxxrt
      clang
      #Nix Stuff
      home-manager
      nh
      alejandra
      #rust stuff
      neovim
      krita
      lazygit
      helix
      vimPlugins.rustaceanvim
      vimPlugins.nvim-dap-lldb
    ])
    ++ (with pkgs-unstable; [
      luajitPackages.rustaceanvim
      lldb_21
      clippy
      cargo
      rustc
      # rustup
      rust-analyzer
      rustfmt

      blender
    ]);
}
