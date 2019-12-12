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
        VGA_VS : out std_logic;
        LED : out std_logic_vector(1 downto 0));
end Controller;

architecture Behavioral of Controller is

    signal PixelClk : std_logic;
    signal frame : std_logic := '0';
    
    signal wea1, wea2, wea: std_logic_vector(0 downto 0);
    signal Addr1A, Addr1B, Addr2A, Addr2B, Addr : std_logic_vector(18 DOWNTO 0);
    signal Output1, Output2 : std_logic_vector(2 DOWNTO 0);
    signal Input1, Input2, Input : std_logic_vector(2 DOWNTO 0);
    signal UseMem2 : std_logic := '0';
       
    signal x,y,hc,vc : integer;
    signal Write : std_logic;

begin
    
    cClk : ClockingWizard
    port map( 
       PixelClk => PixelClk,
       Clk100MHz => Clk100MHz);
    
    vidMemory: VideoMemory
    port map (
        clka => CLK100MHZ,
        wea => wea1,
        addra => Addr1A,
        dina => Input1,
        clkb => PixelClk,
        web => "0",
        addrb => Addr1B,
        doutb => Output1,
        dinb => "000"
    );
    
    vidMemory2: VideoMemory
    port map (
        clka => CLK100MHZ,
        wea => wea2,
        addra => Addr2A,
        dina => Input2,
        clkb => PixelClk,
        web => "0",
        addrb => Addr2B,
        doutb => Output2,
        dinb => "000"
    );
       
    cFramer : FrameGenerator
    port map(
        fastclk => Clk100MHZ,
        clk => PixelClk,
        frame => frame,
        wr_en => wea(0),
        addr => Addr,
        din => Input);
    
    cVSync : VPulse
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
        HCount => x,
        VCount => y,
        Write => Write);
    
    pSwitchMemory : process(CLK100MHZ)
    begin
        if rising_edge(CLK100MHZ)
        then
            if hc = 0 AND vc = 0
            then
                frame <= '1';
                UseMem2 <= not UseMem2;
            end if;
        end if; 
    end process;
    
    pSetAddr : process(x, y, UseMem2)
    begin
        VGA_R <= "0000";
        VGA_G <= "0000";
        VGA_B <= "0000";
        -- Ask for the value in the memory for the current pixel
        -- Address = pixel_x + pixel_y * 640    
        Addr1B <= (others => '0');
        Addr2B <= (others => '0');
        
        if(UseMem2 = '1')
        then
            --Addr1B <= std_logic_vector(to_unsigned(x + y * 640,19));
            VGA_R <= "1111";
        else
            --Addr2B <= std_logic_vector(to_unsigned(x + y * 640,19));
            VGA_B <= "1111";
        end if;
        
    end process;
    
    pPipeOutput : process(Write, Output1, Output2, UseMem2)
    begin
        --VGA_R <= "0000";
        --VGA_G <= "0000";
        --VGA_B <= "0000";
        
        if(Write <= '1')
        then
            if UseMem2 = '1'
            then
                --VGA_R <= "1111";
            
                if(Output1(2) = '1')
                then
                    --VGA_R <= "1111";
                end if;
                
                if(Output1(1) = '1')
                then
                    --VGA_G <= "1111";
                end if;
                
                if(Output1(0) = '1')
                then
                    --VGA_B <= "1111";
                end if;
            else
                --VGA_B <= "1111";
                
                if(Output1(2) = '1')
                then
                    --VGA_R <= "1111";
                end if;
                
                if(Output1(1) = '1')
                then
                    --VGA_G <= "1111";
                end if;
                
                if(Output1(0) = '1')
                then
                    --VGA_B <= "1111";
                end if;
            end if;
        end if;
    end process;
    
    pPipeInput : process(Input, UseMem2)
    begin
        Input1 <= "000";
        Input2 <= "000";
    
        if UseMem2 = '0'
        then
            Input1 <= Input;
        else
            Input2 <= Input;
        end if;
    end process;
    
    pPipeWriteEnable : process(wea, UseMem2)
    begin
        wea1 <= "0";
        wea2 <= "0";
        
        if UseMem2 = '0'
        then
            wea1 <= wea;
        else
            wea2 <= wea;
        end if;
    end process;
    
    pPipeAddr : process(Addr, UseMem2)
    begin
        Addr1a <= (others => '0');
        Addr2a <= (others => '0');
    
        if UseMem2 = '0'
        then
            Addr1a <= Addr;
        else
            Addr2a <= Addr;
        end if;
    end process;

end Behavioral;