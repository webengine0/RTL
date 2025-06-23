----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Car_Entry_Top is
port (
CLOCK: in std_logic; -- input CLK
KEY_0,KEY_1,KEY_2,KEY_3: in std_logic; -- input Push buttons
Sensor_1,Sensor_2: in std_logic; -- input Switches for sensors
RED_LED,GREEN_LED: out std_logic:='0'; -- LED for Stop and Go
Entry_pass, Entry_fail: out std_logic:='0'; -- Sequence indication for correct sequence and wrong seq
Barrier_status,Key_press,ACTIVE_KEYPAD: out std_logic:='0' -- Sequence indication for correct sequence and wrong seq
);
end Car_Entry_Top;

architecture Behavioral of Car_Entry_Top is
signal KEY0_PRESS,KEY1_PRESS,KEY2_PRESS,KEY3_PRESS: STD_LOGIC:='0';
signal KEY0_REG,KEY1_REG,KEY2_REG,KEY3_REG: STD_LOGIC_VECTOR(11 downto 0):=X"000";
signal Counter: STD_LOGIC_VECTOR(27 downto 0):=X"0000000";

-- State 
type state_type is (IDLE_STATE,CAR_REACH,PWD_ENTER0,PWD_ENTER1,
						  PWD_ENTER2,PWD_ENTER3,PWD_ENTER4,PWD_ENTER5,
						  CORRECT_PWD,WRONG_PWD, BARRIER_UP,WAIT_STATE );
signal State,Next_State : state_type:=IDLE_STATE;

begin

process (CLOCK,KEY_0,KEY_1,KEY_2,KEY_3,Sensor_1,Sensor_2,State,Next_State,Counter)
begin


