----------------------------------------------------------------------------------
-- Company: University of Essex
-- Engineer: Luca Citi
-- 
-- Create Date:    09/01/2016
-- Design Name:    Assignment1
-- Module Name:    main3_final - Behavioral 
-- Description:    settable countdown timer with 4-digit 7-segment display
-- Dependencies:   one_digit, four_digit, clock_divider
-- Additional Comments:

------------------------------------------------------------------------------------------------------------------------------------------
-- this main_3 program The timer has two modes of operation: "SET" and "GO". The central button on the board toggles between the two. In "SET" mode, the user
-- is allowed to set the initial time in minutes (the seconds will always be 00). The up and down buttons can be used to increment or decrement the minutes in a range from 0 to 60. If the current
-- value of the seconds is different from zero, pushing the up button moves to the next integer number of minutes (rounds up) while pushing the down button moves to the previous integer number
-- of minutes (rounds down). In "GO" mode, the timer should count down from the current value towards zero at a rate of approximately 1 second
-----------------------------------------------------------------------------------------------------------------------------------------

library IEEE; -- 'IEEE'for standard logic operations and UNISIM for components provided by Xilinx for simulation purposes.
use IEEE.STD_LOGIC_1164.ALL; --defines the basic data types for representing digital signals (std_logic, std_logic_vector) and provides operators for working with these types.
library UNISIM; --allows to use simulation models during simulation. These models are essential for accurately simulating the behavior of design, especially if it includes Xilinx-specific primitives
use UNISIM.VComponents.all; --library available for use in design without needing to explicitly specify each component. This simplifies your code and makes it easier to include Xilinx-specific primitives in your design.
use IEEE.numeric_std.all; -- provides numeric types such as signed and unsigned, as well as functions and operators for arithmetic operations on these types.


entity main3_final is --" main3_final" entity declares 8 ports CLK100MHZ, dp, btnC, btnU, btnD, an, seg
    Port (
        CLK100MHZ : in STD_LOGIC; --100MHz internal clock  
        dp : out STD_LOGIC; --decimal point
        btnC : in STD_LOGIC; -- central button input
        btnU : in STD_LOGIC; -- up button input
        btnD : in STD_LOGIC; -- down button input
        an : out STD_LOGIC_VECTOR (3 downto 0); -- 4 Anode signals
        seg : out STD_LOGIC_VECTOR (6 downto 0)); --7 segment display
end main3_final; -- end of entity " main3_final" 

architecture Behavioral of main3_final is -- " Behavioral architecture" defines the behavior of the main3_final entity.

    type mode_state is (SET_MODE, GO_MODE); --enumerated type declaration known as "mode_state" which consists of two enumeration literals: SET_MODE and GO_MODE
    signal current_mode : mode_state := GO_MODE; -- signal named current_mode of type mode_state and initializes it with the value GO_MODE.

    signal an_3 : STD_LOGIC_VECTOR(3 downto 0):= "0101"; -- Initial value set to 5
    signal an_2 : STD_LOGIC_VECTOR(3 downto 0):= "0101"; -- Initial value set to 5
    signal an_1 : STD_LOGIC_VECTOR(3 downto 0):= "0000"; -- Initial value set to 5
    signal an_0 : STD_LOGIC_VECTOR(3 downto 0):= "0000"; -- Initial value set to 3

    signal clk_out_count : STD_LOGIC; --clock used to count every 1s (1Hz)
    signal clk_out_display : STD_LOGIC; --clock used in displaying on 4 anodes --> 200Hz
    signal clk_up_down : STD_LOGIC; --clock used in displaying on 4 anodes --> 4Hz

    signal btnU_previous_state : std_logic := '0'; --signal to store the previous state of btnC (this is because, btnC is pressed twice)
    signal flag: std_logic := '0';
    ----------------------------------------------------------------------------------------------------------------------------------------------------

