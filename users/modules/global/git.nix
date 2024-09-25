{ pkgs, ... }: {
  home.packages = with pkgs; [
    gh
    git-absorb

    (writeScriptBin "git-fzf" ''
      git ls-files &> /dev/null
      if [[ $? -eq 128 ]] then
        echo "Not in a git repository"
        exit 1
      elif [[ $# -eq 0 ]] then
        echo "$(git ls-files | fzf --filepath-word --multi)"
      else
        echo "$(git ls-files | fzf --filepath-word --multi -1 -q "$*")"
      fi
    '')
    (writeScriptBin "git-fzf-edit" ''
      git ls-files &> /dev/null
      if [[ $? -eq 128 ]] then
        echo "Not in a git repository"
        exit 1
      elif [[ $# -eq 0 ]] then
        git ls-files | fzf --filepath-word --multi | xargs $EDITOR
      else
        git ls-files | fzf --filepath-word --multi -1 -q "$*" | xargs $EDITOR
      fi
    '')
  ];

  programs.git = {
    enable = true;
    package = pkgs.gitFull;

    lfs.enable = true;

    extraConfig = {
      pull.rebase = true;
      merge.ignore.driver = "true";
      init.defaultBranch = "master";
      status.showUntrackedFiles = "all";
      push.autoSetupRemote = true;
      branch.sort = "-committerdate";
    };

    aliases = {
      a = "add -p";
      ai = "add -i";
      an = "add -N";
      co = "checkout";
      cob = "checkout -b";
      f = "fetch -p";
      c = "commit";
      ca = "commit -a";
      caa = "commit -a --amend";
      can = "commit --amend --no-edit";
      caan = "commit -a --amend --no-edit";
      p = "push";
      pfl = "push --force-with-lease";
      pu = "pull";
      pua = "pull --autostash";
      b = "branch";
      ba = "branch -a";
      bd = "branch -d";
      bD = "branch -D";
      d = "diff";
      dc = "diff --cached";
      ds = "diff --staged";
      r = "restore -p";
      rs = "restore --staged -p";
      sw = "switch";
      st = "status -sb";

      # reset
      soft = "reset --soft";
      hard = "reset --hard";
      s1ft = "soft HEAD~1";
      h1rd = "hard HEAD~1";

      # logging
      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      plog = "log --graph --pretty='format:%C(red)%d%C(reset) %C(yellow)%h%C(reset) %ar %C(green)%aN%C(reset) %s'";
      rank = "shortlog -sn --no-merges";

      # delete merged branches
      bdm = "!git branch --merged | grep -v '*' | xargs -n 1 git branch -d";

      crypt = "!git-crypt";

      root = "rev-parse --show-toplevel";
      fzf = "!git-fzf";
      edit = "!git-fzf-edit";
      e = "edit";
    };
  };
}
