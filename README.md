Arion Batsky
================

[Nix](https://nixos.org/nix/) expressions for [Arion](https://github.com/hercules-ci/arion) to run some experiments with [Batsky](https://github.com/oar-team/batsky)

# Requirements:
- Nixos machine 
- Arion: [there](https://github.com/hercules-ci/arion)
```sh
nix-env -iA arion -f https://github.com/hercules-ci/arion/tarball/master
```
# Simple test
Slumr + Batsky

```sh
cd bs-slurm-simple
arion up
#In other terminal
cd bs-slurm-simple
arion docker-compose  exec submit ./batsky/batsky/batsky_controller.py -d -S
```
