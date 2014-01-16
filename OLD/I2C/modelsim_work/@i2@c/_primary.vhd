library verilog;
use verilog.vl_types.all;
entity I2C is
    port(
        address         : in     vl_logic_vector(6 downto 0);
        \register\      : in     vl_logic_vector(7 downto 0);
        clk             : in     vl_logic;
        mode            : in     vl_logic;
        en              : in     vl_logic;
        reset           : in     vl_logic;
        Start           : in     vl_logic;
        Stop            : in     vl_logic;
        repeat_start    : in     vl_logic;
        ack             : out    vl_logic;
        \out\           : out    vl_logic_vector(7 downto 0);
        sda             : inout  vl_logic;
        scl             : inout  vl_logic
    );
end I2C;
