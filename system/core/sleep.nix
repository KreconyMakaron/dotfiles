{...}: {
  services.logind = {
    lidSwitch = "hybrid-sleep";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "lock";
    powerKey = "hybrid-sleep";
    powerKeyLongPress = "reboot";
  };
}
