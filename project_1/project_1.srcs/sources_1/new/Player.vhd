library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Player is
    Generic(
        g_startX  : integer := 0;
        g_startY  : integer := 0;
        
        g_fieldH  : integer := 470;
        g_screenH : integer := 480;
        
        g_width   : integer := 15;
        g_height  : integer := 50;
        g_speed   : integer := 2
    );
    Port(
        CLKGame : in std_logic; 
        
        Up   : in std_logic;
        Down : in std_logic;
        
        X1    : out integer;
        X2    : out integer;
        Y1    : out integer;
        Y2    : out integer
    );
end Player;

architecture Behavioral of Player is
    
    type tPosArr is array(0 to 3) of integer;
    
    signal StepCounter : integer range 0 to 10000000/(2*g_speed) - 1; 
    signal Move        : integer range -1 to 1;
    signal Pos         : tPosArr := (
        g_startX,
        g_startY,
        g_startX + g_width,
        g_startY + g_height
    );
    
begin

    pStepper : process(CLKGame,StepCounter)
    begin
        if rising_edge(CLKGame)
        then
            Move <= 0;
            
            if Up = '1' XOR Down = '1' -- Prevent counting when player uses up and down
            then
                if StepCounter >= 10000000/(2*g_speed) - 1
                then
                    StepCounter <= 0;
                    
                    if Up = '1'
                    then
                        Move <= 1;
                    elsif Down = '1'
                    then
                        Move <= -1;
                    end if;
                else
                    StepCounter <= StepCounter + 1;
                     Move <= 0;
                end if;
            else
                StepCounter <= 0;
            end if;
        end if;
    end process;
    
    pMove : process(Move,Pos)
    begin
        -- Move and constrain to playfield
        if(Pos(1) + Move >= (g_fieldH - g_screenH)/2) AND (Pos(3) + Move <= g_fieldH + (g_fieldH - g_screenH)/2)
        then        
            Pos(1) <= Pos(1) + Move;
            Pos(3) <= Pos(3) + Move;
        end if;
    end process;
    
    pMoved : process(Pos)
    begin
        X1 <= Pos(0);
        Y1 <= Pos(1);
        X2 <= Pos(2);
        Y2 <= Pos(3);
    end process;
    
end Behavioral;
