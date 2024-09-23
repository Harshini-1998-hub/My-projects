----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.03.2024 14:59:21
-- Design Name: 
-- Module Name: mux_2-1 - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux_2_1 is
    Port ( IR : in STD_LOGIC_VECTOR (3 downto 0);
           inc : in STD_LOGIC_VECTOR (3 downto 0);
           sel : in STD_LOGIC ;
           mux_out : out STD_LOGIC_VECTOR (3 downto 0)
         );
end mux_2_1;

architecture Behavioral of mux_2_1 is
    
begin

    process
    begin 
        if sel = '0' then
            mux_out <= IR;
        else
            mux_out <= inc;
        end if;    
    end process;

end Behavioral;
