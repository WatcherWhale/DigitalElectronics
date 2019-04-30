library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity TB_Display is
end TB_Display;

architecture Behavioral of TB_Display is

    component VPulse
    Port (
        pixelClock: in std_logic;
        
        Write : out std_logic;
        
        xPos : out integer;
        yPos : out integer
     );
     end component;
     
    signal x,y : integer;
    signal pixelClock,Write : std_logic := '0';
    signal R : std_logic_vector(3 downto 0);

begin
    
    disp :VPulse
    Port map (xPos => x, yPos => y, Write => Write, pixelClock => pixelClock);
    
    pstim : process
    begin
        pixelClock <= not pixelClock;
        wait for 1ns;
    end process;

    pColor: process(Write,x,y)
    begin
        if(Write = '1')
        then
            R <= std_logic_vector(to_unsigned((16*x)/640,4));
        end if;
    end process;
    
end Behavioral;
