/*
* Bourne Again Shell configuration.
*/

{ config, ... }:

{
  programs.bash = {
    enable = true;

    # Command aliases
    shellAliases = {
      cls = "clear";
      fzfb = "fzf --preview 'bat --style=numbers --color=always --line-range :200 {}'";
      ga = "git add";
      gc = "git commit";
      gd = "git diff";
      gp = "git push";
      gs = "git status";
      ls = "eza -la";
      rb = "sudo nixos-rebuild switch --flake /home/pweth/dotfiles";
      rbi = "sudo nixos-rebuild switch --flake /home/pweth/dotfiles --impure";
      tka = "tmux kill-session -a";
      tls = "tmux ls";
      v = "nvim"; 
    };

    # Functions
    initExtra = ''
      gl() {
        git log --all --pretty=oneline --pretty=format:"%Cgreen%h%Creset %s" --color=always |
        fzf --ansi --preview 'git show --pretty=medium --color=always $(echo {} | cut -d " " -f 1)' |
        cut -d " " -f 1
      }
      secret() {
        (
          cd /home/pweth/dotfiles/secrets &&
          sudo agenix -i /etc/ssh/ssh_host_ed25519_key -e ''${1}.age
        )
      }
      weather() {
        curl -s "wttr.in/''${1}" | head -n -1;
      }
    '';
  };
}
