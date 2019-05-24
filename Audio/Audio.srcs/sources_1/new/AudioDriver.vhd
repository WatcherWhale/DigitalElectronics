library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AudioDriver is
    Generic(
        g_outFreq : integer := 500
    );
    Port (
        CLK_in : in std_logic;
        AUD_PWM : out std_logic
    );
end AudioDriver;

architecture Behavioral of AudioDriver is
    
    constant DataFreq : integer := 44100;
    
    signal counter : integer range 0 to DataFreq/(2*g_outFreq) - 1;
    signal pwmOut : std_logic;
    signal dataClock : std_logic;
    
    component Tick
        Generic ( g_Freq : integer);
        Port ( CLK_in : in STD_LOGIC;
               CLK_out : out STD_LOGIC);
   end component;
    
begin
    
    clock : Tick
    Generic map(g_Freq => 44100)
    Port map (CLK_in => CLK_in,
              CLK_out => dataClock);
    
    
    pOnClock : process(dataClock)
    begin
        if rising_edge(dataClock)
        then
            if counter = DataFreq/(4*g_outFreq) - 1
            then
                counter <= 0;
                pwmOut <= not pwmOut;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
    AUD_PWM <= pwmOut;

end Behavioral;
