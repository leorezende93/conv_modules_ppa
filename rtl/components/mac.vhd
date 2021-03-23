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
      port   (  op1, op2     : in  std_logic_vector(INPUT_SIZE-1 downto 0);
                sum          : in  std_logic_vector(((INPUT_SIZE*2)+CARRY_SIZE)-1 downto 0);
                res_mac      : out std_logic_vector(((INPUT_SIZE*2)+CARRY_SIZE)-1 downto 0)
              );
end entity mac;


architecture a1 of mac is
    signal produto: std_logic_vector((INPUT_SIZE*2)-1 downto 0);
    signal produto_ext: std_logic_vector(((INPUT_SIZE*2)+CARRY_SIZE)-1 downto 0);
begin
    produto <= op1*op2;  --  16 bits
    produto_ext <= produto((CARRY_SIZE*2)-1) & produto((CARRY_SIZE*2)-1) & produto((CARRY_SIZE*2)-1) & produto((CARRY_SIZE*2)-1) & produto;  -- signal extension
    res_mac <= sum + produto_ext;   
end a1;
