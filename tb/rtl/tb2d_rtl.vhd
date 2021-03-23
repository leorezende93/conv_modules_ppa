library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use IEEE.std_logic_arith.CONV_STD_LOGIC_VECTOR;

entity tb is
end tb;

architecture a1 of tb is 

   signal address_out, data_from_mem: std_logic_vector(7 downto 0);
   signal pixel: std_logic_vector(19 downto 0);

   signal clock, reset, start_line, valid, weight_en : std_logic := '0';

   --type wgh3x3 is array (0 to 2, 0 to 2) of integer range -128 to 127;  
   --constant weight : wgh3x3 := ( (8,  4,  8), (-2, -4,  4), (5,  3, -7) );

   type padroes is array(0 to 1024) of integer;
   
   constant weight_mem : padroes := ( 8,  4,  8, -2, -4,  4, 5,  3, -7, others=>0 );
   
   constant feature_mem : padroes := ( -1,  3, -10,  8, -4,  7,  4,  8, -9,
                                       -4,  9,   5, -2,  4, 17, -1,  2, 14,
                                        7, -9,   9, -3, 11, -8,  3, -1,  8, 
                                        1,  2,   3,  4,  5, -6,  -7, -8, -9, others=>0 );

begin

  DUT: entity work.conv2d
             generic map(X_SIZE=>9, FILTER_WIDTH=>3, CONVS_PER_LINE=>4 )
             port map( clock=>clock, reset=> reset, address_out=>address_out, data_from_mem=>data_from_mem, 
                          start_line=>start_line, weight_en=>weight_en, valid=>valid, pixel=>pixel);   

  reset <= '1', '0' after 5 ns;    
  clock <= not clock after 5 ns;
  
  weight_en <= '1', '0' after 95 ns;

  data_from_mem <=  CONV_STD_LOGIC_VECTOR( feature_mem( CONV_INTEGER(address_out)), 8) when weight_en = '0' else
                    CONV_STD_LOGIC_VECTOR( weight_mem( CONV_INTEGER(address_out)), 8);

  start_line <= '0',  '1' after 95 ns,  '0' after 115 ns;  -- to start the convolution

end a1;
