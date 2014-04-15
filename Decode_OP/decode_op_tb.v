module decode_op_tb;

reg clock, reset, decode_rdy;
reg [15:0]data_in;
wire [1:0]sensor_num;
wire [2:0]op_code;
wire [15:0]data_out; 
wire data_rdy;

always #5 clock = ~clock;

initial
	begin
		clock = 0; reset = 0; decode_rdy = 0;
		#22 reset = 1; 
		#10 data_in = 16'b0000000000000000;
		#10 decode_rdy = 1;
		#10 data_in = 16'd1;
		#10 data_in = 16'd2;
		#10 data_in = 16'd3;
		#10 data_in = 16'd4;
		#10 data_in = 16'd5;
		#10 data_in = 16'd6;
		#10 data_in = 16'd7;
		#10 data_in = 16'd8;
		#10 data_in = 16'd9;
		#10 data_in = 16'd10;
		#3000
		$finish;
	end

decode_op dut(.clock(clock), .reset(reset), .decode_rdy(decode_rdy),
		.data_in(data_in), .sensor_num(sensor_num), 
		.op_code(op_code), .data_out(data_out), .data_rdy(data_rdy));

endmodule	
