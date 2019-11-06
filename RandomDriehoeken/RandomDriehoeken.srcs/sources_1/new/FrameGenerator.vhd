library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library draw;
use draw.Generators.TriangleGenerator;
use draw.Drawing.BresenhamErr;

entity FrameGenerator is
    Generic(
        g_Triangles : integer := 4);
    Port (
    clk : in std_logic);
end FrameGenerator;

architecture Behavioral of FrameGenerator is

    type tState IS (START_STATE, READ_STATE, WAIT_STATE);
    signal State : tState := START_STATE;

    signal triangleData : STD_LOGIC_VECTOR(58 downto 0);
    
    signal x0,y0,x1,y1 : integer := 0;
    signal x,y : integer := 0;
    signal Start, Plot : std_logic := '0';
    
    signal full, empty : std_logic;
    signal rd_en : std_logic := '0';
    
    signal triangle : integer range 0 to g_Triangles;
    signal color : STD_LOGIC := '0';
    signal last : STD_LOGIC := '0';
    
begin
    cTriGen : TriangleGenerator
    Port map(
        clk => clk,
        rd_en => rd_en,
        full => full,
        empty => empty,
        triangleData => triangleData);
        
    cBres : BresenhamErr
    Port map(
        X0 => x0,
        Y0 => y0,
        X1 => x1,
        Y1 => y1,
        Start => Start,
        Clk => clk,
        xOut => x,
        yOut => y,
        Plot => Plot);
    
    pStateMachine : process(clk)
    begin
        
        if rising_edge(clk)
        then
            case State is
                when START_STATE=>
                    rd_en <= '0';

                    if full = '1'
                    then
                        State <= READ_STATE;
                    end if;
                    
                when READ_STATE =>
                    rd_en <= '1';
                    
                    color <= triangleData(57);
                    last <= triangleData(58);
                    
                    x0 <= TO_INTEGER(UNSIGNED(triangleData(9 downto 0)));
                    x1 <= TO_INTEGER(UNSIGNED(triangleData(9 downto 0)));
                    
                    State <= WAIT_STATE;
                    
            end case;
        end if;
    
    end process;
    
    
    
    pDraw: process(x,y, Plot)
    begin
        if(Plot = '1')
        then
            
        else
        end if;
    end process;


end Behavioral;
