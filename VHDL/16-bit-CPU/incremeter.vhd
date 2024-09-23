----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.03.2024 13:58:31
-- Design Name: 
-- Module Name: incremeter - Behavioral
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

entity incrementer is
    Port ( inc_input : in STD_LOGIC_VECTOR (3 downto 0);
           inc_output : out STD_LOGIC_VECTOR (3 downto 0));
end incrementer;

architecture Behavioral of incrementer is

    constant increment_value : std_logic_vector(3 downto 0) := "0001";
    constant c_in : std_logic := '0';
    signal cout_1 : std_logic_vector (3 downto 0);
    signal cout : std_logic ;

begin

      adder_increment: entity work.full_adder port map(
            x_FA => inc_input(0),
            y_FA => increment_value(0),
            carry_in_FA => c_in,
            sum_FA => inc_output(0),
            carry_out_FA => cout_1(0)
          );
  
   g_GENERATE_FOR: for i in 1 to 3 generate
            adder_increment_other : entity work.full_adder port map(
            x_FA => inc_input(i),
            y_FA => increment_value(i),
            carry_in_FA => cout_1(i-1),
            sum_FA => inc_output(i),
            carry_out_FA => cout_1(i)
          );
  end generate g_GENERATE_FOR;
  
  cout <= cout_1(3);

end Behavioral;
