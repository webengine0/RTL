----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/27/2024 10:18:16 PM
-- Design Name: 
-- Module Name: DIV_10k - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;



entity DIV_10k is
    Port ( CLK : in STD_LOGIC;
           RES : in STD_LOGIC;
           OVER_FLOW : out STD_LOGIC:='0');
           end DIV_10k;
architecture Behavioral of DIV_10k is

signal  count: STD_LOGIC_VECTOR(15 downto 0):=X"0000";
constant  count_max: STD_LOGIC_VECTOR(15 downto 0):=X"C350"; -- for simulation
begin
process(CLK,RES,count)
	begin
		if (rising_edge(CLK)) then 
            
            if (RES='1') then
            count<=X"0000";
            OVER_FLOW<='0';
            elsif (count = count_max-'1') then
            count<=X"0000";
            OVER_FLOW<='1';
            else
            count<=count + '1';
            OVER_FLOW<='0';
            end if;
       end if;
	
end process;		
end Behavioral;
