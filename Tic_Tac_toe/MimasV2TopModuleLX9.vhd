------------------------------------------------------------------------
-- SPARTAN_3E_ V2 demo code
-- Numato Lab
-- http://www.numato.com
-- http://www.numato.cc
-- License : CC BY-SA (http://creativecommons.org/licenses/by-sa/2.0/)
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity SPARTAN_3E_TopModule is
  GENERIC (          BoardDescription                               : STRING   := "SPARTAN 6E";
                     DeviceDescripition                             : STRING   := "SPARTAN 6E";
                     ClockFrequency                                 : INTEGER  := 50_000_000;
                     NumberOfPushButton                       		  : INTEGER  := 4;
                     NumberOfDIPSW                       		     : INTEGER  := 3;
                     NumberOfLEDs                                   : INTEGER  := 8;
                     NumberOfEachPortIOs                            : INTEGER  := 8;
                     VGAResolution                                  : STRING   := "640x480 @ 60Hz";
                     NumberOfSevenSegmentModule                     : INTEGER  := 3;
                     SevenSegmentLED                                : INTEGER  := 8
                );
  PORT ( -- Input's
            -- Assuming 50MHz input clock and active Low reset.
                     CLK_50MHz                                            : IN   STD_LOGIC;
							DIP_SWITCH                                          : IN   STD_LOGIC_VECTOR(NumberOfDIPSW-1 downto 0);
             -- Push_Button_Switches.
                     Push_Button_Switch                                         : IN   STD_LOGIC_VECTOR(NumberOfPushButton-1 downto 0);
            -- Output's
              -- VGA Display
                     HSync                                          : OUT   STD_LOGIC;
                     VSync                                          : OUT   STD_LOGIC;
                     Red                                            : OUT   STD_LOGIC;
                     Green                                          : OUT   STD_LOGIC;
                     Blue                                           : OUT   STD_LOGIC
             

          );

end SPARTAN_3E_TopModule;

architecture Behavioral of SPARTAN_3E_TopModule is

-- component clocking
--   port    (  --Input clock 50 MHz
--                     CLK_IN                                          : in std_logic;
--                --Output
--                     CLK_100MHz                                      : out std_logic;
--                     CLK_50MHz                                       : out std_logic);
-- end component;
 
 component SPARTAN_3E_VGADisplay
   generic (       VGAResolution                                    : STRING );
   port    (  -- Input clock 100 MHz
                     CLK                                            : in std_logic;
							RST                                            : in std_logic;
							ENTER1                                            : in std_logic;
							ENTER2                                            : in std_logic;
							Push_Button_Switch                                         : IN   STD_LOGIC_VECTOR(NumberOfPushButton-1 downto 0);
                -- Output
                     HSync                                          : out std_logic;
                     VSync                                          : out std_logic;
                     Red                                          : out std_logic;
                     Green                                          : out std_logic;
                     Blue                                          : out std_logic
                    );
 end component;




--	 signal  CLK_100MHz                                              : std_logic := '0';
--	 signal  CLK_50MHz                                               : std_logic := '0';
begin
--
--    clocking_Instant            : clocking
--                                   port map (CLK_IN                                         => CLK,
--                                             CLK_100MHz                                     => CLK_100MHz,
--                                             CLK_50MHz                                      => CLK_50MHz);
															 										 
    VGA_instant                 : SPARTAN_3E_VGADisplay
                                   generic map(VGAResolution                                 => VGAResolution)
                                   port map   (CLK                                           => CLK_50MHz,
											              RST                                           => DIP_SWITCH(0),
											              ENTER1                                         => DIP_SWITCH(1),
											              ENTER2                                        => DIP_SWITCH(2),
															  Push_Button_Switch                            => Push_Button_Switch,
                                               hsync                                         => hsync,
                                               vsync                                         => vsync,
                                               Red                                           => Red,
                                               Green                                         => Green,
                                               Blue                                          => Blue);

end Behavioral;

