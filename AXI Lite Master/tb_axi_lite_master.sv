
`timescale 1ns/1ps

module tb_axi_lite_master;

    logic ACLK = 0;
    logic ARESETN = 0;

    wire [31:0] AWADDR;
    wire AWVALID;
    logic AWREADY = 1;

    wire [31:0] WDATA;
    wire WVALID;
    logic WREADY = 1;
    wire WLAST;

    logic [1:0] BRESP = 2'b00;
    logic BVALID = 0;
    wire BREADY;

    logic [31:0] received_addr = 0;
    logic [31:0] received_data = 0;

    logic address_seen = 0;
    logic data_seen = 0;
    logic response_pending = 0;

    integer transaction_count = 0;
    integer response_delay = 0;

    logic transaction_ok;

    axi_lite_master DUT (
        .ACLK(ACLK),
        .ARESETN(ARESETN),

        .AWADDR(AWADDR),
        .AWVALID(AWVALID),
        .AWREADY(AWREADY),

        .WDATA(WDATA),
        .WVALID(WVALID),
        .WREADY(WREADY),
        .WLAST(WLAST),

        .BRESP(BRESP),
        .BVALID(BVALID),
        .BREADY(BREADY)
    );

    always #5 ACLK = ~ACLK;

    initial begin
        repeat (2) @(negedge ACLK);
        ARESETN = 1;
    end

    always @(posedge ACLK) begin
        if (!ARESETN) begin
            received_addr   <= 0;
            received_data   <= 0;
            address_seen    <= 0;
            data_seen       <= 0;
            response_pending <= 0;
            response_delay  <= 0;
            transaction_count <= 0;
            BVALID           <= 0;
            BRESP            <= 2'b00;
        end
        else begin

            if (AWVALID && AWREADY) begin
                received_addr <= AWADDR;
                address_seen  <= 1;

                $display("[%0t] AW handshake: AWADDR = %h",
                         $time, AWADDR);
            end

            if (WVALID && WREADY) begin
                received_data <= WDATA;
                data_seen     <= 1;

                if (WLAST !== 1'b1)
                    $fatal(1, "ERROR: WLAST was not high");

                $display("[%0t] W handshake: WDATA = %h",
                         $time, WDATA);
            end

            if (!response_pending && !BVALID &&
                (address_seen || (AWVALID && AWREADY)) &&
                (data_seen || (WVALID && WREADY))) begin

                response_pending <= 1;
                response_delay   <= 2;
            end

            if (response_pending && response_delay > 0) begin
                response_delay <= response_delay - 1;

                if (response_delay == 1) begin
                    transaction_ok = 1'b0;

                    case (transaction_count)
                        0: begin
                            transaction_ok =
                                ((received_addr == 32'h00001000) &&
                                 (received_data == 32'h1234BDEF));
                        end

                        1: begin
                            transaction_ok =
                                ((received_addr == 32'h00001004) &&
                                 (received_data == 32'hABCDEF12));
                        end

                        2: begin
                            transaction_ok =
                                ((received_addr == 32'h00001008) &&
                                 (received_data == 32'hab12ab12));
                        end

                        default: begin
                            transaction_ok = 1'b0;
                        end
                    endcase

                    if (transaction_ok) begin
                        BRESP <= 2'b00;
                        $display("[%0t] Data/address MATCH. BRESP = OKAY",
                                 $time);
                    end
                    else begin
                        BRESP <= 2'b10;
                        $error(
                            "Transaction %0d MISMATCH: addr=%h data=%h",
                            transaction_count + 1,
                            received_addr,
                            received_data
                        );
                    end

                    BVALID <= 1;
                end
            end

            if (BVALID && BREADY) begin
                $display("[%0t] B handshake: BRESP = %b",
                         $time, BRESP);

                if (BRESP !== 2'b00)
                    $fatal(1, "FAIL: Slave returned an error response");

                transaction_count <= transaction_count + 1;

                address_seen     <= 0;
                data_seen        <= 0;
                response_pending <= 0;
                response_delay   <= 0;
                BVALID           <= 0;

                if (transaction_count == 2) begin
                    $display("\nPASS: All three transactions matched.");
                    $finish;
                end
            end
        end
    end

    initial begin
        #2000;
        $fatal(1, "TIMEOUT: AXI transactions did not complete");
    end

endmodule
