library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Divider is
    Generic(
        RangeStart : integer := 0;
        RangeStop  : integer := 10);
    Port (
        Denominator : in integer;
        Numerator   : in integer;
        Output      : out integer);
end Divider;

architecture Behavioral of Divider is

begin
    
    pCalculateDivision : process(Numerator, Denominator)
    begin
        Output <= Numerator;
        for i in RangeStart to RangeStop
        loop
            if Numerator - i * Denominator < Denominator
            then
                Output <= i;
            end if;    
        end loop;
    end process;

end Behavioral;
