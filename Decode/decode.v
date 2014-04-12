module decode(
  input wire clock,
  input wire reset_n,
  input wire [15:0] op_code_bus,
  input wire [15:0] user_data_bus,
  
 



  );

  always@(posedge clock or negedge reset_n)
    begin
      if(reset_n)
        begin
          op_code <= 4'b0;
          user_data <= 16'b0
          op_valid <= 1'd0;
        end
      else
        begin
          case(op_code_bus[15:12])
            CONFIG_LOOKUP:
              begin
                op_code <= 4'b0;
                user_data <= 16'b0;
                if(op_valid)
            CONFIG_SENSOR:
            DEFAULT_SENSOR:
            default:
          endcase
        end
    end
    

endmodule
