----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity Debounce is
  Port(clk    : in std_logic; -- 1Mhz
       BTN  : in std_logic;
       BTN_deb  : out std_logic:='0'); 
end Debounce;

architecture Behavioral of Debounce is

signal Count : std_logic_vector (11 downto 0);


begin

process (clk,BTN)
begin

if (clk'event and  clk='1') then
		Count<=Count(10 downto 0) & BTN;

	if (Count=X"00F") then

			BTN_deb<='1';

			else
			BTN_deb<='0';

		end if;
end if;

end process;
end Behavioral;

