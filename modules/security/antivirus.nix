{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.hardening.clamav;

  scan = paths:
    pkgs.writeShellScript "scan.sh" ''
      # Adapted from https://gist.github.com/Pavel-Novikov/0c7486b59f9237d339f562d30b05e56e
      export LOG="/var/log/clamav/scan.log"
      export SUMMARY_FILE=`mktemp`
      export FIFO_DIR=`mktemp -d`
      export FIFO="$FIFO_DIR/log"

      export SCAN_STATUS
      export INFECTED_SUMMARY
      export XUSERS

      mkfifo "$FIFO"
      tail -f "$FIFO" | tee -a "$LOG" "$SUMMARY_FILE" &

      echo "------------ SCAN START ------------" > "$FIFO"
      echo "Running scan on `date`" > "$FIFO"
      echo "Scanning ${concatStringsSep " " paths}" > "$FIFO"
      ${getExe' pkgs.clamav "clamdscan"} --infected --multiscan --fdpass --stdout ${concatStringsSep " " paths} | grep -vE 'WARNING|ERROR|^$' > "$FIFO"
      echo > "$FIFO"

      SCAN_STATUS="''${PIPESTATUS[0]}"
      INFECTED_SUMMARY=`cat "$SUMMARY_FILE" | grep "Infected files"`

      rm "$SUMMARY_FILE"
      rm "$FIFO"
      rmdir "$FIFO_DIR"

      if [[ "$SCAN_STATUS" -ne "0" ]] ; then

        echo "Virus signature found - $INFECTED_SUMMARY" | ${getExe' pkgs.systemd "systemd-cat"} -t clamav -p emerg

        # Send an alert to all graphical users.
        XUSERS=($(who|awk '{print $1$NF}'|sort -u))
        for XUSER in $XUSERS; do
          NAME=(''${XUSER/(/ })
          DISPLAY=''${NAME[1]/)/}
          DBUS_ADDRESS=unix:path=/run/user/$(id -u ''${NAME[0]})/bus
          echo "run $NAME - $DISPLAY - $DBUS_ADDRESS -" >> /tmp/testlog
          ${getExe' pkgs.systemd "run0"} -u ''${NAME[0]} DISPLAY=''${DISPLAY} \
            DBUS_SESSION_BUS_ADDRESS=''${DBUS_ADDRESS} \
            PATH=''${PATH} \
            ${getExe' pkgs.libnotify "notify-send"} -i security-low "Virus signature(s) found" "$INFECTED_SUMMARY"
        done

      fi
    '';
in {
  options.hardening.clamav = {
    enable = mkEnableOption "enables ClamAV the antivirus scanner";
    scan = {
      daily = {
        enable = mkOption {
          type = types.bool;
          default = true;
        };
        directories = mkOption {
          type = with lib.types; listOf str;
          default = [
            "/home/*/download"
            "/home/*/.local/share"
            "/tmp"
            "/var/tmp"
          ];
        };
      };
      weekly = {
        enable = mkOption {
          type = types.bool;
          default = true;
        };
        directories = mkOption {
          type = with lib.types; listOf str;
          default = [
            "/home"
            "/var/lib"
            "/tmp"
            "/etc"
            "/var/tmp"
          ];
        };
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.clamav
    ];

    systemd = let
      mkClamScan = name: interval: paths: {
        services."clamdscan-${name}" = {
          description = "ClamAV ${name} virus scanner";
          after = ["clamav-freshclam.service"];
          wants = ["clamav-freshclam.service"];

          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${scan paths}";
            Slice = "system-clamav.slice";
            Nice = 5;
            IOWeight = 75;
          };
        };
        timers."clamdscan-${name}" = {
          description = "Timer for ClamAV ${name} virus scanner";
          wantedBy = ["timers.target"];
          timerConfig = {
            OnCalendar = "${interval}";
            Unit = "clamdscan-${name}.service";
          };
        };
      };
    in
      mkMerge [
        (mkIf cfg.scan.daily.enable (mkClamScan "daily" "*-*-* 21:00:00" cfg.scan.daily.directories))
        (mkIf cfg.scan.weekly.enable (mkClamScan "weekly" "Sun 21:00:00" cfg.scan.weekly.directories))
      ];

    services.clamav = {
      daemon = {
        enable = true;
        settings = {
          LogFileMaxSize = "50M";
          LogTime = true;
          LogRotate = true;
          ExtendedDetectionInfo = true;
          MaxThreads = 8;

          OnAccessIncludePath = "/home/*/download";
          OnAccessPrevention = true;
          OnAccessExcludeUname = "clamav";
        };
      };

      # on-access scanning
      clamonacc.enable = true;

      # updating the malware database (freshclam)
      updater = {
        enable = true;
        settings = {
          LogFileMaxSize = "10M";
          Bytecode = true;
          LogTime = true;
        };
      };
    };
  };
}
