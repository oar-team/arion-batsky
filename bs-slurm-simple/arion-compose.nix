{ pkgs, lib,... }:
let
   #imports = [pkgs.nur.repos.augu5te.modules];
  slurmconfig = {
    controlMachine = "control";
    nodeName = [ "node[1] CPUs=1 State=UNKNOWN" ];
    partitionName = [ "debug Nodes=node[1] Default=YES MaxTime=INFINITE State=UP" ];
    #extraConfig = ''
      #AuthType=auth/none
      #  AccountingStorageHost=dbd
      #  AccountingStorageType=accounting_storage/slurmdbd
    #'';
  
  
};

inherit (import ./ssh-keys.nix pkgs)
  snakeOilPrivateKey snakeOilPublicKey;


common = {
  nixos.useSystemd = true;
  nixos.configuration = {
    imports = lib.attrValues pkgs.nur.repos.augu5te.modules;
    boot.tmpOnTmpfs = true;
    environment.systemPackages = with pkgs; [ pkgs.nur.repos.augu5te.batsky (python37.withPackages(ps: with ps; [ clustershell pyzmq click pyinotify sortedcontainers])) ];
    environment.etc."privkey.snakeoil" = { mode = "0600"; source = snakeOilPrivateKey; };
    environment.etc."clustershell/clush.conf".text =
    ''[Main]
    ssh_options=-o StrictHostKeyChecking=no -i /etc/privkey.snakeoil'';
    services.openssh.enable = true;
    services.openssh.forwardX11 = false;
    services.bs-munge = {enable = true;}; # TODO howto move to bs-slurm.nix
    services.batsky = {enable = true; controller="submit"; args="-u -d -l /tmp/batsky.log";};
    users.users.root.openssh.authorizedKeys.keys = [ snakeOilPublicKey ];
    i18n.defaultLocale = "en_US.UTF-8";
  };
  
  service.useHostStore = true;
  
  # For sharing host's volumes 
  #service.volumes = [ "/home/auguste/dev/batsky:/batsky" ];
};


addCommon = x: lib.recursiveUpdate x common;

in

{
  docker-compose.services.node1 = addCommon {
    service.hostname="node1";  
    nixos.configuration.services.bs-slurm  = {
      client.enable = true;
    } // slurmconfig;
  };
 
  docker-compose.services.control = addCommon {
    service.hostname="control";
    nixos.configuration.services.bs-slurm  = {
      server.enable = true;
    } // slurmconfig;
  }; 
  
  docker-compose.services.submit = addCommon {
    service.hostname="submit";
    nixos.configuration.services.bs-slurm  = {
      enableStools = true;
    } // slurmconfig;
  };   

}
