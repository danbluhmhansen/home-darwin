{pkgs, ...}: {
  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      theme = "catppuccin_mocha";

      editor = {
        line-number = "relative";
        cursorline = true;
        color-modes = true;
        bufferline = "multiple";
        statusline = {
          left = ["mode" "spinner"];
          center = ["file-name"];
          right = [
            "diagnostics"
            "position"
            "file-encoding"
            "file-line-ending"
            "file-type"
          ];
        };
        lsp = {
          display-messages = true;
          auto-signature-help = false;
        };
        cursor-shape = {
          insert = "bar";
          select = "underline";
        };
        indent-guides.render = true;
        soft-wrap.enable = true;
        file-picker.hidden = false;
        shell = ["nu" "--stdin" "--commands"];
      };

      keys.normal = {
        H = "goto_first_nonwhitespace";
        L = "goto_line_end";
        space.w = ":write";
        space.x = ":buffer-close";
        space.q = ":quit";
        space.l = ":format";
        C-h = ":toggle lsp.display-inlay-hints";
      };

      keys.select = {
        H = "goto_first_nonwhitespace";
        L = "goto_line_end";
      };
    };

    languages = {
      language = [
        {
          name = "markdown";
          language-servers = ["marksman" "ltex-ls"];
        }
        {
          name = "nix";
          formatter.command = "alejandra";
        }
        {
          name = "nu";
          language-servers = ["nu-lsp"];
        }
        {
          name = "rust";
          language-servers = ["rust-analyzer" "tailwindcss-ls"];
        }
        {
          name = "sql";
          formatter.command = "sleek";
          formatter.args = ["--indent_spaces" "2" "-"];
        }
      ];

      language-server = {
        nu-lsp = {
          command = "nu";
          args = ["--lsp"];
        };
        rust-analyzer.config.check.command = "clippy";
        tailwindcss-ls.config.userLanguages = {
          rust = "html";
          "*.rs" = "html";
        };
      };
    };

    extraPackages = [
      pkgs.ltex-ls
      pkgs.marksman
      pkgs.taplo
      pkgs.vscode-langservers-extracted
      pkgs.yaml-language-server
    ];
  };
}
