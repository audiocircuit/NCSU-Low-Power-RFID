library verilog;
use verilog.vl_types.all;
entity tri_state_buffer is
    port(
        enable          : in     vl_logic;
        data            : in     vl_logic;
        \out\           : out    vl_logic;
        data_line       : inout  vl_logic
    );
end tri_state_buffer;
