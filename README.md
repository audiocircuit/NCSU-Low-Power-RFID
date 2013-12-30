NCSU-Low-Power-RFID
===================

Joshua Stevens
Burton Younts
Scott Johnson


Verilog code for a low power RFID chip that will communicate with I2C sensors.

We are using Modelsim to compile: <br>
  "add cadence2010" <br>
  "ncverilog <i>filename.v"<br>

How to run Quartus:<br>
  "add quartus111"<br>
  "quartus &" MUST Be running X-win32 for this step <br>


Set up Modelsim in EOS: <br>
  "add modelsim10.0c" <br>
  "setenv MODELSIM modelsim.ini"<br>

Compile Verilog and Run Simulation: <br>
  "vlog *.v"<br>
  "vsim -novopt <i>testbench_name.v</i>"<br>
  Inside vsim program: "log -r *"<br>
                       "run -all"<br>
                       
  **NOTE: to rerun in vsim: "vlog *.v"<br>
                            "restart -f"<br>
                            "run -all"<br>
