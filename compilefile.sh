#!/bin/sh

nasm -felf64 -o main.obj main.asm
gcc -no-pie main.obj -o main