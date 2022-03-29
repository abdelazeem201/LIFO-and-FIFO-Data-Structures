----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Ahmed Abdelazeem
-- 
-- Create Date: 03/29/2022 01:29:51 PM
-- Design Name: FIFO
-- Module Name: fifo - Behavioral
-- Project Name:  Data Structure
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
entity fifo is 
	generic (
		B : integer := 8 ; -- #of bits 
		W : integer := 4  -- #of address bits 2**4 = 16  location
	);
	port(clk, reset: in std_logic ; -- 50M Hz clock
		wr,rd : in std_logic ;
		w_data : in std_logic_vector (B-1 downto 0);
		full, empty: out std_logic;
		r_data : out std_logic_vector (B-1 downto 0)
		);
end fifo;

architecture arch of fifo is 
	type reg_file_type is array (2**W -1 downto 0) of std_logic_vector (B-1 downto 0);
	signal array_reg : reg_file_type;
	signal w_ptr_reg, w_ptr_next, w_ptr_succ: std_logic_vector (W-1 downto 0);
	signal r_ptr_reg, r_ptr_next, r_ptr_succ: std_logic_vector (W-1 downto 0);
	signal full_reg, full_next: std_logic;
	signal empty_reg, empty_next: std_logic;
	signal wr_op: std_logic_vector (1 downto 0);
	signal wr_en: std_logic;
begin	
	-- register File 
	process (clk, reset)
	begin
		if(reset = '0')then
			array_reg <= (others =>(others => '0'));
		elsif (clk'event and clk = '1')then
			if(wr_en = '1') then
				array_reg (to_integer(unsigned(w_ptr_reg))) <= w_data; --write operation
			end if;
		end if;
	end process;

	r_data <= array_reg (to_integer(unsigned(r_ptr_reg))); -- read operation
	wr_en <= wr and (not full_reg); --write enabled only when FIFO is not Full
	
	-- FIFO control Logic
	--register for read and write pointers
	process (clk, reset)
	begin
		if(reset = '0')then
			w_ptr_reg <= (others =>'0');
			r_ptr_reg <= (others =>'0');
			full_reg <= '0';
			empty_reg <= '1';
		elsif (clk'event and clk = '1')then
			w_ptr_next <= w_ptr_reg;
			r_ptr_next <= r_ptr_reg;
			full_next <= full_reg;
			empty_next <= empty_reg;
		end if;	
	end process;
	
	-- increase the pointer by one position 
	w_ptr_succ <= std_logic_vector(unsigned (w_ptr_reg) + 1);
	r_ptr_succ <= std_logic_vector(unsigned (r_ptr_reg) + 1);
	
	----next state logic for read and write pointers
	wr_op <= wr & rd;
	process( w_ptr_reg, w_ptr_succ, r_ptr_reg, r_ptr_succ, empty_reg, full_reg, wr_op)
	begin
	-- intially
		w_ptr_next <= w_ptr_reg;
		r_ptr_next <= r_ptr_reg;
		full_next <= full_reg;
		empty_next <= empty_reg;
		case wr_op is
			when "00" => -- no op
			when "01" => --read
				if(empty_reg /= '1') then
					r_ptr_next <= r_ptr_succ;
					full_next <= '0';
					if (r_ptr_succ = w_ptr_reg) then
						empty_next <= '1';
					end if;	
				end if;
			when "10" => --write
				if(full_reg /= '1') then
					w_ptr_next <= w_ptr_succ;
					empty_next <= '0';
					if (w_ptr_succ = r_ptr_reg)then
						full_next <= '1';
					end if;	
				end if;			
			when others =>	
				w_ptr_next <= w_ptr_succ;
				r_ptr_next <= r_ptr_succ;
		end case;		
	end process;			
	-- output
	full <= full_reg;
	empty <= empty_reg;

end arch;	
