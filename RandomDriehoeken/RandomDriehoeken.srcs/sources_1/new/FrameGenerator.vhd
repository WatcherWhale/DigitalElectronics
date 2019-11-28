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
        clk : in std_logic;
        frame : in std_logic;
        
        wr_en : out std_logic;
        addr : out std_logic_vector(18 DOWNTO 0);
        din : out  std_logic_vector(2 DOWNTO 0));
end FrameGenerator;

architecture Behavioral of FrameGenerator is

    type tState IS (READ_STATE, WAIT_STATE, GEN_STATE, WAIT_FOR_FRAME, BACKGROUND_STATE);
    signal State : tState := WAIT_FOR_FRAME;

    signal triangleData : STD_LOGIC_VECTOR(58 downto 0);
    
    signal x0,y0,x1,y1 : integer := 0;
    signal x,y : integer := 0;
    signal xB,yB : integer := 0;
    signal Start, Plot : std_logic := '0';
    
    signal full, empty : std_logic;
    signal rd_en : std_logic := '0';
    
    signal lines : integer range 0 to 3;
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
                when BACKGROUND_STATE =>
                    wr_en <= '1';
                    rd_en <= '0';
                    
                    addr <= std_logic_vector(to_unsigned(xB + yB * 640,19));
                    din <= "111";
                    
                    xB <= xB +1;
                    if(xB = 639)
                    then
                        yB <= yB + 1;
                        
                        if(yB = 479)
                        then
                            State <= WAIT_STATE;
                            xB <= 0;
                            yB <= 0;
                        end if;
                    end if;
                
                when WAIT_STATE =>
                    rd_en <= '0';
                    wr_en <= '0';
                    lines <= 0;
                    
                    
                    if full = '1'
                    then
                        State <= READ_STATE;
                    end if;
                    
                when READ_STATE =>
                    rd_en <= '1';
                    wr_en <= '0';
                    
                    color <= triangleData(57);
                    last <= triangleData(58);
                    
                    
                    x0 <= TO_INTEGER(UNSIGNED(triangleData(9 downto 0)));
                    x1 <= TO_INTEGER(UNSIGNED(triangleData(19 downto 10)));
                    y0 <= TO_INTEGER(UNSIGNED(triangleData(28 downto 20)));
                    y1 <= TO_INTEGER(UNSIGNED(triangleData(37 downto 29)));
                    
                    State <= WAIT_STATE;
                
                when GEN_STATE =>
                    rd_en <= '0';
                    wr_en <= '1';
                    
                    if Plot <= '0'
                    then
                        lines <= lines + 1;
                        
                        if(lines = 2)
                        then
                            State <= WAIT_STATE;
                            
                            if(last = '1')
                            then
                                State <= WAIT_FOR_FRAME;
                            end if;
                        end if;
                    else
                        if(Plot = '1' AND x >= 0 AND x < 640 AND y >= 0 AND y < 479)
                        then
                            addr <= std_logic_vector(to_unsigned(x + y * 640,19));
                            if color = '1'
                            then
                                -- Set color at pixel (x,y) to white
                                din <= "111";
                            else
                                -- Set color at pixel (x,y) to black
                                din <= "000";
                            end if;
                        end if;
                    end if;
                    
                when WAIT_FOR_FRAME =>
                    wr_en <= '0';
                    rd_en <= '0';

                    if(frame <= '1')
                    then
                        State <= BACKGROUND_STATE;
                    end if;
                    
            end case;
        end if;
    
    end process;
end Behavioral;
