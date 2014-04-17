module rfid_receive(
  input wire UL_clock,
  input wire reset_n,
  input wire UL_data,
  output reg [127:0] packet,
  output reg packet_rdy,
  output reg [1:0] op_size
  );

  reg [5:0] count;
  reg [6:0] packet_count;
  reg [4:0] state;
  integer i;
  reg data;


  //    1000-0-00-0-00-00-0-0000-10000
  //    1001-00-011
  //    00-01
  //    01-0100111111001000
  //    11000001-0000000011110000-1100110110111011
  //    11000010-01-00000010-00000001-00000001111000001-1101100100110101
  //    11000011-01-0000010-0011000000000000-0000000001111000001-110000000000100100
  //    11000100-1111011101110111-000-000000000001111000-11010010000010001
  //    1010-100-000-10-01111000-00010000-00000000-1-0111100000010011

  parameter WAIT          = 5'd0;
  parameter BAD           = 5'd1;
  parameter S0            = 5'd2;
  parameter S1            = 5'd3;
  parameter S10           = 5'd4;
  parameter S11           = 5'd5;
  parameter S00           = 5'd6;
  parameter S01           = 5'd7;
  parameter S101          = 5'd8;
  parameter S100          = 5'd9;
  parameter S110          = 5'd10;
  parameter S1010         = 5'd11;
  parameter S1000         = 5'd12;
  parameter S1001         = 5'd13;
  parameter S1100         = 5'd14;
  parameter S11000        = 5'd15;
  parameter S110000       = 5'd16;
  parameter S110001       = 5'd17;
  parameter S1100001      = 5'd18;
  parameter S1100000      = 5'd19;
  parameter S1100010      = 5'd20;
  parameter S11000010     = 5'd21;
  parameter S11000011     = 5'd22;
  parameter S11000001     = 5'd23;
  parameter S11000000     = 5'd24;
  parameter S11000100     = 5'd25;

  always@(posedge UL_clock or negedge reset_n)
    begin
      if(!reset_n)
        begin
          state <= WAIT;
          count <= 6'd0;
          packet_rdy <= 1'd0;
          packet_count <= 7'd0;
          packet = 128'd0;
        end
      else
        begin
          for(i = 7'd0; i <= 7'd127; i = i + 1'd1)
            begin
              if(i == (127 - packet_count))
                packet[i] <= UL_data;
              else
                packet[i] <= packet[i];
            end
            case(state)
              BAD:
                begin
                  op_size = 2'd0;
                  state <= BAD;
                  count <= 6'd0;
                  packet_rdy <= 1'd0;
                  packet_count <= 7'd0;
                  packet = 128'd0;
                end
              WAIT:
                begin
                  op_size = 2'd0;
                  packet_rdy <= 1'd0;
                  count <= 6'd0;
                  packet_count <= packet_count + 1'd1;
                  if(UL_data)
                    begin
                      state <= S1;
                    end
                  else
                    begin
                      state <= S0;
                    end
                end
              S1:       
                begin
                  op_size = 2'd0;
                  packet_rdy <= 1'd0;
                  count <= 6'd0;
                  packet_count <= packet_count + 1'd1;
                  if(UL_data)
                    begin
                      state <= S11;
                    end
                  else
                    begin
                      state <= S10;
                    end
                end
              S10:      
                begin
                  op_size = 2'd0;
                  packet_rdy <= 1'd0;
                  count <= 6'd0;
                  packet_count <= packet_count + 1'd1;
                  if(UL_data)
                    begin
                      state <= S101;
                    end
                  else
                    begin
                      state <= S100;
                    end
                end
              S100:     
                begin
                  op_size = 2'd0;
                  packet_rdy <= 1'd0;
                  count <= 6'd0;
                  packet_count <= packet_count + 1'd1;
                  if(UL_data)
                    begin
                      state <= S1001;
                    end
                  else
                    begin
                      state <= S1000;
                    end
                end
              S101:     
                begin
                  op_size = 2'd0;
                  packet_rdy <= 1'd0;
                  count <= 6'd0;
                  packet_count <= packet_count + 1'd1;
                  if(UL_data)
                    begin
                      state <= BAD;
                    end
                  else
                    begin
                      state <= S1010;
                    end
                end
              S1010:
                begin
                  op_size <= 2'd1;
                  if(count < 6'd47)
                    begin
                      packet_count <= packet_count + 1'd1;
                      count <= count + 1'd1;
                      state <= S1010;
                      packet_rdy <= 1'd0;
                    end
                  else if(count == 6'd47)
                    begin
                      packet_count <= packet_count + 1'd1;
                      count <= count + 1'd1;
                      state <= S1010;
                      packet_rdy <= 1'd1;
                    end
                  else
                    begin
                      packet_count <= 7'd0;
                      count <= 6'd0;
                      state <= WAIT;
                      packet_rdy <= 1'd0;
                    end
                end
              S1000:    
                begin
                  op_size <= 2'd1;
                  if(count < 6'd16)
                    begin
                      packet_count <= packet_count + 1'd1;
                      count <= count + 1'd1;
                      state <= S1000;
                      packet_rdy <= 1'd0;
                    end
                  else if(count == 6'd16)
                    begin
                      packet_count <= packet_count + 1'd1;
                      count <= count + 1'd1;
                      state <= S1000;
                      packet_rdy <= 1'd1;
                    end
                  else
                    begin
                      packet_count <= 7'd0;
                      count <= 6'd0;
                      state <= WAIT;
                      packet_rdy <= 1'd0;
                    end
                end
              S1001:    
                begin
                  op_size = 2'd1;
                  if(count < 6'd3)
                    begin
                      packet_count <= packet_count + 1'd1;
                      count <= count + 1'd1;
                      state <= S1001;
                      packet_rdy <= 1'd0;
                    end
                  else if(count == 6'd3)
                    begin
                      packet_count <= packet_count + 1'd1;
                      count <= count + 1'd1;
                      state <= S1001;
                      packet_rdy <= 1'd1;
                    end
                  else
                    begin
                      packet_count <= 7'd0;
                      count <= 6'd0;
                      state <= WAIT;
                      packet_rdy <= 1'd0;
                    end
                end
              S0:       
                begin
                  op_size = 2'd0;
                  packet_rdy <= 1'd0;
                  count <= 6'd0;
                  packet_count <= packet_count + 1'd1;
                  if(UL_data)
                    begin
                      state <= S01;
                    end
                  else
                    begin
                      state <= S00;
                    end
                end
              S00:      
                begin
                  op_size = 2'd0;
                  if(count == 6'd0)
                    begin
                      packet_count <= packet_count + 1'd1;
                      count <= count + 1'd1;
                      state <= S00;
                      packet_rdy <= 1'd1;
                    end
                  else
                    begin
                      packet_count <= 7'd0;
                      count <= 6'd0;
                      state <= WAIT;
                      packet_rdy <= 1'd0;
                    end
                end
              S01:      
                begin
                  op_size = 2'd0;
                  if(count < 6'd14)
                    begin
                      packet_count <= packet_count + 1'd1;
                      count <= count + 1'd1;
                      state <= S01;
                      packet_rdy <= 1'd0;
                    end
                  else if(count == 6'd14)
                    begin
                      packet_count <= packet_count + 1'd1;
                      count <= count + 1'd1;
                      state <= S01;
                      packet_rdy <= 1'd1;
                    end
                  else
                    begin
                      packet_count <= 7'd0;
                      count <= 6'd0;
                      state <= WAIT;
                      packet_rdy <= 1'd0;
                    end
                end
              S11:      
                begin
                  op_size = 2'd0;
                  packet_rdy <= 1'd0;
                  count <= 6'd0;
                  packet_count <= packet_count + 1'd1;
                  if(UL_data)
                    begin
                      state <= BAD;
                    end
                  else
                    begin
                      state <= S110;
                    end
                end
              S110:     
                begin
                  op_size = 2'd0;
                  packet_rdy <= 1'd0;
                  count <= 6'd0;
                  packet_count <= packet_count + 1'd1;
                  if(UL_data)
                    begin
                      state <= BAD;
                    end
                  else
                    begin
                      state <= S1100;
                    end
                end
              S1100:    
                begin
                  op_size = 2'd0;
                  packet_rdy <= 1'd0;
                  count <= 6'd0;
                  packet_count <= packet_count + 1'd1;
                  if(UL_data)
                    begin
                      state <= BAD;
                    end
                  else
                    begin
                      state <= S11000;
                    end
                end
              S11000:   
                begin
                  op_size = 2'd0;
                  packet_rdy <= 1'd0;
                  count <= 6'd0;
                  packet_count <= packet_count + 1'd1;
                  if(UL_data)
                    begin
                      state <= S110001;
                    end
                  else
                    begin
                      state <= S110000;
                    end
                end
              S110001:  
                begin
                  op_size = 2'd0;
                  packet_rdy <= 1'd0;
                  count <= 6'd0;
                  packet_count <= packet_count + 1'd1;
                  if(UL_data)
                    begin
                      state <= BAD;
                    end
                  else
                    begin
                      state <= S1100010;
                    end
                end
              S1100010: 
                begin
                  op_size = 2'd0;
                  packet_rdy <= 1'd0;
                  count <= 6'd0;
                  packet_count <= packet_count + 1'd1;
                  if(UL_data)
                    begin
                      state <= BAD;
                    end
                  else
                    begin
                      state <= S11000100;
                    end
                end
              S11000100:
                begin
                  op_size = 2'd2;
                  if(count < 6'd49)
                    begin
                      packet_count <= packet_count + 1'd1;
                      count <= count + 1'd1;
                      state <= S11000100;
                      packet_rdy <= 1'd0;
                    end
                  else if(count == 6'd49)
                    begin
                      packet_count <= packet_count + 1'd1;
                      count <= count + 1'd1;
                      state <= S11000100;
                      packet_rdy <= 1'd1;
                    end
                  else
                    begin
                      packet_count <= 7'd0;
                      count <= 6'd0;
                      state <= WAIT;
                      packet_rdy <= 1'd0;
                    end
                end
              S110000:   
                begin
                  op_size = 2'd0;
                  packet_rdy <= 1'd0;
                  count <= 6'd0;
                  packet_count <= packet_count + 1'd1;
                  if(UL_data)
                    begin
                      state <= S1100001;
                    end
                  else
                    begin
                      state <= S1100000;
                    end
                end
              S1100000:   
                begin
                  op_size = 2'd0;
                  count <= 6'd0;
                  packet_count <= packet_count + 1'd1;
                  if(UL_data)
                    begin
                      state <= S11000001;
                      packet_rdy <= 1'd0;
                    end
                  else
                    begin
                      state <= S11000000;
                      packet_rdy <= 1'd1;
                    end
                end
              S11000000:
                begin
                  op_size = 2'd2;
                  count <= 6'd0;
                  packet_count <= 5'd0;
                  state <= WAIT;
                  packet_rdy <= 1'd0;
                end
              S1100001: 
                begin
                  op_size = 2'd0;
                  packet_rdy <= 1'd0;
                  count <= 6'd0;
                  packet_count <= packet_count + 1'd1;
                  if(UL_data)
                    begin
                      state <= S11000011;
                    end
                  else
                    begin
                      state <= S11000010;
                    end
                end
              S11000001:
                begin
                  op_size = 2'd2;
                  if(count < 6'd30)
                    begin
                      packet_count <= packet_count + 1'd1;
                      count <= count + 1'd1;
                      state <= S11000001;
                      packet_rdy <= 1'd0;
                    end
                  else if(count == 6'd30)
                    begin
                      packet_count <= packet_count + 1'd1;
                      count <= count + 1'd1;
                      state <= S11000001;
                      packet_rdy <= 1'd1;
                    end
                  else
                    begin
                      packet_count <= 7'd0;
                      count <= 6'd0;
                      state <= WAIT;
                      packet_rdy <= 1'd0;
                    end
                end
              S11000010:
                begin
                  op_size = 2'd2;
                   if(count < 6'd48)
                    begin
                      packet_count <= packet_count + 1'd1;
                      count <= count + 1'd1;
                      state <= S11000010;
                      packet_rdy <= 1'd0;
                    end
                  else if(count == 6'd48)
                    begin
                      packet_count <= packet_count + 1'd1;
                      count <= count + 1'd1;
                      state <= S11000010;
                      packet_rdy <= 1'd1;
                    end
                  else
                    begin
                      packet_count <= 7'd0;
                      count <= 6'd0;
                      state <= WAIT;
                      packet_rdy <= 1'd0;
                    end
                end
              S11000011:
                begin
                  op_size = 2'd2;
                   if(count < 6'd56)
                    begin
                      packet_count <= packet_count + 1'd1;
                      count <= count + 1'd1;
                      state <= S11000011;
                      packet_rdy <= 1'd0;
                    end
                  else if(count == 6'd56)
                    begin
                      packet_count <= packet_count + 1'd1;
                      count <= count + 1'd1;
                      state <= S11000011;
                      packet_rdy <= 1'd1;
                    end
                  else
                    begin
                      packet_count <= 7'd0;
                      count <= 6'd0;
                      state <= WAIT;
                      packet_rdy <= 1'd0;
                    end
                end
            endcase
        end
    end
  endmodule
