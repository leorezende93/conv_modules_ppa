onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/DUT/reset
add wave -noupdate /tb/DUT/clock
add wave -noupdate /tb/DUT/start_line
add wave -noupdate -radix unsigned /tb/address_out
add wave -noupdate /tb/valid
add wave -noupdate -radix decimal /tb/pixel
add wave -noupdate /tb/start_line
add wave -noupdate /tb/weight_en
add wave -noupdate -radix decimal /tb/DUT/weight_en
add wave -noupdate -radix decimal /tb/DUT/address_out
add wave -noupdate -radix decimal {/tb/DUT/\weight[0][0] }
add wave -noupdate -radix decimal {/tb/DUT/\weight[0][1] }
add wave -noupdate -radix decimal {/tb/DUT/\weight[0][2] }
add wave -noupdate -radix decimal {/tb/DUT/\weight[1][0] }
add wave -noupdate -radix decimal {/tb/DUT/\weight[1][1] }
add wave -noupdate -radix decimal {/tb/DUT/\weight[1][2] }
add wave -noupdate -radix decimal {/tb/DUT/\weight[2][0] }
add wave -noupdate -radix decimal {/tb/DUT/\weight[2][1] }
add wave -noupdate -radix decimal {/tb/DUT/\weight[2][2] }
add wave -noupdate -radix decimal /tb/DUT/valid
add wave -noupdate -radix decimal /tb/DUT/pixel
add wave -noupdate /tb/DUT/EA_add
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3295166 ps} 0} {{Cursor 2} {789750 ps} 0}
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
WaveRestoreZoom {0 ps} {27819 ps}
