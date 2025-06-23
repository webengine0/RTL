--------------------------------------------------------------------------------.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Tb IS
END Tb;
 
ARCHITECTURE behavior OF Tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT SPARTAN_3E_TopModule
    PORT(
         CLK_50MHz : IN  std_logic;
         DIP_SWITCH : IN  std_logic_vector(2 downto 0);
         Push_Button_Switch : IN  std_logic_vector(3 downto 0);
         HSync : OUT  std_logic;
         VSync : OUT  std_logic;
         Red : OUT  std_logic;
         Green : OUT  std_logic;
         Blue : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK_50MHz : std_logic := '0';
   signal DIP_SWITCH : std_logic_vector(2 downto 0) := (others => '0');
   signal Push_Button_Switch : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal HSync : std_logic;
   signal VSync : std_logic;
   signal Red : std_logic;
   signal Green : std_logic;
   signal Blue : std_logic;

   -- Clock period definitions
   constant CLK_50MHz_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SPARTAN_3E_TopModule PORT MAP (
          CLK_50MHz => CLK_50MHz,
          DIP_SWITCH => DIP_SWITCH,
          Push_Button_Switch => Push_Button_Switch,
          HSync => HSync,
          VSync => VSync,
          Red => Red,
          Green => Green,
          Blue => Blue
        );

   -- Clock process definitions
   CLK_50MHz_process :process
   begin
		CLK_50MHz <= '0';
		wait for CLK_50MHz_period/2;
		CLK_50MHz <= '1';
		wait for CLK_50MHz_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		DIP_SWITCH<="001";
      wait for 100 ns;	
		DIP_SWITCH<="000";
      wait for CLK_50MHz_period*100;
		Push_Button_Switch<="1000";
      wait for CLK_50MHz_period*100;
		Push_Button_Switch<="0000";
      wait for CLK_50MHz_period*100;
		Push_Button_Switch<="0010";
      wait for CLK_50MHz_period*100;
		Push_Button_Switch<="0000";
		wait for 100 ns;	
		DIP_SWITCH<="010";
      wait for 100 ns;	
		DIP_SWITCH<="000";
		wait for 100 ns;	
		
      wait for CLK_50MHz_period*100;
		Push_Button_Switch<="0001";
      wait for CLK_50MHz_period*100;
		Push_Button_Switch<="0000";
      wait for CLK_50MHz_period*100;
		Push_Button_Switch<="0100";
      wait for CLK_50MHz_period*100;
		Push_Button_Switch<="0000";
		wait for 100 ns;	
		DIP_SWITCH<="100";
      wait for 100 ns;	
		DIP_SWITCH<="000";
		wait for 100 ns;	
		
      -- insert stimulus here 

      wait;
   end process;

END;
