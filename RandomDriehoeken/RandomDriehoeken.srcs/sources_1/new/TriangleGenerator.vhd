library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library draw;
use draw.Memory.TriangleFifo;
use draw.Generators.LFSR;

entity TriangleGenerator is
    Generic(
        g_Triangles : integer := 4);
    Port (
        clk : in std_logic;
        rd_en : in std_logic;
        
        full : out std_logic;
        empty : out std_logic;
        
        triangleData : out STD_LOGIC_VECTOR(58 downto 0));
end TriangleGenerator;

architecture Behavioral of TriangleGenerator is
    
    type tState IS (GEN_STATE, START_STATE);
    signal State : tState := GEN_STATE;
    
    signal sequence : std_logic_vector(15 downto 0);
    
    signal dataCounter : integer range 0 to 3 := 0;
    signal triangleCounter : integer range 0 to g_Triangles := 0;
    
    signal wr_en : std_logic := '0';
    
    signal din : std_logic_vector(58 downto 0);
    
begin

    cFIFO : TriangleFifo
    PORT MAP (
        clk => clk,
        srst => '0',
        din => din,
        wr_en => wr_en,
        rd_en => rd_en,
        dout => triangleData,
        full => full,
        empty => empty
    );
    
    cLfsr : LFSR
    Port map(
        clk => clk,
        sequence => sequence);
    
    pClk : process(clk)
    begin
        if(rising_edge(clk))
        then
            case State is
                When START_STATE =>
                    wr_en <= '0';
                    
                    triangleCounter <= 0;
                    dataCounter <= 0;
                    
                    STATE <= GEN_STATE;
                    
                When GEN_STATE =>
                    wr_en <= '1';
                    
                    if dataCounter < 3
                    then
                        din((dataCounter+1) * 16 - 1 downto dataCounter * 16) <= sequence;
                        dataCounter <= dataCounter + 1;
                    else
                        din(56 downto 48) <= sequence(8 downto 0);
                        din(57) <= '1';
                        din(58) <= '0';
                        
                        triangleCounter <= triangleCounter + 1;
                        dataCounter <= 0;
                                                
                        if triangleCounter = g_Triangles
                        then
                            din(57) <= '1';
                            din(58) <= '1';
                            State <= START_STATE;
                            
                            triangleCounter <= 0;
                        end if;
                    end if;
            end Case;
        end if;
    end process;
end Behavioral;
