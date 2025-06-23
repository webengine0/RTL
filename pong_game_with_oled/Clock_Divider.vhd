library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clock_divider is
  Port(clk    : in std_logic; -- 100Mhz
       reset  : in std_logic;
       speed  : in std_logic_Vector (2 downto 0);
		 window : out std_logic:='0';
		 pre_clock : out std_logic:='0';
		 clock : out std_logic:='0');
end clock_divider;

architecture Behavioral of clock_divider is
begin
--2MHz clock signal
  clk_1kHz : process(clk, reset)	 
	 variable a1: integer range 0 to 200000000;	  
	 begin
      if(reset ='1') then 
		  a1:= 0;
		  clock <= '0';
      elsif(clk'event and clk = '1') then 
			if (speed="000") then
				
				if(a1 > 500_000 and a1 < 195_000_000 ) then 
				window<='1';
				else
				window<='0';
				end if;
				
				if(a1 = 200_000_000 -2 ) then 
				pre_clock<='1';
				else
				pre_clock<='0';
				end if;
				
				if(a1 = 200_000_000 -1 ) then 
					a1:= 0;
					clock <= '1';
				else
					a1 := a1 + 1;
					clock <= '0';
				end if;
			elsif (speed="001") then
			
				if(a1 > 500_000  and a1 < 149_000_000  ) then 
				window<='1';
				else
				window<='0';
				end if;
				
				if(a1 = 150_000_000 -2 ) then 
				pre_clock<='1';
				else
				pre_clock<='0';
				end if;
			
				if(a1 = 150_000_000 -1 ) then 
					a1:= 0;
					clock <= '1';
				else
					a1 := a1 + 1;
					clock <= '0';
				end if;
			elsif (speed="010") then
			
				if(a1 > 500_000and a1 < 99_000_000 ) then 
				window<='1';
				else
				window<='0';
				end if;
				
				if(a1 = 100_000_000 -2 ) then 
				pre_clock<='1';
				else
				pre_clock<='0';
				end if;
			
				if(a1 = 100_000_000 -1 ) then 
					a1:= 0;
					clock <= '1';
				else
					a1 := a1 + 1;
					clock <= '0';
				end if;
			elsif (speed="100") then
			
			if(a1 > 500_000 and a1 < 70_000_000 ) then 
				window<='1';
				else
				window<='0';
				end if;
				
				if(a1 = 75_000_000 -2 ) then 
				pre_clock<='1';
				else
				pre_clock<='0';
				end if;
				
				if(a1 = 75_000_000 -1 ) then 
					a1:= 0;
					clock <= '1';
				else
					a1 := a1 + 1;
					clock <= '0';
				end if;
			elsif (speed="101") then
			
			if(a1 > 500_000 and a1 < 45_000_000 ) then 
				window<='1';
				else
				window<='0';
				end if;
			
				if(a1 = 50_000_000 -2 ) then 
				pre_clock<='1';
				else
				pre_clock<='0';
				end if;
				
				if(a1 = 50_000_000 -1 ) then 
					a1:= 0;
					clock <= '1';
				else
					a1 := a1 + 1;
					clock <= '0';
				end if;
			else	
				
				if(a1 > 500_000 and a1 < 24_000_000 ) then 
				window<='1';
				else
				window<='0';
				end if;
				
				
				if(a1 = 25_000_000 -2 ) then 
				pre_clock<='1';
				else
				pre_clock<='0';
				end if;
				
				
				if(a1 = 25_000_000 - 1 ) then 
					a1:= 0;
					clock <= '1';
				else
					a1 := a1 + 1;
					clock <= '0';
				end if;
			end if;
		end if;

	   
   end process;
end Behavioral;


