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
Slurm + Batsky

```sh
git clone git@github.com:oar-team/arion-batsky.git
cd arion-batsky/bs-slurm-simple
arion up
#In other terminal
cd arion-batsky/bs-slurm-simple
arion docker-compose  exec submit batsky-controller -d -S
```
