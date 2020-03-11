##general settings
set_property CONFIG_VOLTAGE 1.8 [current_design]
set_property CFGBVS GND [current_design]

##Clocks
#300 MHz Systemclock 1
set_property PACKAGE_PIN G31 [get_ports {SYSCLK1_300_P}]
set_property PACKAGE_PIN F31 [get_ports {SYSCLK1_300_N}]
set_property IOSTANDARD DIFF_SSTL12 [get_ports -filter NAME=~SYSCLK1_300_*]
create_clock -period 3.333 -name SYSCLK1_300 [get_ports {SYSCLK1_300_P}]

##switches
set_property PACKAGE_PIN BC40 [get_ports {sw[0]}]
set_property PACKAGE_PIN L19  [get_ports {sw[1]}]
set_property PACKAGE_PIN C37  [get_ports {sw[2]}]
set_property PACKAGE_PIN C38  [get_ports {sw[3]}]

set_property IOSTANDARD LVCMOS12 [get_ports -filter NAME=~sw*]
set_false_path -from [get_ports -filter NAME=~sw*]


##cpu reset
set_property PACKAGE_PIN E36 [get_ports cpu_reset]

set_property IOSTANDARD LVCMOS12 [get_ports cpu_reset]
set_property PULLDOWN true [get_ports cpu_reset]


##LEDs
set_property PACKAGE_PIN AT32 [get_ports {led[0]}]
set_property PACKAGE_PIN AV34 [get_ports {led[1]}]
set_property PACKAGE_PIN AY30 [get_ports {led[2]}]
set_property PACKAGE_PIN BB32 [get_ports {led[3]}]
set_property PACKAGE_PIN BF32 [get_ports {led[4]}]
set_property PACKAGE_PIN AV36 [get_ports {led[5]}]
set_property PACKAGE_PIN AY35 [get_ports {led[6]}]
set_property PACKAGE_PIN BA37 [get_ports {led[7]}]

set_property IOSTANDARD LVCMOS12 [get_ports -filter NAME=~led*]
set_false_path -to [get_ports -filter NAME=~led*]


##DDR SDRAM Channel 1
#Package Pin and IO Standard done by Vivado

#set DDR reset as false path
set_false_path -from [get_pins i_ddr/inst/div_clk_rst_r1_reg/C]

