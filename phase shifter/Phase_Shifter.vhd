----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/28/2024 06:51:11 PM
-- Design Name: 
-- Module Name: Phase_Shifter - Behavioral
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



entity Phase_Shifter is
port (
CLK : in std_logic;
RES : in std_logic;
SI : in std_logic;

PHI_0 : out STD_LOGIC:='0';
PHI_90 : out STD_LOGIC:='0'
);
end Phase_Shifter;

architecture Behavioral of Phase_Shifter is
SIGNAL CEA,CEB,TOGGLE,TCU1,TCU2     : std_logic:='0'; 
SIGNAL COUNTERA,COUNTERB     : std_logic_vector(15 downto 0):=X"0000"; 

begin

	
process(clk)
begin

		TOGGLE<=not clk;

		if (CEA='1' and SI='1' and clk ='1') then
				if (COUNTERA=X"FFFF") then 
				COUNTERA<=COUNTERA;
				else
				COUNTERA<=COUNTERA + '1';
				end if;
		elsif (CEA='1') then
				if (COUNTERA=X"0000") then 
				COUNTERA<=COUNTERA;
				else
				COUNTERA<=COUNTERA - '1';
				end if;
		end if;
	
		if (CEB='1' and SI='1') then
				if (COUNTERB=X"0000") then 
				COUNTERB<=COUNTERB;
				else
				COUNTERB<=COUNTERB - '1';
				end if;
		elsif (CEB='1' and clk ='1') then
				if (COUNTERB=X"FFFF") then 
				COUNTERB<=COUNTERB;
				else
				COUNTERB<=COUNTERB + '1';
				end if;
				
		end if;
	end process;
	
process(clk,SI,RES,CEA,CEB,COUNTERA,COUNTERB,TOGGLE,TCU1,TCU2)
	begin
	
	if (COUNTERA=X"0000" and (SI='0')) then
		TCU1<='1';
	else
		TCU1<='0';
	end if;
	
	if (COUNTERB=X"0000" and (SI='1')) then
		TCU2<='1';
	else
		TCU2<='0';
	end if;
	
	CEA<=( SI and TOGGLE ) or (not (SI));
	CEB<=( (not SI) and TOGGLE ) or ( SI);
	
		if (RES='1') then
			PHI_0  <= '0';
			PHI_90 <= '0';
		else
			PHI_0  <=  SI;
			PHI_90 <= (TCU1 or TCU2) xnor SI;
		end if;

end process;

end Behavioral;

