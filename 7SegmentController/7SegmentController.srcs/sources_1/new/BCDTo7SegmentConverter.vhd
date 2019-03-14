--Created by Mathias Maes

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity BCDTo7SegmentConverter is
    Port ( BCD : in UNSIGNED(3 downto 0);
           SEG : out std_logic_vector(6 downto 0));
end BCDTo7SegmentConverter;

architecture Behavioral of BCDTo7SegmentConverter is
    
    -- Create an array type
    type tSeg is array(0 to 9) of std_logic_vector (6 downto 0);
    
    -- Create a constant array of the previously defined type
    -- This array contains the 7 Segment code for the corresponding index
    constant cSeg : tSeg := ("1111110", -- 0
                             "0110000", -- 1
                             "1101101", -- 2
                             "1111001", -- 3
                             "0110011", -- 4
                             "1011011", -- 5
                             "1011111", -- 6
                             "1110000", -- 7
                             "1111111", -- 8
                             "1111011");-- 9
    
begin
    pBCD : process (BCD)
    begin        
        if BCD < 10
        then
            -- Convert the UNSIGNED BCD Code to an integer
            -- Take the element with index equals to the previous integer
            SEG <= cSeg(TO_INTEGER(BCD));
        else
            --If the BCD code is invalid return a E of error
            SEG <= "1001111";
        end if;
    end process pBCD;
end Behavioral;
