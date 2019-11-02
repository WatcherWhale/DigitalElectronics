library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package Generators is
    
    component LFSR
        Port (
            clk : in std_logic;
            sequence: out std_logic_vector(15 downto 0));
    end component;
    
    component ClockingWizard
        port (
            PixelClk  : out std_logic;
            Clk100MHz : in  std_logic
        );
    end component;
    
    
end Generators;