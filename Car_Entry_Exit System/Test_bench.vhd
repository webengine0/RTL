--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Test_bench IS
END Test_bench;
 
ARCHITECTURE behavior OF Test_bench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Car_Entry_Top
    PORT(
         CLOCK : IN  std_logic;
         KEY_0 : IN  std_logic;
         KEY_1 : IN  std_logic;
         KEY_2 : IN  std_logic;
         KEY_3 : IN  std_logic;
         Sensor_1 : IN  std_logic;
         Sensor_2 : IN  std_logic;
         RED_LED : OUT  std_logic;
         GREEN_LED : OUT  std_logic;
         Entry_pass : OUT  std_logic;
         Entry_fail : OUT  std_logic;
         Barrier_status : OUT  std_logic;
         Key_press : OUT  std_logic;
         ACTIVE_KEYPAD : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLOCK : std_logic := '0';
   signal KEY_0 : std_logic := '0';
   signal KEY_1 : std_logic := '0';
   signal KEY_2 : std_logic := '0';
   signal KEY_3 : std_logic := '0';
   signal Sensor_1 : std_logic := '0';
   signal Sensor_2 : std_logic := '0';

 	--Outputs
   signal RED_LED : std_logic;
   signal GREEN_LED : std_logic;
   signal Entry_pass : std_logic;
   signal Entry_fail : std_logic;
   signal Barrier_status : std_logic;
   signal Key_press : std_logic;
   signal ACTIVE_KEYPAD : std_logic;

   -- Clock period definitions
   constant CLOCK_period : time := 2 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Car_Entry_Top PORT MAP (
          CLOCK => CLOCK,
          KEY_0 => KEY_0,
          KEY_1 => KEY_1,
          KEY_2 => KEY_2,
          KEY_3 => KEY_3,
          Sensor_1 => Sensor_1,
          Sensor_2 => Sensor_2,
          RED_LED => RED_LED,
          GREEN_LED => GREEN_LED,
          Entry_pass => Entry_pass,
          Entry_fail => Entry_fail,
          Barrier_status => Barrier_status,
          Key_press => Key_press,
          ACTIVE_KEYPAD => ACTIVE_KEYPAD
        );

   -- Clock process definitions
   CLOCK_process :process
   begin
		CLOCK <= '0';
		wait for CLOCK_period/2;
		CLOCK <= '1';
		wait for CLOCK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 1000 ns.
      wait for 1000 ns;	

      wait for CLOCK_period*100;
		Sensor_1<='1';
      wait for CLOCK_period*100;
		Sensor_1<='0';
      wait for CLOCK_period*100000;
      wait for CLOCK_period*100000;
		Key_1<='1';
      wait for CLOCK_period*100000;
		Key_1<='0';

      wait for CLOCK_period*100000;
		Key_2<='1';
      wait for CLOCK_period*100000;
		Key_2<='0';

      wait for CLOCK_period*1000000;
		Sensor_1<='1';
      wait for CLOCK_period*100;
		Sensor_1<='0';
      wait for CLOCK_period*100000;
      wait for CLOCK_period*100000;
		Key_2<='1';
      wait for CLOCK_period*100000;
		Key_2<='0';
      wait for CLOCK_period*100000;
		Key_3<='1';
      wait for CLOCK_period*100000;
		Key_3<='0';
      wait for CLOCK_period*100000;
		Key_0<='1';
      wait for CLOCK_period*100000;
		Key_0<='0';
      wait for CLOCK_period*100000;
		Key_0<='1';
      wait for CLOCK_period*100000;
		Key_0<='0';

      wait for CLOCK_period*100000;
		Key_3<='1';
      wait for CLOCK_period*100000;
		Key_3<='0';
      wait for CLOCK_period*100000;
		Key_1<='1';
      wait for CLOCK_period*100000;
		Key_1<='0';	

      wait for CLOCK_period*100;
		Sensor_2<='1';
      wait for CLOCK_period*100;
		Sensor_2<='0';
      wait for CLOCK_period*100000;
      wait for CLOCK_period*100000;
		Key_1<='1';
      wait for CLOCK_period*100000;
		Key_1<='0';

      wait for CLOCK_period*100000;
		Key_2<='1';
      wait for CLOCK_period*100000;
		Key_2<='0';

      wait for CLOCK_period*1000000;
		Sensor_2<='1';
      wait for CLOCK_period*100;
		Sensor_2<='0';
      wait for CLOCK_period*100000;
      wait for CLOCK_period*100000;
		Key_2<='1';
      wait for CLOCK_period*100000;
		Key_2<='0';
      wait for CLOCK_period*100000;
		Key_3<='1';
      wait for CLOCK_period*100000;
		Key_3<='0';
      wait for CLOCK_period*100000;
		Key_0<='1';
      wait for CLOCK_period*100000;
		Key_0<='0';
      wait for CLOCK_period*100000;
		Key_0<='1';
      wait for CLOCK_period*100000;
		Key_0<='0';

      wait for CLOCK_period*100000;
		Key_3<='1';
      wait for CLOCK_period*100000;
		Key_3<='0';
      wait for CLOCK_period*100000;
		Key_1<='1';
      wait for CLOCK_period*100000;
		Key_1<='0';

      -- insert stimulus here 

      wait;
   end process;

END;
