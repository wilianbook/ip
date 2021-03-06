set_module_property DESCRIPTION "A module that allows communication with an SD Card"
set_module_property NAME Altera_UP_SD_Card_Avalon_Interface
set_module_property VERSION 13.0
set_module_property GROUP "University Program/Memory"
set_module_property DISPLAY_NAME "SD Card Interface"
set_module_property LIBRARIES {ieee.std_logic_1164.all ieee.std_logic_arith.all ieee.std_logic_unsigned.all std.standard.all}
set_module_property TOP_LEVEL_HDL_FILE "Altera_UP_SD_Card_Avalon_Interface.vhd"
set_module_property TOP_LEVEL_HDL_MODULE Altera_UP_SD_Card_Avalon_Interface
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property SIMULATION_MODEL_IN_VERILOG false
set_module_property SIMULATION_MODEL_IN_VHDL false
set_module_property SIMULATION_MODEL_HAS_TULIPS false
set_module_property SIMULATION_MODEL_IS_OBFUSCATED false

add_file Altera_UP_SD_Card_Avalon_Interface.vhd {SYNTHESIS}
add_file Altera_UP_SD_Card_48_bit_Command_Generator.vhd {SYNTHESIS}
add_file Altera_UP_SD_Card_Buffer.vhd {SYNTHESIS}
add_file Altera_UP_SD_Card_Clock.vhd {SYNTHESIS}
add_file Altera_UP_SD_Card_Control_FSM.vhd {SYNTHESIS}
add_file Altera_UP_SD_Card_Interface.vhd {SYNTHESIS}
add_file Altera_UP_SD_Card_Memory_Block.qip {SYNTHESIS}
add_file Altera_UP_SD_Card_Response_Receiver.vhd {SYNTHESIS}
add_file Altera_UP_SD_CRC16_Generator.vhd {SYNTHESIS}
add_file Altera_UP_SD_CRC7_Generator.vhd {SYNTHESIS}
add_file Altera_UP_SD_Signal_Trigger.vhd {SYNTHESIS}
add_file Altera_UP_SD_Card_Memory_Block.vhd {SYNTHESIS}
add_file Altera_UP_SD_Card_Memory_Block.bsf {SYNTHESIS}
add_file Altera_UP_SD_Card_Memory_Block.cmp {SYNTHESIS}


add_interface avalon_sdcard_slave avalon end
set_interface_property avalon_sdcard_slave holdTime 0
set_interface_property avalon_sdcard_slave linewrapBursts false
set_interface_property avalon_sdcard_slave minimumUninterruptedRunLength 1
set_interface_property avalon_sdcard_slave bridgesToMaster ""
set_interface_property avalon_sdcard_slave isMemoryDevice false
set_interface_property avalon_sdcard_slave burstOnBurstBoundariesOnly false
set_interface_property avalon_sdcard_slave addressSpan 1024
set_interface_property avalon_sdcard_slave timingUnits Cycles
set_interface_property avalon_sdcard_slave setupTime 0
set_interface_property avalon_sdcard_slave writeWaitTime 0
set_interface_property avalon_sdcard_slave isNonVolatileStorage false
set_interface_property avalon_sdcard_slave addressAlignment DYNAMIC
set_interface_property avalon_sdcard_slave maximumPendingReadTransactions 0
set_interface_property avalon_sdcard_slave readWaitTime 1
set_interface_property avalon_sdcard_slave readLatency 0
set_interface_property avalon_sdcard_slave printableDevice false

set_interface_property avalon_sdcard_slave ASSOCIATED_CLOCK clock_sink

add_interface_port avalon_sdcard_slave i_avalon_chip_select chipselect Input 1
add_interface_port avalon_sdcard_slave i_avalon_address address Input 8
add_interface_port avalon_sdcard_slave i_avalon_read read Input 1
add_interface_port avalon_sdcard_slave i_avalon_write write Input 1
add_interface_port avalon_sdcard_slave i_avalon_byteenable byteenable Input 4
add_interface_port avalon_sdcard_slave i_avalon_writedata writedata Input 32
add_interface_port avalon_sdcard_slave o_avalon_readdata readdata Output 32
add_interface_port avalon_sdcard_slave o_avalon_waitrequest waitrequest Output 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point clock_sink
# | 
add_interface clock_sink clock end
set_interface_property clock_sink ptfSchematicName ""

add_interface_port clock_sink i_clock clk Input 1
add_interface_port clock_sink i_reset_n reset_n Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point conduit_end
# | 
add_interface conduit_end conduit end

add_interface_port conduit_end b_SD_cmd export Bidir 1
add_interface_port conduit_end b_SD_dat export Bidir 1
add_interface_port conduit_end b_SD_dat3 export Bidir 1
add_interface_port conduit_end o_SD_clock export Output 1
# | 
# +-----------------------------------
