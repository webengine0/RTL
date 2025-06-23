----------------------------------------------------------------------------------

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity PONG_GAME is
port (
CLOCK: in std_logic; -- input CLK
btnr: in std_logic; -- input signals for player 1 
btnl: in std_logic; -- input signals for player 2 
btnd: in std_logic; -- input signals for reset 
btnc: in std_logic; -- input signals for reset 
oled_sdin   : out std_logic;
oled_sclk   : out std_logic;
oled_dc     : out std_logic;
oled_res    : out std_logic;
oled_vbat   : out std_logic;
oled_vdd    : out std_logic;
LED: out std_logic_vector(7 downto 0):=X"00" -- led for pong game 

);
end PONG_GAME;

architecture Behavioral of PONG_GAME is

 -- Component Declaration 

 
 COMPONENT clock_divider
  Port(clk    : in std_logic; -- 1Mhz
       reset  : in std_logic;
       speed  : in std_logic_vector(2 downto 0);
		 window : out std_logic:='0';
		 pre_clock : out std_logic:='0';
		 clock : out std_logic:='0'); --250Hz clock signal
 END COMPONENT;

COMPONENT Debounce 
  Port(clk    : in std_logic; -- 1Mhz
       BTN  : in std_logic;
       BTN_deb  : out std_logic:='0'); 
end COMPONENT;


 COMPONENT oled 
    port (  clk         : in std_logic;
            rst         : in std_logic;
            score1          : in std_logic_vector (3 downto 0); 
            score2          : in std_logic_vector (3 downto 0);
            oled_sdin   : out std_logic;
            oled_sclk   : out std_logic;
            oled_dc     : out std_logic;
            oled_res    : out std_logic;
            oled_vbat   : out std_logic;
            oled_vdd    : out std_logic);
end COMPONENT;

signal player1,player2,reset,slow_clock,direction,window,pre_clock,start: std_logic:='0';
signal speed: std_logic_vector(2 downto 0):="000";
signal Score1,Score2: STD_LOGIC_VECTOR(3 downto 0):="0000";


-- State 
type state_type is (IDLE,S0,S1,S2,S3,S4,S5,S6,S7,start_game2,LOSS,start_game);
signal State,next_state : state_type:=IDLE;

begin

 oled_uut: oled 
   PORT MAP (clk    =>CLOCK,
       rst  =>reset,
       score1  =>Score1,
       score2  =>Score2,
       oled_sdin  =>oled_sdin,		 
       oled_sclk  =>oled_sclk,		 
       oled_dc  =>oled_dc,		 
       oled_res  =>oled_res,		 
       oled_vbat  =>oled_vbat,		 
		 oled_vdd =>oled_vdd
		 ); 

 uut: clock_divider 
   PORT MAP (clk    =>CLOCK,
       reset  =>reset,
       speed  =>speed,
       window  =>window,		 
       pre_clock  =>pre_clock,		 
		 clock =>slow_clock
		 ); 

 uut0: Debounce 
  PORT MAP (clk    =>CLOCK,
       BTN  =>btnr,
       BTN_deb  =>player1
		 ); 
		 
 uut1: Debounce 
  PORT MAP (clk    =>CLOCK,
       BTN  =>btnl,
       BTN_deb  =>player2
		 ); 		 

 uut2: Debounce 
  PORT MAP (clk    =>CLOCK,
       BTN  =>btnd,
       BTN_deb  =>reset
		 ); 
		 
 uut3: Debounce 
  PORT MAP (clk    =>CLOCK,
       BTN  =>btnc,
       BTN_deb  =>start
		 ); 
		 
		 
process (CLOCK,player1,player2,reset,State,next_state,Score2,Score1,window,slow_clock,pre_clock,start)
begin


if (CLOCK'event and  CLOCK='1') then

if (reset='1') then
		State<=IDLE;
elsif (slow_clock='1') then
		State<=next_state;
end if;

end if;

if (CLOCK'event and  CLOCK='1') then

case (State) is

when IDLE=>        --- starting the FSM
		Score2<=X"0";
		Score1<=X"0";
		LED<=X"00";
		speed<="000";
		direction<='0';
		if (reset='1') then
		next_state<=IDLE;
		elsif (start='1') then
		next_state<=start_game;
		end if;
		
when start_game=>        
		LED<=X"80";
		direction<='1';
		next_state<=S6;
		
when start_game2=>        
		LED<=X"01";
		direction<='0';
		next_state<=S1;

when S0=>        
				LED<=X"01";

		if (window='1' and player1='1') then
		next_state<=S1;
		direction<='0';
		elsif (pre_clock='1' and next_state=S0 and score2="0100") then
		next_state<=LOSS;
		elsif (pre_clock='1' and next_state=S0) then
		next_state<=start_game;
		score2<= score2 + '1';
		end if;
				
when S1=>        
		LED<=X"02";
		if (direction='1') then
		next_state<=S0;
		else
		next_state<=S2;
		end if;
		

when S2=>        
		LED<=X"04";
		if (direction='1') then
		next_state<=S1;
		else
		next_state<=S3;
		end if;

when S3=>        
		LED<=X"08";
		if (direction='1') then
		next_state<=S2;
		else
		next_state<=S4;
		end if;
		
when S4=>        
		LED<=X"10";
		if (direction='1') then
		next_state<=S3;
		else
		next_state<=S5;
		end if;
		
when S5=>        
		LED<=X"20";
		if (direction='1') then
		next_state<=S4;
		else
		next_state<=S6;
		end if;
		
when S6=>        
		LED<=X"40";
		if (direction='1') then
		next_state<=S5;
		else
		next_state<=S7;
		end if;
		
when S7=>        
		LED<=X"80";
		if (window='1' and player2='1') then
		next_state<=S6;
		direction<='1';
		speed<= speed + '1';
		elsif (pre_clock='1' and next_state=S7 and score1="0100") then
		next_state<=LOSS;
		elsif (pre_clock='1' and next_state=S7) then
		next_state<=start_game2;
		score1<= score1 + '1';
		end if;
		
when LOSS=>        
		if (direction='1') then
		LED<=X"F0";
		else
		LED<=X"0F";
		end if;
		

when others=>
		next_state<=IDLE;
end case;

end if;
	

end process;

end Behavioral;


