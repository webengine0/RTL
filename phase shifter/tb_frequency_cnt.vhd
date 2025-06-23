----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/28/2024 08:08:37 PM
-- Design Name: 
-- Module Name: tb_frequency_cnt - Behavioral
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

ENTITY tb_frequency_cnt IS
END tb_frequency_cnt;
 
ARCHITECTURE behavior OF tb_frequency_cnt IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT frequency_cnt
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         SI : IN  std_logic;
         Ones : out STD_LOGIC_VECTOR (3 downto 0);
         Tens : out STD_LOGIC_VECTOR (3 downto 0);
         Hundreds : out STD_LOGIC_VECTOR (3 downto 0);
         Thousands : out STD_LOGIC_VECTOR (3 downto 0);
         Tens_Thous : out STD_LOGIC_VECTOR (3 downto 0);
         Hund_Thous : out STD_LOGIC_VECTOR (3 downto 0) 
        );
    END COMPONENT;
    
   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal SI : std_logic := '0';
  

 	--Outputs
 
       signal Ones :  STD_LOGIC_VECTOR (3 downto 0);
       signal  Tens :  STD_LOGIC_VECTOR (3 downto 0);
       signal  Hundreds :  STD_LOGIC_VECTOR (3 downto 0);
       signal  Thousands :  STD_LOGIC_VECTOR (3 downto 0);
       signal  Tens_Thous :  STD_LOGIC_VECTOR (3 downto 0);
       signal  Hund_Thous :  STD_LOGIC_VECTOR (3 downto 0); 

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: frequency_cnt PORT MAP (
          clk => clk,
          reset => reset,
          SI => SI,
   
          Ones => Ones,
          Tens => Tens,
          Hundreds => Hundreds,
          Thousands => Thousands,
          Tens_Thous => Tens_Thous,
          Hund_Thous => Hund_Thous
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Clock process definitions
   SI_process :process
   begin
		SI <= '0';
		wait for 500 ns;
		SI <= '1';
		wait for 500 ns;
   end process;
 

 
END;

