#file to create an 8bit arbiter

module arbiter_8bit (
    input wire clk,
    input wire reset,
    input wire [7:0] request,     // 8-bit request lines
    output reg [7:0] grant        // 8-bit grant lines
);

    reg [2:0] last_granted;       // Tracks last granted requester (3 bits for 8 requesters)

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grant <= 8'b0;
            last_granted <= 3'b111; // Start from highest index
        end else begin
            grant <= 8'b0;
            // Round-robin priority logic
            integer i;
            for (i = 1; i <= 8; i = i + 1) begin
                // Calculate next index in round-robin fashion
                integer idx = (last_granted + i) % 8;
                if (request[idx]) begin
                    grant[idx] <= 1'b1;
                    last_granted <= idx[2:0];
                    disable for; // Exit loop after granting
                end
            end
        end
    end

endmodule
