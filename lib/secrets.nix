{
  withOwnerGroup = name: rekeyFile: {
    owner = name;
    group = name;
    mode = "440";
    inherit rekeyFile;
  };
  withOwner = owner: rekeyFile: { inherit owner rekeyFile; };
  withGroup = group: rekeyFile: {
    inherit group rekeyFile;
    mode = "440";
  };
}
