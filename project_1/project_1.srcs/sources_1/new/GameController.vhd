library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity GameController is
    Generic(
        g_playerH : integer := 100;
        g_playerW : integer := 15);
    Port (
        -- Clock
        CLK100MHZ : in std_logic;
        
        -- 7 Segment Displays
        C   : out std_logic_vector(0 to 6);
        AN  : out std_logic_vector(7 downto 0);
        
        -- VGA
        VGA_R  : out std_logic_vector(3 downto 0);
        VGA_G  : out std_logic_vector(3 downto 0);
        VGA_B  : out std_logic_vector(3 downto 0);
        VGA_HS : out std_logic;
        VGA_VS : out std_logic;
        
        -- Buttons
        BTNU : in std_logic;
        BTND : in std_logic;
        BTNL : in std_logic;
        BTNR : in std_logic;
        BTNC : in std_logic
    );
end GameController;

architecture Behavioral of GameController is
    -- Types
    type tIntarr is array(0 to 1) of integer;
    
    -- Signals
    -- Clocks
    signal PixelClock : std_logic;
    signal GameClock  : std_logic;
    
    -- VGA
    signal x,y : integer;
    signal Write : std_logic;
    
    -- Players
    signal p1Pos : tIntarr := (20,30);
    signal p2Pos : tIntarr := (620,30);

    -- Scores
    signal Scores : tIntarr := (0,0);

    -- Components
    component clockGenerator
    Port(
      CLKPixel  : out std_logic;
      CLKGame   : out std_logic;
      CLK100MHZ : in std_logic
     );
    end component;
    
    component VPulse
    Port (
        pixelClock: in std_logic;
        
        HSync : out std_logic;
        VSync : out std_logic;
        Write : out std_logic;
        
        xPos : out integer;
        yPos : out integer
     );
     end component;
    
    component Player
        Generic(
        g_startX  : integer;
        g_startY  : integer;
        g_height  : integer;
        g_width   : integer);
    Port(
        CLKGame : in std_logic; 
        
        Up   : in std_logic;
        Down : in std_logic;
        
        X     : out integer;
        Y     : out integer
    );
    end component;

    component ScoreDisplay
    Port (
        gameClock : in std_logic;
        Score1    : in integer range 0 to 9999;
        Score2    : in integer range 0 to 9999;
        AN        : out std_logic_vector(7 downto 0);
        C         : out std_logic_vector(6 downto 0)
    );
    end component;

begin
    -- Map Components
    clkgen : clockGenerator
    port map (
        CLKPixel => PixelClock,
        CLKGame  => GameClock,
        CLK100MHZ => CLK100MHZ
    );
    
    VSync : VPulse
     Port map(
        pixelClock => PixelClock,
        HSync => VGA_HS,
        VSync => VGA_VS,
        xPos => x,
        yPos => y,
        Write => Write);
        
    Player1 : Player
    Generic map(g_startX => 20, g_startY => 30,g_height => g_playerH, g_width => g_playerW)
    Port map(CLKGame => GameClock,
             Up => BTNU,
             Down => BTNL,
             X => p1Pos(0),
             Y => p1Pos(1));
    
    Player2 : Player
    Generic map(g_startX => 605, g_startY => 30,g_height => g_playerH, g_width => g_playerW)
    Port map(CLKGame => GameClock,
             Up => BTNR,
             Down => BTND,
             X => p2Pos(0),
             Y => p2Pos(1));

    ScoreBoard : ScoreDisplay
    Port map (gameClock => GameClock, 
              Score1 => Scores(0),
              Score2 => Scores(1),
              AN => AN,
              C  => C);

    -- Processes
    pBallMove : process(x,y) -- Change sensitivity list
    begin
        -- Check if there is a collision
        -- Then set Collide std_logic to '1' and detect rising edge in Ball Component
        -- Have to do here because here is all the player/ball/wall info
        
        -- Collision with wall = ball reset & score upkeep
    end process;
    
    pUpdateDisplay : process(x,y,Write,p1Pos,p2Pos)
    begin
        VGA_R <= "0000";
        VGA_G <= "0000";
        VGA_B <= "0000";
        
        -- Write all pixels
        if(Write = '1')
        then        
            -- Player
            if x >= p1Pos(0) AND x <= p1Pos(0) + g_playerW AND y >= p1Pos(1) AND y <= p1Pos(1) + g_playerH
            then
                VGA_R <= "1111";
                VGA_G <= "0000";
                VGA_B <= "0000";
            end if;
            
            if x >= p2Pos(0) AND x <= p2Pos(0) + g_playerW AND y >= p2Pos(1) AND y <= p2Pos(1) + g_playerH
            then
                VGA_R <= "0000";
                VGA_G <= "0000";
                VGA_B <= "1111";
            end if;
                        
            if((9 <= y AND y <= 11) AND (9 <= x AND x <= 640-11)) OR ((480-11 <= y AND y <= 480 - 9) AND (9 <= x AND x <= 640-9))
            then
                VGA_R <= "1111";
                VGA_G <= "1111";
                VGA_B <= "1111";
            end if;
            
            if ((9 <= x AND x <= 11) AND (9 <= y AND y <= 480-11)) OR ((640-11 <= x AND x <= 640 - 9) AND (9 <= y AND y <= 480-9)) 
            then
                VGA_R <= "1111";
                VGA_G <= "1111";
                VGA_B <= "1111";
            end if;
            
            
        end if;
                
    end process;

end Behavioral;
