{ lib }:
lib.makeExtensible (self:
  {
    flattenListSet = imports: (lib.lists.flatten (builtins.concatLists (builtins.attrValues imports)));
  }
)
