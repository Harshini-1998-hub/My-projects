----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.03.2024 01:40:14
-- Design Name: 
-- Module Name: CPU - Behavioral
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

entity CPU is
    Port ( sw : in STD_LOGIC_VECTOR (15 downto 0);
           clk : in STD_LOGIC;
           btnC : in STD_LOGIC;
           an : out STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0)
           );
end CPU;

architecture Behavioral of CPU is

    signal IRload_signal : STD_LOGIC;
    signal IE_signal : STD_LOGIC_VECTOR (1 downto 0);
    signal WE_signal : STD_LOGIC;
    signal WA_signal : STD_LOGIC_VECTOR (1 downto 0);
    signal RAE_signal : STD_LOGIC;
    signal RAA_signal : STD_LOGIC_VECTOR (1 downto 0);
    signal RBE_signal : STD_LOGIC;
    signal RBA_signal : STD_LOGIC_VECTOR (1 downto 0);
    signal OP_signal : STD_LOGIC_VECTOR (2 downto 0);
    signal ZE_signal : STD_LOGIC;
    signal Z_signal : STD_LOGIC;    
    signal OE_signal : STD_LOGIC;
    signal J_MUX_SEL_signal : STD_LOGIC;
    signal MUX_3_1_X_INSTRUCTION_signal: STD_LOGIC_VECTOR(15 downto 0);
    signal IR_signal : STD_LOGIC_VECTOR (9 downto 0);
    signal PCload_signal : STD_LOGIC;
    signal display_signal : STD_LOGIC_VECTOR(15 downto 0);
    signal clk_out_display: STD_LOGIC; 
    signal d0_signal : STD_LOGIC_VECTOR (3 downto 0);
    signal d1_signal : STD_LOGIC_VECTOR (3 downto 0);
    signal d2_signal : STD_LOGIC_VECTOR (3 downto 0);
    signal d3_signal : STD_LOGIC_VECTOR (3 downto 0);

begin

   ALU_control_block: entity work.Data_path_2 port map (
           Instruction_register => MUX_3_1_X_INSTRUCTION_signal, ---check
           Switch => sw,
           IE => IE_signal,
           WE => WE_signal,
           WA => WA_signal,
           RAE => RAE_signal,
           RAA => RAA_signal,
           RBE => RBE_signal,
           RBA => RBA_signal,
           Clock_1 => clk,
           OP => OP_signal,
           ZE => ZE_signal,
           Z => Z_signal,
           OE => OE_signal,
           Data_Output => display_signal
    );
    
    Counter_block: entity work.Data_path_1 port map (
           IRload => IRload_signal,
           PCload => PCload_signal,
           Reset => btnC,
           Clock => clk,
           MUX_SEL => J_MUX_SEL_signal,
           IR_OUT => IR_signal
    );
    
    Control_Unit: entity work.Control_Unit port map (
           PCload_CU => PCload_signal,
           IRload_CU => IRload_signal,
           IE_CU => IE_signal,
           WE_CU => WE_signal,
           WA_CU => WA_signal,
           RAE_CU => RAE_signal,
           RAA_CU => RAA_signal,
           RBE_CU => RBE_signal,
           RBA_CU => RBA_signal,
           OP_CU => OP_signal,
           ZE_CU => ZE_signal,
           Z_CU => Z_signal,
           OE_CU => OE_signal,
           J_MUX_SEL => J_MUX_SEL_signal,
           MUX_3_1_X_INSTRUCTION => MUX_3_1_X_INSTRUCTION_signal,
           IR => IR_signal,
           clk => clk,
           reset => btnC 
    );
    
        display : entity work.Clock_Divider generic map ( --This line instantiates an entity named "Clock_Divider" from the library work 
            THRESHOLD => 500000 -- THRESHOLD generic parameter of the Clock_Divider entity will take the value 500000
        )
        port map ( --This part maps the ports of the instantiated entity Clock_Divider to other signals or ports in my design.
            clk => clk, -- clk is mapped to a signal named CLK100MHZ
            reset => '0', --reset is mapped to a constant value '0'
            clock_out => clk_out_display --clock_out is mapped to signal clk_out_display
        );
    
    seven_segment: entity work.seven_segment_display port map(
           ck => clk_out_display,
           an => an,
           seg => seg,
           d0 => d0_signal,
           d1 => d1_signal,
           d2 => d2_signal,
           d3 => d3_signal
    );
    
    display_to_digits: process (display_signal)
        begin 
            d0_signal <= std_logic_vector(to_unsigned((to_integer(unsigned(display_signal)) mod 10), d0_signal'length));
            d1_signal <= std_logic_vector(to_unsigned((to_integer(unsigned(display_signal)) mod 100)/10, d1_signal'length));
            d2_signal <= std_logic_vector(to_unsigned((to_integer(unsigned(display_signal)) mod 1000)/100, d2_signal'length));
            d0_signal <= std_logic_vector(to_unsigned((to_integer(unsigned(display_signal)) mod 10000)/1000, d3_signal'length));
         end process; 
end Behavioral;
