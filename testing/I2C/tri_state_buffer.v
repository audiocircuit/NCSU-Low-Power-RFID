module tri_state_buffer(
input wire enable,
input wire data,
output out,
inout data_line
);

assign data_line = (enable) ? data: 1'bz;
assign out = data_line;

endmodule
