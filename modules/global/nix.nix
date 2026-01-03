{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkDefault
    filterAttrs
    mapAttrs'
    ;

  authorizedKeysFiles =
    users: lib.concatStringsSep " " (map (u: "/etc/ssh/authorized_keys.d/${u}") users);
in
{
  nixpkgs.flake = {
    setNixPath = false;
    setFlakeRegistry = false;
  };

  nix = {
    channel.enable = false;

    settings = {
      allowed-users = [ "*" ];
      trusted-users = [
        "root"
        "@wheel"
        "remotebuild"
        "nix-ssh"
      ];

      system-features = [
        "nixos-test"
        "benchmark"
        "big-parallel"
        "kvm"
      ];
      experimental-features = [
        "flakes"
        "nix-command"
        "pipe-operator"
      ];

      allow-import-from-derivation = true;
      auto-optimise-store = true;
      builders-use-substitutes = true;
      fallback = true;
      keep-derivations = true;
      keep-outputs = true;
      sandbox = true;
      use-xdg-base-directories = true;

      # Remove global flake registry
      flake-registry = pkgs.writers.writeJSON "registry.json" {
        flakes = [ ];
        version = 2;
      };

      secret-key-files = mkIf config.modules.secrets.enable config.secrets.binary-cache-private-key;

      min-free = 536870912; # 0.5 gibi bytes

      nix-path = [
        "nixpkgs=${inputs.nixpkgs}"
        "devshell=${inputs.devshell}"
        "local=/nix/nixpkgs"
      ];
    };

    nixPath = config.nix.settings.nix-path;

    gc = {
      automatic = lib.mkDefault true;
      options = lib.mkDefault "--delete-older-than 7d";
      dates = lib.mkDefault "weekly";
    };

    optimise.automatic = true;

    registry =
      let
        flakes = filterAttrs (n: v: v ? outputs) inputs;
      in
      (mapAttrs' (n: v: {
        name = if n == "self" then "universe" else n;
        value = {
          flake = v;
        };
      }) flakes)
      // {
        nixpkgs-git = {
          exact = false;
          from.id = "local";
          from.type = "indirect";
          to.url = "file:///nix/nixpkgs";
          to.type = "git";
        };
      };

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
    nix-inspect
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
    group = "remotebuild";
  };
  users.groups.remotebuild = { };

  services.openssh.extraConfig = ''
    Match user remotebuild
      AuthorizedKeysFile ${
        authorizedKeysFiles [
          "infinidoge"
          "root"
          "%u"
        ]
      }
  '';

  nix.buildMachines = [
    {
      hostName = "daedalus";
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      supportedFeatures = [
        "nixos-test"
        "benchmark"
        "big-parallel"
        "kvm"
      ];
      protocol = "ssh-ng";
      maxJobs = 32;
      speedFactor = 16;
      sshUser = "remotebuild";
    }
  ];

  home-manager.sharedModules = [
    {
      nix.gc = {
        automatic = lib.mkDefault config.nix.gc.automatic;
        dates = lib.mkDefault "weekly";
        options = lib.mkDefault config.nix.gc.options;
      };
    }
  ];
}
