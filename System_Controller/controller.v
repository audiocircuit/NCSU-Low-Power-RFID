/*************************************************
Christopher Scott Johsnon

MODULE: controller
DESCRIPTION: This module controls the state of the overall RFID Chip. 
    When no OP Codes are being received, this controller will cycle through
    all sensors putting their readings into RFID User Memory (Bank 3).
************************************************/
module controller(
  input clock,
  input rst_n,
  //Wr_Sensor inputs and outputs
  input [7:0]readVal_I2C,
  input dataRdy_I2C,
  output reg [6:0]sensorAddr_I2C,
  output reg [7:0]writeVal_I2C,
  output reg mode_I2C,
  output reg start_I2C,
  //EEPROM inputs and outputs
  input [15:0] readBus_userMem,
  output reg we_userMem,
  output reg [14:0]writeAddr_userMem,
  output reg [15:0]writeBus_userMem,
  output reg [14:0]readAddr_userMem
);

//parameters for state machine
parameter RESET                 = 0;
parameter GET_SENSOR0_INFO      = 1;
parameter GET_SENSOR1_INFO      = 2;
parameter GET_SENSOR2_INFO      = 3;
parameter GET_SENSOR3_INFO      = 4;
parameter WRITE_SENSOR_CB_READ  = 5;
parameter START_READ_SENSOR_VAL = 6;
parameter READ_SENSOR_VAL       = 7;
parameter LOOKUP_SENSOR_VAL     = 8;
parameter WRITE_TO_USERMEM      = 9;
parameter INCREMENT_SENSOR      = 10;

//parameters for readability
parameter I2C_WRITE             = 1'b0;
parameter I2C_READ              = 1'b1;

reg test;

//define reg/wires
reg [5:0] state;
reg [15:0] sensorInfo [0:3];
reg [1:0]readSensor;

//State machine control logic
always@(posedge clock or negedge rst_n) begin
  if(!rst_n) begin
    state <= RESET;
  end else begin
    case(state)
      RESET: begin
        readSensor <= 2'b0;  
        sensorInfo[0] <= 16'b0;
        sensorInfo[1] <= 16'b0;
        sensorInfo[2] <= 16'b0;
        sensorInfo[3] <= 16'b0;
        state <= GET_SENSOR0_INFO; 

        test <= 0;
      end

      GET_SENSOR0_INFO: begin
        readSensor <= 2'b0;
        sensorInfo[0] <= readBus_userMem;
        sensorInfo[1] <= 16'b0;
        sensorInfo[2] <= 16'b0;
        sensorInfo[3] <= 16'b0;
        state <= GET_SENSOR1_INFO;
        
        test <= ~test;
      end

      GET_SENSOR1_INFO: begin
        readSensor <= 2'b0;
        sensorInfo[0] <= sensorInfo[0];
        sensorInfo[1] <= readBus_userMem;
        sensorInfo[2] <= 16'b0;
        sensorInfo[3] <= 16'b0;
        state <= GET_SENSOR2_INFO;

        test <= ~test;
      end

      GET_SENSOR2_INFO: begin
        readSensor <= 2'b0;
        sensorInfo[0] <= sensorInfo[0];
        sensorInfo[1] <= sensorInfo[1];
        sensorInfo[2] <= readBus_userMem;
        sensorInfo[3] <= 16'b0;
        state <= GET_SENSOR3_INFO;
      end

      GET_SENSOR3_INFO: begin
        readSensor <= 2'b0;
        sensorInfo[0] <= sensorInfo[0];
        sensorInfo[1] <= sensorInfo[1];
        sensorInfo[2] <= sensorInfo[2];
        sensorInfo[3] <= readBus_userMem;
        state <= WRITE_SENSOR_CB_READ;
      end

      WRITE_SENSOR_CB_READ: begin
        readSensor <= readSensor + 1'b0;
        sensorInfo[0] <= sensorInfo[0];
        sensorInfo[1] <= sensorInfo[1];
        sensorInfo[2] <= sensorInfo[2];
        sensorInfo[3] <= sensorInfo[3];
        if(dataRdy_I2C) begin
          state <= START_READ_SENSOR_VAL;
        end else begin
          state <= WRITE_SENSOR_CB_READ;
        end
      end
      
      START_READ_SENSOR_VAL: begin
        readSensor <= readSensor + 1'b0;
        sensorInfo[0] <= sensorInfo[0];
        sensorInfo[1] <= sensorInfo[1];
        sensorInfo[2] <= sensorInfo[2];
        sensorInfo[3] <= sensorInfo[3];
        state <= READ_SENSOR_VAL;
      end

      READ_SENSOR_VAL: begin
        readSensor <= readSensor + 1'b0;
        sensorInfo[0] <= sensorInfo[0];
        sensorInfo[1] <= sensorInfo[1];
        sensorInfo[2] <= sensorInfo[2];
        sensorInfo[3] <= sensorInfo[3];
        if(dataRdy_I2C) begin
          state <= LOOKUP_SENSOR_VAL;
        end else begin
          state <= READ_SENSOR_VAL;
        end
      end

      LOOKUP_SENSOR_VAL: begin
        readSensor <= readSensor + 1'b0;
        sensorInfo[0] <= sensorInfo[0];
        sensorInfo[1] <= sensorInfo[1];
        sensorInfo[2] <= sensorInfo[2];
        sensorInfo[3] <= sensorInfo[3];
        state <= WRITE_TO_USERMEM;
      end

      WRITE_TO_USERMEM: begin
        readSensor <= readSensor + 1'b0;
        sensorInfo[0] <= sensorInfo[0];
        sensorInfo[1] <= sensorInfo[1];
        sensorInfo[2] <= sensorInfo[2];
        sensorInfo[3] <= sensorInfo[3];
        state <= INCREMENT_SENSOR;
      end

      INCREMENT_SENSOR: begin
        readSensor <= readSensor + 1'b1;
        sensorInfo[0] <= sensorInfo[0];
        sensorInfo[1] <= sensorInfo[1];
        sensorInfo[2] <= sensorInfo[2];
        sensorInfo[3] <= sensorInfo[3];
        state <= WRITE_SENSOR_CB_READ;
      end
    endcase
  end
