library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VPulse is
    Generic (
        g_visible : integer := 480;
        g_front   : integer := 10;
        g_back    : integer := 33;
        g_sync    : integer := 2
    );
    Port (
        pixelClock: in std_logic;
        
        HSync : out std_logic;
        VSync : out std_logic;
        Write : out std_logic;
        
        xPos : out integer;
        yPos : out integer
     );
end VPulse;

architecture Behavioral of VPulse is
    
    -- Signals
    signal can_writeH : std_logic;
    signal can_writeV : std_logic;
    
    signal VCounter : integer range 0 to g_visible + g_front + g_sync + g_back - 1;
    
    -- Components
    component HPulse
        Port(
        Clock_in  : in  std_logic;
        Can_write : out std_logic;
        Xpos      : out integer range 0 to g_visible - 1;
        Sync      : out std_logic);
    end component;

begin
    
    HS : HPulse
    Port map(Clock_in => pixelClock,
             Sync => HSync,
             xPos => xPos,
             Can_write => can_writeH);
     
    onHPulse : process(can_writeH, VCounter)
    begin
        if(rising_edge(can_writeH))
        then
            can_writeV <= '0'; 
            VSync <= '0';
            yPos <= 0;
            
            -- Send pulses
            if VCounter < g_visible
            then
                can_writeV <= '1';
                VSync <= '1';
                yPos <= VCounter;
            elsif VCounter < g_visible + g_front
            then
                can_writeV <= '0';
                VSync <= '1';
            elsif VCounter < g_visible + g_front + g_sync
            then
                can_writeV <= '0';
                VSync <= '0';
            elsif VCounter < g_visible + g_front + g_sync + g_back
            then
                can_writeV <= '0';
                VSync <= '1';
            end if;
            
            -- Count
            if VCounter = g_visible + g_front + g_sync + g_back - 1
            then
                VCounter <= 0;
            else
                VCounter <= VCounter + 1;
            end if;
        end if;
    end process;
    
    pCanWrite : process(can_writeH,can_writeV)
    begin
        Write <= can_writeH AND can_writeV;
    end process;
    
end Behavioral;
