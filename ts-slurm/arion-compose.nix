{ pkgs, lib,... }:
let

  nbNodes = if (builtins.getEnv "NBNODES" != "") then lib.toInt (builtins.getEnv "NBNODES") else 1;
  vnodeFactor =  if (builtins.getEnv "VNODEFACTOR" != "") then lib.toInt (builtins.getEnv "VNODEFACTOR") else 1;

  slurmconfig = {
  controlMachine = "control";
  nodeName = [ "node[1-${toString (nbNodes * vnodeFactor)}] CPUs=1 State=UNKNOWN" ];
  partitionName = [ "debug Nodes=node[1-${toString (nbNodes * vnodeFactor)}] Default=YES MaxTime=INFINITE State=UP" ];
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
multiple-services =  base_name: service_base:
let
  node_name_ids = builtins.genList (x: {node_name=base_name + toString(vnodeFactor*x+1); id=vnodeFactor*x+1;}) nbNodes;
in
  builtins.listToAttrs (map (x: {name=x.node_name; value=(service_base x.node_name x.id);}) node_name_ids);

in

{
  docker-compose.services = {
    control = addCommon {
      service.hostname="control";
      nixos.configuration.services.ts-slurm  = {
        server.enable = true;
      } // slurmconfig;
    }; 
  
    submit = addCommon {
      service.hostname="submit";
      nixos.configuration.services.ts-slurm  = {
        enableStools = true;
      } // slurmconfig;
    };
  } // multiple-services "node" (name: nodeId: (
    addCommon {
      service.hostname= name;
      nixos.configuration.services.ts-slurm  = {
        client.enable = true;
        client.nodeId = nodeId;
        client.rangeId = vnodeFactor;
      } // slurmconfig;
    }));
 
#  {
#    submit2 =
#      addCommon {service.hostname="submit2";};
#  };

}


#//  {
#  submit2 = addCommon {
#    service.hostname="submit";
#    nixos.configuration.services.ts-slurm  = {
#      enableStools = true;
#    } // slurmconfig;
#  }; 
#}
