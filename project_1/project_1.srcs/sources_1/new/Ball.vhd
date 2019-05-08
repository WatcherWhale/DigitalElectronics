library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Ball is
    Generic(
        g_timeStep : integer := 100
        );
    Port (
        CLKGame : in std_logic;
    
        speedY : in integer;
        speedX : in integer;
        
        x : out integer;
        y : out integer
    );
end Ball;

architecture Behavioral of Ball is
    
    signal stepClock : std_logic;
    
    signal xPos : integer := 315;
    signal yPos : integer := 235;
    
    component Tick
        Generic ( g_Freq : integer);
        Port ( CLK_in : in STD_LOGIC;
               CLK_out : out STD_LOGIC);
   end component;
        

begin
    moveClock : Tick
        Generic map(g_Freq => g_timeStep * 2)
        Port map(CLK_in => CLKGame,
                 CLK_out => stepClock);
                 
     pStep : process(stepClock)
     begin
        if rising_edge(stepClock)
        then        
            xPos <= xPos + speedX;
            yPos <= yPos + speedY;
        end if;
     end process;
     
     pStepped : process(xPos,yPos)
     begin
        x <= xPos/g_timeStep;
        y <= yPos/g_timeStep;
     end process;

end Behavioral;
