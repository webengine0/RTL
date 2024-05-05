----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/28/2024 02:33:29 PM
-- Design Name: 
-- Module Name: system_controller - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity system_controller is

  Port ( 
      CLK : IN STD_LOGIC;
      start : IN STD_LOGIC;
      read_addr_in0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      read_addr_in1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      write_addr_in0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      write_addr_in1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
        
  );
end system_controller;

architecture Behavioral of system_controller is

COMPONENT dsp0  --component declaration of dsp
  PORT (
     CLK : IN STD_LOGIC;
    CE : IN STD_LOGIC;
    A : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    B : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    P : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;


COMPONENT memory0  --component declaration of memory A
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    clkb : IN STD_LOGIC;
    enb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT;

COMPONENT memory1  --component declaration of memory B
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    clkb : IN STD_LOGIC;
    enb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT;
--All signals initialization using in state machine
  type state_type is (IDLE, READ_MEM, READ_MEM1,PROCESS_MEM, WRITE_MEM,READ_MEM_again,READ_MEM1_again);
  signal state : state_type := IDLE;  --state for FSM
  signal enb_store_0,enb_store_1,CE: std_logic := '0'; --CE for Dsp block enabling
  signal read_addr_0:std_logic_vector(7 downto 0) :=x"00"; --read paramter A from address
  signal read_addr_1:std_logic_vector(7 downto 0) :=x"00";  --read paramter B from address
  signal write_addr_0:std_logic_vector(7 downto 0):=x"00"; --write result from dsp 31 to 16 bits in address
  signal write_addr_1:std_logic_vector(7 downto 0):=x"00";  --write result from dsp 15 to 0 bits in address
  signal count:std_logic_vector(7 downto 0);
  signal dout_memA:std_logic_vector(15 downto 0);  
  signal dout_memB:std_logic_vector(15 downto 0);
  signal d_A,d_B:std_logic_vector(15 downto 0) :=x"0000";  -- Read data A and B and store in registers
  signal din_A,din_B:std_logic_vector(15 downto 0) :=x"0000";
  signal P:std_logic_vector(31 downto 0);  --product from dsp
  signal mem_wea:std_logic_vector(0 downto 0);
  
  
begin

 process(CLK)  --process complete state machine sequentially
  begin
    if rising_edge(CLK) then
      -- State machine logic
      case state is      --state machine
        when IDLE =>
            CE <= '0';
            count <= x"00";
            mem_wea <= "0";
          -- Wait for rising edge of CLK to start
          if start = '1' then  -- Start enables to read data from address for dsp block
            state <= READ_MEM;
            read_addr_0 <= "00000000";
            read_addr_1 <= "00000000";
            write_addr_0 <= "00000000";
            write_addr_1 <= "00000000"; 
--             read_addr_0 <= read_addr_in0;
--            read_addr_1 <= read_addr_in1;
--            write_addr_0 <= write_addr_in0;
--            write_addr_1 <= write_addr_in1;
          end if;
         when READ_MEM =>   -- address for reading data A and B
              enb_store_0 <= '1';
              enb_store_1 <= '1';
--              read_addr_0 <=  "00000011";  
--              read_addr_1 <=  "00000100"; 
              read_addr_0 <=  read_addr_in0;  
              read_addr_1 <=  read_addr_in1;
              state <= READ_MEM1;
  
          when READ_MEM1 =>   -- Read data A and B and store in registers
               d_A <= dout_memA;
               d_B <= dout_memB;
                if start = '0' then
                    state <= PROCESS_MEM;
                     enb_store_0 <= '0';
                     enb_store_1 <= '0';
                end if;
             when PROCESS_MEM =>  --Process data in dsp
                 CE <= '1';
                 count <= count + '1';
                 if count = x"05" then
                    state <= WRITE_MEM;
                    mem_wea <= "1";
                    count <= x"00";
                end if; 
                
              when WRITE_MEM =>  --Write product data from dsp on address given below
--                 write_addr_0 <=  "00001001";
--                 write_addr_1 <= "00001010"; 
                    write_addr_0 <=  write_addr_in0;
                    write_addr_1 <= write_addr_in1;

                 din_A <= P(31 downto 16);
                 din_B <= P(15 downto 0);
--                 read_addr_0 <= "00000000";
--                 read_addr_1 <= "00000000";
                    count <= count + '1';
                if count = x"0f" then
                    state <= READ_MEM_again;
                   mem_wea <= "0";
                   count <= x"00";
                   CE <= '0';
               end if;
                
         
              
               when READ_MEM_again =>   --read back data from address for ensuring it is correct or not
                              enb_store_0 <= '1';
                              enb_store_1 <= '1'; 
--                                read_addr_0 <= "00001001";
--                                read_addr_1 <=  "00001010";
                                read_addr_0 <= write_addr_in0;
                                read_addr_1 <=  write_addr_in1;
                              state <= READ_MEM1_again;
                  
                          when READ_MEM1_again =>  --store again in d_A and d_B
                               d_A <= dout_memA;
                               d_B <= dout_memB;
                               count <= count + '1';
                                if count = x"0f" then
                                     state <= IDLE;  -- go to initial state and wait for start
                                     enb_store_0 <= '0';
                                     enb_store_1 <= '0';
                                     count <= x"00";
                                end if;
            when others =>
            -- Default state
            state <= IDLE;
        end case;
    end if;
 end process;

  mem0_mod : memory0  --initialization of memory A
    PORT MAP (
      clka => CLK,
      ena => '1',
      wea => mem_wea,
      addra => write_addr_0,
      dina => din_A,
      clkb => CLK,
      enb => enb_store_0,
      addrb => read_addr_0,
      doutb => dout_memA
    ); 

   mem1_mod : memory1  --initialization of memory B
       PORT MAP (
         clka => CLK,
         ena => '1',
         wea => mem_wea,
         addra => write_addr_1,
         dina => din_B,
         clkb => CLK,
         enb => enb_store_1,
         addrb => read_addr_1,
         doutb => dout_memB
       );
       
       
     dsp_mod : dsp0  --initialization of dsp
        PORT MAP (
        CLK => CLK,
        CE => CE,
        A => d_A,
        B => d_B,
        P => P
  );


end Behavioral;

