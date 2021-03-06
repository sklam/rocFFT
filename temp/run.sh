################################################################################
# Copyright (C) 2016 Advanced Micro Devices, Inc. All rights reserved.
################################################################################

#!/bin/bash

./a.out 33554432        1
./a.out 16777216        2
./a.out  8388608        4
./a.out  4194304        8
./a.out  2097152       16
./a.out  1048576       32
./a.out   524288       64
./a.out   262144      128
./a.out   131072      256
./a.out    65536      512
./a.out    32768     1024
./a.out    16384     2048
./a.out     8192     4096
./a.out     4096     8192
./a.out     2048    16384
./a.out     1024    32768
./a.out      512    65536
./a.out      256   131072
./a.out      128   262144
./a.out       64   524288
./a.out       32  1048576
./a.out       16  2097152
./a.out        8  4194304
./a.out        4  8388608
./a.out        2 16777216

