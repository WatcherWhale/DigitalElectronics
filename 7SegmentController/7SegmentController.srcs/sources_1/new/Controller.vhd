--Created by Mathias Maes

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity Controller is
 Port
 (
    SW : in std_logic_vector(15 DOWNTO 0);
    AN : out std_logic_vector(7 downto 0);
    
    CA : out std_logic;
    CB : out std_logic;
    CC : out std_logic;
    CD : out std_logic;
    CE : out std_logic;
    CF : out std_logic;
    CG : out std_logic
  );
end Controller;

architecture Behavioral of Controller is

    component BCDTo7SegmentConverter port(
        BCD : in Unsigned(3 downto 0);
        SEG : out std_logic_vector(6 downto 0)
    );
    end component;
    
    signal BCDin  : unsigned(6 downto 0);
    signal SEGout : std_logic_vector(6 downto 0);
    
begin
    
    BCDConverter : BCDTo7SegmentConverter port map(
        BCD => BCDin(3 downto 0),
        SEG => SEGout
    );
    
    pInputChanged : process (SW)
    begin  
        -- Check if the 7 segment displays should be on or off 
        AN(0) <= not(not(SW(7)) and not(SW(8) ) );
        AN(1) <= not(SW(7) and not(SW(8)));
        AN(6) <= not(SW(8) and not(SW(7)));
        AN(7) <= not(SW(7) and SW(8));
        
        -- Set the unused displays off
        AN(2) <= '1';
        AN(3) <= '1';
        AN(4) <= '1';
        AN(5) <= '1';
        
       if (unsigned(SW(8 downto 7 )) = 0) and unsigned(SW(6 downto 0)) < 100
       then
            BCDin <= unsigned(SW(6 downto 0)) rem 10;
            
       elsif (unsigned(SW(8 downto 7 )) = 1) or unsigned(SW(6 downto 0)) > 99
       then
            BCDin <= unsigned(SW(6 downto 0)) / 10;
            
       elsif (unsigned(SW(8 downto 7 )) = 2) and unsigned(SW(15 downto 9)) < 100
       then
            BCDin <= unsigned(SW(15 downto 9)) rem 10;
            
       elsif (unsigned(SW(8 downto 7 )) = 3) or unsigned(SW(15 downto 9)) > 99
       then
            BCDin <= unsigned(SW(15 downto 9)) / 10;
       end if;
    end process;
    
    pSegmentUpdated : process(SEGout)
    begin
        CA <= not SEGout(6);
        CB <= not SEGout(5);
        CC <= not SEGout(4);
        CD <= not SEGout(3);
        CE <= not SEGout(2);
        CF <= not SEGout(1);
        CG <= not SEGout(0);
    end process;
    
end Behavioral;
