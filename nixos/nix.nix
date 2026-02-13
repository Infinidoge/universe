{
  self,
  config,
  inputs,
  pkgs,
  lib,
  secrets,
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

    registry = {
      nixpkgs.flake = inputs.nixpkgs;
      latest.flake = inputs.latest;
      devshell.flake = inputs.devshell;
      flake-parts.flake = inputs.flake-parts;
      universe = {
        to.url = "file:///etc/nixos";
        to.type = "git";
      };
      local = {
        exact = false;
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

  environment.systemPackages = with pkgs; [
    nix-diff
    nix-du
    nix-inspect
    nix-melt
    nix-output-monitor
    nix-tree
    nixfmt
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
      srch = "ns nixpkgs";
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

  nix.buildMachines = lib.mkIf (config.networking.hostName != "daedalus") [
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
        automatic = lib.mkDefault true;
        dates = lib.mkDefault "weekly";
        options = lib.mkDefault "--delete-older-than 7d";
      };
    }
  ];

  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://hydra.inx.moe?priority=10"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "infinidoge-1:uw2A6JHHdGJ9GPk0NEDnrdfVkPp0CUY3zIvwVgNlrSk="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
}
