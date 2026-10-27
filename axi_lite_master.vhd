library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity axi_lite_master is
    Port (
        ACLK    : in  STD_LOGIC;
        ARESETN : in  STD_LOGIC;

        AWADDR  : out STD_LOGIC_VECTOR(31 downto 0);
        AWVALID : out STD_LOGIC;
        AWREADY : in  STD_LOGIC;

        WDATA   : out STD_LOGIC_VECTOR(31 downto 0);
        WVALID  : out STD_LOGIC;
        WREADY  : in  STD_LOGIC;
        WLAST   : out STD_LOGIC;

        BRESP   : in  STD_LOGIC_VECTOR(1 downto 0);
        BVALID  : in  STD_LOGIC;
        BREADY  : out STD_LOGIC
    );
end axi_lite_master;

architecture Behavioral of axi_lite_master is

    type state_type is (IDLE, SEND_ADDR, ADDR_DELAY, SEND_DATA, WAIT_RESP, DONE );

    signal state : state_type := IDLE;

    type addr_array_type is array (0 to 2)
        of STD_LOGIC_VECTOR(31 downto 0);

    type data_array_type is array (0 to 2)
        of STD_LOGIC_VECTOR(31 downto 0);

    constant addr_ram : addr_array_type := (
        x"00001000",
        x"00001004",
        x"00001008"
    );

    constant data_ram : data_array_type := (
        x"1234BDEF",
        x"ABCDEF12",
        x"abab1212"
    );

    signal ram_index : integer range 0 to 3 := 0;

    signal addr_reg : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

    signal data_reg : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

    signal awvalid_int : STD_LOGIC := '0';
    signal wvalid_int  : STD_LOGIC := '0';
    signal bready_int  : STD_LOGIC := '0';

    signal delay_count : integer range 0 to 2 := 0;
    
    signal resp_timeout : integer range 0 to 100 := 0;

begin

    AWADDR  <= addr_reg;
    WDATA   <= data_reg;

    AWVALID <= awvalid_int;
    WVALID  <= wvalid_int;
    BREADY  <= bready_int;

    WLAST <= wvalid_int;

    process (ACLK, ARESETN)
    begin
        if ARESETN = '0' then

            state        <= IDLE;
            ram_index    <= 0;
            addr_reg     <= (others => '0');
            data_reg     <= (others => '0');
            awvalid_int  <= '0';
            wvalid_int   <= '0';
            bready_int   <= '0';
            delay_count  <= 0;

        elsif rising_edge(ACLK) then

            case state is

                when IDLE =>
                    awvalid_int <= '0';
                    wvalid_int  <= '0';
                    bready_int  <= '0';

                    if ram_index < 3 then
                        addr_reg    <= addr_ram(ram_index);
                        data_reg    <= data_ram(ram_index);
                        awvalid_int <= '1';
                        state       <= SEND_ADDR;
                    else
                        state <= DONE;
                    end if;

                when SEND_ADDR =>
                    if awvalid_int = '1' and AWREADY = '1' then
                        awvalid_int <= '0';
                        delay_count <= 0;
                        state       <= ADDR_DELAY;
                    end if;

                when ADDR_DELAY =>
                    if delay_count = 2 then
                        wvalid_int <= '1';
                        state      <= SEND_DATA;
                    else
                        delay_count <= delay_count + 1;
                    end if;

                when SEND_DATA =>
                    if wvalid_int = '1' and WREADY = '1' then
                        wvalid_int <= '0';
                        bready_int <= '1';
                        state      <= WAIT_RESP;
                    end if;

                    when WAIT_RESP =>
                        if bready_int = '1' and BVALID = '1' then
                    
                            assert BRESP = "00"
                                report "AXI write response is not OKAY"
                                severity error;
                    
                            bready_int <= '0';
                            resp_timeout <= 0;
                            ram_index <= ram_index + 1;
                            state <= IDLE;
                    
                        elsif resp_timeout = 99 then
                            assert false
                                report "TIMEOUT: No AXI write response received"
                                severity failure;
                            
                            bready_int <= '0';
                            resp_timeout <= 0;
                            state <= IDLE;
                        else
                            resp_timeout <= resp_timeout + 1;
                        end if;

                when DONE =>
                    awvalid_int <= '0';
                    wvalid_int  <= '0';
                    bready_int  <= '0';

                when others =>
                    state <= IDLE;

            end case;
        end if;
    end process;

end Behavioral;