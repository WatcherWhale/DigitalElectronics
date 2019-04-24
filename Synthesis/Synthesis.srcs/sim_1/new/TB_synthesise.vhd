library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TB_synthesise is
end TB_synthesise;

architecture Behavioral of TB_synthesise is

    component synthesise
    Port (A : in integer ;
    B: in integer;
    Z: out integer);
    end component;
    
    signal A : integer;
    signal B : integer;
    signal Z : integer;
    
begin
    
    syn : synthesise port map
    (
        A => A,
        B => B,
        Z => Z
    );
    
    pSimuli : process
    begin
        A <= 1;
        B <= 2;
        wait for 100ns;
    end process;

end Behavioral;
