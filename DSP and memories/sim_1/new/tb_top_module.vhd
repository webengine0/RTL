----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/29/2024 02:36:11 PM
-- Design Name: 
-- Module Name: tb_top_module - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_top_module is
--  Port ( );
end tb_top_module;

architecture Behavioral of tb_top_module is

    COMPONENT top_module
    PORT(
         CLK : IN  std_logic;
         start : IN  std_logic;
         reset : IN  std_logic;
         read_addr_in0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
         read_addr_in1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
         write_addr_in0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
         write_addr_in1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal start : std_logic := '0';
   signal reset : std_logic := '0';
   signal  read_addr_in0 :  STD_LOGIC_VECTOR(7 DOWNTO 0) := x"00";
   signal     read_addr_in1 :  STD_LOGIC_VECTOR(7 DOWNTO 0) := x"00";
   signal    write_addr_in0 :  STD_LOGIC_VECTOR(7 DOWNTO 0) := x"00";
   signal    write_addr_in1 :  STD_LOGIC_VECTOR(7 DOWNTO 0) := x"00";


   -- Clock period definitions
   constant CLK_period : time := 8 ns;
 
BEGIN
 
   uut: top_module PORT MAP (
          CLK => CLK,
          start => start,
          reset => reset,
          read_addr_in0 => read_addr_in0,
          read_addr_in1 => read_addr_in1,
          write_addr_in0 => write_addr_in0,
          write_addr_in1  => write_addr_in1

        );

   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin	
   	
        reset <= '1';
        wait for 10 ns;
         reset <= '0';
          wait for 400 ns;
        start <= '1';
        read_addr_in0 <=  "00000011";  
        read_addr_in1 <=  "00000100"; 
        write_addr_in0 <=  "00001001";
        write_addr_in1 <= "00001010";
        wait for 100 ns;	
        start <= '0';

      -- insert stimulus here 

      wait;
   end process;

END;
