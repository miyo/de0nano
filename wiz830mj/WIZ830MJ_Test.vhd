library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity WIZ830MJ_Test is
  port (
    clk : in std_logic;
    reset : in std_logic;
    wiz830mj_ADDR : out std_logic_vector(10-1 downto 0);
    wiz830mj_DATA : inout std_logic_vector(8-1 downto 0);
    wiz830mj_nCS : out std_logic;
    wiz830mj_nRD : out std_logic;
    wiz830mj_nWR : out std_logic;
    wiz830mj_nINT : in std_logic;
    wiz830mj_nRESET : out std_logic;
    wiz830mj_BRDY : in std_logic_vector(4-1 downto 0);
    field_led_output : out signed(32-1 downto 0);
    field_led_input : in signed(32-1 downto 0);
    field_led_input_we : in std_logic;
    test_req : in std_logic;
    test_busy : out std_logic;
    blink_led_req : in std_logic;
    blink_led_busy : out std_logic
  );
end WIZ830MJ_Test;

architecture RTL of WIZ830MJ_Test is

  signal tmp_0001 : signed(32-1 downto 0);
  signal tmp_0002 : signed(32-1 downto 0);
  signal tmp_0003 : signed(32-1 downto 0);
  signal tmp_0004 : signed(32-1 downto 0);
  signal tmp_0005 : signed(32-1 downto 0);
  signal tmp_0006 : signed(32-1 downto 0);
  signal tmp_0007 : signed(32-1 downto 0);
  signal tmp_0008 : signed(32-1 downto 0);
  signal tmp_0009 : signed(32-1 downto 0);
  signal tmp_0010 : signed(32-1 downto 0);
  signal tmp_0011 : signed(32-1 downto 0);
  signal tmp_0012 : signed(32-1 downto 0);
  signal tmp_0013 : signed(32-1 downto 0);
  signal tmp_0014 : signed(32-1 downto 0);
  signal tmp_0015 : signed(32-1 downto 0);
  signal tmp_0016 : signed(32-1 downto 0);
  signal tmp_0017 : signed(32-1 downto 0);
  signal tmp_0018 : signed(32-1 downto 0);
  signal tmp_0019 : signed(32-1 downto 0);
  signal tmp_0020 : signed(32-1 downto 0);
  signal tmp_0021 : signed(32-1 downto 0);
  signal tmp_0022 : signed(32-1 downto 0);
  signal tmp_0023 : signed(32-1 downto 0);
  signal tmp_0024 : signed(32-1 downto 0);
  signal tmp_0025 : signed(32-1 downto 0);
  signal tmp_0026 : signed(32-1 downto 0);
  signal tmp_0027 : signed(32-1 downto 0);
  signal tmp_0028 : signed(32-1 downto 0);
  signal tmp_0029 : signed(32-1 downto 0);
  signal tmp_0030 : signed(32-1 downto 0);
  signal tmp_0031 : signed(32-1 downto 0);
  signal tmp_0032 : signed(32-1 downto 0);
  signal tmp_0033 : signed(32-1 downto 0);
  signal tmp_0034 : signed(32-1 downto 0);
  signal tmp_0035 : signed(32-1 downto 0);
  signal tmp_0036 : signed(32-1 downto 0);
  signal tmp_0037 : signed(32-1 downto 0);
  signal tmp_0038 : signed(32-1 downto 0);
  signal tmp_0039 : signed(32-1 downto 0);
  signal tmp_0040 : signed(32-1 downto 0);
  signal tmp_0041 : signed(32-1 downto 0);
  signal tmp_0042 : signed(32-1 downto 0);
  signal tmp_0043 : signed(32-1 downto 0);
  signal tmp_0044 : signed(32-1 downto 0);
  signal tmp_0045 : signed(32-1 downto 0);
  signal tmp_0046 : signed(32-1 downto 0);
  signal tmp_0047 : signed(32-1 downto 0);
  signal tmp_0048 : signed(32-1 downto 0);
  signal tmp_0049 : signed(32-1 downto 0);
  signal tmp_0050 : signed(32-1 downto 0);
  signal tmp_0051 : signed(32-1 downto 0);
  signal tmp_0052 : signed(32-1 downto 0);
  signal tmp_0053 : signed(8-1 downto 0);
  signal tmp_0054 : signed(32-1 downto 0);
  signal tmp_0055 : signed(8-1 downto 0);
  signal tmp_0056 : signed(32-1 downto 0);
  signal tmp_0057 : signed(8-1 downto 0);
  signal tmp_0058 : signed(32-1 downto 0);
  signal tmp_0059 : signed(8-1 downto 0);
  signal tmp_0060 : signed(32-1 downto 0);
  signal tmp_0061 : signed(8-1 downto 0);
  signal tmp_0062 : signed(32-1 downto 0);
  signal tmp_0063 : signed(8-1 downto 0);
  signal tmp_0064 : signed(32-1 downto 0);
  signal tmp_0065 : signed(8-1 downto 0);
  signal tmp_0066 : signed(32-1 downto 0);
  signal tmp_0067 : signed(8-1 downto 0);
  signal tmp_0068 : signed(32-1 downto 0);
  signal tmp_0069 : signed(8-1 downto 0);
  signal tmp_0070 : signed(32-1 downto 0);
  signal tmp_0071 : signed(8-1 downto 0);
  signal tmp_0072 : signed(32-1 downto 0);
  signal tmp_0073 : signed(8-1 downto 0);
  signal tmp_0074 : signed(32-1 downto 0);
  signal tmp_0075 : signed(8-1 downto 0);
  signal tmp_0076 : signed(32-1 downto 0);
  signal tmp_0077 : signed(8-1 downto 0);
  signal tmp_0078 : signed(32-1 downto 0);
  signal tmp_0079 : signed(8-1 downto 0);
  signal tmp_0080 : signed(32-1 downto 0);
  signal tmp_0081 : signed(8-1 downto 0);
  signal tmp_0082 : signed(32-1 downto 0);
  signal tmp_0083 : signed(8-1 downto 0);
  signal tmp_0084 : signed(32-1 downto 0);
  signal tmp_0085 : signed(8-1 downto 0);
  signal tmp_0086 : signed(32-1 downto 0);
  signal tmp_0087 : signed(8-1 downto 0);
  signal tmp_0088 : signed(32-1 downto 0);
  signal tmp_0089 : signed(8-1 downto 0);
  signal tmp_0090 : signed(32-1 downto 0);
  signal tmp_0091 : signed(8-1 downto 0);
  signal tmp_0092 : signed(32-1 downto 0);
  signal tmp_0093 : signed(8-1 downto 0);
  signal tmp_0094 : signed(32-1 downto 0);
  signal tmp_0095 : signed(8-1 downto 0);
  signal tmp_0096 : signed(32-1 downto 0);
  signal tmp_0097 : signed(8-1 downto 0);
  signal tmp_0098 : signed(32-1 downto 0);
  signal tmp_0099 : signed(8-1 downto 0);
  signal tmp_0100 : signed(32-1 downto 0);
  signal tmp_0101 : signed(8-1 downto 0);
  signal tmp_0102 : signed(32-1 downto 0);
  signal tmp_0103 : signed(8-1 downto 0);
  signal tmp_0104 : signed(32-1 downto 0);
  signal tmp_0105 : signed(8-1 downto 0);
  signal tmp_0106 : signed(32-1 downto 0);
  signal tmp_0107 : signed(8-1 downto 0);
  signal tmp_0108 : signed(32-1 downto 0);
  signal tmp_0109 : signed(8-1 downto 0);
  signal tmp_0110 : signed(32-1 downto 0);
  signal tmp_0111 : signed(8-1 downto 0);
  signal tmp_0112 : signed(32-1 downto 0);
  signal tmp_0113 : signed(8-1 downto 0);
  signal tmp_0114 : signed(32-1 downto 0);
  signal tmp_0115 : signed(8-1 downto 0);
  signal tmp_0116 : signed(32-1 downto 0);
  signal tmp_0117 : signed(8-1 downto 0);
  signal tmp_0118 : signed(32-1 downto 0);
  signal tmp_0119 : signed(8-1 downto 0);
  signal tmp_0120 : signed(32-1 downto 0);
  signal tmp_0121 : signed(8-1 downto 0);
  component dualportram
    generic (
      WIDTH : integer := 8;
      DEPTH : integer := 10;
      WORDS : integer := 1024
    );
    port (
      clk : in std_logic;
      reset : in std_logic;
      length : out signed(32-1 downto 0);
      address : in signed(32-1 downto 0);
      din : in signed(8-1 downto 0);
      dout : out signed(8-1 downto 0);
      we : in std_logic;
      oe : in std_logic;
      address_b : in signed(32-1 downto 0);
      din_b : in signed(8-1 downto 0);
      dout_b : out signed(8-1 downto 0);
      we_b : in std_logic;
      oe_b : in std_logic
    );
  end component dualportram;
  component wiz830mj_iface
    port (
      clk : in std_logic;
      reset : in std_logic;
      address : in std_logic_vector(32-1 downto 0);
      wdata : in std_logic_vector(8-1 downto 0);
      rdata : out std_logic_vector(8-1 downto 0);
      cs : in std_logic;
      oe : in std_logic;
      we : in std_logic;
      interrupt : out std_logic;
      module_reset : in std_logic;
      bready0 : out std_logic;
      bready1 : out std_logic;
      bready2 : out std_logic;
      bready3 : out std_logic;
      ADDR : out std_logic_vector(10-1 downto 0);
      DATA : inout std_logic_vector(8-1 downto 0);
      nCS : out std_logic;
      nRD : out std_logic;
      nWR : out std_logic;
      nINT : in std_logic;
      nRESET : out std_logic;
      BRDY : in std_logic_vector(4-1 downto 0)
    );
  end component wiz830mj_iface;

  signal clk_sig : std_logic;
  signal reset_sig : std_logic;
  signal field_led_output_sig : signed(32-1 downto 0);
  signal field_led_input_sig : signed(32-1 downto 0);
  signal field_led_input_we_sig : std_logic;
  signal test_req_sig : std_logic;
  signal test_busy_sig : std_logic;
  signal blink_led_req_sig : std_logic;
  signal blink_led_busy_sig : std_logic;

  signal Sn_CR1 : signed(32-1 downto 0) := X"00000203";
  signal Sn_CR_PCN : signed(8-1 downto 0) := tmp_0088(32 - 24 - 1 downto 0);
  signal Sn_CR0 : signed(32-1 downto 0) := X"00000202";
  signal Sn_CR_PCJ : signed(8-1 downto 0) := tmp_0090(32 - 24 - 1 downto 0);
  signal Sn_RX_FIFOR1 : signed(32-1 downto 0) := X"00000231";
  signal Sn_RX_FIFOR0 : signed(32-1 downto 0) := X"00000230";
  signal Sn_SOCK_CLOSE_WAIT : signed(8-1 downto 0) := tmp_0100(32 - 24 - 1 downto 0);
  signal Sn_SOCK_ARP : signed(8-1 downto 0) := tmp_0120(32 - 24 - 1 downto 0);
  signal Sn_DPORTR1 : signed(32-1 downto 0) := X"00000213";
  signal Sn_DPORTR0 : signed(32-1 downto 0) := X"00000212";
  signal Sn_MR_UDP : signed(8-1 downto 0) := tmp_0056(32 - 24 - 1 downto 0);
  signal Sn_SOCK_SYSRECV : signed(8-1 downto 0) := tmp_0112(32 - 24 - 1 downto 0);
  signal Sn_SOCK_INIT : signed(8-1 downto 0) := tmp_0094(32 - 24 - 1 downto 0);
  signal Sn_CR_LISTEN : signed(8-1 downto 0) := tmp_0066(32 - 24 - 1 downto 0);
  signal Sn_TTLR1 : signed(32-1 downto 0) := X"0000021f";
  signal Sn_TTLR0 : signed(32-1 downto 0) := X"0000021e";
  signal Sn_SOCK_FIN_WAIT : signed(8-1 downto 0) := tmp_0114(32 - 24 - 1 downto 0);
  signal Sn_TX_FSR3 : signed(32-1 downto 0) := X"00000227";
  signal Sn_MR_IPRAW : signed(8-1 downto 0) := tmp_0058(32 - 24 - 1 downto 0);
  signal Sn_TX_FSR2 : signed(32-1 downto 0) := X"00000226";
  signal Sn_TX_FSR1 : signed(32-1 downto 0) := X"00000225";
  signal Sn_DHAR5 : signed(32-1 downto 0) := X"00000211";
  signal Sn_DHAR4 : signed(32-1 downto 0) := X"00000210";
  signal Sn_TX_FSR0 : signed(32-1 downto 0) := X"00000224";
  signal Sn_DHAR3 : signed(32-1 downto 0) := X"0000020f";
  signal Sn_DHAR2 : signed(32-1 downto 0) := X"0000020e";
  signal Sn_TX_WRSR3 : signed(32-1 downto 0) := X"00000223";
  signal Sn_DHAR1 : signed(32-1 downto 0) := X"0000020d";
  signal Sn_TX_WRSR2 : signed(32-1 downto 0) := X"00000222";
  signal Sn_DHAR0 : signed(32-1 downto 0) := X"0000020c";
  signal Sn_TX_WRSR1 : signed(32-1 downto 0) := X"00000221";
  signal Sn_TX_WRSR0 : signed(32-1 downto 0) := X"00000220";
  signal Sn_MSSR1 : signed(32-1 downto 0) := X"00000219";
  signal Sn_MSSR0 : signed(32-1 downto 0) := X"00000218";
  signal Sn_IMR1 : signed(32-1 downto 0) := X"00000205";
  signal Sn_IMR0 : signed(32-1 downto 0) := X"00000204";
  signal Sn_CR_RECV : signed(8-1 downto 0) := tmp_0080(32 - 24 - 1 downto 0);
  signal Sn_MR_TCP : signed(8-1 downto 0) := tmp_0054(32 - 24 - 1 downto 0);
  signal Sn_SOCK_MACRAW : signed(8-1 downto 0) := tmp_0106(32 - 24 - 1 downto 0);
  signal Sn_SSR1 : signed(32-1 downto 0) := X"00000209";
  signal Sn_SSR0 : signed(32-1 downto 0) := X"00000208";
  signal Sn_SOCK_ESTABLISHED : signed(8-1 downto 0) := tmp_0098(32 - 24 - 1 downto 0);
  signal Sn_SOCK_IPRAW : signed(8-1 downto 0) := tmp_0104(32 - 24 - 1 downto 0);
  signal Sn_CR_PCON : signed(8-1 downto 0) := tmp_0082(32 - 24 - 1 downto 0);
  signal Sn_SOCK_SYSSENT : signed(8-1 downto 0) := tmp_0110(32 - 24 - 1 downto 0);
  signal Sn_SOCK_LISTEN : signed(8-1 downto 0) := tmp_0096(32 - 24 - 1 downto 0);
  signal Sn_SOCK_CLOSED : signed(8-1 downto 0) := tmp_0092(32 - 24 - 1 downto 0);
  signal Sn_PROTOR : signed(32-1 downto 0) := X"0000021b";
  signal Sn_SOCK_LAST_ACK : signed(8-1 downto 0) := tmp_0118(32 - 24 - 1 downto 0);
  signal Sn_CR_CONNECT : signed(8-1 downto 0) := tmp_0068(32 - 24 - 1 downto 0);
  signal Sn_MR_CLOSE : signed(8-1 downto 0) := tmp_0052(32 - 24 - 1 downto 0);
  signal Sn_SOCK_TIME_WAIT : signed(8-1 downto 0) := tmp_0116(32 - 24 - 1 downto 0);
  signal Sn_MR_PPPoE : signed(8-1 downto 0) := tmp_0062(32 - 24 - 1 downto 0);
  signal Sn_MR1 : signed(32-1 downto 0) := X"00000201";
  signal led : signed(32-1 downto 0) := (others => '0');
  signal Sn_FRAGR1 : signed(32-1 downto 0) := X"0000022d";
  signal Sn_MR0 : signed(32-1 downto 0) := X"00000200";
  signal Sn_FRAGR0 : signed(32-1 downto 0) := X"0000022c";
  signal buffer_clk : std_logic;
  signal buffer_reset : std_logic;
  signal buffer_length : signed(32-1 downto 0);
  signal buffer_address : signed(32-1 downto 0) := (others => '0');
  signal buffer_din : signed(8-1 downto 0) := (others => '0');
  signal buffer_dout : signed(8-1 downto 0);
  signal buffer_we : std_logic := '0';
  signal buffer_oe : std_logic := '0';
  signal buffer_address_b : signed(32-1 downto 0) := (others => '0');
  signal buffer_din_b : signed(8-1 downto 0) := (others => '0');
  signal buffer_dout_b : signed(8-1 downto 0);
  signal buffer_we_b : std_logic := '0';
  signal buffer_oe_b : std_logic := '0';
  signal Sn_CR_OPEN : signed(8-1 downto 0) := tmp_0064(32 - 24 - 1 downto 0);
  signal Sn_CR_SEND : signed(8-1 downto 0) := tmp_0074(32 - 24 - 1 downto 0);
  signal Sn_SOCK_UDP : signed(8-1 downto 0) := tmp_0102(32 - 24 - 1 downto 0);
  signal Sn_CR_PDISCON : signed(8-1 downto 0) := tmp_0084(32 - 24 - 1 downto 0);
  signal Sn_KPALVTR : signed(32-1 downto 0) := X"0000021a";
  signal Sn_IR1 : signed(32-1 downto 0) := X"00000207";
  signal Sn_IR0 : signed(32-1 downto 0) := X"00000206";
  signal Sn_CR_SEND_MAC : signed(8-1 downto 0) := tmp_0076(32 - 24 - 1 downto 0);
  signal Sn_MR_MACRAW : signed(8-1 downto 0) := tmp_0060(32 - 24 - 1 downto 0);
  signal Sn_PORTR1 : signed(32-1 downto 0) := X"0000020b";
  signal wiz830mj_clk : std_logic;
  signal wiz830mj_reset : std_logic;
  signal wiz830mj_address : std_logic_vector(32-1 downto 0) := (others => '0');
  signal wiz830mj_wdata : std_logic_vector(8-1 downto 0) := (others => '0');
  signal wiz830mj_rdata : std_logic_vector(8-1 downto 0);
  signal wiz830mj_cs : std_logic := '0';
  signal wiz830mj_oe : std_logic := '0';
  signal wiz830mj_we : std_logic := '0';
  signal wiz830mj_interrupt : std_logic;
  signal wiz830mj_module_reset : std_logic := '0';
  signal wiz830mj_bready0 : std_logic;
  signal wiz830mj_bready1 : std_logic;
  signal wiz830mj_bready2 : std_logic;
  signal wiz830mj_bready3 : std_logic;
  signal Sn_PORTR0 : signed(32-1 downto 0) := X"0000020a";
  signal Sn_SOCK_PPPoE : signed(8-1 downto 0) := tmp_0108(32 - 24 - 1 downto 0);
  signal Sn_RX_RSR3 : signed(32-1 downto 0) := X"0000022b";
  signal Sn_DIPR3 : signed(32-1 downto 0) := X"00000217";
  signal Sn_RX_RSR2 : signed(32-1 downto 0) := X"0000022a";
  signal Sn_DIPR2 : signed(32-1 downto 0) := X"00000216";
  signal Sn_RX_RSR1 : signed(32-1 downto 0) := X"00000229";
  signal Sn_DIPR1 : signed(32-1 downto 0) := X"00000215";
  signal Sn_RX_RSR0 : signed(32-1 downto 0) := X"00000228";
  signal Sn_DIPR0 : signed(32-1 downto 0) := X"00000214";
  signal Sn_CR_SEND_KEEP : signed(8-1 downto 0) := tmp_0078(32 - 24 - 1 downto 0);
  signal Sn_CR_CLOSE : signed(8-1 downto 0) := tmp_0072(32 - 24 - 1 downto 0);
  signal Sn_TX_FIFOR1 : signed(32-1 downto 0) := X"0000022f";
  signal Sn_TX_FIFOR0 : signed(32-1 downto 0) := X"0000022e";
  signal Sn_TOSR1 : signed(32-1 downto 0) := X"0000021d";
  signal Sn_CR_DISCON : signed(8-1 downto 0) := tmp_0070(32 - 24 - 1 downto 0);
  signal Sn_TOSR0 : signed(32-1 downto 0) := X"0000021c";
  signal Sn_CR_PCR : signed(8-1 downto 0) := tmp_0086(32 - 24 - 1 downto 0);
  signal wait_cycles_i_1 : signed(32-1 downto 0) := X"00000000";
  signal pull_recv_data_i_4 : signed(32-1 downto 0) := X"00000000";
  signal pull_recv_data_tmp_0001_2 : signed(8-1 downto 0) := (others => '0');
  signal pull_recv_data_tmp_0000_3 : signed(8-1 downto 0) := (others => '0');
  signal push_send_data_v_2 : signed(8-1 downto 0) := (others => '0');
  signal push_send_data_i_3 : signed(32-1 downto 0) := X"00000000";
  signal blink_led_i_0 : signed(32-1 downto 0) := X"00000000";
  type Type_methodId is (
    IDLE,
    method_wait_cycles,
    method_write_data,
    method_read_data,
    method_init,
    method_network_configuration,
    method_tcp_server_open,
    method_tcp_server_listen,
    method_wait_for_established,
    method_wait_for_recv,
    method_pull_recv_data,
    method_push_send_data,
    method_tcp_server,
    method_test,
    method_blink_led  
  );
  signal methodId : Type_methodId := IDLE;
  signal wait_cycles_n : signed(32-1 downto 0) := (others => '0');
  signal wait_cycles_req_local : std_logic := '0';
  signal tmp_0122 : std_logic;
  signal wait_cycles_busy_sig : std_logic;
  type Type_S_wait_cycles is (
    S_wait_cycles_IDLE,
    S_wait_cycles_S_wait_cycles_0001,
    S_wait_cycles_S_wait_cycles_0002,
    S_wait_cycles_S_wait_cycles_0003,
    S_wait_cycles_S_wait_cycles_0004  
  );
  signal S_wait_cycles : Type_S_wait_cycles := S_wait_cycles_IDLE;
  signal S_wait_cycles_delay : signed(32-1 downto 0) := (others => '0');
  signal tmp_0123 : std_logic;
  signal tmp_0124 : std_logic;
  signal tmp_0125 : std_logic;
  signal tmp_0126 : std_logic;
  signal tmp_0127 : std_logic;
  signal tmp_0128 : std_logic;
  signal tmp_0129 : signed(32-1 downto 0);
  signal tmp_0130 : signed(32-1 downto 0);
  signal write_data_addr : signed(32-1 downto 0) := (others => '0');
  signal write_data_data : signed(8-1 downto 0) := (others => '0');
  signal write_data_req_local : std_logic := '0';
  signal tmp_0131 : std_logic;
  signal write_data_busy_sig : std_logic;
  type Type_S_write_data is (
    S_write_data_IDLE,
    S_write_data_S_write_data_0001,
    S_write_data_S_write_data_0002,
    S_write_data_S_write_data_0003,
    S_write_data_S_write_data_0004,
    S_write_data_S_write_data_0005,
    S_write_data_S_write_data_0006,
    S_write_data_S_write_data_0007,
    S_write_data_S_write_data_0008  
  );
  signal S_write_data : Type_S_write_data := S_write_data_IDLE;
  signal S_write_data_delay : signed(32-1 downto 0) := (others => '0');
  signal tmp_0132 : std_logic;
  signal tmp_0133 : std_logic;
  signal tmp_0134 : std_logic;
  signal tmp_0135 : std_logic;
  signal tmp_0136 : signed(32-1 downto 0);
  signal wait_cycles_busy_sig_0137 : std_logic;
  signal tmp_0138 : std_logic;
  signal tmp_0139 : std_logic;
  signal tmp_0140 : std_logic;
  signal tmp_0141 : std_logic;
  signal tmp_0142 : std_logic;
  signal tmp_0143 : std_logic;
  signal read_data_addr : signed(32-1 downto 0) := (others => '0');
  signal read_data_return_sig : signed(8-1 downto 0) := (others => '0');
  signal read_data_req_local : std_logic := '0';
  signal tmp_0144 : std_logic;
  signal read_data_busy_sig : std_logic;
  signal read_data_v_1 : signed(8-1 downto 0) := (others => '0');
  type Type_S_read_data is (
    S_read_data_IDLE,
    S_read_data_S_read_data_0001,
    S_read_data_S_read_data_0002,
    S_read_data_S_read_data_0003,
    S_read_data_S_read_data_0004,
    S_read_data_S_read_data_0005,
    S_read_data_S_read_data_0006,
    S_read_data_S_read_data_0007,
    S_read_data_S_read_data_0008,
    S_read_data_S_read_data_0009  
  );
  signal S_read_data : Type_S_read_data := S_read_data_IDLE;
  signal S_read_data_delay : signed(32-1 downto 0) := (others => '0');
  signal tmp_0145 : std_logic;
  signal tmp_0146 : std_logic;
  signal tmp_0147 : std_logic;
  signal tmp_0148 : std_logic;
  signal tmp_0149 : signed(32-1 downto 0);
  signal wait_cycles_busy_sig_0150 : std_logic;
  signal tmp_0151 : std_logic;
  signal tmp_0152 : std_logic;
  signal tmp_0153 : std_logic;
  signal tmp_0154 : std_logic;
  signal tmp_0155 : std_logic;
  signal tmp_0156 : std_logic;
  signal init_req_local : std_logic := '0';
  signal tmp_0157 : std_logic;
  signal init_busy_sig : std_logic;
  type Type_S_init is (
    S_init_IDLE,
    S_init_S_init_0001,
    S_init_S_init_0002,
    S_init_S_init_0003,
    S_init_S_init_0004,
    S_init_S_init_0005,
    S_init_S_init_0006,
    S_init_S_init_0007,
    S_init_S_init_0008  
  );
  signal S_init : Type_S_init := S_init_IDLE;
  signal S_init_delay : signed(32-1 downto 0) := (others => '0');
  signal tmp_0158 : std_logic;
  signal tmp_0159 : std_logic;
  signal tmp_0160 : std_logic;
  signal tmp_0161 : std_logic;
  signal tmp_0162 : std_logic;
  signal tmp_0163 : std_logic;
  signal tmp_0164 : signed(32-1 downto 0);
  signal wait_cycles_busy_sig_0165 : std_logic;
  signal tmp_0166 : std_logic;
  signal tmp_0167 : std_logic;
  signal tmp_0168 : std_logic;
  signal tmp_0169 : std_logic;
  signal tmp_0170 : std_logic;
  signal tmp_0171 : signed(32-1 downto 0);
  signal wait_cycles_busy_sig_0172 : std_logic;
  signal tmp_0173 : std_logic;
  signal tmp_0174 : std_logic;
  signal tmp_0175 : std_logic;
  signal tmp_0176 : std_logic;
  signal network_configuration_req_local : std_logic := '0';
  signal tmp_0177 : std_logic;
  signal network_configuration_busy_sig : std_logic;
  type Type_S_network_configuration is (
    S_network_configuration_IDLE,
    S_network_configuration_S_network_configuration_0001,
    S_network_configuration_S_network_configuration_0002,
    S_network_configuration_S_network_configuration_0003,
    S_network_configuration_S_network_configuration_0004,
    S_network_configuration_S_network_configuration_0005,
    S_network_configuration_S_network_configuration_0006,
    S_network_configuration_S_network_configuration_0007,
    S_network_configuration_S_network_configuration_0008,
    S_network_configuration_S_network_configuration_0009,
    S_network_configuration_S_network_configuration_0010,
    S_network_configuration_S_network_configuration_0011,
    S_network_configuration_S_network_configuration_0012,
    S_network_configuration_S_network_configuration_0013,
    S_network_configuration_S_network_configuration_0014,
    S_network_configuration_S_network_configuration_0015,
    S_network_configuration_S_network_configuration_0016,
    S_network_configuration_S_network_configuration_0017,
    S_network_configuration_S_network_configuration_0018,
    S_network_configuration_S_network_configuration_0019  
  );
  signal S_network_configuration : Type_S_network_configuration := S_network_configuration_IDLE;
  signal S_network_configuration_delay : signed(32-1 downto 0) := (others => '0');
  signal tmp_0178 : std_logic;
  signal tmp_0179 : std_logic;
  signal tmp_0180 : signed(32-1 downto 0);
  signal tmp_0181 : signed(32-1 downto 0);
  signal tmp_0182 : signed(8-1 downto 0);
  signal write_data_busy_sig_0183 : std_logic;
  signal tmp_0184 : std_logic;
  signal tmp_0185 : std_logic;
  signal tmp_0186 : std_logic;
  signal tmp_0187 : std_logic;
  signal tmp_0188 : signed(32-1 downto 0);
  signal tmp_0189 : signed(32-1 downto 0);
  signal tmp_0190 : signed(8-1 downto 0);
  signal write_data_busy_sig_0191 : std_logic;
  signal tmp_0192 : std_logic;
  signal tmp_0193 : std_logic;
  signal tmp_0194 : std_logic;
  signal tmp_0195 : std_logic;
  signal tmp_0196 : signed(32-1 downto 0);
  signal tmp_0197 : signed(32-1 downto 0);
  signal tmp_0198 : signed(8-1 downto 0);
  signal write_data_busy_sig_0199 : std_logic;
  signal tmp_0200 : std_logic;
  signal tmp_0201 : std_logic;
  signal tmp_0202 : std_logic;
  signal tmp_0203 : std_logic;
  signal tmp_0204 : signed(32-1 downto 0);
  signal tmp_0205 : signed(32-1 downto 0);
  signal tmp_0206 : signed(8-1 downto 0);
  signal write_data_busy_sig_0207 : std_logic;
  signal tmp_0208 : std_logic;
  signal tmp_0209 : std_logic;
  signal tmp_0210 : std_logic;
  signal tmp_0211 : std_logic;
  signal tmp_0212 : signed(32-1 downto 0);
  signal tmp_0213 : signed(32-1 downto 0);
  signal tmp_0214 : signed(8-1 downto 0);
  signal write_data_busy_sig_0215 : std_logic;
  signal tmp_0216 : std_logic;
  signal tmp_0217 : std_logic;
  signal tmp_0218 : std_logic;
  signal tmp_0219 : std_logic;
  signal tmp_0220 : signed(32-1 downto 0);
  signal tmp_0221 : signed(32-1 downto 0);
  signal tmp_0222 : signed(8-1 downto 0);
  signal write_data_busy_sig_0223 : std_logic;
  signal tmp_0224 : std_logic;
  signal tmp_0225 : std_logic;
  signal tmp_0226 : std_logic;
  signal tmp_0227 : std_logic;
  signal tmp_0228 : signed(32-1 downto 0);
  signal tmp_0229 : signed(32-1 downto 0);
  signal tmp_0230 : signed(8-1 downto 0);
  signal write_data_busy_sig_0231 : std_logic;
  signal tmp_0232 : std_logic;
  signal tmp_0233 : std_logic;
  signal tmp_0234 : std_logic;
  signal tmp_0235 : std_logic;
  signal tmp_0236 : signed(32-1 downto 0);
  signal tmp_0237 : signed(32-1 downto 0);
  signal tmp_0238 : signed(8-1 downto 0);
  signal write_data_busy_sig_0239 : std_logic;
  signal tmp_0240 : std_logic;
  signal tmp_0241 : std_logic;
  signal tmp_0242 : std_logic;
  signal tmp_0243 : std_logic;
  signal tmp_0244 : signed(32-1 downto 0);
  signal tmp_0245 : signed(32-1 downto 0);
  signal tmp_0246 : signed(8-1 downto 0);
  signal write_data_busy_sig_0247 : std_logic;
  signal tmp_0248 : std_logic;
  signal tmp_0249 : std_logic;
  signal tmp_0250 : std_logic;
  signal tmp_0251 : std_logic;
  signal tmp_0252 : signed(32-1 downto 0);
  signal tmp_0253 : signed(32-1 downto 0);
  signal tmp_0254 : signed(8-1 downto 0);
  signal write_data_busy_sig_0255 : std_logic;
  signal tmp_0256 : std_logic;
  signal tmp_0257 : std_logic;
  signal tmp_0258 : std_logic;
  signal tmp_0259 : std_logic;
  signal tmp_0260 : signed(32-1 downto 0);
  signal tmp_0261 : signed(32-1 downto 0);
  signal tmp_0262 : signed(8-1 downto 0);
  signal write_data_busy_sig_0263 : std_logic;
  signal tmp_0264 : std_logic;
  signal tmp_0265 : std_logic;
  signal tmp_0266 : std_logic;
  signal tmp_0267 : std_logic;
  signal tmp_0268 : signed(32-1 downto 0);
  signal tmp_0269 : signed(32-1 downto 0);
  signal tmp_0270 : signed(8-1 downto 0);
  signal write_data_busy_sig_0271 : std_logic;
  signal tmp_0272 : std_logic;
  signal tmp_0273 : std_logic;
  signal tmp_0274 : std_logic;
  signal tmp_0275 : std_logic;
  signal tmp_0276 : signed(32-1 downto 0);
  signal tmp_0277 : signed(32-1 downto 0);
  signal tmp_0278 : signed(8-1 downto 0);
  signal write_data_busy_sig_0279 : std_logic;
  signal tmp_0280 : std_logic;
  signal tmp_0281 : std_logic;
  signal tmp_0282 : std_logic;
  signal tmp_0283 : std_logic;
  signal tmp_0284 : signed(32-1 downto 0);
  signal tmp_0285 : signed(32-1 downto 0);
  signal tmp_0286 : signed(8-1 downto 0);
  signal write_data_busy_sig_0287 : std_logic;
  signal tmp_0288 : std_logic;
  signal tmp_0289 : std_logic;
  signal tmp_0290 : std_logic;
  signal tmp_0291 : std_logic;
  signal tmp_0292 : signed(32-1 downto 0);
  signal tmp_0293 : signed(32-1 downto 0);
  signal tmp_0294 : signed(8-1 downto 0);
  signal write_data_busy_sig_0295 : std_logic;
  signal tmp_0296 : std_logic;
  signal tmp_0297 : std_logic;
  signal tmp_0298 : std_logic;
  signal tmp_0299 : std_logic;
  signal tmp_0300 : signed(32-1 downto 0);
  signal tmp_0301 : signed(32-1 downto 0);
  signal tmp_0302 : signed(8-1 downto 0);
  signal write_data_busy_sig_0303 : std_logic;
  signal tmp_0304 : std_logic;
  signal tmp_0305 : std_logic;
  signal tmp_0306 : std_logic;
  signal tmp_0307 : std_logic;
  signal tmp_0308 : signed(32-1 downto 0);
  signal tmp_0309 : signed(32-1 downto 0);
  signal tmp_0310 : signed(8-1 downto 0);
  signal write_data_busy_sig_0311 : std_logic;
  signal tmp_0312 : std_logic;
  signal tmp_0313 : std_logic;
  signal tmp_0314 : std_logic;
  signal tmp_0315 : std_logic;
  signal tmp_0316 : signed(32-1 downto 0);
  signal tmp_0317 : signed(32-1 downto 0);
  signal tmp_0318 : signed(8-1 downto 0);
  signal write_data_busy_sig_0319 : std_logic;
  signal tmp_0320 : std_logic;
  signal tmp_0321 : std_logic;
  signal tmp_0322 : std_logic;
  signal tmp_0323 : std_logic;
  signal tcp_server_open_port : signed(32-1 downto 0) := (others => '0');
  signal tcp_server_open_return_sig : signed(8-1 downto 0) := (others => '0');
  signal tcp_server_open_req_local : std_logic := '0';
  signal tmp_0324 : std_logic;
  signal tcp_server_open_busy_sig : std_logic;
  type Type_S_tcp_server_open is (
    S_tcp_server_open_IDLE,
    S_tcp_server_open_S_tcp_server_open_0001,
    S_tcp_server_open_S_tcp_server_open_0002,
    S_tcp_server_open_S_tcp_server_open_0003,
    S_tcp_server_open_S_tcp_server_open_0004,
    S_tcp_server_open_S_tcp_server_open_0005,
    S_tcp_server_open_S_tcp_server_open_0006  
  );
  signal S_tcp_server_open : Type_S_tcp_server_open := S_tcp_server_open_IDLE;
  signal S_tcp_server_open_delay : signed(32-1 downto 0) := (others => '0');
  signal tmp_0325 : std_logic;
  signal tmp_0326 : std_logic;
  signal tmp_0327 : signed(32-1 downto 0);
  signal tmp_0328 : signed(32-1 downto 0);
  signal tmp_0329 : signed(32-1 downto 0);
  signal write_data_busy_sig_0330 : std_logic;
  signal tmp_0331 : std_logic;
  signal tmp_0332 : std_logic;
  signal tmp_0333 : std_logic;
  signal tmp_0334 : std_logic;
  signal tmp_0335 : signed(32-1 downto 0);
  signal tmp_0336 : signed(32-1 downto 0);
  signal tmp_0337 : signed(32-1 downto 0);
  signal tmp_0338 : signed(32-1 downto 0);
  signal tmp_0339 : signed(8-1 downto 0);
  signal write_data_busy_sig_0340 : std_logic;
  signal tmp_0341 : std_logic;
  signal tmp_0342 : std_logic;
  signal tmp_0343 : std_logic;
  signal tmp_0344 : std_logic;
  signal tmp_0345 : signed(32-1 downto 0);
  signal tmp_0346 : signed(32-1 downto 0);
  signal tmp_0347 : signed(32-1 downto 0);
  signal tmp_0348 : signed(32-1 downto 0);
  signal tmp_0349 : signed(8-1 downto 0);
  signal write_data_busy_sig_0350 : std_logic;
  signal tmp_0351 : std_logic;
  signal tmp_0352 : std_logic;
  signal tmp_0353 : std_logic;
  signal tmp_0354 : std_logic;
  signal tmp_0355 : signed(32-1 downto 0);
  signal tmp_0356 : signed(32-1 downto 0);
  signal tmp_0357 : signed(32-1 downto 0);
  signal write_data_busy_sig_0358 : std_logic;
  signal tmp_0359 : std_logic;
  signal tmp_0360 : std_logic;
  signal tmp_0361 : std_logic;
  signal tmp_0362 : std_logic;
  signal tmp_0363 : signed(32-1 downto 0);
  signal tmp_0364 : signed(32-1 downto 0);
  signal tmp_0365 : signed(32-1 downto 0);
  signal read_data_busy_sig_0366 : std_logic;
  signal tmp_0367 : std_logic;
  signal tmp_0368 : std_logic;
  signal tmp_0369 : std_logic;
  signal tmp_0370 : std_logic;
  signal tcp_server_listen_port : signed(32-1 downto 0) := (others => '0');
  signal tcp_server_listen_return_sig : signed(8-1 downto 0) := (others => '0');
  signal tcp_server_listen_req_local : std_logic := '0';
  signal tmp_0371 : std_logic;
  signal tcp_server_listen_busy_sig : std_logic;
  type Type_S_tcp_server_listen is (
    S_tcp_server_listen_IDLE,
    S_tcp_server_listen_S_tcp_server_listen_0001,
    S_tcp_server_listen_S_tcp_server_listen_0002,
    S_tcp_server_listen_S_tcp_server_listen_0003  
  );
  signal S_tcp_server_listen : Type_S_tcp_server_listen := S_tcp_server_listen_IDLE;
  signal S_tcp_server_listen_delay : signed(32-1 downto 0) := (others => '0');
  signal tmp_0372 : std_logic;
  signal tmp_0373 : std_logic;
  signal tmp_0374 : signed(32-1 downto 0);
  signal tmp_0375 : signed(32-1 downto 0);
  signal tmp_0376 : signed(32-1 downto 0);
  signal write_data_busy_sig_0377 : std_logic;
  signal tmp_0378 : std_logic;
  signal tmp_0379 : std_logic;
  signal tmp_0380 : std_logic;
  signal tmp_0381 : std_logic;
  signal tmp_0382 : signed(32-1 downto 0);
  signal tmp_0383 : signed(32-1 downto 0);
  signal tmp_0384 : signed(32-1 downto 0);
  signal read_data_busy_sig_0385 : std_logic;
  signal tmp_0386 : std_logic;
  signal tmp_0387 : std_logic;
  signal tmp_0388 : std_logic;
  signal tmp_0389 : std_logic;
  signal wait_for_established_port : signed(32-1 downto 0) := (others => '0');
  signal wait_for_established_req_local : std_logic := '0';
  signal tmp_0390 : std_logic;
  signal wait_for_established_busy_sig : std_logic;
  signal wait_for_established_v_1 : signed(8-1 downto 0) := (others => '0');
  type Type_S_wait_for_established is (
    S_wait_for_established_IDLE,
    S_wait_for_established_S_wait_for_established_0001,
    S_wait_for_established_S_wait_for_established_0002,
    S_wait_for_established_S_wait_for_established_0003,
    S_wait_for_established_S_wait_for_established_0004,
    S_wait_for_established_S_wait_for_established_0005  
  );
  signal S_wait_for_established : Type_S_wait_for_established := S_wait_for_established_IDLE;
  signal S_wait_for_established_delay : signed(32-1 downto 0) := (others => '0');
  signal tmp_0391 : std_logic;
  signal tmp_0392 : std_logic;
  signal tmp_0393 : std_logic;
  signal tmp_0394 : std_logic;
  signal tmp_0395 : std_logic;
  signal tmp_0396 : std_logic;
  signal tmp_0397 : std_logic;
  signal tmp_0398 : std_logic;
  signal tmp_0399 : std_logic;
  signal tmp_0400 : std_logic;
  signal tmp_0401 : signed(32-1 downto 0);
  signal tmp_0402 : signed(32-1 downto 0);
  signal tmp_0403 : signed(32-1 downto 0);
  signal read_data_busy_sig_0404 : std_logic;
  signal tmp_0405 : std_logic;
  signal tmp_0406 : std_logic;
  signal tmp_0407 : std_logic;
  signal tmp_0408 : std_logic;
  signal wait_for_recv_port : signed(32-1 downto 0) := (others => '0');
  signal wait_for_recv_return_sig : signed(32-1 downto 0) := (others => '0');
  signal wait_for_recv_req_local : std_logic := '0';
  signal tmp_0409 : std_logic;
  signal wait_for_recv_busy_sig : std_logic;
  signal wait_for_recv_v0_4 : signed(32-1 downto 0) := (others => '0');
  signal wait_for_recv_v_1 : signed(32-1 downto 0) := X"00000000";
  signal wait_for_recv_v2_2 : signed(32-1 downto 0) := (others => '0');
  signal wait_for_recv_v1_3 : signed(32-1 downto 0) := (others => '0');
  type Type_S_wait_for_recv is (
    S_wait_for_recv_IDLE,
    S_wait_for_recv_S_wait_for_recv_0001,
    S_wait_for_recv_S_wait_for_recv_0002,
    S_wait_for_recv_S_wait_for_recv_0003,
    S_wait_for_recv_S_wait_for_recv_0004,
    S_wait_for_recv_S_wait_for_recv_0005,
    S_wait_for_recv_S_wait_for_recv_0006,
    S_wait_for_recv_S_wait_for_recv_0007,
    S_wait_for_recv_S_wait_for_recv_0008,
    S_wait_for_recv_S_wait_for_recv_0009,
    S_wait_for_recv_S_wait_for_recv_0010  
  );
  signal S_wait_for_recv : Type_S_wait_for_recv := S_wait_for_recv_IDLE;
  signal S_wait_for_recv_delay : signed(32-1 downto 0) := (others => '0');
  signal tmp_0410 : std_logic;
  signal tmp_0411 : std_logic;
  signal tmp_0412 : std_logic;
  signal tmp_0413 : std_logic;
  signal tmp_0414 : signed(32-1 downto 0);
  signal tmp_0415 : std_logic;
  signal tmp_0416 : std_logic;
  signal tmp_0417 : signed(32-1 downto 0);
  signal tmp_0418 : std_logic;
  signal tmp_0419 : std_logic;
  signal tmp_0420 : std_logic;
  signal tmp_0421 : std_logic;
  signal tmp_0422 : signed(32-1 downto 0);
  signal tmp_0423 : signed(32-1 downto 0);
  signal tmp_0424 : signed(32-1 downto 0);
  signal tmp_0425 : signed(32-1 downto 0);
  signal tmp_0426 : signed(32-1 downto 0);
  signal read_data_busy_sig_0427 : std_logic;
  signal tmp_0428 : std_logic;
  signal tmp_0429 : std_logic;
  signal tmp_0430 : std_logic;
  signal tmp_0431 : std_logic;
  signal tmp_0432 : signed(32-1 downto 0);
  signal tmp_0433 : signed(32-1 downto 0);
  signal tmp_0434 : signed(32-1 downto 0);
  signal tmp_0435 : signed(32-1 downto 0);
  signal read_data_busy_sig_0436 : std_logic;
  signal tmp_0437 : std_logic;
  signal tmp_0438 : std_logic;
  signal tmp_0439 : std_logic;
  signal tmp_0440 : std_logic;
  signal tmp_0441 : signed(32-1 downto 0);
  signal tmp_0442 : signed(32-1 downto 0);
  signal tmp_0443 : signed(32-1 downto 0);
  signal tmp_0444 : signed(32-1 downto 0);
  signal read_data_busy_sig_0445 : std_logic;
  signal tmp_0446 : std_logic;
  signal tmp_0447 : std_logic;
  signal tmp_0448 : std_logic;
  signal tmp_0449 : std_logic;
  signal tmp_0450 : signed(32-1 downto 0);
  signal tmp_0451 : signed(32-1 downto 0);
  signal tmp_0452 : signed(32-1 downto 0);
  signal tmp_0453 : signed(32-1 downto 0);
  signal tmp_0454 : signed(32-1 downto 0);
  signal tmp_0455 : signed(32-1 downto 0);
  signal tmp_0456 : signed(32-1 downto 0);
  signal pull_recv_data_port : signed(32-1 downto 0) := (others => '0');
  signal pull_recv_data_len : signed(32-1 downto 0) := (others => '0');
  signal pull_recv_data_req_local : std_logic := '0';
  signal tmp_0457 : std_logic;
  signal pull_recv_data_busy_sig : std_logic;
  signal pull_recv_data_read_len_5 : signed(32-1 downto 0) := (others => '0');
  type Type_S_pull_recv_data is (
    S_pull_recv_data_IDLE,
    S_pull_recv_data_S_pull_recv_data_0001,
    S_pull_recv_data_S_pull_recv_data_0002,
    S_pull_recv_data_S_pull_recv_data_0003,
    S_pull_recv_data_S_pull_recv_data_0004,
    S_pull_recv_data_S_pull_recv_data_0005,
    S_pull_recv_data_S_pull_recv_data_0006,
    S_pull_recv_data_S_pull_recv_data_0007,
    S_pull_recv_data_S_pull_recv_data_0008,
    S_pull_recv_data_S_pull_recv_data_0009,
    S_pull_recv_data_S_pull_recv_data_0010,
    S_pull_recv_data_S_pull_recv_data_0011,
    S_pull_recv_data_S_pull_recv_data_0012  
  );
  signal S_pull_recv_data : Type_S_pull_recv_data := S_pull_recv_data_IDLE;
  signal S_pull_recv_data_delay : signed(32-1 downto 0) := (others => '0');
  signal tmp_0458 : std_logic;
  signal tmp_0459 : std_logic;
  signal tmp_0460 : std_logic;
  signal tmp_0461 : std_logic;
  signal tmp_0462 : signed(32-1 downto 0);
  signal tmp_0463 : signed(32-1 downto 0);
  signal tmp_0464 : signed(32-1 downto 0);
  signal tmp_0465 : std_logic;
  signal tmp_0466 : std_logic;
  signal tmp_0467 : signed(32-1 downto 0);
  signal tmp_0468 : signed(32-1 downto 0);
  signal tmp_0469 : signed(32-1 downto 0);
  signal tmp_0470 : std_logic;
  signal tmp_0471 : std_logic;
  signal tmp_0472 : std_logic;
  signal tmp_0473 : std_logic;
  signal tmp_0474 : signed(32-1 downto 0);
  signal tmp_0475 : signed(32-1 downto 0);
  signal tmp_0476 : signed(32-1 downto 0);
  signal tmp_0477 : signed(32-1 downto 0);
  signal tmp_0478 : signed(32-1 downto 0);
  signal tmp_0479 : signed(32-1 downto 0);
  signal tmp_0480 : signed(32-1 downto 0);
  signal tmp_0481 : signed(32-1 downto 0);
  signal read_data_busy_sig_0482 : std_logic;
  signal tmp_0483 : std_logic;
  signal tmp_0484 : std_logic;
  signal tmp_0485 : std_logic;
  signal tmp_0486 : std_logic;
  signal tmp_0487 : signed(32-1 downto 0);
  signal tmp_0488 : signed(32-1 downto 0);
  signal tmp_0489 : signed(32-1 downto 0);
  signal tmp_0490 : signed(32-1 downto 0);
  signal tmp_0491 : signed(32-1 downto 0);
  signal tmp_0492 : signed(32-1 downto 0);
  signal tmp_0493 : signed(32-1 downto 0);
  signal read_data_busy_sig_0494 : std_logic;
  signal tmp_0495 : std_logic;
  signal tmp_0496 : std_logic;
  signal tmp_0497 : std_logic;
  signal tmp_0498 : std_logic;
  signal tmp_0499 : signed(32-1 downto 0);
  signal tmp_0500 : signed(32-1 downto 0);
  signal tmp_0501 : signed(32-1 downto 0);
  signal tmp_0502 : signed(32-1 downto 0);
  signal tmp_0503 : signed(32-1 downto 0);
  signal tmp_0504 : signed(32-1 downto 0);
  signal tmp_0505 : signed(32-1 downto 0);
  signal tmp_0506 : signed(32-1 downto 0);
  signal write_data_busy_sig_0507 : std_logic;
  signal tmp_0508 : std_logic;
  signal tmp_0509 : std_logic;
  signal tmp_0510 : std_logic;
  signal tmp_0511 : std_logic;
  signal push_send_data_port : signed(32-1 downto 0) := (others => '0');
  signal push_send_data_len : signed(32-1 downto 0) := (others => '0');
  signal push_send_data_req_local : std_logic := '0';
  signal tmp_0512 : std_logic;
  signal push_send_data_busy_sig : std_logic;
  signal push_send_data_write_len_4 : signed(32-1 downto 0) := (others => '0');
  type Type_S_push_send_data is (
    S_push_send_data_IDLE,
    S_push_send_data_S_push_send_data_0001,
    S_push_send_data_S_push_send_data_0002,
    S_push_send_data_S_push_send_data_0003,
    S_push_send_data_S_push_send_data_0004,
    S_push_send_data_S_push_send_data_0005,
    S_push_send_data_S_push_send_data_0006,
    S_push_send_data_S_push_send_data_0007,
    S_push_send_data_S_push_send_data_0008,
    S_push_send_data_S_push_send_data_0009,
    S_push_send_data_S_push_send_data_0010,
    S_push_send_data_S_push_send_data_0011,
    S_push_send_data_S_push_send_data_0012,
    S_push_send_data_S_push_send_data_0013,
    S_push_send_data_S_push_send_data_0014,
    S_push_send_data_S_push_send_data_0015,
    S_push_send_data_S_push_send_data_0016  
  );
  signal S_push_send_data : Type_S_push_send_data := S_push_send_data_IDLE;
  signal S_push_send_data_delay : signed(32-1 downto 0) := (others => '0');
  signal tmp_0513 : std_logic;
  signal tmp_0514 : std_logic;
  signal tmp_0515 : std_logic;
  signal tmp_0516 : std_logic;
  signal tmp_0517 : signed(32-1 downto 0);
  signal tmp_0518 : signed(32-1 downto 0);
  signal tmp_0519 : signed(32-1 downto 0);
  signal tmp_0520 : std_logic;
  signal tmp_0521 : std_logic;
  signal tmp_0522 : signed(32-1 downto 0);
  signal tmp_0523 : signed(32-1 downto 0);
  signal tmp_0524 : signed(32-1 downto 0);
  signal tmp_0525 : std_logic;
  signal tmp_0526 : std_logic;
  signal tmp_0527 : std_logic;
  signal tmp_0528 : std_logic;
  signal tmp_0529 : signed(32-1 downto 0);
  signal tmp_0530 : signed(32-1 downto 0);
  signal tmp_0531 : signed(32-1 downto 0);
  signal tmp_0532 : signed(32-1 downto 0);
  signal tmp_0533 : signed(32-1 downto 0);
  signal tmp_0534 : signed(32-1 downto 0);
  signal tmp_0535 : signed(32-1 downto 0);
  signal tmp_0536 : signed(32-1 downto 0);
  signal tmp_0537 : signed(32-1 downto 0);
  signal tmp_0538 : signed(32-1 downto 0);
  signal tmp_0539 : signed(32-1 downto 0);
  signal tmp_0540 : signed(32-1 downto 0);
  signal write_data_busy_sig_0541 : std_logic;
  signal tmp_0542 : std_logic;
  signal tmp_0543 : std_logic;
  signal tmp_0544 : std_logic;
  signal tmp_0545 : std_logic;
  signal tmp_0546 : signed(32-1 downto 0);
  signal tmp_0547 : signed(32-1 downto 0);
  signal tmp_0548 : signed(32-1 downto 0);
  signal tmp_0549 : signed(32-1 downto 0);
  signal tmp_0550 : signed(32-1 downto 0);
  signal tmp_0551 : signed(32-1 downto 0);
  signal tmp_0552 : signed(32-1 downto 0);
  signal write_data_busy_sig_0553 : std_logic;
  signal tmp_0554 : std_logic;
  signal tmp_0555 : std_logic;
  signal tmp_0556 : std_logic;
  signal tmp_0557 : std_logic;
  signal tmp_0558 : signed(32-1 downto 0);
  signal tmp_0559 : signed(32-1 downto 0);
  signal tmp_0560 : signed(32-1 downto 0);
  signal tmp_0561 : signed(32-1 downto 0);
  signal write_data_busy_sig_0562 : std_logic;
  signal tmp_0563 : std_logic;
  signal tmp_0564 : std_logic;
  signal tmp_0565 : std_logic;
  signal tmp_0566 : std_logic;
  signal tmp_0567 : signed(32-1 downto 0);
  signal tmp_0568 : signed(32-1 downto 0);
  signal tmp_0569 : signed(32-1 downto 0);
  signal tmp_0570 : signed(32-1 downto 0);
  signal tmp_0571 : signed(32-1 downto 0);
  signal tmp_0572 : signed(8-1 downto 0);
  signal write_data_busy_sig_0573 : std_logic;
  signal tmp_0574 : std_logic;
  signal tmp_0575 : std_logic;
  signal tmp_0576 : std_logic;
  signal tmp_0577 : std_logic;
  signal tmp_0578 : signed(32-1 downto 0);
  signal tmp_0579 : signed(32-1 downto 0);
  signal tmp_0580 : signed(32-1 downto 0);
  signal tmp_0581 : signed(32-1 downto 0);
  signal tmp_0582 : signed(32-1 downto 0);
  signal tmp_0583 : signed(8-1 downto 0);
  signal write_data_busy_sig_0584 : std_logic;
  signal tmp_0585 : std_logic;
  signal tmp_0586 : std_logic;
  signal tmp_0587 : std_logic;
  signal tmp_0588 : std_logic;
  signal tmp_0589 : signed(32-1 downto 0);
  signal tmp_0590 : signed(32-1 downto 0);
  signal tmp_0591 : signed(32-1 downto 0);
  signal tmp_0592 : signed(32-1 downto 0);
  signal tmp_0593 : signed(32-1 downto 0);
  signal tmp_0594 : signed(8-1 downto 0);
  signal write_data_busy_sig_0595 : std_logic;
  signal tmp_0596 : std_logic;
  signal tmp_0597 : std_logic;
  signal tmp_0598 : std_logic;
  signal tmp_0599 : std_logic;
  signal tmp_0600 : signed(32-1 downto 0);
  signal tmp_0601 : signed(32-1 downto 0);
  signal tmp_0602 : signed(32-1 downto 0);
  signal write_data_busy_sig_0603 : std_logic;
  signal tmp_0604 : std_logic;
  signal tmp_0605 : std_logic;
  signal tmp_0606 : std_logic;
  signal tmp_0607 : std_logic;
  signal tcp_server_port : signed(32-1 downto 0) := (others => '0');
  signal tcp_server_req_local : std_logic := '0';
  signal tmp_0608 : std_logic;
  signal tcp_server_busy_sig : std_logic;
  signal tcp_server_len_1 : signed(32-1 downto 0) := (others => '0');
  signal tcp_server_v_2 : signed(8-1 downto 0) := (others => '0');
  type Type_S_tcp_server is (
    S_tcp_server_IDLE,
    S_tcp_server_S_tcp_server_0001,
    S_tcp_server_S_tcp_server_0002,
    S_tcp_server_S_tcp_server_0003,
    S_tcp_server_S_tcp_server_0004,
    S_tcp_server_S_tcp_server_0005,
    S_tcp_server_S_tcp_server_0006,
    S_tcp_server_S_tcp_server_0007,
    S_tcp_server_S_tcp_server_0008,
    S_tcp_server_S_tcp_server_0009,
    S_tcp_server_S_tcp_server_0010,
    S_tcp_server_S_tcp_server_0011,
    S_tcp_server_S_tcp_server_0012,
    S_tcp_server_S_tcp_server_0013,
    S_tcp_server_S_tcp_server_0014,
    S_tcp_server_S_tcp_server_0015  
  );
  signal S_tcp_server : Type_S_tcp_server := S_tcp_server_IDLE;
  signal S_tcp_server_delay : signed(32-1 downto 0) := (others => '0');
  signal tmp_0609 : std_logic;
  signal tmp_0610 : std_logic;
  signal tmp_0611 : std_logic;
  signal tmp_0612 : std_logic;
  signal tmp_0613 : std_logic;
  signal tmp_0614 : std_logic;
  signal tmp_0615 : std_logic;
  signal tmp_0616 : std_logic;
  signal tmp_0617 : std_logic;
  signal tmp_0618 : std_logic;
  signal tmp_0619 : std_logic;
  signal tmp_0620 : std_logic;
  signal tmp_0621 : std_logic;
  signal tmp_0622 : std_logic;
  signal tmp_0623 : signed(32-1 downto 0);
  signal tmp_0624 : signed(32-1 downto 0);
  signal tmp_0625 : signed(32-1 downto 0);
  signal tmp_0626 : signed(32-1 downto 0);
  signal tmp_0627 : signed(8-1 downto 0);
  signal write_data_busy_sig_0628 : std_logic;
  signal tmp_0629 : std_logic;
  signal tmp_0630 : std_logic;
  signal tmp_0631 : std_logic;
  signal tmp_0632 : std_logic;
  signal tcp_server_open_busy_sig_0633 : std_logic;
  signal tmp_0634 : std_logic;
  signal tmp_0635 : std_logic;
  signal tmp_0636 : std_logic;
  signal tmp_0637 : std_logic;
  signal tmp_0638 : signed(32-1 downto 0);
  signal tmp_0639 : signed(32-1 downto 0);
  signal tmp_0640 : signed(32-1 downto 0);
  signal write_data_busy_sig_0641 : std_logic;
  signal tmp_0642 : std_logic;
  signal tmp_0643 : std_logic;
  signal tmp_0644 : std_logic;
  signal tmp_0645 : std_logic;
  signal tcp_server_open_busy_sig_0646 : std_logic;
  signal tmp_0647 : std_logic;
  signal tmp_0648 : std_logic;
  signal tmp_0649 : std_logic;
  signal tmp_0650 : std_logic;
  signal tcp_server_listen_busy_sig_0651 : std_logic;
  signal tmp_0652 : std_logic;
  signal tmp_0653 : std_logic;
  signal tmp_0654 : std_logic;
  signal tmp_0655 : std_logic;
  signal tmp_0656 : signed(32-1 downto 0);
  signal tmp_0657 : signed(32-1 downto 0);
  signal tmp_0658 : signed(32-1 downto 0);
  signal write_data_busy_sig_0659 : std_logic;
  signal tmp_0660 : std_logic;
  signal tmp_0661 : std_logic;
  signal tmp_0662 : std_logic;
  signal tmp_0663 : std_logic;
  signal tcp_server_listen_busy_sig_0664 : std_logic;
  signal tmp_0665 : std_logic;
  signal tmp_0666 : std_logic;
  signal tmp_0667 : std_logic;
  signal tmp_0668 : std_logic;
  signal wait_for_established_busy_sig_0669 : std_logic;
  signal tmp_0670 : std_logic;
  signal tmp_0671 : std_logic;
  signal tmp_0672 : std_logic;
  signal tmp_0673 : std_logic;
  signal wait_for_recv_busy_sig_0674 : std_logic;
  signal tmp_0675 : std_logic;
  signal tmp_0676 : std_logic;
  signal tmp_0677 : std_logic;
  signal tmp_0678 : std_logic;
  signal pull_recv_data_busy_sig_0679 : std_logic;
  signal tmp_0680 : std_logic;
  signal tmp_0681 : std_logic;
  signal tmp_0682 : std_logic;
  signal tmp_0683 : std_logic;
  signal push_send_data_busy_sig_0684 : std_logic;
  signal tmp_0685 : std_logic;
  signal tmp_0686 : std_logic;
  signal tmp_0687 : std_logic;
  signal tmp_0688 : std_logic;
  signal test_req_local : std_logic := '0';
  signal tmp_0689 : std_logic;
  type Type_S_test is (
    S_test_IDLE,
    S_test_S_test_0001,
    S_test_S_test_0002,
    S_test_S_test_0003,
    S_test_S_test_0004,
    S_test_S_test_0005  
  );
  signal S_test : Type_S_test := S_test_IDLE;
  signal S_test_delay : signed(32-1 downto 0) := (others => '0');
  signal tmp_0690 : std_logic;
  signal tmp_0691 : std_logic;
  signal tmp_0692 : std_logic;
  signal tmp_0693 : std_logic;
  signal tmp_0694 : std_logic;
  signal tmp_0695 : std_logic;
  signal init_busy_sig_0696 : std_logic;
  signal tmp_0697 : std_logic;
  signal tmp_0698 : std_logic;
  signal tmp_0699 : std_logic;
  signal tmp_0700 : std_logic;
  signal network_configuration_busy_sig_0701 : std_logic;
  signal tmp_0702 : std_logic;
  signal tmp_0703 : std_logic;
  signal tmp_0704 : std_logic;
  signal tmp_0705 : std_logic;
  signal tmp_0706 : signed(32-1 downto 0);
  signal tcp_server_busy_sig_0707 : std_logic;
  signal tmp_0708 : std_logic;
  signal tmp_0709 : std_logic;
  signal tmp_0710 : std_logic;
  signal tmp_0711 : std_logic;
  signal blink_led_req_local : std_logic := '0';
  signal tmp_0712 : std_logic;
  type Type_S_blink_led is (
    S_blink_led_IDLE,
    S_blink_led_S_blink_led_0001,
    S_blink_led_S_blink_led_0002,
    S_blink_led_S_blink_led_0003,
    S_blink_led_S_blink_led_0004,
    S_blink_led_S_blink_led_0005,
    S_blink_led_S_blink_led_0006,
    S_blink_led_S_blink_led_0007,
    S_blink_led_S_blink_led_0008  
  );
  signal S_blink_led : Type_S_blink_led := S_blink_led_IDLE;
  signal S_blink_led_delay : signed(32-1 downto 0) := (others => '0');
  signal tmp_0713 : std_logic;
  signal tmp_0714 : std_logic;
  signal tmp_0715 : std_logic;
  signal tmp_0716 : std_logic;
  signal tmp_0717 : signed(32-1 downto 0);
  signal tmp_0718 : std_logic;
  signal tmp_0719 : std_logic;
  signal tmp_0720 : signed(32-1 downto 0);
  signal tmp_0721 : std_logic;
  signal tmp_0722 : std_logic;
  signal tmp_0723 : signed(32-1 downto 0);
  signal tmp_0724 : std_logic;
  signal tmp_0725 : std_logic;
  signal tmp_0726 : signed(32-1 downto 0);
  signal tmp_0727 : std_logic;
  signal tmp_0728 : std_logic;
  signal tmp_0729 : std_logic;
  signal tmp_0730 : std_logic;
  signal tmp_0731 : signed(32-1 downto 0);
  signal tmp_0732 : signed(32-1 downto 0);
  signal tmp_0733 : signed(32-1 downto 0);
  signal tmp_0734 : signed(32-1 downto 0);

