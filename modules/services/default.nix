{ config, lib, pkgs, ... }:
{
  imports = [
    # ./borgbackup
    ./easyeffects
    ./fail2ban
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
