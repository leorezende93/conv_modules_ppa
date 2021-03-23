-------------------------------------------------------------------------------------------------
-- SIMPLE BEHAVORIAL MAC  -  out/20120 - MORAES                                           20 bits           
-------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;   -- *** signed to avoid problems *** 

entity mac is
      generic ( INPUT_SIZE  : integer := 8 ;  
                CARRY_SIZE : integer := 4
             );
      port   (  clock, reset : in  std_logic;
                start        : in  std_logic;
                op1, op2     : in  std_logic_vector(INPUT_SIZE-1 downto 0);
                sum          : in  std_logic_vector(((INPUT_SIZE*2)+CARRY_SIZE)-1 downto 0);
                res_mac      : out std_logic_vector(((INPUT_SIZE*2)+CARRY_SIZE)-1 downto 0); 
                end_mac      : out std_logic
              );
end entity mac;


architecture a1 of mac is
    type states is (IDLE, C1, C2);
    signal EA : states;
    signal produto: std_logic_vector((INPUT_SIZE*2)-1 downto 0);
    signal produto_ext, result: std_logic_vector(((INPUT_SIZE*2)+CARRY_SIZE)-1 downto 0);
begin

    ---------------------------------------------------------------------------- MAC
    produto <= op1*op2;  --  16 bits
    produto_ext <= produto((CARRY_SIZE*2)-1) & produto((CARRY_SIZE*2)-1) & produto((CARRY_SIZE*2)-1) & produto((CARRY_SIZE*2)-1) & produto;  -- signal extension
    result <= sum + produto_ext;

    -- simple fsm to simule the time do execute the MAC
    process(reset, clock)
    begin
          if reset='1' then
             EA <= IDLE;
             end_mac<='0';
             res_mac <= (others=>'0');

          elsif rising_edge(clock) then
            case EA is
                when IDLE   =>  end_mac<='0';
                                if start='1' then EA <= C1;  end if;
                when C1     =>  EA <= C2; 
                when C2     =>  EA <= IDLE;   res_mac <= result; end_mac<='1';
            end case;            
          end if;
    end process;
   
end a1;
