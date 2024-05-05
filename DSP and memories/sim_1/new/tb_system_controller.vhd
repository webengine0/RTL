
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY tb_system_controller IS
END tb_system_controller;
 
ARCHITECTURE behavior OF tb_system_controller IS 
 
    
 
    COMPONENT system_controller
    PORT(
         CLK : IN  std_logic;
         start : IN  std_logic
--         P : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal start : std_logic := '0';

 	--Outputs
--   signal A : std_logic_vector(15 downto 0);
--   signal B : std_logic_vector(15 downto 0);
--   signal P : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 8 ns;
 
BEGIN
 
   uut: system_controller PORT MAP (
          CLK => CLK,
          start => start
--          P => P
--          B => B
        );

   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
   
   
        start <= '1';
        wait for 120 ns;	
        start <= '0';

      -- insert stimulus here 

      wait;
   end process;

END;
