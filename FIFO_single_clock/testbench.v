module test_controller();
   reg clock = 1;
   reg reset_n = 1;
   reg write_en = 0;
  reg read_en = 0;
  wire full;
  wire empty;
  wire [7:0] data_out;
  reg [7:0] data_in = 4;

/*  FIFO_controller u1 (
    clock,
    reset_n,
    write_en,
    read_en,
    write_pointer,
    read_pointer,
    full,
    empty,
    data_ready,
    data_valid
    );
*/

FIFO FIFO_dut(
  .clock(clock),
  .reset_n(reset_n),
  .write_en(write_en),
  .read_en(read_en),
  .empty(empty),
  .full(full),
  .data_in(data_in),
  .data_out(data_out)
  );

  always #5 clock <= ~clock;

  initial
    begin
      #10
      reset_n = 0;
      #10
      reset_n = 1;
      #10
      write_en = 1;
      #20
      data_in = 3;
      #20
      data_in = 2;
      #20
      data_in = 1;
      #100 // while(!full)
      #40
      write_en = 0;
      #20
      read_en = 1;
      #20
      read_en = 0;
      #20
      read_en = 1;
      #20
      read_en = 0;
      #20
      read_en = 1;
      #20
      read_en = 0;
      #20
      read_en = 1;
      #20
      read_en = 0;
      #20
      read_en = 1;
      #20
      read_en = 0;
      #200//while(!empty)
      #100
      write_en = 1;
      #10
      read_en = 1;
      repeat(10)
        begin
          #20
          data_in = data_in + 1;
        end

      #200
      write_en = 0;
      #60
      read_en = 0;
      #40

      $finish;
    end


endmodule


