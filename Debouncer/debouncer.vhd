----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/06/2024 09:19:56 PM
-- Design Name: 
-- Module Name: debouncer - Behavioral
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


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;



entity debouncer is generic (
cycles : positive

);

port (

clk : in std_logic; rst : in std_logic;
switch : in std_logic; number_of_switch_debounced : out std_logic
);

end debouncer;


architecture behavior of debouncer is signal debounced : std_logic;
signal counter : integer range 0 to cycles - 1; begin
number_of_switch_debounced <= debounced;
 
DEBOUNCE_PROC : process(clk) begin
if rising_edge(clk) then if rst = '1' then
counter <= 0; debounced <= switch;
else

if counter < cycles - 1 then

counter <= counter + 1; elsif switch /= debounced then
counter <= 0; debounced <= switch;
end if;

end if;

end if; end process; end architecture;
