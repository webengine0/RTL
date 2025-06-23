----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/27/2024 08:26:37 PM
-- Design Name: 
-- Module Name: clk_div - Behavioral
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

entity clk_div is
  Port ( 
        MCLK : in std_logic; --input mclk
        CLK : out std_logic --output clk (mclk/2)
            );
 
end clk_div;
   
architecture Behavioral of clk_div is
 signal count: std_logic_vector(1 downto 0) := "00";
begin
    process(MCLK)
    begin
    if(rising_edge (MCLK))then
        count <= count + 1;
    end if;
    end process;
    CLK <= count(0); 
    

end Behavioral;
