#!/bin/sh
#BSUB -J test
#BSUB -o test1_%J.out
#BSUB -e test1_%J.err
#BSUB -n 1
#BSUB -R span[ptile=1]
#BSUB -q bsc_debug
#BSUB -W 00:05

#echo "This is JOBCOMPSCRIPT test\n" >> /home/bsc19/bsc19620/RESOURCE_MANAGEMENT/scripts/TRACES/trace.test

echo "JobId=$JOBID UserId=$UID GroupId=$GID Name=$JOBNAME JobState=$JOBSTATE Partition=$PARTITION TimeLimit=$LIMIT SubmitTime=$SUBMIT StartTime=$START EndTime=$END NodeList=$NODES NodeCnt=$NODECNT ProcCnt=$PROCS WorkDir=$WORK_DIR Backfilled=$BACKFILLED" >> /srv/traces/trace.test

#The plugin sets up the environment for the program to contain the following variables:
#ACCOUNT:   Job's account value
#BATCH:     Was the job submitted as a batch job ("yes" or "no")
#END:       The end time of the job (seconds since Epoch)
#JOBID:     The job id of the slurm job
#JOBNAME:   The name of the job
#JOBSTATE:  The state of the job when it ended
#LIMIT:     The time limit of the job (minutes or "UNLIMITED")
#NODES:     The nodes the job ran on or an empty string if it wasn't assigned
#PARTITION: The partiton the job ran on
#PROCS:     Number of processors allocated to the job
#PATH:      Sets to the standard path
#START:     The start time of the job (seconds since Epoch)
#SUBMIT:    The submit time of the job (seconds since Epoch)
#UID:       The uid of the user the job was run for

