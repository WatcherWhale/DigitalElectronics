library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FPAdder is
    Port ( Clk : in STD_LOGIC;
           A : in STD_LOGIC_VECTOR (31 downto 0);
           B : in STD_LOGIC_VECTOR (31 downto 0);
           
           C : out STD_LOGIC_VECTOR (31 downto 0));
end FPAdder;

architecture Behavioral of FPAdder is
    
    signal M : std_logic_vector(46 downto 0);
    signal sM : std_logic_vector(46 downto 0);
    signal shift : integer range -128 to 127;
    signal add : std_logic;
    signal sign : std_logic;
    signal exponent : std_logic_vector(7 downto 0);
begin
    
    pClkAdder : process(Clk)
    begin
        
        if rising_edge(Clk)
        then
            shift <= to_integer(signed(A(30 downto 23))) - to_integer(signed(A(30 downto 23)));
             
            if (A(31) = '0' AND B(31) = '0') OR (A(31) = '1' AND B(31) = '1')
            then
                M(22 downto 0)  <= A(22 downto 0);
                M(45 downto 23) <= B(22 downto 0);
                add <= '1';
            end if;
            
        
        end if;
        
    end process;
    
    pShift : process(M, shift)
    begin
        sM <= M;
        if shift /= 0
        then
            if shift > 0
            then                
                for i in 0 to 22 - shift
                loop
                    sM(i + 23) <= '0';
                    sM(i + 23 + shift) <= M(i + 23);    
                end loop;
                
                sM(22 + shift) <= '1';
            else
                for i in 0 to 22 + shift
                loop
                    sM(i) <= '0';
                    sM(i - shift) <= M(i);    
                end loop;
                
                sM(22 - shift) <= '1';
            end if;
        end if;
    end process;
    
    pAdd : process(sM, add)
    begin
        if add = '1'
        then
            C(22 downto 0) <= std_logic_vector(unsigned(sM(22 downto 0)) + unsigned(sM(45 downto 23)));
            C(30 downto 23) <= exponent;
            C(31) <= sign;
        end if;
    end process;


end Behavioral;
