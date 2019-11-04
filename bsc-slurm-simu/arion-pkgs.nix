# Instead of pinning Nixpkgs, we can opt to use the one in NIX_PATH
import <nixpkgs> {
  config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
      repoOverrides = {
        augu5te = import /home/auguste/dev/nur-packages {};
        #augu5te = import (pkgs.fetchgit {
        #  url = https://github.com/augu5te/nur-packages;
        #  rev = "a5ae145df66c1c6fc3315f66d08a92c466fad78e";
        #  sha256 = "0hq728xlm7l6grxrdhkmw2mhqm0xksyynrh37i1c4h7p1sqif4kc";
        #  }) {};
      };
    };
  };
}
