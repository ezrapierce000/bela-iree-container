#!/bin/bash
BBB_HOSTNAME=192.168.6.2
scp ${1}  root@$BBB_HOSTNAME:/tmp/

PERF_CMD="perf_5.10 record -F 99 -o perf.data --call-graph=fp"
BENCH_CMD="./iree-benchmark-module --module_file=/tmp/${1} --device=local-sync:// --function_input=1x1024xf32=1 2 3 4 --entry_function=main --benchmark_repetitions=10 --trace_execution=true"
ssh root@$BBB_HOSTNAME $PERF_CMD $BENCH_CMD


scp root@$BBB_HOSTNAME:/root/perf.data ./profiles/perf${1}.data
exit
