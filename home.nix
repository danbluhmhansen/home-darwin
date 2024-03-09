{pkgs, lib, config, devenv, ...}: {
  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "danbluhmhansen";
  home.homeDirectory = lib.mkForce "/Users/danbluhmhansen";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    devenv.packages.${pkgs.system}.devenv
    pkgs.cachix

    pkgs.fd
    pkgs.sd
    pkgs.xh

    pkgs.streamlink

    pkgs.openssh
    pkgs.libfido2

    pkgs.ripasso-cursive
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage plain files is through 'home.file'.
  home.file = {
    ".config/streamlink/config".text = ''
      player=mpv
      default-stream=best
    '';
  };

  home.sessionVariables = {
    PAGER = "bat --wrap=never";
  };  fonts.fontconfig.enable = true;

  stylix = {
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    fonts.sizes.terminal = 16;
    fonts.monospace = {
      package = pkgs.maple-mono-NF;
      name = "Maple Mono NF";
    };
    targets = {
      bat.enable = false;
      firefox.profileNames = [config.home.username];
      helix.enable = false;
      wezterm.enable = false;
      zellij.enable = false;
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zsh.enable = true;

  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./wezterm.lua;
  };

  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    shellAliases = {
      ll = "ls -l";
    };
    extraConfig = ''
      use ${pkgs.nu_scripts}/share/nu_scripts/themes/nu-themes/catppuccin-mocha.nu
      $env.config.color_config = (catppuccin-mocha)

      register ${pkgs.nushellPlugins.gstat}/bin/nu_plugin_gstat
      register ${pkgs.nushellPlugins.net}/bin/nu_plugin_net

      source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/btm/btm-completions.nu
      source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/cargo/cargo-completions.nu
      source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/gh/gh-completions.nu
      source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/git/git-completions.nu
      source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/nix/nix-completions.nu
      source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/rustup/rustup-completions.nu
      source ${pkgs.nu_scripts}/share/nu_scripts/custom-completions/zellij/zellij-completions.nu
    '';
  };

  programs.carapace.enable = true;

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$git_status $character";
      right_format = "$all";
      directory = {
        format = "[$path]($style)[$read_only]($read_only_style)";
        read_only = " 󰌾";
      };
      git_status.format = "[$all_status$ahead_behind]($style)";
    };
  };

  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [batdiff batman batgrep batwatch];
    config.theme = "catppuccin-mocha";
    themes = {
      catppuccin-mocha = {
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "bat";
          rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
          sha256 = "6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
        };
        file = "Catppuccin-mocha.tmTheme";
      };
    };
  };

  programs.ripgrep.enable = true;

  programs.git = {
    enable = true;
    userEmail = "00.pavers_dither@icloud.com";
    userName = "Dan Bluhm Hansen";
    signing = {
      key = "0x077BBC8A99A747DD";
      signByDefault = true;
    };
    extraConfig = {
      diff.algorithm = "histogram";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
    delta = {
      enable = true;
      options = {
        side-by-side = true;
      };
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.gitui = {
    enable = true;
    keyConfig = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/extrawurst/gitui/8f7f35b8a97e38a0e181032285554cd0961d588e/vim_style_key_config.ron";
      hash = "sha256-cAh+OufbYUve7aei4MncUKrIGH0lzUxHqa9ebN5MwMA=";
    };
    theme = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/gitui/ce0d073676dc96d005f7b91368e5cd565d840104/theme/mocha.ron";
      hash = "sha256-i0WUnSoi9yL+OEgn5b2w7f9bqVYzBkt9zNaysSJAYLY=";
    };
  };

  programs.zellij = {
    enable = true;
    settings.default_shell = "nu";
    settings.default_layout = "compact";
    settings.theme = "catppuccin-mocha";
  };

  programs.bottom.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.mpv = {
    enable = true;
    config = {
      volume = 50;
    };
  };

  programs.yt-dlp.enable = true;

  programs.gpg = {
    enable = true;
    publicKeys = [
      {
        source = pkgs.fetchurl {
          url = "https://keys.openpgp.org/vks/v1/by-fingerprint/F5DC22A680631D2C9E04867F077BBC8A99A747DD";
          sha256 = "CLepFmgsa1Hy4fZo7Z57dGF7DwCGcuYMyOivr6cKwqM=";
        };
        trust = 5;
      }
    ];
    settings = {
      # https://github.com/drduh/config/blob/master/gpg.conf
      # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html
      # https://www.gnupg.org/documentation/manuals/gnupg/GPG-Esoteric-Options.html
      # 'gpg --version' to get capabilities
      # Use AES256, 192, or 128 as cipher
      personal-cipher-preferences = ["AES256" "AES192" "AES"];
      # Use SHA512, 384, or 256 as digest
      personal-digest-preferences = ["SHA512" "SHA384" "SHA256"];
      # Use ZLIB, BZIP2, ZIP, or no compression
      personal-compress-preferences = ["ZLIB" "BZIP2" "ZIP" "Uncompressed"];
      # Default preferences for new keys
      default-preference-list = ["SHA512" "SHA384" "SHA256" "AES256" "AES192" "AES" "ZLIB" "BZIP2" "ZIP" "Uncompressed"];
      # SHA512 as digest to sign keys
      cert-digest-algo = "SHA512";
      # SHA512 as digest for symmetric ops
      s2k-digest-algo = "SHA512";
      # AES256 as cipher for symmetric ops
      s2k-cipher-algo = "AES256";
      # UTF-8 support for compatibility
      charset = "utf-8";
      # Show Unix timestamps
      fixed-list-mode = true;
      # No comments in signature
      no-comments = true;
      # No version in output
      no-emit-version = true;
      # Disable banner
      no-greeting = true;
      # Long key id format
      keyid-format = "0xlong";
      # Display UID validity
      list-options = "show-uid-validity";
      verify-options = "show-uid-validity";
      # Display all keys and their fingerprints
      with-fingerprint = true;
      # Display key origins and updates
      #with-key-origin = true;
      # Cross-certify subkeys are present and valid
      require-cross-certification = true;
      # Disable caching of passphrase for symmetrical ops
      no-symkey-cache = true;
      # Enable smartcard
      use-agent = true;
      # Disable recipient key ID in messages (breaks Mailvelope)
      throw-keyids = true;
      # Default key ID to use (helpful with throw-keyids)
      #default-key = "0xFF3E7D88647EBCDB";
      #trusted-key = "0xFF3E7D88647EBCDB";
      # Group recipient keys (preferred ID last)
      #group keygroup = 0xFF00000000000001 0xFF00000000000002 0xFF3E7D88647EBCDB
      # Keyserver URL
      keyserver = "hkps://keys.openpgp.org";
      #keyserver = "hkps://keys.mailvelope.com";
      #keyserver = "hkps://keyserver.ubuntu.com:443";
      #keyserver = "hkps://pgpkeys.eu";
      #keyserver = "hkps://pgp.circl.lu";
      #keyserver = "hkp://zkaan2xfbuxia2wpf7ofnkbz6r5zdbbvxbunvp5g2iebopbfc4iqmbad.onion";
      # Keyserver proxy
      #keyserver-options = "http-proxy=http://127.0.0.1:8118";
      #keyserver-options = "http-proxy=socks5-hostname://127.0.0.1:9050";
      # Show expired subkeys
      #list-options show-unusable-subkeys
      # Verbose output
      #verbose
    };
  };
}
