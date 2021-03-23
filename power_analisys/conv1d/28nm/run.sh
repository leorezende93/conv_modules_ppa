#!/bin/sh

mkdir reports

module load innovus
innovus -common_ui -no_gui -files power_analysis.tcl

cp activity.report.avgpower reports/activity_power.txt
