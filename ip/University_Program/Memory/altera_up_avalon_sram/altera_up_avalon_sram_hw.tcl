# +----------------------------------------------------------------------------+
# | License Agreement                                                          |
# |                                                                            |
# | Copyright (c) 1991-2013 Altera Corporation, San Jose, California, USA.     |
# | All rights reserved.                                                       |
# |                                                                            |
# | Any megafunction design, and related net list (encrypted or decrypted),    |
# |  support information, device programming or simulation file, and any other |
# |  associated documentation or information provided by Altera or a partner   |
# |  under Altera's Megafunction Partnership Program may be used only to       |
# |  program PLD devices (but not masked PLD devices) from Altera.  Any other  |
# |  use of such megafunction design, net list, support information, device    |
# |  programming or simulation file, or any other related documentation or     |
# |  information is prohibited for any other purpose, including, but not       |
# |  limited to modification, reverse engineering, de-compiling, or use with   |
# |  any other silicon devices, unless such use is explicitly licensed under   |
# |  a separate agreement with Altera or a megafunction partner.  Title to     |
# |  the intellectual property, including patents, copyrights, trademarks,     |
# |  trade secrets, or maskworks, embodied in any such megafunction design,    |
# |  net list, support information, device programming or simulation file, or  |
# |  any other related documentation or information provided by Altera or a    |
# |  megafunction partner, remains with Altera, the megafunction partner, or   |
# |  their respective licensors.  No other licenses, including any licenses    |
# |  needed under any third party's intellectual property, are provided herein.|
# |  Copying or modifying any file, or portion thereof, to which this notice   |
# |  is attached violates this copyright.                                      |
# |                                                                            |
# | THIS FILE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    |
# | IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,   |
# | FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL    |
# | THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER |
# | LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING    |
# | FROM, OUT OF OR IN CONNECTION WITH THIS FILE OR THE USE OR OTHER DEALINGS  |
# | IN THIS FILE.                                                              |
# |                                                                            |
# | This agreement shall be governed in all respects by the laws of the State  |
# |  of California and by the laws of the United States of America.            |
# |                                                                            |
# +----------------------------------------------------------------------------+

# TCL File Generated by Altera University Program
# DO NOT MODIFY

# +-----------------------------------
# | module altera_up_avalon_sram
# | 
set_module_property DESCRIPTION "SRAM/SSRAM Controller for DE-series Boards"
set_module_property NAME altera_up_avalon_sram
set_module_property VERSION 13.0
set_module_property GROUP "University Program/Memory"
set_module_property AUTHOR "Altera University Program"
set_module_property DISPLAY_NAME "SRAM/SSRAM Controller"
#set_module_property DATASHEET_URL "doc/SRAM_Controller.pdf"
#set_module_property top_level_hdl_file altera_up_avalon_sram.v
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property ANALYZE_HDL false
set_module_property ELABORATION_CALLBACK elaborate
set_module_property GENERATION_CALLBACK generate
# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
#add_file altera_up_avalon_sram.v {SYNTHESIS SIMULATION}
# | 
# +-----------------------------------

# +-----------------------------------
# | parameters
# | 
add_parameter board string DE2
set_parameter_property board DISPLAY_NAME "DE-Series Board"
set_parameter_property board GROUP "Configurations"
set_parameter_property board UNITS None
set_parameter_property board AFFECTS_ELABORATION true
set_parameter_property board AFFECTS_GENERATION true
set_parameter_property board ALLOWED_RANGES {DE1 DE2 "DE2-70" "DE2-115"}
set_parameter_property board VISIBLE true
set_parameter_property board ENABLED true

add_parameter pixel_buffer boolean false
set_parameter_property pixel_buffer DISPLAY_NAME "Use as a pixel buffer for video out"
set_parameter_property pixel_buffer GROUP "Configurations"
set_parameter_property pixel_buffer UNITS None
set_parameter_property pixel_buffer AFFECTS_ELABORATION true
set_parameter_property pixel_buffer AFFECTS_GENERATION true
set_parameter_property pixel_buffer VISIBLE true
set_parameter_property pixel_buffer ENABLED true
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point clock_reset
# | 
add_interface clock_reset clock end
set_interface_property clock_reset ptfSchematicName ""

add_interface_port clock_reset clk clk Input 1
add_interface_port clock_reset reset reset Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point external_interface
# | 
add_interface external_interface conduit end 
# | 
# +-----------------------------------

