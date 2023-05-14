{ config, lib, pkgs, ... }:
{
  imports = [
    # ./borgbackup
    ./easyeffects
    ./fail2ban
    ./hedgedoc
    ./mako
    ./mpd
    ./murmur
    ./nebula
    ./nginx
    ./nix
    ./openssh
    ./pipewire
    ./swayidle
    ./syncthing
    ./virtualisation
  ];
}
