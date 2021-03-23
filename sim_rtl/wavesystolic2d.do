onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/DUT/reset
add wave -noupdate /tb/DUT/clock
add wave -noupdate /tb/DUT/start_line
add wave -noupdate /tb/DUT/read_ready
add wave -noupdate /tb/DUT/startMac
add wave -noupdate /tb/DUT/fim_op
add wave -noupdate /tb/DUT/executing_arithmetic
add wave -noupdate -radix unsigned /tb/DUT/H
add wave -noupdate -radix unsigned /tb/DUT/V
add wave -noupdate -color Red /tb/DUT/EA_add
add wave -noupdate -color Red /tb/DUT/EA_arit
add wave -noupdate -radix unsigned -childformat {{/tb/DUT/add(0) -radix unsigned} {/tb/DUT/add(1) -radix unsigned} {/tb/DUT/add(2) -radix unsigned} {/tb/DUT/add(3) -radix unsigned} {/tb/DUT/add(4) -radix unsigned} {/tb/DUT/add(5) -radix unsigned}} -expand -subitemconfig {/tb/DUT/add(0) {-height 17 -radix unsigned} /tb/DUT/add(1) {-height 17 -radix unsigned} /tb/DUT/add(2) {-height 17 -radix unsigned} /tb/DUT/add(3) {-height 17 -radix unsigned} /tb/DUT/add(4) {-height 17 -radix unsigned} /tb/DUT/add(5) {-height 17 -radix unsigned}} /tb/DUT/add
add wave -noupdate -radix unsigned /tb/address_out
add wave -noupdate -radix decimal -childformat {{/tb/DUT/buffer_features(0) -radix decimal -childformat {{/tb/DUT/buffer_features(0)(0) -radix decimal} {/tb/DUT/buffer_features(0)(1) -radix decimal} {/tb/DUT/buffer_features(0)(2) -radix decimal}}} {/tb/DUT/buffer_features(1) -radix decimal -childformat {{/tb/DUT/buffer_features(1)(0) -radix decimal} {/tb/DUT/buffer_features(1)(1) -radix decimal} {/tb/DUT/buffer_features(1)(2) -radix decimal}}} {/tb/DUT/buffer_features(2) -radix decimal -childformat {{/tb/DUT/buffer_features(2)(0) -radix decimal} {/tb/DUT/buffer_features(2)(1) -radix decimal} {/tb/DUT/buffer_features(2)(2) -radix decimal}}}} -subitemconfig {/tb/DUT/buffer_features(0) {-height 17 -radix decimal -childformat {{/tb/DUT/buffer_features(0)(0) -radix decimal} {/tb/DUT/buffer_features(0)(1) -radix decimal} {/tb/DUT/buffer_features(0)(2) -radix decimal}} -expand} /tb/DUT/buffer_features(0)(0) {-color red -height 17 -itemcolor Red -radix decimal} /tb/DUT/buffer_features(0)(1) {-color red -height 17 -itemcolor Red -radix decimal} /tb/DUT/buffer_features(0)(2) {-color red -height 17 -itemcolor Red -radix decimal} /tb/DUT/buffer_features(1) {-height 17 -radix decimal -childformat {{/tb/DUT/buffer_features(1)(0) -radix decimal} {/tb/DUT/buffer_features(1)(1) -radix decimal} {/tb/DUT/buffer_features(1)(2) -radix decimal}} -expand} /tb/DUT/buffer_features(1)(0) {-color red -height 17 -itemcolor red -radix decimal} /tb/DUT/buffer_features(1)(1) {-color red -height 17 -itemcolor red -radix decimal} /tb/DUT/buffer_features(1)(2) {-color red -height 17 -itemcolor red -radix decimal} /tb/DUT/buffer_features(2) {-height 17 -radix decimal -childformat {{/tb/DUT/buffer_features(2)(0) -radix decimal} {/tb/DUT/buffer_features(2)(1) -radix decimal} {/tb/DUT/buffer_features(2)(2) -radix decimal}} -expand} /tb/DUT/buffer_features(2)(0) {-color red -height 17 -itemcolor red -radix decimal} /tb/DUT/buffer_features(2)(1) {-color red -height 17 -itemcolor red -radix decimal} /tb/DUT/buffer_features(2)(2) {-color red -height 17 -itemcolor red -radix decimal}} /tb/DUT/buffer_features
add wave -noupdate -radix decimal -childformat {{/tb/DUT/features(0) -radix decimal -childformat {{/tb/DUT/features(0)(0) -radix decimal} {/tb/DUT/features(0)(1) -radix decimal} {/tb/DUT/features(0)(2) -radix decimal}}} {/tb/DUT/features(1) -radix decimal -childformat {{/tb/DUT/features(1)(0) -radix decimal} {/tb/DUT/features(1)(1) -radix decimal} {/tb/DUT/features(1)(2) -radix decimal}}} {/tb/DUT/features(2) -radix decimal -childformat {{/tb/DUT/features(2)(0) -radix decimal} {/tb/DUT/features(2)(1) -radix decimal} {/tb/DUT/features(2)(2) -radix decimal}}}} -expand -subitemconfig {/tb/DUT/features(0) {-height 17 -radix decimal -childformat {{/tb/DUT/features(0)(0) -radix decimal} {/tb/DUT/features(0)(1) -radix decimal} {/tb/DUT/features(0)(2) -radix decimal}} -expand} /tb/DUT/features(0)(0) {-color violet -height 17 -itemcolor violet -radix decimal} /tb/DUT/features(0)(1) {-color violet -height 17 -itemcolor violet -radix decimal} /tb/DUT/features(0)(2) {-color violet -height 17 -itemcolor violet -radix decimal} /tb/DUT/features(1) {-height 17 -radix decimal -childformat {{/tb/DUT/features(1)(0) -radix decimal} {/tb/DUT/features(1)(1) -radix decimal} {/tb/DUT/features(1)(2) -radix decimal}} -expand} /tb/DUT/features(1)(0) {-color violet -height 17 -itemcolor violet -radix decimal} /tb/DUT/features(1)(1) {-color violet -height 17 -itemcolor violet -radix decimal} /tb/DUT/features(1)(2) {-color violet -height 17 -itemcolor violet -radix decimal} /tb/DUT/features(2) {-height 17 -radix decimal -childformat {{/tb/DUT/features(2)(0) -radix decimal} {/tb/DUT/features(2)(1) -radix decimal} {/tb/DUT/features(2)(2) -radix decimal}} -expand} /tb/DUT/features(2)(0) {-color violet -height 17 -itemcolor violet -radix decimal} /tb/DUT/features(2)(1) {-color violet -height 17 -itemcolor violet -radix decimal} /tb/DUT/features(2)(2) {-color violet -height 17 -itemcolor violet -radix decimal}} /tb/DUT/features
add wave -noupdate -radix decimal -childformat {{/tb/DUT/res_mac(0) -radix decimal -childformat {{/tb/DUT/res_mac(0)(0) -radix decimal} {/tb/DUT/res_mac(0)(1) -radix decimal} {/tb/DUT/res_mac(0)(2) -radix decimal}}} {/tb/DUT/res_mac(1) -radix decimal -childformat {{/tb/DUT/res_mac(1)(0) -radix decimal} {/tb/DUT/res_mac(1)(1) -radix decimal} {/tb/DUT/res_mac(1)(2) -radix decimal}}} {/tb/DUT/res_mac(2) -radix decimal -childformat {{/tb/DUT/res_mac(2)(0) -radix decimal} {/tb/DUT/res_mac(2)(1) -radix decimal} {/tb/DUT/res_mac(2)(2) -radix decimal}}}} -subitemconfig {/tb/DUT/res_mac(0) {-height 17 -radix decimal -childformat {{/tb/DUT/res_mac(0)(0) -radix decimal} {/tb/DUT/res_mac(0)(1) -radix decimal} {/tb/DUT/res_mac(0)(2) -radix decimal}} -expand} /tb/DUT/res_mac(0)(0) {-height 17 -radix decimal} /tb/DUT/res_mac(0)(1) {-height 17 -radix decimal} /tb/DUT/res_mac(0)(2) {-height 17 -radix decimal} /tb/DUT/res_mac(1) {-height 17 -radix decimal -childformat {{/tb/DUT/res_mac(1)(0) -radix decimal} {/tb/DUT/res_mac(1)(1) -radix decimal} {/tb/DUT/res_mac(1)(2) -radix decimal}} -expand} /tb/DUT/res_mac(1)(0) {-height 17 -radix decimal} /tb/DUT/res_mac(1)(1) {-height 17 -radix decimal} /tb/DUT/res_mac(1)(2) {-height 17 -radix decimal} /tb/DUT/res_mac(2) {-height 17 -radix decimal -childformat {{/tb/DUT/res_mac(2)(0) -radix decimal} {/tb/DUT/res_mac(2)(1) -radix decimal} {/tb/DUT/res_mac(2)(2) -radix decimal}} -expand} /tb/DUT/res_mac(2)(0) {-height 17 -radix decimal} /tb/DUT/res_mac(2)(1) {-height 17 -radix decimal} /tb/DUT/res_mac(2)(2) {-height 17 -radix decimal}} /tb/DUT/res_mac
add wave -noupdate -radix decimal -childformat {{/tb/DUT/reg_mac(0) -radix decimal -childformat {{/tb/DUT/reg_mac(0)(0) -radix decimal} {/tb/DUT/reg_mac(0)(1) -radix decimal} {/tb/DUT/reg_mac(0)(2) -radix decimal}}} {/tb/DUT/reg_mac(1) -radix decimal -childformat {{/tb/DUT/reg_mac(1)(0) -radix decimal} {/tb/DUT/reg_mac(1)(1) -radix decimal} {/tb/DUT/reg_mac(1)(2) -radix decimal}}} {/tb/DUT/reg_mac(2) -radix decimal -childformat {{/tb/DUT/reg_mac(2)(0) -radix decimal} {/tb/DUT/reg_mac(2)(1) -radix decimal} {/tb/DUT/reg_mac(2)(2) -radix decimal}}}} -subitemconfig {/tb/DUT/reg_mac(0) {-height 17 -radix decimal -childformat {{/tb/DUT/reg_mac(0)(0) -radix decimal} {/tb/DUT/reg_mac(0)(1) -radix decimal} {/tb/DUT/reg_mac(0)(2) -radix decimal}} -expand} /tb/DUT/reg_mac(0)(0) {-height 17 -radix decimal} /tb/DUT/reg_mac(0)(1) {-height 17 -radix decimal} /tb/DUT/reg_mac(0)(2) {-height 17 -radix decimal} /tb/DUT/reg_mac(1) {-height 17 -radix decimal -childformat {{/tb/DUT/reg_mac(1)(0) -radix decimal} {/tb/DUT/reg_mac(1)(1) -radix decimal} {/tb/DUT/reg_mac(1)(2) -radix decimal}} -expand} /tb/DUT/reg_mac(1)(0) {-height 17 -radix decimal} /tb/DUT/reg_mac(1)(1) {-height 17 -radix decimal} /tb/DUT/reg_mac(1)(2) {-height 17 -radix decimal} /tb/DUT/reg_mac(2) {-height 17 -radix decimal -childformat {{/tb/DUT/reg_mac(2)(0) -radix decimal} {/tb/DUT/reg_mac(2)(1) -radix decimal} {/tb/DUT/reg_mac(2)(2) -radix decimal}} -expand} /tb/DUT/reg_mac(2)(0) {-height 17 -radix decimal} /tb/DUT/reg_mac(2)(1) {-height 17 -radix decimal} /tb/DUT/reg_mac(2)(2) {-height 17 -radix decimal}} /tb/DUT/reg_mac
add wave -noupdate -color red -itemcolor red -radix decimal /tb/DUT/reg_soma1
add wave -noupdate -color red -itemcolor red -radix decimal /tb/DUT/reg_soma2
add wave -noupdate -color red -itemcolor red -radix decimal /tb/DUT/reg_soma3
add wave -noupdate /tb/DUT/cont_steps
add wave -noupdate /tb/valid
add wave -noupdate -radix decimal /tb/pixel
add wave -noupdate /tb/start_line
add wave -noupdate /tb/weight_en
add wave -noupdate /tb/DUT/weight
add wave -noupdate /tb/DUT/weight_en
add wave -noupdate /tb/DUT/weight_x
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1264 ns} 0} {{Cursor 2} {525 ns} 0}
quietly wave cursor active 2
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {404 ns} {2084 ns}
