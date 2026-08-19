//============================================================
// 4-Line Direct-Mapped Cache Memory Controller
//============================================================

module cache_controller (
    input         clk,
    input         reset,

    // CPU interface
    input         cpu_read,
    input         cpu_write,
    input  [7:0]  cpu_addr,
    input  [7:0]  cpu_write_data,
    output reg [7:0] cpu_read_data,
    output reg       cpu_ready,
    output reg       cache_hit,

    // Main memory interface
    output reg       mem_read,
    output reg       mem_write,
    output reg [7:0] mem_addr,
    output reg [7:0] mem_write_data,
    input      [7:0]  mem_read_data
);

    // ---------------------------------------------------------
    // Cache configuration
    // ---------------------------------------------------------
    // 4 cache lines
    // 8-bit address
    // 2-bit index
    // 5-bit tag
    // 1-bit offset is unused for this single-byte example
    // ---------------------------------------------------------

    reg [7:0] cache_data [0:3];
    reg [4:0] cache_tag  [0:3];
    reg       valid_bit  [0:3];

    integer i;

    wire [1:0] index;
    wire [4:0] tag;

    assign index = cpu_addr[2:1];
    assign tag   = cpu_addr[7:3];

    // ---------------------------------------------------------
    // Cache controller
    // ---------------------------------------------------------

    always @(posedge clk or posedge reset) begin

        if (reset) begin

            cpu_read_data <= 8'b0;
            cpu_ready     <= 1'b0;
            cache_hit     <= 1'b0;

            mem_read      <= 1'b0;
            mem_write     <= 1'b0;
            mem_addr      <= 8'b0;
            mem_write_data <= 8'b0;

            for (i = 0; i < 4; i = i + 1) begin
                cache_data[i] <= 8'b0;
                cache_tag[i]  <= 5'b0;
                valid_bit[i]  <= 1'b0;
            end

        end

        else begin

            // Default signals
            cpu_ready <= 1'b0;
            cache_hit <= 1'b0;
            mem_read  <= 1'b0;
            mem_write <= 1'b0;

            // -------------------------------------------------
            // READ operation
            // -------------------------------------------------

            if (cpu_read) begin

                // Cache HIT
                if (valid_bit[index] &&
                    cache_tag[index] == tag) begin

                    cpu_read_data <= cache_data[index];
                    cpu_ready     <= 1'b1;
                    cache_hit     <= 1'b1;

                end

                // Cache MISS
                else begin

                    // Request data from main memory
                    mem_read <= 1'b1;
                    mem_addr <= cpu_addr;

                    // Fill cache with memory data
                    cache_data[index] <= mem_read_data;
                    cache_tag[index]  <= tag;
                    valid_bit[index]  <= 1'b1;

                    cpu_read_data <= mem_read_data;
                    cpu_ready     <= 1'b1;
                    cache_hit     <= 1'b0;

                end
            end

            // -------------------------------------------------
            // WRITE operation
            // -------------------------------------------------

            else if (cpu_write) begin

                // Update cache
                cache_data[index] <= cpu_write_data;
                cache_tag[index]  <= tag;
                valid_bit[index]  <= 1'b1;

                // Write-through to main memory
                mem_write      <= 1'b1;
                mem_addr       <= cpu_addr;
                mem_write_data <= cpu_write_data;

                cpu_ready <= 1'b1;

                if (valid_bit[index] &&
                    cache_tag[index] == tag)
                    cache_hit <= 1'b1;
                else
                    cache_hit <= 1'b0;

            end

        end
    end

endmodule