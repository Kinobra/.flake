{ config, lib, pkgs, ... }:
{
  imports = [
    ./ceres
    ./minerva
    ./nixos
    ./orion
  ];
}
