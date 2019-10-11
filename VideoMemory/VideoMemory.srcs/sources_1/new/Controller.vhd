library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Controller is
    Port(
        CLK100MHZ : in std_logic;
        VGA_R : out std_logic_vector(3 downto 0);
        VGA_G : out std_logic_vector(3 downto 0);
        VGA_B : out std_logic_vector(3 downto 0);
        VGA_HS : out std_logic;
        VGA_VS : out std_logic
    );
end Controller;

architecture Behavioral of Controller is

signal PixelClk : std_logic;

signal Addr : std_logic_vector(18 DOWNTO 0);
signal Output : std_logic_vector(2 DOWNTO 0);

signal x,y : integer;
signal Write : std_logic;

component ClockingWizard
port
(
    PixelClk  : out std_logic;
    Clk100MHz : in  std_logic
);
end component;

component VideoMemory
    port (
        clka    : IN  std_logic;
        wea     : IN  std_logic_vector(0 DOWNTO 0);
        addra   : IN  std_logic_vector(18 DOWNTO 0);
        dina    : IN  std_logic_vector(2 DOWNTO 0);
        clkb    : IN  std_logic;
        web     : IN  std_logic_vector(0 DOWNTO 0);
        addrb   : IN  std_logic_vector(18 DOWNTO 0);
        doutb   : OUT std_logic_vector(2 DOWNTO 0);
        dinb    : IN std_logic_vector(2 DOWNTO 0)
    );
end component;

component VPulse
    Port (
        pixelClock: in std_logic;
        
        HSync : out std_logic;
        VSync : out std_logic;
        Write : out std_logic;
        
        xPos : out integer;
        yPos : out integer
     );
end component;

begin

    clocker : ClockingWizard
    port map( 
        PixelClk => PixelClk,
        Clk100MHz => CLK100MHZ);
    
    vidMemory: VideoMemory
    port map(
        clka => '0',
        wea => "0",
        addra => "0000000000000000000",
        dina => "000",
        clkb => PixelClk,
        web => "0",
        addrb => Addr,
        doutb => Output,
        dinb => "000"
    );
    
    VSync : VPulse
     Port map(
        pixelClock => PixelClk,
        HSync => VGA_HS,
        VSync => VGA_VS,
        xPos => x,
        yPos => y,
        Write => Write);
        
    pSetAddr : process(x, y)
    begin
        Addr <= std_logic_vector(to_unsigned(x + y * 640,19));
    end process;
    
    pReadValue : process(Write, Output)
    begin
        VGA_R <= "0000";
        VGA_G <= "0000";
        VGA_B <= "0000";
    
        if(Write = '1')
        then
            if(Output(2) = '1')
            then
                VGA_R <= "1111";
            end if;
            
            if(Output(1) = '1')
            then
                VGA_G <= "1111";
            end if;
            
            if(Output(0) = '1')
            then
                VGA_B <= "1111";
            end if;
        end if;
    end process;
        
end Behavioral;












