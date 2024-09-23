----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.02.2024 10:08:40
-- Design Name: 
-- Module Name: clock_divider - Behavioral
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
----------------------------------------------------------------------------------------------------------------------------------
-- This program is Frequency divider, where 100MHz clock is used, on the risibg edge of each clock, count_out value is updated to 1
-- this is used for main3_program
----------------------------------------------------------------------------------------------------------------------------------

library IEEE; -- 'IEEE'for standard logic operations and UNISIM for components provided by Xilinx for simulation purposes.
use IEEE.STD_LOGIC_1164.ALL; -- 'IEEE'for standard logic operations and UNISIM for components provided by Xilinx for simulation purposes.
use IEEE.numeric_std.ALL; -- VHDL package that provides numeric types and operations. It includes definitions for types such as unsigned, signed, and functions for arithmetic operations like addition, subtraction, multiplication, etc., on these types. 

entity Clock_Divider is --"Clock Divider" entity declares 3 ports clk,reset and clock_out and one generic map
    generic (  -- Generics are like parameters for VHDL entities, allowing me to customize behavior without modifying their internal code.
        THRESHOLD : integer := 100000000 --set the division factor for the clock.
    ); 
    port (
        clk,reset: in std_logic;
        clock_out: out std_logic);
end Clock_Divider; -- end entity

architecture bhv of Clock_Divider is -- " bhv architecture" defines the behavior of the Clock_Divider.

    signal count: integer:=1; -- used to count the clock cycles

begin -- beginning of the executable part where I write VHDL code. It follows the port declarations and any other declarations necessary for my design.

    process(clk,reset) --The process is sensitive to changes in clk and reset.
    begin
        if(reset='1') then --if reset is '1' count is '1'
            count <= 1; 
        elsif(rising_edge(clk)) then --on rising edge of clock count is incremented by '1'
            count <= count + 1; --count is incremented to 1
            if (count = THRESHOLD) then --If count reaches the specified threshold (THRESHOLD), clock_out is set high ('1') and count is reset to 1.
                clock_out <= '1';
                count <= 1;
            else
                clock_out <= '0'; --Otherwise, clock_out remains low ('0')
            end if;
        end if;
    end process; --end process

end bhv; -- terminate architecture
