library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity wiz830mj_iface is
  port(
    clk   : in std_logic;
    reset : in std_logic;

    -- for WIZ830MJ
    ADDR   : out   std_logic_vector(9 downto 0);
    DATA   : inout std_logic_vector(7 downto 0);
    nCS    : out   std_logic;
    nRD    : out   std_logic;
    nWR    : out   std_logic;
    nINT   : in    std_logic;
    nRESET : out   std_logic;
    BRDY   : in    std_logic_vector(3 downto 0);

    -- for user logic
    address      : in  std_logic_vector(31 downto 0);
    wdata        : in  std_logic_vector(7 downto 0);
    rdata        : out std_logic_vector(7 downto 0);
    cs           : in  std_logic;
    oe           : in  std_logic;
    we           : in  std_logic;
    interrupt    : out std_logic;
    module_reset : in  std_logic;
    bready0      : out std_logic;
    bready1      : out std_logic;
    bready2      : out std_logic;
    bready3      : out std_logic
    );
end wiz830mj_iface;

architecture RTL of wiz830mj_iface is

begin

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        nRESET    <= '0';
        nCS       <= '1';
        nRD       <= '1';
        nWR       <= '1';
        interrupt <= '0';
        bready0   <= '0';
        bready1   <= '0';
        bready2   <= '0';
        bready3   <= '0';
        DATA      <= (others => 'Z');
      else
        bready0   <= BRDY(0);
        bready1   <= BRDY(1);
        bready2   <= BRDY(2);
        bready3   <= BRDY(3);
        interrupt <= not nINT;
        nRESET    <= not module_reset;
        nCS       <= not cs;
        ADDR      <= address(9 downto 0);
        
        if we = '1' then
          nWR  <= '0';
          nRD  <= '1';
          DATA <= wdata;
        elsif oe = '1' then
          nWR <= '1';
          nRD <= '0';
          rdata <= DATA;
        else
          DATA <= (others => 'Z');
        end if;
      end if;
    end if;
  end process;
  
  
end RTL;
