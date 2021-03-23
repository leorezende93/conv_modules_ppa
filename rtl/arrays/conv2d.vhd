-------------------------------------------------------------------------------------------------
-- SIMPLE BEHAVORIAL MAC  -  out/20120 - MORAES                                           20 bits           
-------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;   -- *** signed to avoid problems *** 

entity mac is
     port    (  clock, reset : in  std_logic;
                start        : in  std_logic;
                op1, op2     : in  std_logic_vector(7 downto 0);
                sum          : in  std_logic_vector(19 downto 0);
                res_mac      : out std_logic_vector(19 downto 0); 
                end_mac      : out std_logic
              );
end entity mac;


architecture a1 of mac is
    type states is (IDLE, C1, C2);
    signal EA : states;
    signal produto: std_logic_vector(15 downto 0);
    signal produto_ext, result: std_logic_vector(19 downto 0);
begin

    ---------------------------------------------------------------------------- MAC
    produto <= op1*op2;  --  16 bits
    produto_ext <= produto(15) & produto(15) & produto(15) & produto(15) & produto;  -- signal extension
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


-------------------------------------------------------------------------------------------------
-- flop    -  out/2020   (simple register) - MORAES                                       20 bits    
-------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity reg is
     port    ( clock, reset : in  std_logic;
               enable       : in  std_logic;
               D            : in std_logic_vector(19 downto 0);
               Q            : out std_logic_vector(19 downto 0)
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
    

-------------------------------------------------------------------------------------------------
-- CONVOLUTION   -  out/20120 - MORAES
-------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use IEEE.std_logic_arith.CONV_STD_LOGIC_VECTOR;

entity conv2d is
     generic (  X_SIZE : integer := 9 ;  
                FILTER_WIDTH : integer := 3 ;
                CONVS_PER_LINE  : integer := 4 
             );
     port    (  clock, reset   : in  std_logic;
                address_out    : out  std_logic_vector(7 downto 0);   -- feature map address
                data_from_mem  : in  std_logic_vector(7 downto 0);    -- value from feature map memory
                start_line     : in std_logic;
                weight_en      : in std_logic;
                valid          : out std_logic;                       -- valid data
                pixel          : out std_logic_vector(19 downto 0)    -- result
             );
end entity conv2d;


architecture a1 of conv2d is

    type states is (ENDIDLE, END0, END1, END2, END3, END4, END5);
    signal EA_add, PE_add : states;

    signal addressX, x, y, weight_x: std_logic_vector(7 downto 0);

    ---- fixed weights ---------------------------------------------------------- 
    --type wgh3x3 is array (0 to 2, 0 to 2) of integer range -128 to 127;  
    --constant weight : wgh3x3;
    type wgh3x3 is array (0 to 2, 0 to 2) of std_logic_vector(7 downto 0);
    signal weight : wgh3x3;
    
    type features_3x3 is array (0 to 2, 0 to 2) of std_logic_vector(7 downto 0);  
    signal features : features_3x3;

     -- signals for the convolution 
    type array3x3 is array (0 to 2, 0 to 2) of std_logic_vector(19 downto 0);  -- 20 bits
    signal op1, op2, res_mac, reg_mac : array3x3;

    type control3x3 is array (0 to 2, 0 to 2) of std_logic; 
    signal end_mac : control3x3;

    signal soma : std_logic_vector(19 downto 0);

    signal fim_op, endRead_and_startMac, d1, d2: std_logic;

    signal count_convolutions: std_logic_vector(4 downto 0);

begin

    ----------------------------------------------------------------------------
    -- manages weights
    ----------------------------------------------------------------------------
   process(reset, clock)
   begin
      if reset='1' then
         weight_x       <= (others => '0');
         --weight_control <= (others => '0');
         weight         <= (others=>(others =>(others =>'0')));
      elsif rising_edge(clock) then
         if (weight_en = '1') then
               
            weight_x <= weight_x + 1;
            
            if (weight_x = 0) then
               weight(0,0) <= data_from_mem;
                              
            elsif (weight_x = 1) then
               weight(0,1) <= data_from_mem;
                              
            elsif (weight_x = 2) then
               weight(0,2) <= data_from_mem;
                             
            elsif (weight_x = 3) then
               weight(1,0) <= data_from_mem;
                              
            elsif (weight_x = 4) then
               weight(1,1) <= data_from_mem;
                             
            elsif (weight_x = 5) then
               weight(1,2) <= data_from_mem;
                              
            elsif (weight_x = 6) then
               weight(2,0) <= data_from_mem;
                              
            elsif (weight_x = 7) then
               weight(2,1) <= data_from_mem;
                              
            elsif (weight_x = 8) then
               weight(2,2) <= data_from_mem;
                              
            end if;
         else
            weight_x <= (others => '0');
         end if;
      end if;
   end process;


    ----------------------------------------------------------------------------
    -- manages the x and y addresses
    ----------------------------------------------------------------------------
    process(reset, clock)
    begin
          if reset='1' then
              x <= (others => '0');
              y <= (others => '0');
          elsif rising_edge(clock) then
             if EA_add = END5 then
                if x+2 < X_SIZE then
                   x <= x+2;       -- at the end of the reading cycle add 2 to the x coordinate
                else
                   x <= (others => '0');   -- start of a new line
                   y <= y + 2*X_SIZE;
                end if;
            end if;
          end if;
    end process;
    
    ----------------------------------------------------------------------------
    -- state machine to manage the feature map access
    -- the idea is to make 6 readings - assuming stride=1
    ----------------------------------------------------------------------------
    process(reset, clock)
    begin
          if reset='1' then
             EA_add <= ENDIDLE;
          elsif rising_edge(clock) then
             EA_add <= PE_add;
          end if;
    end process;

    process (EA_add,start_line, fim_op)
    begin
            case EA_add is
                when ENDIDLE =>  -- advance with an external command or when the computation finishes
                                 if start_line='1' or fim_op='1' then
                                        PE_add <= END0;
                                   else 
                                        PE_add <= ENDIDLE; 
                                 end if;
                                 addressX <= x;

                when END0    =>  PE_add <= END1;
                                 addressX <= x;       --------------------------- addresses to access memory

                when END1    =>  PE_add <= END2;
                                 addressX <= x + X_SIZE;

                when END2    =>  PE_add <= END3;
                                 addressX <= x + 2*X_SIZE;

                when END3    =>  PE_add <= END4;
                                 addressX <= (x-1);

                when END4    =>  PE_add <= END5;
                                 addressX <= (x-1) + X_SIZE;

                when END5    =>  PE_add <= ENDIDLE;             
                                 addressX <= (x-1) + 2*X_SIZE;
            end case;               
    end process;


    -- defines the address to the feature map avoiding invalid addresses (em END3 pode-se gerar x<0) 
    address_out <= addressX+y  when (addressX>=0 and weight_en = '0')  else 
                   weight_x;

    -- read from memory filling the features matriz (buffer)
    process(reset, clock)
    begin
          if reset='1' then
             features <= (others=>(others =>(others =>'0')));
             endRead_and_startMac <= '0';
          elsif rising_edge(clock) then
            case EA_add is

               when END0  =>  if count_convolutions>1 then        -- BIG TRICK - FILL THE LAST 3 BUFFERS WITH THE 3 FIRTS ONES
                                 features(2,0) <= features(0,0);  -- REUSING DUE TO THE STRIDE!  REDUCES 1/3 THE MEMORY ACCESSES
                                 features(2,1) <= features(0,1); 
                                 features(2,2) <= features(0,2);
                             end if;

                             features(0,0) <= data_from_mem;  

               when END1  => features(0,1) <= data_from_mem;

               when END2  => features(0,2) <= data_from_mem;

               when END3  => if x>0 then features(1,0)<=data_from_mem;  else features(1,0)<=(others =>'0');  end if;

               when END4  => if x>0 then features(1,1)<=data_from_mem;  else features(1,1)<=(others =>'0');  end if;

               when END5  => if x>0 then features(1,2)<=data_from_mem;  else features(1,2)<=(others =>'0');  end if;
                             endRead_and_startMac <= '1';

               when others => endRead_and_startMac <= '0';
            end case;

        end if;
    end process;

   -------------------------------------------------------------------------------------------------- 
   --- macs and flops array
   -------------------------------------------------------------------------------------------------

   -- the first column does not hava a previous sum
   cols0:  for j in 0  to 2 generate
              mac0: entity work.mac  
                  port map( clock=>clock, reset=>reset, 
                            sum      => (others=>'0'), 
                            --op1      => CONV_STD_LOGIC_VECTOR(weight(j,0),8),  -- caution to read the weihts
                            op1      => weight(j,0),  -- caution to read the weihts
                            op2      => features(0, j),
                            res_mac  => res_mac(0,j), 
                            start    => endRead_and_startMac,
                            end_mac  => end_mac(0,j) 
                          );
   end generate cols0; 

   -- second and third column with previous column
   cols12: for i in 1  to 2 generate
     rows:  for j in 0  to 2 generate
                     
              mac12: entity work.mac  
                  port map( clock=>clock, reset=>reset, 
                            sum      => reg_mac(i-1,j),                          -- previous sum
                            --op1      => CONV_STD_LOGIC_VECTOR(weight(j,i),8),    -- caution to read the weihts
                            op1      => weight(j,i),    -- caution to read the weihts
                            op2      => features(i, j),
                            res_mac  => res_mac(i,j), 
                            start    => endRead_and_startMac,
                            end_mac  => end_mac(i,j) 
                          );
      end generate rows;  
   end generate cols12;  

    -- pipe registers 
   reg_r:  for i in 0  to 2 generate
     reg_c:  for j in 0  to 2 generate
                             
             ireg: entity work.reg  
                  port map( clock=>clock, reset=>reset, enable=>fim_op,
                            D  => res_mac(i,j), 
                            Q  => reg_mac(i,j) 
                          );

        end generate reg_c;  
   end generate reg_r;

   -- one signal per column to detect completion
   fim_op <= end_mac(0,0) and  end_mac(1,0)  and  end_mac(2,0);

   -- compute the result (it may be valid or invalid)
   soma <=  reg_mac(2,0) +  reg_mac(2,1) +  reg_mac(2,2);

    ----------------------------------------------------------------------------
    -- two clock cycles to store the result and count the executed convolutions
    ----------------------------------------------------------------------------
    process(reset, clock)
    begin
          if reset='1' then
             d1 <= '0';
             d2 <= '0';
             valid <= '0';
             count_convolutions <= (others=>'0');
             pixel <= (others=>'0');
          elsif rising_edge(clock) then
             d1 <= fim_op;
             d2 <= d1;                
             if count_convolutions>=FILTER_WIDTH and count_convolutions<(FILTER_WIDTH + CONVS_PER_LINE) then
                  valid <= d2;       
                  pixel <= soma;     -- SIGNALIZES TO THE EXTERNAL WORLD VALIDA DATA
             end if;

             if fim_op='1'  then
                 if count_convolutions >   (FILTER_WIDTH + CONVS_PER_LINE - 2) then
                      count_convolutions <= ( 1=>'1', others=>'0');   -- ja começa com 2 (aqui é onde perdi tempo! saco!)
                 else
                     count_convolutions <= count_convolutions+1;
                 end if;
             end if;

          end if;
    end process;
 
end a1;