begin

  clk_sig <= clk;
  reset_sig <= reset;
  field_led_output <= field_led_output_sig;
  field_led_output_sig <= led;

  field_led_input_sig <= field_led_input;
  field_led_input_we_sig <= field_led_input_we;
  test_req_sig <= test_req;
  test_busy <= test_busy_sig;
  test_busy_sig <= tmp_0695;

  blink_led_req_sig <= blink_led_req;
  blink_led_busy <= blink_led_busy_sig;
  blink_led_busy_sig <= tmp_0730;


  -- expressions
  tmp_0001 <= field_led_input_sig when field_led_input_we_sig = '1' else led;
  tmp_0002 <= X"00000200";
  tmp_0003 <= X"00000201";
  tmp_0004 <= X"00000202";
  tmp_0005 <= X"00000203";
  tmp_0006 <= X"00000204";
  tmp_0007 <= X"00000205";
  tmp_0008 <= X"00000206";
  tmp_0009 <= X"00000207";
  tmp_0010 <= X"00000208";
  tmp_0011 <= X"00000209";
  tmp_0012 <= X"0000020a";
  tmp_0013 <= X"0000020b";
  tmp_0014 <= X"0000020c";
  tmp_0015 <= X"0000020d";
  tmp_0016 <= X"0000020e";
  tmp_0017 <= X"0000020f";
  tmp_0018 <= X"00000210";
  tmp_0019 <= X"00000211";
  tmp_0020 <= X"00000212";
  tmp_0021 <= X"00000213";
  tmp_0022 <= X"00000214";
  tmp_0023 <= X"00000215";
  tmp_0024 <= X"00000216";
  tmp_0025 <= X"00000217";
  tmp_0026 <= X"00000218";
  tmp_0027 <= X"00000219";
  tmp_0028 <= X"0000021a";
  tmp_0029 <= X"0000021b";
  tmp_0030 <= X"0000021c";
  tmp_0031 <= X"0000021d";
  tmp_0032 <= X"0000021e";
  tmp_0033 <= X"0000021f";
  tmp_0034 <= X"00000220";
  tmp_0035 <= X"00000221";
  tmp_0036 <= X"00000222";
  tmp_0037 <= X"00000223";
  tmp_0038 <= X"00000224";
  tmp_0039 <= X"00000225";
  tmp_0040 <= X"00000226";
  tmp_0041 <= X"00000227";
  tmp_0042 <= X"00000228";
  tmp_0043 <= X"00000229";
  tmp_0044 <= X"0000022a";
  tmp_0045 <= X"0000022b";
  tmp_0046 <= X"0000022c";
  tmp_0047 <= X"0000022d";
  tmp_0048 <= X"0000022e";
  tmp_0049 <= X"0000022f";
  tmp_0050 <= X"00000230";
  tmp_0051 <= X"00000231";
  tmp_0052 <= X"00000000";
  tmp_0053 <= tmp_0052(32 - 24 - 1 downto 0);
  tmp_0054 <= X"00000001";
  tmp_0055 <= tmp_0054(32 - 24 - 1 downto 0);
  tmp_0056 <= X"00000002";
  tmp_0057 <= tmp_0056(32 - 24 - 1 downto 0);
  tmp_0058 <= X"00000003";
  tmp_0059 <= tmp_0058(32 - 24 - 1 downto 0);
  tmp_0060 <= X"00000004";
  tmp_0061 <= tmp_0060(32 - 24 - 1 downto 0);
  tmp_0062 <= X"00000005";
  tmp_0063 <= tmp_0062(32 - 24 - 1 downto 0);
  tmp_0064 <= X"00000001";
  tmp_0065 <= tmp_0064(32 - 24 - 1 downto 0);
  tmp_0066 <= X"00000002";
  tmp_0067 <= tmp_0066(32 - 24 - 1 downto 0);
  tmp_0068 <= X"00000004";
  tmp_0069 <= tmp_0068(32 - 24 - 1 downto 0);
  tmp_0070 <= X"00000008";
  tmp_0071 <= tmp_0070(32 - 24 - 1 downto 0);
  tmp_0072 <= X"00000010";
  tmp_0073 <= tmp_0072(32 - 24 - 1 downto 0);
  tmp_0074 <= X"00000020";
  tmp_0075 <= tmp_0074(32 - 24 - 1 downto 0);
  tmp_0076 <= X"00000021";
  tmp_0077 <= tmp_0076(32 - 24 - 1 downto 0);
  tmp_0078 <= X"00000022";
  tmp_0079 <= tmp_0078(32 - 24 - 1 downto 0);
  tmp_0080 <= X"00000040";
  tmp_0081 <= tmp_0080(32 - 24 - 1 downto 0);
  tmp_0082 <= X"00000023";
  tmp_0083 <= tmp_0082(32 - 24 - 1 downto 0);
  tmp_0084 <= X"00000024";
  tmp_0085 <= tmp_0084(32 - 24 - 1 downto 0);
  tmp_0086 <= X"00000025";
  tmp_0087 <= tmp_0086(32 - 24 - 1 downto 0);
  tmp_0088 <= X"00000026";
  tmp_0089 <= tmp_0088(32 - 24 - 1 downto 0);
  tmp_0090 <= X"00000027";
  tmp_0091 <= tmp_0090(32 - 24 - 1 downto 0);
  tmp_0092 <= X"00000000";
  tmp_0093 <= tmp_0092(32 - 24 - 1 downto 0);
  tmp_0094 <= X"00000013";
  tmp_0095 <= tmp_0094(32 - 24 - 1 downto 0);
  tmp_0096 <= X"00000014";
  tmp_0097 <= tmp_0096(32 - 24 - 1 downto 0);
  tmp_0098 <= X"00000017";
  tmp_0099 <= tmp_0098(32 - 24 - 1 downto 0);
  tmp_0100 <= X"0000001c";
  tmp_0101 <= tmp_0100(32 - 24 - 1 downto 0);
  tmp_0102 <= X"00000022";
  tmp_0103 <= tmp_0102(32 - 24 - 1 downto 0);
  tmp_0104 <= X"00000032";
  tmp_0105 <= tmp_0104(32 - 24 - 1 downto 0);
  tmp_0106 <= X"00000042";
  tmp_0107 <= tmp_0106(32 - 24 - 1 downto 0);
  tmp_0108 <= X"0000005f";
  tmp_0109 <= tmp_0108(32 - 24 - 1 downto 0);
  tmp_0110 <= X"00000015";
  tmp_0111 <= tmp_0110(32 - 24 - 1 downto 0);
  tmp_0112 <= X"00000016";
  tmp_0113 <= tmp_0112(32 - 24 - 1 downto 0);
  tmp_0114 <= X"00000018";
  tmp_0115 <= tmp_0114(32 - 24 - 1 downto 0);
  tmp_0116 <= X"0000001b";
  tmp_0117 <= tmp_0116(32 - 24 - 1 downto 0);
  tmp_0118 <= X"0000001d";
  tmp_0119 <= tmp_0118(32 - 24 - 1 downto 0);
  tmp_0120 <= X"00000001";
  tmp_0121 <= tmp_0120(32 - 24 - 1 downto 0);
  tmp_0122 <= '1' when wait_cycles_req_local = '1' else '0';
  tmp_0123 <= '1' when wait_cycles_i_1 < wait_cycles_n else '0';
  tmp_0124 <= '1' when tmp_0123 = '0' else '0';
  tmp_0125 <= '1' when wait_cycles_i_1 < wait_cycles_n else '0';
  tmp_0126 <= '1' when tmp_0125 = '1' else '0';
  tmp_0127 <= '1' when S_wait_cycles = S_wait_cycles_IDLE else '0';
  tmp_0128 <= '0' when tmp_0127 = '1' else '1';
  tmp_0129 <= X"00000000";
  tmp_0130 <= wait_cycles_i_1 + 1;
  tmp_0131 <= '1' when write_data_req_local = '1' else '0';
  tmp_0132 <= '1' when S_write_data = S_write_data_IDLE else '0';
  tmp_0133 <= '0' when tmp_0132 = '1' else '1';
  tmp_0134 <= '1';
  tmp_0135 <= '1';
  tmp_0136 <= X"00000003";
  tmp_0138 <= '1' when wait_cycles_busy_sig = '0' else '0';
  tmp_0139 <= '1' when wait_cycles_req_local = '0' else '0';
  tmp_0140 <= tmp_0138 and tmp_0139;
  tmp_0141 <= '1' when tmp_0140 = '1' else '0';
  tmp_0142 <= '0';
  tmp_0143 <= '0';
  tmp_0144 <= '1' when read_data_req_local = '1' else '0';
  tmp_0145 <= '1' when S_read_data = S_read_data_IDLE else '0';
  tmp_0146 <= '0' when tmp_0145 = '1' else '1';
  tmp_0147 <= '1';
  tmp_0148 <= '1';
  tmp_0149 <= X"00000003";
  tmp_0151 <= '1' when wait_cycles_busy_sig = '0' else '0';
  tmp_0152 <= '1' when wait_cycles_req_local = '0' else '0';
  tmp_0153 <= tmp_0151 and tmp_0152;
  tmp_0154 <= '1' when tmp_0153 = '1' else '0';
  tmp_0155 <= '0';
  tmp_0156 <= '0';
  tmp_0157 <= '1' when init_req_local = '1' else '0';
  tmp_0158 <= '1' when S_init = S_init_IDLE else '0';
  tmp_0159 <= '0' when tmp_0158 = '1' else '1';
  tmp_0160 <= '0';
  tmp_0161 <= '0';
  tmp_0162 <= '0';
  tmp_0163 <= '1';
  tmp_0164 <= X"000003e8";
  tmp_0166 <= '1' when wait_cycles_busy_sig = '0' else '0';
  tmp_0167 <= '1' when wait_cycles_req_local = '0' else '0';
  tmp_0168 <= tmp_0166 and tmp_0167;
  tmp_0169 <= '1' when tmp_0168 = '1' else '0';
  tmp_0170 <= '0';
  tmp_0171 <= X"000003e8";
  tmp_0173 <= '1' when wait_cycles_busy_sig = '0' else '0';
  tmp_0174 <= '1' when wait_cycles_req_local = '0' else '0';
  tmp_0175 <= tmp_0173 and tmp_0174;
  tmp_0176 <= '1' when tmp_0175 = '1' else '0';
  tmp_0177 <= '1' when network_configuration_req_local = '1' else '0';
  tmp_0178 <= '1' when S_network_configuration = S_network_configuration_IDLE else '0';
  tmp_0179 <= '0' when tmp_0178 = '1' else '1';
  tmp_0180 <= X"00000008";
  tmp_0181 <= X"00000000";
  tmp_0182 <= tmp_0181(32 - 24 - 1 downto 0);
  tmp_0184 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0185 <= '1' when write_data_req_local = '0' else '0';
  tmp_0186 <= tmp_0184 and tmp_0185;
  tmp_0187 <= '1' when tmp_0186 = '1' else '0';
  tmp_0188 <= X"00000009";
  tmp_0189 <= X"00000008";
  tmp_0190 <= tmp_0189(32 - 24 - 1 downto 0);
  tmp_0192 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0193 <= '1' when write_data_req_local = '0' else '0';
  tmp_0194 <= tmp_0192 and tmp_0193;
  tmp_0195 <= '1' when tmp_0194 = '1' else '0';
  tmp_0196 <= X"0000000a";
  tmp_0197 <= X"000000dc";
  tmp_0198 <= tmp_0197(32 - 24 - 1 downto 0);
  tmp_0200 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0201 <= '1' when write_data_req_local = '0' else '0';
  tmp_0202 <= tmp_0200 and tmp_0201;
  tmp_0203 <= '1' when tmp_0202 = '1' else '0';
  tmp_0204 <= X"0000000b";
  tmp_0205 <= X"00000001";
  tmp_0206 <= tmp_0205(32 - 24 - 1 downto 0);
  tmp_0208 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0209 <= '1' when write_data_req_local = '0' else '0';
  tmp_0210 <= tmp_0208 and tmp_0209;
  tmp_0211 <= '1' when tmp_0210 = '1' else '0';
  tmp_0212 <= X"0000000c";
  tmp_0213 <= X"00000002";
  tmp_0214 <= tmp_0213(32 - 24 - 1 downto 0);
  tmp_0216 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0217 <= '1' when write_data_req_local = '0' else '0';
  tmp_0218 <= tmp_0216 and tmp_0217;
  tmp_0219 <= '1' when tmp_0218 = '1' else '0';
  tmp_0220 <= X"0000000d";
  tmp_0221 <= X"00000003";
  tmp_0222 <= tmp_0221(32 - 24 - 1 downto 0);
  tmp_0224 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0225 <= '1' when write_data_req_local = '0' else '0';
  tmp_0226 <= tmp_0224 and tmp_0225;
  tmp_0227 <= '1' when tmp_0226 = '1' else '0';
  tmp_0228 <= X"00000010";
  tmp_0229 <= X"0000000a";
  tmp_0230 <= tmp_0229(32 - 24 - 1 downto 0);
  tmp_0232 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0233 <= '1' when write_data_req_local = '0' else '0';
  tmp_0234 <= tmp_0232 and tmp_0233;
  tmp_0235 <= '1' when tmp_0234 = '1' else '0';
  tmp_0236 <= X"00000011";
  tmp_0237 <= X"00000000";
  tmp_0238 <= tmp_0237(32 - 24 - 1 downto 0);
  tmp_0240 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0241 <= '1' when write_data_req_local = '0' else '0';
  tmp_0242 <= tmp_0240 and tmp_0241;
  tmp_0243 <= '1' when tmp_0242 = '1' else '0';
  tmp_0244 <= X"00000012";
  tmp_0245 <= X"00000000";
  tmp_0246 <= tmp_0245(32 - 24 - 1 downto 0);
  tmp_0248 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0249 <= '1' when write_data_req_local = '0' else '0';
  tmp_0250 <= tmp_0248 and tmp_0249;
  tmp_0251 <= '1' when tmp_0250 = '1' else '0';
  tmp_0252 <= X"00000013";
  tmp_0253 <= X"00000001";
  tmp_0254 <= tmp_0253(32 - 24 - 1 downto 0);
  tmp_0256 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0257 <= '1' when write_data_req_local = '0' else '0';
  tmp_0258 <= tmp_0256 and tmp_0257;
  tmp_0259 <= '1' when tmp_0258 = '1' else '0';
  tmp_0260 <= X"00000014";
  tmp_0261 <= X"000000ff";
  tmp_0262 <= tmp_0261(32 - 24 - 1 downto 0);
  tmp_0264 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0265 <= '1' when write_data_req_local = '0' else '0';
  tmp_0266 <= tmp_0264 and tmp_0265;
  tmp_0267 <= '1' when tmp_0266 = '1' else '0';
  tmp_0268 <= X"00000015";
  tmp_0269 <= X"00000000";
  tmp_0270 <= tmp_0269(32 - 24 - 1 downto 0);
  tmp_0272 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0273 <= '1' when write_data_req_local = '0' else '0';
  tmp_0274 <= tmp_0272 and tmp_0273;
  tmp_0275 <= '1' when tmp_0274 = '1' else '0';
  tmp_0276 <= X"00000016";
  tmp_0277 <= X"00000000";
  tmp_0278 <= tmp_0277(32 - 24 - 1 downto 0);
  tmp_0280 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0281 <= '1' when write_data_req_local = '0' else '0';
  tmp_0282 <= tmp_0280 and tmp_0281;
  tmp_0283 <= '1' when tmp_0282 = '1' else '0';
  tmp_0284 <= X"00000017";
  tmp_0285 <= X"00000000";
  tmp_0286 <= tmp_0285(32 - 24 - 1 downto 0);
  tmp_0288 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0289 <= '1' when write_data_req_local = '0' else '0';
  tmp_0290 <= tmp_0288 and tmp_0289;
  tmp_0291 <= '1' when tmp_0290 = '1' else '0';
  tmp_0292 <= X"00000018";
  tmp_0293 <= X"0000000a";
  tmp_0294 <= tmp_0293(32 - 24 - 1 downto 0);
  tmp_0296 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0297 <= '1' when write_data_req_local = '0' else '0';
  tmp_0298 <= tmp_0296 and tmp_0297;
  tmp_0299 <= '1' when tmp_0298 = '1' else '0';
  tmp_0300 <= X"00000019";
  tmp_0301 <= X"00000000";
  tmp_0302 <= tmp_0301(32 - 24 - 1 downto 0);
  tmp_0304 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0305 <= '1' when write_data_req_local = '0' else '0';
  tmp_0306 <= tmp_0304 and tmp_0305;
  tmp_0307 <= '1' when tmp_0306 = '1' else '0';
  tmp_0308 <= X"0000001a";
  tmp_0309 <= X"00000000";
  tmp_0310 <= tmp_0309(32 - 24 - 1 downto 0);
  tmp_0312 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0313 <= '1' when write_data_req_local = '0' else '0';
  tmp_0314 <= tmp_0312 and tmp_0313;
  tmp_0315 <= '1' when tmp_0314 = '1' else '0';
  tmp_0316 <= X"0000001b";
  tmp_0317 <= X"00000002";
  tmp_0318 <= tmp_0317(32 - 24 - 1 downto 0);
  tmp_0320 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0321 <= '1' when write_data_req_local = '0' else '0';
  tmp_0322 <= tmp_0320 and tmp_0321;
  tmp_0323 <= '1' when tmp_0322 = '1' else '0';
  tmp_0324 <= '1' when tcp_server_open_req_local = '1' else '0';
  tmp_0325 <= '1' when S_tcp_server_open = S_tcp_server_open_IDLE else '0';
  tmp_0326 <= '0' when tmp_0325 = '1' else '1';
  tmp_0327 <= X"00000006";
  tmp_0328 <= tcp_server_open_port(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0329 <= Sn_MR1 + tmp_0328;
  tmp_0331 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0332 <= '1' when write_data_req_local = '0' else '0';
  tmp_0333 <= tmp_0331 and tmp_0332;
  tmp_0334 <= '1' when tmp_0333 = '1' else '0';
  tmp_0335 <= X"00000006";
  tmp_0336 <= tcp_server_open_port(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0337 <= Sn_PORTR0 + tmp_0336;
  tmp_0338 <= X"00000000";
  tmp_0339 <= tmp_0338(32 - 24 - 1 downto 0);
  tmp_0341 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0342 <= '1' when write_data_req_local = '0' else '0';
  tmp_0343 <= tmp_0341 and tmp_0342;
  tmp_0344 <= '1' when tmp_0343 = '1' else '0';
  tmp_0345 <= X"00000006";
  tmp_0346 <= tcp_server_open_port(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0347 <= Sn_PORTR1 + tmp_0346;
  tmp_0348 <= X"00000050";
  tmp_0349 <= tmp_0348(32 - 24 - 1 downto 0);
  tmp_0351 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0352 <= '1' when write_data_req_local = '0' else '0';
  tmp_0353 <= tmp_0351 and tmp_0352;
  tmp_0354 <= '1' when tmp_0353 = '1' else '0';
  tmp_0355 <= X"00000006";
  tmp_0356 <= tcp_server_open_port(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0357 <= Sn_CR1 + tmp_0356;
  tmp_0359 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0360 <= '1' when write_data_req_local = '0' else '0';
  tmp_0361 <= tmp_0359 and tmp_0360;
  tmp_0362 <= '1' when tmp_0361 = '1' else '0';
  tmp_0363 <= X"00000006";
  tmp_0364 <= tcp_server_open_port(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0365 <= Sn_SSR1 + tmp_0364;
  tmp_0367 <= '1' when read_data_busy_sig = '0' else '0';
  tmp_0368 <= '1' when read_data_req_local = '0' else '0';
  tmp_0369 <= tmp_0367 and tmp_0368;
  tmp_0370 <= '1' when tmp_0369 = '1' else '0';
  tmp_0371 <= '1' when tcp_server_listen_req_local = '1' else '0';
  tmp_0372 <= '1' when S_tcp_server_listen = S_tcp_server_listen_IDLE else '0';
  tmp_0373 <= '0' when tmp_0372 = '1' else '1';
  tmp_0374 <= X"00000006";
  tmp_0375 <= tcp_server_listen_port(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0376 <= Sn_CR1 + tmp_0375;
  tmp_0378 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0379 <= '1' when write_data_req_local = '0' else '0';
  tmp_0380 <= tmp_0378 and tmp_0379;
  tmp_0381 <= '1' when tmp_0380 = '1' else '0';
  tmp_0382 <= X"00000006";
  tmp_0383 <= tcp_server_listen_port(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0384 <= Sn_SSR1 + tmp_0383;
  tmp_0386 <= '1' when read_data_busy_sig = '0' else '0';
  tmp_0387 <= '1' when read_data_req_local = '0' else '0';
  tmp_0388 <= tmp_0386 and tmp_0387;
  tmp_0389 <= '1' when tmp_0388 = '1' else '0';
  tmp_0390 <= '1' when wait_for_established_req_local = '1' else '0';
  tmp_0391 <= '1';
  tmp_0392 <= '1' when tmp_0391 = '1' else '0';
  tmp_0393 <= '1';
  tmp_0394 <= '1' when tmp_0393 = '0' else '0';
  tmp_0395 <= '1' when wait_for_established_v_1 = Sn_SOCK_ESTABLISHED else '0';
  tmp_0396 <= '1' when tmp_0395 = '1' else '0';
  tmp_0397 <= '1' when wait_for_established_v_1 = Sn_SOCK_ESTABLISHED else '0';
  tmp_0398 <= '1' when tmp_0397 = '0' else '0';
  tmp_0399 <= '1' when S_wait_for_established = S_wait_for_established_IDLE else '0';
  tmp_0400 <= '0' when tmp_0399 = '1' else '1';
  tmp_0401 <= X"00000006";
  tmp_0402 <= wait_for_established_port(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0403 <= Sn_SSR1 + tmp_0402;
  tmp_0405 <= '1' when read_data_busy_sig = '0' else '0';
  tmp_0406 <= '1' when read_data_req_local = '0' else '0';
  tmp_0407 <= tmp_0405 and tmp_0406;
  tmp_0408 <= '1' when tmp_0407 = '1' else '0';
  tmp_0409 <= '1' when wait_for_recv_req_local = '1' else '0';
  tmp_0410 <= '1';
  tmp_0411 <= '1' when tmp_0410 = '1' else '0';
  tmp_0412 <= '1';
  tmp_0413 <= '1' when tmp_0412 = '0' else '0';
  tmp_0414 <= X"00000000";
  tmp_0415 <= '1' when wait_for_recv_v_1 /= tmp_0414 else '0';
  tmp_0416 <= '1' when tmp_0415 = '1' else '0';
  tmp_0417 <= X"00000000";
  tmp_0418 <= '1' when wait_for_recv_v_1 /= tmp_0417 else '0';
  tmp_0419 <= '1' when tmp_0418 = '0' else '0';
  tmp_0420 <= '1' when S_wait_for_recv = S_wait_for_recv_IDLE else '0';
  tmp_0421 <= '0' when tmp_0420 = '1' else '1';
  tmp_0422 <= X"00000000";
  tmp_0423 <= X"00000000";
  tmp_0424 <= X"00000006";
  tmp_0425 <= wait_for_recv_port(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0426 <= Sn_RX_RSR1 + tmp_0425;
  tmp_0428 <= '1' when read_data_busy_sig = '0' else '0';
  tmp_0429 <= '1' when read_data_req_local = '0' else '0';
  tmp_0430 <= tmp_0428 and tmp_0429;
  tmp_0431 <= '1' when tmp_0430 = '1' else '0';
  tmp_0432 <= (32-1 downto 8 => read_data_return_sig(7)) & read_data_return_sig;
  tmp_0433 <= X"00000006";
  tmp_0434 <= wait_for_recv_port(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0435 <= Sn_RX_RSR2 + tmp_0434;
  tmp_0437 <= '1' when read_data_busy_sig = '0' else '0';
  tmp_0438 <= '1' when read_data_req_local = '0' else '0';
  tmp_0439 <= tmp_0437 and tmp_0438;
  tmp_0440 <= '1' when tmp_0439 = '1' else '0';
  tmp_0441 <= (32-1 downto 8 => read_data_return_sig(7)) & read_data_return_sig;
  tmp_0442 <= X"00000006";
  tmp_0443 <= wait_for_recv_port(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0444 <= Sn_RX_RSR3 + tmp_0443;
  tmp_0446 <= '1' when read_data_busy_sig = '0' else '0';
  tmp_0447 <= '1' when read_data_req_local = '0' else '0';
  tmp_0448 <= tmp_0446 and tmp_0447;
  tmp_0449 <= '1' when tmp_0448 = '1' else '0';
  tmp_0450 <= (32-1 downto 8 => read_data_return_sig(7)) & read_data_return_sig;
  tmp_0451 <= X"00000010";
  tmp_0452 <= wait_for_recv_v0_4(15 downto 0) & (16-1 downto 0 => '0');
  tmp_0453 <= X"00000008";
  tmp_0454 <= wait_for_recv_v1_3(23 downto 0) & (8-1 downto 0 => '0');
  tmp_0455 <= tmp_0452 + tmp_0454;
  tmp_0456 <= tmp_0455 + wait_for_recv_v2_2;
  tmp_0457 <= '1' when pull_recv_data_req_local = '1' else '0';
  tmp_0458 <= '1' when pull_recv_data_i_4 < pull_recv_data_read_len_5 else '0';
  tmp_0459 <= '1' when tmp_0458 = '0' else '0';
  tmp_0460 <= '1' when pull_recv_data_i_4 < pull_recv_data_read_len_5 else '0';
  tmp_0461 <= '1' when tmp_0460 = '1' else '0';
  tmp_0462 <= X"00000001";
  tmp_0463 <= pull_recv_data_len and tmp_0462;
  tmp_0464 <= X"00000001";
  tmp_0465 <= '1' when tmp_0463 = tmp_0464 else '0';
  tmp_0466 <= '1' when tmp_0465 = '1' else '0';
  tmp_0467 <= X"00000001";
  tmp_0468 <= pull_recv_data_len and tmp_0467;
  tmp_0469 <= X"00000001";
  tmp_0470 <= '1' when tmp_0468 = tmp_0469 else '0';
  tmp_0471 <= '1' when tmp_0470 = '0' else '0';
  tmp_0472 <= '1' when S_pull_recv_data = S_pull_recv_data_IDLE else '0';
  tmp_0473 <= '0' when tmp_0472 = '1' else '1';
  tmp_0474 <= X"00000001";
  tmp_0475 <= (1-1 downto 0 => pull_recv_data_len(31)) & pull_recv_data_len(31 downto 1);
  tmp_0476 <= X"00000001";
  tmp_0477 <= pull_recv_data_read_len_5 + tmp_0476;
  tmp_0478 <= X"00000000";
  tmp_0479 <= X"00000006";
  tmp_0480 <= pull_recv_data_port(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0481 <= Sn_RX_FIFOR0 + tmp_0480;
  tmp_0483 <= '1' when read_data_busy_sig = '0' else '0';
  tmp_0484 <= '1' when read_data_req_local = '0' else '0';
  tmp_0485 <= tmp_0483 and tmp_0484;
  tmp_0486 <= '1' when tmp_0485 = '1' else '0';
  tmp_0487 <= X"00000001";
  tmp_0488 <= pull_recv_data_i_4(30 downto 0) & (1-1 downto 0 => '0');
  tmp_0489 <= X"00000000";
  tmp_0490 <= tmp_0488 + tmp_0489;
  tmp_0491 <= X"00000006";
  tmp_0492 <= pull_recv_data_port(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0493 <= Sn_RX_FIFOR1 + tmp_0492;
  tmp_0495 <= '1' when read_data_busy_sig = '0' else '0';
  tmp_0496 <= '1' when read_data_req_local = '0' else '0';
  tmp_0497 <= tmp_0495 and tmp_0496;
  tmp_0498 <= '1' when tmp_0497 = '1' else '0';
  tmp_0499 <= X"00000001";
  tmp_0500 <= pull_recv_data_i_4(30 downto 0) & (1-1 downto 0 => '0');
  tmp_0501 <= X"00000001";
  tmp_0502 <= tmp_0500 + tmp_0501;
  tmp_0503 <= pull_recv_data_i_4 + 1;
  tmp_0504 <= X"00000006";
  tmp_0505 <= pull_recv_data_port(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0506 <= Sn_CR1 + tmp_0505;
  tmp_0508 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0509 <= '1' when write_data_req_local = '0' else '0';
  tmp_0510 <= tmp_0508 and tmp_0509;
  tmp_0511 <= '1' when tmp_0510 = '1' else '0';
  tmp_0512 <= '1' when push_send_data_req_local = '1' else '0';
  tmp_0513 <= '1' when push_send_data_i_3 < push_send_data_write_len_4 else '0';
  tmp_0514 <= '1' when tmp_0513 = '0' else '0';
  tmp_0515 <= '1' when push_send_data_i_3 < push_send_data_write_len_4 else '0';
  tmp_0516 <= '1' when tmp_0515 = '1' else '0';
  tmp_0517 <= X"00000001";
  tmp_0518 <= push_send_data_len and tmp_0517;
  tmp_0519 <= X"00000001";
  tmp_0520 <= '1' when tmp_0518 = tmp_0519 else '0';
  tmp_0521 <= '1' when tmp_0520 = '1' else '0';
  tmp_0522 <= X"00000001";
  tmp_0523 <= push_send_data_len and tmp_0522;
  tmp_0524 <= X"00000001";
  tmp_0525 <= '1' when tmp_0523 = tmp_0524 else '0';
  tmp_0526 <= '1' when tmp_0525 = '0' else '0';
  tmp_0527 <= '1' when S_push_send_data = S_push_send_data_IDLE else '0';
  tmp_0528 <= '0' when tmp_0527 = '1' else '1';
  tmp_0529 <= X"00000001";
  tmp_0530 <= (1-1 downto 0 => push_send_data_len(31)) & push_send_data_len(31 downto 1);
  tmp_0531 <= X"00000001";
  tmp_0532 <= push_send_data_write_len_4 + tmp_0531;
  tmp_0533 <= X"00000000";
  tmp_0534 <= X"00000001";
  tmp_0535 <= push_send_data_i_3(30 downto 0) & (1-1 downto 0 => '0');
  tmp_0536 <= X"00000000";
  tmp_0537 <= tmp_0535 + tmp_0536;
  tmp_0538 <= X"00000006";
  tmp_0539 <= push_send_data_port(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0540 <= Sn_TX_FIFOR0 + tmp_0539;
  tmp_0542 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0543 <= '1' when write_data_req_local = '0' else '0';
  tmp_0544 <= tmp_0542 and tmp_0543;
  tmp_0545 <= '1' when tmp_0544 = '1' else '0';
  tmp_0546 <= X"00000001";
  tmp_0547 <= push_send_data_i_3(30 downto 0) & (1-1 downto 0 => '0');
  tmp_0548 <= X"00000001";
  tmp_0549 <= tmp_0547 + tmp_0548;
  tmp_0550 <= X"00000006";
  tmp_0551 <= push_send_data_port(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0552 <= Sn_TX_FIFOR1 + tmp_0551;
  tmp_0554 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0555 <= '1' when write_data_req_local = '0' else '0';
  tmp_0556 <= tmp_0554 and tmp_0555;
  tmp_0557 <= '1' when tmp_0556 = '1' else '0';
  tmp_0558 <= push_send_data_i_3 + 1;
  tmp_0559 <= X"00000006";
  tmp_0560 <= push_send_data_port(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0561 <= Sn_CR1 + tmp_0560;
  tmp_0563 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0564 <= '1' when write_data_req_local = '0' else '0';
  tmp_0565 <= tmp_0563 and tmp_0564;
  tmp_0566 <= '1' when tmp_0565 = '1' else '0';
  tmp_0567 <= X"00000006";
  tmp_0568 <= push_send_data_port(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0569 <= Sn_TX_WRSR1 + tmp_0568;
  tmp_0570 <= X"00000010";
  tmp_0571 <= (16-1 downto 0 => push_send_data_len(31)) & push_send_data_len(31 downto 16);
  tmp_0572 <= tmp_0571(32 - 24 - 1 downto 0);
  tmp_0574 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0575 <= '1' when write_data_req_local = '0' else '0';
  tmp_0576 <= tmp_0574 and tmp_0575;
  tmp_0577 <= '1' when tmp_0576 = '1' else '0';
  tmp_0578 <= X"00000006";
  tmp_0579 <= push_send_data_port(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0580 <= Sn_TX_WRSR2 + tmp_0579;
  tmp_0581 <= X"00000008";
  tmp_0582 <= (8-1 downto 0 => push_send_data_len(31)) & push_send_data_len(31 downto 8);
  tmp_0583 <= tmp_0582(32 - 24 - 1 downto 0);
  tmp_0585 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0586 <= '1' when write_data_req_local = '0' else '0';
  tmp_0587 <= tmp_0585 and tmp_0586;
  tmp_0588 <= '1' when tmp_0587 = '1' else '0';
  tmp_0589 <= X"00000006";
  tmp_0590 <= push_send_data_port(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0591 <= Sn_TX_WRSR3 + tmp_0590;
  tmp_0592 <= X"00000000";
  tmp_0593 <= push_send_data_len;
  tmp_0594 <= tmp_0593(32 - 24 - 1 downto 0);
  tmp_0596 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0597 <= '1' when write_data_req_local = '0' else '0';
  tmp_0598 <= tmp_0596 and tmp_0597;
  tmp_0599 <= '1' when tmp_0598 = '1' else '0';
  tmp_0600 <= X"00000006";
  tmp_0601 <= push_send_data_port(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0602 <= Sn_CR1 + tmp_0601;
  tmp_0604 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0605 <= '1' when write_data_req_local = '0' else '0';
  tmp_0606 <= tmp_0604 and tmp_0605;
  tmp_0607 <= '1' when tmp_0606 = '1' else '0';
  tmp_0608 <= '1' when tcp_server_req_local = '1' else '0';
  tmp_0609 <= '1';
  tmp_0610 <= '1' when tmp_0609 = '1' else '0';
  tmp_0611 <= '1';
  tmp_0612 <= '1' when tmp_0611 = '0' else '0';
  tmp_0613 <= '1' when tcp_server_v_2 /= Sn_SOCK_LISTEN else '0';
  tmp_0614 <= '1' when tmp_0613 = '1' else '0';
  tmp_0615 <= '1' when tcp_server_v_2 /= Sn_SOCK_LISTEN else '0';
  tmp_0616 <= '1' when tmp_0615 = '0' else '0';
  tmp_0617 <= '1' when tcp_server_v_2 /= Sn_SOCK_INIT else '0';
  tmp_0618 <= '1' when tmp_0617 = '1' else '0';
  tmp_0619 <= '1' when tcp_server_v_2 /= Sn_SOCK_INIT else '0';
  tmp_0620 <= '1' when tmp_0619 = '0' else '0';
  tmp_0621 <= '1' when S_tcp_server = S_tcp_server_IDLE else '0';
  tmp_0622 <= '0' when tmp_0621 = '1' else '1';
  tmp_0623 <= X"00000006";
  tmp_0624 <= tcp_server_port(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0625 <= Sn_MR0 + tmp_0624;
  tmp_0626 <= X"00000001";
  tmp_0627 <= tmp_0626(32 - 24 - 1 downto 0);
  tmp_0629 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0630 <= '1' when write_data_req_local = '0' else '0';
  tmp_0631 <= tmp_0629 and tmp_0630;
  tmp_0632 <= '1' when tmp_0631 = '1' else '0';
  tmp_0634 <= '1' when tcp_server_open_busy_sig = '0' else '0';
  tmp_0635 <= '1' when tcp_server_open_req_local = '0' else '0';
  tmp_0636 <= tmp_0634 and tmp_0635;
  tmp_0637 <= '1' when tmp_0636 = '1' else '0';
  tmp_0638 <= X"00000006";
  tmp_0639 <= tcp_server_port(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0640 <= Sn_CR1 + tmp_0639;
  tmp_0642 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0643 <= '1' when write_data_req_local = '0' else '0';
  tmp_0644 <= tmp_0642 and tmp_0643;
  tmp_0645 <= '1' when tmp_0644 = '1' else '0';
  tmp_0647 <= '1' when tcp_server_open_busy_sig = '0' else '0';
  tmp_0648 <= '1' when tcp_server_open_req_local = '0' else '0';
  tmp_0649 <= tmp_0647 and tmp_0648;
  tmp_0650 <= '1' when tmp_0649 = '1' else '0';
  tmp_0652 <= '1' when tcp_server_listen_busy_sig = '0' else '0';
  tmp_0653 <= '1' when tcp_server_listen_req_local = '0' else '0';
  tmp_0654 <= tmp_0652 and tmp_0653;
  tmp_0655 <= '1' when tmp_0654 = '1' else '0';
  tmp_0656 <= X"00000006";
  tmp_0657 <= tcp_server_port(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0658 <= Sn_CR1 + tmp_0657;
  tmp_0660 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0661 <= '1' when write_data_req_local = '0' else '0';
  tmp_0662 <= tmp_0660 and tmp_0661;
  tmp_0663 <= '1' when tmp_0662 = '1' else '0';
  tmp_0665 <= '1' when tcp_server_listen_busy_sig = '0' else '0';
  tmp_0666 <= '1' when tcp_server_listen_req_local = '0' else '0';
  tmp_0667 <= tmp_0665 and tmp_0666;
  tmp_0668 <= '1' when tmp_0667 = '1' else '0';
  tmp_0670 <= '1' when wait_for_established_busy_sig = '0' else '0';
  tmp_0671 <= '1' when wait_for_established_req_local = '0' else '0';
  tmp_0672 <= tmp_0670 and tmp_0671;
  tmp_0673 <= '1' when tmp_0672 = '1' else '0';
  tmp_0675 <= '1' when wait_for_recv_busy_sig = '0' else '0';
  tmp_0676 <= '1' when wait_for_recv_req_local = '0' else '0';
  tmp_0677 <= tmp_0675 and tmp_0676;
  tmp_0678 <= '1' when tmp_0677 = '1' else '0';
  tmp_0680 <= '1' when pull_recv_data_busy_sig = '0' else '0';
  tmp_0681 <= '1' when pull_recv_data_req_local = '0' else '0';
  tmp_0682 <= tmp_0680 and tmp_0681;
  tmp_0683 <= '1' when tmp_0682 = '1' else '0';
  tmp_0685 <= '1' when push_send_data_busy_sig = '0' else '0';
  tmp_0686 <= '1' when push_send_data_req_local = '0' else '0';
  tmp_0687 <= tmp_0685 and tmp_0686;
  tmp_0688 <= '1' when tmp_0687 = '1' else '0';
  tmp_0689 <= test_req_sig or test_req_local;
  tmp_0690 <= '1';
  tmp_0691 <= '1' when tmp_0690 = '1' else '0';
  tmp_0692 <= '1';
  tmp_0693 <= '1' when tmp_0692 = '0' else '0';
  tmp_0694 <= '1' when S_test = S_test_IDLE else '0';
  tmp_0695 <= '0' when tmp_0694 = '1' else '1';
  tmp_0697 <= '1' when init_busy_sig = '0' else '0';
  tmp_0698 <= '1' when init_req_local = '0' else '0';
  tmp_0699 <= tmp_0697 and tmp_0698;
  tmp_0700 <= '1' when tmp_0699 = '1' else '0';
  tmp_0702 <= '1' when network_configuration_busy_sig = '0' else '0';
  tmp_0703 <= '1' when network_configuration_req_local = '0' else '0';
  tmp_0704 <= tmp_0702 and tmp_0703;
  tmp_0705 <= '1' when tmp_0704 = '1' else '0';
  tmp_0706 <= X"00000000";
  tmp_0708 <= '1' when tcp_server_busy_sig = '0' else '0';
  tmp_0709 <= '1' when tcp_server_req_local = '0' else '0';
  tmp_0710 <= tmp_0708 and tmp_0709;
  tmp_0711 <= '1' when tmp_0710 = '1' else '0';
  tmp_0712 <= blink_led_req_sig or blink_led_req_local;
  tmp_0713 <= '1';
  tmp_0714 <= '1' when tmp_0713 = '1' else '0';
  tmp_0715 <= '1';
  tmp_0716 <= '1' when tmp_0715 = '0' else '0';
  tmp_0717 <= X"000f4240";
  tmp_0718 <= '1' when blink_led_i_0 < tmp_0717 else '0';
  tmp_0719 <= '1' when tmp_0718 = '0' else '0';
  tmp_0720 <= X"000f4240";
  tmp_0721 <= '1' when blink_led_i_0 < tmp_0720 else '0';
  tmp_0722 <= '1' when tmp_0721 = '1' else '0';
  tmp_0723 <= X"000000ff";
  tmp_0724 <= '1' when led = tmp_0723 else '0';
  tmp_0725 <= '1' when tmp_0724 = '1' else '0';
  tmp_0726 <= X"000000ff";
  tmp_0727 <= '1' when led = tmp_0726 else '0';
  tmp_0728 <= '1' when tmp_0727 = '0' else '0';
  tmp_0729 <= '1' when S_blink_led = S_blink_led_IDLE else '0';
  tmp_0730 <= '0' when tmp_0729 = '1' else '1';
  tmp_0731 <= X"00000000";
  tmp_0732 <= led + 1;
  tmp_0733 <= X"00000000";
  tmp_0734 <= blink_led_i_0 + 1;

  -- sequencers
  process (clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        S_wait_cycles <= S_wait_cycles_IDLE;
        S_wait_cycles_delay <= (others => '0');
      else
        case (S_wait_cycles) is
          when S_wait_cycles_IDLE => 
            if tmp_0122 = '1' then
              S_wait_cycles <= S_wait_cycles_S_wait_cycles_0004;
            end if;
          when S_wait_cycles_S_wait_cycles_0001 => 
            S_wait_cycles <= S_wait_cycles_IDLE;
          when S_wait_cycles_S_wait_cycles_0002 => 
            if tmp_0124 = '1' then
              S_wait_cycles <= S_wait_cycles_S_wait_cycles_0001;
            elsif tmp_0126 = '1' then
              S_wait_cycles <= S_wait_cycles_S_wait_cycles_0003;
            end if;
          when S_wait_cycles_S_wait_cycles_0003 => 
            S_wait_cycles <= S_wait_cycles_S_wait_cycles_0002;
          when S_wait_cycles_S_wait_cycles_0004 => 
            S_wait_cycles <= S_wait_cycles_S_wait_cycles_0002;
          when others => null;
        end case;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        S_write_data <= S_write_data_IDLE;
        S_write_data_delay <= (others => '0');
      else
        case (S_write_data) is
          when S_write_data_IDLE => 
            if tmp_0131 = '1' then
              S_write_data <= S_write_data_S_write_data_0008;
            end if;
          when S_write_data_S_write_data_0001 => 
            S_write_data <= S_write_data_IDLE;
          when S_write_data_S_write_data_0002 => 
            S_write_data <= S_write_data_S_write_data_0001;
          when S_write_data_S_write_data_0003 => 
            S_write_data <= S_write_data_S_write_data_0002;
          when S_write_data_S_write_data_0004 => 
            if S_write_data_delay >= 1 and wait_cycles_busy_sig_0137 = '1' then
              S_write_data_delay <= (others => '0');
              S_write_data <= S_write_data_S_write_data_0003;
            else
              S_write_data_delay <= S_write_data_delay + 1;
            end if;
          when S_write_data_S_write_data_0005 => 
            S_write_data <= S_write_data_S_write_data_0004;
          when S_write_data_S_write_data_0006 => 
            S_write_data <= S_write_data_S_write_data_0005;
          when S_write_data_S_write_data_0007 => 
            S_write_data <= S_write_data_S_write_data_0006;
          when S_write_data_S_write_data_0008 => 
            S_write_data <= S_write_data_S_write_data_0007;
          when others => null;
        end case;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        S_read_data <= S_read_data_IDLE;
        S_read_data_delay <= (others => '0');
      else
        case (S_read_data) is
          when S_read_data_IDLE => 
            if tmp_0144 = '1' then
              S_read_data <= S_read_data_S_read_data_0009;
            end if;
          when S_read_data_S_read_data_0001 => 
            S_read_data <= S_read_data_IDLE;
          when S_read_data_S_read_data_0002 => 
            S_read_data <= S_read_data_S_read_data_0001;
          when S_read_data_S_read_data_0003 => 
            S_read_data <= S_read_data_S_read_data_0002;
          when S_read_data_S_read_data_0004 => 
            S_read_data <= S_read_data_S_read_data_0003;
          when S_read_data_S_read_data_0005 => 
            S_read_data <= S_read_data_S_read_data_0004;
          when S_read_data_S_read_data_0006 => 
            if S_read_data_delay >= 1 and wait_cycles_busy_sig_0150 = '1' then
              S_read_data_delay <= (others => '0');
              S_read_data <= S_read_data_S_read_data_0005;
            else
              S_read_data_delay <= S_read_data_delay + 1;
            end if;
          when S_read_data_S_read_data_0007 => 
            S_read_data <= S_read_data_S_read_data_0006;
          when S_read_data_S_read_data_0008 => 
            S_read_data <= S_read_data_S_read_data_0007;
          when S_read_data_S_read_data_0009 => 
            S_read_data <= S_read_data_S_read_data_0008;
          when others => null;
        end case;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        S_init <= S_init_IDLE;
        S_init_delay <= (others => '0');
      else
        case (S_init) is
          when S_init_IDLE => 
            if tmp_0157 = '1' then
              S_init <= S_init_S_init_0008;
            end if;
          when S_init_S_init_0001 => 
            S_init <= S_init_IDLE;
          when S_init_S_init_0002 => 
            if S_init_delay >= 1 and wait_cycles_busy_sig_0172 = '1' then
              S_init_delay <= (others => '0');
              S_init <= S_init_S_init_0001;
            else
              S_init_delay <= S_init_delay + 1;
            end if;
          when S_init_S_init_0003 => 
            S_init <= S_init_S_init_0002;
          when S_init_S_init_0004 => 
            if S_init_delay >= 1 and wait_cycles_busy_sig_0165 = '1' then
              S_init_delay <= (others => '0');
              S_init <= S_init_S_init_0003;
            else
              S_init_delay <= S_init_delay + 1;
            end if;
          when S_init_S_init_0005 => 
            S_init <= S_init_S_init_0004;
          when S_init_S_init_0006 => 
            S_init <= S_init_S_init_0005;
          when S_init_S_init_0007 => 
            S_init <= S_init_S_init_0006;
          when S_init_S_init_0008 => 
            S_init <= S_init_S_init_0007;
          when others => null;
        end case;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        S_network_configuration <= S_network_configuration_IDLE;
        S_network_configuration_delay <= (others => '0');
      else
        case (S_network_configuration) is
          when S_network_configuration_IDLE => 
            if tmp_0177 = '1' then
              S_network_configuration <= S_network_configuration_S_network_configuration_0019;
            end if;
          when S_network_configuration_S_network_configuration_0001 => 
            S_network_configuration <= S_network_configuration_IDLE;
          when S_network_configuration_S_network_configuration_0002 => 
            if S_network_configuration_delay >= 1 and write_data_busy_sig_0319 = '1' then
              S_network_configuration_delay <= (others => '0');
              S_network_configuration <= S_network_configuration_S_network_configuration_0001;
            else
              S_network_configuration_delay <= S_network_configuration_delay + 1;
            end if;
          when S_network_configuration_S_network_configuration_0003 => 
            if S_network_configuration_delay >= 1 and write_data_busy_sig_0311 = '1' then
              S_network_configuration_delay <= (others => '0');
              S_network_configuration <= S_network_configuration_S_network_configuration_0002;
            else
              S_network_configuration_delay <= S_network_configuration_delay + 1;
            end if;
          when S_network_configuration_S_network_configuration_0004 => 
            if S_network_configuration_delay >= 1 and write_data_busy_sig_0303 = '1' then
              S_network_configuration_delay <= (others => '0');
              S_network_configuration <= S_network_configuration_S_network_configuration_0003;
            else
              S_network_configuration_delay <= S_network_configuration_delay + 1;
            end if;
          when S_network_configuration_S_network_configuration_0005 => 
            if S_network_configuration_delay >= 1 and write_data_busy_sig_0295 = '1' then
              S_network_configuration_delay <= (others => '0');
              S_network_configuration <= S_network_configuration_S_network_configuration_0004;
            else
              S_network_configuration_delay <= S_network_configuration_delay + 1;
            end if;
          when S_network_configuration_S_network_configuration_0006 => 
            if S_network_configuration_delay >= 1 and write_data_busy_sig_0287 = '1' then
              S_network_configuration_delay <= (others => '0');
              S_network_configuration <= S_network_configuration_S_network_configuration_0005;
            else
              S_network_configuration_delay <= S_network_configuration_delay + 1;
            end if;
          when S_network_configuration_S_network_configuration_0007 => 
            if S_network_configuration_delay >= 1 and write_data_busy_sig_0279 = '1' then
              S_network_configuration_delay <= (others => '0');
              S_network_configuration <= S_network_configuration_S_network_configuration_0006;
            else
              S_network_configuration_delay <= S_network_configuration_delay + 1;
            end if;
          when S_network_configuration_S_network_configuration_0008 => 
            if S_network_configuration_delay >= 1 and write_data_busy_sig_0271 = '1' then
              S_network_configuration_delay <= (others => '0');
              S_network_configuration <= S_network_configuration_S_network_configuration_0007;
            else
              S_network_configuration_delay <= S_network_configuration_delay + 1;
            end if;
          when S_network_configuration_S_network_configuration_0009 => 
            if S_network_configuration_delay >= 1 and write_data_busy_sig_0263 = '1' then
              S_network_configuration_delay <= (others => '0');
              S_network_configuration <= S_network_configuration_S_network_configuration_0008;
            else
              S_network_configuration_delay <= S_network_configuration_delay + 1;
            end if;
          when S_network_configuration_S_network_configuration_0010 => 
            if S_network_configuration_delay >= 1 and write_data_busy_sig_0255 = '1' then
              S_network_configuration_delay <= (others => '0');
              S_network_configuration <= S_network_configuration_S_network_configuration_0009;
            else
              S_network_configuration_delay <= S_network_configuration_delay + 1;
            end if;
          when S_network_configuration_S_network_configuration_0011 => 
            if S_network_configuration_delay >= 1 and write_data_busy_sig_0247 = '1' then
              S_network_configuration_delay <= (others => '0');
              S_network_configuration <= S_network_configuration_S_network_configuration_0010;
            else
              S_network_configuration_delay <= S_network_configuration_delay + 1;
            end if;
          when S_network_configuration_S_network_configuration_0012 => 
            if S_network_configuration_delay >= 1 and write_data_busy_sig_0239 = '1' then
              S_network_configuration_delay <= (others => '0');
              S_network_configuration <= S_network_configuration_S_network_configuration_0011;
            else
              S_network_configuration_delay <= S_network_configuration_delay + 1;
            end if;
          when S_network_configuration_S_network_configuration_0013 => 
            if S_network_configuration_delay >= 1 and write_data_busy_sig_0231 = '1' then
              S_network_configuration_delay <= (others => '0');
              S_network_configuration <= S_network_configuration_S_network_configuration_0012;
            else
              S_network_configuration_delay <= S_network_configuration_delay + 1;
            end if;
          when S_network_configuration_S_network_configuration_0014 => 
            if S_network_configuration_delay >= 1 and write_data_busy_sig_0223 = '1' then
              S_network_configuration_delay <= (others => '0');
              S_network_configuration <= S_network_configuration_S_network_configuration_0013;
            else
              S_network_configuration_delay <= S_network_configuration_delay + 1;
            end if;
          when S_network_configuration_S_network_configuration_0015 => 
            if S_network_configuration_delay >= 1 and write_data_busy_sig_0215 = '1' then
              S_network_configuration_delay <= (others => '0');
              S_network_configuration <= S_network_configuration_S_network_configuration_0014;
            else
              S_network_configuration_delay <= S_network_configuration_delay + 1;
            end if;
          when S_network_configuration_S_network_configuration_0016 => 
            if S_network_configuration_delay >= 1 and write_data_busy_sig_0207 = '1' then
              S_network_configuration_delay <= (others => '0');
              S_network_configuration <= S_network_configuration_S_network_configuration_0015;
            else
              S_network_configuration_delay <= S_network_configuration_delay + 1;
            end if;
          when S_network_configuration_S_network_configuration_0017 => 
            if S_network_configuration_delay >= 1 and write_data_busy_sig_0199 = '1' then
              S_network_configuration_delay <= (others => '0');
              S_network_configuration <= S_network_configuration_S_network_configuration_0016;
            else
              S_network_configuration_delay <= S_network_configuration_delay + 1;
            end if;
          when S_network_configuration_S_network_configuration_0018 => 
            if S_network_configuration_delay >= 1 and write_data_busy_sig_0191 = '1' then
              S_network_configuration_delay <= (others => '0');
              S_network_configuration <= S_network_configuration_S_network_configuration_0017;
            else
              S_network_configuration_delay <= S_network_configuration_delay + 1;
            end if;
          when S_network_configuration_S_network_configuration_0019 => 
            if S_network_configuration_delay >= 1 and write_data_busy_sig_0183 = '1' then
              S_network_configuration_delay <= (others => '0');
              S_network_configuration <= S_network_configuration_S_network_configuration_0018;
            else
              S_network_configuration_delay <= S_network_configuration_delay + 1;
            end if;
          when others => null;
        end case;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        S_tcp_server_open <= S_tcp_server_open_IDLE;
        S_tcp_server_open_delay <= (others => '0');
      else
        case (S_tcp_server_open) is
          when S_tcp_server_open_IDLE => 
            if tmp_0324 = '1' then
              S_tcp_server_open <= S_tcp_server_open_S_tcp_server_open_0006;
            end if;
          when S_tcp_server_open_S_tcp_server_open_0001 => 
            S_tcp_server_open <= S_tcp_server_open_IDLE;
          when S_tcp_server_open_S_tcp_server_open_0002 => 
            if S_tcp_server_open_delay >= 1 and read_data_busy_sig_0366 = '1' then
              S_tcp_server_open_delay <= (others => '0');
              S_tcp_server_open <= S_tcp_server_open_S_tcp_server_open_0001;
            else
              S_tcp_server_open_delay <= S_tcp_server_open_delay + 1;
            end if;
          when S_tcp_server_open_S_tcp_server_open_0003 => 
            if S_tcp_server_open_delay >= 1 and write_data_busy_sig_0358 = '1' then
              S_tcp_server_open_delay <= (others => '0');
              S_tcp_server_open <= S_tcp_server_open_S_tcp_server_open_0002;
            else
              S_tcp_server_open_delay <= S_tcp_server_open_delay + 1;
            end if;
          when S_tcp_server_open_S_tcp_server_open_0004 => 
            if S_tcp_server_open_delay >= 1 and write_data_busy_sig_0350 = '1' then
              S_tcp_server_open_delay <= (others => '0');
              S_tcp_server_open <= S_tcp_server_open_S_tcp_server_open_0003;
            else
              S_tcp_server_open_delay <= S_tcp_server_open_delay + 1;
            end if;
          when S_tcp_server_open_S_tcp_server_open_0005 => 
            if S_tcp_server_open_delay >= 1 and write_data_busy_sig_0340 = '1' then
              S_tcp_server_open_delay <= (others => '0');
              S_tcp_server_open <= S_tcp_server_open_S_tcp_server_open_0004;
            else
              S_tcp_server_open_delay <= S_tcp_server_open_delay + 1;
            end if;
          when S_tcp_server_open_S_tcp_server_open_0006 => 
            if S_tcp_server_open_delay >= 1 and write_data_busy_sig_0330 = '1' then
              S_tcp_server_open_delay <= (others => '0');
              S_tcp_server_open <= S_tcp_server_open_S_tcp_server_open_0005;
            else
              S_tcp_server_open_delay <= S_tcp_server_open_delay + 1;
            end if;
          when others => null;
        end case;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        S_tcp_server_listen <= S_tcp_server_listen_IDLE;
        S_tcp_server_listen_delay <= (others => '0');
      else
        case (S_tcp_server_listen) is
          when S_tcp_server_listen_IDLE => 
            if tmp_0371 = '1' then
              S_tcp_server_listen <= S_tcp_server_listen_S_tcp_server_listen_0003;
            end if;
          when S_tcp_server_listen_S_tcp_server_listen_0001 => 
            S_tcp_server_listen <= S_tcp_server_listen_IDLE;
          when S_tcp_server_listen_S_tcp_server_listen_0002 => 
            if S_tcp_server_listen_delay >= 1 and read_data_busy_sig_0385 = '1' then
              S_tcp_server_listen_delay <= (others => '0');
              S_tcp_server_listen <= S_tcp_server_listen_S_tcp_server_listen_0001;
            else
              S_tcp_server_listen_delay <= S_tcp_server_listen_delay + 1;
            end if;
          when S_tcp_server_listen_S_tcp_server_listen_0003 => 
            if S_tcp_server_listen_delay >= 1 and write_data_busy_sig_0377 = '1' then
              S_tcp_server_listen_delay <= (others => '0');
              S_tcp_server_listen <= S_tcp_server_listen_S_tcp_server_listen_0002;
            else
              S_tcp_server_listen_delay <= S_tcp_server_listen_delay + 1;
            end if;
          when others => null;
        end case;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        S_wait_for_established <= S_wait_for_established_IDLE;
        S_wait_for_established_delay <= (others => '0');
      else
        case (S_wait_for_established) is
          when S_wait_for_established_IDLE => 
            if tmp_0390 = '1' then
              S_wait_for_established <= S_wait_for_established_S_wait_for_established_0002;
            end if;
          when S_wait_for_established_S_wait_for_established_0001 => 
            S_wait_for_established <= S_wait_for_established_IDLE;
          when S_wait_for_established_S_wait_for_established_0002 => 
            if tmp_0392 = '1' then
              S_wait_for_established <= S_wait_for_established_S_wait_for_established_0005;
            elsif tmp_0394 = '1' then
              S_wait_for_established <= S_wait_for_established_S_wait_for_established_0001;
            end if;
          when S_wait_for_established_S_wait_for_established_0003 => 
            S_wait_for_established <= S_wait_for_established_S_wait_for_established_0001;
          when S_wait_for_established_S_wait_for_established_0004 => 
            if tmp_0396 = '1' then
              S_wait_for_established <= S_wait_for_established_S_wait_for_established_0003;
            elsif tmp_0398 = '1' then
              S_wait_for_established <= S_wait_for_established_S_wait_for_established_0002;
            end if;
          when S_wait_for_established_S_wait_for_established_0005 => 
            if S_wait_for_established_delay >= 1 and read_data_busy_sig_0404 = '1' then
              S_wait_for_established_delay <= (others => '0');
              S_wait_for_established <= S_wait_for_established_S_wait_for_established_0004;
            else
              S_wait_for_established_delay <= S_wait_for_established_delay + 1;
            end if;
          when others => null;
        end case;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        S_wait_for_recv <= S_wait_for_recv_IDLE;
        S_wait_for_recv_delay <= (others => '0');
      else
        case (S_wait_for_recv) is
          when S_wait_for_recv_IDLE => 
            if tmp_0409 = '1' then
              S_wait_for_recv <= S_wait_for_recv_S_wait_for_recv_0010;
            end if;
          when S_wait_for_recv_S_wait_for_recv_0001 => 
            S_wait_for_recv <= S_wait_for_recv_IDLE;
          when S_wait_for_recv_S_wait_for_recv_0002 => 
            if tmp_0411 = '1' then
              S_wait_for_recv <= S_wait_for_recv_S_wait_for_recv_0009;
            elsif tmp_0413 = '1' then
              S_wait_for_recv <= S_wait_for_recv_S_wait_for_recv_0001;
            end if;
          when S_wait_for_recv_S_wait_for_recv_0003 => 
            S_wait_for_recv <= S_wait_for_recv_S_wait_for_recv_0001;
          when S_wait_for_recv_S_wait_for_recv_0004 => 
            if tmp_0416 = '1' then
              S_wait_for_recv <= S_wait_for_recv_S_wait_for_recv_0003;
            elsif tmp_0419 = '1' then
              S_wait_for_recv <= S_wait_for_recv_S_wait_for_recv_0002;
            end if;
          when S_wait_for_recv_S_wait_for_recv_0005 => 
            S_wait_for_recv <= S_wait_for_recv_S_wait_for_recv_0004;
          when S_wait_for_recv_S_wait_for_recv_0006 => 
            if S_wait_for_recv_delay >= 1 and read_data_busy_sig_0445 = '1' then
              S_wait_for_recv_delay <= (others => '0');
              S_wait_for_recv <= S_wait_for_recv_S_wait_for_recv_0005;
            else
              S_wait_for_recv_delay <= S_wait_for_recv_delay + 1;
            end if;
          when S_wait_for_recv_S_wait_for_recv_0007 => 
            if S_wait_for_recv_delay >= 1 and read_data_busy_sig_0436 = '1' then
              S_wait_for_recv_delay <= (others => '0');
              S_wait_for_recv <= S_wait_for_recv_S_wait_for_recv_0006;
            else
              S_wait_for_recv_delay <= S_wait_for_recv_delay + 1;
            end if;
          when S_wait_for_recv_S_wait_for_recv_0008 => 
            if S_wait_for_recv_delay >= 1 and read_data_busy_sig_0427 = '1' then
              S_wait_for_recv_delay <= (others => '0');
              S_wait_for_recv <= S_wait_for_recv_S_wait_for_recv_0007;
            else
              S_wait_for_recv_delay <= S_wait_for_recv_delay + 1;
            end if;
          when S_wait_for_recv_S_wait_for_recv_0009 => 
            S_wait_for_recv <= S_wait_for_recv_S_wait_for_recv_0008;
          when S_wait_for_recv_S_wait_for_recv_0010 => 
            S_wait_for_recv <= S_wait_for_recv_S_wait_for_recv_0002;
          when others => null;
        end case;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        S_pull_recv_data <= S_pull_recv_data_IDLE;
        S_pull_recv_data_delay <= (others => '0');
      else
        case (S_pull_recv_data) is
          when S_pull_recv_data_IDLE => 
            if tmp_0457 = '1' then
              S_pull_recv_data <= S_pull_recv_data_S_pull_recv_data_0012;
            end if;
          when S_pull_recv_data_S_pull_recv_data_0001 => 
            S_pull_recv_data <= S_pull_recv_data_IDLE;
          when S_pull_recv_data_S_pull_recv_data_0002 => 
            if S_pull_recv_data_delay >= 1 and write_data_busy_sig_0507 = '1' then
              S_pull_recv_data_delay <= (others => '0');
              S_pull_recv_data <= S_pull_recv_data_S_pull_recv_data_0001;
            else
              S_pull_recv_data_delay <= S_pull_recv_data_delay + 1;
            end if;
          when S_pull_recv_data_S_pull_recv_data_0003 => 
            if tmp_0459 = '1' then
              S_pull_recv_data <= S_pull_recv_data_S_pull_recv_data_0002;
            elsif tmp_0461 = '1' then
              S_pull_recv_data <= S_pull_recv_data_S_pull_recv_data_0008;
            end if;
          when S_pull_recv_data_S_pull_recv_data_0004 => 
            S_pull_recv_data <= S_pull_recv_data_S_pull_recv_data_0003;
          when S_pull_recv_data_S_pull_recv_data_0005 => 
            S_pull_recv_data <= S_pull_recv_data_S_pull_recv_data_0004;
          when S_pull_recv_data_S_pull_recv_data_0006 => 
            if S_pull_recv_data_delay >= 1 and read_data_busy_sig_0494 = '1' then
              S_pull_recv_data_delay <= (others => '0');
              S_pull_recv_data <= S_pull_recv_data_S_pull_recv_data_0005;
            else
              S_pull_recv_data_delay <= S_pull_recv_data_delay + 1;
            end if;
          when S_pull_recv_data_S_pull_recv_data_0007 => 
            S_pull_recv_data <= S_pull_recv_data_S_pull_recv_data_0006;
          when S_pull_recv_data_S_pull_recv_data_0008 => 
            if S_pull_recv_data_delay >= 1 and read_data_busy_sig_0482 = '1' then
              S_pull_recv_data_delay <= (others => '0');
              S_pull_recv_data <= S_pull_recv_data_S_pull_recv_data_0007;
            else
              S_pull_recv_data_delay <= S_pull_recv_data_delay + 1;
            end if;
          when S_pull_recv_data_S_pull_recv_data_0009 => 
            S_pull_recv_data <= S_pull_recv_data_S_pull_recv_data_0003;
          when S_pull_recv_data_S_pull_recv_data_0010 => 
            S_pull_recv_data <= S_pull_recv_data_S_pull_recv_data_0009;
          when S_pull_recv_data_S_pull_recv_data_0011 => 
            if tmp_0466 = '1' then
              S_pull_recv_data <= S_pull_recv_data_S_pull_recv_data_0010;
            elsif tmp_0471 = '1' then
              S_pull_recv_data <= S_pull_recv_data_S_pull_recv_data_0009;
            end if;
          when S_pull_recv_data_S_pull_recv_data_0012 => 
            S_pull_recv_data <= S_pull_recv_data_S_pull_recv_data_0011;
          when others => null;
        end case;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        S_push_send_data <= S_push_send_data_IDLE;
        S_push_send_data_delay <= (others => '0');
      else
        case (S_push_send_data) is
          when S_push_send_data_IDLE => 
            if tmp_0512 = '1' then
              S_push_send_data <= S_push_send_data_S_push_send_data_0016;
            end if;
          when S_push_send_data_S_push_send_data_0001 => 
            S_push_send_data <= S_push_send_data_IDLE;
          when S_push_send_data_S_push_send_data_0002 => 
            if S_push_send_data_delay >= 1 and write_data_busy_sig_0603 = '1' then
              S_push_send_data_delay <= (others => '0');
              S_push_send_data <= S_push_send_data_S_push_send_data_0001;
            else
              S_push_send_data_delay <= S_push_send_data_delay + 1;
            end if;
          when S_push_send_data_S_push_send_data_0003 => 
            if S_push_send_data_delay >= 1 and write_data_busy_sig_0595 = '1' then
              S_push_send_data_delay <= (others => '0');
              S_push_send_data <= S_push_send_data_S_push_send_data_0002;
            else
              S_push_send_data_delay <= S_push_send_data_delay + 1;
            end if;
          when S_push_send_data_S_push_send_data_0004 => 
            if S_push_send_data_delay >= 1 and write_data_busy_sig_0584 = '1' then
              S_push_send_data_delay <= (others => '0');
              S_push_send_data <= S_push_send_data_S_push_send_data_0003;
            else
              S_push_send_data_delay <= S_push_send_data_delay + 1;
            end if;
          when S_push_send_data_S_push_send_data_0005 => 
            if S_push_send_data_delay >= 1 and write_data_busy_sig_0573 = '1' then
              S_push_send_data_delay <= (others => '0');
              S_push_send_data <= S_push_send_data_S_push_send_data_0004;
            else
              S_push_send_data_delay <= S_push_send_data_delay + 1;
            end if;
          when S_push_send_data_S_push_send_data_0006 => 
            if S_push_send_data_delay >= 1 and write_data_busy_sig_0562 = '1' then
              S_push_send_data_delay <= (others => '0');
              S_push_send_data <= S_push_send_data_S_push_send_data_0005;
            else
              S_push_send_data_delay <= S_push_send_data_delay + 1;
            end if;
          when S_push_send_data_S_push_send_data_0007 => 
            if tmp_0514 = '1' then
              S_push_send_data <= S_push_send_data_S_push_send_data_0006;
            elsif tmp_0516 = '1' then
              S_push_send_data <= S_push_send_data_S_push_send_data_0012;
            end if;
          when S_push_send_data_S_push_send_data_0008 => 
            S_push_send_data <= S_push_send_data_S_push_send_data_0007;
          when S_push_send_data_S_push_send_data_0009 => 
            if S_push_send_data_delay >= 1 and write_data_busy_sig_0553 = '1' then
              S_push_send_data_delay <= (others => '0');
              S_push_send_data <= S_push_send_data_S_push_send_data_0008;
            else
              S_push_send_data_delay <= S_push_send_data_delay + 1;
            end if;
          when S_push_send_data_S_push_send_data_0010 => 
            if S_push_send_data_delay >= 2 then
              S_push_send_data_delay <= (others => '0');
              S_push_send_data <= S_push_send_data_S_push_send_data_0009;
            else
              S_push_send_data_delay <= S_push_send_data_delay + 1;
            end if;
          when S_push_send_data_S_push_send_data_0011 => 
            if S_push_send_data_delay >= 1 and write_data_busy_sig_0541 = '1' then
              S_push_send_data_delay <= (others => '0');
              S_push_send_data <= S_push_send_data_S_push_send_data_0010;
            else
              S_push_send_data_delay <= S_push_send_data_delay + 1;
            end if;
          when S_push_send_data_S_push_send_data_0012 => 
            if S_push_send_data_delay >= 2 then
              S_push_send_data_delay <= (others => '0');
              S_push_send_data <= S_push_send_data_S_push_send_data_0011;
            else
              S_push_send_data_delay <= S_push_send_data_delay + 1;
            end if;
          when S_push_send_data_S_push_send_data_0013 => 
            S_push_send_data <= S_push_send_data_S_push_send_data_0007;
          when S_push_send_data_S_push_send_data_0014 => 
            S_push_send_data <= S_push_send_data_S_push_send_data_0013;
          when S_push_send_data_S_push_send_data_0015 => 
            if tmp_0521 = '1' then
              S_push_send_data <= S_push_send_data_S_push_send_data_0014;
            elsif tmp_0526 = '1' then
              S_push_send_data <= S_push_send_data_S_push_send_data_0013;
            end if;
          when S_push_send_data_S_push_send_data_0016 => 
            S_push_send_data <= S_push_send_data_S_push_send_data_0015;
          when others => null;
        end case;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        S_tcp_server <= S_tcp_server_IDLE;
        S_tcp_server_delay <= (others => '0');
      else
        case (S_tcp_server) is
          when S_tcp_server_IDLE => 
            if tmp_0608 = '1' then
              S_tcp_server <= S_tcp_server_S_tcp_server_0015;
            end if;
          when S_tcp_server_S_tcp_server_0001 => 
            S_tcp_server <= S_tcp_server_IDLE;
          when S_tcp_server_S_tcp_server_0002 => 
            if tmp_0610 = '1' then
              S_tcp_server <= S_tcp_server_S_tcp_server_0005;
            elsif tmp_0612 = '1' then
              S_tcp_server <= S_tcp_server_S_tcp_server_0001;
            end if;
          when S_tcp_server_S_tcp_server_0003 => 
            if S_tcp_server_delay >= 1 and push_send_data_busy_sig_0684 = '1' then
              S_tcp_server_delay <= (others => '0');
              S_tcp_server <= S_tcp_server_S_tcp_server_0002;
            else
              S_tcp_server_delay <= S_tcp_server_delay + 1;
            end if;
          when S_tcp_server_S_tcp_server_0004 => 
            if S_tcp_server_delay >= 1 and pull_recv_data_busy_sig_0679 = '1' then
              S_tcp_server_delay <= (others => '0');
              S_tcp_server <= S_tcp_server_S_tcp_server_0003;
            else
              S_tcp_server_delay <= S_tcp_server_delay + 1;
            end if;
          when S_tcp_server_S_tcp_server_0005 => 
            if S_tcp_server_delay >= 1 and wait_for_recv_busy_sig_0674 = '1' then
              S_tcp_server_delay <= (others => '0');
              S_tcp_server <= S_tcp_server_S_tcp_server_0004;
            else
              S_tcp_server_delay <= S_tcp_server_delay + 1;
            end if;
          when S_tcp_server_S_tcp_server_0006 => 
            if S_tcp_server_delay >= 1 and wait_for_established_busy_sig_0669 = '1' then
              S_tcp_server_delay <= (others => '0');
              S_tcp_server <= S_tcp_server_S_tcp_server_0002;
            else
              S_tcp_server_delay <= S_tcp_server_delay + 1;
            end if;
          when S_tcp_server_S_tcp_server_0007 => 
            if tmp_0614 = '1' then
              S_tcp_server <= S_tcp_server_S_tcp_server_0009;
            elsif tmp_0616 = '1' then
              S_tcp_server <= S_tcp_server_S_tcp_server_0006;
            end if;
          when S_tcp_server_S_tcp_server_0008 => 
            if S_tcp_server_delay >= 1 and tcp_server_listen_busy_sig_0664 = '1' then
              S_tcp_server_delay <= (others => '0');
              S_tcp_server <= S_tcp_server_S_tcp_server_0007;
            else
              S_tcp_server_delay <= S_tcp_server_delay + 1;
            end if;
          when S_tcp_server_S_tcp_server_0009 => 
            if S_tcp_server_delay >= 1 and write_data_busy_sig_0659 = '1' then
              S_tcp_server_delay <= (others => '0');
              S_tcp_server <= S_tcp_server_S_tcp_server_0008;
            else
              S_tcp_server_delay <= S_tcp_server_delay + 1;
            end if;
          when S_tcp_server_S_tcp_server_0010 => 
            if S_tcp_server_delay >= 1 and tcp_server_listen_busy_sig_0651 = '1' then
              S_tcp_server_delay <= (others => '0');
              S_tcp_server <= S_tcp_server_S_tcp_server_0007;
            else
              S_tcp_server_delay <= S_tcp_server_delay + 1;
            end if;
          when S_tcp_server_S_tcp_server_0011 => 
            if tmp_0618 = '1' then
              S_tcp_server <= S_tcp_server_S_tcp_server_0013;
            elsif tmp_0620 = '1' then
              S_tcp_server <= S_tcp_server_S_tcp_server_0010;
            end if;
          when S_tcp_server_S_tcp_server_0012 => 
            if S_tcp_server_delay >= 1 and tcp_server_open_busy_sig_0646 = '1' then
              S_tcp_server_delay <= (others => '0');
              S_tcp_server <= S_tcp_server_S_tcp_server_0011;
            else
              S_tcp_server_delay <= S_tcp_server_delay + 1;
            end if;
          when S_tcp_server_S_tcp_server_0013 => 
            if S_tcp_server_delay >= 1 and write_data_busy_sig_0641 = '1' then
              S_tcp_server_delay <= (others => '0');
              S_tcp_server <= S_tcp_server_S_tcp_server_0012;
            else
              S_tcp_server_delay <= S_tcp_server_delay + 1;
            end if;
          when S_tcp_server_S_tcp_server_0014 => 
            if S_tcp_server_delay >= 1 and tcp_server_open_busy_sig_0633 = '1' then
              S_tcp_server_delay <= (others => '0');
              S_tcp_server <= S_tcp_server_S_tcp_server_0011;
            else
              S_tcp_server_delay <= S_tcp_server_delay + 1;
            end if;
          when S_tcp_server_S_tcp_server_0015 => 
            if S_tcp_server_delay >= 1 and write_data_busy_sig_0628 = '1' then
              S_tcp_server_delay <= (others => '0');
              S_tcp_server <= S_tcp_server_S_tcp_server_0014;
            else
              S_tcp_server_delay <= S_tcp_server_delay + 1;
            end if;
          when others => null;
        end case;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        S_test <= S_test_IDLE;
        S_test_delay <= (others => '0');
      else
        case (S_test) is
          when S_test_IDLE => 
            if tmp_0689 = '1' then
              S_test <= S_test_S_test_0005;
            end if;
          when S_test_S_test_0001 => 
            S_test <= S_test_IDLE;
          when S_test_S_test_0002 => 
            if tmp_0691 = '1' then
              S_test <= S_test_S_test_0002;
            elsif tmp_0693 = '1' then
              S_test <= S_test_S_test_0001;
            end if;
          when S_test_S_test_0003 => 
            if S_test_delay >= 1 and tcp_server_busy_sig_0707 = '1' then
              S_test_delay <= (others => '0');
              S_test <= S_test_S_test_0002;
            else
              S_test_delay <= S_test_delay + 1;
            end if;
          when S_test_S_test_0004 => 
            if S_test_delay >= 1 and network_configuration_busy_sig_0701 = '1' then
              S_test_delay <= (others => '0');
              S_test <= S_test_S_test_0003;
            else
              S_test_delay <= S_test_delay + 1;
            end if;
          when S_test_S_test_0005 => 
            if S_test_delay >= 1 and init_busy_sig_0696 = '1' then
              S_test_delay <= (others => '0');
              S_test <= S_test_S_test_0004;
            else
              S_test_delay <= S_test_delay + 1;
            end if;
          when others => null;
        end case;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        S_blink_led <= S_blink_led_IDLE;
        S_blink_led_delay <= (others => '0');
      else
        case (S_blink_led) is
          when S_blink_led_IDLE => 
            if tmp_0712 = '1' then
              S_blink_led <= S_blink_led_S_blink_led_0002;
            end if;
          when S_blink_led_S_blink_led_0001 => 
            S_blink_led <= S_blink_led_IDLE;
          when S_blink_led_S_blink_led_0002 => 
            if tmp_0714 = '1' then
              S_blink_led <= S_blink_led_S_blink_led_0007;
            elsif tmp_0716 = '1' then
              S_blink_led <= S_blink_led_S_blink_led_0001;
            end if;
          when S_blink_led_S_blink_led_0003 => 
            if tmp_0719 = '1' then
              S_blink_led <= S_blink_led_S_blink_led_0002;
            elsif tmp_0722 = '1' then
              S_blink_led <= S_blink_led_S_blink_led_0004;
            end if;
          when S_blink_led_S_blink_led_0004 => 
            S_blink_led <= S_blink_led_S_blink_led_0003;
          when S_blink_led_S_blink_led_0005 => 
            S_blink_led <= S_blink_led_S_blink_led_0003;
          when S_blink_led_S_blink_led_0006 => 
            S_blink_led <= S_blink_led_S_blink_led_0005;
          when S_blink_led_S_blink_led_0007 => 
            if tmp_0725 = '1' then
              S_blink_led <= S_blink_led_S_blink_led_0006;
            elsif tmp_0728 = '1' then
              S_blink_led <= S_blink_led_S_blink_led_0008;
            end if;
          when S_blink_led_S_blink_led_0008 => 
            S_blink_led <= S_blink_led_S_blink_led_0005;
          when others => null;
        end case;
      end if;
    end if;
  end process;


  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        led <= (others => '0');
      else
        if S_blink_led = S_blink_led_S_blink_led_0006 then
          led <= tmp_0731;
        elsif S_blink_led = S_blink_led_S_blink_led_0008 then
          led <= tmp_0732;
        else
          led <= tmp_0001;
        end if;
      end if;
    end if;
  end process;

  buffer_clk <= clk_sig;

  buffer_reset <= reset_sig;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        buffer_address_b <= (others => '0');
      else
        if S_pull_recv_data = S_pull_recv_data_S_pull_recv_data_0007 then
          buffer_address_b <= tmp_0490;
        elsif S_pull_recv_data = S_pull_recv_data_S_pull_recv_data_0005 then
          buffer_address_b <= tmp_0502;
        elsif S_push_send_data = S_push_send_data_S_push_send_data_0012 and S_push_send_data_delay = 0 then
          buffer_address_b <= tmp_0537;
        elsif S_push_send_data = S_push_send_data_S_push_send_data_0010 and S_push_send_data_delay = 0 then
          buffer_address_b <= tmp_0549;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        buffer_din_b <= (others => '0');
      else
        if S_pull_recv_data = S_pull_recv_data_S_pull_recv_data_0007 then
          buffer_din_b <= pull_recv_data_tmp_0000_3;
        elsif S_pull_recv_data = S_pull_recv_data_S_pull_recv_data_0005 then
          buffer_din_b <= pull_recv_data_tmp_0001_2;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        buffer_we_b <= '0';
      else
        if S_pull_recv_data = S_pull_recv_data_S_pull_recv_data_0007 then
          buffer_we_b <= '1';
        elsif S_pull_recv_data = S_pull_recv_data_S_pull_recv_data_0005 then
          buffer_we_b <= '1';
        elsif S_push_send_data = S_push_send_data_S_push_send_data_0012 and S_push_send_data_delay >= 2 then
          buffer_we_b <= '0';
        elsif S_push_send_data = S_push_send_data_S_push_send_data_0010 and S_push_send_data_delay >= 2 then
          buffer_we_b <= '0';
        else
          buffer_we_b <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        buffer_oe_b <= '0';
      else
        if S_push_send_data = S_push_send_data_S_push_send_data_0012 and S_push_send_data_delay = 0 then
          buffer_oe_b <= '1';
        elsif S_push_send_data = S_push_send_data_S_push_send_data_0010 and S_push_send_data_delay = 0 then
          buffer_oe_b <= '1';
        else
          buffer_oe_b <= '0';
        end if;
      end if;
    end if;
  end process;

  wiz830mj_clk <= clk_sig;

  wiz830mj_reset <= reset_sig;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wiz830mj_address <= (others => '0');
      else
        if S_write_data = S_write_data_S_write_data_0008 then
          wiz830mj_address <= std_logic_vector(write_data_addr);
        elsif S_read_data = S_read_data_S_read_data_0009 then
          wiz830mj_address <= std_logic_vector(read_data_addr);
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wiz830mj_wdata <= (others => '0');
      else
        if S_write_data = S_write_data_S_write_data_0007 then
          wiz830mj_wdata <= std_logic_vector(write_data_data);
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wiz830mj_cs <= '0';
      else
        if S_write_data = S_write_data_S_write_data_0006 then
          wiz830mj_cs <= tmp_0134;
        elsif S_write_data = S_write_data_S_write_data_0002 then
          wiz830mj_cs <= tmp_0143;
        elsif S_read_data = S_read_data_S_read_data_0008 then
          wiz830mj_cs <= tmp_0147;
        elsif S_read_data = S_read_data_S_read_data_0003 then
          wiz830mj_cs <= tmp_0156;
        elsif S_init = S_init_S_init_0008 then
          wiz830mj_cs <= tmp_0160;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wiz830mj_oe <= '0';
      else
        if S_read_data = S_read_data_S_read_data_0007 then
          wiz830mj_oe <= tmp_0148;
        elsif S_read_data = S_read_data_S_read_data_0004 then
          wiz830mj_oe <= tmp_0155;
        elsif S_init = S_init_S_init_0006 then
          wiz830mj_oe <= tmp_0162;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wiz830mj_we <= '0';
      else
        if S_write_data = S_write_data_S_write_data_0005 then
          wiz830mj_we <= tmp_0135;
        elsif S_write_data = S_write_data_S_write_data_0003 then
          wiz830mj_we <= tmp_0142;
        elsif S_init = S_init_S_init_0007 then
          wiz830mj_we <= tmp_0161;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wiz830mj_module_reset <= '0';
      else
        if S_init = S_init_S_init_0005 then
          wiz830mj_module_reset <= tmp_0163;
        elsif S_init = S_init_S_init_0003 then
          wiz830mj_module_reset <= tmp_0170;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_cycles_i_1 <= X"00000000";
      else
        if S_wait_cycles = S_wait_cycles_S_wait_cycles_0004 then
          wait_cycles_i_1 <= tmp_0129;
        elsif S_wait_cycles = S_wait_cycles_S_wait_cycles_0003 then
          wait_cycles_i_1 <= tmp_0130;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pull_recv_data_i_4 <= X"00000000";
      else
        if S_pull_recv_data = S_pull_recv_data_S_pull_recv_data_0009 then
          pull_recv_data_i_4 <= tmp_0478;
        elsif S_pull_recv_data = S_pull_recv_data_S_pull_recv_data_0004 then
          pull_recv_data_i_4 <= tmp_0503;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pull_recv_data_tmp_0001_2 <= (others => '0');
      else
        if S_pull_recv_data = S_pull_recv_data_S_pull_recv_data_0006 and S_pull_recv_data_delay >= 1 and read_data_busy_sig_0494 = '1' then
          pull_recv_data_tmp_0001_2 <= read_data_return_sig;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pull_recv_data_tmp_0000_3 <= (others => '0');
      else
        if S_pull_recv_data = S_pull_recv_data_S_pull_recv_data_0008 and S_pull_recv_data_delay >= 1 and read_data_busy_sig_0482 = '1' then
          pull_recv_data_tmp_0000_3 <= read_data_return_sig;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        push_send_data_v_2 <= (others => '0');
      else
        if S_push_send_data = S_push_send_data_S_push_send_data_0012 and S_push_send_data_delay >= 2 then
          push_send_data_v_2 <= buffer_dout_b;
        elsif S_push_send_data = S_push_send_data_S_push_send_data_0010 and S_push_send_data_delay >= 2 then
          push_send_data_v_2 <= buffer_dout_b;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        push_send_data_i_3 <= X"00000000";
      else
        if S_push_send_data = S_push_send_data_S_push_send_data_0013 then
          push_send_data_i_3 <= tmp_0533;
        elsif S_push_send_data = S_push_send_data_S_push_send_data_0008 then
          push_send_data_i_3 <= tmp_0558;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        blink_led_i_0 <= X"00000000";
      else
        if S_blink_led = S_blink_led_S_blink_led_0005 then
          blink_led_i_0 <= tmp_0733;
        elsif S_blink_led = S_blink_led_S_blink_led_0004 then
          blink_led_i_0 <= tmp_0734;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_cycles_n <= (others => '0');
      else
        if S_write_data = S_write_data_S_write_data_0004 and S_write_data_delay = 0 then
          wait_cycles_n <= tmp_0136;
        elsif S_read_data = S_read_data_S_read_data_0006 and S_read_data_delay = 0 then
          wait_cycles_n <= tmp_0149;
        elsif S_init = S_init_S_init_0004 and S_init_delay = 0 then
          wait_cycles_n <= tmp_0164;
        elsif S_init = S_init_S_init_0002 and S_init_delay = 0 then
          wait_cycles_n <= tmp_0171;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_cycles_req_local <= '0';
      else
        if S_write_data = S_write_data_S_write_data_0004 and S_write_data_delay = 0 then
          wait_cycles_req_local <= '1';
        elsif S_read_data = S_read_data_S_read_data_0006 and S_read_data_delay = 0 then
          wait_cycles_req_local <= '1';
        elsif S_init = S_init_S_init_0004 and S_init_delay = 0 then
          wait_cycles_req_local <= '1';
        elsif S_init = S_init_S_init_0002 and S_init_delay = 0 then
          wait_cycles_req_local <= '1';
        else
          wait_cycles_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  wait_cycles_busy_sig <= tmp_0128;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        write_data_addr <= (others => '0');
      else
        if S_network_configuration = S_network_configuration_S_network_configuration_0019 and S_network_configuration_delay = 0 then
          write_data_addr <= tmp_0180;
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0018 and S_network_configuration_delay = 0 then
          write_data_addr <= tmp_0188;
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0017 and S_network_configuration_delay = 0 then
          write_data_addr <= tmp_0196;
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0016 and S_network_configuration_delay = 0 then
          write_data_addr <= tmp_0204;
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0015 and S_network_configuration_delay = 0 then
          write_data_addr <= tmp_0212;
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0014 and S_network_configuration_delay = 0 then
          write_data_addr <= tmp_0220;
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0013 and S_network_configuration_delay = 0 then
          write_data_addr <= tmp_0228;
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0012 and S_network_configuration_delay = 0 then
          write_data_addr <= tmp_0236;
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0011 and S_network_configuration_delay = 0 then
          write_data_addr <= tmp_0244;
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0010 and S_network_configuration_delay = 0 then
          write_data_addr <= tmp_0252;
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0009 and S_network_configuration_delay = 0 then
          write_data_addr <= tmp_0260;
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0008 and S_network_configuration_delay = 0 then
          write_data_addr <= tmp_0268;
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0007 and S_network_configuration_delay = 0 then
          write_data_addr <= tmp_0276;
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0006 and S_network_configuration_delay = 0 then
          write_data_addr <= tmp_0284;
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0005 and S_network_configuration_delay = 0 then
          write_data_addr <= tmp_0292;
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0004 and S_network_configuration_delay = 0 then
          write_data_addr <= tmp_0300;
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0003 and S_network_configuration_delay = 0 then
          write_data_addr <= tmp_0308;
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0002 and S_network_configuration_delay = 0 then
          write_data_addr <= tmp_0316;
        elsif S_tcp_server_open = S_tcp_server_open_S_tcp_server_open_0006 and S_tcp_server_open_delay = 0 then
          write_data_addr <= tmp_0329;
        elsif S_tcp_server_open = S_tcp_server_open_S_tcp_server_open_0005 and S_tcp_server_open_delay = 0 then
          write_data_addr <= tmp_0337;
        elsif S_tcp_server_open = S_tcp_server_open_S_tcp_server_open_0004 and S_tcp_server_open_delay = 0 then
          write_data_addr <= tmp_0347;
        elsif S_tcp_server_open = S_tcp_server_open_S_tcp_server_open_0003 and S_tcp_server_open_delay = 0 then
          write_data_addr <= tmp_0357;
        elsif S_tcp_server_listen = S_tcp_server_listen_S_tcp_server_listen_0003 and S_tcp_server_listen_delay = 0 then
          write_data_addr <= tmp_0376;
        elsif S_pull_recv_data = S_pull_recv_data_S_pull_recv_data_0002 and S_pull_recv_data_delay = 0 then
          write_data_addr <= tmp_0506;
        elsif S_push_send_data = S_push_send_data_S_push_send_data_0011 and S_push_send_data_delay = 0 then
          write_data_addr <= tmp_0540;
        elsif S_push_send_data = S_push_send_data_S_push_send_data_0009 and S_push_send_data_delay = 0 then
          write_data_addr <= tmp_0552;
        elsif S_push_send_data = S_push_send_data_S_push_send_data_0006 and S_push_send_data_delay = 0 then
          write_data_addr <= tmp_0561;
        elsif S_push_send_data = S_push_send_data_S_push_send_data_0005 and S_push_send_data_delay = 0 then
          write_data_addr <= tmp_0569;
        elsif S_push_send_data = S_push_send_data_S_push_send_data_0004 and S_push_send_data_delay = 0 then
          write_data_addr <= tmp_0580;
        elsif S_push_send_data = S_push_send_data_S_push_send_data_0003 and S_push_send_data_delay = 0 then
          write_data_addr <= tmp_0591;
        elsif S_push_send_data = S_push_send_data_S_push_send_data_0002 and S_push_send_data_delay = 0 then
          write_data_addr <= tmp_0602;
        elsif S_tcp_server = S_tcp_server_S_tcp_server_0015 and S_tcp_server_delay = 0 then
          write_data_addr <= tmp_0625;
        elsif S_tcp_server = S_tcp_server_S_tcp_server_0013 and S_tcp_server_delay = 0 then
          write_data_addr <= tmp_0640;
        elsif S_tcp_server = S_tcp_server_S_tcp_server_0009 and S_tcp_server_delay = 0 then
          write_data_addr <= tmp_0658;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        write_data_data <= (others => '0');
      else
        if S_network_configuration = S_network_configuration_S_network_configuration_0019 and S_network_configuration_delay = 0 then
          write_data_data <= tmp_0182;
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0018 and S_network_configuration_delay = 0 then
          write_data_data <= tmp_0190;
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0017 and S_network_configuration_delay = 0 then
          write_data_data <= tmp_0198;
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0016 and S_network_configuration_delay = 0 then
          write_data_data <= tmp_0206;
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0015 and S_network_configuration_delay = 0 then
          write_data_data <= tmp_0214;
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0014 and S_network_configuration_delay = 0 then
          write_data_data <= tmp_0222;
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0013 and S_network_configuration_delay = 0 then
          write_data_data <= tmp_0230;
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0012 and S_network_configuration_delay = 0 then
          write_data_data <= tmp_0238;
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0011 and S_network_configuration_delay = 0 then
          write_data_data <= tmp_0246;
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0010 and S_network_configuration_delay = 0 then
          write_data_data <= tmp_0254;
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0009 and S_network_configuration_delay = 0 then
          write_data_data <= tmp_0262;
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0008 and S_network_configuration_delay = 0 then
          write_data_data <= tmp_0270;
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0007 and S_network_configuration_delay = 0 then
          write_data_data <= tmp_0278;
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0006 and S_network_configuration_delay = 0 then
          write_data_data <= tmp_0286;
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0005 and S_network_configuration_delay = 0 then
          write_data_data <= tmp_0294;
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0004 and S_network_configuration_delay = 0 then
          write_data_data <= tmp_0302;
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0003 and S_network_configuration_delay = 0 then
          write_data_data <= tmp_0310;
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0002 and S_network_configuration_delay = 0 then
          write_data_data <= tmp_0318;
        elsif S_tcp_server_open = S_tcp_server_open_S_tcp_server_open_0006 and S_tcp_server_open_delay = 0 then
          write_data_data <= Sn_MR_TCP;
        elsif S_tcp_server_open = S_tcp_server_open_S_tcp_server_open_0005 and S_tcp_server_open_delay = 0 then
          write_data_data <= tmp_0339;
        elsif S_tcp_server_open = S_tcp_server_open_S_tcp_server_open_0004 and S_tcp_server_open_delay = 0 then
          write_data_data <= tmp_0349;
        elsif S_tcp_server_open = S_tcp_server_open_S_tcp_server_open_0003 and S_tcp_server_open_delay = 0 then
          write_data_data <= Sn_CR_OPEN;
        elsif S_tcp_server_listen = S_tcp_server_listen_S_tcp_server_listen_0003 and S_tcp_server_listen_delay = 0 then
          write_data_data <= Sn_CR_LISTEN;
        elsif S_pull_recv_data = S_pull_recv_data_S_pull_recv_data_0002 and S_pull_recv_data_delay = 0 then
          write_data_data <= Sn_CR_RECV;
        elsif S_push_send_data = S_push_send_data_S_push_send_data_0011 and S_push_send_data_delay = 0 then
          write_data_data <= push_send_data_v_2;
        elsif S_push_send_data = S_push_send_data_S_push_send_data_0009 and S_push_send_data_delay = 0 then
          write_data_data <= push_send_data_v_2;
        elsif S_push_send_data = S_push_send_data_S_push_send_data_0006 and S_push_send_data_delay = 0 then
          write_data_data <= Sn_CR_RECV;
        elsif S_push_send_data = S_push_send_data_S_push_send_data_0005 and S_push_send_data_delay = 0 then
          write_data_data <= tmp_0572;
        elsif S_push_send_data = S_push_send_data_S_push_send_data_0004 and S_push_send_data_delay = 0 then
          write_data_data <= tmp_0583;
        elsif S_push_send_data = S_push_send_data_S_push_send_data_0003 and S_push_send_data_delay = 0 then
          write_data_data <= tmp_0594;
        elsif S_push_send_data = S_push_send_data_S_push_send_data_0002 and S_push_send_data_delay = 0 then
          write_data_data <= Sn_CR_SEND;
        elsif S_tcp_server = S_tcp_server_S_tcp_server_0015 and S_tcp_server_delay = 0 then
          write_data_data <= tmp_0627;
        elsif S_tcp_server = S_tcp_server_S_tcp_server_0013 and S_tcp_server_delay = 0 then
          write_data_data <= Sn_CR_CLOSE;
        elsif S_tcp_server = S_tcp_server_S_tcp_server_0009 and S_tcp_server_delay = 0 then
          write_data_data <= Sn_CR_CLOSE;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        write_data_req_local <= '0';
      else
        if S_network_configuration = S_network_configuration_S_network_configuration_0019 and S_network_configuration_delay = 0 then
          write_data_req_local <= '1';
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0018 and S_network_configuration_delay = 0 then
          write_data_req_local <= '1';
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0017 and S_network_configuration_delay = 0 then
          write_data_req_local <= '1';
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0016 and S_network_configuration_delay = 0 then
          write_data_req_local <= '1';
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0015 and S_network_configuration_delay = 0 then
          write_data_req_local <= '1';
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0014 and S_network_configuration_delay = 0 then
          write_data_req_local <= '1';
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0013 and S_network_configuration_delay = 0 then
          write_data_req_local <= '1';
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0012 and S_network_configuration_delay = 0 then
          write_data_req_local <= '1';
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0011 and S_network_configuration_delay = 0 then
          write_data_req_local <= '1';
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0010 and S_network_configuration_delay = 0 then
          write_data_req_local <= '1';
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0009 and S_network_configuration_delay = 0 then
          write_data_req_local <= '1';
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0008 and S_network_configuration_delay = 0 then
          write_data_req_local <= '1';
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0007 and S_network_configuration_delay = 0 then
          write_data_req_local <= '1';
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0006 and S_network_configuration_delay = 0 then
          write_data_req_local <= '1';
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0005 and S_network_configuration_delay = 0 then
          write_data_req_local <= '1';
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0004 and S_network_configuration_delay = 0 then
          write_data_req_local <= '1';
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0003 and S_network_configuration_delay = 0 then
          write_data_req_local <= '1';
        elsif S_network_configuration = S_network_configuration_S_network_configuration_0002 and S_network_configuration_delay = 0 then
          write_data_req_local <= '1';
        elsif S_tcp_server_open = S_tcp_server_open_S_tcp_server_open_0006 and S_tcp_server_open_delay = 0 then
          write_data_req_local <= '1';
        elsif S_tcp_server_open = S_tcp_server_open_S_tcp_server_open_0005 and S_tcp_server_open_delay = 0 then
          write_data_req_local <= '1';
        elsif S_tcp_server_open = S_tcp_server_open_S_tcp_server_open_0004 and S_tcp_server_open_delay = 0 then
          write_data_req_local <= '1';
        elsif S_tcp_server_open = S_tcp_server_open_S_tcp_server_open_0003 and S_tcp_server_open_delay = 0 then
          write_data_req_local <= '1';
        elsif S_tcp_server_listen = S_tcp_server_listen_S_tcp_server_listen_0003 and S_tcp_server_listen_delay = 0 then
          write_data_req_local <= '1';
        elsif S_pull_recv_data = S_pull_recv_data_S_pull_recv_data_0002 and S_pull_recv_data_delay = 0 then
          write_data_req_local <= '1';
        elsif S_push_send_data = S_push_send_data_S_push_send_data_0011 and S_push_send_data_delay = 0 then
          write_data_req_local <= '1';
        elsif S_push_send_data = S_push_send_data_S_push_send_data_0009 and S_push_send_data_delay = 0 then
          write_data_req_local <= '1';
        elsif S_push_send_data = S_push_send_data_S_push_send_data_0006 and S_push_send_data_delay = 0 then
          write_data_req_local <= '1';
        elsif S_push_send_data = S_push_send_data_S_push_send_data_0005 and S_push_send_data_delay = 0 then
          write_data_req_local <= '1';
        elsif S_push_send_data = S_push_send_data_S_push_send_data_0004 and S_push_send_data_delay = 0 then
          write_data_req_local <= '1';
        elsif S_push_send_data = S_push_send_data_S_push_send_data_0003 and S_push_send_data_delay = 0 then
          write_data_req_local <= '1';
        elsif S_push_send_data = S_push_send_data_S_push_send_data_0002 and S_push_send_data_delay = 0 then
          write_data_req_local <= '1';
        elsif S_tcp_server = S_tcp_server_S_tcp_server_0015 and S_tcp_server_delay = 0 then
          write_data_req_local <= '1';
        elsif S_tcp_server = S_tcp_server_S_tcp_server_0013 and S_tcp_server_delay = 0 then
          write_data_req_local <= '1';
        elsif S_tcp_server = S_tcp_server_S_tcp_server_0009 and S_tcp_server_delay = 0 then
          write_data_req_local <= '1';
        else
          write_data_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  write_data_busy_sig <= tmp_0133;

  wait_cycles_busy_sig_0137 <= tmp_0141;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        read_data_addr <= (others => '0');
      else
        if S_tcp_server_open = S_tcp_server_open_S_tcp_server_open_0002 and S_tcp_server_open_delay = 0 then
          read_data_addr <= tmp_0365;
        elsif S_tcp_server_listen = S_tcp_server_listen_S_tcp_server_listen_0002 and S_tcp_server_listen_delay = 0 then
          read_data_addr <= tmp_0384;
        elsif S_wait_for_established = S_wait_for_established_S_wait_for_established_0005 and S_wait_for_established_delay = 0 then
          read_data_addr <= tmp_0403;
        elsif S_wait_for_recv = S_wait_for_recv_S_wait_for_recv_0008 and S_wait_for_recv_delay = 0 then
          read_data_addr <= tmp_0426;
        elsif S_wait_for_recv = S_wait_for_recv_S_wait_for_recv_0007 and S_wait_for_recv_delay = 0 then
          read_data_addr <= tmp_0435;
        elsif S_wait_for_recv = S_wait_for_recv_S_wait_for_recv_0006 and S_wait_for_recv_delay = 0 then
          read_data_addr <= tmp_0444;
        elsif S_pull_recv_data = S_pull_recv_data_S_pull_recv_data_0008 and S_pull_recv_data_delay = 0 then
          read_data_addr <= tmp_0481;
        elsif S_pull_recv_data = S_pull_recv_data_S_pull_recv_data_0006 and S_pull_recv_data_delay = 0 then
          read_data_addr <= tmp_0493;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        read_data_return_sig <= (others => '0');
      else
        if S_read_data = S_read_data_S_read_data_0002 then
          read_data_return_sig <= read_data_v_1;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        read_data_req_local <= '0';
      else
        if S_tcp_server_open = S_tcp_server_open_S_tcp_server_open_0002 and S_tcp_server_open_delay = 0 then
          read_data_req_local <= '1';
        elsif S_tcp_server_listen = S_tcp_server_listen_S_tcp_server_listen_0002 and S_tcp_server_listen_delay = 0 then
          read_data_req_local <= '1';
        elsif S_wait_for_established = S_wait_for_established_S_wait_for_established_0005 and S_wait_for_established_delay = 0 then
          read_data_req_local <= '1';
        elsif S_wait_for_recv = S_wait_for_recv_S_wait_for_recv_0008 and S_wait_for_recv_delay = 0 then
          read_data_req_local <= '1';
        elsif S_wait_for_recv = S_wait_for_recv_S_wait_for_recv_0007 and S_wait_for_recv_delay = 0 then
          read_data_req_local <= '1';
        elsif S_wait_for_recv = S_wait_for_recv_S_wait_for_recv_0006 and S_wait_for_recv_delay = 0 then
          read_data_req_local <= '1';
        elsif S_pull_recv_data = S_pull_recv_data_S_pull_recv_data_0008 and S_pull_recv_data_delay = 0 then
          read_data_req_local <= '1';
        elsif S_pull_recv_data = S_pull_recv_data_S_pull_recv_data_0006 and S_pull_recv_data_delay = 0 then
          read_data_req_local <= '1';
        else
          read_data_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  read_data_busy_sig <= tmp_0146;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        read_data_v_1 <= (others => '0');
      else
        if S_read_data = S_read_data_S_read_data_0005 then
          read_data_v_1 <= signed(wiz830mj_rdata);
        end if;
      end if;
    end if;
  end process;

  wait_cycles_busy_sig_0150 <= tmp_0154;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        init_req_local <= '0';
      else
        if S_test = S_test_S_test_0005 and S_test_delay = 0 then
          init_req_local <= '1';
        else
          init_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  init_busy_sig <= tmp_0159;

  wait_cycles_busy_sig_0165 <= tmp_0169;

  wait_cycles_busy_sig_0172 <= tmp_0176;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        network_configuration_req_local <= '0';
      else
        if S_test = S_test_S_test_0004 and S_test_delay = 0 then
          network_configuration_req_local <= '1';
        else
          network_configuration_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  network_configuration_busy_sig <= tmp_0179;

  write_data_busy_sig_0183 <= tmp_0187;

  write_data_busy_sig_0191 <= tmp_0195;

  write_data_busy_sig_0199 <= tmp_0203;

  write_data_busy_sig_0207 <= tmp_0211;

  write_data_busy_sig_0215 <= tmp_0219;

  write_data_busy_sig_0223 <= tmp_0227;

  write_data_busy_sig_0231 <= tmp_0235;

  write_data_busy_sig_0239 <= tmp_0243;

  write_data_busy_sig_0247 <= tmp_0251;

  write_data_busy_sig_0255 <= tmp_0259;

  write_data_busy_sig_0263 <= tmp_0267;

  write_data_busy_sig_0271 <= tmp_0275;

  write_data_busy_sig_0279 <= tmp_0283;

  write_data_busy_sig_0287 <= tmp_0291;

  write_data_busy_sig_0295 <= tmp_0299;

  write_data_busy_sig_0303 <= tmp_0307;

  write_data_busy_sig_0311 <= tmp_0315;

  write_data_busy_sig_0319 <= tmp_0323;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_open_port <= (others => '0');
      else
        if S_tcp_server = S_tcp_server_S_tcp_server_0014 and S_tcp_server_delay = 0 then
          tcp_server_open_port <= tcp_server_port;
        elsif S_tcp_server = S_tcp_server_S_tcp_server_0012 and S_tcp_server_delay = 0 then
          tcp_server_open_port <= tcp_server_port;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_open_return_sig <= (others => '0');
      else
        if S_tcp_server_open = S_tcp_server_open_S_tcp_server_open_0002 and S_tcp_server_open_delay >= 1 and read_data_busy_sig_0366 = '1' then
          tcp_server_open_return_sig <= read_data_return_sig;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_open_req_local <= '0';
      else
        if S_tcp_server = S_tcp_server_S_tcp_server_0014 and S_tcp_server_delay = 0 then
          tcp_server_open_req_local <= '1';
        elsif S_tcp_server = S_tcp_server_S_tcp_server_0012 and S_tcp_server_delay = 0 then
          tcp_server_open_req_local <= '1';
        else
          tcp_server_open_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  tcp_server_open_busy_sig <= tmp_0326;

  write_data_busy_sig_0330 <= tmp_0334;

  write_data_busy_sig_0340 <= tmp_0344;

  write_data_busy_sig_0350 <= tmp_0354;

  write_data_busy_sig_0358 <= tmp_0362;

  read_data_busy_sig_0366 <= tmp_0370;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_listen_port <= (others => '0');
      else
        if S_tcp_server = S_tcp_server_S_tcp_server_0010 and S_tcp_server_delay = 0 then
          tcp_server_listen_port <= tcp_server_port;
        elsif S_tcp_server = S_tcp_server_S_tcp_server_0008 and S_tcp_server_delay = 0 then
          tcp_server_listen_port <= tcp_server_port;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_listen_return_sig <= (others => '0');
      else
        if S_tcp_server_listen = S_tcp_server_listen_S_tcp_server_listen_0002 and S_tcp_server_listen_delay >= 1 and read_data_busy_sig_0385 = '1' then
          tcp_server_listen_return_sig <= read_data_return_sig;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_listen_req_local <= '0';
      else
        if S_tcp_server = S_tcp_server_S_tcp_server_0010 and S_tcp_server_delay = 0 then
          tcp_server_listen_req_local <= '1';
        elsif S_tcp_server = S_tcp_server_S_tcp_server_0008 and S_tcp_server_delay = 0 then
          tcp_server_listen_req_local <= '1';
        else
          tcp_server_listen_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  tcp_server_listen_busy_sig <= tmp_0373;

  write_data_busy_sig_0377 <= tmp_0381;

  read_data_busy_sig_0385 <= tmp_0389;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_established_port <= (others => '0');
      else
        if S_tcp_server = S_tcp_server_S_tcp_server_0006 and S_tcp_server_delay = 0 then
          wait_for_established_port <= tcp_server_port;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_established_req_local <= '0';
      else
        if S_tcp_server = S_tcp_server_S_tcp_server_0006 and S_tcp_server_delay = 0 then
          wait_for_established_req_local <= '1';
        else
          wait_for_established_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  wait_for_established_busy_sig <= tmp_0400;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_established_v_1 <= (others => '0');
      else
        if S_wait_for_established = S_wait_for_established_S_wait_for_established_0005 and S_wait_for_established_delay >= 1 and read_data_busy_sig_0404 = '1' then
          wait_for_established_v_1 <= read_data_return_sig;
        end if;
      end if;
    end if;
  end process;

  read_data_busy_sig_0404 <= tmp_0408;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_recv_port <= (others => '0');
      else
        if S_tcp_server = S_tcp_server_S_tcp_server_0005 and S_tcp_server_delay = 0 then
          wait_for_recv_port <= tcp_server_port;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_recv_return_sig <= (others => '0');
      else
        if S_wait_for_recv = S_wait_for_recv_S_wait_for_recv_0003 then
          wait_for_recv_return_sig <= wait_for_recv_v_1;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_recv_req_local <= '0';
      else
        if S_tcp_server = S_tcp_server_S_tcp_server_0005 and S_tcp_server_delay = 0 then
          wait_for_recv_req_local <= '1';
        else
          wait_for_recv_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  wait_for_recv_busy_sig <= tmp_0421;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_recv_v0_4 <= (others => '0');
      else
        if S_wait_for_recv = S_wait_for_recv_S_wait_for_recv_0008 and S_wait_for_recv_delay >= 1 and read_data_busy_sig_0427 = '1' then
          wait_for_recv_v0_4 <= tmp_0432;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_recv_v_1 <= X"00000000";
      else
        if S_wait_for_recv = S_wait_for_recv_S_wait_for_recv_0010 then
          wait_for_recv_v_1 <= tmp_0422;
        elsif S_wait_for_recv = S_wait_for_recv_S_wait_for_recv_0009 then
          wait_for_recv_v_1 <= tmp_0423;
        elsif S_wait_for_recv = S_wait_for_recv_S_wait_for_recv_0005 then
          wait_for_recv_v_1 <= tmp_0456;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_recv_v2_2 <= (others => '0');
      else
        if S_wait_for_recv = S_wait_for_recv_S_wait_for_recv_0006 and S_wait_for_recv_delay >= 1 and read_data_busy_sig_0445 = '1' then
          wait_for_recv_v2_2 <= tmp_0450;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_recv_v1_3 <= (others => '0');
      else
        if S_wait_for_recv = S_wait_for_recv_S_wait_for_recv_0007 and S_wait_for_recv_delay >= 1 and read_data_busy_sig_0436 = '1' then
          wait_for_recv_v1_3 <= tmp_0441;
        end if;
      end if;
    end if;
  end process;

  read_data_busy_sig_0427 <= tmp_0431;

  read_data_busy_sig_0436 <= tmp_0440;

  read_data_busy_sig_0445 <= tmp_0449;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pull_recv_data_port <= (others => '0');
      else
        if S_tcp_server = S_tcp_server_S_tcp_server_0004 and S_tcp_server_delay = 0 then
          pull_recv_data_port <= tcp_server_port;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pull_recv_data_len <= (others => '0');
      else
        if S_tcp_server = S_tcp_server_S_tcp_server_0004 and S_tcp_server_delay = 0 then
          pull_recv_data_len <= tcp_server_len_1;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pull_recv_data_req_local <= '0';
      else
        if S_tcp_server = S_tcp_server_S_tcp_server_0004 and S_tcp_server_delay = 0 then
          pull_recv_data_req_local <= '1';
        else
          pull_recv_data_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  pull_recv_data_busy_sig <= tmp_0473;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pull_recv_data_read_len_5 <= (others => '0');
      else
        if S_pull_recv_data = S_pull_recv_data_S_pull_recv_data_0012 then
          pull_recv_data_read_len_5 <= tmp_0475;
        elsif S_pull_recv_data = S_pull_recv_data_S_pull_recv_data_0010 then
          pull_recv_data_read_len_5 <= tmp_0477;
        end if;
      end if;
    end if;
  end process;

  read_data_busy_sig_0482 <= tmp_0486;

  read_data_busy_sig_0494 <= tmp_0498;

  write_data_busy_sig_0507 <= tmp_0511;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        push_send_data_port <= (others => '0');
      else
        if S_tcp_server = S_tcp_server_S_tcp_server_0003 and S_tcp_server_delay = 0 then
          push_send_data_port <= tcp_server_port;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        push_send_data_len <= (others => '0');
      else
        if S_tcp_server = S_tcp_server_S_tcp_server_0003 and S_tcp_server_delay = 0 then
          push_send_data_len <= tcp_server_len_1;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        push_send_data_req_local <= '0';
      else
        if S_tcp_server = S_tcp_server_S_tcp_server_0003 and S_tcp_server_delay = 0 then
          push_send_data_req_local <= '1';
        else
          push_send_data_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  push_send_data_busy_sig <= tmp_0528;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        push_send_data_write_len_4 <= (others => '0');
      else
        if S_push_send_data = S_push_send_data_S_push_send_data_0016 then
          push_send_data_write_len_4 <= tmp_0530;
        elsif S_push_send_data = S_push_send_data_S_push_send_data_0014 then
          push_send_data_write_len_4 <= tmp_0532;
        end if;
      end if;
    end if;
  end process;

  write_data_busy_sig_0541 <= tmp_0545;

  write_data_busy_sig_0553 <= tmp_0557;

  write_data_busy_sig_0562 <= tmp_0566;

  write_data_busy_sig_0573 <= tmp_0577;

  write_data_busy_sig_0584 <= tmp_0588;

  write_data_busy_sig_0595 <= tmp_0599;

  write_data_busy_sig_0603 <= tmp_0607;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_port <= (others => '0');
      else
        if S_test = S_test_S_test_0003 and S_test_delay = 0 then
          tcp_server_port <= tmp_0706;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_req_local <= '0';
      else
        if S_test = S_test_S_test_0003 and S_test_delay = 0 then
          tcp_server_req_local <= '1';
        else
          tcp_server_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  tcp_server_busy_sig <= tmp_0622;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_len_1 <= (others => '0');
      else
        if S_tcp_server = S_tcp_server_S_tcp_server_0005 and S_tcp_server_delay >= 1 and wait_for_recv_busy_sig_0674 = '1' then
          tcp_server_len_1 <= wait_for_recv_return_sig;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_v_2 <= (others => '0');
      else
        if S_tcp_server = S_tcp_server_S_tcp_server_0014 and S_tcp_server_delay >= 1 and tcp_server_open_busy_sig_0633 = '1' then
          tcp_server_v_2 <= tcp_server_open_return_sig;
        elsif S_tcp_server = S_tcp_server_S_tcp_server_0012 and S_tcp_server_delay >= 1 and tcp_server_open_busy_sig_0646 = '1' then
          tcp_server_v_2 <= tcp_server_open_return_sig;
        elsif S_tcp_server = S_tcp_server_S_tcp_server_0010 and S_tcp_server_delay >= 1 and tcp_server_listen_busy_sig_0651 = '1' then
          tcp_server_v_2 <= tcp_server_listen_return_sig;
        elsif S_tcp_server = S_tcp_server_S_tcp_server_0008 and S_tcp_server_delay >= 1 and tcp_server_listen_busy_sig_0664 = '1' then
          tcp_server_v_2 <= tcp_server_listen_return_sig;
        end if;
      end if;
    end if;
  end process;

  write_data_busy_sig_0628 <= tmp_0632;

  tcp_server_open_busy_sig_0633 <= tmp_0637;

  write_data_busy_sig_0641 <= tmp_0645;

  tcp_server_open_busy_sig_0646 <= tmp_0650;

  tcp_server_listen_busy_sig_0651 <= tmp_0655;

  write_data_busy_sig_0659 <= tmp_0663;

  tcp_server_listen_busy_sig_0664 <= tmp_0668;

  wait_for_established_busy_sig_0669 <= tmp_0673;

  wait_for_recv_busy_sig_0674 <= tmp_0678;

  pull_recv_data_busy_sig_0679 <= tmp_0683;

  push_send_data_busy_sig_0684 <= tmp_0688;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        test_req_local <= '0';
      else
        test_req_local <= '0';
      end if;
    end if;
  end process;

  init_busy_sig_0696 <= tmp_0700;

  network_configuration_busy_sig_0701 <= tmp_0705;

  tcp_server_busy_sig_0707 <= tmp_0711;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        blink_led_req_local <= '0';
      else
        blink_led_req_local <= '0';
      end if;
    end if;
  end process;


  inst_buffer : dualportram
  generic map(
    WIDTH => 8,
    DEPTH => 13,
    WORDS => 8192
  )
  port map(
    clk => buffer_clk,
    reset => buffer_reset,
    length => buffer_length,
    address => buffer_address,
    din => buffer_din,
    dout => buffer_dout,
    we => buffer_we,
    oe => buffer_oe,
    address_b => buffer_address_b,
    din_b => buffer_din_b,
    dout_b => buffer_dout_b,
    we_b => buffer_we_b,
    oe_b => buffer_oe_b
  );

  inst_wiz830mj : wiz830mj_iface
  port map(
    clk => wiz830mj_clk,
    reset => wiz830mj_reset,
    address => wiz830mj_address,
    wdata => wiz830mj_wdata,
    rdata => wiz830mj_rdata,
    cs => wiz830mj_cs,
    oe => wiz830mj_oe,
    we => wiz830mj_we,
    interrupt => wiz830mj_interrupt,
    module_reset => wiz830mj_module_reset,
    bready0 => wiz830mj_bready0,
    bready1 => wiz830mj_bready1,
    bready2 => wiz830mj_bready2,
    bready3 => wiz830mj_bready3,
    ADDR => wiz830mj_ADDR,
    DATA => wiz830mj_DATA,
    nCS => wiz830mj_nCS,
    nRD => wiz830mj_nRD,
    nWR => wiz830mj_nWR,
    nINT => wiz830mj_nINT,
    nRESET => wiz830mj_nRESET,
    BRDY => wiz830mj_BRDY
  );


end RTL;
