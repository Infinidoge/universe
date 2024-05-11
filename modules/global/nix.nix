{ config, channel, inputs, pkgs, lib, self, ... }:
with lib;
{
  nix = {
    package = pkgs.nixVersions.latest;

    channel.enable = false;

    settings = {
      allowed-users = [ "*" ];
      trusted-users = [ "root" "@wheel" "remotebuild" ];

      system-features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      experimental-features = [ "flakes" "nix-command" "impure-derivations" "no-url-literals" ];

      auto-optimise-store = true;
      fallback = true;
      keep-derivations = true;
      keep-outputs = true;
      sandbox = true;
      use-xdg-base-directories = true;

      flake-registry = "${inputs.flake-registry}/flake-registry.json";
      secret-key-files = mkIf config.modules.secrets.enable config.secrets.binary-cache-private-key;

      min-free = 536870912; # 0.5 gibi bytes

      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
      dates = "weekly";
    };

    optimise.automatic = true;

    registry =
      let
        flakes = filterAttrs (n: v: v ? outputs) inputs;
      in
      (mapAttrs' (n: v: { name = if n == "self" then "universe" else n; value = { flake = v; }; }) flakes)
      // {
        nixpkgs-git = {
          exact = false;
          from.id = "local";
          from.type = "indirect";
          to.url = "file:///nix/nixpkgs";
          to.type = "git";
        };
      };

    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
      "home-manager=${inputs.home-manager}"
    ];

    distributedBuilds = true;
    extraOptions = ''
      builders-use-substitutes = true
    '';
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.nix-ld.enable = mkDefault true;

  universe.packages = with pkgs; [
    comma
    nix-diff
    nix-du
    nix-index
    nix-melt
    nix-output-monitor
    nix-tree
    nixpkgs-fmt
    nvd

    (writeScriptBin "wherenix" ''
      #!/usr/bin/env bash
      ${unixtools.whereis}/bin/whereis "''${@}" \
      | ${gawk}/bin/awk '{ print substr($0, length($1)+2) }' \
      | ${findutils}/bin/xargs -r ${coreutils}/bin/readlink -f \
      | ${coreutils}/bin/sort \
      | ${coreutils}/bin/uniq
    '')
  ];

  environment = {
    shellAliases =
      let ifSudo = mkIf config.security.sudo.enable;
      in
      {
        # nix
        n = "nix";
        ns = "n search --no-update-lock-file";
        nf = "n flake";
        nepl = "n repl '<nixpkgs>'";
        srch = "ns nixpkgs";
        mn = ''
          manix "" | grep '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | sk --preview="manix '{}'" | xargs manix
        '';
      };
  };

  users.users.remotebuild = {
    description = "Unprivledged user for Nix remote builds";
    isSystemUser = true;
    shell = pkgs.bashInteractive;
    openssh.authorizedKeys.keys = config.users.users.root.openssh.authorizedKeys.keys;
    group = "remotebuild";
  };
  users.groups.remotebuild = { };
}
