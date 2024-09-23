----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.03.2024 16:01:10
-- Design Name: 
-- Module Name: d_ff - Behavioral
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

entity d_ff is
    Port ( d : in STD_LOGIC_VECTOR (15 downto 0);
           E : in STD_LOGIC;
           clk : in STD_LOGIC;
           Q : out STD_LOGIC);
end d_ff;

architecture Behavioral of d_ff is

    signal d_in: std_logic;
    
begin
    
    d_in <= not(d(0) or d(1)or d(2) or d(3) or d(4) or d(5) or d(6) or d(7) or d(8) or d(9) or d(10) or d(11) or d(12) or d(13) or d(14) or d(15));
    
    process
    begin
        if E = '1' then 
            if rising_edge (clk) then
                Q <= d_in;
            end if;
        end if;
    end process;
    
   
    
end Behavioral;
