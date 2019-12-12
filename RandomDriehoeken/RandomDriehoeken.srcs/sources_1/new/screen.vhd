library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package Screen is
    
    constant visible_V : integer := 480;
    constant front_V : integer := 10;
    constant back_V : integer := 33;
    constant sync_V : integer := 2;
    
    constant visible_H : integer := 640;
    constant front_H : integer := 16;
    constant sync_H : integer := 96;
    constant back_H : integer := 48;
    
    component VPulse
        Generic (
            g_visible : integer;
            g_front   : integer;
            g_back    : integer;
            g_sync    : integer;
            
            g_visible_H : integer;
            g_front_H   : integer;
            g_sync_H    : integer;
            g_back_H    : integer
        );
        Port (
            pixelClock: in std_logic;
            
            HSync : out std_logic;
            VSync : out std_logic;
            Write : out std_logic;
            
            HCount : out integer;
            VCount : out integer;
            
            xPos : out integer;
            yPos : out integer
         );
    end component;
    
    component HPulse
        Generic(
            g_visible : integer;
            g_front   : integer;
            g_sync    : integer;
            g_back    : integer);
        Port(
            Clock_in  : in  std_logic;
            Can_write : out std_logic;
            Xpos      : out integer;
            Sync      : out std_logic;
            HCounter_out  : out integer);
    end component;
    
    
end Screen;