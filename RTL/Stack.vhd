----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Ahmed Abdelazeem
-- 
-- Create Date: 03/29/2022 01:29:51 PM
-- Design Name: Stack "LIFO"
-- Module Name: LIFO - Behavioral
-- Project Name: Data Structure
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity stack is 
	generic (
		B : integer := 8 ; -- #of bits 
		W : integer := 4  -- #of address bits 2**4 = 16  location
	);
	port(clk, reset: in std_logic ; 
		push,pop : in std_logic ;
		w_data : in std_logic_vector (B-1 downto 0);
		full, empty: out std_logic;
		r_data : out std_logic_vector (B-1 downto 0)
		);
end stack;

architecture arch of stack is 
	type reg_file_type is array (2**W -1 downto 0) of std_logic_vector (B-1 downto 0);
	signal stack_mem  : reg_file_type;
	signal push_ptr_reg, push_ptr_next, push_ptr_succ: std_logic_vector (W-1 downto 0);
	signal pop_ptr_reg, pop_ptr_next, pop_ptr_succ: std_logic_vector (W-1 downto 0);
	signal full_reg, full_next: std_logic;
	signal empty_reg, empty_next: std_logic;
	signal wr_op: std_logic_vector (1 downto 0);
	signal wr_en: std_logic;
begin	
	-- register File 
	process (clk, reset)
	begin
		if(reset = '0')then
			stack_mem  <= (others =>(others => '0'));
		elsif (clk'event and clk = '1')then
			if(wr_en = '1') then
				stack_mem  (to_integer(unsigned(push_ptr_reg))) <= w_data; --write operation
			end if;
		end if;
	end process;

	r_data <= stack_mem  (to_integer(unsigned(pop_ptr_reg))); -- read operation
	wr_en <= push and (not full_reg); --write enabled only when Stack is not Full
	
	-- Stack control Logic
	--register for read and write pointers
	process (clk, reset)
	begin
		if(reset = '0')then
			push_ptr_reg <= (others =>'1');
			pop_ptr_reg <= (others =>'0');
			full_reg <= '0';
			empty_reg <= '1';
		elsif (clk'event and clk = '1')then
			push_ptr_next <= push_ptr_reg;
			pop_ptr_next <= pop_ptr_reg;
			full_next <= full_reg;
			empty_next <= empty_reg;
		end if;	
	end process;
	
	-- increase the pointer by one position 
	push_ptr_succ <= std_logic_vector(unsigned (push_ptr_reg) + 1);
	pop_ptr_succ <= std_logic_vector(unsigned (pop_ptr_reg) - 1);
	
	----next state logic for read and write pointers
	wr_op <= push & pop;
	process( push_ptr_reg, push_ptr_succ, pop_ptr_reg, pop_ptr_succ, empty_reg, full_reg, wr_op)
	begin
	-- intially
		push_ptr_next <= push_ptr_reg;
		pop_ptr_next <= pop_ptr_reg;
		full_next <= full_reg;
		empty_next <= empty_reg;
		case wr_op is
			when "00" => -- no op
			when "01" => --read
				if(empty_reg /= '1') then
					pop_ptr_next <= pop_ptr_succ;
					full_next <= '0';
					if (pop_ptr_succ = (others => '0')) then
						empty_next <= '1';
					end if;	
				end if;
			when "10" => --write
				if(full_reg /= '1') then
					push_ptr_next <= push_ptr_succ;
					empty_next <= '0';
					if (push_ptr_succ = (2**W - 1))then
						full_next <= '1';
					end if;	
				end if;			
			when others =>	
				push_ptr_next <= push_ptr_succ;
				pop_ptr_next <= pop_ptr_succ;
		end case;		
	end process;			
	-- output
	full <= full_reg;
	empty <= empty_reg;

end arch;	
