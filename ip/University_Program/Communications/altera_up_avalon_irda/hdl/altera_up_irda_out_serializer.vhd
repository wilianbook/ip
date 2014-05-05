LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_misc.all;
USE ieee.numeric_std.all;

-- ******************************************************************************
-- * License Agreement                                                          *
-- *                                                                            *
-- * Copyright (c) 1991-2013 Altera Corporation, San Jose, California, USA.     *
-- * All rights reserved.                                                       *
-- *                                                                            *
-- * Any megafunction design, and related net list (encrypted or decrypted),    *
-- *  support information, device programming or simulation file, and any other *
-- *  associated documentation or information provided by Altera or a partner   *
-- *  under Altera's Megafunction Partnership Program may be used only to       *
-- *  program PLD devices (but not masked PLD devices) from Altera.  Any other  *
-- *  use of such megafunction design, net list, support information, device    *
-- *  programming or simulation file, or any other related documentation or     *
-- *  information is prohibited for any other purpose, including, but not       *
-- *  limited to modification, reverse engineering, de-compiling, or use with   *
-- *  any other silicon devices, unless such use is explicitly licensed under   *
-- *  a separate agreement with Altera or a megafunction partner.  Title to     *
-- *  the intellectual property, including patents, copyrights, trademarks,     *
-- *  trade secrets, or maskworks, embodied in any such megafunction design,    *
-- *  net list, support information, device programming or simulation file, or  *
-- *  any other related documentation or information provided by Altera or a    *
-- *  megafunction partner, remains with Altera, the megafunction partner, or   *
-- *  their respective licensors.  No other licenses, including any licenses    *
-- *  needed under any third party's intellectual property, are provided herein.*
-- *  Copying or modifying any file, or portion thereof, to which this notice   *
-- *  is attached violates this copyright.                                      *
-- *                                                                            *
-- * THIS FILE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR    *
-- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,   *
-- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL    *
-- * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER *
-- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING    *
-- * FROM, OUT OF OR IN CONNECTION WITH THIS FILE OR THE USE OR OTHER DEALINGS  *
-- * IN THIS FILE.                                                              *
-- *                                                                            *
-- * This agreement shall be governed in all respects by the laws of the State  *
-- *  of California and by the laws of the United States of America.            *
-- *                                                                            *
-- ******************************************************************************

-- ******************************************************************************
-- *                                                                            *
-- * This module writes data to the IrDA UART Port.                             *
-- *                                                                            *
-- ******************************************************************************

ENTITY altera_up_irda_out_serializer IS 

-- *****************************************************************************
-- *                             Generic Declarations                          *
-- *****************************************************************************
	
GENERIC (
	
	CW								:INTEGER		:= 9;			-- Baud counter width
	BAUD_TICK_COUNT			:INTEGER		:= 433;
	BAUD_3_16_TICK_COUNT		:INTEGER		:= 81;
	CAPTURE_IN_TICK_COUNT	:INTEGER		:= 60;
	HALF_BAUD_TICK_COUNT		:INTEGER		:= 216;
	
	TDW							:INTEGER		:= 11;		-- Total data width
	DW								:INTEGER		:= 9			-- Data width
	
);
-- *****************************************************************************
-- *                             Port Declarations                             *
-- *****************************************************************************
PORT (
	-- Inputs
	clk					:IN		STD_LOGIC;
	reset					:IN		STD_LOGIC;

	transmit_data		:IN		STD_LOGIC_VECTOR(DW DOWNTO  0);	
	transmit_data_en	:IN		STD_LOGIC;

	-- Bidirectionals

	-- Outputs
	fifo_write_space	:BUFFER	STD_LOGIC_VECTOR( 7 DOWNTO  0);	

	serial_data_out	:BUFFER	STD_LOGIC


);

END altera_up_irda_out_serializer;

ARCHITECTURE Behaviour OF altera_up_irda_out_serializer IS
-- *****************************************************************************
-- *                           Constant Declarations                           *
-- *****************************************************************************

-- *****************************************************************************
-- *                       Internal Signals Declarations                       *
-- *****************************************************************************
	
	-- Internal Wires
	SIGNAL	shift_data_reg_en		:STD_LOGIC;
	SIGNAL	transmitting_bit		:STD_LOGIC;
	SIGNAL	all_bits_transmitted	:STD_LOGIC;
	
	SIGNAL	read_fifo_en			:STD_LOGIC;
	
	SIGNAL	fifo_is_empty			:STD_LOGIC;
	SIGNAL	fifo_is_full			:STD_LOGIC;
	SIGNAL	fifo_used				:STD_LOGIC_VECTOR( 6 DOWNTO  0);	
	
	SIGNAL	data_from_fifo			:STD_LOGIC_VECTOR(DW DOWNTO  0);	
	
	-- Internal Registers
	SIGNAL	transmitting_data		:STD_LOGIC;
	
	SIGNAL	data_out_shift_reg	:STD_LOGIC_VECTOR((DW + 1) DOWNTO  0);	
	
	-- State Machine Registers
	
