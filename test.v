module FIFO_test;
 wire [15:0] out;
 wire ful, emp;
 reg clocks, rst, clr, wn, rn;
 reg [15:0] in;  
  
 FIFO mem(.clock(clocks), .reset(rst), .clear(clr), .write(wn), .read(rn), .data_in(in), .full(ful), .empty(emp), .data_out(out));
  
 initial 
  begin
   rst=0;
   clr=0;
   clocks=0;
  forever #5 clocks=~clocks;
  end
 
 initial 
  begin
   $monitor($time, , ,"c=%b",clocks,,"reset=%b",rst,,"data_in=%b",in,,"clear=%b",clr,,"read=%b",rn,,"write=%b",wn,,"full=%b",ful,,"empty=%b",emp,,"data_out=%b",out);
   #300 $display("Finished");
   $finish;
  end
 
  initial 
   begin 
   $dumpfile("dump.vcd"); 
   $dumpvars;
   end

  initial
  begin
   in = 15'd0;
   rst = 1; 
  #10 rst = 0;
  // First write some data into the queue
   #10 wn = 1; rn = 0;
   in = 15'd100;
   #10 in = 15'd150;
   #10 in = 15'd200;
   #10 wn = 0; rn = 1;
   #40 rn = 0;
   #10 clr = 1; 
 
   #10 clr = 0; wn = 1; in = 15'd100;   
   #10 in = 15'd150;
   #10 in = 15'd200;
   #10 in = 15'd40; rn = 1;
   #10 in = 15'd70;
   #10 in = 15'd65;
   #10 in = 15'd15;
   #10 in = 15'd230;
   #10 in = 15'd150;
   #10 in = 15'd200;
   // Now start reading and checking the values
   #30	wn = 0;
  end
endmodule
