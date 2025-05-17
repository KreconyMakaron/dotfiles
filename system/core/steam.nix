{pkgs, ...}: {
  programs.steam.enable = true;
	# programs.steam = {
	# 	enable = true;
	# 	remotePlay.openFirewall = true;
	# 	dedicatedServer.openFirewall = true;
	#    gamescopeSession.enable = true;
	#
	#    extraPackages = with pkgs; [
	#      SDL2
	#      libcxx
	#      libGL
	#      fmodex
	#      xorg.libX11
	#      xorg.libXext
	#      xorg.libxcb
	#      xorg.libXau
	#      xorg.libXdmcp
	#    ];
	# };
	#
	#  programs.gamemode.enable = true;
	#
	#  environment.systemPackages = with pkgs; [ 
	#    mangohud 
	#    protonup
	#    # polymc
	#  ];
	#
	#  environment.sessionVariables = {
	#    STEAM_EXTRA_COMPAT_TOOLS_PATHS =
	#      "\${HOME}/.steam/root/compatibilitytools.d";
	#  };
}