-- *****************************************************************************
-- *                          Component Declarations                           *
-- *****************************************************************************
	COMPONENT altera_up_irda_counters
	GENERIC ( 
		CW								:INTEGER;
		BAUD_TICK_COUNT			:INTEGER;
		BAUD_3_16_TICK_COUNT		:INTEGER;
		CAPTURE_IN_TICK_COUNT	:INTEGER;
		HALF_BAUD_TICK_COUNT		:INTEGER;
		TDW							:INTEGER
	);
	PORT (
		-- Inputs
		clk							:IN		STD_LOGIC;
		reset							:IN		STD_LOGIC;
	
		reset_counters				:IN		STD_LOGIC;

		-- Bidirectionals

		-- Outputs
		baud_clock_rising_edge	:BUFFER	STD_LOGIC;
		transmitting_bit			:BUFFER	STD_LOGIC;
		all_bits_transmitted		:BUFFER	STD_LOGIC
	);
	END COMPONENT;

	COMPONENT altera_up_sync_fifo
	GENERIC ( 
		DW					:INTEGER;
		DATA_DEPTH		:INTEGER;
		AW					:INTEGER
	);
	PORT (
		-- Inputs
		clk				:IN		STD_LOGIC;
		reset				:IN		STD_LOGIC;

		write_en			:IN		STD_LOGIC;
		write_data		:IN		STD_LOGIC_VECTOR(DW DOWNTO  0);

		read_en			:IN		STD_LOGIC;
	
		-- Bidirectionals

		-- Outputs
		fifo_is_empty	:BUFFER	STD_LOGIC;
		fifo_is_full	:BUFFER	STD_LOGIC;
		words_used		:BUFFER	STD_LOGIC_VECTOR( 6 DOWNTO  0);

		read_data		:BUFFER	STD_LOGIC_VECTOR(DW DOWNTO  0)
	);
	END COMPONENT;

BEGIN
-- *****************************************************************************
-- *                         Finite State Machine(s)                           *
-- *****************************************************************************


-- *****************************************************************************
-- *                             Sequential Logic                              *
-- *****************************************************************************

	PROCESS (clk)
	BEGIN
		IF clk'EVENT AND clk = '1' THEN
			IF (reset = '1') THEN
				fifo_write_space <= B"00000000";
			ELSE
				fifo_write_space <= B"10000000" - (fifo_is_full & fifo_used);
			END IF;
		END IF;
	END PROCESS;



	PROCESS (clk)
	BEGIN
		IF clk'EVENT AND clk = '1' THEN
			IF (reset = '1') THEN
				serial_data_out <= '0';
			ELSIF (transmitting_bit = '1') THEN
				serial_data_out <= NOT data_out_shift_reg(0);
			ELSE
				serial_data_out <= '0';
			END IF;
		END IF;
	END PROCESS;


	PROCESS (clk)
	BEGIN
		IF clk'EVENT AND clk = '1' THEN
			IF (reset = '1') THEN
				transmitting_data <= '0';
			ELSIF (all_bits_transmitted = '1') THEN
				transmitting_data <= '0';
			ELSIF (read_fifo_en = '1') THEN
				transmitting_data <= '1';
			END IF;
		END IF;
	END PROCESS;


	PROCESS (clk)
	BEGIN
		IF clk'EVENT AND clk = '1' THEN
			IF (reset = '1') THEN
				data_out_shift_reg	<= (OTHERS => '1');
			ELSIF (read_fifo_en = '1') THEN
				data_out_shift_reg	<= (data_from_fifo & '0');
			ELSIF (shift_data_reg_en = '1') THEN
				data_out_shift_reg	<= 
					('1' & data_out_shift_reg((DW + 1) DOWNTO 1));
			END IF;
		END IF;
	END PROCESS;


-- *****************************************************************************
-- *                            Combinational Logic                            *
-- *****************************************************************************

	read_fifo_en <= 
				 NOT transmitting_data AND NOT fifo_is_empty AND NOT 
				 all_bits_transmitted AND NOT shift_data_reg_en;

-- *****************************************************************************
-- *                          Component Instantiations                         *
-- *****************************************************************************

	IrDA_Out_Counters : altera_up_irda_counters 
	GENERIC MAP ( 
		CW								=> CW,
		BAUD_TICK_COUNT			=> BAUD_TICK_COUNT,
		BAUD_3_16_TICK_COUNT		=> BAUD_3_16_TICK_COUNT,
		CAPTURE_IN_TICK_COUNT	=> CAPTURE_IN_TICK_COUNT,
		HALF_BAUD_TICK_COUNT		=> HALF_BAUD_TICK_COUNT,
		TDW							=> TDW
	)
	PORT MAP (
		-- Inputs
		clk							=> clk,
		reset							=> reset,
		
		reset_counters				=>  NOT transmitting_data,
	
		-- Bidirectionals
	
		-- Outputs
		baud_clock_rising_edge	=> shift_data_reg_en,
		transmitting_bit			=> transmitting_bit,
		all_bits_transmitted		=> all_bits_transmitted
	);

	IrDA_Out_FIFO : altera_up_sync_fifo 
	GENERIC MAP ( 
		DW					=> DW,
		DATA_DEPTH		=> 128,
		AW					=> 6
	)
	PORT MAP (
		-- Inputs
		clk				=> clk,
		reset				=> reset,
	
		write_en			=> transmit_data_en AND NOT fifo_is_full,
		write_data		=> transmit_data,
	
		read_en			=> read_fifo_en,
		
		-- Bidirectionals
	
		-- Outputs
		fifo_is_empty	=> fifo_is_empty,
		fifo_is_full	=> fifo_is_full,
		words_used		=> fifo_used,
	
		read_data		=> data_from_fifo
	);


END Behaviour;
