{
  config,
  pkgs,
  inputs,
  ...
}:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    niri = "niri";
    rofi = "rofi";
    mako = "mako";
    helix = "helix";
    hypr = "hypr";
    sway = "sway";
    mango = "mango";
  };
in
{
  imports = [
    inputs.nfsm-flake.homeModules.default
  ];
  home.username = "amitay";
  home.homeDirectory = "/home/amitay";
  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
    settings = {
      shell = "fish";
      font_family = "JetBrainsMono Nerd Font";
      font_size = 16;
      background_opacity = "0.9";
      confirm_os_window_close = 0;
    };
  };
  home.sessionVariables = {
    XCURSOR_SIZE = "24";
    XDG_DATA_DIRS = "$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:$XDG_DATA_DIRS";
  };
  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    x11.enable = true;
    gtk.enable = true;
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo I use nixos, btw";
      nsbf = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#amitay_btw";
    };
  };

  programs.ssh = {
    enable = true;
    settings = {
      "*" = {
        AddKeysToAgent = true;
      };
    };
  };
  services.ssh-agent.enable = true;
  programs.git = {
    enable = true;
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFejeoxSP3UlXKP6SViuqndIZB+SXsvX+zin1g4S/ets amitay@nixos";
      signByDefault = true;
    };
    settings = {
      gpg = {
        format = "ssh";
      };
      user = {
        name = "AmitayBenish";
        email = "amitay.amitay2@gmail.com";
      };
    };
  };

  programs.fish = {
    enable = true;
    shellInit = ''
      direnv hook fish | source
      set -gx EDITOR hx
      set -gx VISUAL hx
    '';
    shellAliases = {
      nsbf = "sudo nixos-rebuild switch --flake .#amitay_btw";
    };

    functions = {
      run = "NIXPKGS_ALLOW_UNFREE=1 nix run nixpkgs#$argv[1] --impure";
    };
  };

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;

  }) configs;

  services.mako.enable = true;

  # `default` means the value is the default value.
  # This option creates a systemd service for daemon
  services.nfsm = {
    enable = true;
    enableCli = true; # default
    socketPath = "/run/user/1000/nfsm.sock"; # default
  };

  services.hypridle = {
    enable = true;
  };

  programs.keychain = {
    enable = true;
    keys = [ "id_ed25519" ]; # ודא שזהו שם המפתח שלך
    agents = [ "ssh" ];
  };

  home.packages = with pkgs; [
    nixd
    nixfmt
    (waybar.overrideAttrs (oldAttrs: {
      src = inputs.waybar-latest;
      mesonFlags = (oldAttrs.mesonFlags or [ ]) ++ [
        "-Dmango=true"
        "-Dcava=disabled"
      ];
      buildInputs = (oldAttrs.buildInputs or [ ]) ++ [
        pkgs.modemmanager
      ];
    }))
    rofi
    grim
    slurp
    wl-clipboard
    libnotify
    btop
    mpv
    libreoffice
    (pkgs.slstatus.overrideAttrs (_: {
      src = ./config/slstatus;
      patches = [ ];
    }))
    swaybg
    pamixer
    pavucontrol
    moonlight-qt
    hyprlock
    swayfx
    stremio-linux-shell
  ];
  home.stateVersion = "26.05";
}
