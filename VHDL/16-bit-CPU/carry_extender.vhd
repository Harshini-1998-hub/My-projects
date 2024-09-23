----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.03.2024 11:42:00
-- Design Name: 
-- Module Name: carry_extender - Behavioral
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

entity carry_extender is
    Port (
           s_CE : in STD_LOGIC_VECTOR (2 downto 0);
           cout_CE : out STD_LOGIC
         );
end carry_extender;

architecture Behavioral of carry_extender is

begin

    process                            
    begin
        case (s_CE) is  
            when "000" =>  -- PASS
                cout_CE <= '0';
            when "001" =>  -- AND
                cout_CE <= '0';                
            when "010" =>  -- OR
               cout_CE <= '0';      
            when "011" =>  -- NOT
                cout_CE <= '0';               
            when "100" =>  -- ADDITION
                cout_CE <= '0';               
            when "101" =>  -- SUBTRACTION
                cout_CE <= '1';               
            when "110" =>  -- INCREMENT
                cout_CE <= '1';
            when "111" =>  -- DECREMENT
                cout_CE <= '0'; 
            when others =>  --changed this be carefullllllllllll                                     
                cout_CE <= '0';
        end case;
    end process;
end Behavioral;
