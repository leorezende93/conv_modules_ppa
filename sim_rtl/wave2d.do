onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/DUT/clock
add wave -noupdate -radix decimal -childformat {{/tb/DUT/weight(0) -radix decimal} {/tb/DUT/weight(1) -radix decimal} {/tb/DUT/weight(2) -radix decimal}} -expand -subitemconfig {/tb/DUT/weight(0) {-height 17 -radix decimal} /tb/DUT/weight(1) {-height 17 -radix decimal} /tb/DUT/weight(2) {-height 17 -radix decimal}} /tb/DUT/weight
add wave -noupdate -radix decimal /tb/DUT/x
add wave -noupdate -radix decimal /tb/DUT/y
add wave -noupdate -radix decimal /tb/DUT/addressX
add wave -noupdate -divider WEIGHTS
add wave -noupdate -radix decimal /tb/DUT/data_from_mem
add wave -noupdate -radix decimal -childformat {{/tb/DUT/weight(0) -radix decimal -childformat {{/tb/DUT/weight(0)(0) -radix decimal -childformat {{/tb/DUT/weight(0)(0)(7) -radix decimal} {/tb/DUT/weight(0)(0)(6) -radix decimal} {/tb/DUT/weight(0)(0)(5) -radix decimal} {/tb/DUT/weight(0)(0)(4) -radix decimal} {/tb/DUT/weight(0)(0)(3) -radix decimal} {/tb/DUT/weight(0)(0)(2) -radix decimal} {/tb/DUT/weight(0)(0)(1) -radix decimal} {/tb/DUT/weight(0)(0)(0) -radix decimal}}} {/tb/DUT/weight(0)(1) -radix decimal} {/tb/DUT/weight(0)(2) -radix decimal}}} {/tb/DUT/weight(1) -radix decimal} {/tb/DUT/weight(2) -radix decimal}} -subitemconfig {/tb/DUT/weight(0) {-height 17 -radix decimal -childformat {{/tb/DUT/weight(0)(0) -radix decimal -childformat {{/tb/DUT/weight(0)(0)(7) -radix decimal} {/tb/DUT/weight(0)(0)(6) -radix decimal} {/tb/DUT/weight(0)(0)(5) -radix decimal} {/tb/DUT/weight(0)(0)(4) -radix decimal} {/tb/DUT/weight(0)(0)(3) -radix decimal} {/tb/DUT/weight(0)(0)(2) -radix decimal} {/tb/DUT/weight(0)(0)(1) -radix decimal} {/tb/DUT/weight(0)(0)(0) -radix decimal}}} {/tb/DUT/weight(0)(1) -radix decimal} {/tb/DUT/weight(0)(2) -radix decimal}}} /tb/DUT/weight(0)(0) {-height 17 -radix decimal -childformat {{/tb/DUT/weight(0)(0)(7) -radix decimal} {/tb/DUT/weight(0)(0)(6) -radix decimal} {/tb/DUT/weight(0)(0)(5) -radix decimal} {/tb/DUT/weight(0)(0)(4) -radix decimal} {/tb/DUT/weight(0)(0)(3) -radix decimal} {/tb/DUT/weight(0)(0)(2) -radix decimal} {/tb/DUT/weight(0)(0)(1) -radix decimal} {/tb/DUT/weight(0)(0)(0) -radix decimal}} -expand} /tb/DUT/weight(0)(0)(7) {-radix decimal} /tb/DUT/weight(0)(0)(6) {-radix decimal} /tb/DUT/weight(0)(0)(5) {-radix decimal} /tb/DUT/weight(0)(0)(4) {-radix decimal} /tb/DUT/weight(0)(0)(3) {-radix decimal} /tb/DUT/weight(0)(0)(2) {-radix decimal} /tb/DUT/weight(0)(0)(1) {-radix decimal} /tb/DUT/weight(0)(0)(0) {-radix decimal} /tb/DUT/weight(0)(1) {-radix decimal} /tb/DUT/weight(0)(2) {-radix decimal} /tb/DUT/weight(1) {-height 17 -radix decimal} /tb/DUT/weight(2) {-height 17 -radix decimal}} /tb/DUT/weight
add wave -noupdate /tb/DUT/weight_en
add wave -noupdate /tb/DUT/weight_x
add wave -noupdate -divider CONTROL
add wave -noupdate /tb/DUT/start_line
add wave -noupdate /tb/DUT/endRead_and_startMac
add wave -noupdate /tb/DUT/fim_op
add wave -noupdate -divider -height 22 memory
add wave -noupdate -radix decimal /tb/DUT/x
add wave -noupdate -radix decimal /tb/DUT/y
add wave -noupdate -radix unsigned /tb/DUT/address_out
add wave -noupdate /tb/DUT/EA_add
add wave -noupdate -radix decimal -childformat {{/tb/DUT/features(0) -radix decimal -childformat {{/tb/DUT/features(0)(0) -radix decimal} {/tb/DUT/features(0)(1) -radix decimal} {/tb/DUT/features(0)(2) -radix decimal}}} {/tb/DUT/features(1) -radix decimal -childformat {{/tb/DUT/features(1)(0) -radix decimal} {/tb/DUT/features(1)(1) -radix decimal} {/tb/DUT/features(1)(2) -radix decimal}}} {/tb/DUT/features(2) -radix decimal -childformat {{/tb/DUT/features(2)(0) -radix decimal} {/tb/DUT/features(2)(1) -radix decimal} {/tb/DUT/features(2)(2) -radix decimal}}}} -radixshowbase 0 -expand -subitemconfig {/tb/DUT/features(0) {-color Red -height 17 -radix decimal -childformat {{/tb/DUT/features(0)(0) -radix decimal} {/tb/DUT/features(0)(1) -radix decimal} {/tb/DUT/features(0)(2) -radix decimal}} -radixshowbase 1 -expand} /tb/DUT/features(0)(0) {-color Red -height 17 -radix decimal -radixshowbase 1} /tb/DUT/features(0)(1) {-color Red -height 17 -radix decimal -radixshowbase 1} /tb/DUT/features(0)(2) {-color Red -height 17 -radix decimal -radixshowbase 1} /tb/DUT/features(1) {-color Red -height 17 -radix decimal -childformat {{/tb/DUT/features(1)(0) -radix decimal} {/tb/DUT/features(1)(1) -radix decimal} {/tb/DUT/features(1)(2) -radix decimal}} -radixshowbase 1 -expand} /tb/DUT/features(1)(0) {-color Red -height 17 -radix decimal -radixshowbase 1} /tb/DUT/features(1)(1) {-color Red -height 17 -radix decimal -radixshowbase 1} /tb/DUT/features(1)(2) {-color Red -height 17 -radix decimal -radixshowbase 1} /tb/DUT/features(2) {-color Red -height 17 -radix decimal -childformat {{/tb/DUT/features(2)(0) -radix decimal} {/tb/DUT/features(2)(1) -radix decimal} {/tb/DUT/features(2)(2) -radix decimal}} -radixshowbase 1 -expand} /tb/DUT/features(2)(0) {-color Red -height 17 -radix decimal -radixshowbase 1} /tb/DUT/features(2)(1) {-color Red -height 17 -radix decimal -radixshowbase 1} /tb/DUT/features(2)(2) {-color Red -height 17 -radix decimal -radixshowbase 1}} /tb/DUT/features
add wave -noupdate -divider computation
add wave -noupdate /tb/DUT/res_mac
add wave -noupdate -radix decimal /tb/DUT/data_from_mem
add wave -noupdate -childformat {{/tb/DUT/reg_mac(0) -radix decimal -childformat {{/tb/DUT/reg_mac(0)(0) -radix decimal} {/tb/DUT/reg_mac(0)(1) -radix decimal} {/tb/DUT/reg_mac(0)(2) -radix decimal}}} {/tb/DUT/reg_mac(1) -radix decimal} {/tb/DUT/reg_mac(2) -radix decimal -childformat {{/tb/DUT/reg_mac(2)(0) -radix decimal} {/tb/DUT/reg_mac(2)(1) -radix decimal} {/tb/DUT/reg_mac(2)(2) -radix decimal}}}} -expand -subitemconfig {/tb/DUT/reg_mac(0) {-height 17 -radix decimal -childformat {{/tb/DUT/reg_mac(0)(0) -radix decimal} {/tb/DUT/reg_mac(0)(1) -radix decimal} {/tb/DUT/reg_mac(0)(2) -radix decimal}}} /tb/DUT/reg_mac(0)(0) {-height 17 -radix decimal} /tb/DUT/reg_mac(0)(1) {-height 17 -radix decimal} /tb/DUT/reg_mac(0)(2) {-height 17 -radix decimal} /tb/DUT/reg_mac(1) {-height 17 -radix decimal} /tb/DUT/reg_mac(2) {-height 17 -radix decimal -childformat {{/tb/DUT/reg_mac(2)(0) -radix decimal} {/tb/DUT/reg_mac(2)(1) -radix decimal} {/tb/DUT/reg_mac(2)(2) -radix decimal}}} /tb/DUT/reg_mac(2)(0) {-height 17 -radix decimal} /tb/DUT/reg_mac(2)(1) {-height 17 -radix decimal} /tb/DUT/reg_mac(2)(2) {-height 17 -radix decimal}} /tb/DUT/reg_mac
add wave -noupdate -divider -height 30 SUM
add wave -noupdate /tb/DUT/count_convolutions
add wave -noupdate -radix decimal /tb/DUT/soma
add wave -noupdate /tb/valid
add wave -noupdate -radix decimal /tb/pixel
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2805 ns} 0} {{Cursor 2} {5 ns} 0}
quietly wave cursor active 2
configure wave -namecolwidth 234
configure wave -valuecolwidth 90
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ns} {33 ns}
