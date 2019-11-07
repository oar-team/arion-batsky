{ pkgs, lib,... }:
let
   #imports = [pkgs.nur.repos.augu5te.modules];
  slurmconfig = {
  controlMachine = "control";
    nodeName = [ "node[1-10] NodeHostName=node NodeAddr=node CPUs=1 State=UNKNOWN" ];
    partitionName = [ "debug Nodes=node[1-10] Default=YES MaxTime=INFINITE State=UP" ];
    extraConfig = ''
      AuthType=auth/none
      CryptoType=crypto/none
      #  AccountingStorageHost=dbd
      #  AccountingStorageType=accounting_storage/slurmdbd
    '';
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
    services.batsky = {enable = true; controller="submit"; args="-u -d -l /tmp/batsky.log";};
    users.users.root.openssh.authorizedKeys.keys = [ snakeOilPublicKey ];
    i18n.defaultLocale = "en_US.UTF-8";
  };
  
  service.useHostStore = true;
  
  # For sharing host's volumes
  service.volumes = [ "${builtins.getEnv "PWD"}:/srv" ];
};


addCommon = x: lib.recursiveUpdate x common;

in

{
  services.node = addCommon {
    service.hostname="node";  
    nixos.configuration.services.fe-slurm  = {
      client.enable = true;
    } // slurmconfig;
  };
 
  services.control = addCommon {
    service.hostname="control";
    nixos.configuration.services.fe-slurm  = {
      server.enable = true;
    } // slurmconfig;
  }; 
  
  services.submit = addCommon {
    service.hostname="submit";
    nixos.configuration.services.fe-slurm  = {
      #package = pkgs.nur.repos.augu5te.slurm-front-end;
      enableStools = true;
    } // slurmconfig;
  };   

}
