----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/28/2024 06:47:31 PM
-- Design Name: 
-- Module Name: freq_cnt_co - Behavioral
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

entity freq_cnt_co is
    Port ( clk : in STD_LOGIC;
           LOAD : in STD_LOGIC;
           RES : in STD_LOGIC;
           O_F : in STD_LOGIC;
           Q1_in : in STD_LOGIC_VECTOR (3 downto 0);
           Q2_in : in STD_LOGIC_VECTOR (3 downto 0);
           Q3_in : in STD_LOGIC_VECTOR (3 downto 0);
           Q4_in : in STD_LOGIC_VECTOR (3 downto 0);
           Q5_in : in STD_LOGIC_VECTOR (3 downto 0);
           Q6_in : in STD_LOGIC_VECTOR (3 downto 0);
            ERR : out STD_LOGIC:='0';
            Ones : out STD_LOGIC_VECTOR (3 downto 0):=X"0";
            Tens : out STD_LOGIC_VECTOR (3 downto 0):=X"0";
            Hundreds : out STD_LOGIC_VECTOR (3 downto 0):=X"0";
            Thousands : out STD_LOGIC_VECTOR (3 downto 0):=X"0";
            Tens_Thous : out STD_LOGIC_VECTOR (3 downto 0):=X"0";
            Hund_Thous : out STD_LOGIC_VECTOR (3 downto 0):=X"0");
end freq_cnt_co;

architecture Behavioral of freq_cnt_co is

begin
process(clk,LOAD,RES)
	begin
		
		if (clk' event and clk ='1') then 
            
            if (RES='1') then
            Ones <=X"0";
            Tens <=X"0";
            Hundreds <=X"0";
            Thousands <=X"0";
            Tens_Thous <=X"0";
            Hund_Thous <=X"0";
            ERR<='0';
            elsif (LOAD='1')  then
            Ones <=Q1_in;
            Tens <=Q2_in;
            Hundreds <=Q3_in;
            Thousands <=Q4_in;
            Tens_Thous <=Q5_in;
            Hund_Thous <=Q6_in;
				ERR<=O_F;
            end if;
       end if;
	
end process;		


end Behavioral;

