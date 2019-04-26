library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Controller is
 Port (
    CLK100MHZ : in std_logic);
end Controller;

architecture Behavioral of Controller is
    
    -- Signals
    signal pixelClock : std_logic;
    
    -- Components
    component clk_wiz_0
    Port(
      pixelClock : out std_logic;
      CLK100MHZ  : in  std_logic);
    end component;

begin
    
    clk : clk_wiz_0
    Port map(
        pixelClock => pixelClock,
        CLK100MHZ => CLK100MHZ
        );

end Behavioral;
