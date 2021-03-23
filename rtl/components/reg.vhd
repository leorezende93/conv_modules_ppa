-------------------------------------------------------------------------------------------------
-- flop    -  out/2020   (simple register) - MORAES                                       20 bits    
-------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity reg is
   generic ( INPUT_SIZE  : integer := 20 );
   port    ( clock, reset : in  std_logic;
               enable       : in  std_logic;
               D            : in std_logic_vector(INPUT_SIZE-1 downto 0);
               Q            : out std_logic_vector(INPUT_SIZE-1 downto 0)
             );
end entity reg;

architecture a1 of reg is
begin

    process(reset, clock)
    begin
          if reset='1' then
                Q <= (others=>'0');
          elsif rising_edge(clock) then
            if enable ='1' then
               Q <= D;
            end if;
          end if;
    end process;
   
end a1;             
