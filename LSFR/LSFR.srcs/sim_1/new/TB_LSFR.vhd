-- Mathias Maes
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.textio.all;
use IEEE.std_logic_textio.all;

entity TB_LSFR is
end TB_LSFR;

architecture Behavioral of TB_LSFR is
    
    signal clock : std_logic := '0';
    signal sequence : std_logic_vector(15 downto 0);
    signal testSequence : std_logic_vector(15 downto 0);
    
    function to_string ( a: std_logic_vector) return string is
        variable b : string (1 to a'length) := (others => NUL);
        variable stri : integer := 1; 
    begin
        for i in a'range loop
            b(stri) := std_logic'image(a((i)))(2);
        stri := stri+1;
        end loop;
    return b;
    end function;
    
    file testFile : text;
    
    component LSFR
    Port (
        clk : in std_logic;
        sequence: out std_logic_vector(15 downto 0));
    end component;
    
begin
    
    cLsfr : LSFR
    Port map(
        clk => clock,
        sequence => sequence);
        
    pClock : process
    begin
        wait for 10ns;
        while not endfile(testFile)
        loop
            clock <= not clock;
            wait for 10ns;
        end loop;
    end process;
    
    pTest : process
        variable inLine : line;
        variable checkValue : std_logic_vector(15 downto 0);
    begin
        file_open(testFile, "testvector.txt", read_mode);
        
        wait for 10ns;
        
        while not endfile(testFile)
        loop
            readline(testFile,inLine);
            read(inLine, checkValue);
            
            testSequence <= checkValue;
            
            assert sequence=checkValue report "Wrong sequence expected (" 
                & to_string(checkValue) & ") but got (" & to_string(sequence) & ")" severity error;
                
            wait for 20ns;
        end loop;
        
    end process;    
end Behavioral;
