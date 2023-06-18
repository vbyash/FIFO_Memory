module FIFO(data_out, full, empty, clock, reset, wn, rn, data_in);
  output reg [7:0] data_out;
  output reg [1:0]full, empty;
  input [7:0] data_in;
  input clk, reset, wr, rd;
  integer i;
  
  reg [2:0] wptr, rptr; // pointers tracking the stack
  reg [7:0] memory [7:0]; // the stack is 8 bit wide and 8 locations in size
  

  always @(posedge rd, wr, clk)
    begin
      if((wptr == 3'b111) & (rptr == 3'b000))
        full<=1;
      else
        full<=0;
    end
  
  
  always @(posedge rd, wr, clk)
    begin
      if((wptr == rptr))
        empty<=1;
      else
        empty<=0;
    end
 
  
  always @(posedge clk)
  begin
    if (reset)
      begin
        
        data_out <= 0; 
        wptr <= 0; 
        rptr <= 0;
        
        for(i=0; i<8; i=i+1)
          begin
            memory[i]<=0;
          end
        
      end
    
    else if (wr & !full)
      begin
        memory[wptr] <= data_in;
        wptr <= wptr + 1;
      end
    
    else if (rd & !empty)
      begin
        data_out <= memory[rptr];
        rptr <= rptr + 1;
      end
    
  end
  
endmodule
