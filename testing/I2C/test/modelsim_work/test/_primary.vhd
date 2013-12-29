library verilog;
use verilog.vl_types.all;
entity test is
    port(
        clk             : in     vl_logic;
        sda             : in     vl_logic;
        \out\           : out    vl_logic
    );
end test;