begin
    -------------------------------------- Port mapping --------------------------------------
    display : entity work.Clock_Divider generic map ( --This line instantiates an entity named "Clock_Divider" from the library work 
            THRESHOLD => 500000 -- THRESHOLD generic parameter of the Clock_Divider entity will take the value 500000
        )
        port map ( --This part maps the ports of the instantiated entity Clock_Divider to other signals or ports in my design.
            clk => CLK100MHZ, -- clk is mapped to a signal named CLK100MHZ
            reset => '0', --reset is mapped to a constant value '0'
            clock_out => clk_out_display --clock_out is mapped to signal clk_out_display
        );

    one_sec : entity work.Clock_Divider generic map ( --This line instantiates an entity named "Clock_Divider" from the library work. 
            THRESHOLD => 100000000 -- THRESHOLD generic parameter of the Clock_Divider entity will take the value 100000000.
        )
        port map ( --This part maps the ports of the instantiated entity Clock_Divider to other signals or ports in my design.
            clk => CLK100MHZ, -- clk is mapped to a signal named CLK100MHZ
            reset => '0', --reset is mapped to a constant value '0'
            clock_out => clk_out_count --clock_out is mapped to signal clk_out_down
        );

    btnU_btnD : entity work.Clock_Divider generic map ( --This line instantiates an entity named "Clock_Divider" from the library work. 
            THRESHOLD => 25000000 -- THRESHOLD generic parameter of the Clock_Divider entity will take the value 25000000.
        )
        port map ( --This part maps the ports of the instantiated entity Clock_Divider to other signals or ports in my design.
            clk => CLK100MHZ, -- clk is mapped to a signal named CLK100MHZ
            reset => '0', --reset is mapped to a constant value '0'
            clock_out => clk_up_down --clock_out is mapped to signal clk_up_down
        );

    four_digits_unit : entity work.four_digits(Behavioral) --This line instantiates an entity named "four_digits" from the library work. 
        Port map ( --This part maps the ports of the instantiated entity Clock_Divider to other signals or ports in my design.
            d3 => an_3(3 downto 0), --seg_3_3 is driving 3rd display (an(3))  
            d2 => an_2(3 downto 0), -- seg_2 is driving 2nd display (an(2))
            d1 => an_1(3 downto 0), --seg_1_1 is driving 1st display (an(1))
            d0 => an_0(3 downto 0), --seg_0_0 is driving 0th display (an(0))
            ck => clk_out_display, -- clock used in displaying on 4 anodes --> 200Hz
            seg => seg, --7 segment display
            dp => dp, -- decimal point
            an => an -- anode 
        );

    ------------------------------ Botton-C program ------------------------------

    process (btnC, current_mode) -- sensitive to changes in btnC and current_mode. 
    begin -- begin program
        if rising_edge (btnC) then -- when buttonC is pressed
            btnU_previous_state <= not btnU_previous_state; -- represents the previous state of another button or input (btnU). It's being toggled each time btnC rises.
        end if;

        if btnU_previous_state = '0' then  -- If btnU_previous_state is low ('0'), it sets current_mode to GO_MODE, otherwise, it sets it to SET_MODE.
            current_mode <= GO_MODE; -- sets current_mode to GO_MODE
        else
            current_mode<= SET_MODE; -- sets it to SET_MODE.
        end if;
    end process; -- end process

    --------------------------------------------------------------------------------
    process
    begin

        ------------------------------ FSM program ------------------------------
        if rising_edge(CLK100MHZ) then -- meaning program will execute on every rising edge of 100Mhz clock signal.

            case current_mode is -- determine the behavior based on the current_mode

                -------------------- SET MODE --------------------  

                when SET_MODE => -- when SET MODE

                    if (clk_up_down = '1') then -- means THRESHOLD value is reached to 25000000 which is set for using button 

                        ------- Upward incrementing -------

                        if btnU = '1' then -- if btnU is pressed
                            an_0 <= "0000"; -- seconds is erased 00
                            an_1 <= "0000";
                            if (an_3 /= "0110") then --if an_3 not equal to 6 then perfo the below operation
                                if an_2 < "1001"  then -- if ones value of minutes is less than 9...
                                    an_2 <= STD_LOGIC_VECTOR(UNSIGNED(an_2) + 1); -- This converts the seg_2 signal, which is likely of type std_logic_vector, into an unsigned integer representation. 
                                    -- This allows for arithmetic operations to be performed on an_2. 
                                    -- Then result is conveted back into a std_logic_vector, as an_2 is likely a std_logic_vector type.
                                elsif an_2 >= "1001" then -- otherwise, if ones value of minute is greater than or equal to 9...
                                    an_2 <= "0000"; -- ones value of minute becomes 0
                                    if an_3 < "0110" then -- if the tens value is less than 6 ,,
                                        an_3 <= STD_LOGIC_VECTOR(UNSIGNED(an_3) + 1); -- tens value + 1
                                    elsif an_3 = "0110" then -- else tens value of minute is equal to 6
                                   an_3 <= "0000"; -- tens value of minute is updated to 0
                                    end if; --
                                end if; --
                            end if; --

                        ------- Downward decrementing -------     

                        elsif btnD = '1' then -- if btnD is pressed
                        an_0 <= "0000"; -- ones value of seconds is updated to 0
                        an_1 <= "0000"; -- tens value of seconds is updated to 00
                        if an_2 > "0000" then -- if ones value of minutes is greater than 0 ....
                            if an_2 < "1010" then -- if ones value of miutes is also less than 10...
                                an_2 <= STD_LOGIC_VECTOR(UNSIGNED(an_2) - 1); -- ones value of minute is value - 1
                            end if; --
                        elsif an_2 = "0000" then -- else if ones value of minute is 0...
							if an_3 > "0000" then -- if tens value of minutes is greater than 0..
                                if an_3 <= "0110" then -- if tens value is less than or equal to 6..
                                    an_3 <= STD_LOGIC_VECTOR(UNSIGNED(an_3) - 1); -- tens value of minute is value - 1
                                    an_2 <= "1001"; -- ones value of minute is 9
                                end if;--
                            end if; --
                        end if ;--
                        end if; --btn ends
                    end if; --clock ends

                -------------------- SET MODE --------------------
                when GO_MODE =>
				
                    if (clk_out_count = '1') then -- means THRESHOLD value is reached to 100000000 which is set for using button 
					
                        if (an_2 = "0000")and (an_3 = "0000")and (an_1 = "0000") and (an_0 = "0000")  then -- if 00:00 then stop
                            an_0 <= "0000";
                            an_1 <= "0000";
                            an_2 <= "0000";
                            an_3 <= "0000";
                        else
                            if an_0 <= "1001" then -- if ones of seconds is less or equal to 9 ..
                               an_0 <= STD_LOGIC_VECTOR(UNSIGNED(an_0) - 1); -- subtract 1
								if an_0 = "0000" then -- once value reaches to 0 (if ones of seconds is 0)...
                                    an_0 <= "1001"; -- ones of seconds is assigned 9
                                    if an_1 = "0000" then -- if tens of seconds is 0...
                                        if an_2 <= "1001" then -- ones of minutes reaches to 9...
                                            an_0 <= "1001"; -- update ones value of seconds to 9
                                            an_1 <= "0101"; -- update tens value of second to 5
                                            an_2 <= STD_LOGIC_VECTOR(UNSIGNED(an_2) - 1); -- ones of minute is value - 1
                                            if an_2 = "0000" then -- after decrementing if ones of minutes reaches to 0..
                                                if an_3 > "0000" then -- check for tens value of minutes if it is greater than 0
                                                    if an_3 < "0110" then -- also check if it is less than 6
                                                        an_3 <= STD_LOGIC_VECTOR(UNSIGNED(an_3) - 1); -- if yes decrement by 1
                                                        an_2 <= "1001"; -- assign ones value minute to 9
                                                    end if; --
                                                end if;--
                                            end if ;--
                                        end if; --
                                    elsif (an_1 <="1001")then -- if tens value of is less than or equal to 9
                                        an_1 <= STD_LOGIC_VECTOR(UNSIGNED(an_1) - 1); -- decrement by 1
                                    end if; --
                                end if; --
                            end if; --
                        end if; --
                    end if; -- clock
            end case; -- end case
        end if; -- CLK100MHz end


    end process; -- end process

end Behavioral; -- terminate architecture


