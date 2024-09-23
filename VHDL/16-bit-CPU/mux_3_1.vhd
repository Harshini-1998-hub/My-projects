----------------------------------------------------------------------------------
-- Company: 
-- Engineer: HARSHINI
-- 
-- Create Date: 13.03.2024 16:17:11
-- Design Name: 
-- Module Name: mux_3_1 - Behavioral
-- Project Name: Assignment 2 - CPU DESIGN
-- Target Devices: 
-- Tool Versions: 
-- Description: This is a program for 4:1 mux but its mentioned as 3:1 because of its last 2 inputs 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE; -- 'IEEE'for standard logic operations and UNISIM for components provided by Xilinx for simulation purposes.
use IEEE.STD_LOGIC_1164.ALL; --defines the basic data types for representing digital signals (std_logic, std_logic_vector) and provides operators for working with these types.

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL; -- provides numeric types such as signed and unsigned, as well as functions and operators for arithmetic operations on these types.

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM; --allows to use simulation models during simulation. These models are essential for accurately simulating the behavior of design, especially if it includes Xilinx-specific primitives
use UNISIM.VComponents.all; --library available for use in design without needing to explicitly specify each component. This simplifies your code and makes it easier to include Xilinx-specific primitives in your design.

entity mux_3_1 is --" mux_3_1" entity declares x_instruction, y_instruction, z_instruction, select_IE, out_mux
    Port ( x_instruction : in STD_LOGIC_VECTOR (15 downto 0); --from instruction
           y_instruction : in STD_LOGIC_VECTOR (15 downto 0); --from switch
           ALU_output : in STD_LOGIC_VECTOR (15 downto 0); --from ALU output
           select_IE : in std_logic_vector (1 downto 0); -- select pin 
           out_mux : out STD_LOGIC_VECTOR (15 downto 0)); -- output
end mux_3_1;

architecture Behavioral of mux_3_1 is -- " Behavioral architecture" defines the behavior of the mux_3_1 entity.

begin
    
    process (select_IE) --sensitive to the changes in select pin
    begin
        if select_IE = "00" then -- if select pin is "00", intput is from instruction
            out_mux <= x_instruction; -- represents input from the instruction itself 
        elsif select_IE = "01" then -- if select pin is "01", intput is from switches
            out_mux <= y_instruction; -- output is the value of switches
        elsif select_IE = "10" then -- if select pin is "10", intput is from ALU output
            out_mux <= ALU_output; -- output is the value of ALU output
        elsif select_IE = "11" then -- if select pin is "10", intput is from ALU output
            out_mux <= ALU_output; -- output is the value of ALU output 
                
        end if;
    end process;  -- end process
end Behavioral; -- terminate architecture
