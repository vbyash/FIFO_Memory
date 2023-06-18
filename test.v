module FIFO_test;
 wire [7:0] out;
 wire ful, emp;
 reg clock, rst, wn, rn;
 reg [7:0] in;  
  
 FIFO mem(.data_out(out), .full(ful), .empty(emp), .clk(clock), .reset(rst), .wr(wn), .rd(rn), .data_in(in));
  
  //enabling the wave dump
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
  initial 
   begin 
   $dumpfile("dump.vcd"); 
   $dumpvars;
   end

  initial
  begin
   clock = 0; 
   in = 8'd0;
   reset = 1; clock = 1; #5 ; clock = 0; #5;
   reset = 0;
  
  // First write some data into the queue
   wn = 1; rn = 0;
   in = 8'd100;
   clock = 1; #5 ; 
   clock = 0; #5;
   in = 8'd150;
   clock = 1; #5 ;
   clock = 0; #5;
   in = 8'd200;
   clock = 1; #5 ;
   clock = 0; #5;
   in = 8'd40;
   clock = 1; #5 ; 
   clock = 0; #5;
   in = 8'd70;
   clock = 1; #5 ;
   clock = 0; #5;
   in = 8'd65;
   clock = 1; #5 ;
   clock = 0; #5;
   in = 8'd15;
   clock = 1; #5;
   clock = 0; #5;
    
   // Now start reading and checking the values
   wn = 0; rn = 1;
   clock = 1; #5;
   clock = 0; #5;
   clock = 1; #5;
   clock = 0; #5;
   clock = 1; #5;
   clock = 0; #5;
   clock = 1; #5;
   clock = 0; #5;
   clock = 1; #5;
   clock = 0; #5;
   clock = 1; #5; 
   clock = 0; #5;
   clock = 1; #5; 
   clock = 0; #5;
   clock = 1; #5; 
   clock = 0; #5;
   
endmodule
