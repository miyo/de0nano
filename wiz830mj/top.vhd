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

  component WIZ830MJ_Test
    port (
      clk             : in    std_logic;
      reset           : in    std_logic;
      class_wiz830mj_0000_ADDR_exp   : out   std_logic_vector(10-1 downto 0);
      class_wiz830mj_0000_DATA_exp   : inout std_logic_vector(8-1 downto 0);
      class_wiz830mj_0000_nCS_exp    : out   std_logic;
      class_wiz830mj_0000_nRD_exp    : out   std_logic;
      class_wiz830mj_0000_nWR_exp    : out   std_logic;
      class_wiz830mj_0000_nINT_exp   : in    std_logic;
      class_wiz830mj_0000_nRESET_exp : out   std_logic;
      class_wiz830mj_0000_BRDY_exp   : in    std_logic_vector(4-1 downto 0);
      led_out : out signed(32-1 downto 0);
      led_in : in signed(32-1 downto 0);
      led_we : in std_logic;
      test_req : in std_logic;
      test_busy : out std_logic;
      blink_led_req : in std_logic;
      blink_led_busy : out std_logic
      );
  end component WIZ830MJ_Test;

  signal reset_counter : unsigned(7 downto 0) := (others => '0');
  signal nReset        : std_logic            := '0';

  signal test_req  : std_logic := '0';
  signal test_busy : std_logic := '0';

  signal led_out : signed(31 downto 0);

begin

  process(CLOCK_50)
  begin
    if CLOCK_50'event and CLOCK_50 = '1' then
      if reset_counter < 100 then
        reset_counter <= reset_counter + 1;
        nReset <= '0';
      else
        nReset <= '1';
      end if;
    end if;
  end process;
  
  U: WIZ830MJ_Test port map(
    clk             => CLOCK_50,
    reset           => not nReset,
    -- wiz830mj_ADDR
    class_wiz830mj_0000_ADDR_exp(9) => GPIO_1(17),
    class_wiz830mj_0000_ADDR_exp(8) => GPIO_1(16),
    class_wiz830mj_0000_ADDR_exp(7) => GPIO_1(19),
    class_wiz830mj_0000_ADDR_exp(6) => GPIO_1(18),
    class_wiz830mj_0000_ADDR_exp(5) => GPIO_1(21),
    class_wiz830mj_0000_ADDR_exp(4) => GPIO_1(20),
    class_wiz830mj_0000_ADDR_exp(3) => GPIO_1(23),
    class_wiz830mj_0000_ADDR_exp(2) => GPIO_1(22),
    class_wiz830mj_0000_ADDR_exp(1) => GPIO_1(25),
    class_wiz830mj_0000_ADDR_exp(0) => GPIO_1(24),
    -- wiz830mj_DATA
    class_wiz830mj_0000_DATA_exp(7) => GPIO_1(8),
    class_wiz830mj_0000_DATA_exp(6) => GPIO_1(9),
    class_wiz830mj_0000_DATA_exp(5) => GPIO_1(10),
    class_wiz830mj_0000_DATA_exp(4) => GPIO_1(11),
    class_wiz830mj_0000_DATA_exp(3) => GPIO_1(12),
    class_wiz830mj_0000_DATA_exp(2) => GPIO_1(13),
    class_wiz830mj_0000_DATA_exp(1) => GPIO_1(14),
    class_wiz830mj_0000_DATA_exp(0) => GPIO_1(15),
    class_wiz830mj_0000_nCS_exp    => GPIO_1(0),
    class_wiz830mj_0000_nRD_exp    => GPIO_1(1),
    class_wiz830mj_0000_nWR_exp    => GPIO_1(3),
    class_wiz830mj_0000_nINT_exp   => GPIO_1(5),
    class_wiz830mj_0000_nRESET_exp => GPIO_1(7),
    -- wiz830mj_BRDY
    class_wiz830mj_0000_BRDY_exp(0) => GPIO_1(4),
    class_wiz830mj_0000_BRDY_exp(1) => GPIO_1(2),
    class_wiz830mj_0000_BRDY_exp(2) => GPIO_1_IN(1),
    class_wiz830mj_0000_BRDY_exp(3) => GPIO_1_IN(0),
    led_out => led_out,
    led_in => (others => '0'),
    led_we => '0',
    test_req => nReset,
    test_busy => open,
    blink_led_req => '1',
    blink_led_busy => open
    );

  LED <= std_logic_vector(led_out(7 downto 0));
  
end RTL;
