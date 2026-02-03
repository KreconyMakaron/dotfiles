{...}: {
  environment.etc."modprobe.d/nm-disable-unused-protocols.conf" = {
    text = ''
      install tipc /bin/true
      install sctp /bin/true
      install dccp /bin/true
      install rds  /bin/true
    '';
  };
}
