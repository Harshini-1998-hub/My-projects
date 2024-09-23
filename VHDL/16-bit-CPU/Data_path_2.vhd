----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.03.2024 21:32:09
-- Design Name: 
-- Module Name: Data_path_2 - Behavioral
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

entity Data_path_2 is
    Port ( Instruction_Register : in STD_LOGIC_VECTOR (15 downto 0);
           Switch : in STD_LOGIC_VECTOR (15 downto 0);
           IE : in STD_LOGIC_VECTOR (1 downto 0);
           WE : in STD_LOGIC;
           WA : in STD_LOGIC_VECTOR (1 downto 0);
           RAE : in STD_LOGIC;
           RAA : in STD_LOGIC_VECTOR (1 downto 0);
           RBE : in STD_LOGIC;
           RBA : in STD_LOGIC_VECTOR (1 downto 0);
           Clock_1 : in STD_LOGIC;
           OP : in STD_LOGIC_VECTOR (2 downto 0);
           ZE : in STD_LOGIC;
           Z : out STD_LOGIC;
           OE : in STD_LOGIC;
           Data_Output : out STD_LOGIC_VECTOR (15 downto 0));
end Data_path_2;

architecture Behavioral of Data_path_2 is

    signal MUX_RF_OUT : std_logic_vector (15 downto 0); -- ouput of MUX_RF
    signal A_out_RF : std_logic_vector (15 downto 0); -- output of A_RF
    signal B_out_RF : std_logic_vector (15 downto 0); -- output of B_RF
    signal ALU_out : std_logic_vector (15 downto 0); -- output of ALU
    signal BUFF_OUT : std_logic_vector (15 downto 0); -- output of TRI_STATE_BUFFER_OUTPUT
    
begin

    MUX_RF : entity work.mux_3_1 port map(
        x_instruction => Instruction_Register,
        y_instruction => Switch,
        ALU_output => ALU_out ,
        select_IE => IE,
        out_mux => MUX_RF_OUT
    );
    
    RF: entity work.RF port map (
        clk => Clock_1,
        WE_RF => WE,
        WA_RF => WA,
        RAE_RF => RAE,
        RAA_RF => RAA,
        RBE_RF => RBE,
        RBA_RF => RBA,
        input_ID => MUX_RF_OUT,
        Aout => A_out_RF,
        Bout => B_out_RF
    );
    
    ALU : entity work.ALU port map(
        a => A_out_RF,
        b => B_out_RF,
        op => OP,
        f => ALU_out 
    );
    
    D_ff : entity work.d_ff port map (
        d => ALU_out,
        E => ZE,
        clk => Clock_1,
        Q => Z  
    );
    
    TRI_STATE: entity work.tristate_buffer port map (
        input => ALU_out,
        cntrl => OE,
        output => BUFF_OUT
    );
    
    Data_Output <= BUFF_OUT;
    
    
    end Behavioral;
