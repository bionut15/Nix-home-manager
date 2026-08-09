{
  config,
  inputs,
  pkgs,
  pkgs-unstable,
  ...
}: {
  imports = [
    ./../hosts/pc_dual_boot/hardware-configuration.nix
    ./../hosts/desktop_apps.nix
    ./../hosts/programs.nix
    ./../hosts/services.nix
    # ./../hosts/NixPad/nvf_config.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.editor = false;
  boot.loader.systemd-boot.sortKey = "20-nixos";
  # boot.loader.systemd-boot.windows."windows11".sortKey = "10-windows";

  boot.loader.systemd-boot.extraEntries = {
    "windows11.conf" = ''
       title Windows 11
       efi   /EFI/Microsoft/Boot/bootmgfw.efi
       options root=UUID=A8E6-5E62
      sort-key 10-windows
    '';
  };

  networking = {
    hostName = "pc_dual_boot";

    firewall = {
      allowedTCPPorts = [2222 443 8080];
      enable = false;
    };

    networkmanager.enable = true;
  };

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
      "dialout"
    ];
    packages = with pkgs; [];
  };

  #default shell also bash
  users.defaultUserShell = pkgs.zsh;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix = {
    settings.warn-dirty = false;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  #fonts
  fonts = {
    fontDir.enable = true;
    packages = [
      pkgs.nerd-fonts.fira-code
      pkgs.nerd-fonts.fira-mono
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.nerd-fonts.caskaydia-mono
      pkgs.nerd-fonts.noto
      pkgs.nerd-fonts.geist-mono
      pkgs.nerd-fonts.dejavu-sans-mono
      pkgs.nerd-fonts.iosevka-term
      pkgs.nerd-fonts.iosevka-term-slab
    ];
  };

  #Wayland
  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk];
  };

  security.rtkit.enable = true;
  security.pam.services.wayland.enableGnomeKeyring = true;

  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=yes
    AllowHybridSleep=yes
    AllowSuspendThenHibernate=yes
  '';

  environment.sessionVariables = {
    KWIN_DRM_NO_AMS = "1";
    WLR_NO_HARDWARE_CURSOR = "1";
    NIXOS_OZONE_WL = "1";
    EDITOR = "nvim";
    VISUAL = "nvim";
    QT_QPA_PLAFORM = "wayland";
    RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
  };

  hardware = {
    graphics.enable = true;
    cpu.amd.updateMicrocode = true;

    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = false;
        };
      };
    };
  };
  environment.etc = {
  };

  system.stateVersion = "23.11"; # Did you read the comment?
}
