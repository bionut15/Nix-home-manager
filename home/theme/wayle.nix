{
  config,
  pkgs,
  services,
  ...
}: {
  services.wayle = {
    enable = true;
    settings = {
      bar = {
        layout = [
          {
            center = [
            ];
            right= [
              "media"
              "network"
              "volume"
              "systray"
		  "idle-inhibit"
              "clock"
            ];
            monitor = "*";
            left= [
		  "dashboard"
		  "hyprland-workspaces"
              "window-title"
            ];
          }
        ];
        location = "top";
        rounding = "none";
        scale = 1;
      };
      modules = {
        clock = {
          format = "%H:%M";
          icon-show = true;
          label-show = true;
        };
      };
      styling = {
	  barbuttonvariant ="icon-square";
        palette = {
          bg = "#16161e";
          fg = "#c0caf5";
          primary = "#7aa2f7";
        };
        theme-provider = "wayle";
      };
    };
  };
}
