----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/27/2024 09:56:53 PM
-- Design Name: 
-- Module Name: frequency_cnt - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity frequency_cnt is
   Port ( clk : in STD_LOGIC;
          reset : in STD_LOGIC;
          SI : in STD_LOGIC;
         
         Ones : out STD_LOGIC_VECTOR (3 downto 0);
         Tens : out STD_LOGIC_VECTOR (3 downto 0);
         Hundreds : out STD_LOGIC_VECTOR (3 downto 0);
         Thousands : out STD_LOGIC_VECTOR (3 downto 0);
         Tens_Thous : out STD_LOGIC_VECTOR (3 downto 0);
         Hund_Thous : out STD_LOGIC_VECTOR (3 downto 0) );

end frequency_cnt;

architecture Behavioral of frequency_cnt is

component DIV_10 
    Port ( 
           CE : in STD_LOGIC;
           RES : in STD_LOGIC;
           OVER_FLOW : out STD_LOGIC:='0';
           Q : out STD_LOGIC_VECTOR (3 downto 0):=X"0");
end component;

component DIV_10K is
    Port ( CLK : in STD_LOGIC;
           RES : in STD_LOGIC;
           OVER_FLOW : out STD_LOGIC:='0');
end component;

component freq_cnt_co is
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
           ERR : out STD_LOGIC;
           Ones : out STD_LOGIC_VECTOR (3 downto 0);
           Tens : out STD_LOGIC_VECTOR (3 downto 0);
           Hundreds : out STD_LOGIC_VECTOR (3 downto 0);
           Thousands : out STD_LOGIC_VECTOR (3 downto 0);
           Tens_Thous : out STD_LOGIC_VECTOR (3 downto 0);
           Hund_Thous : out STD_LOGIC_VECTOR (3 downto 0)
            );
end component;



signal Q1,Q2,Q3,Q4,Q5,Q6 : std_logic_vector (3 downto 0):=X"0";
--signal ones, tens, hundreds,thousands, Tens_Thous, Hund_Thous: std_logic_vector (3 downto 0):=X"0";
signal OF_ones,OF_tens,OF_hundreds,OF_thousands,OF_Ten_Thousands,OF_Hund_Thousands,ERR,LOAD,CE,SI_FF: std_logic:='0';


begin

process(clk,SI,SI_FF)
	begin
		CE<= SI and (not SI_FF);
		if (clk' event and clk ='1') then 
		SI_FF<=SI;
		end if;
end process;

   Delay_Counter: DIV_10K Port map(
       CLK => clk,
       RES=> reset,
       OVER_FLOW => LOAD);
       
   Ones_Counter: DIV_10 Port map(
       CE=> CE,
       RES=> reset,
       OVER_FLOW => OF_ones,
       Q =>  Q1);
       
   Tens_Counter: DIV_10 Port map(
       CE=> OF_ones,
       RES=> reset,
       OVER_FLOW => OF_tens,
       Q =>  Q2);
       
   Hundreds_Counter: DIV_10 Port map(
       CE=> OF_tens,
       RES=> reset,
       OVER_FLOW => OF_hundreds,
       Q =>  Q3);
       
   Thousands_Counter: DIV_10 Port map(
       CE=> OF_hundreds,
       RES=> reset,
       OVER_FLOW => OF_Thousands,
       Q =>  Q4);      
        
   Ten_Thousands_Counter: DIV_10 Port map(
       CE=> OF_Thousands,
       RES=> reset,
       OVER_FLOW => OF_Ten_Thousands,
       Q =>  Q5);   
        
   Hund_Thousands_Counter: DIV_10 Port map(
       CE=> OF_Ten_Thousands,
       RES=> reset,
       OVER_FLOW => OF_Hund_Thousands,
       Q =>  Q6);   
        
   counter_circuit_inst: freq_cnt_co Port map(
       clk => clk,
       RES => reset,
       LOAD => LOAD,
       O_F => OF_Hund_Thousands,
       Q1_in=> Q1,
       Q2_in=> Q2,
       Q3_in=> Q3,
       Q4_in=> Q4,
       Q5_in=> Q5,
       Q6_in=> Q6,
       ERR => ERR,
       Ones => Ones,
       Tens => Tens,
       Hundreds => Hundreds,
       Thousands => Thousands,
       Tens_Thous => Tens_Thous,
       Hund_Thous => Hund_Thous);
           
  
end Behavioral;
