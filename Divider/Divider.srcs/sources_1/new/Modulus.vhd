library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Modulus is
    Generic(
        RangeStart : integer := 0;
        RangeStop  : integer := 10);
    Port (
    Input: in integer;
    Output: out integer;
    ModBase : in integer);
end Modulus;

architecture Behavioral of Modulus is
    
begin

    pCalculateMod : process(Input, ModBase)
    begin
        Output <= Input;
        for i in RangeStart to RangeStop
        loop
            if Input - i * ModBase < ModBase
            then
                Output <= Input - i * ModBase;
            end if;    
        end loop;
    end process;

end Behavioral;
