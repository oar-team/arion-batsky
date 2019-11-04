BSC Simulator
=================

The packaged version is take from https://github.com/BSC-RM/slurm_simulator with a small bug fix.
See for usage details of the simulator  https://github.com/BSC-RM/slurm_simulator_tools

# Use example

```sh
cd arion-batsky/bsc-slurm-simu
arion exec host bash 
export SLURM_SIM_ID=1
export SLURM_CONF=/srv/slurm_conf/slurm.conf
sim_mgr -f -w /srv/simple.trace
```
Output trace is located in  [arion-batsky/bsc-slurm-simu/trace](arion-batsky/bsc-slurm-simu/trace)
