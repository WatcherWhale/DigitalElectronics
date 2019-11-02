library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library draw;
use draw.Memory.TriangleFifo;
use draw.Generators.LFSR;

entity TriangleGenerator is
    Port (
        clk : in std_logic;
        gen : in STD_LOGIC;
        
        triangleData : out STD_LOGIC_VECTOR(58 downto 0);
        genDone : out STD_LOGIC);
end TriangleGenerator;

architecture Behavioral of TriangleGenerator is
    
    type tState IS (WAIT_STATE, GEN_STATE, GENEND_STATE, READ_STATE);
    signal State : tState := WAIT_STATE;
    
    signal sequence : std_logic_vector(15 downto 0);
    
    signal dataCounter : integer range 0 to 3 := 0;
    signal triangleCounter : integer range 0 to 2 := 0;
    
    signal wr_en : std_logic := '0';
    signal rd_en : std_logic := '0';
    
    signal full, empty : std_logic;
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
            Case State is
                When WAIT_STATE =>
                    dataCounter <= 0;
                    triangleCounter <= 0;
                    
                    if(gen = '1')
                    then
                        State <= GEN_STATE;
                    end if;
                When GEN_STATE =>
                    wr_en <= '1';
                    rd_en <= '0';
                    
                    if dataCounter < 3
                    then
                        din((dataCounter+1) * 16 - 1 downto dataCounter * 16) <= sequence;
                        dataCounter <= dataCounter + 1;
                    else
                        din(56 downto 48) <= sequence(9 downto 0);
                        din(57) <= '1';
                        din(58) <= '0';
                        
                        triangleCounter <= triangleCounter + 1;
                        dataCounter <= 0;
                        
                        if triangleCounter = 2
                        then
                            State <= GENEND_STATE;
                        end if;
                        
                    end if;
                
                When GENEND_STATE =>
                    wr_en <= '1';
                    rd_en <= '0';
                    
                    if dataCounter < 3
                    then
                        din((dataCounter+1) * 16 - 1 downto dataCounter * 16) <= sequence;
                        dataCounter <= dataCounter + 1;
                    else
                        din(56 downto 48) <= sequence(9 downto 0);
                        din(57) <= '1';
                        din(58) <= '1';
                        
                        triangleCounter <= 0;
                        dataCounter <= 0;
                        genDone <= '1';
                        
                        State <= READ_STATE;
                    end if;
                when READ_STATE =>
                    wr_en <= '0';
                    rd_en <= '1';
                    
                    if empty = '1'
                    then
                        State <= WAIT_STATE;
                    end if;
                    
            end Case;
        end if;
    end process;
end Behavioral;
