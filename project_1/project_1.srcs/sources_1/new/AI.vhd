library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AI is
    Generic(
        g_startX  : integer := 0;
        g_startY  : integer := 0;
        
        g_fieldH  : integer := 460;
        g_screenH : integer := 480;
        
        g_width   : integer := 15;
        g_height  : integer := 100;
        g_speed   : integer := 150;

        g_ballSize: integer := 10
    );
    Port(
        CLKGame : in std_logic;
        
        ballX : in integer;
        ballY : in integer;
        
        x    : out integer;
        y    : out integer;
        
        random : in integer;
        shrink : in integer
    );
end AI;

architecture Behavioral of AI is

    signal Up,Down : std_logic := '0';
    signal xPos, yPos : integer;
    
    component Player
    Generic(
        g_startX  : integer := 0;
        g_startY  : integer := 0;
        
        g_fieldH  : integer := 460;
        g_screenH : integer := 480;
        
        g_width   : integer := 15;
        g_height  : integer := 100;
        g_speed   : integer := 150
        );
    Port(
        CLKGame : in std_logic; 
        
        Up   : in std_logic;
        Down : in std_logic;
        
        x    : out integer;
        y    : out integer
    );
    end component;

begin
    
    aiPlayer : Player
        Generic map(
            g_startX => g_startX,
            g_startY => g_startY,
            g_fieldH => g_fieldH,
            g_screenH => g_screenH,
            g_width => g_width,
            g_height => g_height,
            g_speed => g_speed
        )
        Port map(
            CLKGame => CLKGame,
            x => xPos,
            y => yPos,
            Up => Up,
            Down => Down
        );

    pBallMove : process(ballY,yPos)
    begin
        Down <= '0';
        Up   <= '0';
        
        if(random rem 1000) <= 84
        then
            if(ballY + g_ballSize/2 > yPos + g_height/2)
            then
                Up <= '1';
            elsif(ballY + g_ballSize/2 < yPos + g_height/2)
            then
                Down <= '1';
            end if;
        else
            if(ballY + g_ballSize/2 > yPos + g_height/2)
            then
                Down <= '1';
            elsif(ballY + g_ballSize/2 < yPos + g_height/2)
            then
                Up <= '1';
            end if;
        end if;
    end process;

    pCoordinates : process(yPos,xPos)
    begin
        x <= xPos;
        y <= yPos;
    end process;
    

end Behavioral;
