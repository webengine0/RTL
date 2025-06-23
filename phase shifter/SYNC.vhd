----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/27/2024 08:58:07 PM
-- Design Name: 
-- Module Name: SYNC - Behavioral
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

entity SYNC is
  Port ( 
  CLK: in std_logic;
  RES: in std_logic;
  SENSOR_IN: in std_logic;
  SYNC_out: out std_logic 
  );
end SYNC;

architecture Behavioral of SYNC is
signal Q_int : std_logic;
begin
     process(CLK,RES)
     begin
     if(rising_edge(CLK)) then
        if(RES='1') then
            Q_int <= '0';
            SYNC_OUT <= '0';
        else
            Q_int <= SENSOR_IN;
            SYNC_OUT <= Q_int;
        end if;
     
     end if;
     end process;

end Behavioral;
