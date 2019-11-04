# Instead of pinning Nixpkgs, we can opt to use the one in NIX_PATH
import <nixpkgs> {
  config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
      repoOverrides = {
        #augu5te = import /home/auguste/dev/nur-packages {};
        augu5te = import (pkgs.fetchgit {
          url = https://github.com/augu5te/nur-packages;
          rev = "aebf40368f1454b0bbbe24e776437de995ecfdb9";
          sha256 = "1hqaamyvf1nzq6p4pwy26cil0yajmhdjzvs4p01vkkjm3gcggbkk";
          }) {};
      };
    };
  };
}
