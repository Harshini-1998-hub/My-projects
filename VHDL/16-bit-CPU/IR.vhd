----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.03.2024 18:28:12
-- Design Name: 
-- Module Name: IR - Behavioral
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

entity IR is
    Port ( D : in STD_LOGIC_VECTOR (9 downto 0);
           IR_load : in STD_LOGIC;
           clk : in STD_LOGIC;
           IR : out STD_LOGIC_VECTOR (9 downto 0));
end IR;

architecture Behavioral of IR is

begin

    process
    begin
        if rising_edge (clk) then
            if IR_load = '1' then
               IR <= D; 
            end if;
        end if;
        
    end process;
end Behavioral;