end


always@(*) begin
  case(state)
    RESET: begin
      sensorAddr_I2C <= 7'b0;
      writeVal_I2C <= 8'b0;
      mode_I2C <= 1'b0;
      start_I2C <= 1'b0;
      we_userMem <= 1'b0;
      writeAddr_userMem <= 15'b0;
      writeBus_userMem <= 16'b0;
      readAddr_userMem <= 15'b100_0000_0000_0000;
    end

    GET_SENSOR0_INFO: begin
      sensorAddr_I2C <= 7'b0;
      writeVal_I2C <= 8'b0;
      mode_I2C <= 1'b0;
      start_I2C <= 1'b0;
      we_userMem <= 1'b0;
      writeAddr_userMem <= 15'b0;
      writeBus_userMem <= 16'b0;
      readAddr_userMem <= 15'b100_0000_0000_0000;
    end

    GET_SENSOR1_INFO: begin
      sensorAddr_I2C <= 7'b0;
      writeVal_I2C <= 8'b0;
      mode_I2C <= 1'b0;
      start_I2C <= 1'b0;
      we_userMem <= 1'b0;
      writeAddr_userMem <= 15'b0;
      writeBus_userMem <= 16'b0;
      readAddr_userMem <= 15'b100_0000_0001_0000;
    end

    GET_SENSOR2_INFO: begin
      sensorAddr_I2C <= 7'b0;
      writeVal_I2C <= 8'b0;
      mode_I2C <= 1'b0;
      start_I2C <= 1'b0;
      we_userMem <= 1'b0;
      writeAddr_userMem <= 15'b0;
      writeBus_userMem <= 16'b0;
      readAddr_userMem <= 15'b100_0000_0010_0000;
    end

    GET_SENSOR3_INFO: begin
      sensorAddr_I2C <= 7'b0;
      writeVal_I2C <= 8'b0;
      mode_I2C <= 1'b0;
      start_I2C <= 1'b0;
      we_userMem <= 1'b0;
      writeAddr_userMem <= 15'b0;
      writeBus_userMem <= 16'b0;
      readAddr_userMem <= 15'b100_0000_0011_0000;
    end

    WRITE_SENSOR_CB_READ: begin
      sensorAddr_I2C <= sensorInfo[readSensor][7:1];
      writeVal_I2C <= sensorInfo[readSensor][15:8];
      mode_I2C <= I2C_WRITE;
      start_I2C <= 1'b1;
      we_userMem <= 1'b0;
      writeAddr_userMem <= 16'b0;
      writeBus_userMem <= 16'b0;
      readAddr_userMem <= 16'b0;
    end


    START_READ_SENSOR_VAL: begin
      sensorAddr_I2C <= sensorInfo[readSensor][7:1];
      writeVal_I2C <= 8'b0;
      mode_I2C <= I2C_READ;
      start_I2C <= 1'b1;
      we_userMem <= 1'b0;
      writeAddr_userMem <= 16'b0;
      writeBus_userMem <= 16'b0;
      readAddr_userMem <= 16'b0;
    end

    READ_SENSOR_VAL: begin
      sensorAddr_I2C <= sensorInfo[readSensor][7:1];
      writeVal_I2C <= 8'b0;
      mode_I2C <= I2C_READ;
      start_I2C <= 1'b1;
      we_userMem <= 1'b0;
      writeAddr_userMem <= 16'b0;
      writeBus_userMem <= 16'b0;
      readAddr_userMem <= 16'b0;
    end

    LOOKUP_SENSOR_VAL: begin
      sensorAddr_I2C <= 7'b0;
      writeVal_I2C <= 8'b0;
      mode_I2C <= 1'b0;
      start_I2C <= 1'b0;
      we_userMem <= 1'b0;
      writeAddr_userMem <= 16'b0;
      writeBus_userMem <= 16'b0;
      readAddr_userMem <= {1'b0,readSensor,4'b0,readVal_I2C};
    end

    WRITE_TO_USERMEM: begin
      sensorAddr_I2C <= 7'b0;
      writeVal_I2C <= 8'b0;
      mode_I2C <= 1'b0;
      start_I2C <= 1'b0;
      we_userMem <= 1'b1;
      writeAddr_userMem <= writeAddr_userMem;
      writeBus_userMem <= readBus_userMem;
      readAddr_userMem <= 15'b0;
    end

    INCREMENT_SENSOR: begin
      sensorAddr_I2C <= 7'b0;
      writeVal_I2C <= 8'b0;
      mode_I2C <= 1'b0;
      start_I2C <= 1'b0;
      we_userMem <= 1'b1;
      writeAddr_userMem <= writeAddr_userMem;
      writeBus_userMem <= writeBus_userMem;
      readAddr_userMem <= 15'b0;
    end
  endcase
end

endmodule
