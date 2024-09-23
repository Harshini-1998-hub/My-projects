----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.03.2024 11:37:39
-- Design Name: 
-- Module Name: logic_extender - Behavioral
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

entity logic_extender is
    Port ( s_LE : in STD_LOGIC_VECTOR (2 downto 0);
           a_LE : in STD_LOGIC;
           b_LE : in STD_LOGIC;
           x_LE : out STD_LOGIC
          );
end logic_extender;

architecture Behavioral of logic_extender is
    
begin

    process                            
    begin
        case (s_LE) is  
            when "000" =>  -- PASS
                x_LE <= a_LE;
            when "001" =>  -- AND
                x_LE <= a_LE and b_LE;                
            when "010" =>  -- OR
               x_LE <= a_LE or b_LE;      
            when "011" =>  -- NOT
                x_LE <= not a_LE;               
            when "100" =>  -- ADDITION
                x_LE <= a_LE;               
            when "101" =>  -- SUBTRACTION
                x_LE <= a_LE;               
            when "110" =>  -- INCREMENT
                x_LE <= a_LE;
            when "111" =>  -- DECREMENT
                x_LE <= a_LE; 
            when others =>  --changed this be carefullllllllllll                                        
                x_LE  <= '0';                                                       
        end case;
    end process;

    
end Behavioral;
