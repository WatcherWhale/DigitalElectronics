library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package Memory is
    
    component VideoMemory
        port (
            clka    : IN  std_logic;
            wea     : IN  std_logic_vector(0 DOWNTO 0);
            addra   : IN  std_logic_vector(18 DOWNTO 0);
            dina    : IN  std_logic_vector(2 DOWNTO 0);
            douta   : OUT std_logic_vector(2 DOWNTO 0);
            clkb    : IN  std_logic;
            web     : IN  std_logic_vector(0 DOWNTO 0);
            addrb   : IN  std_logic_vector(18 DOWNTO 0);
            doutb   : OUT std_logic_vector(2 DOWNTO 0);
            dinb    : IN std_logic_vector(2 DOWNTO 0)
        );
    end component;
    
    COMPONENT TriangleFifo
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
    END COMPONENT;

end Memory;