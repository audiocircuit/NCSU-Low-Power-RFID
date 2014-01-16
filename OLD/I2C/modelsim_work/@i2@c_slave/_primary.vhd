library verilog;
use verilog.vl_types.all;
entity I2C_slave is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        sda             : inout  vl_logic;
        scl             : in     vl_logic
    );
end I2C_slave;
