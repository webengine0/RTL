----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/26/2024 04:08:30 PM
-- Design Name: 
-- Module Name: LU - Behavioral
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

entity LU is  --entity logic unit define
   port (

	 CLK: in STD_LOGIC;   --Input clock
	 RES: in STD_LOGIC;   --Input rst
    A,B: in STD_LOGIC_VECTOR (7 downto 0); --Input two 8 bit operand
    OPCODE: in STD_LOGIC_VECTOR (2 downto 0); --Input opcode for Logic Unit 
    Q: out STD_LOGIC_VECTOR (7 downto 0)  --Output from 8 bit register
  
    
);

end LU;

architecture Behavioral of LU is

signal QA: std_logic_vector (7 downto 0); -- Internal signal to store intermediate result
begin
    process(A,B,OPCODE)
    begin
    case(OPCODE) is   --selection of opcode logic functions
    when "000" =>
            QA <= (not(A) or B);
    when "001" =>
            QA <= not(A xor B);
	 when "010" =>
            QA <= not B;
    when "011" =>
            QA <= B and "00110011";
    when "100" =>
            QA <= A;
    when "101" =>
            QA <= (not(A) xnor B);
    when "110" =>
            QA <= not (A and B); 
    when "111" =>
            QA <= not A;

    when others =>
            QA <= x"ff"; -- Default assignment for unknown opcode
end case;
end process;

	process (CLK) --sensitivity to the falling edge of clock
	begin
	if falling_edge(CLK) then
		if RES = '1' then --synchronous reset
		Q <= x"00";
		else
		Q <= QA;  --synchronous assignment
		end if;
	end if;
	end process;


end Behavioral;