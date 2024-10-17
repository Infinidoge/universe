{ config, inputs, pkgs, lib, ... }:
let
  inherit (lib) mkIf mkDefault filterAttrs mapAttrs';
in
{
  nix = {
    channel.enable = false;

    settings = {
      allowed-users = [ "*" ];
      trusted-users = [ "root" "@wheel" "remotebuild" "nix-ssh" ];

      system-features = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      experimental-features = [
        "flakes"
        "nix-command"
        "impure-derivations"
        "no-url-literals"
        "pipe-operator"
      ];

      allow-import-from-derivation = true;
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
      "devshell=${inputs.devshell}"
    ];

    distributedBuilds = mkDefault true;
    extraOptions = ''
      builders-use-substitutes = true
    '';

    sshServe = {
      enable = mkDefault true;
      write = true;
      keys = config.user.openssh.authorizedKeys.keys;
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  programs.nix-ld.enable = mkDefault true;

  programs.nix-index-database.comma.enable = true;
  programs.nix-index = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = false;
    enableFishIntegration = false;
  };

  universe.packages = with pkgs; [
    nix-diff
    nix-du
    nix-melt
    nix-output-monitor
    nix-tree
    nixfmt-rfc-style
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
    shellAliases = {
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
