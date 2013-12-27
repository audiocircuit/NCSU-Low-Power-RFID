library verilog;
use verilog.vl_types.all;
entity I2C is
    port(
        Address         : in     vl_logic_vector(6 downto 0);
        \Register\      : in     vl_logic_vector(7 downto 0);
        Clk             : in     vl_logic;
        Mode            : in     vl_logic;
        Start           : in     vl_logic;
        Stop            : in     vl_logic;
        Reset           : in     vl_logic;
        Ack             : out    vl_logic;
        \Out\           : out    vl_logic_vector(7 downto 0);
        Sda             : inout  vl_logic;
        Scl             : inout  vl_logic
    );
end I2C;
