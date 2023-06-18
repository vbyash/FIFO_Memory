module FIFO( clock, reset, clear, data_in, write, read, full, empty, data_out);
  input clock;
  input reset;
  input clear;
  input [15:0] data_in;
  input write;
  input read;

  output [15:0] data_out;
  output reg full;
  output reg empty;

  reg last_f;
  reg first_f;

  reg [2:0]counter;
  reg [2:0]rd_ptr;
  reg [2:0]wr_ptr;

  wire [15:0]d_out;
  wire [15:0]d_in;
  wire read_fifo=read;
  wire write_fifo=write;

  assign data_out=d_out;
  assign d_in=data_in;

  memory m1(.clk(clock), .write_f(write_fifo), .rd_addr(rd_ptr), .wr_addr(wr_ptr), .din(d_in), .dout(d_out));

  always @(posedge clock, reset)
    begin
      if(reset)
        begin
          counter<=0;
          rd_ptr<=0;
          wr_ptr<=0;
        end
      else
        begin
          if(clear) 
            begin
              counter<=0;
              rd_ptr<=0;
              wr_ptr<=0;
            end
          else
            begin
              if(write_fifo)
                wr_ptr=wr_ptr+1;
              if(read_fifo)
                rd_ptr=rd_ptr+1;
              if(write_fifo && ~read_fifo && ~full)
                counter=counter+1;
              else if(~write_fifo && read_fifo && ~empty)
                counter=counter-1;
            end
       end
    end


  always @(posedge clock, reset)
    begin
      if(reset)
        empty<=1'b1;
      else
        begin
          if(clear)
            empty<=1'b1;
          else
            begin
              if(empty==1'b1 && write_fifo==1'b1)
                empty<=1'b0;
              else if(first_f==1'b1 && read_fifo==1'b1 && write_fifo==1'b0)
                empty<=1'b1;
            end
        end
    end

   always @(posedge clock,reset)
     begin
       if(reset)
         first_f<=1'b0;
       else
         begin
           if(clear)
             first_f<=1'b0;
           else
             begin
               if((empty==1'b1 && write_fifo==1'b1)||(counter==2 && read_fifo==1'b1 && write_fifo==1'b0))
                 first_f<=1'b1;
               else if(first_f==1'b1 && (write_fifo^read_fifo))
                 first_f<=1'b0;
             end
         end
     end

    always @(posedge clock, reset)
    begin
      if(reset)
        full<=1'b0;
      else
        begin
          if(clear)
            full<=1'b0;
          else
            begin
              if(full==1'b1 && read_fifo==1'b1)
                full<=1'b0;
              else if(last_f==1'b1 && read_fifo==1'b0 && write_fifo==1'b1)
                full<=1'b1;
            end
        end
    end
  
      
 always @(posedge clock,reset)
     begin
       if(reset)
         last_f<=1'b0;
       else
         begin
           if(clear)
             first_f<=1'b0;
           else
             begin
               if((full==1'b1 && read_fifo==1'b1)||(counter==6 && write_fifo==1'b1 && read_fifo==1'b0))
                 last_f<=1'b1;
               else if(last_f==1'b1 && (write_fifo^read_fifo))
                 last_f<=1'b0;
             end
         end
     end
  
endmodule


module memory(clk, write_f, wr_addr, rd_addr, din, dout);
  input clk;
  input write_f;
  input [2:0]wr_addr;
  input [2:0]rd_addr;
  input [15:0]din;
  output [15:0]dout;
  wire dout;
  reg [15:0]FIFO_blk[0:7];

  assign dout=FIFO_blk[rd_addr];
  always @(posedge clk)
    begin
      if(write_f==1'b1)
        FIFO_blk[wr_addr]<=din;
    end
endmodule
  


