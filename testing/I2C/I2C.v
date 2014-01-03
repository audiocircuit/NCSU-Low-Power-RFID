module I2C(
  input wire [6:0] address,
  input wire [7:0] register, 
  input wire clk,  
  input wire mode,
  input wire en,
  input wire reset,
  input wire Start,
  input wire Stop,
  input wire repeat_start,
  output reg [7:0] out,
  output reg ack,
  inout wire sda,
  inout wire scl
);

  reg [3:0] state;
  reg [4:0] counter;
  wire clk_4x;
  wire clk_4x_offset;

  wire sda_in, scl_in;
  reg sda_enable, sda_out, scl_enable, scl_out, clk_enable, sda_output, sda_en;

  assign sda = ( sda_en ) ? (sda_output) ? 1'bz : 1'b0 : 1'bz;
  assign sda_in = sda;
  assign scl = ( scl_enable ) ?  ( clk_enable ) ? (clk_4x_offset) ? 1'bz : 1'b0 :  scl_out : 1'bZ;
  assign scl_in = scl;

  clock_divider4 clk_u1 (clk, reset, en, clk_4x); 
  clock_divider4_offset clk_u2 (clk, reset, en, clk_4x_offset);

  always@(posedge clk_4x)
    begin
      sda_en <= sda_enable;
      sda_output <= sda_out;
    end
  

  always@(posedge clk_4x_offset or negedge reset)
    begin
      if( ~reset )
        begin
          state <= 0;
          sda_enable <= 0;
          sda_out <= 0;
          scl_enable <= 0;
          clk_enable <= 0;
          scl_out <= 0;
          out <= 0;
          counter <= 0;
          ack <= 1'b0;
        end
      else
        begin
          case( state )
            0:
              begin
                if((( Start || repeat_start ) ) && ( en ))
                  begin
                    state <= 1;
                    sda_enable <= 1'b1;
                    sda_out <= 1'b0;
                    scl_enable <= 1'b0;
                    clk_enable <= 1'b1;
                    scl_out <= 1'b0;
                    out <= out;
                    counter <= 0;
                    ack <= 1'b0;
                  end
                else
                  begin
                    state <= 0;
                    sda_enable <= 1'b0;
                    sda_out <= 1'b0;
                    scl_enable <= 1'b0;
                    clk_enable <= 1'b0;
                    scl_out <= 1'b0;
                    out <= out;
                    counter <= 0;
                    ack <= 1'b0;
                  end
              end
            1:
              begin
                if(counter < 7)
                  begin
                    state <= 1;
                    sda_enable <= 1'b1;
                    sda_out <= address[6-counter];
                    scl_enable <= 1'b1;
                    clk_enable <= 1'b1;
                    scl_out <= 1'b0;
                    out <= out;
                    counter <= counter + 1;
                    ack <= 1'b0;
                  end
                else
                   begin
                    state <= 2;
                    sda_enable <= 1'b1;
                    sda_out <= mode;
                    scl_enable <= 1'b1;
                    clk_enable <= 1'b1;
                    scl_out <= 1'b0;
                    out <= out;
                    counter <= 0;
                    ack <= 1'b0;
                  end    
              end
            2:
              begin
                state <= 3;
                sda_enable <= 1'b0;
                sda_out <= 0;
                scl_enable <= 1'b1;
                clk_enable <= 1'b1;
                scl_out <= 1'b0;
                out <= out;
                counter <= 0;
                ack <= 1'b1;
              end
            3:
              begin
                if( ~sda_in )
                  begin
                    if( mode )
                      begin
                        state <= 4;
                        sda_enable <= 1'b0;
                        sda_out <= 0;
                        scl_enable <= 1'b1;
                        clk_enable <= 1'b1;
                        scl_out <= 1'b0;
                        out <= out;
                        counter <= 0;
                        ack <= 1'b0;
                      end
                    else
                      begin
                        state <= 5;
                        sda_enable <= 1'b1;
                        sda_out <= register[7 - counter];
                        scl_enable <= 1'b1;
                        clk_enable <= 1'b1;
                        scl_out <= 1'b0;
                        out <= out;
                        counter <= counter + 1;
                        ack <= 1'b0;
                      end
                  end
                else
                  begin
                    state <= 15;
                    sda_enable <= 1'b1;
                    sda_out <= 0;
                    scl_enable <= 1'b1;
                    clk_enable <= 1'b0;
                    scl_out <= 1'b1;
                    out <= out;
                    counter <= 0;
                    ack <= 1'b0;
                  end
              end
           4:
              begin
                 if(counter < 7)
                  begin
                    state <= 4;
                    sda_enable <= 1'b0;
                    sda_out <= 1'b0;
                    scl_enable <= 1'b1;
                    clk_enable <= 1'b1;
                    scl_out <= 1'b0;
                    out[7-counter] <= sda_in;
                    counter <= counter + 1;
                    ack <= 1'b0;
                 end
                else
                  begin
                    if( Stop )
                      begin
                        state <= 7;
                        sda_enable <= 1'b1;
                        sda_out <= 1'b1;
                        scl_enable <= 1'b1;
                        clk_enable <= 1'b1;
                        scl_out <= 1'b0;
                        out[7-counter] <= sda_in;
                        counter <= 0;
                        ack <= 1'b1;
                      end
                    else
                      begin
                        state <= 8;
                        sda_enable <= 1'b1;
                        sda_out <= 1'b0;
                        scl_enable <= 1'b1;
                        clk_enable <= 1'b1;
                        scl_out <= 1'b0;
                        out[7-counter] <= sda_in;
                        counter <= 0;
                        ack <= 1'b1;
                      end 
                  end    
              end
            5:
              begin
                if(counter < 8)
                  begin
                    state <= 5;
                    sda_enable <= 1'b1;
                    sda_out <= register[7 - counter];
                    scl_enable <= 1'b1;
                    clk_enable <= 1'b1;
                    scl_out <= 1'b0;
                    out <= out;
                    counter <= counter + 1;
                    ack <= 1'b0;
                 end
                else
                   begin
                    state <= 6;
                    sda_enable <= 1'b0;
                    sda_out <= 1'b0;
                    scl_enable <= 1'b1;
                    clk_enable <= 1'b1;
                    scl_out <= 1'b0;
                    out <= out;
                    counter <= 0;
                    ack <= 1'b1;
                  end                   
              end
            6:
              begin
                if(( Stop ) || ( sda_in ))
                  begin
                    state <= 15;
                    sda_enable <= 1'b1;
                    sda_out <= 0;
                    scl_enable <= 1'b1;
                    clk_enable <= 1'b0;
                    scl_out <= 1'b1;
                    out <= out;
                    counter <= 0;
                    ack <= 1'b0;
                  end 
                else if( repeat_start )
                  begin
                    state <= 0;
                    sda_enable <= 1'b1;
                    sda_out <= 1;
                    scl_enable <= 1'b1;
                    clk_enable <= 1'b0;
                    scl_out <= 1'b1;
                    out <= out;
                    counter <= 0;              
                    ack <= 1'b0;
                 end
                else
                  begin
                    state <= 5;
                    sda_enable <= 1'b1;
                    sda_out <= register[7 - counter];
                    scl_enable <= 1'b1;
                    clk_enable <= 1'b1;
                    scl_out <= 1'b0;
                    out <= out;
                    counter <= counter + 1;
                    ack <= 1'b0;
                 end
              end
            7:
              begin
                state <= 15;
                sda_enable <= 1'b1;
                sda_out <= 0;
                scl_enable <= 1'b1;
                clk_enable <= 1'b0;
                scl_out <= 1'b1;
                out <= out;
                counter <= 0;              
                ack <= 1'b0;
             end
            8:
              begin
                if( repeat_start )
                  begin
                    state <= 0;
                    sda_enable <= 1'b1;
                    sda_out <= 1;
                    scl_enable <= 1'b1;
                    clk_enable <= 1'b0;
                    scl_out <= 1'b1;
                    out <= out;
                    counter <= 0;              
                    ack <= 1'b0;
                 end
                else
                  begin
                    state <= 4;
                    sda_enable <= 1'b0;
                    sda_out <= 0;
                    scl_enable <= 1'b1;
                    clk_enable <= 1'b1;
                    scl_out <= 1'b0;
                    out <= out;
                    counter <= 0; 
                    ack <= 1'b0;
                 end
             end
          15:
              begin
                state <= 15;
                sda_enable <= 1'b0;
                sda_out <= 0;
                scl_enable <= 1'b0;
                clk_enable <= 1'b0;
                scl_out <= 1'b1;
                out <= out;
                counter <= 0;
                ack <= 1'b0;
             end 
          endcase
        end

    end



endmodule
