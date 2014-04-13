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
  //decode_OP inputs and outputs
  input [1:0]sensor_num,
  input [2:0]op_code,
  input [15:0]data_Decode,
  input dataRdy_Decode,
  //Wr_Sensor inputs and outputs
  input [7:0]readVal_I2C,
  input dataRdy_I2C,
  output reg [6:0]sensorAddr_I2C,
  output reg [7:0]writeVal_I2C,
  output reg mode_I2C,
  output reg start_I2C,
  //User Memory inputs and outputs
  output reg we_userMem,
  output reg [15:0] writeAddr_userMem,
  output reg [15:0] writeBus_userMem,
  //EEPROM inputs and outputs
  input [15:0] readBus_EEPROM,
  output reg we_EEPROM,
  output reg [15:0]writeAddr_EEPROM,
  output reg [15:0]writeBus_EEPROM,
  output reg [17:0]readAddr_EEPROM
);

//parameters for state machine
parameter RESET                 = 0;
parameter GET_SENSOR0_INFO      = 1;
parameter GET_SENSOR1_INFO      = 2;
parameter GET_SENSOR2_INFO      = 3;
parameter GET_SENSOR3_INFO      = 4;
parameter WRITE_SENSOR_CB_READ  = 5;
parameter READ_SENSOR_VAL       = 6;
parameter LOOKUP_SENSOR_VAL     = 7;
parameter WRITE_TO_USERMEM      = 8;
parameter INCREMENT_SENSOR      = 9;

//parameters for readability
parameter I2C_WRITE             = 0;
parameter I2C_READ              = 1;

//define reg/wires
reg [5:0] cstate, nstate;
reg [15:0] sensorInfo [0:3];
reg [1:0]readSensor;

always@(posedge clock or negedge rst_n) begin
  if(!rst_n) begin
    cstate <= RESET;
  end else begin
    cstate <= nstate;
  end
end

