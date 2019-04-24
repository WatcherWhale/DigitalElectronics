library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Tick is
    Generic ( g_Freq : integer := 100);
    Port ( CLK_in : in STD_LOGIC;
           CLK_out : out STD_LOGIC);
end Tick;

architecture Behavioral of Tick is
    
    signal counter : integer range 0 to 10000000/(2 * g_Freq);
    signal CLK : std_logic := '0';    
    
begin
    
    baseClockTick : process(CLK_in)
    begin
    
        if rising_edge(CLK_in)
        then
            if counter = 10000000/(2 * g_Freq)
            then
                counter <= 0;
                CLK <= not CLK;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
    tick : process(CLK)
    begin
        CLK_out <= CLK;
    end process;

end Behavioral;
