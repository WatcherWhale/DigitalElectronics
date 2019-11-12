library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library draw;
use draw.Generators.ALL;
use draw.Memory.ALL;
use draw.Screen.ALL;

entity Controller is
    Port (
        CLK100MHZ : in std_logic;
        VGA_R : out std_logic_vector(3 downto 0);
        VGA_G : out std_logic_vector(3 downto 0);
        VGA_B : out std_logic_vector(3 downto 0);
        VGA_HS : out std_logic;
        VGA_VS : out std_logic);
end Controller;

architecture Behavioral of Controller is

    signal PixelClk : std_logic;
    signal frame : std_logic := '0';
    
    signal wea : std_logic_vector(0 downto 0);
    signal AddrA, AddrB : std_logic_vector(18 DOWNTO 0);
    signal Output : std_logic_vector(2 DOWNTO 0);
    signal Input : std_logic_vector(2 DOWNTO 0);
    
    signal x,y : integer;
    signal Write : std_logic;


begin
    
    cClk : ClockingWizard
    port map( 
       PixelClk => PixelClk,
       Clk100MHz => Clk100MHz);
    
    vidMemory: VideoMemory
    port map (
        clka => CLK100MHZ,
        wea => wea,
        addra => AddrA,
        dina => Input,
        clkb => PixelClk,
        web => "0",
        addrb => AddrB,
        doutb => Output,
        dinb => "000"
    );
       
    cFramer : FrameGenerator
    port map(
        clk => Clk100MHZ,
        frame => frame,
        wr_en => wea(0),
        addr => AddrA,
        din => Input);
    
    VSync : VPulse
    Generic map(
        g_visible => visible_V,
        g_front => front_V,
        g_sync => sync_V,
        g_back => sync_V,
        
        g_visible_H => visible_H,
        g_front_H => front_H,
        g_sync_H => sync_H,
        g_back_H => back_H
    )
    Port map (
        pixelClock => PixelClk,
        HSync => VGA_HS,
        VSync => VGA_VS,
        xPos => x,
        yPos => y,
        Write => Write);
    
    pSetAddr : process(x, y)
    begin
        -- Ask for the value in the memory for the current pixel
        -- Address = pixel_x + pixel_y * 640
        --
        -- This formula is used because the information is stored per row (640 pixels/row = 640 x_pixels/y_pixel)
        AddrB <= std_logic_vector(to_unsigned(x + y * 640,19));
    end process;
    
    pReadValue : process(Write, Output)
    begin
        -- Set default values
        VGA_R <= "0000";
        VGA_G <= "0000";
        VGA_B <= "0000";
        
        if(Write = '1')
        then
            -- Parse the pixel data from memory to RGB values
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
        else
            frame <= '1';
        end if;
    end process;
   

end Behavioral;
