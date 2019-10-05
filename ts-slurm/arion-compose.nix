{ pkgs, lib, ... }:
let 
  slurmconfig = {
  controlMachine = "control";
  nodeName = [ "node[1] CPUs=1 State=UNKNOWN" ];
  partitionName = [ "debug Nodes=node[1] Default=YES MaxTime=INFINITE State=UP" ];
};
#extraConfig = ''
  #  AccountingStorageHost=dbd
  #  AccountingStorageType=accounting_storage/slurmdbd
#'';

inherit (import ./ssh-keys.nix pkgs)
  snakeOilPrivateKey snakeOilPublicKey;


common = {
  nixos.useSystemd = true;
  nixos.configuration = {
    boot.tmpOnTmpfs = true;
    environment.systemPackages = with pkgs; [ batsky (python37.withPackages(ps: with ps; [ clustershell pyzmq click pyinotify sortedcontainers])) ];
    environment.etc."privkey.snakeoil" = { mode = "0600"; source = snakeOilPrivateKey; };
    environment.etc."clustershell/clush.conf".text =
    ''[Main]
    ssh_options=-o StrictHostKeyChecking=no -i /etc/privkey.snakeoil'';
    services.openssh.enable = true;
    services.openssh.forwardX11 = false;
    services.batsky = {enable = true; controller="submit"; args="-u -d -l /tmp/batsky.log";};
    users.users.root.openssh.authorizedKeys.keys = [ snakeOilPublicKey ];
    i18n.defaultLocale = "en_US.UTF-8";
  };
  
  service.useHostStore = true;
  
  service.volumes = [ "/home/auguste/dev/batsky:/batsky" ];
};

addCommon = x: lib.recursiveUpdate x common;

in

{
  docker-compose.services.node1 = addCommon {
    service.hostname="node1";  
    nixos.configuration.services.ts-slurm  = {
      client.enable = true;
    } // slurmconfig;
  };
 
  docker-compose.services.control = addCommon {
    service.hostname="control";
    nixos.configuration.services.ts-slurm  = {
      server.enable = true;
    } // slurmconfig;
  }; 
  
  docker-compose.services.submit = addCommon {
    service.hostname="submit";
    nixos.configuration.services.ts-slurm  = {
      enableStools = true;
    } // slurmconfig;
  };
}
