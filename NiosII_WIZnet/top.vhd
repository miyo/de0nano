library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top is

  port(
    CLOCK_50 : in std_logic;
    KEY : in std_logic_vector(1 downto 0);
    
    GPIO_1_IN : in std_logic_vector(1 downto 0);
    GPIO_1 : inout std_logic_vector(33 downto 0);

    DRAM_ADDR  : out   std_logic_vector(12 downto 0);
    DRAM_BA    : out   std_logic_vector(1 downto 0);
    DRAM_CKE   : out   std_logic;
    DRAM_CLK   : out   std_logic;
    DRAM_CS_N  : out   std_logic;
    DRAM_DQ    : inout std_logic_vector(15 downto 0);
    DRAM_DQM   : out   std_logic_vector(1 downto 0);
    DRAM_CAS_N : out   std_logic;
    DRAM_RAS_N : out   std_logic;
    DRAM_WE_N  : out   std_logic;

    LED : out std_logic_vector(7 downto 0)
    );
  
end top;

architecture RTL of top is

  component wiz830mj_iface
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
  end component wiz830mj_iface;

  
    component system is
        port (
            clk_clk                                          : in    std_logic                     := 'X';             -- clk
            reset_reset_n                                    : in    std_logic                     := 'X';             -- reset_n
            pio_0_external_connection_export                 : out   std_logic_vector(7 downto 0);                     -- export
            new_sdram_controller_0_wire_addr                 : out   std_logic_vector(12 downto 0);                    -- addr
            new_sdram_controller_0_wire_ba                   : out   std_logic_vector(1 downto 0);                     -- ba
            new_sdram_controller_0_wire_cas_n                : out   std_logic;                                        -- cas_n
            new_sdram_controller_0_wire_cke                  : out   std_logic;                                        -- cke
            new_sdram_controller_0_wire_cs_n                 : out   std_logic;                                        -- cs_n
            new_sdram_controller_0_wire_dq                   : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
            new_sdram_controller_0_wire_dqm                  : out   std_logic_vector(1 downto 0);                     -- dqm
            new_sdram_controller_0_wire_ras_n                : out   std_logic;                                        -- ras_n
            new_sdram_controller_0_wire_we_n                 : out   std_logic;                                        -- we_n
            generic_tristate_controller_0_tcm_write_out      : out   std_logic;                                        -- write_out
            generic_tristate_controller_0_tcm_read_out       : out   std_logic;                                        -- read_out
            generic_tristate_controller_0_tcm_chipselect_out : out   std_logic;                                        -- chipselect_out
            generic_tristate_controller_0_tcm_request        : out   std_logic;                                        -- request
            generic_tristate_controller_0_tcm_grant          : in    std_logic                     := 'X';             -- grant
            generic_tristate_controller_0_tcm_address_out    : out   std_logic_vector(9 downto 0);                     -- address_out
            generic_tristate_controller_0_tcm_data_out       : out   std_logic_vector(7 downto 0);                     -- data_out
            generic_tristate_controller_0_tcm_data_outen     : out   std_logic;                                        -- data_outen
            generic_tristate_controller_0_tcm_data_in        : in    std_logic_vector(7 downto 0)  := (others => 'X')  -- data_in
        );
    end component system;

  signal reset_counter : unsigned(7 downto 0) := (others => '0');
  signal nReset        : std_logic            := '0';

  signal test_req  : std_logic := '0';
  signal test_busy : std_logic := '0';

  signal wiznet_write, wiznet_read : std_logic;
  signal wiznet_cs : std_logic;
  signal wiznet_addr : std_logic_vector(31 downto 0);
  signal wiznet_rdata, wiznet_wdata : std_logic_vector(7 downto 0);
  signal wiznet_outen : std_logic;

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
  
  U_IFACE: wiz830mj_iface port map(
    clk             => CLOCK_50,
    reset           => not nReset,
    -- wiz830mj_ADDR
    ADDR(9) => GPIO_1(17),
    ADDR(8) => GPIO_1(16),
    ADDR(7) => GPIO_1(19),
    ADDR(6) => GPIO_1(18),
    ADDR(5) => GPIO_1(21),
    ADDR(4) => GPIO_1(20),
    ADDR(3) => GPIO_1(23),
    ADDR(2) => GPIO_1(22),
    ADDR(1) => GPIO_1(25),
    ADDR(0) => GPIO_1(24),
    -- wiz830mj_DATA
    DATA(7) => GPIO_1(8),
    DATA(6) => GPIO_1(9),
    DATA(5) => GPIO_1(10),
    DATA(4) => GPIO_1(11),
    DATA(3) => GPIO_1(12),
    DATA(2) => GPIO_1(13),
    DATA(1) => GPIO_1(14),
    DATA(0) => GPIO_1(15),
    nCS    => GPIO_1(0),
    nRD    => GPIO_1(1),
    nWR    => GPIO_1(3),
    nINT   => GPIO_1(5),
    nRESET => GPIO_1(7),
    -- wiz830mj_BRDY
    BRDY(0) => GPIO_1(4),
    BRDY(1) => GPIO_1(2),
    BRDY(2) => GPIO_1_IN(1),
    BRDY(3) => GPIO_1_IN(0),

    address      => wiznet_addr,
    wdata        => wiznet_wdata,
    rdata        => wiznet_rdata,
    cs           => wiznet_cs,
    oe           => wiznet_read,
    we           => wiznet_write,
    interrupt    => open,
    module_reset => not nReset,
    bready0      => open,
    bready1      => open,
    bready2      => open,
    bready3      => open
    );

    u0 : component system
        port map (
            clk_clk => CLOCK_50,
            reset_reset_n => nReset,
            pio_0_external_connection_export => LED,
            new_sdram_controller_0_wire_addr => DRAM_ADDR,
            new_sdram_controller_0_wire_ba   => DRAM_BA,
            new_sdram_controller_0_wire_cas_n=> DRAM_CAS_N,
            new_sdram_controller_0_wire_cke  => DRAM_CKE,
            new_sdram_controller_0_wire_cs_n => DRAM_CS_N,
            new_sdram_controller_0_wire_dq   => DRAM_DQ,
            new_sdram_controller_0_wire_dqm  => DRAM_DQM,
            new_sdram_controller_0_wire_ras_n=> DRAM_RAS_N,
            new_sdram_controller_0_wire_we_n => DRAM_WE_N,
            generic_tristate_controller_0_tcm_write_out => wiznet_write,
            generic_tristate_controller_0_tcm_read_out  => wiznet_read,
            generic_tristate_controller_0_tcm_chipselect_out => wiznet_cs,
            generic_tristate_controller_0_tcm_request        => open,
            generic_tristate_controller_0_tcm_grant          => '1',
            generic_tristate_controller_0_tcm_address_out    => wiznet_addr(9 downto 0),
            generic_tristate_controller_0_tcm_data_out       => wiznet_wdata,
            generic_tristate_controller_0_tcm_data_outen     => wiznet_outen,
            generic_tristate_controller_0_tcm_data_in        => wiznet_rdata
        );
  wiznet_addr(31 downto 10) <= (others => '0');

  DRAM_CLK <= CLOCK_50;
  
end RTL;
