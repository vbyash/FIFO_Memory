module jFIFO(DATAOUT, full, empty, clock, reset, wn, rn, DATAIN);
  output reg [7:0] DATAOUT;
  output reg [1:0]full, empty;
  input [7:0] DATAIN;
  input clock, reset, wn, rn;
  integer i;
  
  reg [2:0] wptr, rptr; // pointers tracking the stack
  reg [7:0] memory [7:0]; // the stack is 8 bit wide and 8 locations in size
  

  always @(posedge rn, wn, clock)
    begin
      if((wptr == 3'b111) & (rptr == 3'b000))
        full<=1;
      else
        full<=0;
    end
  
  
  always @(posedge rn, wn, clock)
    begin
      if((wptr == rptr))
        empty<=1;
      else
        empty<=0;
    end
 
  
  always @(posedge clock)
  begin
    if (reset)
      begin
        
        DATAOUT <= 0; 
        wptr <= 0; 
        rptr <= 0;
        
        for(i=0; i<8; i=i+1)
          begin
            memory[i]<=0;
          end
        
      end
    
    else if (wn & !full)
      begin
        memory[wptr] <= DATAIN;
        wptr <= wptr + 1;
      end
    
    else if (rn & !empty)
      begin
        DATAOUT <= memory[rptr];
        rptr <= rptr + 1;
      end
    
  end
  
endmodule
