{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    niri = "niri";
    rofi = "rofi";
    mako = "mako";
    helix = "helix";
  };
in
{
  home.username = "amitay";
  home.homeDirectory = "/home/amitay";
  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
    settings = {
      shell = "fish";
      font_familty = "JetBrainsMono Nerd Font";
      font_size = 12;
      background_opacity = "0.9";
      confirm_os_window_close = 0;
    };
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
    addKeysToAgent = "yes";
  };
  services.ssh-agent.enable = true;
  programs.git = {
    enable = true;
    userName = "AmitayBenish";
    userEmail = "amitay.amitay2@gmail.com";
    signing = {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKIJKBHEkA0TdNbcxZxoBRqHZK30Ja5XBPrSq0bhxGFt amitay.amitay2@gmail.com";
      signByDefault = true;
    };
    settings = {
      gpg = {
        format = "ssh";
      };
    };
  };

  programs.fish = {
    enable = true;
    shellInit = ''
      direnv hook fish | source
    '';
  };

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;

  }) configs;

  services.mako.enable = true;
  home.packages = with pkgs; [
    nixd
    nixfmt-rfc-style
    waybar
    rofi
    grim
    slurp
    wl-clipboard
    libnotify
    btop
    (pkgs.slstatus.overrideAttrs (_: {
      src = ./config/slstatus;
      patches = [ ];
    }))
    swaybg
  ];
  home.stateVersion = "26.05";
}
