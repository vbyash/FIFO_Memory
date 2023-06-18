module FIFO_test;
 wire [7:0] out;
 wire ful, emp;
 reg clock, rst, wn, rn;
 reg [7:0] in;  
  
 FIFO mem(.data_out(out), .full(ful), .empty(emp), .clk(clock), .reset(rst), .wr(wn), .rd(rn), .data_in(in));
  
 initial 
  begin
   clk=0;
  forever #5 clk=~clk;
  end
 
 initial 
  begin
   $monitor($time, , ,"c=%b",clk,,"y=%b",out,,"r=%b",rst,,"d=%b",in,,"read=%b",rn,,"write=%b",wn,,"full=%b",ful,,"empty=%b",emp);
   #200 $display("Finished");
   $finish;
  end
 
  initial 
   begin 
   $dumpfile("dump.vcd"); 
   $dumpvars;
   end

  initial
  begin
   in = 8'd0;
   reset = 1; 
  #10 reset = 0;
  // First write some data into the queue
   #10 wn = 1; rn = 0;
   in = 8'd100;
   #10 in = 8'd150;
   #10 in = 8'd200;
   #10 in = 8'd40;
   #10 in = 8'd70;
   #10 in = 8'd65;
   #10 in = 8'd15;
   
   // Now start reading and checking the values
   #20 wn = 0; rn = 1;
  end
endmodule
