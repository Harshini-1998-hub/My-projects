----------------------------------------------------------------------------------
-- Company: 
-- Engineer: HARSHINI
-- 
-- Create Date: 13.03.2024 17:07:12
-- Design Name: 
-- Module Name: RF - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Program for register files
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE; -- 'IEEE'for standard logic operations and UNISIM for components provided by Xilinx for simulation purposes.
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity RF is
    Port ( clk : in STD_LOGIC;
           WE_RF : in STD_LOGIC;
           WA_RF : in STD_LOGIC_VECTOR (1 downto 0);
           RAE_RF : in STD_LOGIC;
           RAA_RF : in STD_LOGIC_VECTOR (1 downto 0);
           RBE_RF : in STD_LOGIC;
           RBA_RF : in STD_LOGIC_VECTOR (1 downto 0);
           input_ID : in STD_LOGIC_VECTOR (15 downto 0);
           Aout : out STD_LOGIC_VECTOR (15 downto 0);
           Bout : out STD_LOGIC_VECTOR (15 downto 0));
end RF;

architecture Behavioral of RF is

    subtype reg is std_logic_vector (15 downto 0);
    type regArray is array (0 to 3) of reg;
    signal reg_file: regArray;

begin
    
    WritePort: process
    begin
    
        wait until rising_edge(clk);
        if WE_RF = '1' then
            reg_file (to_integer(unsigned(WA_RF))) <= input_ID;
        end  if;
   end process;
       
   -- READ PORT A
   Aout <= reg_file (to_integer(unsigned(RAA_RF))) when RAE_RF = '1'
   else (others => '0');
   
   -- READ PORT b
   Bout <= reg_file (to_integer(unsigned(RBA_RF))) when RBE_RF = '1'
   else (others => '0');  
   
end Behavioral;
