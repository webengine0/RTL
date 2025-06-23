----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/27/2024 09:05:57 PM
-- Design Name: 
-- Module Name: tb_SYNC - Behavioral
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

entity tb_SYNC is
--  Port ( );
end tb_SYNC;

architecture Behavioral of tb_SYNC is
    component SYNC
        port (
          CLK: in std_logic;
          RES: in std_logic;
          SENSOR_IN: in std_logic;
          SYNC_out: out std_logic 
        );
    end component;
    
    --Inputs
       signal CLK : std_logic := '0';
       signal RES : std_logic := '0';
       signal SENSOR_IN : std_logic := '0';
       
    
         --Outputs
       signal SYNC_out : std_logic;
     -- Clock period definitions
       constant clk_period : time := 10 ns;
begin
         uut: SYNC PORT MAP (
         CLK => CLK,
         SENSOR_IN => SENSOR_IN,
         RES => RES,
         SYNC_OUT => SYNC_OUT
       );

  -- Clock process definitions
  clk_process :process
  begin
       CLK <= '0';
       wait for clk_period/2;
       CLK <= '1';
       wait for clk_period/2;
  end process;


  -- Stimulus process
  stim_proc: process
  begin        
     
     wait for 150 ns;    
       RES<='1';
     wait for clk_period*10;
       RES<='0';
       SENSOR_IN<='1';
     wait for clk_period*10;
       SENSOR_IN<='0';
     wait for clk_period*10;
       SENSOR_IN<='1';
     wait for clk_period*10;
       SENSOR_IN<='0';
  

     wait;
  end process;

end Behavioral;
