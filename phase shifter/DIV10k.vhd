----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/27/2024 10:01:02 PM
-- Design Name: 
-- Module Name: DIV10K - Behavioral
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

entity Div10K is
    Port ( CLK : in STD_LOGIC;
           RES : in STD_LOGIC;
           O_F : out STD_LOGIC:='0');
           end Div50K;

architecture Behavioral of Div50K is

signal  counter: STD_LOGIC_VECTOR(15 downto 0):=X"0000";
constant  counter_max: STD_LOGIC_VECTOR(15 downto 0):=X"C350"; -- for simulation
begin
process(clk,RES,counter)
	begin
		if (clk' event and clk ='1') then 
            
            if (RES='1') then
            counter<=X"0000";
            O_F<='0';
            elsif (counter = counter_max-'1') then
            counter<=X"0000";
            O_F<='1';
            else
            counter<=counter + '1';
            O_F<='0';
            end if;
       end if;
	
end process;		
end Behavioral;

