----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.03.2024 23:28:51
-- Design Name: 
-- Module Name: Control_Unit - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity Control_Unit is
    Port ( 
           PCload_CU : out STD_LOGIC;
           IRload_CU : out STD_LOGIC;
           IE_CU : out STD_LOGIC_VECTOR (1 downto 0);
           WE_CU : out STD_LOGIC;
           WA_CU : out STD_LOGIC_VECTOR (1 downto 0);
           RAE_CU : out STD_LOGIC;
           RAA_CU : out STD_LOGIC_VECTOR (1 downto 0);
           RBE_CU : out STD_LOGIC;
           RBA_CU : out STD_LOGIC_VECTOR (1 downto 0);
           OP_CU : out STD_LOGIC_VECTOR (2 downto 0);
           ZE_CU : out STD_LOGIC;
           Z_CU : in STD_LOGIC;
           OE_CU : out STD_LOGIC;
           J_MUX_SEL : out STD_LOGIC;
           MUX_3_1_X_INSTRUCTION: out STD_LOGIC_VECTOR(15 downto 0);
           IR : IN STD_LOGIC_VECTOR (9 downto 0);
           clk : IN STD_LOGIC;
           reset : IN STD_LOGIC
           );
end Control_Unit;

architecture Behavioral of Control_Unit is

    signal extended_bit : std_logic_vector(11 downto 0):= "000000000000";

    type cu_state is (FETCH, DECODE, INPUT, MOV_RDD_NNNN, MOV_RDD_RSS, JMP, JN, DEC, 
                                     ADD, INC, LT,JNZ, OUT_INS, HALT, NOT_INS, SUB, AND_INS, OR_INS );
                                        
    signal current_state : cu_state := FETCH; 
    
begin

    process (clk, reset)
    begin
        if reset = '1' then
            current_state <= FETCH;
            
        elsif rising_edge (clk) then
            PCload_CU <= '0';
            IRload_CU <= '0';
            
            case current_state is
                when FETCH => 
                    PCload_CU <= '1';
                    IRload_CU <= '1';
                    current_state <= DECODE;
                    
                when DECODE =>
                    case IR is 
                        when "0010000011" =>
                            current_state <= INPUT ;
                        when "1111000001" =>
                            current_state <= MOV_RDD_NNNN ;
                        when "1111010000" =>
                            current_state <= MOV_RDD_RSS ;
                        when "1011010001" =>
                            current_state <= ADD ;
                        when "1001000001" =>
                            current_state <= INC ;
                        when "1000000011" =>
                            current_state <= LT ;
                        when "0110000011" =>
                            current_state <= JNZ ;
                        when "0011000001" =>
                            current_state <= OUT_INS ;
                        when "0000000000" =>
                            current_state <= HALT ;
                        when others =>
                            current_state <= HALT ;                             
                       end case;
                               
                when INPUT =>  
                    IE_CU <= "01"; --read from switch
                    WE_CU <= '1';
                    WA_CU <= IR(1 downto 0); -- IN Rdd //0// READ INPUT TO R3
                    OE_CU <= '0';
                    current_state <= FETCH ; 
                    
                when MOV_RDD_NNNN =>
                    J_MUX_SEL <= '1';
                    IE_CU <= "00"; --read from IR (10 bit)
                    WE_CU <= '1';
                    WA_CU <= IR(5 downto 4); -- MOV Rdd, #nnnn //1// INIT R0 = 1
                    MUX_3_1_X_INSTRUCTION <= "000000000000" & IR(3 downto 0);
                    OE_CU <= '0';    
                    current_state <= FETCH ; 
                             
                when MOV_RDD_RSS =>
                    J_MUX_SEL <= '1';
                    IE_CU <= "00"; --read from IR (10 bit)
                    WE_CU <= '1';
                    WA_CU <= IR(5 downto 4); -- MOV Rdd, #nnnn //2// INIT R1 = 0
                    MUX_3_1_X_INSTRUCTION <= "000000000000" & IR(3 downto 0);
                    OE_CU <= '0';    
                    current_state <= FETCH ; 
                    
                when ADD =>
                    J_MUX_SEL <= '1';
                    WE_CU <= '1';
                    WA_CU <= IR(5 downto 4); -- ADD Rdd, Rrr, Rqq //3// R1 = R0 + R1
                    RAE_CU <= '1';
                    RAA_CU <= IR(3 downto 2);
                    RBE_CU <= '1';
                    RBA_CU <= IR(1 downto 0);
                    OP_CU <= "100";
                    OE_CU <= '0';    
                    current_state <= FETCH ;                               
                                    
                when INC =>
                    IE_CU <= "00";
                    J_MUX_SEL <= '1';
                    WE_CU <= '1';
                    WA_CU <= IR(5 downto 4); -- INC Rrr, #nnnn //4// R0 = R0 + 1
                    RAE_CU <= '1';
                    RAA_CU <= IR(5 downto 4);
                    RBE_CU <= '0';
                    MUX_3_1_X_INSTRUCTION <= "0000000000000001"; 
                    OP_CU <= "100";
                    OE_CU <= '0';    
                    current_state <= FETCH ;  
                                                                                              
                when LT => -- LT Rrr, Rqq //5// IF R0 < R3 THEN Z = 0 ELSE Z = 1
                    WE_CU <= '0';
                    RAE_CU <= '1';
                    RAA_CU <= IR(1 downto 0); --R3
                    RBE_CU <= '1';
                    RBA_CU <= IR(3 downto 2); --R1
                    OP_CU <= "101";
                    OE_CU <= '0';
                    ZE_CU <= '1';
                    if(Z_CU = '0') then
                        current_state <= JNZ; -- JNZ aaaa //6// IF Z == 0  THEN GO ADDR 03 ELSE GO NEXT ADDR
                    else 
                        current_state <= OUT_INS;    -- OUT Rss //7// OUTPUT R1                   
                    end if;
                                                                      
                when JNZ =>  -- JNZ aaaa //6// IF Z == 0  THEN GO ADDR 03 ELSE GO NEXT ADDR
                    if(Z_CU = '0') then
                        J_MUX_SEL <= '0'; 
                    end if;     

                when OUT_INS => -- OUT Rss //7// OUTPUT R1
                     OE_CU <= '1';
                     RAE_CU <= '1';
                     RAA_CU <= IR(1 downto 0);
                     OP_CU <= "000";
                     current_state <= FETCH ; 
                    
                when HALT =>
                    --000000000000 halt    
                    
                when NOT_INS => 
                    -- 010000ddss 
                
                when JMP => 
                    -- 010100aaaa  
                
                when JN => 
                    -- 011100aaaa 
                
                when DEC =>
                    -- 1010rrnnnn 
                    
                when SUB => 
                    -- 1100ddrrqq 
                
                when AND_INS => 
                    -- 1101ddrrqq 
                 
                when OR_INS => 
                    -- 1110ddrrqq  
                            
            end case;
            end if;
     end process;
    

end Behavioral;
