library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Counter is
    Generic ( g_count_to : integer := 9);
    Port ( CLK : in STD_LOGIC;
           Tick : out integer range 0 to g_count_to := 0);
end Counter;

architecture Behavioral of Counter is
    
    signal counter : integer range 0 to g_count_to := 0;
    
begin

    count : process(CLK)
    begin
        if rising_edge(CLK)
        then
            if counter = g_count_to
            then
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
    pass : process(counter)
    begin
        Tick <= counter;
    end process;
    
end Behavioral;
