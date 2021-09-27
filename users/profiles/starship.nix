{ ... }: {
  programs.starship = {
    enable = true;
    enableBashIntegration = true;

    settings =
      let
        line_style = "bold green";
        section = {
          user_host = "underline";
        };
      in
      {
        add_newline = true;

        format = ''
          ([╳](bold grey) $status$cmd_duration)
          [┌┨[$username@$hostname](${section.user_host})┠(┨$shell $shlvl┠)──(┨$nix_shell┠)───────────┨](${line_style})
          [┝┫$directory(┣━┫$git_branch$git_status(@$git_commit)( $git_metrics)( $git_state))┃](${line_style})
          [└┨](${line_style})$character
        '';
        # format = ''
        #   (╢$status $cmd_duration\n)[┌───┨$shlvl┠──┨$shell┠────────>](bold green) $username@$hostname
        #   [│](bold green) $directory$git_branch$git_commit$git_state$git_metrics$git_status$vcsh$hg_branch
        #   (\n[|](bold green) $crystal$dart$deno$dotnet$elixir$elm$erlang$golang$helm$java$julia$kotlin$lua$nim$nodejs$ocaml$perl$php$purescript$python$red$ruby$rust$scaly$swift$terraform$vlang$vagrant$zig)
        #   (\n[|](bold green) $nix_shell$conda$docker_context$package$cmake$kubernetes$env_var)
        #   (\n[|](bold green)$aws$gcloud$openstack)
        #   [└─](bold green) $character
        # '';

        character = rec {
          success_symbol = "[❯](bold purple)";
          error_symbol = success_symbol;
          vicmd_symbol = "[❮](bold purple)";
        };

        aws.symbol = "  ";
        conda.symbol = " ";
        dart.symbol = " ";
        docker_context.symbol = " ";
        elixir.symbol = " ";
        elm.symbol = " ";
        golang.symbol = " ";
        hg_branch.symbol = " ";
        java.symbol = " ";
        julia.symbol = " ";
        memory_usage.symbol = " ";
        nim.symbol = " ";
        package.symbol = " ";
        perl.symbol = " ";
        php.symbol = " ";
        python.symbol = " ";
        ruby.symbol = " ";
        rust.symbol = " ";
        scala.symbol = " ";
        swift.symbol = "ﯣ ";

        directory = {
          style = "cyan";
          read_only = " ";
          format = "[$read_only]($read_only_style)[$path]($style)";
        };

        git_branch = {
          format = "[$symbol$branch]($style)";
          style = "bold dimmed white";
          symbol = " ";
        };

        git_status = {
          format = "([「$all_status$ahead_behind」]($style))";
          conflicted = "⚠️";
          ahead = "⟫\${count} ";
          behind = "⟪\${count}";
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
          format = "[$symbol$state $name]($style)";
          pure_msg = "λ";
          impure_msg = "⎔";
          symbol = " ";
        };

        username = {
          format = "[$user]($style ${section.user_host})";
          show_always = true;
        };

        hostname = {
          ssh_only = false;
          format = "[$hostname]($style ${section.user_host})";
          trim_at = "";
        };

        shlvl = {
          disabled = false;
          format = "[$symbol$shlvl]($style)";
          symbol = " ";
        };

        shell = {
          disabled = false;
          format = "$indicator";
        };

        status.disabled = false;
      };
  };
}
