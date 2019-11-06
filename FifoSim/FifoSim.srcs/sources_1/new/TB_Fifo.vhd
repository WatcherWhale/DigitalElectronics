library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_Fifo is
--  Port ( );
end TB_Fifo;

architecture Behavioral of TB_Fifo is
    
    signal clk : std_logic := '0';
    signal wr_en : std_logic := '1';
    signal din : STD_LOGIC_VECTOR(58 DOWNTO 0);
    signal dout : STD_LOGIC_VECTOR(58 DOWNTO 0);
    
    component TriangleFifo
    PORT (
        clk : IN STD_LOGIC;
        srst : IN STD_LOGIC;
        din : IN STD_LOGIC_VECTOR(58 DOWNTO 0);
        wr_en : IN STD_LOGIC;
        rd_en : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR(58 DOWNTO 0);
        full : OUT STD_LOGIC;
        empty : OUT STD_LOGIC
    );
    end component;
    
begin

    cFIFO : TriangleFifo
    PORT MAP (
        clk => clk,
        srst => '0',
        din => din,
        wr_en => wr_en,
        rd_en => '1',
        dout => dout
    );
    
    pClk : process
    begin
        clk <= not clk;
        wait for 10ns;
    end process;
    
    pAdd : process
    begin
        wr_en <= '1';
        din(3 downto 0) <= "1111";
        wait for 10ns;
        din(7 downto 4) <= "0000";
        wait for 10ns;
    end process;

end Behavioral;
