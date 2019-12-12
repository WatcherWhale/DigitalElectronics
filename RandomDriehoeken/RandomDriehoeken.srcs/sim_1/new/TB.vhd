library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TB is
--  Port ( );
end TB;

architecture Behavioral of TB is

    signal clock : std_logic := '0';
    
    component Controller
        Port(CLK100MHZ : in std_logic;
        VGA_R : out std_logic_vector(3 downto 0);
        VGA_G : out std_logic_vector(3 downto 0);
        VGA_B : out std_logic_vector(3 downto 0);
        VGA_HS : out std_logic;
        VGA_VS : out std_logic;
        LED : out std_logic_vector(1 downto 0));
    end component;
    
    signal R,G,B : std_logic_vector(3 downto 0);
    signal H,V : std_logic;
    signal LED : std_logic_vector(1 downto 0);
    
begin

   cc : Controller
   Port map(
        CLK100MHZ => Clock,
        VGA_R => R,
        VGA_G => G,
        VGA_B => B,
        VGA_HS => H,
        VGA_VS => V,
        Led => Led);
   
    pClock : process
    begin
        clock <= not clock;
        wait for 1ns;
    end process;


end Behavioral;
