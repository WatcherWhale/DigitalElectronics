library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Controller is
 Port (
    CLK100MHZ : in std_logic;
    VGA_R : out std_logic_vector(3 downto 0);
    VGA_G : out std_logic_vector(3 downto 0) := "0000";
    VGA_B : out std_logic_vector(3 downto 0) := "0000";
    VGA_HS : out std_logic;
    VGA_VS : out std_logic
    );
end Controller;

architecture Behavioral of Controller is
    
    -- Signals
    signal pixelClock : std_logic;
    
    signal Write : std_logic;
    signal x : integer;
    signal y : integer;
    
    -- Components
    component clk_wiz_0
    Port(
      pixelClock : out std_logic;
      CLK100MHZ  : in  std_logic);
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
    clk : clk_wiz_0
    Port map(
        pixelClock => pixelClock,
        CLK100MHZ => CLK100MHZ);
     
     VSync : VPulse
     Port map(
        pixelClock => pixelClock,
        HSync => VGA_HS,
        VSync => VGA_VS,
        xPos => x,
        yPos => y,
        Write => Write);
        
    pUpdateDisplay : process(x,y,Write)
    begin
        VGA_R <= "0000";
        VGA_G <= "0000";
        VGA_B <= "0000";
        
        if(Write = '1')
        then
            VGA_B <= "1111";
        end if;
    end process;
    
end Behavioral;
