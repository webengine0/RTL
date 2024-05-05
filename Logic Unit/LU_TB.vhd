----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/26/2024 04:15:49 PM
-- Design Name: 
-- Module Name: LU_TB - Behavioral
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

ENTITY LU_TB IS
END LU_TB;
 
ARCHITECTURE behavior OF LU_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT LU
    PORT(
         CLK : IN  std_logic;    -- System Clock
         RES : IN  std_logic;      -- Master Reset (sync or async)
         A : IN  std_logic_vector(7 downto 0);   --A input bus
         B : IN  std_logic_vector(7 downto 0);  --B input bus
         OPCODE : IN  std_logic_vector(2 downto 0);  -- Logic Unit Opcode
         Q : OUT  std_logic_vector(7 downto 0)   -- Q output from Logic Unit 
        );
    END COMPONENT;
    
-- signal declarations 
   --Inputs
   signal CLK : std_logic := '0';
   signal RES : std_logic := '0';
   signal A : std_logic_vector(7 downto 0) := (others => '0');
   signal B : std_logic_vector(7 downto 0) := (others => '0');
   signal OPCODE : std_logic_vector(2 downto 0) := (others => '0');

 	--Outputs
   signal Q : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;  --100Mhz clock is generated
 
BEGIN

	-- Instantiate the Unit Under Test (UUT)
   uut: LU PORT MAP (
          CLK => CLK,
          RES => RES,
          A => A,
          B => B,
          OPCODE => OPCODE,
          Q => Q
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process  -- This process is used to generate/apply the rest of the inputs
   begin		
			A <= "10110011";
         B <= "11001001";
			wait for 20 ns;
         RES <= '0';
			wait for 20 ns;
         OPCODE <= "001";
			wait for 20 ns;
         OPCODE <= "010";
			wait for 20 ns;
			OPCODE <= "011";
			wait for 20 ns;
         OPCODE <= "100";
			wait for 20 ns;
         OPCODE <= "101";
			wait for 20 ns;
			OPCODE <= "110"; 
			wait for 20 ns;
			OPCODE <= "111";
			wait for 20 ns;	
			
      wait; -- will wait forever (if you remove this statement, the process will just repeat/loop and the same inputs re-applied)


   end process;

END;
