library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity synthesise is
    Port (A : in integer;
    B: in integer;
    Z: out integer);
end synthesise;

architecture Behavioral of synthesise is
    attribute use_dsp : string;
    attribute use_dsp of Z : signal is "yes";
begin
    
    Z <= A / B;

end Behavioral;
