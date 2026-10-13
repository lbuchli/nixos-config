{ username }: {
  enable = true;
  systemd.enable = true;
  settings = {
    theme = {
      mode = "dark";
      source = "wallpaper";
      wallpaper_scheme = "m3-tonal-spot";
      pure_black_dark = true;
    };

    wallpaper = {
      enabled = true;
      default.path = "/home/${username}/wallpaper.jpg";
    };

    bar.default = {
      position = "left";
      reserve_space = true;
      concave_edge_corners = false;
      radius = 0;
      margin_ends = 0;
      start = [
        "launcher"
        "privacy"
        "session"
      ];
      center = [
        "workspaces"
      ];
      end = [
        "battery"
        "clock"
      ];
    };

    shell = {
      launcher = {
        layout = "simple";
        categories = false;
        app_grid = false;

        providers = {
          panels = {
            global = true;
          };
          windows = {
            global = true;
          };
        };
      };
      readline_shortcuts = true;
    };

    widget = {
      gap = {
        type = "spacer";
        length = 200;
      };
      workspaces = {
        style = "focus_hint";
        show_icons = true;
      };
    };

    lockscreen_widgets = {
      widget.default = {
        show_media = false;
      };
    };
  };
}
