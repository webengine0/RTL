--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:20:56 11/03/2022
-- Design Name:   
-- Module Name:   C:/Users/user/Documents/task/Pong_game/tb.vhd
-- Project Name:  Pong_game
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PONG_GAME
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb IS
END tb;
 
ARCHITECTURE behavior OF tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PONG_GAME
    PORT(
         CLOCK : IN  std_logic;
         btnr : IN  std_logic;
         btnl : IN  std_logic;
         btnd : IN  std_logic;
         oled_sdin : OUT  std_logic;
         oled_sclk : OUT  std_logic;
         oled_dc : OUT  std_logic;
         oled_res : OUT  std_logic;
         oled_vbat : OUT  std_logic;
         oled_vdd : OUT  std_logic;
         LED : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLOCK : std_logic := '0';
   signal btnr : std_logic := '0';
   signal btnl : std_logic := '0';
   signal btnd : std_logic := '0';

 	--Outputs
   signal oled_sdin : std_logic;
   signal oled_sclk : std_logic;
   signal oled_dc : std_logic;
   signal oled_res : std_logic;
   signal oled_vbat : std_logic;
   signal oled_vdd : std_logic;
   signal LED : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLOCK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PONG_GAME PORT MAP (
          CLOCK => CLOCK,
          btnr => btnr,
          btnl => btnl,
          btnd => btnd,
          oled_sdin => oled_sdin,
          oled_sclk => oled_sclk,
          oled_dc => oled_dc,
          oled_res => oled_res,
          oled_vbat => oled_vbat,
          oled_vdd => oled_vdd,
          LED => LED
        );

   -- Clock process definitions
   CLOCK_process :process
   begin
		CLOCK <= '0';
		wait for CLOCK_period/2;
		CLOCK <= '1';
		wait for CLOCK_period/2;
   end process;


   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLOCK_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
