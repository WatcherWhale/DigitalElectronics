-- Mathias Maes
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LSFR is
    Generic(
        seed : std_logic_vector(15 downto 0) := "1000000000000000");
    Port (
        clk : in std_logic;
        sequence: out std_logic_vector(15 downto 0));
end LSFR;

architecture Behavioral of LSFR is
    
    signal lsfr : std_logic_vector(0 to 15) := seed;
    
begin
 
    pNextNumber : process(clk)
    begin
        if (rising_edge(clk))
        then
            for I in 1 to 15
            loop
                lsfr(I) <= lsfr(I-1);
            end loop;
            
            lsfr(0) <= ((lsfr(15) xor lsfr(14)) xor lsfr(13)) xor lsfr(11);
            
            report std_logic'image(lsfr(0));
        end if;
    end process;
    
    sequence <= lsfr;
    
end Behavioral;
