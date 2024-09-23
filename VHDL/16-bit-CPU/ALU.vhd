----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.02.2024 10:48:21
-- Design Name: 
-- Module Name: ALU - Behavioral
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

ENTITY ALU IS
  PORT (
         a : IN std_logic_vector (15 DOWNTO 0);
         b : IN std_logic_vector (15 DOWNTO 0);
         op : IN std_logic_vector (2 DOWNTO 0);
         f : OUT std_logic_vector (15 DOWNTO 0)  
       );
END ALU;

ARCHITECTURE BHV_ALU OF ALU IS

    signal x : std_logic_vector(15 downto 0); --LE output   
    signal y : std_logic_vector(15 downto 0); --AEoutput
    signal CE_out: std_logic;
    signal carry_wire: std_logic_vector (16 DOWNTO 0);
    signal unsigned_overflow : std_logic;
    signal signed_overflow : std_logic;
    
begin

    carry_extender : entity work.carry_extender
        Port map (cout_CE => CE_out,
                  s_CE => op
                 );
        
  g_GENERATE_FOR_LE_AE: for i in 0 to 15 generate
  
    arithematic_extender: entity work.arithematic_extender
        Port map (b_AE => b(i), 
                  y_AE => y(i), --AE output
                  s_AE => op
                 );
                  
    logic_extender: entity work.logic_extender
        Port map (a_LE => a(i), 
                  b_LE => b(i), 
                  x_LE => x(i), --LE output
                  s_LE => op 
                 );
   end generate g_GENERATE_FOR_LE_AE;
       
             
    full_adder_0: entity work.full_adder
        Port map (x_FA => x(0), --LE output
                  y_FA => y(0), --AE output
                  carry_in_FA => CE_out,
                  sum_FA => f(0),
                  carry_out_FA => carry_wire(0)
                  );
 
   g_GENERATE_FOR_full_adder_1_15: for i in 1 to 15 generate
       full_adder_0: entity work.full_adder
        Port map (x_FA => x(i), --LE output
                  y_FA => y(i), --AE output
                  carry_in_FA => carry_wire(i-1),
                  sum_FA => f(0),
                  carry_out_FA => carry_wire(0)
                  );
                  
  end generate g_GENERATE_FOR_full_adder_1_15;
      
    
END BHV_ALU;