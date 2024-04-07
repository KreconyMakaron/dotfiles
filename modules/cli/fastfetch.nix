{
	pkgs, 
	theme,
	...
}: {
	home.packages = with pkgs; [ fastfetch ];

	xdg.configFile."fastfetch/config.jsonc".text = builtins.toJSON {
    "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
		logo = {
			type = "file-raw";
			source = "${theme.asciiart}";
		};
		display.separator = " ";
    modules = [
			{
				type = "host";
				key = "╭─󰌢";
				keyColor = "green";
			}
			{
				type = "cpu";
				key = "├─";
				keyColor = "green";
			}
			{
				type = "gpu";
				key = "├─";
				keyColor = "green";
			}
			{
				type = "disk";
				key = "├─";
				keyColor = "green";
			}
			{
				type = "memory";
				key = "├─";
				keyColor = "green";
			}
			{
				type = "display";
				key = "├─󰍹";
				keyColor = "green";
			}
			{
				type = "sound";
				key = "├─";
				keyColor = "green";
			}
			{
				type = "battery";
				key = "╰─ ";
				keyColor = "green";
			}
			"break"
			{
				type = "os";
				key = "╭─󱄅";
				keyColor = "blue";
			}
			{
				type = "kernel";
				key = "├─";
				"format" = "{1} {2}";
				keyColor = "blue";
			}
			{
				type = "wm";
				key = "├─";
				keyColor = "blue";
			}
			{
				type = "packages";
				key = "├─󰏖";
				keyColor = "blue";
			}
			{
				type = "wifi";
				key = "├─";
				"format" = "{4}";	
				keyColor = "blue";
			}
			{
				type = "uptime";
				key = "╰─󰅐";
				keyColor = "blue";
			}
			"break"
			{
				type = "terminal";
				key = "╭─";
				keyColor = "yellow";
			}
			{
				type = "terminalfont";
				key = "├─";
				keyColor = "yellow";
			}
			{
				type = "shell";
				key = "╰─";
				keyColor = "yellow";
			}
			];
		};
}
