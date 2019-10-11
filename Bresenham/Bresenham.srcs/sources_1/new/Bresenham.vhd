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
    signal diff, dx, dy : integer;   
    signal p1 : tPoint;
    signal y, x : integer := 0;
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
                        p1 <= (X1,Y1);
                        dx <= X0 - X1;
                        dy <= Y0 - Y1;
                        
                        if(Y0 - Y1 < 0)
                        then
                            xyi <= -1;
                        else 
                            xyi <= 1;
                        end if;
                        
                        diff <= 
                        
                    else
                        p1 <= (X0,Y0);
                        dx <= X1 - X0;
                        dy <= Y1 - Y0;

                        if(Y1- Y0 <0)
                        then
                            xyi <= -1;
                        else 
                            xyi <= 1;
                        end if;
                        
                    end if;
                else
                    low <= '0';
                    
                    if(Y0 > Y1)
                    then
                        p1 <= (X1,Y1);
                        dx <= X0- X1;
                        dy <= Y0 - Y1;
                        diff <= 
                        
                        if(X0 - X1 < 0)
                        then
                            xyi <= -1;
                        else 
                            xyi <= 1;
                        end if;
                    else
                        p1 <= (X0,Y0);
                        dx <= X1- X0;
                        dy <= Y1 - Y0;
                        
                        if(X1- X0 <0)
                        then
                            xyi <= -1;
                        else 
                            xyi <= 1;
                        end if;
                    end if;
                end if;
            elsif (started = '1' and x <= p1(0) and low = '1')
            then
                xOut <= x;
                YOut <= Y;
                Plot <= '1';

                if (diff > 0)
                then
                    y <= y + 1;
                    diff <= diff - 2 * dx;
                end if;

                diff <= diff + 2 * dy;
                x <= x + 1;
            elsif (started = '1' and y <= p1(1) and low = '0')
            then
                
            else
                started <= '0';
                Plot <= '0';
            end if;
        end if;
    end process;
    
end Behavioral;
