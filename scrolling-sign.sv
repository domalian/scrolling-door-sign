// 4-bit Counter
module BCDtoseven(input wire Clock,
                  input wire Reset,
                  input wire X,
                  output wire [3:0] CNT,
                  output wire [6:0] OUT);

  Counter counter_inst(.CNT(CNT),
                       .Clock(Clock),
                       .Reset(Reset),
                       .X(X));

  sevensegROM sevenseg_inst(.OUT(OUT),
                            .IN(CNT));

endmodule

module Counter(output reg[3:0] CNT,
               input wire Clock, Reset, X);
  
  reg [3:0] current_state, next_state;
  parameter C0 = 4'b0000,
  			C1 = 4'b0001,
  			C2 = 4'b0010,
  			C3 = 4'b0011,
  			C4 = 4'b0100,
  			C5 = 4'b0101,
  			C6 = 4'b0110,
  			C7 = 4'b0111,
  			C8 = 4'b1000,
  			C9 = 4'b1001,
  			C10 = 4'b1010,
  			C11 = 4'b1011;
  
  always @ (posedge Clock or negedge Reset)
    begin: STATE_MEMORY
      if (!Reset & (X == 1'b0)) begin
        current_state <= C0;
        CNT <= 4'b0000;
      end
      else if(!Reset & (X == 1'b1)) begin
        current_state <= C5;
        CNT <= 4'b0101;
      end
      else
        current_state <= next_state;
    end
  
  always @ (current_state or X)
    begin: NEXT_STATE_LOGIC
      case (current_state)
        C0 : if (X == 1'b0) next_state = C1; else next_state = C5;
        C1 : if (X == 1'b0) next_state = C2; else next_state = C5;
        C2 : if (X == 1'b0) next_state = C3; else next_state = C5;
        C3 : if (X == 1'b0) next_state = C4; else next_state = C5;
        C4 : if (X == 1'b0) next_state = C0; else next_state = C5;
        C5 : if (X == 1'b1) next_state = C6; else next_state = C0;
        C6 : if (X == 1'b1) next_state = C7; else next_state = C0;
        C7 : if (X == 1'b1) next_state = C8; else next_state = C0;
        C8 : if (X == 1'b1) next_state = C9; else next_state = C0;
        C9 : if (X == 1'b1) next_state = C10; else next_state = C0;
        C10 : if (X == 1'b1) next_state = C11; else next_state = C0;
        C11 : if (X == 1'b1) next_state = C5; else next_state = C0;
        default : if (X == 1'b1) next_state = C5; else next_state = C0; // Might not be needed
      endcase
    end
  
  always @ (current_state)
    begin: OUTPUT_LOGIC
      case (current_state)
        C0 : CNT = 4'b0000;
        C1 : CNT = 4'b0001;
        C2 : CNT = 4'b0010;
        C3 : CNT = 4'b0011;
        C4 : CNT = 4'b0100;
        C5 : CNT = 4'b0101;
        C6 : CNT = 4'b0110;
        C7 : CNT = 4'b0111;
        C8 : CNT = 4'b1000;
        C9 : CNT = 4'b1001;
        C10 : CNT = 4'b1010;
  		C11 : CNT = 4'b1011;
        default : if (X == 1'b1) CNT = 4'b0101; else CNT = 4'b0000; // Might not be needed
      endcase
    end
  
endmodule

module sevensegROM(output reg[6:0] OUT,
                input wire[3:0] IN);
  always @ (OUT, IN) begin
    case (IN)
      4'b0000: OUT = 7'b1100111;
      4'b0001: OUT = 7'b1110111;
      4'b0010: OUT = 7'b0111110;
      4'b0011: OUT = 7'b0000000;
      4'b0100: OUT = 7'b0000000;
      4'b0101: OUT = 7'b1110111;
      4'b0110: OUT = 7'b0001110;
      4'b0111: OUT = 7'b1111110;
      4'b1000: OUT = 7'b0110111;
      4'b1001: OUT = 7'b1110111;
      4'b1010: OUT = 7'b0000000;
      4'b1011: OUT = 7'b0000000;
    endcase
  end
endmodule