if (CLOCK'event and  CLOCK='1') then			
KEY0_REG<=KEY0_REG(10 downto 0) & KEY_0;
KEY1_REG<=KEY1_REG(10 downto 0) & KEY_1;
KEY2_REG<=KEY2_REG(10 downto 0) & KEY_2;
KEY3_REG<=KEY3_REG(10 downto 0) & KEY_3;
end if;

if (CLOCK'event and  CLOCK='1') then
if (KEY0_REG=X"0FF")		then 	KEY0_PRESS<='1'; else 	KEY0_PRESS<='0'; end if;
if (KEY1_REG=X"0FF")		then 	KEY1_PRESS<='1'; else 	KEY1_PRESS<='0'; end if;
if (KEY2_REG=X"0FF")		then 	KEY2_PRESS<='1'; else 	KEY2_PRESS<='0'; end if;
if (KEY3_REG=X"0FF")		then 	KEY3_PRESS<='1'; else 	KEY3_PRESS<='0'; end if;
end if;

if (CLOCK'event and  CLOCK='1') then
case (State) is

when IDLE_STATE=>        --- starting the FSM
		RED_LED<='1';
		GREEN_LED<='0';
		Entry_pass<='0';
		Entry_fail<='0';
		Barrier_status<='0';
		ACTIVE_KEYPAD<='0';
		Key_press<='0';
		if (Sensor_1='1' and Sensor_2='1') then
		Next_State<=IDLE_STATE;
		elsif (Sensor_1='1') then 
		Next_State<=CAR_REACH;
		State<=WAIT_STATE;
		elsif (Sensor_2='1') then 
		Next_State<=CAR_REACH;	
		State<=WAIT_STATE;
		else 
		Next_State<=IDLE_STATE;
		end if;
		
when CAR_REACH=>        
		RED_LED<='0';
		GREEN_LED<='0';
		Entry_pass<='0';
		Entry_fail<='0';
		Barrier_status<='0';
		ACTIVE_KEYPAD<='1';
		Key_press<='0';
		Next_State<=PWD_ENTER0;
		State<=WAIT_STATE;
		
when PWD_ENTER0=>
		RED_LED<='0';
		GREEN_LED<='0';
		Entry_pass<='0';
		Entry_fail<='0';
		Barrier_status<='0';
		ACTIVE_KEYPAD<='1';
		if (KEY2_PRESS='1') then 
		Next_State<=PWD_ENTER1;
		State<=WAIT_STATE;
		Key_press<='1';
		elsif (KEY0_PRESS='1' or KEY1_PRESS='1' or KEY3_PRESS='1') then
		Next_State<=WRONG_PWD;
		State<=WAIT_STATE;
		Key_press<='1';
		else
		Key_press<='0';
		Next_State<=PWD_ENTER0;
		end if;
		
when PWD_ENTER1=>

		if (KEY3_PRESS='1') then 
		Next_State<=PWD_ENTER2;
		State<=WAIT_STATE;
		Key_press<='1';
		elsif (KEY0_PRESS='1' or KEY1_PRESS='1' or KEY2_PRESS='1') then
		Next_State<=WRONG_PWD;
		State<=WAIT_STATE;
		Key_press<='1';
		else
		Key_press<='0';
		Next_State<=PWD_ENTER1;
		end if;
		
when PWD_ENTER2=>

		if (KEY0_PRESS='1') then 
		Next_State<=PWD_ENTER3;
		State<=WAIT_STATE;
		Key_press<='1';
		elsif (KEY3_PRESS='1' or KEY1_PRESS='1' or KEY2_PRESS='1') then
		Next_State<=WRONG_PWD;
		State<=WAIT_STATE;
		Key_press<='1';
		else
		Key_press<='0';
		Next_State<=PWD_ENTER2;
		end if;
		
when PWD_ENTER3=>

		if (KEY0_PRESS='1') then 
		Next_State<=PWD_ENTER4;
		State<=WAIT_STATE;
		Key_press<='1';
		elsif (KEY3_PRESS='1' or KEY1_PRESS='1' or KEY2_PRESS='1') then
		Next_State<=WRONG_PWD;
		State<=WAIT_STATE;
		Key_press<='1';
		else
		Key_press<='0';
		Next_State<=PWD_ENTER3;
		end if;
		
when PWD_ENTER4=>

		if (KEY3_PRESS='1') then 
		Next_State<=PWD_ENTER5;
		State<=WAIT_STATE;
		Key_press<='1';
		elsif (KEY0_PRESS='1' or KEY1_PRESS='1' or KEY2_PRESS='1') then
		Next_State<=WRONG_PWD;
		State<=WAIT_STATE;
		Key_press<='1';
		else
		Key_press<='0';
		Next_State<=PWD_ENTER4;
		end if;
		
when PWD_ENTER5=>

		if (KEY1_PRESS='1') then 
		Next_State<=CORRECT_PWD;
		State<=WAIT_STATE;
		Key_press<='1';
		elsif (KEY3_PRESS='1' or KEY0_PRESS='1' or KEY2_PRESS='1') then
		Next_State<=WRONG_PWD;
		State<=WAIT_STATE;
		Key_press<='1';
		else
		Key_press<='0';
		Next_State<=PWD_ENTER4;
		end if;

when CORRECT_PWD=>        
		RED_LED<='0';
		GREEN_LED<='0';
		Entry_pass<='1';
		Entry_fail<='0';
		Barrier_status<='0';
		ACTIVE_KEYPAD<='0';
		Key_press<='0';
		Next_State<=BARRIER_UP;
		State<=WAIT_STATE;

when WRONG_PWD=>        
		RED_LED<='0';
		GREEN_LED<='0';
		Entry_pass<='0';
		Entry_fail<='1';
		Barrier_status<='0';
		ACTIVE_KEYPAD<='0';
		Key_press<='0';
		Next_State<=IDLE_STATE;
		State<=WAIT_STATE;

when BARRIER_UP=>        
		RED_LED<='0';
		GREEN_LED<='1';
		Entry_pass<='0';
		Entry_fail<='0';
		Barrier_status<='1';
		ACTIVE_KEYPAD<='0';
		Key_press<='0';
		Next_State<=IDLE_STATE;
		State<=WAIT_STATE;

when WAIT_STATE=>        
	--	if (Counter<X"5F5E0FF") then -- Hardware 
		if (Counter<X"FFFF") then --Simulation
		Counter<=Counter + '1';
		else 
		Counter<=X"0000000";
		State<=Next_State;
		end if;


when others=>
		State<=IDLE_STATE;
end case;
end if;
end process;

end Behavioral;
