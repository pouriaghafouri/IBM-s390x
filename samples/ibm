#!/bin/bash
set -e
s390x-linux-gnu-as -o $1.o $1.s
s390x-linux-gnu-gcc -z noexecstack -m64 -pipe -static -no-pie -std=c17 -o $1 $1.o -lm
qemu-s390x ./$1
