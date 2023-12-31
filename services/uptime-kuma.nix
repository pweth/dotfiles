/*
* An easy-to-use self-hosted monitoring tool.
* https://github.com/louislam/uptime-kuma
*/

{ config, ... }:

{
  virtualisation.oci-containers.containers.uptime-kuma = {
    autoStart = true;
    image = "elestio/uptime-kuma";
    ports = [ "58057:3001" ];
    volumes = [
      "/home/pweth/uptime-kuma:/app/data"
    ];
  };
}