#RAM Calibration
set_property C_CLK_INPUT_FREQ_HZ    300000000   [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER   false       [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN      1           [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_1]


##SD CARD
#all of Pmod0
set_property PACKAGE_PIN BB16 [get_ports spi_clk_o] ;#PMOD0_3
set_property PACKAGE_PIN BC14 [get_ports spi_ss]    ;#PMOD0_0
set_property PACKAGE_PIN BA10 [get_ports spi_mosi]  ;#PMOD0_1
set_property PACKAGE_PIN AW16 [get_ports spi_miso]  ;#PMOD0_2

set_property IOSTANDARD LVCMOS18 [get_ports -filter NAME=~spi_*]

#set_property PACKAGE_PIN BC14     [get_ports "PMOD0[0]"] ;# Bank  66 VCCO - VADJ_1V8_FPGA - IO_L19P_T3L_N0_DBC_AD9P_66
#set_property PACKAGE_PIN BA10     [get_ports "PMOD0[1]"] ;# Bank  66 VCCO - VADJ_1V8_FPGA - IO_T2U_N12_66
#set_property PACKAGE_PIN AW16     [get_ports "PMOD0[2]"] ;# Bank  67 VCCO - VADJ_1V8_FPGA - IO_T1U_N12_67
#set_property PACKAGE_PIN BB16     [get_ports "PMOD0[3]"] ;# Bank  66 VCCO - VADJ_1V8_FPGA - IO_L20P_T3L_N2_AD1P_66
#set_property PACKAGE_PIN BC13     [get_ports "PMOD0[4]"] ;# Bank  66 VCCO - VADJ_1V8_FPGA - IO_L19N_T3L_N1_DBC_AD9N_66
#set_property PACKAGE_PIN BF7      [get_ports "PMOD0[5]"] ;# Bank  66 VCCO - VADJ_1V8_FPGA - IO_T1U_N12_66
#set_property PACKAGE_PIN AW12     [get_ports "PMOD0[6]"] ;# Bank  67 VCCO - VADJ_1V8_FPGA - IO_L2P_T0L_N2_67
#set_property PACKAGE_PIN BC16     [get_ports "PMOD0[7]"] ;# Bank  66 VCCO - VADJ_1V8_FPGA - IO_L20N_T3L_N3_AD1N_66
#set_property -dict {IOSTANDARD LVCMOS18} [get_ports -filter NAME=~PMOD0*]


##Uart
##2 of 8 Ports of Pmod1
set_property PACKAGE_PIN N22 [get_ports tx] ;#PMOD1_1
set_property PACKAGE_PIN J20 [get_ports rx] ;#PMOD1_2

set_property IOSTANDARD LVCMOS12 [get_ports { tx rx }]

#Create UART Interface
create_interface UART
set_property INTERFACE UART [get_ports { tx rx }]


##JTAG
# 5 of 8 Ports of Pmod1
#set Package Pins
set_property PACKAGE_PIN J24 [get_ports tck]    ;#PMOD1_4
set_property PACKAGE_PIN T23 [get_ports tdi]    ;#PMOD1_5
set_property PACKAGE_PIN R23 [get_ports tdo]    ;#PMOD1_6
set_property PACKAGE_PIN R22 [get_ports tms]    ;#PMOD1_7
set_property PACKAGE_PIN K24 [get_ports trst_n] ;#PMOD1_3
#set IOStandard
set_property IOSTANDARD LVCMOS12 [get_ports { tck tdi tdo tms trst_n }]

#Create JTAG Interface
create_interface JTAG
set_property INTERFACE JTAG [get_ports { tck tdi tdo tms trst_n }]

#accept sub-optimal placing
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets tck_IBUF_inst/O]

#JTAG Clock
create_clock -period 100.000 -name tck -waveform {0.000 50.000} [get_ports tck]
set_input_jitter tck 1.000

#set JTAG reset as false path
set_false_path -from [get_ports trst_n]

#set_property PACKAGE_PIN P22      [get_ports "PMOD1[0]"] ;# Bank  70 VCCO - VCC1V2_FPGA - IO_L5N_T0U_N9_AD14N_70
#set_property PACKAGE_PIN N22      [get_ports "PMOD1[1]"] ;# Bank  70 VCCO - VCC1V2_FPGA - IO_L4P_T0U_N6_DBC_AD7P_70
#set_property PACKAGE_PIN J20      [get_ports "PMOD1[2]"] ;# Bank  70 VCCO - VCC1V2_FPGA - IO_T1U_N12_70
#set_property PACKAGE_PIN K24      [get_ports "PMOD1[3]"] ;# Bank  70 VCCO - VCC1V2_FPGA - IO_L8P_T1L_N2_AD5P_70
#set_property PACKAGE_PIN J24      [get_ports "PMOD1[4]"] ;# Bank  70 VCCO - VCC1V2_FPGA - IO_L8N_T1L_N3_AD5N_70
#set_property PACKAGE_PIN T23      [get_ports "PMOD1[5]"] ;# Bank  70 VCCO - VCC1V2_FPGA - IO_L6P_T0U_N10_AD6P_70
#set_property PACKAGE_PIN R23      [get_ports "PMOD1[6]"] ;# Bank  70 VCCO - VCC1V2_FPGA - IO_L6N_T0U_N11_AD6N_70
#set_property PACKAGE_PIN R22      [get_ports "PMOD1[7]"] ;# Bank  70 VCCO - VCC1V2_FPGA - IO_L5P_T0U_N8_AD14P_70
#set_property -dict {IOSTANDARD LVCMOS12} [get_ports -filter NAME=~PMOD1*]

#BPI FLASH
set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN  div-1 [current_design]
set_property BITSTREAM.CONFIG.BPI_SYNC_MODE     Type1 [current_design]
set_property CONFIG_MODE                        BPI16 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS         TRUE  [current_design]


