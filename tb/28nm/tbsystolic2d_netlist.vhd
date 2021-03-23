library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use IEEE.std_logic_arith.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use work.tensorflow_package.all;

entity tb is
   generic ( X_SIZE : integer := 32 ;  
             FILTER_WIDTH : integer := 3 ;
             CONVS_PER_LINE  : integer := 15 ;
             MEM_SIZE  : integer := 10 ;
             INPUT_SIZE  : integer := 8 ;
             CARRY_SIZE : integer := 4
   );
end tb;

architecture a1 of tb is 

   signal data_from_mem: std_logic_vector(INPUT_SIZE-1 downto 0);
   signal address_out: std_logic_vector(MEM_SIZE-1 downto 0);
   signal pixel: std_logic_vector(((INPUT_SIZE*2)+CARRY_SIZE)-1 downto 0);

   signal clock, reset, start_line, valid, weight_en, bias_en : std_logic := '0';
 
begin

   DUT: entity work.systolic2d
             port map( clock=>clock, reset=> reset, address_out=>address_out, data_from_mem=>data_from_mem, 
                          start_line=>start_line, weight_en=>weight_en, bias_en=>bias_en, valid=>valid, pixel=>pixel);   

   reset <= '1', '0' after 0.53 ns;    
   clock <= not clock after 0.5 ns;
      
   bias_en   <= '1', '0' after 1.53 ns;
   weight_en <= '0', '1' after 1.468 ns, '0' after 11.468 ns;

   start_line <= '0',  '1' after 11.53 ns,  '0' after 12.53 ns; -- to start the convolution
   

   data_from_mem <= CONV_STD_LOGIC_VECTOR( bias_mem   ( CONV_INTEGER(unsigned(address_out))), INPUT_SIZE)   when bias_en   = '1' else
                    CONV_STD_LOGIC_VECTOR( weight_mem ( CONV_INTEGER(unsigned(address_out))), INPUT_SIZE) when weight_en = '1' else
                    CONV_STD_LOGIC_VECTOR( feature_mem( CONV_INTEGER(unsigned(address_out))), INPUT_SIZE);

   process(clock)
      file store_file : text open write_mode is "output.txt";
      variable file_line : line;
      variable conv_length : integer := 0;
   begin
      if clock'event and clock = '0' then
         if valid = '1' and conv_length < CONVS_PER_LINE*CONVS_PER_LINE then
            write(store_file, integer'image(CONV_INTEGER(pixel)));
            write(store_file, " ");
            if CONV_INTEGER(pixel) /= gold(conv_length) then
               report "gold  == " & integer'image(gold(conv_length));
               report "pixel == " & integer'image(CONV_INTEGER(pixel));
               report "end of simulation with error!" severity failure;
            end if;
            conv_length := conv_length + 1;
         elsif conv_length = CONVS_PER_LINE*CONVS_PER_LINE then
            writeline(store_file,file_line);
            report "end of simulation without error!" severity failure;
         end if;
      end if;
   end process;

end a1;
