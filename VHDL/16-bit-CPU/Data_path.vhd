----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.03.2024 19:41:36
-- Design Name: 
-- Module Name: Data_path - Behavioral
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

entity Data_path_1 is
    Port ( IRload : in STD_LOGIC;
           PCload : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Clock : in STD_LOGIC;
           MUX_SEL: in STD_LOGIC;
           IR_OUT : out STD_LOGIC_VECTOR (9 downto 0));
end Data_path_1;

architecture Behavioral of Data_path_1 is

    signal ROM_out: std_logic_vector (9 downto 0);  -- output of ROM
    signal IR_9downto0: std_logic_vector (9 downto 0); --output of IR (last 3 bits)
    signal inc_out: std_logic_vector (3 downto 0); --output of INCREMENTER
    signal IR_mux_out: std_logic_vector (3 downto 0); --output of 2:1 MUX
    signal PC_out: std_logic_vector (3 downto 0); --output of PC

begin

    IR:  entity work.IR port map (
        D => ROM_out,
        IR_load => IRload,
        clk => Clock,
        IR => IR_9downto0
    );
    
    MUX_IR: entity work.mux_2_1 port map (
        IR => IR_9downto0(3 DOWNTO 0),
        inc => inc_out,
        sel => MUX_SEL,
        mux_out => IR_mux_out
    ); 
    
    PC: entity work.PC port map (
        D => IR_mux_out,
        PC_load => PCload,
        reset => Reset,
        clk => Clock,
        PC => PC_out
    );
    
    INCREMENTER: entity work.incrementer port map (
        inc_input => PC_out,
        inc_output => inc_out
    );
    
    ROM: entity work.ROM port map (
        address => PC_out,
        data_out => ROM_out
    );
    
   IR_OUT <= IR_9downto0; 
   
 end Behavioral;
