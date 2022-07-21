#!/bin/bash

scp /opt/iree-device-build/tools/iree-benchmark-module root@$BBB_HOSTNAME:/tmp/
scp /opt/iree-device-build/samples/simple_embedding/simple_embedding_test_bytecode_module_dylib_arm_32.vmfb root@$BBB_HOSTNAME:/tmp/

ssh root@$BBB_HOSTNAME '/tmp/iree-benchmark-module --module_file=/tmp/simple_embedding_test_bytecode_module_dylib_arm_32.vmfb --device=local-sync:// --function_input=4xf32=1 2 3 4 --function_input=4xf32= 5 6 7 8 --entry_function=simple_mul'

exit
