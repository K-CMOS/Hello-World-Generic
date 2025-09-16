module arbiter_8bit_sv_tb;

    logic clk;
    logic reset;
    logic [7:0] request;
    logic [7:0] grant;

    // Instantiate the DUT (Device Under Test)
    arbiter_8bit_sv dut (
        .clk(clk),
        .reset(reset),
        .request(request),
        .grant(grant)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 100MHz clock

    // Test sequence
    initial begin
        $display("Starting Arbiter Testbench...");
        reset = 1;
        request = 8'b00000000;
        #10;

        reset = 0;

        // Test 1: Single request
        request = 8'b00000001; // Only requester 0
        #10;
        $display("Grant: %b", grant);

        // Test 2: Multiple requests
        request = 8'b00001111; // Requesters 0 to 3
        #10;
        $display("Grant: %b", grant);

        #10;
        request = 8'b00001111; // Keep same requests
        #10;
        $display("Grant: %b", grant);

        #10;
        request = 8'b00001111; // Keep same requests
        #10;
        $display("Grant: %b", grant);

        // Test 3: All requesters active
        request = 8'b11111111;
        repeat (10) begin
            #10;
            $display("Grant: %b", grant);
        end

        // Test 4: No requests
        request = 8'b00000000;
        #10;
        $display("Grant: %b", grant);

        $display("Testbench completed.");
        $finish;
    end

endmodule
