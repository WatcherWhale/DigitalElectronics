library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Player is
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
        
        X    : out integer;
        y    : out integer
    );
end Player;

architecture Behavioral of Player is
    
    signal stepClock   : std_logic;
    signal Move        : integer range -1 to 1;
    signal xPos        : integer := g_startX;
    signal yPos        : integer := g_startY;

    component Tick
    Generic ( g_Freq : integer);
    Port ( CLK_in : in STD_LOGIC;
           CLK_out : out STD_LOGIC);
    end component;
    
begin

    moveClock : Tick
        Generic map(g_Freq => g_speed * 2)
        Port map(CLK_in => CLKGame,
                 CLK_out => stepClock);

    pStepper : process(stepClock)
    begin
        if rising_edge(stepClock)
        then
            if (Up XOR Down) = '1'
            then
                if Up = '1'
                then
                    if(yPos - 1 >= (g_screenH - g_fieldH)/2)
                    then
                        yPos <= yPos - 1;
                    end if;
                elsif Down = '1'
                then
                    if(yPos + 1 <= g_screenH - ((g_screenH - g_fieldH)/2 + g_height))
                    then
                        yPos <= yPos + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    pUpdatePosition : process(xPos,yPos)
    begin
        X <= xPos;
        Y <= yPos;
    end process;

end Behavioral;
