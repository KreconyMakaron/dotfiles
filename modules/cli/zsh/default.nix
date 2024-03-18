{config, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;

    shellAliases = import ./aliases.nix {inherit config;};
    # ToDo: configure oh-my-zsh
    initExtra = ''
         setfoottitle () {
         	local split dir=''${PWD/#~\//\~/}
         	case $dir in
         	~) dir='~' ;;
         	*) split=( "''${(@s:/:)dir}" )
         		 dir=''${(j:/:M)split#?}''${split[-1]:1} ;;
         	esac
         	printf '\e]2;%s\e' $dir
         }

      add-zsh-hook -Uz chpwd setfoottitle
    '';
  };
}
