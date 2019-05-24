-- AI(cpu) toegevoegd
-- Bots geluidjes
-- Een easter egg (score 6-9)
-- Random Generator met LSFR
-- * Regenboog kleuren van het balletje
-- * AI(cpu) Dommer gemaakt

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity GameController is
    Generic(
        g_playerH   : integer := 100;
        g_playerW   : integer := 15;
        
        g_ballSize  : integer := 10;
        g_ballSpeed : integer := 150;
        g_colorSpeed: integer := 2);
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
        BTNC : in std_logic;
        
        SW   : in std_logic_vector(15 downto 0);
        
        AUD_PWM : out std_logic;
        AUD_SD : out std_logic
    );
end GameController;

architecture Behavioral of GameController is
    -- Types
    type tIntarr is array(0 to 1) of integer;
    type tColor is array(0 to 2) of Unsigned(3 downto 0);
    type tClockArr is array(0 to 1) of std_logic;
    
    -- Signals
    -- Clocks
    signal PixelClock : std_logic;
    signal GameClock  : std_logic;
    signal specialClocks : tClockArr;
    
    -- VGA
    signal x,y : integer;
    signal Write : std_logic;
    signal Color : tColor := ("1111","1111","1111");
    
    -- Players
    signal p1Pos : tIntarr := (20,30);
    signal p2Pos : tIntarr := (620,510);

    -- Ball
    signal ballPos : tIntarr := (315,235);
    signal ballSpeed : tIntarr := (others => 0);
    signal ballFlip : std_logic_vector(1 downto 0);

    -- Scores
    signal Scores : tIntarr := (0,0);
    
    signal Playing : std_logic := '0';
    
     -- Random
     signal RES : std_logic := '1';
     signal randNumber : integer;
     signal randSeed : std_logic_vector(30 downto 0);

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

    component AI
        Generic(
        g_startX  : integer;
        g_startY  : integer;
        g_ballSize: integer;
        g_height  : integer;
        g_width   : integer);
    Port(
        CLKGame : in std_logic; 

        ballX : in integer;
        ballY : in integer;
        
        X     : out integer;
        Y     : out integer;
        
        random : in integer
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
    
    component AudioDriver
    Port (
        CLK_in : in std_logic;
        AUD_PWM : out std_logic
    );
    end component;
    
    component Tick
        Generic ( g_Freq : integer);
        Port ( CLK_in : in STD_LOGIC;
               CLK_out : out STD_LOGIC);
   end component;
   
   component Random
        Port(
        CLK  : in std_logic;
        seed : in std_logic_vector(30 downto 0);
        RES  : in std_logic;
        Number : out integer
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
    
    randGen : Random
        Port map(
            CLK => CLK100MHZ,
            seed => randSeed,
            RES => RES,
            Number => randNumber
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
    Generic map(g_startX => 20, g_startY => 190,g_height => g_playerH, g_width => g_playerW)
    Port map(CLKGame => GameClock,
             Up => BTNU,
             Down => BTNL,
             X => p1Pos(0),
             Y => p1Pos(1)
             );
    
    Player2 : AI
    Generic map(g_startX => 605, g_startY => 190,g_height => g_playerH, g_width => g_playerW, g_ballSize => g_ballSize)
    Port map(CLKGame => GameClock,
             --Up => BTNR,
             --Down => BTND,
             X => p2Pos(0),
             Y => p2Pos(1),
             ballX => ballPos(0),
             ballY => ballPos(1),
             random => randNumber);

    ScoreBoard : ScoreDisplay
    Port map (gameClock => GameClock, 
              Score1 => Scores(0),
              Score2 => Scores(1),
              AN => AN,
              C  => C);
              
    au : AudioDriver
        Port map(
            CLK_in => GameClock,
            AUD_PWM => AUD_PWM
        );
    
    genClocks : for I in 0 to 1 generate
        genClock : Tick
        Generic map(g_Freq => (g_ballSpeed * (1-I) + g_colorSpeed * (I))*2)
        Port map(CLK_in => GameClock,
                 CLK_out => specialClocks(I));
    end generate;
              
    pBallTick : process(specialClocks(0))
    begin
        if rising_edge(specialClocks(0))
        then
            AUD_SD <= '0';
            
            if(ballSpeed(0) = 0) AND Playing = '1'
            then
                ballSpeed(0) <= 1;
            elsif ballSpeed(1) = 0 AND Playing = '1'
            then
                ballSpeed(1) <= 1;
            end if;

            ballPos(0) <= ballPos(0) + ballSpeed(0);
            ballPos(1) <= ballPos(1) + ballSpeed(1);
            
            if BTNC = '1'
            then
                if Playing = '0'
                then
                    RES <= '0';
                    Playing <= '1';
                    
                    ballSpeed(0) <= (randNumber rem 3) - 1;
                    ballSpeed(1) <= (randNumber rem 3) - 1;
                else
                    RES <= '1';   
                    Playing <= '0';
                                 
                    ballSpeed(0) <= 0;
                    ballSpeed(1) <= 0;
    
                    ballPos(0) <= 315;
                    ballPos(1) <= 235;
    
                    Scores(0) <= 0;
                    Scores(1) <= 0;
                end if;
            end if;
            
            if  ballPos(1) <= 11
            then
                ballSpeed(1) <= 1;
                AUD_SD <= '1';
            elsif ballPos(1) + g_ballSize >= 480 - 11
            then
                ballSpeed(1) <= -1;
                AUD_SD <= '1';
            end if;
            
            if ballPos(0) + g_ballSize >= 640 - 11
            then
                Scores(0) <= Scores(0) + 1;
                
                ballPos(0) <= 315;
                ballPos(1) <= 235;
                ballSpeed(0) <= -1;
                ballSpeed(1) <= randNumber rem 3 - 1;
                
            elsif ballPos(0) <= 11
            then
                Scores(1) <= Scores(1) + 1;
                
                ballPos(0) <= 315;
                ballPos(1) <= 235;
                ballSpeed(0) <= 1;
                ballSpeed(1) <= randNumber rem 3 - 1;
                
            end if;
            
            if ballPos(0) <= p1Pos(0) + g_playerW AND ballpos(1) >= p1Pos(1) AND ballPos(1) + g_ballSize <= p1Pos(1) + g_playerH
            then
                ballSpeed(0) <= 1;
                AUD_SD <= '1';
            elsif ballPos(0) + g_ballSize >= p2Pos(0) AND ballpos(1) >= p2Pos(1) AND ballPos(1) + g_ballSize <= p2Pos(1) + g_playerH
            then
                ballSpeed(0) <= -1;
                AUD_SD <= '1';
            end if;
        end if;
    end process;
    
    pColorTick : process(specialClocks(1))
    begin
        if rising_edge(specialClocks(1))
        then
            Color(0) <= to_unsigned((randNumber) ** 2 rem 10,4) + 6;
            Color(1) <= to_unsigned((randNumber + 1) ** 2 rem 10,4) + 6;
            Color(2) <= to_unsigned((randNumber + 2) ** 2 rem 10,4) + 6;
        end if;
    end process;
        
    pUpdateDisplay : process(x,y,Write,p1Pos,p2Pos,ballPos)
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
            
            if ((9 <= x AND x <= 11) OR (640-11 <= x AND x <= 640 - 9) OR (319 <= x AND x <= 321) ) AND (9 <= y AND y <= 480-9)
            then
                VGA_R <= "1111";
                VGA_G <= "1111";
                VGA_B <= "1111";
            end if;
            
            if x >= ballPos(0) AND x <= ballPos(0) + g_ballSize AND y >= ballPos(1) AND y <= ballPos(1) + g_ballSize
            then
                VGA_R <= std_logic_vector(Color(0));  
                VGA_G <= std_logic_vector(Color(1));
                VGA_B <= std_logic_vector(Color(2));
            end if;
            
        end if;
                
    end process;
    
    pUpdateSeed : process(SW)
    begin
        randSeed(15 downto 0) <= SW;
    end process;

end Behavioral;
