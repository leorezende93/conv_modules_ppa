-------------------------------------------------------------------------------------------------
-- SIMPLE BEHAVORIAL MAC  -  jan/2021 - MORAES                                           20 bits           
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
-- convolution - SYSTOLIC   -  JAN/2021 - MORAES  
-------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use IEEE.std_logic_arith.CONV_STD_LOGIC_VECTOR;

entity conv2d is
     generic (  X_SIZE : integer := 9 ;  
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

    type statesM is (RIDLE, UPDATEADD, END0, END1, END2, END3, END4, END5);
    signal EA_add, PE_add : statesM;

    type statesA is (AIDLE, ARIT1, ARIT2);
    signal EA_arit, PE_arit : statesA;

    signal read_ready, executing_arithmetic, valid_int: std_logic;

    ---- fixed weights ----------------------------------------------------------  READ FROM TEST BENCH - IMPROVE!!!!!!!!!!
    type wgh3x3 is array (0 to 2, 0 to 2) of std_logic_vector(7 downto 0);
    signal weight : wgh3x3;

    type features_3x3 is array (0 to 2, 0 to 2) of std_logic_vector(7 downto 0);  
    signal features, buffer_features : features_3x3;

     -- signals for the convolution 
    type array3x3 is array (0 to 2, 0 to 2) of std_logic_vector(19 downto 0);  -- 20 bits
    signal op1, op2, res_mac, reg_mac : array3x3;

    type control3x3 is array (0 to 2, 0 to 2) of std_logic; 
    signal end_mac : control3x3;

    signal reg_soma : std_logic_vector(19 downto 0);

    signal fim_op, startMac: std_logic;

    type address is array (0 to 5) of std_logic_vector(7 downto 0);
    signal add : address;

    signal weight_x: std_logic_vector(7 downto 0);

    signal cont_steps: std_logic_vector(3 downto 0);

    signal H: integer range 0 to X_SIZE;  
    signal V: integer range 0 to 1024;   --------------------------------------- melhorar

begin

    ----------------------------------------------------------------------------
    -- manages weights
    ----------------------------------------------------------------------------
    process(reset, clock)
    begin
       if reset='1' then
          weight_x       <= (others => '0');
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
   
    -------------------------------------------------------------------------------------------------------
    --  PART 1 - STATE MACHINE THAT CONTROLS THE ARITHMETIC PART
    -------------------------------------------------------------------------------------------------------  
    process(reset, clock)
    begin
          if reset='1' then
             EA_arit <= AIDLE;
             startMac  <= '0';
          elsif rising_edge(clock) then
             EA_arit <= PE_arit;

             if  read_ready='1'  then   -- ****** START THE ARITMETIC OPERATIONS ONE CYCLE AFTER READING  *****
                    startMac  <= '1';
             else
                    startMac  <= '0';
             end if;

          end if;
    end process;

    process (EA_arit, read_ready, fim_op)
    begin
            case EA_arit is
                when AIDLE   => if read_ready='1' then PE_arit<=ARIT1 ;  else  PE_arit <= AIDLE; end if;    -- wait for the memory reading
                when ARIT1  =>  if fim_op='1'     then PE_arit<=ARIT2 ;  else  PE_arit <= ARIT1; end if;    -- wait end MAC
                when ARIT2 =>   PE_arit <= AIDLE;                                                           -- state that manages the additions
            end case;               
    end process;

    -- MANAGES THE REGISTERS AND ADDERS AFTER THE MAC MATRIX ---------------------
    process(reset, clock)
    begin
          if reset='1' then
               cont_steps <= (others=>'0');
               reg_soma  <=  (others=>'0');
               pixel  <=  (others=>'0');
               valid_int <= '0';
          elsif rising_edge(clock) then
            case EA_arit is

                when AIDLE =>   valid_int <= '0';

                when ARIT2 =>   if cont_steps< 7  then    -- stop at 6 - enough to fire accumulation
                                     cont_steps <= cont_steps + 1;
                               end if;

                    if cont_steps > 2  then 
                           reg_soma <=  reg_mac(0,2) + reg_mac(1,2) + reg_mac(2,2);  
                           if  (H+2) < X_SIZE then       -- CONTROLS THE BUBBLE IN THE CONV 2D
                                   valid_int <= '1';
                                   pixel <= reg_soma;  
                            end if; 
                    end if;

               when others => null;
            end case;

        end if;
    end process;

    -- outputs, delaying 'valid' to get stable outputs (pixel) -----------------------------
    process(reset, clock)
    begin
          if reset='1' then
             valid <= '0';
          elsif rising_edge(clock) then
             valid <= valid_int;
          end if;
    end process;

    -- flag to signalize that the arithmetic part is working - stall the reading if MAC too slow
    executing_arithmetic <= '0' when EA_arit=AIDLE  else '1';


    -------------------------------------------------------------------------------------------------------
    -- PART 2 - READING STATE MACHINE. PRINCIPLE: READS SIX ELEMENTS FROM MEMORY AND WAITS FOR CONSUMPTION
    -------------------------------------------------------------------------------------------------------
    process(reset, clock)
    begin
          if reset='1' then
             EA_add <= RIDLE;
          elsif rising_edge(clock) then
             EA_add <= PE_add;
          end if;
    end process;

    process (EA_add, start_line, executing_arithmetic)
    begin
            case EA_add is
                when RIDLE   => if (start_line='1' and weight_en = '0') then PE_add<=END0 ;  else  PE_add <=RIDLE; end if;

                when UPDATEADD  =>  PE_add <= END0;
                when END0       =>  PE_add <= END1;     -- read 6 values from the memory **** continously ****
                when END1       =>  PE_add <= END2;
                when END2       =>  PE_add <= END3;
                when END3       =>  PE_add <= END4;
                when END4       =>  PE_add <= END5;

                when END5       =>  if executing_arithmetic='1' then  -- stalls the reading is computing
                                        PE_add <= END5;
                                    else
                                        PE_add <= UPDATEADD;
                                    end if;
            end case;               
    end process;

    --  memory read address:  based on the address obtained from the reading state machine - two first columns
    address_out <= weight_x when weight_en='1' else
                   add(0) when EA_add=END0 else
                   add(1) when EA_add=END1 else 
                   add(2) when EA_add=END2 else
                   add(3) when EA_add=END3 else
                   add(4) when EA_add=END4 else
                   add(5) ;
    
    -- read from memory filling the features matriz, the first cycle update the addresses
    process(reset, clock)
    begin
          if reset='1' then
               H  <= 0;
               V  <= 0;
               add <= (others =>(others =>'0'));
               buffer_features <= (others=>(others =>(others =>'0')));
               features <= (others=>(others =>(others =>'0')));
               read_ready <= '0';
          elsif rising_edge(clock) then
            case EA_add is

                when UPDATEADD => read_ready <= '0';

                                  --
                                  -- address by columns
                                  --
                                  add(0) <=  CONV_STD_LOGIC_VECTOR(V + H, 8);
                                  add(2) <=  CONV_STD_LOGIC_VECTOR(V + H, 8) + X_SIZE;
                                  add(4) <=  CONV_STD_LOGIC_VECTOR(V + H, 8) + 2*X_SIZE;
         
                                  add(1) <=  add(0) + 1;
                                  add(3) <=  add(2) + 1;
                                  add(5) <=  add(4) + 1;

                                  --
                                  -- NEXT LINE
                                  --                   
                                 if  (H+2) > X_SIZE  then
                                            H <= 0;
                                            V <= V+2*X_SIZE;
                                 else  
                                            H<=H+2;
                                 end if;  

                                 --
                                 -- TRANSFER THE READ DATA, REUSING THE FIRST COLUM TO THE THIRD ONE
                                 --
                                 features(0,0) <= buffer_features(0,0) ;
                                 features(0,1) <= buffer_features(0,1) ;
                                 features(0,2) <=  features(0,0);
                                
                                 features(1,0) <= buffer_features(1,0) ;
                                 features(1,1) <= buffer_features(1,1) ;
                                 features(1,2) <= features(1,0);
                                
                                
                                 features(2,0) <= buffer_features(2,0) ;
                                 features(2,1) <= buffer_features(2,1) ;
                                 features(2,2) <= features(2,0);

               when END0  => buffer_features(0,0) <= data_from_mem; 
               when END1  => buffer_features(0,1) <= data_from_mem;
               when END2  => buffer_features(1,0) <= data_from_mem;   
               when END3  => buffer_features(1,1) <= data_from_mem;   
               when END4  => buffer_features(2,0) <= data_from_mem;   
               when END5  => buffer_features(2,1) <= data_from_mem;  
                             if executing_arithmetic='0' then   -- signalizes the reading of 6 elements from memory
                                        read_ready <= '1';   
                             end if; 

               when others => null;
            end case;

        end if;
    end process;

   -------------------------------------------------------------------------------------------------------
   --- PART 3 *********  MACS AND FLOPS ARRAY - ATTENTION :  ARRANGEMENT IS DIFFERENT FROM 2D  ***********
   -------------------------------------------------------------------------------------------------------

   -- the first column does not hava a previous sum
   cols0:  for j in 0  to 2 generate
              mac0: entity work.mac  
                  port map( clock=>clock, reset=>reset, 
                            sum      => (others=>'0'), 
                            op1      => weight(j,0),  
                            op2      => features(j,0),
                            res_mac  => res_mac(j,0), 
                            start    => startMac,
                            end_mac  => end_mac(j,0) 
                          );
   end generate cols0; 

   -- second and third column with previous column
   cols12: for i in 1  to 2 generate
     rows:  for j in 0  to 2 generate
                     
              mac12: entity work.mac  
                  port map( clock=>clock, reset=>reset, 
                            sum      => reg_mac(j,i-1),                          -- previous sum
                            op1      => weight(j,i),   
                            op2      => features(j,i),
                            res_mac  => res_mac(j,i), 
                            start    => startMac,
                            end_mac  => end_mac(j,i) 
                          );
      end generate rows;  
   end generate cols12;  

    -- vertical pipe registers 
   reg_r:  for i in 0  to 2 generate
     reg_c:  for j in 0  to 2 generate
                             
             ireg: entity work.reg  
                  port map( clock=>clock, reset=>reset, enable=>fim_op,
                            D  => res_mac(j,i), 
                            Q  => reg_mac(j,i) 
                          );

        end generate reg_c;  
   end generate reg_r;

   -- one signal per column to detect completion
   fim_op <= end_mac(0,0) and  end_mac(1,0)  and  end_mac(2,0);

end a1;
