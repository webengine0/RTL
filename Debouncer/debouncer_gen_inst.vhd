----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/06/2024 09:24:18 PM
-- Design Name: 
-- Module Name: debouncer_gen_inst - Behavioral
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



entity debouncer_gen_inst is generic (
count : positive :=4;
cycles : positive :=4
 
);

port (
clk : in std_logic; rst : in std_logic;
switch : in std_logic_vector(count - 1 downto 0);
number_of_switch_debounced : out std_logic_vector(count - 1 downto 0)
);

end debouncer_gen_inst;


architecture behavior of debouncer_gen_inst is begin
gen_debouncer : for i in 0 to count - 1 generate
DEBOUNCER_INST : entity work.debouncer(behavior) generic map (
cycles => cycles
)

port map ( 
clk => clk,
rst => rst,
switch => switch(i),
number_of_switch_debounced => number_of_switch_debounced(i)

);

end generate;
 end architecture;
