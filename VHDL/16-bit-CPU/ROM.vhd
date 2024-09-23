----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.03.2024 12:34:28
-- Design Name: 
-- Module Name: Read_Only_Memory - Behavioral
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

entity ROM is
    Port ( address : in STD_LOGIC_VECTOR (3 downto 0);
           data_out : out STD_LOGIC_VECTOR (9 downto 0));
end ROM;

architecture Behavioral of ROM is

    type program is array (0 to 15) of std_logic_vector(9 downto 0); --16 locations
    signal first_code : program := (
        "0010000011", -- IN Rdd //0// READ INPUT TO R3
        "1111000001", -- MOV Rdd, #nnnn //1// INIT R0 = 1
        "1111010000", -- MOV Rdd, #nnnn //2// INIT R1 = 0
        "1011010001", -- ADD Rdd, Rrr, Rqq //3// R1 = R0 + R1
        "1001000001", -- INC Rrr, #nnnn //4// R0 = R0 + 1
        "1000000011", -- LT Rrr, Rqq //5// IF R0 < R3 THEN Z = 0 ELSE Z = 1
        "0110000011", -- JNZ aaaa //6// IF Z == 0  THEN GO ADDR 03 ELSE GO NEXT ADDR
        "0011000001", -- OUT Rss //7// OUTPUT R1
        others => ("0000000000") -- HALT //8// OVER 
       );
        
        
        signal current_program : program := first_code; ---assign address
    
begin

    data_out <= current_program (to_integer(unsigned(address)));  --adress is converted to unsigned int., and coverted to regular integer
    
end Behavioral;
