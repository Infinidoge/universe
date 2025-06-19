{ pkgs, ... }:
{
  home.packages = with pkgs; [
    git-absorb
    git-crypt
    git-agecrypt

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
      branch.sort = "-committerdate";
      commit.verbose = true;
      init.defaultBranch = "master";
      merge.ignore.driver = "true";
      pull.rebase = true;
      push.autoSetupRemote = true;
      status.showUntrackedFiles = "all";
      absorb = {
        maxStack = 20;
        oneFixupPerCommit = true;
        autoStageIfNothingStaged = true;
      };
      protocol.file.allow = "always";
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
      pup = "!git pull && git push";
      puap = "!git pull --autostash && git push";
      b = "branch";
      ba = "branch -a";
      bd = "branch -d";
      bD = "branch -D";
      d = "diff";
      dc = "diff --cached";
      ds = "diff --staged";
      dh = "diff HEAD~1 HEAD";
      r = "restore -p";
      rs = "restore --staged -p";
      sw = "switch";
      st = "status -sb";
      rb = "rebase -i --autosquash";
      arb = "absorb --and-rebase";

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

      root = "rev-parse --show-toplevel";
      fzf = "!git-fzf";
      edit = "!git-fzf-edit";
      e = "edit";
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      prompt = "enabled";
      git_protocol = "ssh";
      aliases = {
        co = "pr checkout";
        clone = "repo clone";
      };
    };
  };
}
