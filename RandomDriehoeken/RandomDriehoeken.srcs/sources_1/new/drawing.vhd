library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package Drawing is
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
end Drawing;