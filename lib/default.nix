{ lib }:
lib.makeExtensible (self:
  {
    flattenListSet = imports: (lib.lists.flatten (builtins.concatLists (builtins.attrValues imports)));
    flattenSetList = attrSet: (builtins.mapAttrs (name: value: lib.lists.flatten value) attrSet);
  }
)
