----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.03.2024 11:49:42
-- Design Name: 
-- Module Name: full_adder - Behavioral
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

entity full_adder is
    Port ( 
         x_FA : in STD_LOGIC;
         y_FA : in STD_LOGIC;
         carry_in_FA : in STD_LOGIC;
         sum_FA : out STD_LOGIC;
         carry_out_FA : out STD_LOGIC
        );
end full_adder;

architecture Behavioral of full_adder is

begin

    sum_FA <= x_FA xor y_FA xor carry_in_FA;
    carry_out_FA <= (x_FA and y_FA) or (carry_in_FA and (x_FA xor y_FA));

end Behavioral;
