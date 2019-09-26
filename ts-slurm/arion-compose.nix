{ pkgs, lib, ... }:
let 
  slurmconfig = {
  controlMachine = "control";
  nodeName = [ "node[1] CPUs=1 State=UNKNOWN" ];
      partitionName = [ "debug Nodes=node[1] Default=YES MaxTime=INFINITE State=UP" ];
      #extraConfig = ''
      #  AccountingStorageHost=dbd
      #  AccountingStorageType=accounting_storage/slurmdbd
  #'';
  };

  common = {
    nixos.useSystemd = true;
    nixos.configuration.boot.tmpOnTmpfs = true;
    nixos.configuration.environment.systemPackages = with pkgs; [python3];
    service.useHostStore = true;
    nixos.configuration.services.batsky = {enable = true; controller="submit";};
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
