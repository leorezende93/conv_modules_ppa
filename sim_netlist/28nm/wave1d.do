onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/DUT/clock
add wave -noupdate -divider CONTROL
add wave -noupdate /tb/bias_en
add wave -noupdate /tb/weight_en
add wave -noupdate /tb/DUT/start_line
add wave -noupdate /tb/DUT/reg_weight_en
add wave -noupdate /tb/DUT/endRead_and_startMac
add wave -noupdate -divider -height 22 memory
add wave -noupdate -radix unsigned /tb/DUT/address_out
add wave -noupdate -divider computation
add wave -noupdate -radix decimal /tb/DUT/data_from_mem
add wave -noupdate -divider -height 30 SUM
add wave -noupdate /tb/valid
add wave -noupdate -radix decimal /tb/pixel
add wave -noupdate {/tb/DUT/\features[0] }
add wave -noupdate {/tb/DUT/\features[1] }
add wave -noupdate {/tb/DUT/\features[2] }
add wave -noupdate -radix decimal {/tb/DUT/\weight[0][0] }
add wave -noupdate -radix decimal {/tb/DUT/\weight[0][1] }
add wave -noupdate -radix decimal {/tb/DUT/\weight[0][2] }
add wave -noupdate -radix decimal {/tb/DUT/\weight[1][0] }
add wave -noupdate -radix decimal {/tb/DUT/\weight[1][1] }
add wave -noupdate -radix decimal {/tb/DUT/\weight[1][2] }
add wave -noupdate -radix decimal {/tb/DUT/\weight[2][0] }
add wave -noupdate -radix decimal {/tb/DUT/\weight[2][1] }
add wave -noupdate -radix decimal {/tb/DUT/\weight[2][2] }
add wave -noupdate /tb/DUT/bias_x
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4631 ps} 0} {{Cursor 2} {36314431 ps} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {0 ps} {6479 ps}
