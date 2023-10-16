library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

package text_package is

	constant FONT_WIDTH : integer := 8;
	constant FONT_HEIGHT : integer := 16;
	
	constant TEXT_X : integer := 512/2;
	constant TEXT_Y : integer := 480/2;
	
	constant TITLE_TEXT   : string := "M A S T E R M I N D";
	constant INTRO_TEXT   : string := "Use KEY 1 a 3 para iniciar o jogo";
	constant WIN_TEXT     : string := "Parabens!!! Acertou as cores!";
	constant LOSE_TEXT    : string := "Errroou! As cores eram:";
	
	type message is (TITLE, INTRO, WIN, LOSE);
	
	type codes is array(natural range<>) of integer;

end package;
