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
      wiz830mj_ADDR   : out   std_logic_vector(10-1 downto 0);
      wiz830mj_DATA   : inout std_logic_vector(8-1 downto 0);
      wiz830mj_nCS    : out   std_logic;
      wiz830mj_nRD    : out   std_logic;
      wiz830mj_nWR    : out   std_logic;
      wiz830mj_nINT   : in    std_logic;
      wiz830mj_nRESET : out   std_logic;
      wiz830mj_BRDY   : in    std_logic_vector(4-1 downto 0);
      field_led_output : out signed(32-1 downto 0);
      field_led_input : in signed(32-1 downto 0);
      field_led_input_we : in std_logic;
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
    wiz830mj_ADDR(9) => GPIO_1(17),
    wiz830mj_ADDR(8) => GPIO_1(16),
    wiz830mj_ADDR(7) => GPIO_1(19),
    wiz830mj_ADDR(6) => GPIO_1(18),
    wiz830mj_ADDR(5) => GPIO_1(21),
    wiz830mj_ADDR(4) => GPIO_1(20),
    wiz830mj_ADDR(3) => GPIO_1(23),
    wiz830mj_ADDR(2) => GPIO_1(22),
    wiz830mj_ADDR(1) => GPIO_1(25),
    wiz830mj_ADDR(0) => GPIO_1(24),
    -- wiz830mj_DATA
    wiz830mj_DATA(7) => GPIO_1(8),
    wiz830mj_DATA(6) => GPIO_1(9),
    wiz830mj_DATA(5) => GPIO_1(10),
    wiz830mj_DATA(4) => GPIO_1(11),
    wiz830mj_DATA(3) => GPIO_1(12),
    wiz830mj_DATA(2) => GPIO_1(13),
    wiz830mj_DATA(1) => GPIO_1(14),
    wiz830mj_DATA(0) => GPIO_1(15),
    wiz830mj_nCS    => GPIO_1(0),
    wiz830mj_nRD    => GPIO_1(1),
    wiz830mj_nWR    => GPIO_1(3),
    wiz830mj_nINT   => GPIO_1(5),
    wiz830mj_nRESET => GPIO_1(7),
    -- wiz830mj_BRDY
    wiz830mj_BRDY(0) => GPIO_1(4),
    wiz830mj_BRDY(1) => GPIO_1(2),
    wiz830mj_BRDY(2) => GPIO_1_IN(1),
    wiz830mj_BRDY(3) => GPIO_1_IN(0),
    field_led_output => led_out,
    field_led_input => (others => '0'),
    field_led_input_we => '0',
    test_req => nReset,
    test_busy => open,
    blink_led_req => '1',
    blink_led_busy => open
    );

  LED <= std_logic_vector(led_out(7 downto 0));
  
end RTL;
