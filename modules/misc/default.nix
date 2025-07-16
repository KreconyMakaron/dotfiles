{...}: {
  # programs = {
  # 	# image viewing
  # 	imv.enable = true;
  #
  # 	# video viewer
  # 	mpv = {
  # 		enable = true;
  # 		config = {
  # 			hwdec = "auto-safe";
  # 			vo = "gpu";
  # 			profile = "gpu-hq";
  # 			gpu-context = "wayland";
  # 		};
  # 	};
  # };

  # bluetooth headset media buttons support
  services.mpris-proxy.enable = true;

  imports = [
    ./hypridle.nix
    # ./firefox.nix
  ];
}
