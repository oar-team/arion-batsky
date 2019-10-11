# Instead of pinning Nixpkgs, we can opt to use the one in NIX_PATH
import <nixpkgs> {
  config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
      repoOverrides = {
        #augu5te = import /home/auguste/dev/nur-packages {};
        augu5te = import (pkgs.fetchgit {
          url = https://github.com/augu5te/nur-packages;
          rev = "e7f0de694667af3d766bc8b685dade8df5b282f5";
          sha256 = "1r5rpphbyr2lp14k62gmq4z4shgn8z2ikj7x7v4r83x8qdqqjrm2";
          }) {};
      };
    };
  };
}
