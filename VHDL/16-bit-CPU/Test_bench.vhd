----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.03.2024 10:50:26
-- Design Name: 
-- Module Name: Test_bench - Behavioral
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

entity Test_bench is
    Port ( clk : out STD_LOGIC;
           btnC : in STD_LOGIC;
           an : out STD_LOGIC_VECTOR (3 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0));
end Test_bench;

architecture Behavioral of Test_bench is

begin

    CPU_Testbench: entity work.CPU port map (
                clk => clk,
                btnC => btnC,
                an => an,
                sw => sw,
                seg => seg
    );
    
    process 
    begin 
        while TRUE loop
        clk <= '0';
        wait for 20ns;
        clk <= '1';
        wait for 20ns;
        end loop;
    end process;

end Behavioral;
