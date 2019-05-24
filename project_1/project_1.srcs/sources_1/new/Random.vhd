-- Sources: http://inst.eecs.berkeley.edu/~cs150/sp03/handouts/15/LectureA/lec27-6up
--          https://en.wikipedia.org/wiki/Linear-feedback_shift_register

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Random is
    Port(
        CLK  : in std_logic;
        seed : in std_logic_vector(30 downto 0);
        RES  : in std_logic;
        
        Number : out integer
    );
end Random;

architecture Behavioral of Random is

    signal lsfr : std_logic_vector(30 downto 0);

begin
    pClock : process(CLK)
    begin
        if rising_edge(CLK)
        then
            if RES = '1'
            then
                lsfr <= seed;
            else
                for I in 1 to 30
                loop
                    lsfr(I) <= lsfr(I - 1);
                end loop;
                
                lsfr(0) <= lsfr(30);
                lsfr(7) <= lsfr(6) XOR lsfr(30);
                lsfr(5) <= lsfr(4) XOR lsfr(30);
                lsfr(2) <= lsfr(1) XOR lsfr(30);
            end if;
        end if;
    end process;
    
    pToInteger : process(lsfr)
    begin
        Number <= to_integer(unsigned(lsfr));
    end process;

end Behavioral;
