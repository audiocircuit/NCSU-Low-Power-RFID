module slave(
  input wire [6:0] my_addr,
  input wire [7:0] measurement,
  input wire en,
  input wire reset,
  input wire scl,
  inout wire sda
  );

  reg stop, start, mode;  
  reg [7:0] input_buffer; 
  reg [6:0] input_address;
  reg [2:0] state; 
  reg [4:0] counter; 
  reg sda_output, sda_out;
  reg sda_enable, sda_en;

  assign sda = (sda_enable) ? ( sda_output ) ? 1'bz : 1'b0 : 1'bz;
  assign sda_in = sda;

  always@( negedge scl or negedge reset )
    begin
      if( !reset )
        begin
          sda_enable <= 0;
          sda_output <= 0;
        end
      else
        begin
          sda_enable <= sda_en;
          sda_output <= sda_out;
        end
    end

  always@( negedge sda )
    begin
      if( scl )
        begin
          start <= 1;
        end
      else
        begin
          start <= 0;
        end
    end


  always@( posedge sda )
    begin
      if( scl )
        begin
          stop <= 1;
        end
      else
        begin
          stop <= 0;
        end
    end
    
    always@(posedge scl or negedge reset)
      begin
        if( ~reset )
          begin
            state <= 0;
          end
        else
          begin
            case( state )
              0:
                begin
                  if( start && en )
                    begin
                      state <=1;
                      input_address <= {input_address, sda};
                      counter <= 0;
                      mode <= 0;
                      input_buffer <= 0;
                      sda_en <= 0;
                      sda_out <= 0;
                    end
                  else
                    begin
                      state <= 0;
                      input_address <= 0;
                      counter <= 0;
                      mode <= 0;
                      input_buffer <= 0;
                      sda_en <= 0;
                      sda_out <= 0;
                   end
                end
              1:
                begin
                  if(counter < 6 )
                    begin
                      state <= 1;
                      input_address <= {input_address, sda};
                      counter <= counter +1;
                      mode <= 0;
                      input_buffer <= 0;
                      sda_en <= 0;
                      sda_out <= 0;
                    end
                  else
                    begin
                      if(input_address == my_addr)
                        begin
                          if( sda )
                            begin
                              state <= 2;
                              input_address <= 0;
                              counter <= 0;
                              mode <= sda;
                              input_buffer <= 0;
                              sda_en <= 1;
                              sda_out <= 0;
                         end
                          else
                            begin
                              state <= 3;
                              input_address <= 0;
                              counter <= 0;
                              mode <= sda;
                              input_buffer <= 0;
                              sda_en <= 1;
                              sda_out <= 0;
                            end
                        end
                      else
                        begin
                          state <= 0;
                          input_address <= 0;
                          counter <= 0;
                          mode <= 0;
                          input_buffer <= 0;
                          sda_en <= 0;
                          sda_out <= 0;
                        end
                    end
                end
              2:
                begin
                  if( !stop )
                    begin
                      if( counter < 8 )
                        begin
                          state <= 2;
                          input_address <= 0;
                          counter <= counter + 1;
                          mode <= 0;
                          input_buffer <= 0;
                          sda_en <= 1;
                          sda_out <= measurement[7 - counter];
                        end
                      else
                        begin
                          state <= 4;
                          input_address <= 0;
                          counter <= 0;
                          mode <= 0;
                          input_buffer <= 0;
                          sda_en <= 0;
                          sda_out <= 0;
                        end
                    end
                  else
                    begin
                      state <= 0;
                      input_address <= 0;
                      counter <= 0;
                      mode <= 0;
                      input_buffer <= 0;
                      sda_en <= 0;
                      sda_out <= 0;                   
                    end
                end
              3:
                begin
                  if( !stop )
                    begin
                      if( counter < 7 )
                        begin
                          state <= 3;
                          input_address <= 0;
                          counter <= counter + 1;
                          mode <= 0;
                          input_buffer <= {input_buffer, sda};
                          sda_en <= 0;
                          sda_out <= 0;
                        end
                      else if(counter == 7)
                        begin
                          state <= 3;
                          input_address <= 0;
                          counter <= counter +1;
                          mode <= 0;
                          input_buffer <= {input_buffer,sda};
                          sda_en <= 0;
                          sda_out <= 0;
                        end
                      else
                        begin
                          state <= 3;
                          input_address <= 0;
                          counter <= 0;
                          mode <= 0;
                          input_buffer <= 0;
                          sda_en <= 1;
                          sda_out <= 0;
                        end
                   end
                  else
                    begin
                      state <= 0;
                      input_address <= 0;
                      counter <= 0;
                      mode <= 0;
                      input_buffer <= 0;
                      sda_en <= 0;
                      sda_out <= 0;                   
                    end
                end
              4:
                begin
                  if( sda )
                    begin
                      state <= 0;
                      input_address <= 0;
                      counter <= 0;
                      mode <= 0;
                      input_buffer <= 0;
                      sda_en <= 0;
                      sda_out <= 0;
                   end
                  else
                    begin
                      state <= 2;
                      input_address <= 0;
                      counter <= counter + 1;
                      mode <= mode;
                      input_buffer <= 0;
                      sda_en <= 1;
                      sda_out <= measurement[7 - counter];
                  end
                end
              5:
                begin
                  state <= 3;
                  input_address <= 0;
                  counter <= 0;
                  mode <= mode;
                  input_buffer <= 0;
                  sda_en <= 0;
                  sda_out <= 0;
                end
            endcase
          end
      end
endmodule
