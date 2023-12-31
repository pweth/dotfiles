/*
* Query, visualize, alerting observability platform.
* https://github.com/grafana/grafana
*/

{ config, ... }:

{
  age.secrets.grafana = {
    file = ../secrets/grafana.age;
    owner = "grafana";
  };

  services.grafana = {
    enable = true;
    settings = {
      analytics = {
        check_for_plugin_updates = false;
        check_for_updates = false;
        feedback_links_enabled = false;
        reporting_enabled = false;
      };
      security = {
        admin_user = "admin";
        admin_password = "$__file{${config.age.secrets.grafana.path}}";
        disable_gravatar = true;
      };
      server = {
        domain = "grafana.pweth.com";
        http_port = 59663;
      };
      user = {
        default_language = "en-GB";
        default_theme = "dark";
      };
    };
  };
}
