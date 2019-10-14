-- Mathias Maes

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
    signal s : std_logic := '0';
    
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
        variable i : integer;
        variable cX : integer;
        variable cY : integer;
        variable temp : integer;
    begin
        file_open(testFile, "testvector.txt", read_mode);
        
        readline(testFile,inLine);
        read(inLine,char);
        
        Start <= '1';
        readline(testfile,inLine);
        
        read(inLine,temp);
        X0 <= temp;
        read(inLine,temp);
        Y0 <= temp;
        read(inLine,temp);
        X1 <= temp;
        read(inLine,temp);
        Y1 <= temp;
        
        wait for 20ns;
        Start <= '0';
        --wait for 21ns;
        
        while not endfile(testFile)
        loop
            if not endfile(testfile)
            then
                while Plot = '1' AND not endfile(testFile)
                loop
                    readLine(testfile,inLine);
                    read(inLine,cX);
                    read(inLine,cY);
                    
                    if(x/=cX OR y/=cY)
                    then
                         assert false report "Wrong coordinate! Expected (" &
                         integer'image(cX) & ", " & integer'image(cY) & ") but got (" &
                         integer'image(x) & ", " & integer'image(y) & ") instead!" severity warning;
                    end if;
                    
                    wait for 20ns;
                    Start <= '0';
                end loop;
                
                readline(testFile,inLine);
                read(inLine, char);
                if char /= 'E'
                then
                    assert false report "Line drawing is incomplete!" severity warning;
                end if;

                while char /= 'E'
                loop
                    readline(testFile,inLine);
                    read(inLine, char);
                    wait for 20 ns;
                end loop;
                
                readline(testFile,inLine);
                read(inLine,char);
                
                Start <= '1';
                readline(testfile,inLine);
                
                read(inLine,temp);
                X0 <= temp;
                read(inLine,temp);
                Y0 <= temp;
                read(inLine,temp);
                X1 <= temp;
                read(inLine,temp);
                Y1 <= temp;
                
                wait for 20ns;
                
            end if;      
        end loop;
    end process;
    
    
    pClock : process
    begin
        Clk <= not Clk;
        wait for 10ns;
    end process;
    
end Behavioral;
