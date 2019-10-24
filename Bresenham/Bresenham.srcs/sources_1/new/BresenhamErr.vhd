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

    type tState IS (START_STATE, BUSY_STATE, INIT_STATE);
    signal State : tState := START_STATE;
    
    type tPoint is array(0 to 1) of integer;
    signal p0, p1 : tPoint;
    
    signal dx, sx, dy, sy, err : integer;
    signal currX, currY : integer;
    
begin

    pClock : process(Clk)
    begin
        if(rising_edge(Clk))
        then
            CASE State IS
                WHEN START_STATE =>
                    Plot <= '0';
                    
                    if(Start = '1')
                    then
                        State <= INIT_STATE;
                        p0 <= (X0,Y0);
                        p1 <= (X1,Y1);
                    end if;
                    
                WHEN INIT_STATE =>
                    Plot <= '0';
                    State <= BUSY_STATE;
                    
                    if(p0(0) - p1(0) >= 0)
                    then
                        dx <= (p0(0) - p1(0));
                    else
                        dx <= -1 * (p0(0) - p1(0));
                    end if;
                    
                    if(p0(1) - p1(1) >= 0)
                    then
                        dy <= -1 * (p0(1) - p1(1));
                    else
                        dy <= (p0(1) - p1(1));
                    end if;
                                     
                    
                    if p0(0) < p1(0)
                    then
                        sx <= 1;
                    else
                        sx <= -1;
                    end if;
                    
                    if p0(1) < p1(1)
                    then
                        sy <= 1;
                    else
                        sy <= -1;
                    end if;
                    
                    err <= abs(p0(0) - p1(0)) - abs(p0(1) - p1(1));
                    
                    currX <= p0(0);
                    currY <= p0(1);
                    
                WHEN BUSY_STATE =>
                    
                    if(currX /= p1(0) OR currY /= p1(1))
                    then
                        Plot <= '1';
                        xOut <= currX;
                        yOut <= currY;
                        
                        if err*2 > dy
                        then 
                            if err*2 < dx
                            then
                                err <= err + dx +dy;
                                currY <= currY + sy;
                            else
                                err <= err + dy;
                            end if;
                            
                            currX <= currX + sx;
                        else
                            if err*2 < dx
                            then
                                err <= err + dx;
                                currY <= currY + sy;
                            end if;
                        end if; 
                    else
                        Plot <= '1';
                        xOut <= p1(0);
                        yOut <= p1(1);
                        State <= START_STATE;
                    end if;
            end CASE;
        end if;
    end process;
    
end Behavioral;
