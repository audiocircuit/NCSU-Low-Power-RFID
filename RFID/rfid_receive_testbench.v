
module rfid_receive_testbench();
  reg UL_clock = 1;
  reg reset_n = 1;
  reg UL_data;
  wire [127:0] packet;
  wire packet_rdy;
  reg clk_enable = 0;


  rfid_receive rec(
    UL_clock,
    reset_n,
    UL_data,
    packet,
    packet_rdy
    );


    always@(*)
      begin
        if(clk_enable)
          #5 UL_clock <= ~UL_clock;
        else 
          #5 UL_clock <= 1;
      end



    initial
      begin
        #20 reset_n = 0;
        #10 reset_n = 1;
        #30 clk_enable = 1; UL_data = 0;
        #10 UL_data = 0;
        #10 UL_data = 1;
        #10 UL_data = 0;
        #10 clk_enable = 0;
       $finish; 
      end
endmodule  
