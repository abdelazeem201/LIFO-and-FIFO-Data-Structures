// --------------------------------------------------------------------
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
// --------------------------------------------------------------------
// Author: Ahmed Abdelazeem
// Github: https://github.com/abdelazeem201
// Email: ahmed_abdelazeem@outlook.com
// Description: FIFO module
// Dependencies: 
// Since: 2021-12-24 15:16:50
// LastEditors: ahmed abdelazeem
// LastEditTime: 2021-17-18 15:16:50
// ********************************************************************
// Module Function:
module stack 
	#(parameter B = 8, // #of bits  
				      W = 4) // #of address bits 2**4 = 16  location
	(
	 input wire clk, reset,
	 input wire push, pop
	 input wire [B-1:0] w_data,
	 output wire full, empty,
	 output wire [B-1:0] r_data
	);

     //signal declaration
reg [B-1:0] arrayreg[2**W-1:0]; //number of words in fifo = 2^(number of address bits)
reg [W-1:0] push_ptr_reg, push_ptr_next, push_ptr_succ;
reg [W-1:0] pop_ptr_reg, pop_ptr_next, pop_ptr_succ;
reg full_reg, empty_reg, full_next, empty_next;
wire wr_en;

   // body
   // register file write operation
   always @(posedge clk)
      if (wr_en)
         array_reg[push_ptr_reg] <= w_data;
   // register file read operation
   assign r_data = array_reg[pop_ptr_reg];
   // write enabled only when FIFO is not full
   assign wr_en = push & ~full_reg;
 
   // LIFO control logic
   // register for read and write pointers
   always @(posedge clk, posedge reset)
      if (reset)
         begin
            push_ptr_reg <= 0;
            pop_ptr_reg <= 0;
            full_reg <= 1'b0;
            empty_reg <= 1'b1;
         end
      else
         begin
            push_ptr_reg <= w_ptr_next;
            pop_ptr_reg <= r_ptr_next;
            full_reg <= full_next;
            empty_reg <= empty_next;
         end 
   
   // next-state logic for read and write pointers
   always @*
   begin
      // successive pointer values
      push_ptr_succ = push_ptr_reg + 1;
      pop_ptr_succ = pop_ptr_reg - 1;
      // default: keep old values
      push_ptr_next = push_ptr_reg;
      pop_ptr_next =pop_ptr_reg;
      full_next = full_reg;
      empty_next = empty_reg;
      case ({push, pop})
         // 2'b00:  no op
         2'b01: // read
            if (~empty_reg) // not empty
               begin
                  pop_ptr_next = pop_ptr_succ;
                  full_next = 1'b0;
                  if (pop_ptr_succ == 0)
                     empty_next = 1'b1; //all data has been read
               end
         2'b10: // write
            if (~full_reg) // not full
               begin
                  push_ptr_next = push_ptr_succ;
                  empty_next = 1'b0;
                  if (push_ptr_succ == (2**W - 1))
                     full_next = 1'b1; //all registers have been written to
               end
         2'b11: // write and read
            begin
               push_ptr_next = push_ptr_succ;
               pop_ptr_next = pop_ptr_succ;
            end
      endcase
   end

   // output
   assign full = full_reg;
   assign empty = empty_reg;

endmodule   
