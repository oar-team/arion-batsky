{ pkgs, lib,... }:
{
  services.host = {
    service.hostname="host";
    
    nixos.useSystemd = true;
    nixos.configuration = {
      boot.tmpOnTmpfs = true;
      environment.systemPackages = with pkgs; [ nur.repos.augu5te.slurm-bsc-simulator ];
      i18n.defaultLocale = "en_US.UTF-8";
    };
    service.useHostStore = true;  
    # For sharing host's volumes 
    service.volumes = [ "${builtins.getEnv "PWD"}:/srv" ];
  };
}
