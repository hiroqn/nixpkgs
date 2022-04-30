{ pkgs, config, ... }:

{
  imports = [
    ./installation-cd-graphical-plasma5.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_5_10;

  boot.extraModulePackages = [
    config.boot.kernelPackages.macbook12-spi-driver
    config.boot.kernelPackages.mbp2018-bridge-drv
    config.boot.kernelPackages.ax88179_178a
  ];
  boot.kernelModules = [
    "bce"
    "apple-ibridge"
    "apple-ib-tb"
    "apple-ib-als"
    "ipheth"
    "ax88179_178a"
  ];
  nixpkgs.config.allowUnfree = true;
}
