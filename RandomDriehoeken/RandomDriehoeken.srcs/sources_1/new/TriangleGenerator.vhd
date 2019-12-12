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
    
    type tSeq is array(0 to 3) of std_logic_vector(15 downto 0);
    signal sequence : tSeq;
    
    signal dataCounter : integer range 0 to 3 := 0;
    signal triangleCounter : integer range 0 to g_Triangles := 0;
    
    signal wr_en : std_logic := '0';
    signal is_empty : std_logic;
    
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
        empty => is_empty
    );
    
     genLFSR : for I in 0 to 3 generate
        gclfsr : LFSR
        Port map(
            clk => clk,
            sequence => sequence(I));
    end generate;
    
    pClk : process(clk)
    begin
        if(rising_edge(clk))
        then
            case State is
                When START_STATE =>
                    wr_en <= '0';
                    empty <= is_empty;
                    
                    if(is_empty = '1')
                    then
                        STATE <= GEN_STATE;
                    end if;
                    
                When GEN_STATE =>
                    wr_en <= '1';
                    empty <= is_empty;
                    
                    if(triangleCounter = g_Triangles)
                    then 
                        triangleCounter <= 0;
                        din(58) <= '1';
                    else
                        din(58) <= '0';
                    end if;
                    
                    din(57) <= '1';
                    din(56 downto 48) <= sequence(3)(8 downto 0);
                    din(47 downto 32) <= sequence(2);
                    din(31 downto 16) <= sequence(1);
                    din(15 downto 0) <= sequence(0);
                    
                    STATE <= START_STATE;
            end Case;
        end if;
    end process;
end Behavioral;