# +-----------------------------------
# | Elaboration function
# | 
proc elaborate {} {
	set board [ get_parameter_value "board" ]
	set pixel_buffer [ get_parameter_value "pixel_buffer" ]

	if { $board == "DE2-70" } {
		# +-----------------------------------
		# | connection point avalon_ssram_slave
		# | 
		add_interface avalon_ssram_slave avalon end clock_reset

		set_interface_property avalon_ssram_slave addressAlignment DYNAMIC
		set_interface_property avalon_ssram_slave bridgesToMaster ""
		set_interface_property avalon_ssram_slave burstOnBurstBoundariesOnly false
#		set_interface_property avalon_ssram_slave explicitAddressSpan 2011.052
		set_interface_property avalon_ssram_slave holdTime 0
		set_interface_property avalon_ssram_slave isBigEndian  false
		set_interface_property avalon_ssram_slave isFlash false
		if { $pixel_buffer } {
			set_interface_property avalon_ssram_slave isMemoryDevice false
		} else {
			set_interface_property avalon_ssram_slave isMemoryDevice true
		}
		set_interface_property avalon_ssram_slave isNonVolatileStorage false
		set_interface_property avalon_ssram_slave linewrapBursts false
		set_interface_property avalon_ssram_slave maximumPendingReadTransactions 4
		set_interface_property avalon_ssram_slave minimumUninterruptedRunLength 1
		set_interface_property avalon_ssram_slave printableDevice false
		set_interface_property avalon_ssram_slave readLatency 0
		set_interface_property avalon_ssram_slave readWaitTime 0
		set_interface_property avalon_ssram_slave setupTime 0
		set_interface_property avalon_ssram_slave timingUnits cycles
		set_interface_property avalon_ssram_slave writeWaitTime 0

		add_interface_port avalon_ssram_slave address address Input 19
		add_interface_port avalon_ssram_slave byteenable byteenable Input 4
		add_interface_port avalon_ssram_slave read read Input 1
		add_interface_port avalon_ssram_slave write write Input 1
		add_interface_port avalon_ssram_slave writedata writedata Input 32
		add_interface_port avalon_ssram_slave readdata readdata Output 32
		add_interface_port avalon_ssram_slave readdatavalid readdatavalid Output 1
		add_interface_port avalon_ssram_slave waitrequest waitrequest Output 1
		# | 
		# +-----------------------------------

		# Add signals to the connection point external_interface
		add_interface_port external_interface SRAM_DQ export Bidir 32
		add_interface_port external_interface SRAM_DPA export Bidir 4
		add_interface_port external_interface SRAM_ADDR export Output 19
		add_interface_port external_interface SRAM_ADSC_N export Output 1
		add_interface_port external_interface SRAM_ADSP_N export Output 1
		add_interface_port external_interface SRAM_ADV_N export Output 1
		add_interface_port external_interface SRAM_BE_N export Output 4
		add_interface_port external_interface SRAM_CE1_N export Output 1
		add_interface_port external_interface SRAM_CE2 export Output 1
		add_interface_port external_interface SRAM_CE3_N export Output 1
		add_interface_port external_interface SRAM_GW_N export Output 1
		add_interface_port external_interface SRAM_OE_N export Output 1
		add_interface_port external_interface SRAM_WE_N export Output 1
		add_interface_port external_interface SRAM_CLK export Output 1
	} else {
		# +-----------------------------------
		# | connection point avalon_sram_slave
		# | 
		add_interface avalon_sram_slave avalon end clock_reset

		set_interface_property avalon_sram_slave addressAlignment DYNAMIC
		set_interface_property avalon_sram_slave bridgesToMaster ""
		set_interface_property avalon_sram_slave burstOnBurstBoundariesOnly false
#		if { $board == "DE2-115" } {
#			set_interface_property avalon_sram_slave explicitAddressSpan 2011.052
#		} else {
#			set_interface_property avalon_sram_slave explicitAddressSpan 524288
#		}
		set_interface_property avalon_sram_slave holdTime 0
		set_interface_property avalon_sram_slave isBigEndian  false
		set_interface_property avalon_sram_slave isFlash false
		if { $pixel_buffer } {
			set_interface_property avalon_sram_slave isMemoryDevice false
		} else {
			set_interface_property avalon_sram_slave isMemoryDevice true
		}
		set_interface_property avalon_sram_slave isNonVolatileStorage false
		set_interface_property avalon_sram_slave linewrapBursts false
		set_interface_property avalon_sram_slave maximumPendingReadTransactions 2
		set_interface_property avalon_sram_slave minimumUninterruptedRunLength 1
		set_interface_property avalon_sram_slave printableDevice false
		set_interface_property avalon_sram_slave readLatency 0
		set_interface_property avalon_sram_slave readWaitTime 0
		set_interface_property avalon_sram_slave setupTime 0
		set_interface_property avalon_sram_slave timingUnits cycles
		set_interface_property avalon_sram_slave writeWaitTime 0

		if { $board == "DE2-115" } {
			add_interface_port avalon_sram_slave address address Input 20
		} else {
			add_interface_port avalon_sram_slave address address Input 18
		}
		add_interface_port avalon_sram_slave byteenable byteenable Input 2
		add_interface_port avalon_sram_slave read read Input 1
		add_interface_port avalon_sram_slave write write Input 1
		add_interface_port avalon_sram_slave writedata writedata Input 16
		add_interface_port avalon_sram_slave readdata readdata Output 16
		add_interface_port avalon_sram_slave readdatavalid readdatavalid Output 1
		# | 
		# +-----------------------------------

		# Add signals to the connection point external_interface
		add_interface_port external_interface SRAM_DQ export Bidir 16
		if { $board == "DE2-115" } {
			add_interface_port external_interface SRAM_ADDR export Output 20
		} else {
			add_interface_port external_interface SRAM_ADDR export Output 18
		}
		add_interface_port external_interface SRAM_LB_N export Output 1
		add_interface_port external_interface SRAM_UB_N export Output 1
		add_interface_port external_interface SRAM_CE_N export Output 1
		add_interface_port external_interface SRAM_OE_N export Output 1
		add_interface_port external_interface SRAM_WE_N export Output 1
	}
}
# | 
# +-----------------------------------

