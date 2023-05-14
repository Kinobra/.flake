{ config, lib, pkgs, ... }:
{
  imports = [
    # ./borgbackup
    ./easyeffects
    ./fail2ban
    ./hedgedoc
    ./mako
    ./mpd
    ./nebula
    ./nix
    ./openssh
    ./pipewire
    ./swayidle
    ./syncthing
    ./virtualisation
  ];
}
