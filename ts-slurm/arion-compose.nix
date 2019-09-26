
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
in

{

  docker-compose.services.node1 = { pkgs, ... }: {
    nixos.useSystemd = true;
    nixos.configuration.boot.tmpOnTmpfs = true;
    nixos.configuration.services.ts-slurm  = {
      client.enable = true;
    } // slurmconfig;
    nixos.configuration.services.batsky = {enable = true; controller="submit";};
    service.useHostStore = true;
    service.hostname="node1";
  };
  
  docker-compose.services.control = { pkgs, ... }: {
    nixos.useSystemd = true;
    nixos.configuration.boot.tmpOnTmpfs = true;
    nixos.configuration.services.ts-slurm  = {
      server.enable = true;
    } // slurmconfig;
    nixos.configuration.services.batsky = {enable = true; controller="submit";};
    service.hostname="control";
    service.useHostStore = true;
  };
  
  docker-compose.services.submit = { pkgs, ... }: {
    nixos.useSystemd = true;
    nixos.configuration.boot.tmpOnTmpfs = true;
    nixos.configuration.services.ts-slurm  = {
      enableStools = true;
    } // slurmconfig;
    nixos.configuration.services.batsky = {enable = true; controller="submit";};
    service.hostname="submit";
    service.useHostStore = true;
    
  };
}
