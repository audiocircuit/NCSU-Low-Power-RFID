module rfid_decode(
  input wire [127:0] input_in,



  );



  parameter Query =       4'b1000;
  parameter QueryRep =    2'b00;
  parameter QueryAdjust = 4'b1001;
  parameter ACK =         4'b1000;
  parameter NACK =        8'b11000000;
  parameter ReqRN =       8'b11000001;
  parameter Read =        4'b11000010;
  parameter Query =       4'b1000;



  //    Query command, Divide Ratio, FM0 Encodeing (m=1), No Pilot Tone, All ICs Selected, Session (S0),
  //      Inventory Flag (A), Q-Value (0), 5-bit CRC
  //    1000-0-00-0-00-00-0-0000-10000

  //    QueryAdjust command, session (S0), Decrement Count(Q = Q - 1)
  //    1001-00-011

  //    QueryReq Command, session (S0)
  //    00-01

  //    ACK Command, 16-bit Random Number
  //    01-0100111111001000

  //    NAK Command
  //    11000000

  //    Req_RN Command, Prior 16-bit Ramandon Number, CRC-16
  //    11000001-0000000011110000-1100110110111011

  //    Req_RN: new 16-bit Ramdon Number, CRC-16
  //    0000011110000111-10011010000001000

  //    Read Command, MEMBank(01 = EPC), pointer to Start Address(PC-bits Word), Number of words to be read, Handle from IC, CRC-16
  //    11000010-01-00000010-00000001-00000001111000001-1101100100110101

  //    Write Command, MEmBank(01-EPC), WordPtr(PC Word of EOC), Data to be Writen, Handle From IC, CRC-16
  //    11000011-01-0000010-0011000000000000-0000000001111000001-110000000000100100

  //    Write response: Header bit(0 = seccess, 1 = failure), Handle From IC, 16-bit CRC
  //    0-00000001111000001-000110111101111

  //    Kill Command, Kill 1 Passsword(XORed with RN 16), RFU bits, Handle, CRC-16
  //    11000100-1111011101110111-000-000000000001111000-11010010000010001

  //    Kill response: Handle From IC, CRC-16
  //    00000000001111000-0001110101101111

  //    BlockWrite Command, Memory Bank(01=EPC), Word Pointer, Word Count, Data, Handle, CRC-16
  //    11000111-01-00000010-Data-1111000011110110-10011100001101011

  //    BlockWrite response: Header, Handle From IC, CRC-16
  //    0-11110000011110110-0101100111111001
  
  //    Select command, Target: SL, Action: matching-Assert, Nomatching-Deassert, EPC Memory Bank (01), Start Address (0111000), Lenght(8-bits), mask Value, Truncate, CRC-16
  //    1010-100-000-10-01111000-00010000-00000000-1-0111100000010011


