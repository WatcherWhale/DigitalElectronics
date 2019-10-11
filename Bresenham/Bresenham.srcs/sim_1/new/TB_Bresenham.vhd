library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.textio.all;


entity TB_Bresenham is
end TB_Bresenham;

architecture Behavioral of TB_Bresenham is

    component Bresenham
        Port (
            X0: in integer;
            Y0: in integer;
            X1: in integer;
            Y1: in integer;
            Start : in STD_LOGIC;
            Clk : in STD_LOGIC;

            xOut : out integer;
            yOut : out integer;
            Plot : out STD_LOGIC);
    end component;
    
    signal x0,y0,x1,y1 : integer := 0;
    signal x,y : integer := 0;
    signal Clk, Start, Plot : std_logic := '0';
    
    file testFile : text;

begin
    
    bres : Bresenham
    Port map(
        X0 => x0,
        Y0 => y0,
        X1 => x1,
        Y1 => y1,
        Start => Start,
        Clk => Clk,
        xOut => x,
        yOut => y,
        Plot => Plot);
    
    pStart : process
        variable inLine : line;
        variable char : character;
    begin
        file_open(testFile, "testvector.txt", read_mode);
        
        while not endfile(testfile)
        loop
            readline(testFile,inLine);
            read(inLine,char);
            
            if char = 'B'
            then
                Start <= '1';
            end if;
            
        end loop;
        
        file_close(testfile);
        
    end process;

end Behavioral;
