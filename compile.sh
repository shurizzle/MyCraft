#!/bin/sh

gcc -nostartfiles -fPIC -shared -DHOST=\"craft.dre.am\" getaddrfake.c -o getaddrfake.so -ldl
