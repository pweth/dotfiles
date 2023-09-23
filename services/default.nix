/*
* Container services to run on the VPS.
*/

{ config, pkgs, ... }:
let
  services = [
    { domain = "cowyo.pw.ax"; address = "127.0.0.1"; port = 44615; }
    { domain = "status.pw.ax"; address = "127.0.0.1"; port = 58057; }
  ];
in
{
  imports = [
    ./cowyo.nix
    ./uptime-kuma.nix
  ];

  # Certificates
  security.acme.certs = builtins.listToAttrs (builtins.map (service: {
    name = service.domain;
    value = {
      credentialsFile = config.age.secrets.cloudflare-api.path;
      dnsProvider = "cloudflare";
      group = "nginx";
    };
  }) services);

  # Reverse proxy hosts
  services.nginx.virtualHosts = builtins.listToAttrs (builtins.map (service : {
    name = service.domain;
    value = {
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://${service.address}:${builtins.toString service.port}/";
        proxyWebsockets = true;
      };
      useACMEHost = service.domain;
    };
  }) services);
}
