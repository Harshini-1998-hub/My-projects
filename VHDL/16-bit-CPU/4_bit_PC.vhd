----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.03.2024 13:26:27
-- Design Name: 
-- Module Name: 4_bit_PC - Behavioral
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

entity PC is
    Port ( 
         D : in STD_LOGIC_VECTOR (3 downto 0);
         PC_load : in STD_LOGIC;
         reset : in STD_LOGIC;
         clk : in STD_LOGIC;
         PC : out STD_LOGIC_VECTOR (3 downto 0));
end PC;

architecture Behavioral of PC is

begin

    process (clk)
        begin
        if reset = '1' then
            PC <= (others => '0');
        elsif PC_load = '1' then
            if rising_edge (clk) then
                PC <= D ;
            end if;
        end if;
    end process;

end Behavioral;
