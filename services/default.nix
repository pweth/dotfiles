/*
* Container services to run on the VPS.
*/

{ config, ... }:
let
  services = [
    { domain = "cowyo.pw.ax"; port = 44615; }
    { domain = "grafana.pw.ax"; port = 59663; }
    { domain = "notebook.pw.ax"; port = 43067; }
    { domain = "prometheus.pw.ax"; port = 58635; }
    { domain = "uptime.pw.ax"; port = 58057; }
  ];
in
{
  imports = [
    ./cowyo.nix
    ./grafana.nix
    ./jupyter.nix
    ./prometheus.nix
    ./uptime-kuma.nix
  ];

  # Certificates
  security.acme.certs = builtins.listToAttrs (builtins.map (service: {
    name = service.domain;
    value = {
      credentialsFile = config.age.secrets.cloudflare.path;
      dnsProvider = "cloudflare";
      group = "nginx";
    };
  }) services);

  # Reverse proxy hosts
  services.nginx.virtualHosts = builtins.listToAttrs (builtins.map (service: {
    name = service.domain;
    value = {
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${builtins.toString service.port}/";
        proxyWebsockets = true;
      };
      useACMEHost = service.domain;
    };
  }) services);
}
