{ config, lib, pkgs, ... }:
{
  imports = [
    ./desktop
    ./desktop-minimal
    ./server
    ./server-minimal
  ];
}
