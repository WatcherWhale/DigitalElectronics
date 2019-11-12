library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VPulse is
    Generic (
        g_visible : integer := 480;
        g_front   : integer := 10;
        g_back    : integer := 33;
        g_sync    : integer := 2;
        
        g_visible_H : integer := 640;
        g_front_H   : integer := 16;
        g_sync_H    : integer := 96;
        g_back_H    : integer := 48
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
    signal can_writeH : std_logic := '0';
    signal can_writeV : std_logic := '0';
    
    signal VCounter : integer range 0 to (g_visible + g_front + g_sync + g_back) := 0;
    signal HCounter : integer;

    -- Components
    component HPulse
        Generic(
        g_visible : integer;
        g_front   : integer;
        g_sync    : integer;
        g_back    : integer);
        Port(
        Clock_in  : in  std_logic;
        Can_write : out std_logic;
        Xpos      : out integer; --range 0 to g_visible - 1; Kijk of dit niet de reden was
        Sync      : out std_logic;
        HCounter_out  : out integer);
    end component;

begin
    
    HS : HPulse
    Generic map(
        g_visible => g_visible_H,
        g_front => g_front_H,
        g_sync => g_sync_H,
        g_back => g_back
    )
    Port map(Clock_in => pixelClock,
             Sync => HSync,
             xPos => xPos,
             Can_write => can_writeH,
             HCounter_out => HCounter);
     
    onHPulse : process(pixelClock)
    begin        
        if(rising_edge(pixelClock))
        then
            --Check if we can count
            if can_writeH = '1' AND HCounter = 0
            then
                -- Count
                if VCounter >= g_visible + g_front + g_sync + g_back
                then
                    VCounter <= 0;
                else
                    VCounter <= VCounter + 1;
                end if;
            end if;
        end if;
    end process;
    
    pCounted : process(VCounter)
    begin
        can_writeV <= '0'; 
        VSync <= '0';
        yPos <= 0;
        
        -- Send pulses
        if VCounter <= g_visible
        then
            can_writeV <= '1';
            VSync <= '1';
            yPos <= VCounter;
        elsif VCounter <= g_visible + g_front
        then
            can_writeV <= '0';
            VSync <= '1';
        elsif VCounter <= g_visible + g_front + g_sync
        then
            can_writeV <= '0';
            VSync <= '0';
        elsif VCounter <= g_visible + g_front + g_sync + g_back
        then
            can_writeV <= '0';
            VSync <= '1';
        end if;
    end process;
    
    pCanWrite : process(can_writeH,can_writeV)
    begin
        Write <= can_writeH AND can_writeV;
    end process;
    
end Behavioral;
