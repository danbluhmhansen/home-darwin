let carapace_completer = {|spans|
  carapace $spans.0 nushell ...$spans | from json
}

$env.config = {
  show_banner: false

  completions: {
    case_sensitive: false
    quick: true
    partial: true
    algorithm: "prefix"
    external: {
      enable: true
      max_results: 100
      completer: $carapace_completer
    }
  }

  keybindings: [
    {
      name: fuzzy_dir
      modifier: control
      keycode: char_s
      mode: [emacs, vi_normal, vi_insert]
      event: {
        send: executehostcommand
        cmd: "commandline -a (
          ls **/*
          | where type == dir
          | get name
          | input list --fuzzy
            $'Please choose a (ansi magenta)directory(ansi reset) to (ansi cyan_underline)insert(ansi reset):'
        )"
      }
    }
  ]
}
