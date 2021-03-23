#!/bin/sh

module load innovus
innovus -common_ui -no_gui -files power_analysis.tcl

mkdir reports
cp activity.report.avgpower reports/activity_power.txt
