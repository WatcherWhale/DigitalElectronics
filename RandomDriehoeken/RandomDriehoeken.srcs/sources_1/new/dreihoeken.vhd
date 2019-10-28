library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package dreihoeken is
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
    
    component VideoMemory
        port (
            clka    : IN  std_logic;
            wea     : IN  std_logic_vector(0 DOWNTO 0);
            addra   : IN  std_logic_vector(18 DOWNTO 0);
            dina    : IN  std_logic_vector(2 DOWNTO 0);
            clkb    : IN  std_logic;
            web     : IN  std_logic_vector(0 DOWNTO 0);
            addrb   : IN  std_logic_vector(18 DOWNTO 0);
            doutb   : OUT std_logic_vector(2 DOWNTO 0);
            dinb    : IN std_logic_vector(2 DOWNTO 0)
        );
    end component;
    
    component VPulse
        Port (
            pixelClock: in std_logic;
            
            HSync : out std_logic;
            VSync : out std_logic;
            Write : out std_logic;
            
            xPos : out integer;
            yPos : out integer
         );
    end component;
    
    component BresenhamErr
        Port (
            X0: in integer;
            Y0: in integer;
            X1: in integer;
            Y1: in integer;
            Start : in STD_LOGIC;
            Clk : in STD_LOGIC;

            xOut : out integer;
            yOut : out integer;
            Plot : out STD_LOGIC);
    end component;
    
end dreihoeken;