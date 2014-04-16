
module rfid_receive_testbench();
  reg UL_clock = 1;
  reg reset_n = 1;
  reg UL_data;
  wire [127:0] packet;
  wire packet_rdy;
  wire op_size;
  reg clk_enable = 0;
  integer i;

  rfid_receive rec(
    .UL_clock(UL_clock),
    .reset_n(reset_n),
    .UL_data(UL_data),
    .packet(packet),
    .packet_rdy(packet_rdy),
    .op_size(op_size)
    );

  rfid_decode(
    .clock(UL_clock),
    .reset_n(reset_n),
    .input_in(packet),
    .op_code(op_size),
    .packet_rdy(packet_rdy)
    );

    always@(*)
      begin
        if(clk_enable)
          #5 UL_clock <= ~UL_clock;
        else 
          #5 UL_clock <= 0;
      end



    initial
      begin
        start_up();
        #40
        ACK_Command(16'h5555);
        #20
        rec.packet = 128'd0;
        #20
        QueryRep(2'd1);
        #20
        rec.packet = 128'd0;
        #20
        QueryAdjust(2'd1,3'd1);
        #20
        rec.packet = 128'd0;
        #20
        Query(1'd1,2'd1,1'd0,2'd1,2'd1,1'd1,4'd1,5'd1);
        #20
        rec.packet = 128'd0;
        #20
        Select(3'd1,3'd1,2'd1,8'd1,8'd1,8'd1,1'd1,16'd1);
        #20
        rec.packet = 128'd0;
        #20
        nak();
        #20
        rec.packet = 128'd0;
        #20
        Req_RN(16'd1,16'd1);
        #20
        rec.packet = 128'd0;
        #20
        Read(2'd1,8'd1,8'd1,16'd1,16'd1);
        #20
        rec.packet = 128'd0;
        #20
        Write(2'd1,8'd1,16'd1,16'd1,16'd1);
        #40
        #20
        rec.packet = 128'd0;
        #20
        Kill(16'd1,3'd1,16'd1,16'd1);
        #40
        $finish; 
      end

    task start_up;
      begin
        #20 reset_n = 0;
        #10 reset_n = 1;
      end
    endtask
    
    task nak;
      begin
        #19 UL_data = 1;
        #1 clk_enable = 1;
        #9 UL_data = 1;
        #10 UL_data = 0;
        #60
        #11 clk_enable = 0;
      
      end
    endtask

    task ACK_Command;
      input [15:0] rd;
      begin
        #19 UL_data = 0;
        #1 clk_enable = 1;
        #9 UL_data = 1;
        for(i = 0; i < 16; i = i  + 1)
          begin
            #10
            UL_data = rd[15-i];
          end
        #11 clk_enable = 0;
      end
    endtask


    task QueryRep;
      input [1:0] rd;
      begin
        #19 UL_data = 0;
        #1 clk_enable = 1;
        #9 UL_data = 0;
        for(i = 0; i < 2; i = i  + 1)
          begin
            #10
            UL_data = rd[1-i];
          end
        #11 clk_enable = 0;
      end
    endtask

    task QueryAdjust;
      input [1:0] Session;
      input [2:0] Decrement;
      begin
        #19 UL_data = 1;
        #1 clk_enable = 1;
        #9 UL_data = 0;
        #10 UL_data = 0;
        #10 UL_data = 1;
        for(i = 0; i < 2; i = i  + 1)
          begin
            #10
            UL_data = Session[1-i];
          end
        for(i = 0; i < 3; i = i  + 1)
          begin
            #10
            UL_data = Decrement[2-i];
          end
        #11 clk_enable = 0;
      end
    endtask

    task Query;
      input divide_ratio;
      input [1:0] FM0; 
      input no_piot_tone;
      input [1:0] ic_selected;
      input [1:0] session;
      input inventory_flag;
      input [3:0] Q_value;
      input [4:0] CRC;
      begin
        #19 UL_data = 1;
        #1 clk_enable = 1;
        #9 UL_data = 0;
        #10 UL_data = 0;
        #10 UL_data = 0;
        #10 UL_data = divide_ratio;
        for(i = 0; i < 2; i = i  + 1)
          begin
            #10
            UL_data = FM0[1-i];
          end
        #10 UL_data = no_piot_tone;
        for(i = 0; i < 2; i = i  + 1)
          begin
            #10
            UL_data = ic_selected[1-i];
          end
        for(i = 0; i < 2; i = i  + 1)
          begin
            #10
            UL_data = session[1-i];
          end
        #10 UL_data = inventory_flag;
        for(i = 0; i < 4; i = i  + 1)
          begin
            #10
            UL_data = Q_value[3-i];
          end
        for(i = 0; i < 5; i = i  + 1)
          begin
            #10
            UL_data = CRC[4-i];
          end
        #11 clk_enable = 0;
      end
    endtask

    task Select;
      input [2:0] target;
      input [2:0] action; 
      input [1:0] epc;
      input [7:0] start_address;
      input [7:0] lenght;
      input [7:0] mask_value;
      input truncate;
      input [15:0] crc_16;
      begin
        #19 UL_data = 1;
        #1 clk_enable = 1;
        #9 UL_data = 0;
        #10 UL_data = 1;
        #10 UL_data = 0;
        for(i = 0; i < 3; i = i  + 1)
          begin
            #10
            UL_data = target[2-i];
          end
        for(i = 0; i < 3; i = i  + 1)
          begin
            #10
            UL_data = action[2-i];
          end
        for(i = 0; i < 2; i = i  + 1)
          begin
            #10
            UL_data = epc[1-i];
          end
        for(i = 0; i < 8; i = i  + 1)
          begin
            #10
            UL_data = start_address[7-i];
          end
        for(i = 0; i < 8; i = i  + 1)
          begin
            #10
            UL_data = lenght[7-i];
          end
        for(i = 0; i < 8; i = i  + 1)
          begin
            #10
            UL_data = mask_value[7-i];
          end
        #10 UL_data = truncate;
        for(i = 0; i < 16; i = i  + 1)
          begin
            #10
            UL_data = crc_16[15-i];
          end
        #11 clk_enable = 0;
      end
    endtask

    task Req_RN;
      input [15:0] rd;
      input [15:0] crc_16; 
      begin
        #19 UL_data = 1;
        #1 clk_enable = 1;
        #9 UL_data = 1;
        #10 UL_data = 0;
        #10 UL_data = 0;
        #10 UL_data = 0;
        #10 UL_data = 0;
        #10 UL_data = 0;
        #10 UL_data = 1;
        for(i = 0; i < 16; i = i  + 1)
          begin
            #10
            UL_data = rd[15-i];
          end
        for(i = 0; i < 16; i = i  + 1)
          begin
            #10
            UL_data = crc_16[15-i];
          end
        #11 clk_enable = 0;
      end
    endtask

    task Read;
      input [1:0] memBank;
      input [7:0] pointer; 
      input [7:0] number_of_words;
      input [15:0] handle;
      input [15:0] crc_16;
      begin
        #19 UL_data = 1;
        #1 clk_enable = 1;
        #9 UL_data = 1;
        #10 UL_data = 0;
        #10 UL_data = 0;
        #10 UL_data = 0;
        #10 UL_data = 0;
        #10 UL_data = 1;
        #10 UL_data = 0;
        for(i = 0; i < 2; i = i  + 1)
          begin
            #10
            UL_data = memBank[1-i];
          end
        for(i = 0; i < 8; i = i  + 1)
          begin
            #10
            UL_data = pointer[7-i];
          end
        for(i = 0; i < 8; i = i  + 1)
          begin
            #10
            UL_data = number_of_words[7-i];
          end
        for(i = 0; i < 16; i = i  + 1)
          begin
            #10
            UL_data = handle[15-i];
          end
        for(i = 0; i < 16; i = i  + 1)
          begin
            #10
            UL_data = crc_16[15-i];
          end
        #11 clk_enable = 0;
      end
    endtask

    task Write;
      input [1:0] memBank;
      input [7:0] wordPtr; 
      input [15:0] data;
      input [15:0] handle;
      input [15:0] crc_16;
      begin
        #19 UL_data = 1;
        #1 clk_enable = 1;
        #9 UL_data = 1;
        #10 UL_data = 0;
        #10 UL_data = 0;
        #10 UL_data = 0;
        #10 UL_data = 0;
        #10 UL_data = 1;
        #10 UL_data = 1;
        for(i = 0; i < 2; i = i  + 1)
          begin
            #10
            UL_data = memBank[1-i];
          end
        for(i = 0; i < 8; i = i  + 1)
          begin
            #10
            UL_data = wordPtr[7-i];
          end
        for(i = 0; i < 16; i = i  + 1)
          begin
            #10
            UL_data = data[15-i];
          end
        for(i = 0; i < 16; i = i  + 1)
          begin
            #10
            UL_data = handle[15-i];
          end
        for(i = 0; i < 16; i = i  + 1)
          begin
            #10
            UL_data = crc_16[15-i];
          end
        #11 clk_enable = 0;
      end
    endtask

    task Kill;
      input [15:0] password; 
      input [2:0] RFU;
      input [15:0] handle;
      input [15:0] crc_16;
      begin
        #19 UL_data = 1;
        #1 clk_enable = 1;
        #9 UL_data = 1;
        #10 UL_data = 0;
        #10 UL_data = 0;
        #10 UL_data = 0;
        #10 UL_data = 1;
        #10 UL_data = 0;
        #10 UL_data = 0;
        for(i = 0; i < 16; i = i  + 1)
          begin
            #10
            UL_data = password[15-i];
          end
        for(i = 0; i < 3; i = i  + 1)
          begin
            #10
            UL_data = RFU[2-i];
          end
        for(i = 0; i < 16; i = i  + 1)
          begin
            #10
            UL_data = handle[15-i];
          end
        for(i = 0; i < 16; i = i  + 1)
          begin
            #10
            UL_data = crc_16[15-i];
          end
        #11 clk_enable = 0;
      end
    endtask

endmodule  
