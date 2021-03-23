#!/bin/sh

module load genus
cp ../../../apps/generic.tcl .
genus -f commands.tcl
