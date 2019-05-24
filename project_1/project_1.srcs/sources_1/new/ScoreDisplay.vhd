library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ScoreDisplay is
    Port (
        gameClock : in std_logic;
        Score1    : in integer range 0 to 9999;
        Score2    : in integer range 0 to 9999;
        AN        : out std_logic_vector(7 downto 0);
        C         : out std_logic_vector(6 downto 0)
    );
end ScoreDisplay;

architecture Behavioral of ScoreDisplay is

    type tIntegerArray is array(3 downto 0) of integer;
    constant powerTable : tIntegerArray := (1,10,100,1000);

    signal displayCounter : integer range 0 to 7;
    signal displayClock   : std_logic;
    signal BCD            : unsigned(3 downto 0);
    signal tempC          : std_logic_vector(6 downto 0);

    component Tick
        Generic ( g_Freq : integer);
        Port ( CLK_in : in STD_LOGIC;
               CLK_out : out STD_LOGIC);
    end component;
   
    component BCDTo7SegmentConverter is
        Port ( BCD : in UNSIGNED(3 downto 0);
               SEG : out std_logic_vector(0 to 6));
    end component;
    
begin
    
    clk : Tick
        Generic map(g_freq => 800 * 2) -- *2 because of rising edges
        Port map(CLK_in  => gameClock,
                 CLK_out => displayClock);
    converter : BCDTo7SegmentConverter
        Port map(BCD => BCD,SEG =>tempC);

    pCount : process(displayClock)
    begin
        if rising_edge(displayClock)
        then
            if displayCounter = 7
            then
                displayCounter <= 0;
            else
                displayCounter <= displayCounter + 1;
            end if;
        end if;
    end process;

    pShow : process(Score1,Score2,displayCounter)
    begin
        AN <= "11111111";
        AN(displayCounter) <= '0';
        
        if(displayCounter < 4)
        then
            if displayCounter = 0
            then
                -- Only take the first digit
                BCD <= to_unsigned(Score2 rem 10,4);
            elsif displayCounter = 3
            then
                -- Only take the last digit
                BCD <= to_unsigned(Score2 / 1000,4);
            else
                -- Take the correct digit
                BCD <= to_unsigned( (Score2/powerTable(3-displayCounter) rem 10 ) , 4);
            end if;
        else
            if displayCounter - 3 = 0
            then
                -- Only take the first digit
                BCD <= to_unsigned(Score1 rem 10,4);
            elsif displayCounter - 4 = 3
            then
                -- Only take the last digit
                BCD <= to_unsigned(Score1 / powerTable(0),4);
            else
                -- Take the correct digit
                BCD <= to_unsigned( (Score1/powerTable(3-(displayCounter-4)) rem 10 ) , 4);
            end if;
        end if;
    end process;
    
    pCathodes : process(tempC, Score1, Score2, displayCounter)
    begin
        C <= "1111111";
        if Score1 = 6 AND Score2 = 9
        then
            if displayCounter rem 4 = 0
            then
                C <= "0100000";
            elsif displayCounter rem 4 = 1 
            then
                C <= "0100100";
            elsif displayCounter rem 4 = 2 
            then
                C <= "1001111";
            elsif displayCounter rem 4 = 3 
            then
                C <= "0011000";
            end if;
        else
            C <= tempC;
        end if;
    end process;

end Behavioral;