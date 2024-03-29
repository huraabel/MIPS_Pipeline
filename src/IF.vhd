

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;


entity IF1 is
  Port (
    clk : in std_logic;
    ce : in std_logic;
    addr_branch : in std_logic_vector(15 downto 0);
    addr_jump : in std_logic_vector(15 downto 0);
    PCSrc : in std_logic;
    JUMP : in std_logic;
    reset_pc:in std_logic;
    curent_instruction: out std_logic_vector(15 downto 0);
    next_instruction : out std_logic_vector(15 downto 0)
    
   );
end IF1;

    

architecture Behavioral of IF1 is
    --signal noOp : std_logic_vector(15 downto 0) := X"0000";
    type rom is array (0 to 255) of std_logic_vector (15 downto 0);
	
   	signal rom_file : rom :=
   	(
   	        
   	     0=>(X"0010"),     --000_000_000_001_0_000            -- add $1,$0,$0                      #i=0
   	     1=>(X"0040"),     --000_000_000_100_0_000            -- add $4,$0,$0                      #gasit=0
   	     2=>(X"2183"),     --001_000_011_0000011              -- addi $3,$0,3                     #f=3
   	     3=>(X"0020"),     --000_000_000_010_0_000            -- add $2,$0,$0                      #init index memorie
   	     4=>(X"228A"),     --001_000_101_0001010              -- addi $5,,$0,10                    #vom compara 10 cu i
   	        5=>X"0000",
   	        6=>X"0000",
   	        7=>X"0000", 
   	     8=>(X"8696"),     --100_001_101_0010110              -- begin_loop: beq $1,$5,end_loop    # compara i cu 100
   	        9=>X"0000",
   	        10=>X"0000",
   	        11=>X"0000",
   	     12=>(X"4B28"),     --010_010_110_0101000              -- lw $6,A_addr($2)                  #scoate elementul pe pozitia curenta
   	        13=>X"0000",
   	        14=>X"0000",
   	        15=>X"0000",
   	     16=>(X"8F0A"),     --100_011_110_0001010              -- beq $3,$6,found                   #daca a gasit jump la found
   	        17=>X"0000",
            18=>X"0000",
            19=>X"0000",
   	     20=>(X"2901"),     --001_010_010_0000001              -- addi $2,$2,1                      #increment pozitie memo
   	     21=>(X"2481"),     --001_001_001_0000001              -- addi $1,$1,1                      #incrememt contor i
   	        22=>X"0000",
   	        23=>X"0000",
   	        24=>X"0000",
   	     25=>(X"E008"),    --111_0000000001000                -- j begin_loop                      #jump inapoi la begin_loop daca nu a gasit
   	        26=> X"0000",
   	     27=>(X"2201"),    --001_000_100_0000001              -- found: addi $4,$0,1               #daca a gasit marcam , gasit=1
   	        28=>X"0000",
   	        29=>X"0000",
   	        30=>X"0000",
   	     31=>(X"6210"),    --011_000_100_0010000              -- sw $4,gasit_addr($0)              #memoram in memorie
   	     32=>(X"4310"),    --010_000_110_0010000              -- lw $6,gasit_addr($0)   
   	     others => X"0000"
   	) ;
   	

signal PC : std_logic_vector(15 downto 0) :=X"0000";
signal PC_1 : std_logic_vector(15 downto 0) :=X"0001";
signal branch_out : std_logic_vector(15 downto 0) :=X"0000";
signal newPC :  std_logic_vector(15 downto 0) :=X"0000";
begin
    
    --PC
    process(clk,reset_pc)
    begin
    
        if(reset_pc='1') then
            pc<=X"0000";
         elsif  (rising_edge(clk)) then
              if(ce='1') then
                  pc <= newPC;
              end if;
        end if;
    end process;
    
    curent_instruction <= rom_file(conv_integer(pc(7 downto 0)));
    
    pc_1 <= pc + 1;
    next_instruction <= pc_1;
    
    --MUX pcsrc
    process(PCSrc, pc_1, addr_branch)
    begin
        case PCSrc is
            when '0' => branch_out <= pc_1;
            when others => branch_out <= addr_branch;
        end case;
    
    end process;
    
    
    --MUX jump
    process(jump, addr_jump, branch_out)
    begin
        case jump is
            when '1' => newPC <= addr_jump;
            when others => newPC <= branch_out;
        end case;
    end process;
    
    

end Behavioral;
