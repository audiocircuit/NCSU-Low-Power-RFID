library verilog;
use verilog.vl_types.all;
entity test1 is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        enabled         : in     vl_logic;
        \in\            : in     vl_logic;
        Start           : in     vl_logic;
        Stop            : in     vl_logic;
        sda             : out    vl_logic
    );
end test1;