# +-----------------------------------
# | Generation function
# | 
proc generate {} {
	send_message info "Starting Generation of SRAM or SSRAM Controller"

	# get parameter values
	set board [ get_parameter_value "board" ]

	# set section values

	# set top_level_ports and external_port
#	set top_level_name [ format "top_level_name=%s" [ get_project_property QUARTUS_PROJECT_NAME ] ]
#	set top_level_ports "top_level_ports="
#	set module_ports "module_ports="
#	foreach port [ get_interface_ports external_interface ] {
#		set direction [ get_port_property $port DIRECTION ]
#		set width [ get_port_property $port WIDTH ]
		
#		set top_level_ports "$top_level_ports$port:$direction:$width;"
#		set module_ports  "$module_ports$port:$direction:$width:$port;"
#	}
	
	# set arguments
	if { $board == "DE2-70" } {
		set files "files=Altera_UP_Avalon_SSRAM.v"
	} else {
		set files "files=Altera_UP_Avalon_SRAM.v"
	}
	set params ""
	if { $board == "DE2-115" } {
		set sections "USE_DE2_115:1"
	} else {
		set sections "USE_DE2_115:0"
	}

	# get generation properties
	set dest_language	[ get_generation_property HDL_LANGUAGE ]
	set dest_dir 		[ get_generation_property OUTPUT_DIRECTORY ]
	set dest_name		[ get_generation_property OUTPUT_NAME ]
	
	set file_ending "v"
	if { $dest_language == "VHDL" || $dest_language == "vhdl" } {
		set file_ending "vhd"
	}

	add_file "$dest_dir$dest_name.$file_ending" {SYNTHESIS SIMULATION}

	# generate HDL
	source "up_ip_generator.tcl"
	if { $board == "DE2-70" } {
		alt_up_generate "$dest_dir$dest_name.$file_ending" "hdl/altera_up_avalon_ssram.$file_ending" "altera_up_avalon_ssram" $dest_name $params $sections
	} else {
		alt_up_generate "$dest_dir$dest_name.$file_ending" "hdl/altera_up_avalon_sram.$file_ending" "altera_up_avalon_sram" $dest_name $params $sections
	}

	# generate top level template
	#alt_up_create_instantiation_template "$dest_dir$dest_name.inst.v" $dest_name "external_interface"

#	alt_up_test
}
# | 
# +-----------------------------------

