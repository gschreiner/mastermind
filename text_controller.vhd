-- Pixel_On_Text2 determines if the current pixel is on text and make it easiler to call from verilog
-- param:
--   display text
-- input: 
--   VGA clock(the clk you used to update VGA)
--   top left corner of the text area -- positionX, positionY
--   current X and Y position
-- output:
--   a bit that represent whether is the pixel in text

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.text_package.ALL;

entity text_controller is
	port (
		CLOCK				: in std_logic;
		RESET_N 			: in std_logic;
		CHOSEN_TEXT 	: in message;
		NEXT_BIT    	: in std_logic;
		NEXT_LINE   	: in std_logic;
		PIXEL				: out std_logic := '0'
	);
end text_controller;


architecture behavioral of text_controller is

	signal y_counter   : integer;
	signal font_address : integer;
	-- A row of bit in a charactor, we check if our current (x,y) is 1 in char row
	signal char_bit_in_row: std_logic_vector(FONT_WIDTH-1 downto 0) := (others => '0');
	-- the position(column) of a charactor in the given text
	signal char_position:integer := 0;
	-- the bit position(column) in a charactor
	signal bit_position:integer := 0;
	signal char_codes  : codes(0 to message'POS(message'HIGH));
begin

	font_rom: entity work.font_rom
		port map(
			clk  => CLOCK,
			addr => font_address,
			font_row => char_bit_in_row
	);
		
	process(CLOCK, RESET_N, CHOSEN_TEXT)
		variable last_chosen_text: message;
	begin
		if RESET_N = '0' or last_chosen_text /= CHOSEN_TEXT then
			y_counter     <= 0;
			char_position <= 1;
			bit_position  <= 0;
		elsif rising_edge(CLOCK) then
			if NEXT_BIT = '1' then
				if bit_position = 7 then
					bit_position <= 0;
					char_position <= char_position + 1;
				else
					bit_position <= bit_position + 1;
				end if;
			end if;
			if NEXT_LINE = '1' then
				bit_position <= 0;
				char_position <= 1;
				y_counter <= y_counter + 1;
			end if;
		end if;
		last_chosen_text := CHOSEN_TEXT;
	end process;
	
	char_codes(0) <= character'pos(TITLE_TEXT(char_position));
	char_codes(1) <= (character'pos(INTRO_TEXT(char_position)))-1;
	char_codes(2) <= character'pos(WIN_TEXT(char_position))-2;
	char_codes(3) <= (character'pos(LOSE_TEXT(char_position)))-2;
	
	font_address <= (char_codes((message'POS(CHOSEN_TEXT)))) * 16 + y_counter;
	
	pixel <= char_bit_in_row(FONT_WIDTH-bit_position);
		        
end behavioral;
