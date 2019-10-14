-- Mathias Maes
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Bresenham is
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
end Bresenham;

architecture Behavioral of Bresenham is
    
    type tPoint is array(0 to 1) of integer;
    
    signal started : STD_LOGIC := '0';
    signal diff, dx, dy : integer := 0;   
    signal p1 : tPoint := (0,0);
    signal y, x : integer;
    signal low : STD_LOGIC := '1';
    signal xyi : integer := 0;
    
begin
    
    pClock : process(Clk)
    begin
        if(rising_edge(Clk))
        then
            if(Start = '1' and started = '0')
            then
                started <= '1';

                if(abs(Y1-Y0) < abs(X1-X0))
                then
                    low <= '1';
                    
                    if(X0 > X1)
                    then
                        p1 <= (X0,Y0);
                        dx <= X0 - X1;
                        y <= Y1;
                        x <= X1;
                        
                        if(Y0 - Y1 < 0)
                        then
                            xyi <= -1;
                            dy <= Y1 - Y0;
                            diff <= 2 * (Y1 - Y0) - (X0 - X1);
                        else 
                            xyi <= 1;
                            dy <= Y0 - Y1;
                            diff <= 2 * (Y0 - Y1) - (X0 - X1);
                        end if;
                        
                    else
                        p1 <= (X1,Y1);
                        dx <= X1 - X0;
                        
                        y <= Y0;
                        x <= X0;

                        if(Y1 - Y0 < 0)
                        then
                            xyi <= -1;
                            dy <= Y0 - Y1;
                            diff <= 2 * (Y0 - Y1) - (X1 - X0);
                        else 
                            xyi <= 1;
                            dy <= Y1 - Y0;
                            diff <= 2 * (Y1 - Y0) - (X1 - X0);
                        end if;
                    end if;
                else
                    low <= '0';
                    
                    if(Y0 > Y1)
                    then
                        p1 <= (X0,Y0);
                        dy <= Y0 - Y1;
                        y <= Y1;
                        x <= X1;
                        
                        if(X0 - X1 < 0)
                        then
                            xyi <= -1;
                            dx <= X1 - X0;
                            diff <= - 2 * (X1 - X0) + (Y0 - Y1);
                        else 
                            xyi <= 1;
                            dx <= X0- X1;
                            diff <= 2 * (X0 - X1) - (Y0 - Y1);
                        end if;
                    else
                        p1 <= (X1,Y1);
                        dy <= Y1 - Y0;
                        y <= Y0;
                        x <= X0;
                        
                        if(X1- X0 <0)
                        then
                            xyi <= -1;
                            dx <= X0 - X1;
                            diff <= 2* (X0 - X1) - (Y1 - Y0);
                        else 
                            xyi <= 1;
                            dx <= X1 - X0;
                            diff <= 2* (X1 - X0) - (Y1 - Y0);
                        end if;
                    end if;
                end if;
            elsif (started = '1' and x <= p1(0) and low = '1')
            then
                xOut <= x;
                YOut <= Y;
                started <= '1';

                if (diff > 0)
                then
                    y <= y + xyi;
                    diff <= diff - 2 * dx + 2 * dy;
                else
                    diff <= diff + 2 * dy;
                end if;

                x <= x + 1;
            elsif (started = '1' and y <= p1(1) and low = '0')
            then
                xOut <= x;
                yOut <= y;
                started <= '1';
                
                if (diff > 0)
                then
                    x <= x + xyi;
                    diff <= diff - 2 * dy + 2 * dx;
                else
                    diff <= diff + 2 * dx;
                end if;
                
                y <= y+1;
            else
                started <= '0';
            end if;
        end if;
    end process;
    
    Plot <= started;
    
end Behavioral;
