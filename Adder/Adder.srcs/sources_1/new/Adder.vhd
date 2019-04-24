library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Adder is
    Port ( A : in integer;
           B : in integer;
           Z : out integer);
end Adder;

architecture Behavioral of Adder is

begin

    Z <= A + B;

end Behavioral;
