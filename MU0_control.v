//Verilog HDL for Undergraduate course: "COMP12111", "MU0_Control" "functional"

module MU0_try (input   Clk, 
                input   reset,
		            input   [15:0] DIn,
                output  reg [11:0] Addr,
                output  reg Wr, 
                output  reg Rd,
                output  reg Halted,
		            output  reg [11:0] PC,
                output  reg [15:0] IR,
                output  reg [15:0] Acc,
                output  reg [15:0] DOut);
		
reg current_state;
reg [11:0]PC_value;
reg [15:0]IR_value;
reg [15:0]Acc_value;

always@(posedge Clk, posedge reset)
begin
  if (reset)
    begin
      current_state <= 0;
    end
  else
    begin
    if(!Halted)
      if(!current_state)
        current_state <= 1;
      else 
        current_state <= 0;
    end
end

always@(posedge Clk, posedge reset)   // IR register
begin
  if (reset)
    IR <= 0;
  else if(!current_state)
    IR <= IR_value;
end

always@(posedge Clk, posedge reset)  // PC register
begin
  if (reset)
    PC <= 0;
  else
    PC <= PC_value;
end

always@(posedge Clk, posedge reset)  // Acc register
begin
  if (reset)
    Acc <= 0;
  else if(current_state)
    Acc <= Acc_value;
end
  
always@(*)
  if(!current_state)     // fetch
    begin
      Rd=1;
      Wr=0;
      Addr = PC;
      Halted = 0;
      IR_value = DIn;
      PC_value = PC +1;
      Acc_value = 'hxxxx;
    end 
  else               // decode and execute
    begin
      case(IR[15:12])
       
      0: begin      // load
        Addr = IR[11:0];
	      Acc_value = DIn;
	      Halted = 0;
	      Rd=1;
              Wr=0;
	      IR_value = 'hxxxx;
	      PC_value = 'hxxxx;
      end
      
      1: begin   // store
        Wr=1;
        Addr = IR[11:0];
	      DOut = Acc;
	      Halted = 0;
	      Rd=0;
        Wr=1;
	      Acc_value = 'hxxxx;
	      IR_value = 'hxxxx;
	      PC_value = 'hxxxx;
      end
      
      2: begin   // add
        Addr = IR[11:0];
	      Acc_value = Acc + DIn;
	      Halted = 0;
	      Rd=1;
        Wr=0;
	      IR_value = 'hxxxx;
	      PC_value = 'hxxxx;
      end
      
      3: begin   // sub
        Addr = IR[11:0];
	      Acc_value = Acc - DIn;
	      Halted = 0;
	      Rd=1;
        Wr=0;
	      PC_value = 'hxxxx;
	      IR_value = 'hxxxx;
      end
      
      4: begin  // jump
        PC_value = IR[11:0];
        Halted = 0;
	      Rd=0;
        Wr=0;
        Addr = 'hxxx;
        Acc_value = 'hxxxx;
        IR_value = 'hxxxx;
	    end
      
      5: begin // jump GE
        if(Acc>=0) PC_value = IR[11:0];
	       Halted = 0;
	       Addr = 'hxxx;
	       Acc_value = 'hxxxx;
	       IR_value = 'hxxxx;
	       Rd=0;
         Wr=0;
      end
      
      6: begin // jump NE
        if(Acc!=0) PC_value = IR[11:0];
        Halted = 0;
        Rd=0;
        Wr=0;
        Addr = 'hxxx;
        Acc_value = 'hxxxx;
        IR_value = 'hxxxx;
	    end
      
      7: begin // halted
        Halted = 1;
	      Rd=0;
        Wr=0;
        Addr = 'hxxx;
	      Acc_value = 'hxxxx;
	      IR_value = 'hxxxx;
	      PC_value = 'hxxxx;
	    end
    endcase
  end
	
endmodule
