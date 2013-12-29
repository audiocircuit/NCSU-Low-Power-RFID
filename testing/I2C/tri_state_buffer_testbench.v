module tri_state_buffer_testbench();

reg in, data;
wire data_line;
wire out;

tri_state_buffer u1 (in, data, out, data_line);

initial
  begin
    in = 1'bx;
    data = 1'bx;
    #10
    in = 0;
    data = 0;
    #10
    in = 1;
    data = 0;
    #10
    in = 0;
    data = 1;
    #10
    in = 1;
    data = 1;
    #10
    $stop;
  end

endmodule






