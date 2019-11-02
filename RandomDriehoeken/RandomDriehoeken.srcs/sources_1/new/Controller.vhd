library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.dreihoeken.ALL;

entity Controller is
    Port (
        CLK100MHZ: in std_logic
    );
end Controller;

architecture Behavioral of Controller is

    signal PixelClk : std_logic;
    signal generatedTriangle : std_logic_vector(56 downto 0);

begin
    
    cClk : ClockingWizard
    port map( 
       PixelClk => PixelClk,
       Clk100MHz => Clk100MHz);

end Behavioral;
