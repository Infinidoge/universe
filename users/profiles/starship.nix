{ ... }: {
  programs.starship = {
    enable = true;
    enableBashIntegration = true;

    settings = {
      prompt = {
        add_newline = true;

        format = ''
          (╢$status$cmd_duration)
          [┌───┨$shlvl┠──┨$shell┠────────>](bold green) $username@$hostname
          [│](bold green)$directory$git_branch$git_commit$git_state$git_metrics$git_status$vcsh$hg_branch
          ([|](bold green)$crystal$dart$deno$dotnet$elixir$elm$erlang$golang$helm$java$julia$kotlin$lua$nim$nodejs$ocaml$perl$php$purescript$python$red$ruby$rust$scaly$swift$terraform$vlang$vagrant$zig)
          ([|](bold green)$nix_shell$conda$docker_context$package$cmake$kubernetes$env_var)
          ([|](bold green)$aws$gcloud$openstack)
          [└─](bold green) $character
        '';
      };
      character = {
        success_symbol = "[❯](bold purple)";
        vicmd_symbol = "[❮](bold purple)";
      };

      # conda.symbol = " ";
      # docker.symbol = " ";
      # haskell.symbol = " ";
      # hg_branch.symbol = " ";
      # java.symbol = " ";
      # package.symbol = " ";
      # python.symbol = " ";

      directory = {
        style = "cyan";
        read_only = " 🔒";
      };

      git_branch = {
        format = "[$symbol$branch]($style) ";
        symbol = " ";
        style = "bold dimmed white";
      };

      git_status = {
        format = "([「$all_status$ahead_behind」]($style) )";
        conflicted = "⚠️";
        ahead = "⟫$${count} ";
        behind = "⟪$${count}";
        diverged = "🔀 ";
        untracked = "📁 ";
        stashed = "↪ ";
        modified = "𝚫 ";
        staged = "✔ ";
        renamed = "⇆ ";
        deleted = "✘ ";
        style = "bold bright-white";
      };

      nix_shell = {
        format = "[$symbol$state]($style) ";
        symbol = " ";
        pure_msg = "λ";
        impure_msg = "⎔";
      };

      status = {
        disabled = false;
      };

      # aws.disabled = true;
      # battery.disabled = true;
      # cmake.disabled = true;
      # crystal.disabled = true;
      # dart.disabled = true;
      # deno.disabled = true;
      # dotnet.disabled = true;
      # elixer.disabled = true;
      # elm.disabled = true;
      # erlang.disabled = true;
      # gcloud.disabled = true;
      # goland.disabled = true;
      # helm.disabled = true;
      # julia.disabled = true;
      # kotlin.disabled = true;
      # kubernetes.disabled = true;
      # memory_usage.disabled = true;
      # hg_branch.disabled = true;
      # nim.disabled = true;
      # nodejs.disabled = true;
      # ocaml.disabled = true;
      # openstack.disabled = true;

      # prompt.disabled = false;
      # character.disabled = false;
      # cmd_duration.disabled = false;
      # conda.disabled = false;
      # directory.disabled = false;
      # docker.disabled = false;
      # env_var.disabled = false;
      # git_branch.disabled = false;
      # git_commit.disabled = false;
      # git_state.disabled = false;
      # git_metrics.disabled = false;
      # git_status.disabled = false;
      # hostname.disabled = false;
      # jobs.disabled = false;
      # line_break.disabled = false;
      # nix_shell.disabled = false;

      # java.disabled = false;
      # lua.disabled = false;

    };
  };
}
