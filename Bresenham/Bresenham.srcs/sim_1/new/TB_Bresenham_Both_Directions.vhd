-- Mathias Maes
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.textio.ALL;
use IEEE.std_logic_textio.ALL;

entity TB_Bresenham_Both_Directions is
end TB_Bresenham_Both_Directions;

architecture Behavioral of TB_Bresenham_Both_Directions is

    type tPoint is array(0 to 1) of integer;
    type tPoints is array(0 to 500) of tPoint;
    type tArray is array(0 to 4) of tPoints;

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
    signal s : std_logic := '0';
    
    file testFile : text;
    file charFile : text;

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
        
    pClock : process
    begin
        Clk <= not Clk;
        wait for 10ns;
    end process;
    
    pStart : process
        variable inLine : line;
        variable charLine : line;
        variable char : character;
        variable i : integer;
        variable len : integer;
        variable l : integer;
        variable cX : integer;
        variable cY : integer;
        variable arrays : tArray;
        variable str : string;
    begin
        
        file_open(testFile, "testvector.txt", read_mode);
        file_open(charFile, "testvector.txt", read_mode);        
        
        i:=0;
        while not endfile(testFile)
        loop
            readline(testFile,inLine);
            read(inLine,char);
            readline(charFile,charLine);
            read(charLine,char);
            
            readline(testFile,inLine);

            l:= 0;
            while char /= 'E'
            loop
                readline(charFile,charLine);
                read(charLine,char);
                
                if char /= 'E'
                then
                    readline(testFile,inLine);
                    read(inLine,cX);
                    read(inLine,cY);
                    arrays(i)(l) := (cX,cY);
                end if;
            
                l:=l+1;
            end loop;
            i:=i+1;
        end loop;
        
        closefile(testFile);
        closefile(charFile);
        
    end process;
    

end Behavioral;














