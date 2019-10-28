-- Mathias Maes
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LFSR is
    Generic(
        seed : std_logic_vector(15 downto 0) := "1000000000000000");
    Port (
        clk : in std_logic;
        sequence: out std_logic_vector(15 downto 0));
end LFSR;

architecture Behavioral of LFSR is
    
    signal lfsr : std_logic_vector(0 to 15) := seed;
    
begin
 
    pNextNumber : process(clk)
    begin
        if (rising_edge(clk))
        then
            for I in 1 to 15
            loop
                lfsr(I) <= lfsr(I-1);
            end loop;
            
            lfsr(0) <= ((lfsr(15) xor lfsr(13)) xor lfsr(12)) xor lfsr(10);
        end if;
    end process;
    
    sequence <= lfsr;
    
end Behavioral;
