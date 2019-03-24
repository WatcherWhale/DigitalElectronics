--Created by Mathias Maes

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity Controller is
 Port
 (
    SW : in std_logic_vector(15 downto 0);
    BTNC : in std_logic;
    
    AN : out std_logic_vector(7 downto 0);
    
    CA : out std_logic;
    CB : out std_logic;
    CC : out std_logic;
    CD : out std_logic;
    CE : out std_logic;
    CF : out std_logic;
    CG : out std_logic;
    DP : out std_logic
  );
end Controller;

architecture Behavioral of Controller is

    -- Define the component created in 'BCDTo7SegmentConverter.vhd'
    component BCDTo7SegmentConverter port(
        BCD : in Unsigned(3 downto 0);
        SEG : out std_logic_vector(6 downto 0)
    );
    end component;
    
    signal BCDin  : unsigned(6 downto 0);
    signal SEGout : std_logic_vector(6 downto 0);
    
begin
    
    -- Create a converter
    -- and map it's input and output to the corrosponding signals
    BCDConverter : BCDTo7SegmentConverter port map(
        BCD => BCDin(3 downto 0),
        SEG => SEGout
    );
    
    -- Check if the switches have been updated
    pInputChanged : process (SW,BTNC)
    begin  
        -- Active High
        DP <= not BTNC;
        
        -- Check if the 7 segment displays should be on or off 
        -- These need to be active low
        AN(7) <= not(not(SW(7)) and not(SW(8) ) );  -- 0 & 0
        AN(6) <= not(SW(7) and not(SW(8)));         -- 0 & 1
        AN(1) <= not(SW(8) and not(SW(7)));         -- 1 & 0
        AN(0) <= not(SW(7) and SW(8));              -- 1 & 1
        
        -- Set the unused displays off
        AN(2) <= '1';
        AN(3) <= '1';
        AN(4) <= '1';
        AN(5) <= '1';
        
        -- Making sure BCDin gets a value
        BCDin <= "0001010";
        
        if( BTNC = '0' or
          (unsigned(SW(8 downto 7 )) = 2 and SW(6) = '0') or
          (unsigned(SW(8 downto 7 )) = 3 and SW(6) = '0'))
        then
            -- Check if the first display is on and the binary input is below 100
           if (unsigned(SW(8 downto 7 )) = 3) and unsigned(SW(6 downto 0)) < 100
           then
                -- Get the remainder of the binary value from the divison by 10
                BCDin <= unsigned(SW(6 downto 0)) rem 10;
           --Check if the seccond display is on or the binary input is above 99
           elsif (unsigned(SW(8 downto 7 )) = 2) or unsigned(SW(6 downto 0)) > 99
           then
                -- Divide by ten
                -- If this number becomes more than 9 the Converter will return 'E'
                BCDin <= unsigned(SW(6 downto 0)) / 10;
                
           -- Check if the third display is on and the binary input is below 100
           elsif (unsigned(SW(8 downto 7 )) = 1) and unsigned(SW(15 downto 9)) < 100
           then
                -- Get the remainder of the binary value from the divison by 10
                BCDin <= unsigned(SW(15 downto 9)) rem 10;
                
           -- Check if the fourth display is on or the binary input is above 99     
           elsif (unsigned(SW(8 downto 7 )) = 0) or unsigned(SW(15 downto 9)) > 99
           then
                -- Divide by ten
                -- If this number becomes more than 9 the Converter will return 'E'
                BCDin <= unsigned(SW(15 downto 9)) / 10;
           end if;
       else
           if (unsigned(SW(8 downto 7)) = 3)
           then
                BCDin <= (unsigned(not SW(6 downto 0)) + 1) rem 10;
                
            elsif(unsigned(SW(8 downto 7)) = 2)
            then
                BCDin <= (unsigned(not SW(6 downto 0)) + 1) / 10;
                
            elsif (unsigned(SW(8 downto 7)) = 1)
            then
                BCDin <= (unsigned(not SW(15 downto 9)) + 1) rem 10;
                
            elsif(unsigned(SW(8 downto 7)) = 0)
            then
                BCDin <= (unsigned(not SW(15 downto 9)) + 1) / 10;  
            end if;
       end if;
    end process;
    
    -- Check if the 7 Segment code has been changed
    pSegmentUpdated : process(SEGout)
    begin
        -- Reverse the displays
        -- Add a not port because the 7 segment displays are active low        
        CA <= not SEGout(6);
        CB <= not SEGout(5);
        CC <= not SEGout(4);
        CD <= not SEGout(3);
        CE <= not SEGout(2);
        CF <= not SEGout(1);
        CG <= not SEGout(0);
    end process;
    
end Behavioral;
