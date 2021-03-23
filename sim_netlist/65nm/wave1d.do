onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/DUT/clock
add wave -noupdate -radix decimal /tb/DUT/x
add wave -noupdate -radix decimal /tb/DUT/y
add wave -noupdate -divider CONTROL
add wave -noupdate /tb/DUT/start_line
add wave -noupdate /tb/DUT/endRead_and_startMac
add wave -noupdate -radix decimal /tb/DUT/count_eop
add wave -noupdate -divider -height 22 memory
add wave -noupdate -radix decimal /tb/DUT/x
add wave -noupdate -radix decimal /tb/DUT/y
add wave -noupdate -radix unsigned /tb/DUT/address_out
add wave -noupdate /tb/DUT/EA_add
add wave -noupdate -divider computation
add wave -noupdate -radix decimal /tb/DUT/data_from_mem
add wave -noupdate -divider -height 30 SUM
add wave -noupdate -radix decimal /tb/DUT/count_convolutions
add wave -noupdate -radix decimal /tb/DUT/count_column
add wave -noupdate -radix decimal /tb/DUT/soma
add wave -noupdate /tb/valid
add wave -noupdate -radix decimal /tb/pixel
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2350 ns} 0} {{Cursor 2} {275 ns} 0}
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
WaveRestoreZoom {1005 ns} {3105 ns}
