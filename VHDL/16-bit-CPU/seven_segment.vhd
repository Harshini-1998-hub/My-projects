----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.02.2024 17:50:41
-- Design Name: 
-- Module Name: lcd_mux_manual - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: one_digit
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 

--------------------------------------------------------------------------------------------------------------------------------------------------------

--manually-multiplexed 4-digit 7-segment decoder: the user should be able to use the sixteen switches, SW15-SW0, to input four BCD (0-9) digits that are then displayed, 
--in turn, on each one of the four digits of the Basys3 display; the user manually simulates the multiplexing clock by pressing the central button;

--------------------------------------------------------------------------------------------------------------------------------------------------------

library IEEE; -- 'IEEE'for standard logic operations and UNISIM for components provided by Xilinx for simulation purposes.
use IEEE.STD_LOGIC_1164.ALL; --defines the basic data types for representing digital signals (std_logic, std_logic_vector) and provides operators for working with these types.
use IEEE.numeric_std.all;-- Makes all the elements (types, functions, procedures, etc.) defined in the IEEE numeric_std package available for use in your VHDL design.

entity seven_segment_display is --"four-digit" entity declares 8 ports -> ck,dp,an,seg,d0,d1,d2,d3
    Port ( 
           ck : in  STD_LOGIC; --represents the clock signal.
           an : out STD_LOGIC_VECTOR (3 downto 0); -- common anode signals -> available as four "digit enable" input signals to the 4-digit display.
           seg : out STD_LOGIC_VECTOR (6 downto 0); -- "seg" port is 7-segment display consists of seven segments, numbered 0 to 6 or a to g which can be used to display a character.
           d0 : in STD_LOGIC_VECTOR(3 downto 0); -- representing a four-bit binary input for each digit of the display. Here, d0 is driving display on 1st lcd display (an(0))
           d1 : in STD_LOGIC_VECTOR(7 downto 4); -- Here, d1 is driving display on 2nd lcd display (an(1))
           d2 : in STD_LOGIC_VECTOR(11 downto 8); -- Here, d2 is driving display on 3rd lcd display (an(2))
           d3 : in STD_LOGIC_VECTOR(15 downto 12) -- Here, d3 is driving display on 4th lcd display (an(3))
         );
end seven_segment_display; -- ending the entity

architecture Behavioral of seven_segment_display is -- " Behavioral architecture" defines the behavior of the four_digit entity.

    -- signal is used as the wire to define other connections
    signal count : UNSIGNED(1 downto 0) := "00"; -- count is ranging from 0-3 and initially count = 0
    signal bcd_value : STD_LOGIC_VECTOR(3 downto 0); -- used to store the binary-coded decimal (BCD) value to be displayed on the current digit.


--------------------------------------------------------------------------------------------------------------------------------------------------------

begin -- beginning of the executable part where I write VHDL code. It follows the port declarations and any other declarations necessary for my design.

    process(ck, count) -- sensitive to changes in ck and count. 
    begin
        if rising_edge (ck) then -- if the clock has rising edge
            count <= (count + 1); -- Count is incremented on the rising edge of the clock signal. Count value ranges form 0-3 i.e, 4 counts
        end if; -- end the if statement
    end process; -- terminating the process


------------------------ I used MUX method of programming 16:4 decoder ------------------------

----- Here, 0 to 3rd switch is drived on an(0) --> d0, 4 to 7th switch is drived by an(1)--> d1, 8 to 11th switch is drived by an(2)-->d2 and 12 to 15th is drived by an(3)--> d3.
----- The output of the MUX is controlled bt select line (count --> 0 to 3)
----- Output of BCD values are driven by "one-digit-unit decoder"


    process(d0,d1,d2,d3,count) -- It selects the appropriate four-bit input based on the value of count and assigns it to bcd_value. 
                               -- It also sets the appropriate value for an (anode) and dp (decimal point) based on the current count.
    begin
        case count is -- "00" "01" "10" "11" 
            when "00" => -- when count is bcd_value is updated to d0
                bcd_value <= d0(3 downto 0);
                an <= "1110"; -- 0th anode is enabled on the display. 
            when "01" => -- when count is bcd_value is updated to d1
                bcd_value <= d1(7 downto 4);
                an <= "1101"; -- 1st anode is enabled on the display. 
            when "10" => -- when count is bcd_value is updated to d2
                bcd_value <= d2(11 downto 8);
                an <= "1011";-- 2nd anode is enabled on the display. 
            when "11" => -- when count is bcd_value is updated to d3
                bcd_value <= d3(15 downto 12);
                an <= "0111"; -- 4th anode is enabled on the display. 
            when others => -- when count is bcd_value is updated to zero
                bcd_value <= (others => '0');
                an <= "1111"; -- all anodes is enabled on the display. 
        end case; -- end of case

    end process; -- end process
      
    --This instantiates another entity named one_digit, presumably representing a single digit display unit. 
    --It maps the bcd_value to the digit input of the one_digit entity and seg to its seg output.
    one_digit_unit : entity work.one_digit(Behavioral)Port map (digit => bcd_value(3 downto 0), seg => seg);
  
end Behavioral; --termination of the architecture






