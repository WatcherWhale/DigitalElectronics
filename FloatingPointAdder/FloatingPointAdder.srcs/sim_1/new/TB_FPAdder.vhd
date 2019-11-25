library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TB_FPAdder is
--  Port ( );
end TB_FPAdder;

architecture Behavioral of TB_FPAdder is

    signal clk : std_logic := '0';
    
    component FPAdder
    Port ( Clk : in STD_LOGIC;
           A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           
           C : out STD_LOGIC_VECTOR (31 downto 0));
   end component;
   
   signal A,B,C : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
    
begin
    
    cFPAdder : FPAdder
    Port map(
        Clk => clk,
        A => A,
        B => B,
        C => C);
    
    pClk : process
    begin
        clk <= not clk;
        wait for 10ns;
    end process;
    
    pTest : process
    begin
        --wait for 10ns;
        A <= "10111101000000001100011010000100";
        B <= "10100010011110000010011111110010";
        wait for 10ns;
        
    end process;
    

end Behavioral;
