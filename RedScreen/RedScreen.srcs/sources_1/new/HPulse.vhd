library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity HPulse is
    Generic(
    g_visible : integer := 640;
    g_front   : integer := 16;
    g_sync    : integer := 96;
    g_back    : integer := 48);
    Port(
    Clock_in  : in  std_logic;
    Can_write : out std_logic;
    Sync      : out std_logic;
    Xpos      : out integer range 0 to g_visible - 1);
end HPulse;

architecture Behavioral of HPulse is
    
    signal HCounter : integer range 0 to g_visible + g_front + g_sync + g_back - 1;
    
begin

    tick : process(Clock_in,HCounter)
    begin
        if(rising_edge(Clock_in))
        then
            -- Default Values
            Can_write <= '0';
            Sync <= '0';
            Xpos <= 0;
            
            -- Create the signal
            if (HCounter < g_visible)
            then
                Can_write <= '1';
                Sync <= '1';
                xPos <= HCounter;
            elsif (HCounter < g_visible + g_front)
            then
                Can_write <= '0';
                Sync <= '1';
            elsif (HCounter < g_visible + g_front + g_sync)
            then
                Can_write <= '0';
                Sync <= '0';
            elsif HCounter < g_visible + g_front + g_sync + g_back
            then
                Can_write <= '0';
                Sync <= '1';
            end if;
            
            -- Add one to the counter
            if HCounter = g_visible + g_front + g_sync + g_back - 1
            then
                HCounter <= 0;
            else
                HCounter <= HCounter + 1;
            end if;
        end if;
    end process;

end Behavioral;
