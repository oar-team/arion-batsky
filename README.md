Arion Batsky
================

[Nix](https://nixos.org/nix/) expressions for [Arion](https://github.com/hercules-ci/arion) to run some experiments with [Batsky](https://github.com/oar-team/batsky)

# Requirements:
- Machine with [Nixos](https://nixos.org/) 
- Arion: [there](https://github.com/hercules-ci/arion)
```sh
nix-env -iA arion -f https://github.com/hercules-ci/arion/tarball/master
```
# Simple test
Slurm + Batsky

```sh
git clone git@github.com:oar-team/arion-batsky.git
cd arion-batsky/fe-slurm
arion up
#In other terminal
cd arion-batsky/fe-slurm
arion exec submit batsky-controller -- -d -S -w /srv/test_delay4.json
```

To stop containers
```sh
arion down
```

## Misc
[BSC Simulator](https://github.com/BSC-RM/slurm_simulator) is also provided see: [Readme](bsc-slurm-simu/README.md)

