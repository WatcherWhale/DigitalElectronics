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
    
    component TriangleGenerator
        Generic(
            g_Triangles : integer := 4);
        Port (
            clk : in std_logic;
            gen : in STD_LOGIC;
            rd_en : in std_logic;
            
            full : out std_logic;
            empty : out std_logic;
            
            triangleData : out STD_LOGIC_VECTOR(58 downto 0));
    end component;
    
    
end Generators;