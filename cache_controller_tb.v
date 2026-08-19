`timescale 1ns/1ps

module cache_controller_tb;

    reg clk;
    reg reset;

    reg        cpu_read;
    reg        cpu_write;
    reg [7:0]  cpu_addr;
    reg [7:0]  cpu_write_data;

    wire [7:0] cpu_read_data;
    wire       cpu_ready;
    wire       cache_hit;

    wire       mem_read;
    wire       mem_write;
    wire [7:0] mem_addr;
    wire [7:0] mem_write_data;

    reg [7:0] mem_read_data;

    // ---------------------------------------------------------
    // Instantiate cache controller
    // ---------------------------------------------------------

    cache_controller uut (
        .clk(clk),
        .reset(reset),

        .cpu_read(cpu_read),
        .cpu_write(cpu_write),
        .cpu_addr(cpu_addr),
        .cpu_write_data(cpu_write_data),

        .cpu_read_data(cpu_read_data),
        .cpu_ready(cpu_ready),
        .cache_hit(cache_hit),

        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_addr(mem_addr),
        .mem_write_data(mem_write_data),

        .mem_read_data(mem_read_data)
    );

    // ---------------------------------------------------------
    // Clock generation
    // ---------------------------------------------------------

    always #5 clk = ~clk;

    // ---------------------------------------------------------
    // Main memory model
    // ---------------------------------------------------------

    always @(*) begin

        case (mem_addr)

            8'h10: mem_read_data = 8'hAA;
            8'h20: mem_read_data = 8'hBB;
            8'h30: mem_read_data = 8'hCC;
            8'h40: mem_read_data = 8'hDD;

            default: mem_read_data = 8'h00;

        endcase

    end

    // ---------------------------------------------------------
    // Test sequence
    // ---------------------------------------------------------

    initial begin

        // Create waveform
        $dumpfile("waveform.vcd");
        $dumpvars(0, cache_controller_tb);

        // Initialize
        clk = 0;
        reset = 1;

        cpu_read = 0;
        cpu_write = 0;
        cpu_addr = 0;
        cpu_write_data = 0;

        #10;

        reset = 0;

        // -----------------------------------------------------
        // TEST 1: Read address 10
        // Expected: MISS
        // -----------------------------------------------------

        #10;

        cpu_addr = 8'h10;
        cpu_read = 1;

        #10;

        cpu_read = 0;

        // -----------------------------------------------------
        // TEST 2: Read address 10 again
        // Expected: HIT
        // -----------------------------------------------------

        #10;

        cpu_addr = 8'h10;
        cpu_read = 1;

        #10;

        cpu_read = 0;

        // -----------------------------------------------------
        // TEST 3: Read address 20
        // Expected: MISS
        // -----------------------------------------------------

        #10;

        cpu_addr = 8'h20;
        cpu_read = 1;

        #10;

        cpu_read = 0;

        // -----------------------------------------------------
        // TEST 4: Write data to address 30
        // -----------------------------------------------------

        #10;

        cpu_addr = 8'h30;
        cpu_write_data = 8'h55;
        cpu_write = 1;

        #10;

        cpu_write = 0;

        // -----------------------------------------------------
        // TEST 5: Read address 30
        // Expected: HIT
        // -----------------------------------------------------

        #10;

        cpu_addr = 8'h30;
        cpu_read = 1;

        #10;

        cpu_read = 0;

        #20;

        $finish;

    end

    // ---------------------------------------------------------
    // Display simulation results
    // ---------------------------------------------------------

    initial begin

        $monitor(
            "Time=%0t | Addr=%h | Read=%b | Write=%b | WriteData=%h | ReadData=%h | Hit=%b | Ready=%b | MemRead=%b | MemWrite=%b",
            $time,
            cpu_addr,
            cpu_read,
            cpu_write,
            cpu_write_data,
            cpu_read_data,
            cache_hit,
            cpu_ready,
            mem_read,
            mem_write
        );

    end

endmodule