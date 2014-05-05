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
# | module altera_up_avalon_accelerometer_spi
# | 
set_module_property DESCRIPTION "Accelerometer Controller in SPI Mode for the DE0-Nano Board"
set_module_property NAME altera_up_avalon_accelerometer_spi
set_module_property VERSION 13.0
set_module_property GROUP "University Program/Generic IO"
set_module_property AUTHOR "Altera University Program"
set_module_property DISPLAY_NAME "Accelerometer SPI Mode"
set_module_property DATASHEET_URL "doc/Accelerometer_SPI_Mode.pdf"
#set_module_property TOP_LEVEL_HDL_FILE altera_up_avalon_accelerometer_spi.v
#set_module_property TOP_LEVEL_HDL_MODULE altera_up_avalon_accelerometer_spi
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE false
set_module_property ANALYZE_HDL false
set_module_property GENERATION_CALLBACK generate
# | 
# +-----------------------------------

# +-----------------------------------
# | files
# | 
#add_file altera_up_avalon_accelerometer_spi.v {SYNTHESIS SIMULATION}
add_file "hdl/altera_up_accelerometer_spi_serial_bus_controller.v" {SYNTHESIS SIMULATION}
add_file "hdl/altera_up_accelerometer_spi_slow_clock_generator.v" {SYNTHESIS SIMULATION}
add_file "hdl/altera_up_accelerometer_spi_auto_init.v" {SYNTHESIS SIMULATION}
add_file "hdl/altera_up_accelerometer_spi_auto_init_ctrl.v" {SYNTHESIS SIMULATION}
# | 
# +-----------------------------------

# +-----------------------------------
# | parameters
# | 
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
# | connection point avalon_accelerometer_spi_mode_slave
# | 
add_interface avalon_accelerometer_spi_mode_slave avalon end clock_reset
set_interface_property avalon_accelerometer_spi_mode_slave addressAlignment DYNAMIC
set_interface_property avalon_accelerometer_spi_mode_slave bridgesToMaster ""
set_interface_property avalon_accelerometer_spi_mode_slave burstOnBurstBoundariesOnly false
#set_interface_property avalon_accelerometer_spi_mode_slave explicitAddressSpan 16
set_interface_property avalon_accelerometer_spi_mode_slave holdTime 0
set_interface_property avalon_accelerometer_spi_mode_slave isBigEndian  false
set_interface_property avalon_accelerometer_spi_mode_slave isFlash false
set_interface_property avalon_accelerometer_spi_mode_slave isMemoryDevice false
set_interface_property avalon_accelerometer_spi_mode_slave isNonVolatileStorage false
set_interface_property avalon_accelerometer_spi_mode_slave linewrapBursts false
set_interface_property avalon_accelerometer_spi_mode_slave maximumPendingReadTransactions 0
set_interface_property avalon_accelerometer_spi_mode_slave minimumUninterruptedRunLength 1
set_interface_property avalon_accelerometer_spi_mode_slave printableDevice false
set_interface_property avalon_accelerometer_spi_mode_slave readLatency 1
set_interface_property avalon_accelerometer_spi_mode_slave readWaitTime 0
set_interface_property avalon_accelerometer_spi_mode_slave setupTime 0
set_interface_property avalon_accelerometer_spi_mode_slave timingUnits cycles
set_interface_property avalon_accelerometer_spi_mode_slave writeWaitTime 0

add_interface_port avalon_accelerometer_spi_mode_slave address address Input 1
add_interface_port avalon_accelerometer_spi_mode_slave byteenable byteenable Input 1
add_interface_port avalon_accelerometer_spi_mode_slave read read Input 1
add_interface_port avalon_accelerometer_spi_mode_slave write write Input 1
add_interface_port avalon_accelerometer_spi_mode_slave writedata writedata Input 8
add_interface_port avalon_accelerometer_spi_mode_slave readdata readdata Output 8
add_interface_port avalon_accelerometer_spi_mode_slave waitrequest waitrequest Output 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point interrupt
# | 
add_interface interrupt interrupt sender

set_interface_property interrupt associatedAddressablePoint avalon_accelerometer_spi_mode_slave
set_interface_property interrupt ASSOCIATED_CLOCK clock_reset
add_interface_port interrupt irq irq Output 1
# | 
# +-----------------------------------

# +-----------------------------------
# | connection point external_interface
# | 
add_interface external_interface conduit end

add_interface_port external_interface I2C_SDAT export Bidir 1
add_interface_port external_interface I2C_SCLK export Output 1
add_interface_port external_interface G_SENSOR_CS_N export Output 1
add_interface_port external_interface G_SENSOR_INT export Input 1
# | 
# +-----------------------------------

# +-----------------------------------
# | Validation function
# | 
# | 
# +-----------------------------------

# +-----------------------------------
# | Elaboration function
# | 
# | 
# +-----------------------------------

# +-----------------------------------
# | Generation function
# | 
proc generate {} {
	send_message info "Starting Generation of the Accelerometer Controller in SPI mode"

	# get parameter values

	# set section values
	
	# set arguments
	set params ""
	set sections "" 

	# get generation settings
	set dest_language	[ get_generation_property HDL_LANGUAGE ]
	set dest_dir 		[ get_generation_property OUTPUT_DIRECTORY ]
	set dest_name		[ get_generation_property OUTPUT_NAME ]
	
	set file_ending "v"
#	if { $dest_language == "VHDL" || $dest_language == "vhdl" } {
#		set file_ending "vhd"
#	}

	add_file "$dest_dir$dest_name.$file_ending" {SYNTHESIS SIMULATION}

	# Generate HDL
	source "up_ip_generator.tcl"
	alt_up_generate "$dest_dir$dest_name.$file_ending" "hdl/altera_up_avalon_accelerometer_spi.$file_ending" "altera_up_avalon_accelerometer_spi" $dest_name $params $sections

	# generate top level template
	#alt_up_create_instantiation_template "$dest_dir$dest_name.inst.v" $dest_name "external_interface"
}
# | 
# +-----------------------------------

