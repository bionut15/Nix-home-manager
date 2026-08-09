{
  config,
  inputs,
  pkgs,
  ...
}: {
  services = {
    openssh.enable = true;

    power-profiles-daemon.enable = false;

    xserver = {
      enable = true;
      videoDrivers = ["amdgpu"];
      displayManager.startx.enable = true;
    };

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd Hyprland";
          user = "greeter";
        };
      };
    };

    gnome.gnome-keyring.enable = true;
    upower = {
      enable = true;
    };

    desktopManager.plasma6.enable = true;

    displayManager.sddm = {
      enable = true;

      # To use Wayland (Experimental for SDDM)
      wayland.enable = true;
    };

    printing = {
      enable = true;
      drivers = [pkgs.hplipWithPlugin pkgs.hplip];
      listenAddresses = ["*:631"];
      allowFrom = ["all"];
      browsing = true;
      defaultShared = true;
      openFirewall = true;
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        userServices = true;
      };
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

    # logind = {
    #   settings.lidSwitch = "suspend";
    #   settings.lidSwitchDocked = "suspend";
    #   settings.lidSwitchExternalPower = "suspend";
    # };
    flatpak.enable = true;

    pipewire = {
      enable = true;

      audio.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;

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

    udisks2.enable = true;
    udev.packages = [
      pkgs.platformio-core
      pkgs.openocd
    ];

    pulseaudio.enable = false;

    mpd = {
      enable = true;
      startWhenNeeded = true;
    };
  };
}
