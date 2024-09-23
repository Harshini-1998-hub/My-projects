----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.03.2024 11:24:42
-- Design Name: 
-- Module Name: arithematic_extender - Behavioral
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

entity arithematic_extender is
    Port (
           s_AE : in STD_LOGIC_VECTOR (2 downto 0);
           b_AE : in STD_LOGIC;
           y_AE : out STD_LOGIC);
end arithematic_extender;

architecture Behavioral of arithematic_extender is

begin
    process                            
    begin
        case (s_AE) is  
            when "000" =>  -- PASS
                y_AE <= '0';
            when "001" =>  -- AND
                y_AE <= '0';                
            when "010" =>  -- OR
               y_AE <= '0';      
            when "011" =>  -- NOT
                y_AE <= '0';               
            when "100" =>  -- ADDITION
                y_AE <= b_AE;               
            when "101" =>  -- SUBTRACTION
                y_AE <= b_AE;               
            when "110" =>  -- INCREMENT
                y_AE <= '0';
            when "111" =>  -- DECREMENT
                y_AE <= '0'; 
            when others =>  --changed this be carefullllllllllll                                        
                y_AE <= '0';
        end case;
    end process;
    

end Behavioral;
