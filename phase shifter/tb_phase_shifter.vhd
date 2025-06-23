----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/28/2024 06:54:25 PM
-- Design Name: 
-- Module Name: tb_phase_shifter - Behavioral
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


ENTITY tb_phase_shifter IS
END tb_phase_shifter;
 
ARCHITECTURE behavior OF tb_phase_shifter IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Phase_Shifter
    PORT(
         CLK : IN  std_logic;
         RES : IN  std_logic;
         SI : IN  std_logic;
         PHI_0 : OUT  std_logic;
         PHI_90 : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RES : std_logic := '0';
   signal SI : std_logic := '0';

 	--Outputs
   signal PHI_0 : std_logic;
   signal PHI_90 : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Phase_Shifter PORT MAP (
          CLK => CLK,
          RES => RES,
          SI => SI,
          PHI_0 => PHI_0,
          PHI_90 => PHI_90
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 
   SI_process :process
   begin
		SI <= '0';
		wait for 500 ns;
		SI <= '1';
		wait for 500 ns;
   end process;
  
  

END;

