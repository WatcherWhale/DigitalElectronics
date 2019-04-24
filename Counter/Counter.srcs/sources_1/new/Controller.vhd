library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Controller is
  Generic (g_max_count : integer := 59);
  Port (CLK100MHZ : in std_logic;
        AN        : out std_logic_vector(7 downto 0);
        C         : out std_logic_vector(6 downto 0));
end Controller;

architecture Behavioral of Controller is
    
    -- Clocks
    type tClkArray is array (1 downto 0) of std_logic;
    signal clocks : tClkArray := (others => '0');
    signal CLK10MHZ : std_logic := '0';
    
    -- Counters
    type tCntrArray is array (1 downto 0) of integer;
    signal counters : tCntrArray;
    signal currentDisplay : integer range 0 to 7;
    
    -- Powertables
    type tIntegerArray is array(7 downto 0) of integer;
    constant powerTable : tIntegerArray := (1,10,100,1000,10000,100000,1000000,10000000);
    
    -- Converter Signals
    signal BCD : UNSIGNED(3 downto 0);
    signal SEG : std_logic_vector(6 downto 0);
    
    -- Components
    component Counter
        Generic ( g_count_to : integer := 9);
        Port ( CLK : in STD_LOGIC;
               Tick : out integer range 0 to g_count_to);
    end component;
    
    component BCDTo7SegmentConverter
        Port ( BCD : in UNSIGNED(3 downto 0);
           SEG : out std_logic_vector(6 downto 0));
    end component;
    
    component Tick 
        Generic ( g_Freq : integer := 100);
        Port ( CLK_in : in STD_LOGIC;
           CLK_out : out STD_LOGIC);
   end component;
   
   component clk_wiz_0 port(
        CLK100MHZ : in std_logic;
        CLK10MHZ  : out std_logic);
    end component;
    
begin    
    -- Generates
    generateClocks : for I in 1 downto 0 generate
        clk : Tick
            Generic map (g_Freq => 1 + I*99)
            Port map (CLK_in => CLK10MHZ, CLK_out => clocks(I));
    end generate;
    
    generateCounters : for I in 1 downto 0 generate
        cntr : Counter
            -- I = 0: g_count_to = g_max_count
            -- I = 1: g_count_to = 7
            generic map(g_count_to => g_max_count * (1-I) + I * 7)
            port map (CLK => clocks( (I) ),
                      Tick => counters(I));
    end generate;
    
    -- Define Components
    
    wiz : clk_wiz_0 port map (
        CLK100MHZ => CLK100MHZ,
        CLK10MHZ => CLK10MHZ);
    
    converter : BCDTo7SegmentConverter port map(
        BCD => BCD,
        SEG => SEG);
        
    changeDisplay : process(counters)
    begin
        AN <= "11111111"; -- By default turn all displays off
        BCD <= "1010"; -- Error State
                
        -- Check if we need to enable a display
        if powerTable(7 - counters(1)) <= g_max_count
        then
            -- Use the right display
            AN(counters(1)) <= '0';
            
            --Fill in the BCD    
            BCD <= to_unsigned(counters(0) 
                    - (counters(0)/powerTable(counters(1))) * powerTable(counters(1)),4);
        end if;
    end process;
    
    segmentUpdate: process(SEG)
    begin
        C <= not SEG;    
    end process;
end Behavioral;
