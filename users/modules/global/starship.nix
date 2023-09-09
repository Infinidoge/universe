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
          ($status$cmd_duration)
          [┃[$username@$hostname](${section.user_host})┃($shlvl┃)($nix_shell┃)](${line_style})
          [┃$directory(┃$git_branch$git_status(@$git_commit)( $git_metrics)( $git_state))](${line_style})
          [┃($shell)┃](${line_style})$character'';

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
          read_only = " ";
          format = "[$read_only]($read_only_style)[$path]($style)";
        };

        git_branch = {
          format = "[$symbol$branch]($style)";
          style = "bold dimmed white";
          symbol = " ";
        };

        git_status = {
          format = " $ahead_behind$all_status";
          conflicted = "";
          ahead = "[⟫\${count}](green bold) ";
          behind = "[⟪\${count}](red bold)";
          diverged = "[](red bold) ";
          untracked = "[](grey bold) ";
          stashed = "[↪](grey bold) ";
          modified = "[](yellow bold) ";
          staged = "[](green bold) ";
          renamed = "[](blue bold) ";
          deleted = "[](red bold) ";
          style = "bold";
        };

        nix_shell = {
          format = "[$symbol$state $name]($style bold)";
          pure_msg = "✔";
          impure_msg = "𝚫";
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
          format = " [$symbol$shlvl]($style bold)";
          symbol = " ";
          threshold = 0;
        };

        shell = {
          disabled = false;
          format = "$indicator";
        };

        status.disabled = false;
      };
  };
}
