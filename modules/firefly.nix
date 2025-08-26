{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.firefly-iii;
in {
  options.firefly-iii = {
    enable = mkEnableOption "enables firefly-iii";
    databasePasswordFile = mkOption {
      type = types.str;
      default = "";
    };
    appKeyFile = mkOption {
      type = types.str;
      default = "";
    };
    enableDataImporter = mkEnableOption "enables data importer";
  };

  config = mkIf cfg.enable {
    services = {
      firefly-iii = {
        enable = true;
        virtualHost = "localhost";
        enableNginx = true;

        settings = {
          APP_ENV = "local";
          APP_KEY_FILE = cfg.appKeyFile;
          DB_PASSWORD_FILE = cfg.databasePasswordFile;
          DB_CONNECTION = "mysql";
          DB_HOST = "localhost";
          DB_DATABASE = "firefly";
          DB_USERNAME = "firefly";
        };
      };

      firefly-iii-data-importer = {
        enable = cfg.enableDataImporter;
        enableNginx = true;
        virtualHost = "localhost2";

        settings = {
          DB_PASSWORD_FILE = cfg.databasePasswordFile;
          FIREFLY_III_URL = "http://localhost";
          VANITY_URL = "http://localhost";
        };
      };

      nginx = {
        enable = true;
        virtualHosts.${config.services.firefly-iii.virtualHost} = {
          listen = [
            {
              addr = "127.0.0.1";
              port = 80;
            }
          ];
        };
        virtualHosts.${config.services.firefly-iii-data-importer.virtualHost} = {
          listen = [
            {
              addr = "127.0.0.1";
              port = 81;
            }
          ];
        };
      };

      mysql = {
        enable = true;
        package = pkgs.mariadb;
        ensureDatabases = ["firefly"];
        ensureUsers = [
          {
            name = "firefly";
            ensurePermissions = {"firefly.*" = "ALL PRIVILEGES";};
          }
        ];
      };
    };
  };
}
