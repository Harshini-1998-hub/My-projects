----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.02.2024 20:16:16
-- Design Name: 
-- Module Name: 7_segment_display - Behavioral
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

--------------------------------------------------------------------------------------------------------------------------------------------------------

--7-segment decoder: the user should be able to use the rightmost four switches, SW3-SW0, to input a BCD (0-9) digit that is then displayed (duplicated)
--on all four digits of the Basys3 display;

--------------------------------------------------------------------------------------------------------------------------------------------------------

-- This VHDL code defines an entity named "one digit" , which represents a single-digit seven-segment display. It has three input ports: 
-- "digit" (a 4-bit input representing the digit value to be displayed), "seg"  (a 7-bit output representing the segments to be illuminated 
-- on the display to form the desired digit), and "an" (a 4-bit output representing the anodes of the display).

--------------------------------------------------------------------------------------------------------------------------------------------------------


library IEEE; -- 'IEEE'for standard logic operations and UNISIM for components provided by Xilinx for simulation purposes.
use IEEE.STD_LOGIC_1164.ALL; --defines the basic data types for representing digital signals (std_logic, std_logic_vector) and provides operators for working with these types.
library UNISIM; --allows to use simulation models during simulation. These models are essential for accurately simulating the behavior of design, especially if it includes Xilinx-specific primitives
use UNISIM.VComponents.all; --library available for use in design without needing to explicitly specify each component. This simplifies your code and makes it easier to include Xilinx-specific primitives in your design.


entity one_digit is --"one-digit" entity declares 3 ports digit, seg, an
    Port ( digit : in STD_LOGIC_VECTOR (3 downto 0); -- "digit" port is 4 bit, in which each bit is connected to each switch 
           seg : out STD_LOGIC_VECTOR (6 downto 0); -- "seg" port is 7-segment display consists of seven segments, numbered 0 to 6 or a to g which can be used to display a character.
           an : out STD_LOGIC_VECTOR (3 downto 0)); -- common anode signals -> available as four “digit enable” input signals to the 4-digit display.
end one_digit; --ending the entity

architecture Behavioral of one_digit is -- " Behavioral architecture" defines the behavior of the one_digit entity.

--------------------------------------------------------------------------------------------------------------------------------------------------------
begin -- beginning of the executable part where I write VHDL code. It follows the port declarations and any other declarations necessary for my design.

    an <= "0000"; -- The "an" signal is assigned the value "0000", which means all anodes are turned ON. 
    with digit select -- output "seg" is described with "digit" as input
    
    ------------------------ I used decoder method of programming 4:16 decoder ------------------------
    --values assigned to seg correspond to the seven segments of a common anode seven-segment display. 
    --Each bit in the seg vector represents a segment (g-a), with '0' indicating the segment is illuminated and '1' indicating it is not.
           seg <=  "1000000" when "0000", --0 
                   "1111001" when "0001", --1
                   "0100100" when "0010", --2
                   "0110000" when "0011", --3
                   "0011001" when "0100", --4
                   "0010010" when "0101", --5 
                   "0000010" when "0110", --6
                   "1111000" when "0111", --7
                   "0000000" when "1000", --8 
                   "0010000" when "1001", --9
                   "1000000" when others; --0 when other buttons are pressed                                   
end Behavioral; --termination of the architecture
