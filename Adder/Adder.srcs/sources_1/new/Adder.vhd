library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Adder is
    Port ( A : in UNSIGNED(3 downto 0);
           B : in UNSIGNED(3 downto 0);
           Z : out UNSIGNED(3 downto 0));
end Adder;

architecture Behavioral of Adder is

begin

    Z <= A + B;

end Behavioral;
