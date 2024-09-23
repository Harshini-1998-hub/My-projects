----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.02.2024 20:16:16
-- Design Name: 
-- Module Name: one_digit - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 
library UNISIM; 
use UNISIM.VComponents.all; 

entity one_digit is 
    Port ( digit : in STD_LOGIC_VECTOR (3 downto 0); 
           seg : out STD_LOGIC_VECTOR (6 downto 0); 
           an : out STD_LOGIC_VECTOR (3 downto 0)); 
end one_digit; 

architecture Behavioral of one_digit is 


begin 

    an <= "1110"; 
    with digit select 
   
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
                                                     
end Behavioral;
