{ config, channel, inputs, pkgs, lib, self, ... }:
with lib;
{
  nix = {
    package = pkgs.nixUnstable;

    settings = {
      allowed-users = [ "@wheel" ];

      trusted-users = [ "root" "@wheel" ];

      system-features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];

      auto-optimise-store = true;

      sandbox = true;
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 3d";
      dates = "weekly";
    };

    optimise.automatic = true;

    extraOptions = ''
      min-free = 536870912
      keep-outputs = true
      keep-derivations = true
      fallback = true
    '' + (if config.modules.secrets.enable then ''
      secret-key-files = ${config.secrets.binary-cache-private-key}
    '' else "");

    # nixPath = [
    #   "nixpkgs=${channel.input}"
    #   "nixos-config=${../../lib/compat/nixos}"
    #   "home-manager=${inputs.home}"
    # ];

    localRegistry = {
      enable = true;
      cacheGlobalRegistry = true;
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
  };


  environment = {
    systemPackages = with pkgs; [
      nix-index
      nixos-option
      nixfmt
      nixpkgs-fmt
      nix-du
      comma

      (writeScriptBin "wherenix" ''
        #!/usr/bin/env bash
        ${unixtools.whereis}/bin/whereis "''${@}" \
        | ${gawk}/bin/awk '{ print substr($0, length($1)+2) }' \
        | ${findutils}/bin/xargs -r ${coreutils}/bin/readlink -f \
        | ${coreutils}/bin/sort \
        | ${coreutils}/bin/uniq
      '')
    ];

    shellAliases =
      let ifSudo = mkIf config.security.sudo.enable;
      in
      {
        # nix
        n = "nix";
        np = "n profile";
        ni = "np install";
        nr = "np remove";
        ns = "n search --no-update-lock-file";
        nf = "n flake";
        nepl = "n repl '<nixpkgs>'";
        srch = "ns nixos";
        nrb = ifSudo "sudo nixos-rebuild";
        mn = ''
          manix "" | grep '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | sk --preview="manix '{}'" | xargs manix
        '';

        # fix nixos-option
        # nixos-option = "nixos-option -I nixpkgs=${self}/lib/compat";
      };
  };
}
