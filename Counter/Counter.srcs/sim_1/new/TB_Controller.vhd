library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TB_Controller is
end TB_Controller;

architecture Behavioral of TB_Controller is

    --Components
    component Controller
    Generic (g_max_count : integer);
    Port(
        CLK100MHZ : in std_logic;
        AN: out std_logic_vector(7 downto 0);
        C: out std_logic_vector(6 downto 0));
    end component;
    
    signal clock : std_logic := '0';
    signal AN : std_logic_vector(7 downto 0);
    signal C : std_logic_vector(6 downto 0);

begin
    
    ctrl : Controller
        Generic map(g_max_count => 59)
        Port map (
            CLK100MHZ => clock,
            AN => AN,
            C => C);
    
    pStimuli : process
    begin
        for I in 0 to 1000000000
        loop
            clock <= not clock;
            wait for 10ns;
        end loop;
    end process;
end Behavioral;