always@(*) begin
  case(cstate)
    RESET: begin
      sensorAddr_I2C <= 0;
      writeVal_I2C <= 0;
      mode_I2C <= 0;
      start_I2C <= 0;
      we_userMem <= 0;
      writeAddr_userMem <= 0;
      writeBus_userMem <= 0;
      we_EEPROM <= 0;
      writeAddr_EEPROM <= 0;
      writeBus_EEPROM <= 0;
      readAddr_EEPROM <= 16'b1_000_000000000000;
      sensorInfo[0] <= 16'b0;
      sensorInfo[1] <= 16'b0;
      sensorInfo[2] <= 16'b0;
      sensorInfo[3] <= 16'b0;
      readSensor <= 0;
      
      nstate <= GET_SENSOR0_INFO;
    end
    
    //Get Sensor0 Address, I2C Control Byte, and Default Sensor
    GET_SENSOR0_INFO: begin
      sensorAddr_I2C <= 0;
      writeVal_I2C <= 0;
      mode_I2C <= 0;
      start_I2C <= 0;
      we_userMem <= 0;
      writeAddr_userMem <= 0;
      writeBus_userMem <= 0;
      we_EEPROM <= 0;
      writeAddr_EEPROM <= 0;
      writeBus_EEPROM <= 0;
      readAddr_EEPROM <= 16'b1_001_000000000000;
      sensorInfo[0] <= readBus_EEPROM;
      sensorInfo[1] <= 16'b0;
      sensorInfo[2] <= 16'b0;
      sensorInfo[3] <= 16'b0;
      readSensor <= readSensor;

      nstate <= GET_SENSOR1_INFO;
    end

    //Get Sensor1 Address, I2C Control Byte, and Default Sensor
    GET_SENSOR1_INFO: begin
      sensorAddr_I2C <= 0;
      writeVal_I2C <= 0;
      mode_I2C <= 0;
      start_I2C <= 0;
      we_userMem <= 0;
      writeAddr_userMem <= 0;
      writeBus_userMem <= 0;
      we_EEPROM <= 0;
      writeAddr_EEPROM <= 0;
      writeBus_EEPROM <= 0;
      readAddr_EEPROM <= 16'b1_010_000000000000;
      sensorInfo[0] <= sensorInfo[0];
      sensorInfo[1] <= readBus_EEPROM;
      sensorInfo[2] <= 16'b0;
      sensorInfo[3] <= 16'b0;
      readSensor <= readSensor;

      nstate <= GET_SENSOR2_INFO;
    end
    
    //Get Sensor2 Address, I2C Control Byte, and Default Sensor
    GET_SENSOR2_INFO: begin
      sensorAddr_I2C <= 0;
      writeVal_I2C <= 0;
      mode_I2C <= 0;
      start_I2C <= 0;
      we_userMem <= 0;
      writeAddr_userMem <= 0;
      writeBus_userMem <= 0;
      we_EEPROM <= 0;
      writeAddr_EEPROM <= 0;
      writeBus_EEPROM <= 0;
      readAddr_EEPROM <= 16'b1_011_000000000000;
      sensorInfo[0] <= sensorInfo[0];
      sensorInfo[1] <= sensorInfo[1];
      sensorInfo[2] <= readBus_EEPROM;
      sensorInfo[3] <= 16'b0;
      readSensor <= readSensor;

      nstate <= GET_SENSOR3_INFO;

    end

    //Get Sensor3 Address, I2C Control Byte, and Default Sensor
    GET_SENSOR3_INFO: begin
      sensorAddr_I2C <= 0;
      writeVal_I2C <= 0;
      mode_I2C <= 0;
      start_I2C <= 0;
      we_userMem <= 0;
      writeAddr_userMem <= 0;
      writeBus_userMem <= 0;
      we_EEPROM <= 0;
      writeAddr_EEPROM <= 0;
      writeBus_EEPROM <= 0;
      readAddr_EEPROM <= 16'b1_011_000000000000;
      sensorInfo[0] <= sensorInfo[0];
      sensorInfo[1] <= sensorInfo[1];
      sensorInfo[2] <= sensorInfo[2];
      sensorInfo[3] <= readBus_EEPROM; 
      readSensor <= readSensor;

      nstate <= WRITE_SENSOR_CB_READ;
    end

    WRITE_SENSOR_CB_READ: begin
      sensorAddr_I2C <= sensorInfo[readSensor][7:1];
      writeVal_I2C <= sensorInfo[readSensor][15:8];
      mode_I2C <= I2C_WRITE;
      start_I2C <= 1;
      we_userMem <= 0;
      writeAddr_userMem <= 0;
      writeBus_userMem <= 0;
      we_EEPROM <= 0;
      writeAddr_EEPROM <= 0;
      writeBus_EEPROM <= 0;
      readAddr_EEPROM <= 0;
      sensorInfo[0] <= sensorInfo[0];
      sensorInfo[1] <= sensorInfo[1];
      sensorInfo[2] <= sensorInfo[2];
      sensorInfo[3] <= sensorInfo[3];
      readSensor <= readSensor;

      nstate <= READ_SENSOR_VAL;
    end

    READ_SENSOR_VAL: begin
      sensorAddr_I2C <= sensorInfo[readSensor][7:1];
      writeVal_I2C <= 0;
      mode_I2C <= I2C_READ;
      start_I2C <= 1;
      we_userMem <= 0;
      writeAddr_userMem <= 0;
      writeBus_userMem <= 0;
      we_EEPROM <= 0;
      writeAddr_EEPROM <= 0;
      writeBus_EEPROM <= 0;
      readAddr_EEPROM <= 0;
      sensorInfo[0] <= sensorInfo[0];
      sensorInfo[1] <= sensorInfo[1];
      sensorInfo[2] <= sensorInfo[2];
      sensorInfo[3] <= sensorInfo[3];
      readSensor <= readSensor;

      nstate <= LOOKUP_SENSOR_VAL;
    end

    LOOKUP_SENSOR_VAL: begin
      sensorAddr_I2C <= 0;
      writeVal_I2C <= 0;
      mode_I2C <= 0;
      start_I2C <= 0;
      we_userMem <= 0;
      writeAddr_userMem <= 0;
      writeBus_userMem <= 0;
      we_EEPROM <= 0;
      writeAddr_EEPROM <= 0;
      writeBus_EEPROM <= 0;
      readAddr_EEPROM <= {0,readSensor,readVal_I2C};
      sensorInfo[0] <= sensorInfo[0];
      sensorInfo[1] <= sensorInfo[1];
      sensorInfo[2] <= sensorInfo[2];
      sensorInfo[3] <= sensorInfo[3];
      readSensor <= readSensor;

      nstate <= WRITE_TO_USERMEM;
    end

    WRITE_TO_USERMEM: begin
      sensorAddr_I2C <= 0;
      writeVal_I2C <= 0;
      mode_I2C <= 0;
      start_I2C <= 0;
      we_userMem <= 1;
      writeAddr_userMem <= readSensor;
      writeBus_userMem <= readBus_EEPROM[15:0];
      we_EEPROM <= 0;
      writeAddr_EEPROM <= 0;
      writeBus_EEPROM <= 0;
      readAddr_EEPROM <= readAddr_EEPROM;
      sensorInfo[0] <= sensorInfo[0];
      sensorInfo[1] <= sensorInfo[1];
      sensorInfo[2] <= sensorInfo[2];
      sensorInfo[3] <= sensorInfo[3];
      readSensor <= readSensor;

      nstate <= INCREMENT_SENSOR;
    end

    INCREMENT_SENSOR: begin
      sensorAddr_I2C <= 0;
      writeVal_I2C <= 0;
      mode_I2C <= 0;
      start_I2C <= 0;
      we_userMem <= 1;
      writeAddr_userMem <= writeAddr_userMem;
      writeBus_userMem <= writeBus_userMem;
      we_EEPROM <= 0;
      writeAddr_EEPROM <= 0;
      writeBus_EEPROM <= 0;
      readAddr_EEPROM <= readAddr_EEPROM;
      sensorInfo[0] <= sensorInfo[0];
      sensorInfo[1] <= sensorInfo[1];
      sensorInfo[2] <= sensorInfo[2];
      sensorInfo[3] <= sensorInfo[3];
      readSensor <= readSensor + 1;

      nstate <= WRITE_SENSOR_CB_READ;
    end
  endcase
end

endmodule
