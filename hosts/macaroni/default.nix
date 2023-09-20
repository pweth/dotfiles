/*
* Oracle Cloud VM system configuration.
*/

{ config, pkgs, agenix, ... }:

{
  imports = [
    ./hardware.nix
    ../../services
  ];

  # Bootloader
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  # agenix
  environment.systemPackages = [
    agenix.packages.aarch64-linux.default
  ];

  # Networking
  networking = {
    hostName = "macaroni";
    firewall.allowedTCPPorts = [ 443 ];
    nameservers = [ "1.1.1.3" "1.0.0.3" ];
  };

  # Certificates
  age.secrets.cloudflare-api.file = ../../secrets/cloudflare-api.age;
  security.acme = {
    acceptTerms = true;
    defaults.email = "9iz5svuo@duck.com";
  };

  # nginx reverse proxy
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  # Secure Shell
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = "no";
  };

  # System services
  services.clamav.daemon.enable = true;
  services.clamav.updater.enable = true;
  services.vscode-server.enable = true;

  # Enable Podman
  virtualisation.podman.enable = true;
}
