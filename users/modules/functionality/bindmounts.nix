{ config, pkgs, lib, ... }:

# Modified from https://github.com/nix-community/impermanence/blob/master/home-manager.nix

with lib;
with lib.our;
let
  cfg = config.home.bindmounts;

  persistentStoragePaths = attrNames cfg;
in
{
  options = {

    home.bindmounts = mkOption {
      default = { };
      type = with types; attrsOf (
        submodule ({ name, ... }: {
          options =
            {
              directories = mkOption {
                type = with types; listOf (submodule {
                  options = {
                    source = mkOption {
                      type = with types; str;
                    };

                    target = mkOption {
                      type = with types; str;
                    };
                  };
                });
                default = [ ];
                description = ''
                  A list of directories and target locations that you wish to bind-mount from the initial source.
                '';
              };

              allowOther = mkOption {
                type = with types; nullOr bool;
                default = null;
                example = true;
                apply = x:
                  if x == null then
                    warn ''
                      home.bindmounts."${name}".allowOther not set; assuming 'false'.
                      See https://github.com/nix-community/impermanence#home-manager for more info.
                    ''
                      false
                  else
                    x;
                description = ''
                  Whether to allow other users, such as
                  <literal>root</literal>, access to files through the
                  bind mounted directories listed in
                  <literal>directories</literal>. Requires the NixOS
                  configuration parameter
                  <literal>programs.fuse.userAllowOther</literal> to
                  be <literal>true</literal>.
                '';
              };
            };
        })
      );
    };

  };

  config = {
    systemd.user.services =
      let
        mkBindMountService = persistentStoragePath: dir:
          let
            inherit (dir) source target;
            targetDir = escapeShellArg (concatPaths [ persistentStoragePath source ]);
            mountPoint = escapeShellArg (concatPaths [ config.home.homeDirectory target ]);
            name = "bindMount-${sanitizeName targetDir}";
            bindfsOptions = concatStringsSep "," (
              optional (!cfg.${persistentStoragePath}.allowOther) "no-allow-other"
              ++ optional (versionAtLeast pkgs.bindfs.version "1.14.9") "fsname=${targetDir}"
            );
            bindfsOptionFlag = optionalString (bindfsOptions != "") (" -o " + bindfsOptions);
            bindfs = "bindfs -f" + bindfsOptionFlag;
            startScript = pkgs.writeShellScript name ''
              set -eu
              if ! mount | grep -F ${mountPoint}' ' && ! mount | grep -F ${mountPoint}/; then
                  mkdir -p ${mountPoint}
                  ${bindfs} ${targetDir} ${mountPoint}
              else
                  echo "There is already an active mount at or below ${mountPoint}!" >&2
                  exit 1
              fi
            '';
            stopScript = pkgs.writeShellScript "unmount-${name}" ''
              set -eu
              triesLeft=6
              while (( triesLeft > 0 )); do
                  if fusermount -u ${mountPoint}; then
                      exit 0
                  else
                      (( triesLeft-- ))
                      if (( triesLeft == 0 )); then
                          echo "Couldn't perform regular unmount of ${mountPoint}. Attempting lazy unmount."
                          fusermount -uz ${mountPoint}
                      else
                          sleep 5
                      fi
                  fi
              done
            '';
          in
          {
            inherit name;
            value = {
              Unit = {
                Description = "Bind mount ${targetDir} at ${mountPoint}";

                # Don't restart the unit, it could corrupt data and
                # crash programs currently reading from the mount.
                X-RestartIfChanged = false;
              };

              Install.WantedBy = [ "default.target" ];

              Service = {
                ExecStart = "${startScript}";
                ExecStop = "${stopScript}";
                Environment = "PATH=${makeBinPath [ pkgs.coreutils pkgs.util-linux pkgs.gnugrep pkgs.bindfs ]}:/run/wrappers/bin";
              };
            };
          };

        mkBindMountServicesForPath = persistentStoragePath:
          listToAttrs (map
            (mkBindMountService persistentStoragePath)
            cfg.${persistentStoragePath}.directories
          );
      in
      builtins.foldl'
        recursiveUpdate
        { }
        (map mkBindMountServicesForPath persistentStoragePaths);

    home.activation =
      let
        dag = config.lib.dag;

        # The name of the activation script entry responsible for
        # reloading systemd user services. The name was initially
        # `reloadSystemD` but has been changed to `reloadSystemd`.
        reloadSystemd =
          if config.home.activation ? reloadSystemD then
            "reloadSystemD"
          else
            "reloadSystemd";

        mkBindMount = persistentStoragePath: dir:
          let
            inherit (dir) source target;
            targetDir = escapeShellArg (concatPaths [ persistentStoragePath source ]);
            mountPoint = escapeShellArg (concatPaths [ config.home.homeDirectory target ]);
            mount = "${pkgs.util-linux}/bin/mount";
            bindfsOptions = concatStringsSep "," (
              optional (!cfg.${persistentStoragePath}.allowOther) "no-allow-other"
              ++ optional (versionAtLeast pkgs.bindfs.version "1.14.9") "fsname=${targetDir}"
            );
            bindfsOptionFlag = optionalString (bindfsOptions != "") (" -o " + bindfsOptions);
            bindfs = "${pkgs.bindfs}/bin/bindfs" + bindfsOptionFlag;
            systemctl = "XDG_RUNTIME_DIR=\${XDG_RUNTIME_DIR:-/run/user/$(id -u)} ${config.systemd.user.systemctlPath}";
          in
          ''
            mkdir -p ${targetDir}
            mkdir -p ${mountPoint}
            if ${mount} | grep -F ${mountPoint}' ' >/dev/null; then
                if ! ${mount} | grep -F ${mountPoint}' ' | grep -F bindfs; then
                    if ! ${mount} | grep -F ${mountPoint}' ' | grep -F ${targetDir}' ' >/dev/null; then
                        # The target directory changed, so we need to remount
                        echo "remounting ${mountPoint}"
                        ${systemctl} --user stop bindMount-${sanitizeName targetDir}
                        ${bindfs} ${targetDir} ${mountPoint}
                        mountedPaths[${mountPoint}]=1
                    fi
                fi
            elif ${mount} | grep -F ${mountPoint}/ >/dev/null; then
                echo "Something is mounted below ${mountPoint}, not creating bind mount to ${targetDir}" >&2
            else
                ${bindfs} ${targetDir} ${mountPoint}
                mountedPaths[${mountPoint}]=1
            fi
          '';

        mkBindMountsForPath = persistentStoragePath:
          concatMapStrings
            (mkBindMount persistentStoragePath)
            cfg.${persistentStoragePath}.directories;

        mkUnmount = persistentStoragePath: dir:
          let
            inherit (dir) target;
            mountPoint = escapeShellArg (concatPaths [ config.home.homeDirectory target ]);
          in
          ''
            if [[ -n ''${mountedPaths[${mountPoint}]+x} ]]; then
                triesLeft=3
                while (( triesLeft > 0 )); do
                    if fusermount -u ${mountPoint}; then
                        break
                    else
                        (( triesLeft-- ))
                        if (( triesLeft == 0 )); then
                            echo "Couldn't perform regular unmount of ${mountPoint}. Attempting lazy unmount."
                            fusermount -uz ${mountPoint} || true
                        else
                            sleep 1
                        fi
                    fi
                done
            fi
          '';

        mkUnmountsForPath = persistentStoragePath:
          concatMapStrings
            (mkUnmount persistentStoragePath)
            cfg.${persistentStoragePath}.directories;

      in
      mkIf (any (path: cfg.${path}.directories != [ ]) persistentStoragePaths) {
        createAndMountPersistentStoragePaths =
          dag.entryBefore
            [ "writeBoundary" ]
            ''
              declare -A mountedPaths
              ${(concatMapStrings mkBindMountsForPath persistentStoragePaths)}
            '';

        unmountPersistentStoragePaths =
          dag.entryBefore
            [ "createAndMountPersistentStoragePaths" ]
            ''
              unmountBindMounts() {
              ${concatMapStrings mkUnmountsForPath persistentStoragePaths}
              }
              # Run the unmount function on error to clean up stray
              # bind mounts
              trap "unmountBindMounts" ERR
            '';

        runUnmountPersistentStoragePaths =
          dag.entryBefore
            [ reloadSystemd ]
            ''
              unmountBindMounts
            '';
      };
  };

}
