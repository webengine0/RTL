----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/27/2024 08:37:28 PM
-- Design Name: 
-- Module Name: tb_clk_div - Behavioral
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

entity tb_clk_div is
--  Port ( );
end tb_clk_div;

architecture Behavioral of tb_clk_div is
component clk_div
        Port ( MCLK : in STD_LOGIC;
               CLK : out STD_LOGIC);
    end component;

    -- Signals for interfacing with the UUT
    signal MCLK : STD_LOGIC := '0';
    signal CLK : STD_LOGIC;

    -- Clock period definitions
    constant clk_period : time := 10 ns;
begin
     uut: clk_div Port map (
         MCLK => MCLK,
         CLK => CLK
       );
-- Clock generation process
           mclk_process :process
           begin
               MCLK <= '0';
               wait for clk_period/2;
               MCLK <= '1';
               wait for clk_period/2;
           end process;
       
     
end Behavioral;
