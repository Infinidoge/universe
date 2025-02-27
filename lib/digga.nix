{ lib }:
# Importers from digga: https://github.com/divnix/digga/blob/main/src/importers.nix
# Plus the mkHomeConfigurations generator from digga: https://github.com/divnix/digga/blob/main/src/generators.nix
let
  flattenTree' =
    /*
      *
        Synopsis: flattenTree' _cond_ _sep_ _tree_

        Flattens a _tree_ of the shape that is produced by rakeLeaves.
        _cond_ determines when to stop recursing
        _sep_ is the separator to join the path with

        Output Format:
        An attrset with names in the spirit of the Reverse DNS Notation form
        that fully preserve information about grouping from nesting.

        Example input:
        ```
        {
          a = {
            b = {
              c = <path>;
            };
          };
        }
        ```

        Example output:
        ```
        {
          "a.b.c" = <path>;
        }
        ```
      *
    */
    cond: sep: tree:
    let
      op =
        sum: path: val:
        let
          pathStr = builtins.concatStringsSep sep path; # dot-based reverse DNS notation
        in
        if cond val then
          # builtins.trace "${toString val} matches condition"
          (sum // { "${pathStr}" = val; })
        else if builtins.isAttrs val then
          # builtins.trace "${builtins.toJSON val} is an attrset"
          # recurse into that attribute set
          (recurse sum path val)
        else
          # ignore that value
          # builtins.trace "${toString path} is something else"
          sum;

      recurse =
        sum: path: val:
        builtins.foldl' (sum: key: op sum (path ++ [ key ]) val.${key}) sum (builtins.attrNames val);
    in
    recurse { } [ ] tree;

  flattenTree = flattenTree' builtins.isPath ".";

  rakeLeaves =
    /*
      *
        Synopsis: rakeLeaves _path_

        Recursively collect the nix files of _path_ into attrs.

        Output Format:
        An attribute set where all `.nix` files and directories with `default.nix` in them
        are mapped to keys that are either the file with .nix stripped or the folder name.
        All other directories are recursed further into nested attribute sets with the same format.

        Example file structure:
        ```
        ./core/default.nix
        ./base.nix
        ./main/dev.nix
        ./main/os/default.nix
        ```

        Example output:
        ```
        {
        core = ./core;
        base = base.nix;
        main = {
        dev = ./main/dev.nix;
        os = ./main/os;
        };
        }
        ```
      *
    */
    dirPath:
    let
      seive =
        file: type:
        # Only rake `.nix` files or directories
        (type == "regular" && lib.hasSuffix ".nix" file) || (type == "directory");

      collect = file: type: {
        name = lib.removeSuffix ".nix" file;
        value =
          let
            path = dirPath + "/${file}";
          in
          if (type == "regular") || (type == "directory" && builtins.pathExists (path + "/default.nix")) then
            path
          # recurse on directories that don't contain a `default.nix`
          else
            rakeLeaves path;
      };

      files = lib.filterAttrs seive (builtins.readDir dirPath);
    in
    lib.filterAttrs (n: v: v != { }) (lib.mapAttrs' collect files);

  flattenLeaves = dir: flattenTree (rakeLeaves dir);

  getFqdn =
    c:
    let
      net = c.config.networking;
      fqdn =
        if (net ? domain) && (net.domain != null) then "${net.hostName}.${net.domain}" else net.hostName;
    in
    fqdn;
in
{
  inherit
    rakeLeaves
    flattenTree
    flattenTree'
    flattenLeaves
    ;

  leaves = dir: builtins.attrValues (flattenLeaves dir);

  mkHomeConfigurations =
    systemConfigurations:
    /*
      *
        Synopsis: mkHomeConfigurations _systemConfigurations_

        Generate the `homeConfigurations` attribute expected by `home-manager` cli
        from _nixosConfigurations_ or _darwinConfigurations_ in the form
        _user@hostname_.
      *
    */
    let
      op =
        attrs: c:
        attrs
        // (lib.mapAttrs' (user: v: {
          name = "${user}@${getFqdn c}";
          value = v.home;
        }) c.config.home-manager.users);
      mkHmConfigs = lib.foldl op { };
    in
    mkHmConfigs (builtins.attrValues systemConfigurations);

}
