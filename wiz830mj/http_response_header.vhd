library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity http_response_header is
port(
clk : in std_logic;
reset : in std_logic;
data_length : out signed(32-1 downto 0);
data_address : in signed(32-1 downto 0);
data_din : in signed(32-1 downto 0);
data_dout : out signed(32-1 downto 0);
data_we : in std_logic;
data_oe : in std_logic;
length : out signed(32-1 downto 0));
end http_response_header;
architecture RTL of http_response_header is
subtype MEM is signed(31 downto 0);
type ROM is array ( 0 to 31 ) of MEM;
constant data : ROM := (
X"48545450",
X"2f312e31",
X"20323030",
X"204f4b0d",
X"0a436f6e",
X"74656e74",
X"2d4c656e",
X"6774683a",
X"20202020",
X"20202020",
X"20202020",
X"20202020",
X"0d0a4b65",
X"65702d41",
X"6c697665",
X"3a207469",
X"6d656f75",
X"743d3135",
X"2c206d61",
X"783d310d",
X"0a436f6e",
X"6e656374",
X"696f6e3a",
X"20636c6f",
X"73650d0a",
X"436f6e74",
X"656e742d",
X"54797065",
X"3a202074",
X"6578742f",
X"68746d6c",
X"0d0a0d0a");
begin
data_length <= to_signed(32, 32);
length <= to_signed(32, 32);
process(clk)
begin
if (clk'event and clk = '1') then
data_dout <= data(to_integer(unsigned(data_address)));
end if;
end process;
end RTL;
