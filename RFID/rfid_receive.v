module rfid_receive(
  input wire UL_clock,
  input wire reset_n,
  input wire UL_data,
  output reg [127:0] packet,
  output reg packet_rdy
  );

  reg [4:0] count;
  reg [6:0] packet_count;
  reg [4:0] state;
  integer i;


  //    1000-0-00-0-00-00-0-0000-10000
  //    1001-00-011
  //    00-01
  //    01-0100111111001000
  //    11000000
  //    11000001-0000000011110000-1100110110111011
  //    11000010-01-00000010-00000001-00000001111000001-1101100100110101
  //    11000011-01-0000010-0011000000000000-0000000001111000001-110000000000100100
  //    11000100-1111011101110111-000-000000000001111000-11010010000010001
  //    1010-100-000-10-01111000-00010000-00000000-1-0111100000010011

  parameter WAIT          = 5'd0;
  parameter S1            = 5'd1;
  parameter S10           = 5'd2;
  parameter S100          = 5'd3;
  parameter S1000         = 5'd4;
  parameter S1001         = 5'd5;
  parameter S0            = 5'd6;
  parameter S00           = 5'd7;
  parameter S01           = 5'd8;
  parameter S11           = 5'd9;
  parameter S110          = 5'd10;
  parameter S1100         = 5'd11;
  parameter S11000        = 5'd12;
  parameter S110001       = 5'd13;
  parameter S1100010      = 5'd14;
  parameter S11000100     = 5'd15;
  parameter S1100001      = 5'd16;
  parameter S11000010     = 5'd17;
  parameter S11000011     = 5'd18;


  always@(posedge UL_clock or negedge reset_n)
    begin
      if(!reset_n)
        begin
          state <= WAIT;
          count <= 5'd0;
          packet_rdy <= 1'd0;
          packet_count <= 7'd0;
          packet <= 128'd0;
        end
      else
        begin
          case(state)
            WAIT:
              begin
                packet_rdy <= 1'd0;
                count <= 5'd0;
                packet_count <= packet_count + 1'd1;
                for(i = 7'd0; i <= 7'd127; i = i + 1'd1)
                  begin
                    if(i == 127 - packet_count)
                      packet[i] <= UL_data;
                    else
                      packet[i] <= packet[i];
                  end
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
              end
            S10:      
              begin
              end
            S100:     
              begin
              end
            S1000:    
              begin
              end
            S1001:    
              begin
              end
            S0:       
              begin
                packet_rdy <= 1'd0;
                count <= 5'd0;
                packet_count <= packet_count + 1'd1;
                for(i = 7'd0; i <= 7'd127; i = i + 1'd1)
                  begin
                    if(i == 127 - packet_count)
                      packet[i] <= UL_data;
                    else
                      packet[i] <= packet[i];
                  end
                if(UL_data)
                  begin
                    state <= S00;
                  end
                else
                  begin
                    state <= S01;
                  end
              end
            S00:      
              begin
                for(i = 7'd0; i <= 7'd127; i = i + 1'd1)
                  begin
                    if(i == 127 - packet_count)
                      packet[i] <= UL_data;
                    else
                      packet[i] <= packet[i];
                  end
                if(count == 0)
                  begin
                    packet_count <= packet_count + 1'd1;
                    count <= count + 1'd1;
                    state <= S00;
                    packet_rdy <= 1'd1;
                  end
                else
                  begin
                    packet_count <= 7'd0;
                    count <= 5'd0;
                    state <= WAIT;
                    packet_rdy <= 1'd0;
                  end
              end
            S01:      
              begin
              end
            S11:      
              begin
              end
            S110:     
              begin
              end
            S1100:    
              begin
              end
            S11000:   
              begin
              end
            S110001:  
              begin
              end
            S1100010: 
              begin
              end
            S11000100:
              begin
              end
            S1100001: 
              begin
              end
            S11000010:
              begin
              end
            S11000011:
              begin
              end
          endcase
        end


    end
  endmodule
