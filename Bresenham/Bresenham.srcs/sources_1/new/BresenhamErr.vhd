-- Mathias Maes

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BresenhamErr is
    Port (
        X0: in integer;
        Y0: in integer;
        X1: in integer;
        Y1: in integer;
        Start : in STD_LOGIC;
        Clk : in STD_LOGIC;
        
        xOut : out integer;
        yOut : out integer;
        Plot : out STD_LOGIC);
end BresenhamErr;

architecture Behavioral of BresenhamErr is

    type tState IS (START_STATE, BUSY_STATE);
    signal State : tState := START_STATE;
    
begin

    pClock : process(Clk)
    begin
        if(rising_edge(Clk))
        then
            CASE State IS
                WHEN START_STATE =>
                    xOut <= 1;
                    
                WHEN BUSY_STATE =>
                    
            end CASE;
        end if;
    end process;
    
end Behavioral;
