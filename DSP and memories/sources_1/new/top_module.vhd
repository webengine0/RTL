----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/29/2024 02:12:21 PM
-- Design Name: 
-- Module Name: top_module - Behavioral
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

entity top_module is

  Port (
   CLK : IN STD_LOGIC; --external 125Mhz clock 
   start : IN STD_LOGIC;  --start is used to start the operations in system_controller
   reset : IN STD_LOGIC;  --Reset is used for reset a clock wizard 
   read_addr_in0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
   read_addr_in1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
   write_addr_in0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
   write_addr_in1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
 );
end top_module;

architecture Behavioral of top_module is

COMPONENT clk_wiz_0    --component declaration of clock
  PORT (
    clk_in : IN STD_LOGIC;
    reset : IN STD_LOGIC;
    locked : OUT STD_LOGIC;
    clk_out : OUT STD_LOGIC
  
  );
END COMPONENT;

COMPONENT system_controller   --component declaration of system_controller
  PORT (
    CLK : IN STD_LOGIC;
    start : IN STD_LOGIC;
    read_addr_in0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0):= x"00";
    read_addr_in1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0) :=x"00";
    write_addr_in0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0):=x"00";
    write_addr_in1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0):=x"00"
  );
END COMPONENT;

signal clk_out,locked :std_logic;
begin
   clk_mod : clk_wiz_0  --initialization of clock wizard
     PORT MAP (
     clk_in => CLK,
     reset => reset,
    locked => locked,
     clk_out => clk_out
);  
 sys_cont_mod : system_controller  ----initialization of system_controller
     PORT MAP (
     CLK => clk_out,
     start => start,
     read_addr_in0 => read_addr_in0,
     read_addr_in1 => read_addr_in1,
     write_addr_in0 => write_addr_in0,
     write_addr_in1 => write_addr_in1
    
);



end Behavioral;
