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
        fastclk : in std_logic;
        frame : in std_logic;
        
        wr_en : out std_logic;
        addr : out std_logic_vector(18 DOWNTO 0);
        din : out  std_logic_vector(2 DOWNTO 0));
end FrameGenerator;

architecture Behavioral of FrameGenerator is

    type tState IS (READ_STATE, WAIT_STATE, GEN_STATE, WAIT_FOR_FRAME, NEXT_LINE);
    signal State : tState := WAIT_FOR_FRAME;

    signal triangleData : STD_LOGIC_VECTOR(58 downto 0);
    signal triangleFifo : STD_LOGIC_VECTOR(58 downto 0);
    
    signal x0,y0,x1,y1 : integer := 0;
    signal x,y : integer := 0;
    --signal xB,yB : integer := 0;
    signal Start, Plot : std_logic := '0';
    
    signal full, empty : std_logic;
    signal rd_en : std_logic := '0';
    
    signal lines : integer range 0 to 3;
    signal color : STD_LOGIC := '0';
    signal last : STD_LOGIC := '0';
    
begin
    cTriGen : TriangleGenerator
    Port map(
        clk => fastclk,
        rd_en => rd_en,
        full => full,
        empty => empty,
        triangleData => triangleFifo);
        
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
                when WAIT_STATE =>
                    rd_en <= '0';
                    wr_en <= '0';
                    lines <= 0;
                    triangleData <= (others => '0');
                    
                    if full = '1'
                    then
                        State <= READ_STATE;
                    end if;
                    
                when READ_STATE =>
                    rd_en <= '1';
                    wr_en <= '0';
                    lines <= 0;
                    triangleData <= triangleFifo;
                    
                    last <= triangleFifo(58);
                    color <= triangleFifo(57);
                    
                    State <= GEN_STATE;
                
                when NEXT_LINE =>
                    rd_en <= '0';
                    wr_en <= '1';
                    lines <= lines + 1;
                    STATE <= GEN_STATE;
                    
                    if(lines = 0)
                    then
                        x0 <= to_integer(unsigned(triangleData(9 downto 0)));
                        y0 <= to_integer(unsigned(triangleData(18 downto 10)));
                        x1 <= to_integer(unsigned(triangleData(28 downto 19)));
                        y1 <= to_integer(unsigned(triangleData(37 downto 29)));
                        Start <= '1';
                    elsif(lines = 1)
                    then
                        x0 <= to_integer(unsigned(triangleData(28 downto 19)));
                        y0 <= to_integer(unsigned(triangleData(37 downto 29)));
                        x1 <= to_integer(unsigned(triangleData(47 downto 38)));
                        y1 <= to_integer(unsigned(triangleData(56 downto 48)));
                        Start <= '1';
                    elsif(lines=2)
                    then
                        x0 <= to_integer(unsigned(triangleData(9 downto 0)));
                        y0 <= to_integer(unsigned(triangleData(18 downto 10)));
                        x1 <= to_integer(unsigned(triangleData(47 downto 38)));
                        y1 <= to_integer(unsigned(triangleData(56 downto 48)));                        
                    elsif(lines = 3)
                    then
                        if(last = '1')
                        then
                            State <= WAIT_FOR_FRAME;
                        else
                            STATE <= WAIT_STATE;
                        end if;
                        
                        Start <= '0';
                    end if;
                
                when GEN_STATE =>
                    rd_en <= '0';
                    wr_en <= '1';
                    lines <= lines;
                    
                    if Plot <= '0'
                    then
                        STATE <= NEXT_LINE;
                    else
                        Start <= '0';
                        
                        if(x >= 0 AND x < 640 AND y >= 0 AND y < 479)
                        then
                            addr <= std_logic_vector(to_unsigned(x + y * 640,19));
                            if color = '1'
                            then
                                -- Set color at pixel (x,y) to yellow
                                din <= "110";
                            else
                                -- Set color at pixel (x,y) to blue
                                din <= "001";
                            end if;
                        end if;
                    end if;
                    
                when WAIT_FOR_FRAME =>
                    wr_en <= '0';
                    rd_en <= '0';

                    if(frame <= '1')
                    then
                        State <= WAIT_STATE;
                    end if;
            end case;
        end if;
    end process;
end Behavioral;
