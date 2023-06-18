module FIFO_test;
 wire [31:0] out;
 wire ful, emp;
 reg clocks, rst, clr, wn, rn;
 reg [31:0] in;  
  
 FIFO mem(.clock(clocks), .reset(rst), .clear(clr), .write(wn), .read(rn), .data_in(in), .full(ful), .empty(emp), .data_out(out));
  
 initial 
  begin
   clk=0;
  forever #5 clk=~clk;
  end
 
 initial 
  begin
   $monitor($time, , ,"c=%b",clk,,"reset=%b",rst,,"data_in=%b",in,,"clear=%b",clr,,"read=%b",rn,,"write=%b",wn,,"full=%b",ful,,"empty=%b",emp,,"data_out=%b",out);
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
   in = 31'd0;
   rst = 1; 
  #10 rst = 0;
  // First write some data into the queue
   #10 wn = 1; rn = 0;
   in = 31'd100;
   #10 in = 31'd150;
   #10 in = 31'd200;
   #10 wn = 0; rn = 1;
   #20 clr = 1;
   #10 wn = 1; rn = 0;
   in = 31'd100;
   #10 in = 31'd150;
   #10 in = 31'd200;
   #10 in = 31'd40;
   #10 in = 31'd70;
   #10 in = 31'd65;
   #10 in = 31'd15;
   #10 in = 31'd230;
   
   // Now start reading and checking the values
   #20 wn = 0; rn = 1;
  end
endmodule
