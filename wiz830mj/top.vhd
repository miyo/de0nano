library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top is

  port(
    CLOCK_50 : in std_logic;
    KEY : in std_logic_vector(1 downto 0);
    
    GPIO_1_IN : in std_logic_vector(1 downto 0);
    GPIO_1 : inout std_logic_vector(33 downto 0);

    LED : out std_logic_vector(7 downto 0)
    );
  
end top;

architecture RTL of top is

begin
  
  
end RTL;
