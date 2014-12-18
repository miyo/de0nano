library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity WIZ830MJ_Test is
  port (
    clk : in std_logic;
    reset : in std_logic;
    class_wiz830mj_0000_ADDR_exp : out std_logic_vector(10-1 downto 0);
    class_wiz830mj_0000_DATA_exp : inout std_logic_vector(8-1 downto 0);
    class_wiz830mj_0000_nCS_exp : out std_logic;
    class_wiz830mj_0000_nRD_exp : out std_logic;
    class_wiz830mj_0000_nWR_exp : out std_logic;
    class_wiz830mj_0000_nINT_exp : in std_logic;
    class_wiz830mj_0000_nRESET_exp : out std_logic;
    class_wiz830mj_0000_BRDY_exp : in std_logic_vector(4-1 downto 0);
    led_in : in signed(32-1 downto 0);
    led_we : in std_logic;
    led_out : out signed(32-1 downto 0);
    test_req : in std_logic;
    test_busy : out std_logic;
    blink_led_req : in std_logic;
    blink_led_busy : out std_logic
  );
end WIZ830MJ_Test;

architecture RTL of WIZ830MJ_Test is

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
  component dualportram
    generic (
      WIDTH : integer := 8;
      DEPTH : integer := 10;
      WORDS : integer := 1024
    );
    port (
      clk : in std_logic;
      reset : in std_logic;
      length : out signed(31 downto 0);
      address : in signed(31 downto 0);
      din : in signed(WIDTH-1 downto 0);
      dout : out signed(WIDTH-1 downto 0);
      we : in std_logic;
      oe : in std_logic;
      address_b : in signed(31 downto 0);
      din_b : in signed(WIDTH-1 downto 0);
      dout_b : out signed(WIDTH-1 downto 0);
      we_b : in std_logic;
      oe_b : in std_logic
    );
  end component dualportram;

  signal clk_sig : std_logic;
  signal reset_sig : std_logic;
  signal class_wiz830mj_0000_ADDR_exp_sig : std_logic_vector(10-1 downto 0);
  signal class_wiz830mj_0000_DATA_exp_sig : std_logic_vector(8-1 downto 0);
  signal class_wiz830mj_0000_nCS_exp_sig : std_logic;
  signal class_wiz830mj_0000_nRD_exp_sig : std_logic;
  signal class_wiz830mj_0000_nWR_exp_sig : std_logic;
  signal class_wiz830mj_0000_nINT_exp_sig : std_logic;
  signal class_wiz830mj_0000_nRESET_exp_sig : std_logic;
  signal class_wiz830mj_0000_BRDY_exp_sig : std_logic_vector(4-1 downto 0);
  signal led_in_sig : signed(32-1 downto 0);
  signal led_we_sig : std_logic;
  signal led_out_sig : signed(32-1 downto 0);
  signal test_req_sig : std_logic;
  signal test_busy_sig : std_logic := '1';
  signal blink_led_req_sig : std_logic;
  signal blink_led_busy_sig : std_logic := '1';

  signal class_wiz830mj_0000_clk : std_logic;
  signal class_wiz830mj_0000_reset : std_logic;
  signal class_wiz830mj_0000_address : std_logic_vector(32-1 downto 0) := (others => '0');
  signal class_wiz830mj_0000_wdata : std_logic_vector(8-1 downto 0) := (others => '0');
  signal class_wiz830mj_0000_rdata : std_logic_vector(8-1 downto 0);
  signal class_wiz830mj_0000_cs : std_logic := '0';
  signal class_wiz830mj_0000_oe : std_logic := '0';
  signal class_wiz830mj_0000_we : std_logic := '0';
  signal class_wiz830mj_0000_interrupt : std_logic;
  signal class_wiz830mj_0000_module_reset : std_logic := '0';
  signal class_wiz830mj_0000_bready0 : std_logic;
  signal class_wiz830mj_0000_bready1 : std_logic;
  signal class_wiz830mj_0000_bready2 : std_logic;
  signal class_wiz830mj_0000_bready3 : std_logic;
  signal class_wiz830mj_0000_ADDR : std_logic_vector(10-1 downto 0);
  signal class_wiz830mj_0000_DATA : std_logic_vector(8-1 downto 0);
  signal class_wiz830mj_0000_nCS : std_logic;
  signal class_wiz830mj_0000_nRD : std_logic;
  signal class_wiz830mj_0000_nWR : std_logic;
  signal class_wiz830mj_0000_nINT : std_logic;
  signal class_wiz830mj_0000_nRESET : std_logic;
  signal class_wiz830mj_0000_BRDY : std_logic_vector(4-1 downto 0);
  signal class_led_0002 : signed(32-1 downto 0) := (others => '0');
  signal class_led_0002_mux : signed(32-1 downto 0);
  signal tmp_0001 : signed(32-1 downto 0);
  signal class_Sn_MR0_0003 : signed(32-1 downto 0) := X"00000200";
  signal class_Sn_MR1_0004 : signed(32-1 downto 0) := X"00000201";
  signal class_Sn_CR0_0005 : signed(32-1 downto 0) := X"00000202";
  signal class_Sn_CR1_0006 : signed(32-1 downto 0) := X"00000203";
  signal class_Sn_IMR0_0007 : signed(32-1 downto 0) := X"00000204";
  signal class_Sn_IMR1_0008 : signed(32-1 downto 0) := X"00000205";
  signal class_Sn_IR0_0009 : signed(32-1 downto 0) := X"00000206";
  signal class_Sn_IR1_0010 : signed(32-1 downto 0) := X"00000207";
  signal class_Sn_SSR0_0011 : signed(32-1 downto 0) := X"00000208";
  signal class_Sn_SSR1_0012 : signed(32-1 downto 0) := X"00000209";
  signal class_Sn_PORTR0_0013 : signed(32-1 downto 0) := X"0000020a";
  signal class_Sn_PORTR1_0014 : signed(32-1 downto 0) := X"0000020b";
  signal class_Sn_DHAR0_0015 : signed(32-1 downto 0) := X"0000020c";
  signal class_Sn_DHAR1_0016 : signed(32-1 downto 0) := X"0000020d";
  signal class_Sn_DHAR2_0017 : signed(32-1 downto 0) := X"0000020e";
  signal class_Sn_DHAR3_0018 : signed(32-1 downto 0) := X"0000020f";
  signal class_Sn_DHAR4_0019 : signed(32-1 downto 0) := X"00000210";
  signal class_Sn_DHAR5_0020 : signed(32-1 downto 0) := X"00000211";
  signal class_Sn_DPORTR0_0021 : signed(32-1 downto 0) := X"00000212";
  signal class_Sn_DPORTR1_0022 : signed(32-1 downto 0) := X"00000213";
  signal class_Sn_DIPR0_0023 : signed(32-1 downto 0) := X"00000214";
  signal class_Sn_DIPR1_0024 : signed(32-1 downto 0) := X"00000215";
  signal class_Sn_DIPR2_0025 : signed(32-1 downto 0) := X"00000216";
  signal class_Sn_DIPR3_0026 : signed(32-1 downto 0) := X"00000217";
  signal class_Sn_MSSR0_0027 : signed(32-1 downto 0) := X"00000218";
  signal class_Sn_MSSR1_0028 : signed(32-1 downto 0) := X"00000219";
  signal class_Sn_KPALVTR_0029 : signed(32-1 downto 0) := X"0000021a";
  signal class_Sn_PROTOR_0030 : signed(32-1 downto 0) := X"0000021b";
  signal class_Sn_TOSR0_0031 : signed(32-1 downto 0) := X"0000021c";
  signal class_Sn_TOSR1_0032 : signed(32-1 downto 0) := X"0000021d";
  signal class_Sn_TTLR0_0033 : signed(32-1 downto 0) := X"0000021e";
  signal class_Sn_TTLR1_0034 : signed(32-1 downto 0) := X"0000021f";
  signal class_Sn_TX_WRSR0_0035 : signed(32-1 downto 0) := X"00000220";
  signal class_Sn_TX_WRSR1_0036 : signed(32-1 downto 0) := X"00000221";
  signal class_Sn_TX_WRSR2_0037 : signed(32-1 downto 0) := X"00000222";
  signal class_Sn_TX_WRSR3_0038 : signed(32-1 downto 0) := X"00000223";
  signal class_Sn_TX_FSR0_0039 : signed(32-1 downto 0) := X"00000224";
  signal class_Sn_TX_FSR1_0040 : signed(32-1 downto 0) := X"00000225";
  signal class_Sn_TX_FSR2_0041 : signed(32-1 downto 0) := X"00000226";
  signal class_Sn_TX_FSR3_0042 : signed(32-1 downto 0) := X"00000227";
  signal class_Sn_RX_RSR0_0043 : signed(32-1 downto 0) := X"00000228";
  signal class_Sn_RX_RSR1_0044 : signed(32-1 downto 0) := X"00000229";
  signal class_Sn_RX_RSR2_0045 : signed(32-1 downto 0) := X"0000022a";
  signal class_Sn_RX_RSR3_0046 : signed(32-1 downto 0) := X"0000022b";
  signal class_Sn_FRAGR0_0047 : signed(32-1 downto 0) := X"0000022c";
  signal class_Sn_FRAGR1_0048 : signed(32-1 downto 0) := X"0000022d";
  signal class_Sn_TX_FIFOR0_0049 : signed(32-1 downto 0) := X"0000022e";
  signal class_Sn_TX_FIFOR1_0050 : signed(32-1 downto 0) := X"0000022f";
  signal class_Sn_RX_FIFOR0_0051 : signed(32-1 downto 0) := X"00000230";
  signal class_Sn_RX_FIFOR1_0052 : signed(32-1 downto 0) := X"00000231";
  signal class_Sn_MR_CLOSE_0053 : signed(8-1 downto 0) := (others => '0');
  signal class_Sn_MR_TCP_0054 : signed(8-1 downto 0) := (others => '0');
  signal class_Sn_MR_UDP_0055 : signed(8-1 downto 0) := (others => '0');
  signal class_Sn_MR_IPRAW_0056 : signed(8-1 downto 0) := (others => '0');
  signal class_Sn_MR_MACRAW_0057 : signed(8-1 downto 0) := (others => '0');
  signal class_Sn_MR_PPPoE_0058 : signed(8-1 downto 0) := (others => '0');
  signal class_Sn_CR_OPEN_0059 : signed(8-1 downto 0) := (others => '0');
  signal class_Sn_CR_LISTEN_0060 : signed(8-1 downto 0) := (others => '0');
  signal class_Sn_CR_CONNECT_0061 : signed(8-1 downto 0) := (others => '0');
  signal class_Sn_CR_DISCON_0062 : signed(8-1 downto 0) := (others => '0');
  signal class_Sn_CR_CLOSE_0063 : signed(8-1 downto 0) := (others => '0');
  signal class_Sn_CR_SEND_0064 : signed(8-1 downto 0) := (others => '0');
  signal class_Sn_CR_SEND_MAC_0065 : signed(8-1 downto 0) := (others => '0');
  signal class_Sn_CR_SEND_KEEP_0066 : signed(8-1 downto 0) := (others => '0');
  signal class_Sn_CR_RECV_0067 : signed(8-1 downto 0) := (others => '0');
  signal class_Sn_CR_PCON_0068 : signed(8-1 downto 0) := (others => '0');
  signal class_Sn_CR_PDISCON_0069 : signed(8-1 downto 0) := (others => '0');
  signal class_Sn_CR_PCR_0070 : signed(8-1 downto 0) := (others => '0');
  signal class_Sn_CR_PCN_0071 : signed(8-1 downto 0) := (others => '0');
  signal class_Sn_CR_PCJ_0072 : signed(8-1 downto 0) := (others => '0');
  signal class_Sn_SOCK_CLOSED_0073 : signed(8-1 downto 0) := (others => '0');
  signal class_Sn_SOCK_INIT_0074 : signed(8-1 downto 0) := (others => '0');
  signal class_Sn_SOCK_LISTEN_0075 : signed(8-1 downto 0) := (others => '0');
  signal class_Sn_SOCK_ESTABLISHED_0076 : signed(8-1 downto 0) := (others => '0');
  signal class_Sn_SOCK_CLOSE_WAIT_0077 : signed(8-1 downto 0) := (others => '0');
  signal class_Sn_SOCK_UDP_0078 : signed(8-1 downto 0) := (others => '0');
  signal class_Sn_SOCK_IPRAW_0079 : signed(8-1 downto 0) := (others => '0');
  signal class_Sn_SOCK_MACRAW_0080 : signed(8-1 downto 0) := (others => '0');
  signal class_Sn_SOCK_PPPoE_0081 : signed(8-1 downto 0) := (others => '0');
  signal class_Sn_SOCK_SYSSENT_0082 : signed(8-1 downto 0) := (others => '0');
  signal class_Sn_SOCK_SYSRECV_0083 : signed(8-1 downto 0) := (others => '0');
  signal class_Sn_SOCK_FIN_WAIT_0084 : signed(8-1 downto 0) := (others => '0');
  signal class_Sn_SOCK_TIME_WAIT_0085 : signed(8-1 downto 0) := (others => '0');
  signal class_Sn_SOCK_LAST_ACK_0086 : signed(8-1 downto 0) := (others => '0');
  signal class_Sn_SOCK_ARP_0087 : signed(8-1 downto 0) := (others => '0');
  signal class_buffer_0088_clk : std_logic;
  signal class_buffer_0088_reset : std_logic;
  signal class_buffer_0088_length : signed(32-1 downto 0);
  signal class_buffer_0088_address : signed(32-1 downto 0) := (others => '0');
  signal class_buffer_0088_din : signed(8-1 downto 0) := (others => '0');
  signal class_buffer_0088_dout : signed(8-1 downto 0);
  signal class_buffer_0088_we : std_logic := '0';
  signal class_buffer_0088_oe : std_logic := '0';
  signal class_buffer_0088_address_b : signed(32-1 downto 0) := (others => '0');
  signal class_buffer_0088_din_b : signed(8-1 downto 0) := (others => '0');
  signal class_buffer_0088_dout_b : signed(8-1 downto 0);
  signal class_buffer_0088_we_b : std_logic := '0';
  signal class_buffer_0088_oe_b : std_logic := '0';
  signal wait_cycles_n_0089 : signed(32-1 downto 0) := (others => '0');
  signal wait_cycles_n_local : signed(32-1 downto 0) := (others => '0');
  signal wait_cycles_i_0090 : signed(32-1 downto 0) := X"00000000";
  signal binary_expr_00091 : std_logic := '0';
  signal unary_expr_00092 : signed(32-1 downto 0) := (others => '0');
  signal write_data_addr_0093 : signed(32-1 downto 0) := (others => '0');
  signal write_data_addr_local : signed(32-1 downto 0) := (others => '0');
  signal write_data_data_0094 : signed(8-1 downto 0) := (others => '0');
  signal write_data_data_local : signed(8-1 downto 0) := (others => '0');
  signal field_access_00095 : signed(32-1 downto 0) := (others => '0');
  signal field_access_00096 : signed(8-1 downto 0) := (others => '0');
  signal field_access_00097 : std_logic := '0';
  signal field_access_00098 : std_logic := '0';
  signal field_access_00100 : std_logic := '0';
  signal field_access_00101 : std_logic := '0';
  signal read_data_addr_0102 : signed(32-1 downto 0) := (others => '0');
  signal read_data_addr_local : signed(32-1 downto 0) := (others => '0');
  signal field_access_00103 : signed(32-1 downto 0) := (others => '0');
  signal field_access_00104 : std_logic := '0';
  signal field_access_00105 : std_logic := '0';
  signal read_data_v_0107 : signed(8-1 downto 0) := (others => '0');
  signal field_access_00108 : signed(8-1 downto 0) := (others => '0');
  signal field_access_00109 : std_logic := '0';
  signal field_access_00110 : std_logic := '0';
  signal field_access_00111 : std_logic := '0';
  signal field_access_00112 : std_logic := '0';
  signal field_access_00113 : std_logic := '0';
  signal field_access_00114 : std_logic := '0';
  signal field_access_00116 : std_logic := '0';
  signal tcp_server_open_port_0136 : signed(32-1 downto 0) := (others => '0');
  signal tcp_server_open_port_local : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00138 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00139 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00141 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00142 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00144 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00145 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00147 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00148 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00149 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00150 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00151 : signed(32-1 downto 0) := (others => '0');
  signal tcp_server_listen_port_0152 : signed(32-1 downto 0) := (others => '0');
  signal tcp_server_listen_port_local : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00154 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00155 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00156 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00157 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00158 : signed(32-1 downto 0) := (others => '0');
  signal wait_for_established_port_0159 : signed(32-1 downto 0) := (others => '0');
  signal wait_for_established_port_local : signed(32-1 downto 0) := (others => '0');
  signal wait_for_established_v_0160 : signed(8-1 downto 0) := (others => '0');
  signal method_result_00161 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00162 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00163 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00164 : std_logic := '0';
  signal wait_for_recv_port_0165 : signed(32-1 downto 0) := (others => '0');
  signal wait_for_recv_port_local : signed(32-1 downto 0) := (others => '0');
  signal wait_for_recv_v_0166 : signed(32-1 downto 0) := X"00000000";
  signal wait_for_recv_v0_0167 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00168 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00169 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00170 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00171 : signed(32-1 downto 0) := (others => '0');
  signal wait_for_recv_v1_0172 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00173 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00174 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00175 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00176 : signed(32-1 downto 0) := (others => '0');
  signal wait_for_recv_v2_0177 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00178 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00179 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00180 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00181 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00182 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00183 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00184 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00185 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00186 : std_logic := '0';
  signal pull_recv_data_port_0187 : signed(32-1 downto 0) := (others => '0');
  signal pull_recv_data_port_local : signed(32-1 downto 0) := (others => '0');
  signal pull_recv_data_len_0188 : signed(32-1 downto 0) := (others => '0');
  signal pull_recv_data_len_local : signed(32-1 downto 0) := (others => '0');
  signal pull_recv_data_read_len_0189 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00190 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00191 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00192 : std_logic := '0';
  signal binary_expr_00210 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00211 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00193 : signed(32-1 downto 0) := (others => '0');
  signal pull_recv_data_i_0194 : signed(32-1 downto 0) := X"00000000";
  signal binary_expr_00195 : std_logic := '0';
  signal unary_expr_00196 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00197 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00198 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00199 : signed(8-1 downto 0) := (others => '0');
  signal method_result_00200 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00201 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00202 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00203 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00204 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00205 : signed(8-1 downto 0) := (others => '0');
  signal method_result_00206 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00207 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00208 : signed(32-1 downto 0) := (others => '0');
  signal push_send_data_port_0212 : signed(32-1 downto 0) := (others => '0');
  signal push_send_data_port_local : signed(32-1 downto 0) := (others => '0');
  signal push_send_data_len_0213 : signed(32-1 downto 0) := (others => '0');
  signal push_send_data_len_local : signed(32-1 downto 0) := (others => '0');
  signal push_send_data_write_len_0214 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00215 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00216 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00217 : std_logic := '0';
  signal binary_expr_00236 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00237 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00239 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00240 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00241 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00242 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00244 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00245 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00246 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00247 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00249 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00250 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00251 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00252 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00254 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00255 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00218 : signed(32-1 downto 0) := (others => '0');
  signal push_send_data_i_0219 : signed(32-1 downto 0) := X"00000000";
  signal binary_expr_00220 : std_logic := '0';
  signal unary_expr_00221 : signed(32-1 downto 0) := (others => '0');
  signal push_send_data_v_0222 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00223 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00224 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00225 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00227 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00228 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00229 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00230 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00231 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00233 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00234 : signed(32-1 downto 0) := (others => '0');
  signal tcp_server_port_0256 : signed(32-1 downto 0) := (others => '0');
  signal tcp_server_port_local : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00258 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00259 : signed(32-1 downto 0) := (others => '0');
  signal tcp_server_v_0260 : signed(8-1 downto 0) := (others => '0');
  signal method_result_00261 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00262 : std_logic := '0';
  signal method_result_00267 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00268 : std_logic := '0';
  signal binary_expr_00264 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00265 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00266 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00270 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00271 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00272 : signed(8-1 downto 0) := (others => '0');
  signal tcp_server_len_0274 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00275 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00281 : std_logic := '0';
  signal unary_expr_00282 : signed(32-1 downto 0) := (others => '0');
  signal blink_led_i_0283 : signed(32-1 downto 0) := X"00000000";
  signal binary_expr_00284 : std_logic := '0';
  signal unary_expr_00285 : signed(32-1 downto 0) := (others => '0');
  signal wait_cycles_req_flag : std_logic;
  signal wait_cycles_req_local : std_logic := '0';
  signal wait_cycles_busy : std_logic := '0';
  signal write_data_req_flag : std_logic;
  signal write_data_req_local : std_logic := '0';
  signal write_data_busy : std_logic := '0';
  signal read_data_req_flag : std_logic;
  signal read_data_req_local : std_logic := '0';
  signal read_data_busy : std_logic := '0';
  signal init_req_flag : std_logic;
  signal init_req_local : std_logic := '0';
  signal init_busy : std_logic := '0';
  signal network_configuration_req_flag : std_logic;
  signal network_configuration_req_local : std_logic := '0';
  signal network_configuration_busy : std_logic := '0';
  signal tcp_server_open_req_flag : std_logic;
  signal tcp_server_open_req_local : std_logic := '0';
  signal tcp_server_open_busy : std_logic := '0';
  signal tcp_server_listen_req_flag : std_logic;
  signal tcp_server_listen_req_local : std_logic := '0';
  signal tcp_server_listen_busy : std_logic := '0';
  signal wait_for_established_req_flag : std_logic;
  signal wait_for_established_req_local : std_logic := '0';
  signal wait_for_established_busy : std_logic := '0';
  signal wait_for_recv_req_flag : std_logic;
  signal wait_for_recv_req_local : std_logic := '0';
  signal wait_for_recv_busy : std_logic := '0';
  signal pull_recv_data_req_flag : std_logic;
  signal pull_recv_data_req_local : std_logic := '0';
  signal pull_recv_data_busy : std_logic := '0';
  signal push_send_data_req_flag : std_logic;
  signal push_send_data_req_local : std_logic := '0';
  signal push_send_data_busy : std_logic := '0';
  signal tcp_server_req_flag : std_logic;
  signal tcp_server_req_local : std_logic := '0';
  signal tcp_server_busy : std_logic := '0';
  signal test_req_flag : std_logic;
  signal test_req_local : std_logic := '0';
  signal tmp_0002 : std_logic;
  signal blink_led_req_flag : std_logic;
  signal blink_led_req_local : std_logic := '0';
  signal tmp_0003 : std_logic;
  type Type_wait_cycles_method is (
    wait_cycles_method_IDLE,
    wait_cycles_method_S_0000,
    wait_cycles_method_S_0001,
    wait_cycles_method_S_0002,
    wait_cycles_method_S_0003,
    wait_cycles_method_S_0004,
    wait_cycles_method_S_0005,
    wait_cycles_method_S_0006,
    wait_cycles_method_S_0007,
    wait_cycles_method_S_0008,
    wait_cycles_method_S_0009,
    wait_cycles_method_S_0010  
  );
  signal wait_cycles_method : Type_wait_cycles_method := wait_cycles_method_IDLE;
  signal wait_cycles_method_delay : signed(32-1 downto 0) := (others => '0');
  signal tmp_0004 : std_logic;
  signal tmp_0005 : std_logic;
  signal tmp_0006 : std_logic;
  signal tmp_0007 : signed(32-1 downto 0);
  type Type_write_data_method is (
    write_data_method_IDLE,
    write_data_method_S_0000,
    write_data_method_S_0001,
    write_data_method_S_0002,
    write_data_method_S_0003,
    write_data_method_S_0004,
    write_data_method_S_0005,
    write_data_method_S_0006,
    write_data_method_S_0007,
    write_data_method_S_0008,
    write_data_method_S_0009,
    write_data_method_S_0010,
    write_data_method_S_0011,
    write_data_method_S_0012,
    write_data_method_S_0013,
    write_data_method_S_0014,
    write_data_method_S_0015,
    write_data_method_write_data_method_S_0010_body  
  );
  signal write_data_method : Type_write_data_method := write_data_method_IDLE;
  signal write_data_method_delay : signed(32-1 downto 0) := (others => '0');
  signal wait_cycles_call_flag_0010 : std_logic;
  signal tmp_0008 : std_logic;
  signal tmp_0009 : std_logic;
  signal tmp_0010 : std_logic;
  signal tmp_0011 : std_logic;
  signal tmp_0012 : std_logic;
  type Type_read_data_method is (
    read_data_method_IDLE,
    read_data_method_S_0000,
    read_data_method_S_0001,
    read_data_method_S_0002,
    read_data_method_S_0003,
    read_data_method_S_0004,
    read_data_method_S_0005,
    read_data_method_S_0006,
    read_data_method_S_0007,
    read_data_method_S_0008,
    read_data_method_S_0009,
    read_data_method_S_0010,
    read_data_method_S_0011,
    read_data_method_S_0012,
    read_data_method_S_0013,
    read_data_method_S_0014,
    read_data_method_S_0015,
    read_data_method_S_0016,
    read_data_method_read_data_method_S_0008_body  
  );
  signal read_data_method : Type_read_data_method := read_data_method_IDLE;
  signal read_data_method_delay : signed(32-1 downto 0) := (others => '0');
  signal wait_cycles_call_flag_0008 : std_logic;
  signal tmp_0013 : std_logic;
  signal tmp_0014 : std_logic;
  signal tmp_0015 : std_logic;
  signal tmp_0016 : std_logic;
  signal tmp_0017 : std_logic;
  signal read_data_return : signed(8-1 downto 0) := (others => '0');
  type Type_init_method is (
    init_method_IDLE,
    init_method_S_0000,
    init_method_S_0001,
    init_method_S_0002,
    init_method_S_0003,
    init_method_S_0004,
    init_method_S_0005,
    init_method_S_0006,
    init_method_S_0007,
    init_method_S_0008,
    init_method_S_0009,
    init_method_S_0010,
    init_method_S_0011,
    init_method_S_0012,
    init_method_S_0013,
    init_method_S_0014,
    init_method_init_method_S_0010_body,
    init_method_init_method_S_0013_body  
  );
  signal init_method : Type_init_method := init_method_IDLE;
  signal init_method_delay : signed(32-1 downto 0) := (others => '0');
  signal tmp_0018 : std_logic;
  signal wait_cycles_call_flag_0013 : std_logic;
  signal tmp_0019 : std_logic;
  signal tmp_0020 : std_logic;
  signal tmp_0021 : std_logic;
  signal tmp_0022 : std_logic;
  signal tmp_0023 : std_logic;
  type Type_network_configuration_method is (
    network_configuration_method_IDLE,
    network_configuration_method_S_0000,
    network_configuration_method_S_0001,
    network_configuration_method_S_0002,
    network_configuration_method_S_0003,
    network_configuration_method_S_0004,
    network_configuration_method_S_0005,
    network_configuration_method_S_0006,
    network_configuration_method_S_0007,
    network_configuration_method_S_0008,
    network_configuration_method_S_0009,
    network_configuration_method_S_0010,
    network_configuration_method_S_0011,
    network_configuration_method_S_0012,
    network_configuration_method_S_0013,
    network_configuration_method_S_0014,
    network_configuration_method_S_0015,
    network_configuration_method_S_0016,
    network_configuration_method_S_0017,
    network_configuration_method_S_0018,
    network_configuration_method_S_0019,
    network_configuration_method_S_0020,
    network_configuration_method_network_configuration_method_S_0002_body,
    network_configuration_method_network_configuration_method_S_0003_body,
    network_configuration_method_network_configuration_method_S_0004_body,
    network_configuration_method_network_configuration_method_S_0005_body,
    network_configuration_method_network_configuration_method_S_0006_body,
    network_configuration_method_network_configuration_method_S_0007_body,
    network_configuration_method_network_configuration_method_S_0008_body,
    network_configuration_method_network_configuration_method_S_0009_body,
    network_configuration_method_network_configuration_method_S_0010_body,
    network_configuration_method_network_configuration_method_S_0011_body,
    network_configuration_method_network_configuration_method_S_0012_body,
    network_configuration_method_network_configuration_method_S_0013_body,
    network_configuration_method_network_configuration_method_S_0014_body,
    network_configuration_method_network_configuration_method_S_0015_body,
    network_configuration_method_network_configuration_method_S_0016_body,
    network_configuration_method_network_configuration_method_S_0017_body,
    network_configuration_method_network_configuration_method_S_0018_body,
    network_configuration_method_network_configuration_method_S_0019_body  
  );
  signal network_configuration_method : Type_network_configuration_method := network_configuration_method_IDLE;
  signal network_configuration_method_delay : signed(32-1 downto 0) := (others => '0');
  signal write_data_call_flag_0002 : std_logic;
  signal tmp_0024 : std_logic;
  signal tmp_0025 : std_logic;
  signal tmp_0026 : std_logic;
  signal tmp_0027 : std_logic;
  signal tmp_0028 : std_logic;
  signal write_data_call_flag_0003 : std_logic;
  signal tmp_0029 : std_logic;
  signal tmp_0030 : std_logic;
  signal tmp_0031 : std_logic;
  signal tmp_0032 : std_logic;
  signal tmp_0033 : std_logic;
  signal write_data_call_flag_0004 : std_logic;
  signal tmp_0034 : std_logic;
  signal tmp_0035 : std_logic;
  signal tmp_0036 : std_logic;
  signal tmp_0037 : std_logic;
  signal tmp_0038 : std_logic;
  signal write_data_call_flag_0005 : std_logic;
  signal tmp_0039 : std_logic;
  signal tmp_0040 : std_logic;
  signal tmp_0041 : std_logic;
  signal tmp_0042 : std_logic;
  signal tmp_0043 : std_logic;
  signal write_data_call_flag_0006 : std_logic;
  signal tmp_0044 : std_logic;
  signal tmp_0045 : std_logic;
  signal tmp_0046 : std_logic;
  signal tmp_0047 : std_logic;
  signal tmp_0048 : std_logic;
  signal write_data_call_flag_0007 : std_logic;
  signal tmp_0049 : std_logic;
  signal tmp_0050 : std_logic;
  signal tmp_0051 : std_logic;
  signal tmp_0052 : std_logic;
  signal tmp_0053 : std_logic;
  signal write_data_call_flag_0008 : std_logic;
  signal tmp_0054 : std_logic;
  signal tmp_0055 : std_logic;
  signal tmp_0056 : std_logic;
  signal tmp_0057 : std_logic;
  signal tmp_0058 : std_logic;
  signal write_data_call_flag_0009 : std_logic;
  signal tmp_0059 : std_logic;
  signal tmp_0060 : std_logic;
  signal tmp_0061 : std_logic;
  signal tmp_0062 : std_logic;
  signal tmp_0063 : std_logic;
  signal write_data_call_flag_0010 : std_logic;
  signal tmp_0064 : std_logic;
  signal tmp_0065 : std_logic;
  signal tmp_0066 : std_logic;
  signal tmp_0067 : std_logic;
  signal tmp_0068 : std_logic;
  signal write_data_call_flag_0011 : std_logic;
  signal tmp_0069 : std_logic;
  signal tmp_0070 : std_logic;
  signal tmp_0071 : std_logic;
  signal tmp_0072 : std_logic;
  signal tmp_0073 : std_logic;
  signal write_data_call_flag_0012 : std_logic;
  signal tmp_0074 : std_logic;
  signal tmp_0075 : std_logic;
  signal tmp_0076 : std_logic;
  signal tmp_0077 : std_logic;
  signal tmp_0078 : std_logic;
  signal write_data_call_flag_0013 : std_logic;
  signal tmp_0079 : std_logic;
  signal tmp_0080 : std_logic;
  signal tmp_0081 : std_logic;
  signal tmp_0082 : std_logic;
  signal tmp_0083 : std_logic;
  signal write_data_call_flag_0014 : std_logic;
  signal tmp_0084 : std_logic;
  signal tmp_0085 : std_logic;
  signal tmp_0086 : std_logic;
  signal tmp_0087 : std_logic;
  signal tmp_0088 : std_logic;
  signal write_data_call_flag_0015 : std_logic;
  signal tmp_0089 : std_logic;
  signal tmp_0090 : std_logic;
  signal tmp_0091 : std_logic;
  signal tmp_0092 : std_logic;
  signal tmp_0093 : std_logic;
  signal write_data_call_flag_0016 : std_logic;
  signal tmp_0094 : std_logic;
  signal tmp_0095 : std_logic;
  signal tmp_0096 : std_logic;
  signal tmp_0097 : std_logic;
  signal tmp_0098 : std_logic;
  signal write_data_call_flag_0017 : std_logic;
  signal tmp_0099 : std_logic;
  signal tmp_0100 : std_logic;
  signal tmp_0101 : std_logic;
  signal tmp_0102 : std_logic;
  signal tmp_0103 : std_logic;
  signal write_data_call_flag_0018 : std_logic;
  signal tmp_0104 : std_logic;
  signal tmp_0105 : std_logic;
  signal tmp_0106 : std_logic;
  signal tmp_0107 : std_logic;
  signal tmp_0108 : std_logic;
  signal write_data_call_flag_0019 : std_logic;
  signal tmp_0109 : std_logic;
  signal tmp_0110 : std_logic;
  signal tmp_0111 : std_logic;
  signal tmp_0112 : std_logic;
  signal tmp_0113 : std_logic;
  type Type_tcp_server_open_method is (
    tcp_server_open_method_IDLE,
    tcp_server_open_method_S_0000,
    tcp_server_open_method_S_0001,
    tcp_server_open_method_S_0002,
    tcp_server_open_method_S_0003,
    tcp_server_open_method_S_0004,
    tcp_server_open_method_S_0005,
    tcp_server_open_method_S_0006,
    tcp_server_open_method_S_0007,
    tcp_server_open_method_S_0008,
    tcp_server_open_method_S_0009,
    tcp_server_open_method_S_0010,
    tcp_server_open_method_S_0011,
    tcp_server_open_method_S_0012,
    tcp_server_open_method_S_0013,
    tcp_server_open_method_S_0014,
    tcp_server_open_method_S_0015,
    tcp_server_open_method_S_0016,
    tcp_server_open_method_S_0017,
    tcp_server_open_method_S_0018,
    tcp_server_open_method_tcp_server_open_method_S_0004_body,
    tcp_server_open_method_tcp_server_open_method_S_0007_body,
    tcp_server_open_method_tcp_server_open_method_S_0010_body,
    tcp_server_open_method_tcp_server_open_method_S_0013_body,
    tcp_server_open_method_tcp_server_open_method_S_0016_body  
  );
  signal tcp_server_open_method : Type_tcp_server_open_method := tcp_server_open_method_IDLE;
  signal tcp_server_open_method_delay : signed(32-1 downto 0) := (others => '0');
  signal tmp_0114 : std_logic;
  signal tmp_0115 : std_logic;
  signal tmp_0116 : std_logic;
  signal tmp_0117 : std_logic;
  signal read_data_call_flag_0016 : std_logic;
  signal tmp_0118 : std_logic;
  signal tmp_0119 : std_logic;
  signal tmp_0120 : std_logic;
  signal tmp_0121 : std_logic;
  signal tmp_0122 : std_logic;
  signal tcp_server_open_return : signed(8-1 downto 0) := (others => '0');
  signal tmp_0123 : signed(32-1 downto 0);
  signal tmp_0124 : signed(32-1 downto 0);
  signal tmp_0125 : signed(32-1 downto 0);
  signal tmp_0126 : signed(32-1 downto 0);
  signal tmp_0127 : signed(32-1 downto 0);
  signal tmp_0128 : signed(32-1 downto 0);
  signal tmp_0129 : signed(32-1 downto 0);
  signal tmp_0130 : signed(32-1 downto 0);
  signal tmp_0131 : signed(32-1 downto 0);
  signal tmp_0132 : signed(32-1 downto 0);
  type Type_tcp_server_listen_method is (
    tcp_server_listen_method_IDLE,
    tcp_server_listen_method_S_0000,
    tcp_server_listen_method_S_0001,
    tcp_server_listen_method_S_0002,
    tcp_server_listen_method_S_0003,
    tcp_server_listen_method_S_0004,
    tcp_server_listen_method_S_0005,
    tcp_server_listen_method_S_0006,
    tcp_server_listen_method_S_0007,
    tcp_server_listen_method_S_0008,
    tcp_server_listen_method_S_0009,
    tcp_server_listen_method_tcp_server_listen_method_S_0004_body,
    tcp_server_listen_method_tcp_server_listen_method_S_0007_body  
  );
  signal tcp_server_listen_method : Type_tcp_server_listen_method := tcp_server_listen_method_IDLE;
  signal tcp_server_listen_method_delay : signed(32-1 downto 0) := (others => '0');
  signal tmp_0133 : std_logic;
  signal read_data_call_flag_0007 : std_logic;
  signal tmp_0134 : std_logic;
  signal tmp_0135 : std_logic;
  signal tmp_0136 : std_logic;
  signal tmp_0137 : std_logic;
  signal tmp_0138 : std_logic;
  signal tcp_server_listen_return : signed(8-1 downto 0) := (others => '0');
  signal tmp_0139 : signed(32-1 downto 0);
  signal tmp_0140 : signed(32-1 downto 0);
  signal tmp_0141 : signed(32-1 downto 0);
  signal tmp_0142 : signed(32-1 downto 0);
  type Type_wait_for_established_method is (
    wait_for_established_method_IDLE,
    wait_for_established_method_S_0000,
    wait_for_established_method_S_0001,
    wait_for_established_method_S_0002,
    wait_for_established_method_S_0003,
    wait_for_established_method_S_0004,
    wait_for_established_method_S_0005,
    wait_for_established_method_S_0006,
    wait_for_established_method_S_0007,
    wait_for_established_method_S_0008,
    wait_for_established_method_S_0009,
    wait_for_established_method_S_0010,
    wait_for_established_method_S_0011,
    wait_for_established_method_S_0012,
    wait_for_established_method_S_0013,
    wait_for_established_method_S_0014,
    wait_for_established_method_wait_for_established_method_S_0006_body  
  );
  signal wait_for_established_method : Type_wait_for_established_method := wait_for_established_method_IDLE;
  signal wait_for_established_method_delay : signed(32-1 downto 0) := (others => '0');
  signal tmp_0143 : std_logic;
  signal tmp_0144 : std_logic;
  signal read_data_call_flag_0006 : std_logic;
  signal tmp_0145 : std_logic;
  signal tmp_0146 : std_logic;
  signal tmp_0147 : std_logic;
  signal tmp_0148 : std_logic;
  signal tmp_0149 : std_logic;
  signal tmp_0150 : std_logic;
  signal tmp_0151 : std_logic;
  signal tmp_0152 : signed(32-1 downto 0);
  signal tmp_0153 : signed(32-1 downto 0);
  signal tmp_0154 : std_logic;
  type Type_wait_for_recv_method is (
    wait_for_recv_method_IDLE,
    wait_for_recv_method_S_0000,
    wait_for_recv_method_S_0001,
    wait_for_recv_method_S_0002,
    wait_for_recv_method_S_0003,
    wait_for_recv_method_S_0004,
    wait_for_recv_method_S_0005,
    wait_for_recv_method_S_0007,
    wait_for_recv_method_S_0008,
    wait_for_recv_method_S_0009,
    wait_for_recv_method_S_0010,
    wait_for_recv_method_S_0013,
    wait_for_recv_method_S_0014,
    wait_for_recv_method_S_0015,
    wait_for_recv_method_S_0018,
    wait_for_recv_method_S_0019,
    wait_for_recv_method_S_0020,
    wait_for_recv_method_S_0024,
    wait_for_recv_method_S_0025,
    wait_for_recv_method_S_0026,
    wait_for_recv_method_S_0027,
    wait_for_recv_method_S_0028,
    wait_for_recv_method_S_0029,
    wait_for_recv_method_S_0030,
    wait_for_recv_method_S_0031,
    wait_for_recv_method_S_0032,
    wait_for_recv_method_wait_for_recv_method_S_0008_body,
    wait_for_recv_method_wait_for_recv_method_S_0013_body,
    wait_for_recv_method_wait_for_recv_method_S_0018_body  
  );
  signal wait_for_recv_method : Type_wait_for_recv_method := wait_for_recv_method_IDLE;
  signal wait_for_recv_method_delay : signed(32-1 downto 0) := (others => '0');
  signal tmp_0155 : std_logic;
  signal tmp_0156 : std_logic;
  signal read_data_call_flag_0008 : std_logic;
  signal tmp_0157 : std_logic;
  signal tmp_0158 : std_logic;
  signal tmp_0159 : std_logic;
  signal tmp_0160 : std_logic;
  signal tmp_0161 : std_logic;
  signal read_data_call_flag_0013 : std_logic;
  signal tmp_0162 : std_logic;
  signal tmp_0163 : std_logic;
  signal tmp_0164 : std_logic;
  signal tmp_0165 : std_logic;
  signal tmp_0166 : std_logic;
  signal read_data_call_flag_0018 : std_logic;
  signal tmp_0167 : std_logic;
  signal tmp_0168 : std_logic;
  signal tmp_0169 : std_logic;
  signal tmp_0170 : std_logic;
  signal tmp_0171 : std_logic;
  signal tmp_0172 : std_logic;
  signal tmp_0173 : std_logic;
  signal wait_for_recv_return : signed(32-1 downto 0) := (others => '0');
  signal tmp_0174 : signed(32-1 downto 0);
  signal tmp_0175 : signed(32-1 downto 0);
  signal tmp_0176 : signed(32-1 downto 0);
  signal tmp_0177 : signed(32-1 downto 0);
  signal tmp_0178 : signed(32-1 downto 0);
  signal tmp_0179 : signed(32-1 downto 0);
  signal tmp_0180 : signed(32-1 downto 0);
  signal tmp_0181 : signed(32-1 downto 0);
  signal tmp_0182 : signed(32-1 downto 0);
  signal tmp_0183 : signed(32-1 downto 0);
  signal tmp_0184 : signed(32-1 downto 0);
  signal tmp_0185 : signed(32-1 downto 0);
  signal tmp_0186 : signed(32-1 downto 0);
  signal tmp_0187 : std_logic;
  type Type_pull_recv_data_method is (
    pull_recv_data_method_IDLE,
    pull_recv_data_method_S_0000,
    pull_recv_data_method_S_0001,
    pull_recv_data_method_S_0002,
    pull_recv_data_method_S_0003,
    pull_recv_data_method_S_0006,
    pull_recv_data_method_S_0007,
    pull_recv_data_method_S_0008,
    pull_recv_data_method_S_0009,
    pull_recv_data_method_S_0010,
    pull_recv_data_method_S_0011,
    pull_recv_data_method_S_0012,
    pull_recv_data_method_S_0013,
    pull_recv_data_method_S_0014,
    pull_recv_data_method_S_0015,
    pull_recv_data_method_S_0016,
    pull_recv_data_method_S_0017,
    pull_recv_data_method_S_0018,
    pull_recv_data_method_S_0019,
    pull_recv_data_method_S_0020,
    pull_recv_data_method_S_0021,
    pull_recv_data_method_S_0022,
    pull_recv_data_method_S_0023,
    pull_recv_data_method_S_0024,
    pull_recv_data_method_S_0026,
    pull_recv_data_method_S_0027,
    pull_recv_data_method_S_0028,
    pull_recv_data_method_S_0029,
    pull_recv_data_method_S_0030,
    pull_recv_data_method_S_0031,
    pull_recv_data_method_S_0032,
    pull_recv_data_method_S_0033,
    pull_recv_data_method_S_0034,
    pull_recv_data_method_S_0035,
    pull_recv_data_method_S_0036,
    pull_recv_data_method_pull_recv_data_method_S_0023_body,
    pull_recv_data_method_pull_recv_data_method_S_0030_body,
    pull_recv_data_method_pull_recv_data_method_S_0035_body  
  );
  signal pull_recv_data_method : Type_pull_recv_data_method := pull_recv_data_method_IDLE;
  signal pull_recv_data_method_delay : signed(32-1 downto 0) := (others => '0');
  signal tmp_0188 : std_logic;
  signal tmp_0189 : std_logic;
  signal tmp_0190 : std_logic;
  signal tmp_0191 : std_logic;
  signal read_data_call_flag_0023 : std_logic;
  signal tmp_0192 : std_logic;
  signal tmp_0193 : std_logic;
  signal tmp_0194 : std_logic;
  signal tmp_0195 : std_logic;
  signal tmp_0196 : std_logic;
  signal read_data_call_flag_0030 : std_logic;
  signal tmp_0197 : std_logic;
  signal tmp_0198 : std_logic;
  signal tmp_0199 : std_logic;
  signal tmp_0200 : std_logic;
  signal tmp_0201 : std_logic;
  signal write_data_call_flag_0035 : std_logic;
  signal tmp_0202 : std_logic;
  signal tmp_0203 : std_logic;
  signal tmp_0204 : std_logic;
  signal tmp_0205 : std_logic;
  signal tmp_0206 : std_logic;
  signal tmp_0207 : signed(32-1 downto 0);
  signal tmp_0208 : signed(32-1 downto 0);
  signal tmp_0209 : std_logic;
  signal tmp_0210 : signed(32-1 downto 0);
  signal tmp_0211 : std_logic;
  signal tmp_0212 : signed(32-1 downto 0);
  signal tmp_0213 : signed(32-1 downto 0);
  signal tmp_0214 : signed(32-1 downto 0);
  signal tmp_0215 : signed(32-1 downto 0);
  signal tmp_0216 : signed(32-1 downto 0);
  signal tmp_0217 : signed(32-1 downto 0);
  signal tmp_0218 : signed(32-1 downto 0);
  signal tmp_0219 : signed(32-1 downto 0);
  signal tmp_0220 : signed(32-1 downto 0);
  signal tmp_0221 : signed(32-1 downto 0);
  signal tmp_0222 : signed(32-1 downto 0);
  type Type_push_send_data_method is (
    push_send_data_method_IDLE,
    push_send_data_method_S_0000,
    push_send_data_method_S_0001,
    push_send_data_method_S_0002,
    push_send_data_method_S_0003,
    push_send_data_method_S_0006,
    push_send_data_method_S_0007,
    push_send_data_method_S_0008,
    push_send_data_method_S_0009,
    push_send_data_method_S_0010,
    push_send_data_method_S_0011,
    push_send_data_method_S_0012,
    push_send_data_method_S_0013,
    push_send_data_method_S_0014,
    push_send_data_method_S_0015,
    push_send_data_method_S_0016,
    push_send_data_method_S_0017,
    push_send_data_method_S_0018,
    push_send_data_method_S_0019,
    push_send_data_method_S_0020,
    push_send_data_method_S_0021,
    push_send_data_method_S_0023,
    push_send_data_method_S_0024,
    push_send_data_method_S_0025,
    push_send_data_method_S_0026,
    push_send_data_method_S_0027,
    push_send_data_method_S_0028,
    push_send_data_method_S_0030,
    push_send_data_method_S_0031,
    push_send_data_method_S_0032,
    push_send_data_method_S_0033,
    push_send_data_method_S_0034,
    push_send_data_method_S_0035,
    push_send_data_method_S_0036,
    push_send_data_method_S_0037,
    push_send_data_method_S_0040,
    push_send_data_method_S_0041,
    push_send_data_method_S_0042,
    push_send_data_method_S_0045,
    push_send_data_method_S_0046,
    push_send_data_method_S_0047,
    push_send_data_method_S_0050,
    push_send_data_method_S_0051,
    push_send_data_method_S_0052,
    push_send_data_method_S_0053,
    push_send_data_method_S_0054,
    push_send_data_method_push_send_data_method_S_0024_body,
    push_send_data_method_push_send_data_method_S_0031_body,
    push_send_data_method_push_send_data_method_S_0035_body,
    push_send_data_method_push_send_data_method_S_0040_body,
    push_send_data_method_push_send_data_method_S_0045_body,
    push_send_data_method_push_send_data_method_S_0050_body,
    push_send_data_method_push_send_data_method_S_0053_body  
  );
  signal push_send_data_method : Type_push_send_data_method := push_send_data_method_IDLE;
  signal push_send_data_method_delay : signed(32-1 downto 0) := (others => '0');
  signal tmp_0223 : std_logic;
  signal tmp_0224 : std_logic;
  signal tmp_0225 : std_logic;
  signal tmp_0226 : std_logic;
  signal write_data_call_flag_0024 : std_logic;
  signal tmp_0227 : std_logic;
  signal tmp_0228 : std_logic;
  signal tmp_0229 : std_logic;
  signal tmp_0230 : std_logic;
  signal tmp_0231 : std_logic;
  signal write_data_call_flag_0031 : std_logic;
  signal tmp_0232 : std_logic;
  signal tmp_0233 : std_logic;
  signal tmp_0234 : std_logic;
  signal tmp_0235 : std_logic;
  signal tmp_0236 : std_logic;
  signal tmp_0237 : std_logic;
  signal write_data_call_flag_0040 : std_logic;
  signal tmp_0238 : std_logic;
  signal tmp_0239 : std_logic;
  signal tmp_0240 : std_logic;
  signal tmp_0241 : std_logic;
  signal tmp_0242 : std_logic;
  signal write_data_call_flag_0045 : std_logic;
  signal tmp_0243 : std_logic;
  signal tmp_0244 : std_logic;
  signal tmp_0245 : std_logic;
  signal tmp_0246 : std_logic;
  signal tmp_0247 : std_logic;
  signal write_data_call_flag_0050 : std_logic;
  signal tmp_0248 : std_logic;
  signal tmp_0249 : std_logic;
  signal tmp_0250 : std_logic;
  signal tmp_0251 : std_logic;
  signal tmp_0252 : std_logic;
  signal write_data_call_flag_0053 : std_logic;
  signal tmp_0253 : std_logic;
  signal tmp_0254 : std_logic;
  signal tmp_0255 : std_logic;
  signal tmp_0256 : std_logic;
  signal tmp_0257 : std_logic;
  signal tmp_0258 : signed(32-1 downto 0);
  signal tmp_0259 : signed(32-1 downto 0);
  signal tmp_0260 : std_logic;
  signal tmp_0261 : signed(32-1 downto 0);
  signal tmp_0262 : std_logic;
  signal tmp_0263 : signed(32-1 downto 0);
  signal tmp_0264 : signed(32-1 downto 0);
  signal tmp_0265 : signed(32-1 downto 0);
  signal tmp_0266 : signed(32-1 downto 0);
  signal tmp_0267 : signed(32-1 downto 0);
  signal tmp_0268 : signed(32-1 downto 0);
  signal tmp_0269 : signed(32-1 downto 0);
  signal tmp_0270 : signed(32-1 downto 0);
  signal tmp_0271 : signed(32-1 downto 0);
  signal tmp_0272 : signed(32-1 downto 0);
  signal tmp_0273 : signed(32-1 downto 0);
  signal tmp_0274 : signed(32-1 downto 0);
  signal tmp_0275 : signed(32-1 downto 0);
  signal tmp_0276 : signed(32-1 downto 0);
  signal tmp_0277 : signed(8-1 downto 0);
  signal tmp_0278 : signed(32-1 downto 0);
  signal tmp_0279 : signed(32-1 downto 0);
  signal tmp_0280 : signed(32-1 downto 0);
  signal tmp_0281 : signed(8-1 downto 0);
  signal tmp_0282 : signed(32-1 downto 0);
  signal tmp_0283 : signed(32-1 downto 0);
  signal tmp_0284 : signed(32-1 downto 0);
  signal tmp_0285 : signed(8-1 downto 0);
  signal tmp_0286 : signed(32-1 downto 0);
  signal tmp_0287 : signed(32-1 downto 0);
  type Type_tcp_server_method is (
    tcp_server_method_IDLE,
    tcp_server_method_S_0000,
    tcp_server_method_S_0001,
    tcp_server_method_S_0002,
    tcp_server_method_S_0003,
    tcp_server_method_S_0004,
    tcp_server_method_S_0005,
    tcp_server_method_S_0006,
    tcp_server_method_S_0007,
    tcp_server_method_S_0008,
    tcp_server_method_S_0009,
    tcp_server_method_S_0010,
    tcp_server_method_S_0011,
    tcp_server_method_S_0012,
    tcp_server_method_S_0013,
    tcp_server_method_S_0014,
    tcp_server_method_S_0015,
    tcp_server_method_S_0016,
    tcp_server_method_S_0017,
    tcp_server_method_S_0018,
    tcp_server_method_S_0019,
    tcp_server_method_S_0020,
    tcp_server_method_S_0021,
    tcp_server_method_S_0022,
    tcp_server_method_S_0023,
    tcp_server_method_S_0024,
    tcp_server_method_S_0025,
    tcp_server_method_S_0026,
    tcp_server_method_S_0027,
    tcp_server_method_S_0028,
    tcp_server_method_S_0029,
    tcp_server_method_S_0030,
    tcp_server_method_S_0031,
    tcp_server_method_S_0032,
    tcp_server_method_S_0033,
    tcp_server_method_S_0034,
    tcp_server_method_S_0035,
    tcp_server_method_tcp_server_method_S_0004_body,
    tcp_server_method_tcp_server_method_S_0005_body,
    tcp_server_method_tcp_server_method_S_0012_body,
    tcp_server_method_tcp_server_method_S_0013_body,
    tcp_server_method_tcp_server_method_S_0016_body,
    tcp_server_method_tcp_server_method_S_0023_body,
    tcp_server_method_tcp_server_method_S_0024_body,
    tcp_server_method_tcp_server_method_S_0027_body,
    tcp_server_method_tcp_server_method_S_0030_body,
    tcp_server_method_tcp_server_method_S_0032_body,
    tcp_server_method_tcp_server_method_S_0033_body  
  );
  signal tcp_server_method : Type_tcp_server_method := tcp_server_method_IDLE;
  signal tcp_server_method_delay : signed(32-1 downto 0) := (others => '0');
  signal tmp_0288 : std_logic;
  signal tcp_server_open_call_flag_0005 : std_logic;
  signal tmp_0289 : std_logic;
  signal tmp_0290 : std_logic;
  signal tmp_0291 : std_logic;
  signal tmp_0292 : std_logic;
  signal tmp_0293 : std_logic;
  signal tmp_0294 : std_logic;
  signal tmp_0295 : std_logic;
  signal tmp_0296 : std_logic;
  signal tcp_server_open_call_flag_0013 : std_logic;
  signal tmp_0297 : std_logic;
  signal tmp_0298 : std_logic;
  signal tmp_0299 : std_logic;
  signal tmp_0300 : std_logic;
  signal tmp_0301 : std_logic;
  signal tcp_server_listen_call_flag_0016 : std_logic;
  signal tmp_0302 : std_logic;
  signal tmp_0303 : std_logic;
  signal tmp_0304 : std_logic;
  signal tmp_0305 : std_logic;
  signal tmp_0306 : std_logic;
  signal tmp_0307 : std_logic;
  signal tmp_0308 : std_logic;
  signal write_data_call_flag_0023 : std_logic;
  signal tmp_0309 : std_logic;
  signal tmp_0310 : std_logic;
  signal tmp_0311 : std_logic;
  signal tmp_0312 : std_logic;
  signal tmp_0313 : std_logic;
  signal tcp_server_listen_call_flag_0024 : std_logic;
  signal tmp_0314 : std_logic;
  signal tmp_0315 : std_logic;
  signal tmp_0316 : std_logic;
  signal tmp_0317 : std_logic;
  signal tmp_0318 : std_logic;
  signal wait_for_established_call_flag_0027 : std_logic;
  signal tmp_0319 : std_logic;
  signal tmp_0320 : std_logic;
  signal tmp_0321 : std_logic;
  signal tmp_0322 : std_logic;
  signal tmp_0323 : std_logic;
  signal tmp_0324 : std_logic;
  signal tmp_0325 : std_logic;
  signal wait_for_recv_call_flag_0030 : std_logic;
  signal tmp_0326 : std_logic;
  signal tmp_0327 : std_logic;
  signal tmp_0328 : std_logic;
  signal tmp_0329 : std_logic;
  signal tmp_0330 : std_logic;
  signal pull_recv_data_call_flag_0032 : std_logic;
  signal tmp_0331 : std_logic;
  signal tmp_0332 : std_logic;
  signal tmp_0333 : std_logic;
  signal tmp_0334 : std_logic;
  signal tmp_0335 : std_logic;
  signal push_send_data_call_flag_0033 : std_logic;
  signal tmp_0336 : std_logic;
  signal tmp_0337 : std_logic;
  signal tmp_0338 : std_logic;
  signal tmp_0339 : std_logic;
  signal tmp_0340 : std_logic;
  signal tmp_0341 : signed(32-1 downto 0);
  signal tmp_0342 : signed(32-1 downto 0);
  signal tmp_0343 : std_logic;
  signal tmp_0344 : signed(32-1 downto 0);
  signal tmp_0345 : signed(32-1 downto 0);
  signal tmp_0346 : std_logic;
  signal tmp_0347 : signed(32-1 downto 0);
  signal tmp_0348 : signed(32-1 downto 0);
  type Type_test_method is (
    test_method_IDLE,
    test_method_S_0000,
    test_method_S_0001,
    test_method_S_0002,
    test_method_S_0003,
    test_method_S_0004,
    test_method_S_0005,
    test_method_S_0006,
    test_method_S_0007,
    test_method_S_0008,
    test_method_test_method_S_0002_body,
    test_method_test_method_S_0003_body,
    test_method_test_method_S_0004_body  
  );
  signal test_method : Type_test_method := test_method_IDLE;
  signal test_method_delay : signed(32-1 downto 0) := (others => '0');
  signal init_call_flag_0002 : std_logic;
  signal tmp_0349 : std_logic;
  signal tmp_0350 : std_logic;
  signal tmp_0351 : std_logic;
  signal tmp_0352 : std_logic;
  signal tmp_0353 : std_logic;
  signal network_configuration_call_flag_0003 : std_logic;
  signal tmp_0354 : std_logic;
  signal tmp_0355 : std_logic;
  signal tmp_0356 : std_logic;
  signal tmp_0357 : std_logic;
  signal tmp_0358 : std_logic;
  signal tcp_server_call_flag_0004 : std_logic;
  signal tmp_0359 : std_logic;
  signal tmp_0360 : std_logic;
  signal tmp_0361 : std_logic;
  signal tmp_0362 : std_logic;
  signal tmp_0363 : std_logic;
  signal tmp_0364 : std_logic;
  signal tmp_0365 : std_logic;
  type Type_blink_led_method is (
    blink_led_method_IDLE,
    blink_led_method_S_0000,
    blink_led_method_S_0001,
    blink_led_method_S_0002,
    blink_led_method_S_0003,
    blink_led_method_S_0004,
    blink_led_method_S_0005,
    blink_led_method_S_0006,
    blink_led_method_S_0007,
    blink_led_method_S_0008,
    blink_led_method_S_0009,
    blink_led_method_S_0010,
    blink_led_method_S_0011,
    blink_led_method_S_0012,
    blink_led_method_S_0013,
    blink_led_method_S_0014,
    blink_led_method_S_0015,
    blink_led_method_S_0016,
    blink_led_method_S_0017,
    blink_led_method_S_0018,
    blink_led_method_S_0019,
    blink_led_method_S_0020,
    blink_led_method_S_0021  
  );
  signal blink_led_method : Type_blink_led_method := blink_led_method_IDLE;
  signal blink_led_method_delay : signed(32-1 downto 0) := (others => '0');
  signal tmp_0366 : std_logic;
  signal tmp_0367 : std_logic;
  signal tmp_0368 : std_logic;
  signal tmp_0369 : std_logic;
  signal tmp_0370 : std_logic;
  signal tmp_0371 : std_logic;
  signal tmp_0372 : std_logic;
  signal tmp_0373 : signed(32-1 downto 0);
  signal tmp_0374 : std_logic;
  signal tmp_0375 : signed(32-1 downto 0);

begin

  clk_sig <= clk;
  reset_sig <= reset;
--  class_wiz830mj_0000_ADDR_exp <= class_wiz830mj_0000_ADDR_exp_sig;
--  class_wiz830mj_0000_ADDR_exp_sig <= class_wiz830mj_0000_ADDR;

--  class_wiz830mj_0000_DATA_exp_sig <= class_wiz830mj_0000_DATA_exp;
--  class_wiz830mj_0000_nCS_exp <= class_wiz830mj_0000_nCS_exp_sig;
--  class_wiz830mj_0000_nCS_exp_sig <= class_wiz830mj_0000_nCS;

--  class_wiz830mj_0000_nRD_exp <= class_wiz830mj_0000_nRD_exp_sig;
--  class_wiz830mj_0000_nRD_exp_sig <= class_wiz830mj_0000_nRD;

--  class_wiz830mj_0000_nWR_exp <= class_wiz830mj_0000_nWR_exp_sig;
--  class_wiz830mj_0000_nWR_exp_sig <= class_wiz830mj_0000_nWR;

--  class_wiz830mj_0000_nINT_exp_sig <= class_wiz830mj_0000_nINT_exp;
--  class_wiz830mj_0000_nRESET_exp <= class_wiz830mj_0000_nRESET_exp_sig;
--  class_wiz830mj_0000_nRESET_exp_sig <= class_wiz830mj_0000_nRESET;

--  class_wiz830mj_0000_BRDY_exp_sig <= class_wiz830mj_0000_BRDY_exp;
  led_in_sig <= led_in;
  led_we_sig <= led_we;
  led_out <= led_out_sig;
  led_out_sig <= class_led_0002;

  test_req_sig <= test_req;
  test_busy <= test_busy_sig;
  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        test_busy_sig <= '1';
      else
        if test_method = test_method_S_0001 then
          test_busy_sig <= test_req_flag;
        end if;
      end if;
    end if;
  end process;

  blink_led_req_sig <= blink_led_req;
  blink_led_busy <= blink_led_busy_sig;
  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        blink_led_busy_sig <= '1';
      else
        if blink_led_method = blink_led_method_S_0001 then
          blink_led_busy_sig <= blink_led_req_flag;
        end if;
      end if;
    end if;
  end process;


  -- expressions
  tmp_0001 <= led_in_sig when led_we_sig = '1' else class_led_0002;
  tmp_0002 <= test_req_local or test_req_sig;
  tmp_0003 <= blink_led_req_local or blink_led_req_sig;
  tmp_0004 <= '1' when binary_expr_00091 = '1' else '0';
  tmp_0005 <= '1' when binary_expr_00091 = '0' else '0';
  tmp_0006 <= '1' when wait_cycles_i_0090 < wait_cycles_n_0089 else '0';
  tmp_0007 <= wait_cycles_i_0090 + X"00000001";
  tmp_0008 <= '1' when wait_cycles_busy = '0' else '0';
  tmp_0009 <= '1' when wait_cycles_req_local = '0' else '0';
  tmp_0010 <= tmp_0008 and tmp_0009;
  tmp_0011 <= '1' when tmp_0010 = '1' else '0';
  tmp_0012 <= '1' when wait_cycles_busy = '0' else '0';
  tmp_0013 <= '1' when wait_cycles_busy = '0' else '0';
  tmp_0014 <= '1' when wait_cycles_req_local = '0' else '0';
  tmp_0015 <= tmp_0013 and tmp_0014;
  tmp_0016 <= '1' when tmp_0015 = '1' else '0';
  tmp_0017 <= '1' when wait_cycles_busy = '0' else '0';
  tmp_0018 <= '1' when wait_cycles_busy = '0' else '0';
  tmp_0019 <= '1' when wait_cycles_busy = '0' else '0';
  tmp_0020 <= '1' when wait_cycles_req_local = '0' else '0';
  tmp_0021 <= tmp_0019 and tmp_0020;
  tmp_0022 <= '1' when tmp_0021 = '1' else '0';
  tmp_0023 <= '1' when wait_cycles_busy = '0' else '0';
  tmp_0024 <= '1' when write_data_busy = '0' else '0';
  tmp_0025 <= '1' when write_data_req_local = '0' else '0';
  tmp_0026 <= tmp_0024 and tmp_0025;
  tmp_0027 <= '1' when tmp_0026 = '1' else '0';
  tmp_0028 <= '1' when write_data_busy = '0' else '0';
  tmp_0029 <= '1' when write_data_busy = '0' else '0';
  tmp_0030 <= '1' when write_data_req_local = '0' else '0';
  tmp_0031 <= tmp_0029 and tmp_0030;
  tmp_0032 <= '1' when tmp_0031 = '1' else '0';
  tmp_0033 <= '1' when write_data_busy = '0' else '0';
  tmp_0034 <= '1' when write_data_busy = '0' else '0';
  tmp_0035 <= '1' when write_data_req_local = '0' else '0';
  tmp_0036 <= tmp_0034 and tmp_0035;
  tmp_0037 <= '1' when tmp_0036 = '1' else '0';
  tmp_0038 <= '1' when write_data_busy = '0' else '0';
  tmp_0039 <= '1' when write_data_busy = '0' else '0';
  tmp_0040 <= '1' when write_data_req_local = '0' else '0';
  tmp_0041 <= tmp_0039 and tmp_0040;
  tmp_0042 <= '1' when tmp_0041 = '1' else '0';
  tmp_0043 <= '1' when write_data_busy = '0' else '0';
  tmp_0044 <= '1' when write_data_busy = '0' else '0';
  tmp_0045 <= '1' when write_data_req_local = '0' else '0';
  tmp_0046 <= tmp_0044 and tmp_0045;
  tmp_0047 <= '1' when tmp_0046 = '1' else '0';
  tmp_0048 <= '1' when write_data_busy = '0' else '0';
  tmp_0049 <= '1' when write_data_busy = '0' else '0';
  tmp_0050 <= '1' when write_data_req_local = '0' else '0';
  tmp_0051 <= tmp_0049 and tmp_0050;
  tmp_0052 <= '1' when tmp_0051 = '1' else '0';
  tmp_0053 <= '1' when write_data_busy = '0' else '0';
  tmp_0054 <= '1' when write_data_busy = '0' else '0';
  tmp_0055 <= '1' when write_data_req_local = '0' else '0';
  tmp_0056 <= tmp_0054 and tmp_0055;
  tmp_0057 <= '1' when tmp_0056 = '1' else '0';
  tmp_0058 <= '1' when write_data_busy = '0' else '0';
  tmp_0059 <= '1' when write_data_busy = '0' else '0';
  tmp_0060 <= '1' when write_data_req_local = '0' else '0';
  tmp_0061 <= tmp_0059 and tmp_0060;
  tmp_0062 <= '1' when tmp_0061 = '1' else '0';
  tmp_0063 <= '1' when write_data_busy = '0' else '0';
  tmp_0064 <= '1' when write_data_busy = '0' else '0';
  tmp_0065 <= '1' when write_data_req_local = '0' else '0';
  tmp_0066 <= tmp_0064 and tmp_0065;
  tmp_0067 <= '1' when tmp_0066 = '1' else '0';
  tmp_0068 <= '1' when write_data_busy = '0' else '0';
  tmp_0069 <= '1' when write_data_busy = '0' else '0';
  tmp_0070 <= '1' when write_data_req_local = '0' else '0';
  tmp_0071 <= tmp_0069 and tmp_0070;
  tmp_0072 <= '1' when tmp_0071 = '1' else '0';
  tmp_0073 <= '1' when write_data_busy = '0' else '0';
  tmp_0074 <= '1' when write_data_busy = '0' else '0';
  tmp_0075 <= '1' when write_data_req_local = '0' else '0';
  tmp_0076 <= tmp_0074 and tmp_0075;
  tmp_0077 <= '1' when tmp_0076 = '1' else '0';
  tmp_0078 <= '1' when write_data_busy = '0' else '0';
  tmp_0079 <= '1' when write_data_busy = '0' else '0';
  tmp_0080 <= '1' when write_data_req_local = '0' else '0';
  tmp_0081 <= tmp_0079 and tmp_0080;
  tmp_0082 <= '1' when tmp_0081 = '1' else '0';
  tmp_0083 <= '1' when write_data_busy = '0' else '0';
  tmp_0084 <= '1' when write_data_busy = '0' else '0';
  tmp_0085 <= '1' when write_data_req_local = '0' else '0';
  tmp_0086 <= tmp_0084 and tmp_0085;
  tmp_0087 <= '1' when tmp_0086 = '1' else '0';
  tmp_0088 <= '1' when write_data_busy = '0' else '0';
  tmp_0089 <= '1' when write_data_busy = '0' else '0';
  tmp_0090 <= '1' when write_data_req_local = '0' else '0';
  tmp_0091 <= tmp_0089 and tmp_0090;
  tmp_0092 <= '1' when tmp_0091 = '1' else '0';
  tmp_0093 <= '1' when write_data_busy = '0' else '0';
  tmp_0094 <= '1' when write_data_busy = '0' else '0';
  tmp_0095 <= '1' when write_data_req_local = '0' else '0';
  tmp_0096 <= tmp_0094 and tmp_0095;
  tmp_0097 <= '1' when tmp_0096 = '1' else '0';
  tmp_0098 <= '1' when write_data_busy = '0' else '0';
  tmp_0099 <= '1' when write_data_busy = '0' else '0';
  tmp_0100 <= '1' when write_data_req_local = '0' else '0';
  tmp_0101 <= tmp_0099 and tmp_0100;
  tmp_0102 <= '1' when tmp_0101 = '1' else '0';
  tmp_0103 <= '1' when write_data_busy = '0' else '0';
  tmp_0104 <= '1' when write_data_busy = '0' else '0';
  tmp_0105 <= '1' when write_data_req_local = '0' else '0';
  tmp_0106 <= tmp_0104 and tmp_0105;
  tmp_0107 <= '1' when tmp_0106 = '1' else '0';
  tmp_0108 <= '1' when write_data_busy = '0' else '0';
  tmp_0109 <= '1' when write_data_busy = '0' else '0';
  tmp_0110 <= '1' when write_data_req_local = '0' else '0';
  tmp_0111 <= tmp_0109 and tmp_0110;
  tmp_0112 <= '1' when tmp_0111 = '1' else '0';
  tmp_0113 <= '1' when write_data_busy = '0' else '0';
  tmp_0114 <= '1' when write_data_busy = '0' else '0';
  tmp_0115 <= '1' when write_data_busy = '0' else '0';
  tmp_0116 <= '1' when write_data_busy = '0' else '0';
  tmp_0117 <= '1' when write_data_busy = '0' else '0';
  tmp_0118 <= '1' when read_data_busy = '0' else '0';
  tmp_0119 <= '1' when read_data_req_local = '0' else '0';
  tmp_0120 <= tmp_0118 and tmp_0119;
  tmp_0121 <= '1' when tmp_0120 = '1' else '0';
  tmp_0122 <= '1' when read_data_busy = '0' else '0';
  tmp_0123 <= tcp_server_open_port_0136(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0124 <= class_Sn_MR1_0004 + binary_expr_00138;
  tmp_0125 <= tcp_server_open_port_0136(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0126 <= class_Sn_PORTR0_0013 + binary_expr_00141;
  tmp_0127 <= tcp_server_open_port_0136(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0128 <= class_Sn_PORTR1_0014 + binary_expr_00144;
  tmp_0129 <= tcp_server_open_port_0136(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0130 <= class_Sn_CR1_0006 + binary_expr_00147;
  tmp_0131 <= tcp_server_open_port_0136(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0132 <= class_Sn_SSR1_0012 + binary_expr_00150;
  tmp_0133 <= '1' when write_data_busy = '0' else '0';
  tmp_0134 <= '1' when read_data_busy = '0' else '0';
  tmp_0135 <= '1' when read_data_req_local = '0' else '0';
  tmp_0136 <= tmp_0134 and tmp_0135;
  tmp_0137 <= '1' when tmp_0136 = '1' else '0';
  tmp_0138 <= '1' when read_data_busy = '0' else '0';
  tmp_0139 <= tcp_server_listen_port_0152(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0140 <= class_Sn_CR1_0006 + binary_expr_00154;
  tmp_0141 <= tcp_server_listen_port_0152(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0142 <= class_Sn_SSR1_0012 + binary_expr_00157;
  tmp_0143 <= '1' and '1';
  tmp_0144 <= '1' and '0';
  tmp_0145 <= '1' when read_data_busy = '0' else '0';
  tmp_0146 <= '1' when read_data_req_local = '0' else '0';
  tmp_0147 <= tmp_0145 and tmp_0146;
  tmp_0148 <= '1' when tmp_0147 = '1' else '0';
  tmp_0149 <= '1' when read_data_busy = '0' else '0';
  tmp_0150 <= '1' when binary_expr_00164 = '1' else '0';
  tmp_0151 <= '1' when binary_expr_00164 = '0' else '0';
  tmp_0152 <= wait_for_established_port_0159(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0153 <= class_Sn_SSR1_0012 + binary_expr_00162;
  tmp_0154 <= '1' when wait_for_established_v_0160 = class_Sn_SOCK_ESTABLISHED_0076 else '0';
  tmp_0155 <= '1' and '1';
  tmp_0156 <= '1' and '0';
  tmp_0157 <= '1' when read_data_busy = '0' else '0';
  tmp_0158 <= '1' when read_data_req_local = '0' else '0';
  tmp_0159 <= tmp_0157 and tmp_0158;
  tmp_0160 <= '1' when tmp_0159 = '1' else '0';
  tmp_0161 <= '1' when read_data_busy = '0' else '0';
  tmp_0162 <= '1' when read_data_busy = '0' else '0';
  tmp_0163 <= '1' when read_data_req_local = '0' else '0';
  tmp_0164 <= tmp_0162 and tmp_0163;
  tmp_0165 <= '1' when tmp_0164 = '1' else '0';
  tmp_0166 <= '1' when read_data_busy = '0' else '0';
  tmp_0167 <= '1' when read_data_busy = '0' else '0';
  tmp_0168 <= '1' when read_data_req_local = '0' else '0';
  tmp_0169 <= tmp_0167 and tmp_0168;
  tmp_0170 <= '1' when tmp_0169 = '1' else '0';
  tmp_0171 <= '1' when read_data_busy = '0' else '0';
  tmp_0172 <= '1' when binary_expr_00186 = '1' else '0';
  tmp_0173 <= '1' when binary_expr_00186 = '0' else '0';
  tmp_0174 <= wait_for_recv_port_0165(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0175 <= class_Sn_RX_RSR1_0044 + binary_expr_00169;
  tmp_0176 <= (32-1 downto 8 => method_result_00168(7)) & method_result_00168;
  tmp_0177 <= wait_for_recv_port_0165(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0178 <= class_Sn_RX_RSR2_0045 + binary_expr_00174;
  tmp_0179 <= (32-1 downto 8 => method_result_00173(7)) & method_result_00173;
  tmp_0180 <= wait_for_recv_port_0165(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0181 <= class_Sn_RX_RSR3_0046 + binary_expr_00179;
  tmp_0182 <= (32-1 downto 8 => method_result_00178(7)) & method_result_00178;
  tmp_0183 <= wait_for_recv_v0_0167(15 downto 0) & (16-1 downto 0 => '0');
  tmp_0184 <= wait_for_recv_v1_0172(23 downto 0) & (8-1 downto 0 => '0');
  tmp_0185 <= binary_expr_00182 + binary_expr_00183;
  tmp_0186 <= binary_expr_00184 + wait_for_recv_v2_0177;
  tmp_0187 <= '1' when wait_for_recv_v_0166 /= X"00000000" else '0';
  tmp_0188 <= '1' when binary_expr_00192 = '1' else '0';
  tmp_0189 <= '1' when binary_expr_00192 = '0' else '0';
  tmp_0190 <= '1' when binary_expr_00195 = '1' else '0';
  tmp_0191 <= '1' when binary_expr_00195 = '0' else '0';
  tmp_0192 <= '1' when read_data_busy = '0' else '0';
  tmp_0193 <= '1' when read_data_req_local = '0' else '0';
  tmp_0194 <= tmp_0192 and tmp_0193;
  tmp_0195 <= '1' when tmp_0194 = '1' else '0';
  tmp_0196 <= '1' when read_data_busy = '0' else '0';
  tmp_0197 <= '1' when read_data_busy = '0' else '0';
  tmp_0198 <= '1' when read_data_req_local = '0' else '0';
  tmp_0199 <= tmp_0197 and tmp_0198;
  tmp_0200 <= '1' when tmp_0199 = '1' else '0';
  tmp_0201 <= '1' when read_data_busy = '0' else '0';
  tmp_0202 <= '1' when write_data_busy = '0' else '0';
  tmp_0203 <= '1' when write_data_req_local = '0' else '0';
  tmp_0204 <= tmp_0202 and tmp_0203;
  tmp_0205 <= '1' when tmp_0204 = '1' else '0';
  tmp_0206 <= '1' when write_data_busy = '0' else '0';
  tmp_0207 <= (1-1 downto 0 => pull_recv_data_len_0188(31)) & pull_recv_data_len_0188(31 downto 1);
  tmp_0208 <= pull_recv_data_len_0188 and X"00000001";
  tmp_0209 <= '1' when binary_expr_00191 = X"00000001" else '0';
  tmp_0210 <= pull_recv_data_read_len_0189 + X"00000001";
  tmp_0211 <= '1' when pull_recv_data_i_0194 < pull_recv_data_read_len_0189 else '0';
  tmp_0212 <= pull_recv_data_i_0194 + X"00000001";
  tmp_0213 <= pull_recv_data_i_0194(30 downto 0) & (1-1 downto 0 => '0');
  tmp_0214 <= binary_expr_00197 + X"00000000";
  tmp_0215 <= pull_recv_data_port_0187(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0216 <= class_Sn_RX_FIFOR0_0051 + binary_expr_00201;
  tmp_0217 <= pull_recv_data_i_0194(30 downto 0) & (1-1 downto 0 => '0');
  tmp_0218 <= binary_expr_00203 + X"00000001";
  tmp_0219 <= pull_recv_data_port_0187(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0220 <= class_Sn_RX_FIFOR1_0052 + binary_expr_00207;
  tmp_0221 <= pull_recv_data_port_0187(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0222 <= class_Sn_CR1_0006 + binary_expr_00210;
  tmp_0223 <= '1' when binary_expr_00217 = '1' else '0';
  tmp_0224 <= '1' when binary_expr_00217 = '0' else '0';
  tmp_0225 <= '1' when binary_expr_00220 = '1' else '0';
  tmp_0226 <= '1' when binary_expr_00220 = '0' else '0';
  tmp_0227 <= '1' when write_data_busy = '0' else '0';
  tmp_0228 <= '1' when write_data_req_local = '0' else '0';
  tmp_0229 <= tmp_0227 and tmp_0228;
  tmp_0230 <= '1' when tmp_0229 = '1' else '0';
  tmp_0231 <= '1' when write_data_busy = '0' else '0';
  tmp_0232 <= '1' when write_data_busy = '0' else '0';
  tmp_0233 <= '1' when write_data_req_local = '0' else '0';
  tmp_0234 <= tmp_0232 and tmp_0233;
  tmp_0235 <= '1' when tmp_0234 = '1' else '0';
  tmp_0236 <= '1' when write_data_busy = '0' else '0';
  tmp_0237 <= '1' when write_data_busy = '0' else '0';
  tmp_0238 <= '1' when write_data_busy = '0' else '0';
  tmp_0239 <= '1' when write_data_req_local = '0' else '0';
  tmp_0240 <= tmp_0238 and tmp_0239;
  tmp_0241 <= '1' when tmp_0240 = '1' else '0';
  tmp_0242 <= '1' when write_data_busy = '0' else '0';
  tmp_0243 <= '1' when write_data_busy = '0' else '0';
  tmp_0244 <= '1' when write_data_req_local = '0' else '0';
  tmp_0245 <= tmp_0243 and tmp_0244;
  tmp_0246 <= '1' when tmp_0245 = '1' else '0';
  tmp_0247 <= '1' when write_data_busy = '0' else '0';
  tmp_0248 <= '1' when write_data_busy = '0' else '0';
  tmp_0249 <= '1' when write_data_req_local = '0' else '0';
  tmp_0250 <= tmp_0248 and tmp_0249;
  tmp_0251 <= '1' when tmp_0250 = '1' else '0';
  tmp_0252 <= '1' when write_data_busy = '0' else '0';
  tmp_0253 <= '1' when write_data_busy = '0' else '0';
  tmp_0254 <= '1' when write_data_req_local = '0' else '0';
  tmp_0255 <= tmp_0253 and tmp_0254;
  tmp_0256 <= '1' when tmp_0255 = '1' else '0';
  tmp_0257 <= '1' when write_data_busy = '0' else '0';
  tmp_0258 <= (1-1 downto 0 => push_send_data_len_0213(31)) & push_send_data_len_0213(31 downto 1);
  tmp_0259 <= push_send_data_len_0213 and X"00000001";
  tmp_0260 <= '1' when binary_expr_00216 = X"00000001" else '0';
  tmp_0261 <= push_send_data_write_len_0214 + X"00000001";
  tmp_0262 <= '1' when push_send_data_i_0219 < push_send_data_write_len_0214 else '0';
  tmp_0263 <= push_send_data_i_0219 + X"00000001";
  tmp_0264 <= push_send_data_i_0219(30 downto 0) & (1-1 downto 0 => '0');
  tmp_0265 <= binary_expr_00223 + X"00000000";
  tmp_0266 <= push_send_data_port_0212(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0267 <= class_Sn_TX_FIFOR0_0049 + binary_expr_00227;
  tmp_0268 <= push_send_data_i_0219(30 downto 0) & (1-1 downto 0 => '0');
  tmp_0269 <= binary_expr_00229 + X"00000001";
  tmp_0270 <= push_send_data_port_0212(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0271 <= class_Sn_TX_FIFOR1_0050 + binary_expr_00233;
  tmp_0272 <= push_send_data_port_0212(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0273 <= class_Sn_CR1_0006 + binary_expr_00236;
  tmp_0274 <= push_send_data_port_0212(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0275 <= (16-1 downto 0 => push_send_data_len_0213(31)) & push_send_data_len_0213(31 downto 16);
  tmp_0276 <= class_Sn_TX_WRSR1_0036 + binary_expr_00239;
  tmp_0277 <= binary_expr_00241(32 - 24 - 1 downto 0);
  tmp_0278 <= push_send_data_port_0212(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0279 <= (8-1 downto 0 => push_send_data_len_0213(31)) & push_send_data_len_0213(31 downto 8);
  tmp_0280 <= class_Sn_TX_WRSR2_0037 + binary_expr_00244;
  tmp_0281 <= binary_expr_00246(32 - 24 - 1 downto 0);
  tmp_0282 <= push_send_data_port_0212(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0283 <= push_send_data_len_0213;
  tmp_0284 <= class_Sn_TX_WRSR3_0038 + binary_expr_00249;
  tmp_0285 <= binary_expr_00251(32 - 24 - 1 downto 0);
  tmp_0286 <= push_send_data_port_0212(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0287 <= class_Sn_CR1_0006 + binary_expr_00254;
  tmp_0288 <= '1' when write_data_busy = '0' else '0';
  tmp_0289 <= '1' when tcp_server_open_busy = '0' else '0';
  tmp_0290 <= '1' when tcp_server_open_req_local = '0' else '0';
  tmp_0291 <= tmp_0289 and tmp_0290;
  tmp_0292 <= '1' when tmp_0291 = '1' else '0';
  tmp_0293 <= '1' when tcp_server_open_busy = '0' else '0';
  tmp_0294 <= '1' when binary_expr_00262 = '1' else '0';
  tmp_0295 <= '1' when binary_expr_00262 = '0' else '0';
  tmp_0296 <= '1' when write_data_busy = '0' else '0';
  tmp_0297 <= '1' when tcp_server_open_busy = '0' else '0';
  tmp_0298 <= '1' when tcp_server_open_req_local = '0' else '0';
  tmp_0299 <= tmp_0297 and tmp_0298;
  tmp_0300 <= '1' when tmp_0299 = '1' else '0';
  tmp_0301 <= '1' when tcp_server_open_busy = '0' else '0';
  tmp_0302 <= '1' when tcp_server_listen_busy = '0' else '0';
  tmp_0303 <= '1' when tcp_server_listen_req_local = '0' else '0';
  tmp_0304 <= tmp_0302 and tmp_0303;
  tmp_0305 <= '1' when tmp_0304 = '1' else '0';
  tmp_0306 <= '1' when tcp_server_listen_busy = '0' else '0';
  tmp_0307 <= '1' when binary_expr_00268 = '1' else '0';
  tmp_0308 <= '1' when binary_expr_00268 = '0' else '0';
  tmp_0309 <= '1' when write_data_busy = '0' else '0';
  tmp_0310 <= '1' when write_data_req_local = '0' else '0';
  tmp_0311 <= tmp_0309 and tmp_0310;
  tmp_0312 <= '1' when tmp_0311 = '1' else '0';
  tmp_0313 <= '1' when write_data_busy = '0' else '0';
  tmp_0314 <= '1' when tcp_server_listen_busy = '0' else '0';
  tmp_0315 <= '1' when tcp_server_listen_req_local = '0' else '0';
  tmp_0316 <= tmp_0314 and tmp_0315;
  tmp_0317 <= '1' when tmp_0316 = '1' else '0';
  tmp_0318 <= '1' when tcp_server_listen_busy = '0' else '0';
  tmp_0319 <= '1' when wait_for_established_busy = '0' else '0';
  tmp_0320 <= '1' when wait_for_established_req_local = '0' else '0';
  tmp_0321 <= tmp_0319 and tmp_0320;
  tmp_0322 <= '1' when tmp_0321 = '1' else '0';
  tmp_0323 <= '1' when wait_for_established_busy = '0' else '0';
  tmp_0324 <= '1' and '1';
  tmp_0325 <= '1' and '0';
  tmp_0326 <= '1' when wait_for_recv_busy = '0' else '0';
  tmp_0327 <= '1' when wait_for_recv_req_local = '0' else '0';
  tmp_0328 <= tmp_0326 and tmp_0327;
  tmp_0329 <= '1' when tmp_0328 = '1' else '0';
  tmp_0330 <= '1' when wait_for_recv_busy = '0' else '0';
  tmp_0331 <= '1' when pull_recv_data_busy = '0' else '0';
  tmp_0332 <= '1' when pull_recv_data_req_local = '0' else '0';
  tmp_0333 <= tmp_0331 and tmp_0332;
  tmp_0334 <= '1' when tmp_0333 = '1' else '0';
  tmp_0335 <= '1' when pull_recv_data_busy = '0' else '0';
  tmp_0336 <= '1' when push_send_data_busy = '0' else '0';
  tmp_0337 <= '1' when push_send_data_req_local = '0' else '0';
  tmp_0338 <= tmp_0336 and tmp_0337;
  tmp_0339 <= '1' when tmp_0338 = '1' else '0';
  tmp_0340 <= '1' when push_send_data_busy = '0' else '0';
  tmp_0341 <= tcp_server_port_0256(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0342 <= class_Sn_MR0_0003 + binary_expr_00258;
  tmp_0343 <= '1' when tcp_server_v_0260 /= class_Sn_SOCK_INIT_0074 else '0';
  tmp_0344 <= tcp_server_port_0256(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0345 <= class_Sn_CR1_0006 + binary_expr_00264;
  tmp_0346 <= '1' when tcp_server_v_0260 /= class_Sn_SOCK_LISTEN_0075 else '0';
  tmp_0347 <= tcp_server_port_0256(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0348 <= class_Sn_CR1_0006 + binary_expr_00270;
  tmp_0349 <= '1' when init_busy = '0' else '0';
  tmp_0350 <= '1' when init_req_local = '0' else '0';
  tmp_0351 <= tmp_0349 and tmp_0350;
  tmp_0352 <= '1' when tmp_0351 = '1' else '0';
  tmp_0353 <= '1' when init_busy = '0' else '0';
  tmp_0354 <= '1' when network_configuration_busy = '0' else '0';
  tmp_0355 <= '1' when network_configuration_req_local = '0' else '0';
  tmp_0356 <= tmp_0354 and tmp_0355;
  tmp_0357 <= '1' when tmp_0356 = '1' else '0';
  tmp_0358 <= '1' when network_configuration_busy = '0' else '0';
  tmp_0359 <= '1' when tcp_server_busy = '0' else '0';
  tmp_0360 <= '1' when tcp_server_req_local = '0' else '0';
  tmp_0361 <= tmp_0359 and tmp_0360;
  tmp_0362 <= '1' when tmp_0361 = '1' else '0';
  tmp_0363 <= '1' when tcp_server_busy = '0' else '0';
  tmp_0364 <= '1' and '1';
  tmp_0365 <= '1' and '0';
  tmp_0366 <= '1' and '1';
  tmp_0367 <= '1' and '0';
  tmp_0368 <= '1' when binary_expr_00281 = '1' else '0';
  tmp_0369 <= '1' when binary_expr_00281 = '0' else '0';
  tmp_0370 <= '1' when binary_expr_00284 = '1' else '0';
  tmp_0371 <= '1' when binary_expr_00284 = '0' else '0';
  tmp_0372 <= '1' when class_led_0002 = X"000000ff" else '0';
  tmp_0373 <= class_led_0002 + X"00000001";
  tmp_0374 <= '1' when blink_led_i_0283 < X"000f4240" else '0';
  tmp_0375 <= blink_led_i_0283 + X"00000001";

  -- sequencers
  process (clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_cycles_method <= wait_cycles_method_IDLE;
        wait_cycles_method_delay <= (others => '0');
      else
        case (wait_cycles_method) is
          when wait_cycles_method_IDLE => 
            wait_cycles_method <= wait_cycles_method_S_0000;
          when wait_cycles_method_S_0000 => 
            wait_cycles_method <= wait_cycles_method_S_0001;
            wait_cycles_method <= wait_cycles_method_S_0001;
          when wait_cycles_method_S_0001 => 
            if wait_cycles_req_flag = '1' then
              wait_cycles_method <= wait_cycles_method_S_0002;
            end if;
          when wait_cycles_method_S_0002 => 
            wait_cycles_method <= wait_cycles_method_S_0003;
          when wait_cycles_method_S_0003 => 
            wait_cycles_method <= wait_cycles_method_S_0004;
          when wait_cycles_method_S_0004 => 
            if tmp_0004 = '1' then
              wait_cycles_method <= wait_cycles_method_S_0009;
            elsif tmp_0005 = '1' then
              wait_cycles_method <= wait_cycles_method_S_0005;
            end if;
          when wait_cycles_method_S_0005 => 
            wait_cycles_method <= wait_cycles_method_S_0010;
          when wait_cycles_method_S_0006 => 
            wait_cycles_method <= wait_cycles_method_S_0007;
          when wait_cycles_method_S_0007 => 
            wait_cycles_method <= wait_cycles_method_S_0008;
          when wait_cycles_method_S_0008 => 
            wait_cycles_method <= wait_cycles_method_S_0003;
          when wait_cycles_method_S_0009 => 
            wait_cycles_method <= wait_cycles_method_S_0006;
          when wait_cycles_method_S_0010 => 
            wait_cycles_method <= wait_cycles_method_S_0000;
          when others => null;
        end case;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        write_data_method <= write_data_method_IDLE;
        write_data_method_delay <= (others => '0');
      else
        case (write_data_method) is
          when write_data_method_IDLE => 
            write_data_method <= write_data_method_S_0000;
          when write_data_method_S_0000 => 
            write_data_method <= write_data_method_S_0001;
            write_data_method <= write_data_method_S_0001;
          when write_data_method_S_0001 => 
            if write_data_req_flag = '1' then
              write_data_method <= write_data_method_S_0002;
            end if;
          when write_data_method_S_0002 => 
            write_data_method <= write_data_method_S_0003;
          when write_data_method_S_0003 => 
            write_data_method <= write_data_method_S_0004;
          when write_data_method_S_0004 => 
            write_data_method <= write_data_method_S_0005;
          when write_data_method_S_0005 => 
            write_data_method <= write_data_method_S_0006;
          when write_data_method_S_0006 => 
            write_data_method <= write_data_method_S_0007;
          when write_data_method_S_0007 => 
            write_data_method <= write_data_method_S_0008;
          when write_data_method_S_0008 => 
            write_data_method <= write_data_method_S_0009;
          when write_data_method_S_0009 => 
            write_data_method <= write_data_method_S_0010;
          when write_data_method_S_0010 => 
            if tmp_0012 = '1' then
              write_data_method <= write_data_method_write_data_method_S_0010_body;
            end if;
          when write_data_method_S_0011 => 
            write_data_method <= write_data_method_S_0012;
          when write_data_method_S_0012 => 
            write_data_method <= write_data_method_S_0013;
          when write_data_method_S_0013 => 
            write_data_method <= write_data_method_S_0014;
          when write_data_method_S_0014 => 
            write_data_method <= write_data_method_S_0015;
          when write_data_method_S_0015 => 
            write_data_method <= write_data_method_S_0000;
          when write_data_method_write_data_method_S_0010_body => 
            if write_data_method_delay >= 1 and wait_cycles_call_flag_0010 = '1' then
              write_data_method_delay <= (others => '0');
              write_data_method <= write_data_method_S_0011;
            else
              write_data_method_delay <= write_data_method_delay + 1;
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
        read_data_method <= read_data_method_IDLE;
        read_data_method_delay <= (others => '0');
      else
        case (read_data_method) is
          when read_data_method_IDLE => 
            read_data_method <= read_data_method_S_0000;
          when read_data_method_S_0000 => 
            read_data_method <= read_data_method_S_0001;
            read_data_method <= read_data_method_S_0001;
          when read_data_method_S_0001 => 
            if read_data_req_flag = '1' then
              read_data_method <= read_data_method_S_0002;
            end if;
          when read_data_method_S_0002 => 
            read_data_method <= read_data_method_S_0003;
          when read_data_method_S_0003 => 
            read_data_method <= read_data_method_S_0004;
          when read_data_method_S_0004 => 
            read_data_method <= read_data_method_S_0005;
          when read_data_method_S_0005 => 
            read_data_method <= read_data_method_S_0006;
          when read_data_method_S_0006 => 
            read_data_method <= read_data_method_S_0007;
          when read_data_method_S_0007 => 
            read_data_method <= read_data_method_S_0008;
          when read_data_method_S_0008 => 
            if tmp_0017 = '1' then
              read_data_method <= read_data_method_read_data_method_S_0008_body;
            end if;
          when read_data_method_S_0009 => 
            read_data_method <= read_data_method_S_0010;
          when read_data_method_S_0010 => 
            read_data_method <= read_data_method_S_0011;
          when read_data_method_S_0011 => 
            read_data_method <= read_data_method_S_0012;
          when read_data_method_S_0012 => 
            read_data_method <= read_data_method_S_0013;
          when read_data_method_S_0013 => 
            read_data_method <= read_data_method_S_0014;
          when read_data_method_S_0014 => 
            read_data_method <= read_data_method_S_0015;
          when read_data_method_S_0015 => 
            read_data_method <= read_data_method_S_0000;
          when read_data_method_S_0016 => 
            read_data_method <= read_data_method_S_0000;
          when read_data_method_read_data_method_S_0008_body => 
            if read_data_method_delay >= 1 and wait_cycles_call_flag_0008 = '1' then
              read_data_method_delay <= (others => '0');
              read_data_method <= read_data_method_S_0009;
            else
              read_data_method_delay <= read_data_method_delay + 1;
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
        init_method <= init_method_IDLE;
        init_method_delay <= (others => '0');
      else
        case (init_method) is
          when init_method_IDLE => 
            init_method <= init_method_S_0000;
          when init_method_S_0000 => 
            init_method <= init_method_S_0001;
            init_method <= init_method_S_0001;
          when init_method_S_0001 => 
            if init_req_flag = '1' then
              init_method <= init_method_S_0002;
            end if;
          when init_method_S_0002 => 
            init_method <= init_method_S_0003;
          when init_method_S_0003 => 
            init_method <= init_method_S_0004;
          when init_method_S_0004 => 
            init_method <= init_method_S_0005;
          when init_method_S_0005 => 
            init_method <= init_method_S_0006;
          when init_method_S_0006 => 
            init_method <= init_method_S_0007;
          when init_method_S_0007 => 
            init_method <= init_method_S_0008;
          when init_method_S_0008 => 
            init_method <= init_method_S_0009;
          when init_method_S_0009 => 
            init_method <= init_method_S_0010;
          when init_method_S_0010 => 
            if tmp_0018 = '1' then
              init_method <= init_method_init_method_S_0010_body;
            end if;
          when init_method_S_0011 => 
            init_method <= init_method_S_0012;
          when init_method_S_0012 => 
            init_method <= init_method_S_0013;
          when init_method_S_0013 => 
            if tmp_0023 = '1' then
              init_method <= init_method_init_method_S_0013_body;
            end if;
          when init_method_S_0014 => 
            init_method <= init_method_S_0000;
          when init_method_init_method_S_0010_body => 
            if init_method_delay >= 1 and wait_cycles_call_flag_0010 = '1' then
              init_method_delay <= (others => '0');
              init_method <= init_method_S_0011;
            else
              init_method_delay <= init_method_delay + 1;
            end if;
          when init_method_init_method_S_0013_body => 
            if init_method_delay >= 1 and wait_cycles_call_flag_0013 = '1' then
              init_method_delay <= (others => '0');
              init_method <= init_method_S_0014;
            else
              init_method_delay <= init_method_delay + 1;
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
        network_configuration_method <= network_configuration_method_IDLE;
        network_configuration_method_delay <= (others => '0');
      else
        case (network_configuration_method) is
          when network_configuration_method_IDLE => 
            network_configuration_method <= network_configuration_method_S_0000;
          when network_configuration_method_S_0000 => 
            network_configuration_method <= network_configuration_method_S_0001;
            network_configuration_method <= network_configuration_method_S_0001;
          when network_configuration_method_S_0001 => 
            if network_configuration_req_flag = '1' then
              network_configuration_method <= network_configuration_method_S_0002;
            end if;
          when network_configuration_method_S_0002 => 
            if tmp_0028 = '1' then
              network_configuration_method <= network_configuration_method_network_configuration_method_S_0002_body;
            end if;
          when network_configuration_method_S_0003 => 
            if tmp_0033 = '1' then
              network_configuration_method <= network_configuration_method_network_configuration_method_S_0003_body;
            end if;
          when network_configuration_method_S_0004 => 
            if tmp_0038 = '1' then
              network_configuration_method <= network_configuration_method_network_configuration_method_S_0004_body;
            end if;
          when network_configuration_method_S_0005 => 
            if tmp_0043 = '1' then
              network_configuration_method <= network_configuration_method_network_configuration_method_S_0005_body;
            end if;
          when network_configuration_method_S_0006 => 
            if tmp_0048 = '1' then
              network_configuration_method <= network_configuration_method_network_configuration_method_S_0006_body;
            end if;
          when network_configuration_method_S_0007 => 
            if tmp_0053 = '1' then
              network_configuration_method <= network_configuration_method_network_configuration_method_S_0007_body;
            end if;
          when network_configuration_method_S_0008 => 
            if tmp_0058 = '1' then
              network_configuration_method <= network_configuration_method_network_configuration_method_S_0008_body;
            end if;
          when network_configuration_method_S_0009 => 
            if tmp_0063 = '1' then
              network_configuration_method <= network_configuration_method_network_configuration_method_S_0009_body;
            end if;
          when network_configuration_method_S_0010 => 
            if tmp_0068 = '1' then
              network_configuration_method <= network_configuration_method_network_configuration_method_S_0010_body;
            end if;
          when network_configuration_method_S_0011 => 
            if tmp_0073 = '1' then
              network_configuration_method <= network_configuration_method_network_configuration_method_S_0011_body;
            end if;
          when network_configuration_method_S_0012 => 
            if tmp_0078 = '1' then
              network_configuration_method <= network_configuration_method_network_configuration_method_S_0012_body;
            end if;
          when network_configuration_method_S_0013 => 
            if tmp_0083 = '1' then
              network_configuration_method <= network_configuration_method_network_configuration_method_S_0013_body;
            end if;
          when network_configuration_method_S_0014 => 
            if tmp_0088 = '1' then
              network_configuration_method <= network_configuration_method_network_configuration_method_S_0014_body;
            end if;
          when network_configuration_method_S_0015 => 
            if tmp_0093 = '1' then
              network_configuration_method <= network_configuration_method_network_configuration_method_S_0015_body;
            end if;
          when network_configuration_method_S_0016 => 
            if tmp_0098 = '1' then
              network_configuration_method <= network_configuration_method_network_configuration_method_S_0016_body;
            end if;
          when network_configuration_method_S_0017 => 
            if tmp_0103 = '1' then
              network_configuration_method <= network_configuration_method_network_configuration_method_S_0017_body;
            end if;
          when network_configuration_method_S_0018 => 
            if tmp_0108 = '1' then
              network_configuration_method <= network_configuration_method_network_configuration_method_S_0018_body;
            end if;
          when network_configuration_method_S_0019 => 
            if tmp_0113 = '1' then
              network_configuration_method <= network_configuration_method_network_configuration_method_S_0019_body;
            end if;
          when network_configuration_method_S_0020 => 
            network_configuration_method <= network_configuration_method_S_0000;
          when network_configuration_method_network_configuration_method_S_0002_body => 
            if network_configuration_method_delay >= 1 and write_data_call_flag_0002 = '1' then
              network_configuration_method_delay <= (others => '0');
              network_configuration_method <= network_configuration_method_S_0003;
            else
              network_configuration_method_delay <= network_configuration_method_delay + 1;
            end if;
          when network_configuration_method_network_configuration_method_S_0003_body => 
            if network_configuration_method_delay >= 1 and write_data_call_flag_0003 = '1' then
              network_configuration_method_delay <= (others => '0');
              network_configuration_method <= network_configuration_method_S_0004;
            else
              network_configuration_method_delay <= network_configuration_method_delay + 1;
            end if;
          when network_configuration_method_network_configuration_method_S_0004_body => 
            if network_configuration_method_delay >= 1 and write_data_call_flag_0004 = '1' then
              network_configuration_method_delay <= (others => '0');
              network_configuration_method <= network_configuration_method_S_0005;
            else
              network_configuration_method_delay <= network_configuration_method_delay + 1;
            end if;
          when network_configuration_method_network_configuration_method_S_0005_body => 
            if network_configuration_method_delay >= 1 and write_data_call_flag_0005 = '1' then
              network_configuration_method_delay <= (others => '0');
              network_configuration_method <= network_configuration_method_S_0006;
            else
              network_configuration_method_delay <= network_configuration_method_delay + 1;
            end if;
          when network_configuration_method_network_configuration_method_S_0006_body => 
            if network_configuration_method_delay >= 1 and write_data_call_flag_0006 = '1' then
              network_configuration_method_delay <= (others => '0');
              network_configuration_method <= network_configuration_method_S_0007;
            else
              network_configuration_method_delay <= network_configuration_method_delay + 1;
            end if;
          when network_configuration_method_network_configuration_method_S_0007_body => 
            if network_configuration_method_delay >= 1 and write_data_call_flag_0007 = '1' then
              network_configuration_method_delay <= (others => '0');
              network_configuration_method <= network_configuration_method_S_0008;
            else
              network_configuration_method_delay <= network_configuration_method_delay + 1;
            end if;
          when network_configuration_method_network_configuration_method_S_0008_body => 
            if network_configuration_method_delay >= 1 and write_data_call_flag_0008 = '1' then
              network_configuration_method_delay <= (others => '0');
              network_configuration_method <= network_configuration_method_S_0009;
            else
              network_configuration_method_delay <= network_configuration_method_delay + 1;
            end if;
          when network_configuration_method_network_configuration_method_S_0009_body => 
            if network_configuration_method_delay >= 1 and write_data_call_flag_0009 = '1' then
              network_configuration_method_delay <= (others => '0');
              network_configuration_method <= network_configuration_method_S_0010;
            else
              network_configuration_method_delay <= network_configuration_method_delay + 1;
            end if;
          when network_configuration_method_network_configuration_method_S_0010_body => 
            if network_configuration_method_delay >= 1 and write_data_call_flag_0010 = '1' then
              network_configuration_method_delay <= (others => '0');
              network_configuration_method <= network_configuration_method_S_0011;
            else
              network_configuration_method_delay <= network_configuration_method_delay + 1;
            end if;
          when network_configuration_method_network_configuration_method_S_0011_body => 
            if network_configuration_method_delay >= 1 and write_data_call_flag_0011 = '1' then
              network_configuration_method_delay <= (others => '0');
              network_configuration_method <= network_configuration_method_S_0012;
            else
              network_configuration_method_delay <= network_configuration_method_delay + 1;
            end if;
          when network_configuration_method_network_configuration_method_S_0012_body => 
            if network_configuration_method_delay >= 1 and write_data_call_flag_0012 = '1' then
              network_configuration_method_delay <= (others => '0');
              network_configuration_method <= network_configuration_method_S_0013;
            else
              network_configuration_method_delay <= network_configuration_method_delay + 1;
            end if;
          when network_configuration_method_network_configuration_method_S_0013_body => 
            if network_configuration_method_delay >= 1 and write_data_call_flag_0013 = '1' then
              network_configuration_method_delay <= (others => '0');
              network_configuration_method <= network_configuration_method_S_0014;
            else
              network_configuration_method_delay <= network_configuration_method_delay + 1;
            end if;
          when network_configuration_method_network_configuration_method_S_0014_body => 
            if network_configuration_method_delay >= 1 and write_data_call_flag_0014 = '1' then
              network_configuration_method_delay <= (others => '0');
              network_configuration_method <= network_configuration_method_S_0015;
            else
              network_configuration_method_delay <= network_configuration_method_delay + 1;
            end if;
          when network_configuration_method_network_configuration_method_S_0015_body => 
            if network_configuration_method_delay >= 1 and write_data_call_flag_0015 = '1' then
              network_configuration_method_delay <= (others => '0');
              network_configuration_method <= network_configuration_method_S_0016;
            else
              network_configuration_method_delay <= network_configuration_method_delay + 1;
            end if;
          when network_configuration_method_network_configuration_method_S_0016_body => 
            if network_configuration_method_delay >= 1 and write_data_call_flag_0016 = '1' then
              network_configuration_method_delay <= (others => '0');
              network_configuration_method <= network_configuration_method_S_0017;
            else
              network_configuration_method_delay <= network_configuration_method_delay + 1;
            end if;
          when network_configuration_method_network_configuration_method_S_0017_body => 
            if network_configuration_method_delay >= 1 and write_data_call_flag_0017 = '1' then
              network_configuration_method_delay <= (others => '0');
              network_configuration_method <= network_configuration_method_S_0018;
            else
              network_configuration_method_delay <= network_configuration_method_delay + 1;
            end if;
          when network_configuration_method_network_configuration_method_S_0018_body => 
            if network_configuration_method_delay >= 1 and write_data_call_flag_0018 = '1' then
              network_configuration_method_delay <= (others => '0');
              network_configuration_method <= network_configuration_method_S_0019;
            else
              network_configuration_method_delay <= network_configuration_method_delay + 1;
            end if;
          when network_configuration_method_network_configuration_method_S_0019_body => 
            if network_configuration_method_delay >= 1 and write_data_call_flag_0019 = '1' then
              network_configuration_method_delay <= (others => '0');
              network_configuration_method <= network_configuration_method_S_0020;
            else
              network_configuration_method_delay <= network_configuration_method_delay + 1;
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
        tcp_server_open_method <= tcp_server_open_method_IDLE;
        tcp_server_open_method_delay <= (others => '0');
      else
        case (tcp_server_open_method) is
          when tcp_server_open_method_IDLE => 
            tcp_server_open_method <= tcp_server_open_method_S_0000;
          when tcp_server_open_method_S_0000 => 
            tcp_server_open_method <= tcp_server_open_method_S_0001;
            tcp_server_open_method <= tcp_server_open_method_S_0001;
          when tcp_server_open_method_S_0001 => 
            if tcp_server_open_req_flag = '1' then
              tcp_server_open_method <= tcp_server_open_method_S_0002;
            end if;
          when tcp_server_open_method_S_0002 => 
            tcp_server_open_method <= tcp_server_open_method_S_0003;
          when tcp_server_open_method_S_0003 => 
            tcp_server_open_method <= tcp_server_open_method_S_0004;
          when tcp_server_open_method_S_0004 => 
            if tmp_0114 = '1' then
              tcp_server_open_method <= tcp_server_open_method_tcp_server_open_method_S_0004_body;
            end if;
          when tcp_server_open_method_S_0005 => 
            tcp_server_open_method <= tcp_server_open_method_S_0006;
          when tcp_server_open_method_S_0006 => 
            tcp_server_open_method <= tcp_server_open_method_S_0007;
          when tcp_server_open_method_S_0007 => 
            if tmp_0115 = '1' then
              tcp_server_open_method <= tcp_server_open_method_tcp_server_open_method_S_0007_body;
            end if;
          when tcp_server_open_method_S_0008 => 
            tcp_server_open_method <= tcp_server_open_method_S_0009;
          when tcp_server_open_method_S_0009 => 
            tcp_server_open_method <= tcp_server_open_method_S_0010;
          when tcp_server_open_method_S_0010 => 
            if tmp_0116 = '1' then
              tcp_server_open_method <= tcp_server_open_method_tcp_server_open_method_S_0010_body;
            end if;
          when tcp_server_open_method_S_0011 => 
            tcp_server_open_method <= tcp_server_open_method_S_0012;
          when tcp_server_open_method_S_0012 => 
            tcp_server_open_method <= tcp_server_open_method_S_0013;
          when tcp_server_open_method_S_0013 => 
            if tmp_0117 = '1' then
              tcp_server_open_method <= tcp_server_open_method_tcp_server_open_method_S_0013_body;
            end if;
          when tcp_server_open_method_S_0014 => 
            tcp_server_open_method <= tcp_server_open_method_S_0015;
          when tcp_server_open_method_S_0015 => 
            tcp_server_open_method <= tcp_server_open_method_S_0016;
          when tcp_server_open_method_S_0016 => 
            if tmp_0122 = '1' then
              tcp_server_open_method <= tcp_server_open_method_tcp_server_open_method_S_0016_body;
            end if;
          when tcp_server_open_method_S_0017 => 
            tcp_server_open_method <= tcp_server_open_method_S_0000;
          when tcp_server_open_method_S_0018 => 
            tcp_server_open_method <= tcp_server_open_method_S_0000;
          when tcp_server_open_method_tcp_server_open_method_S_0004_body => 
            if tcp_server_open_method_delay >= 1 and write_data_call_flag_0004 = '1' then
              tcp_server_open_method_delay <= (others => '0');
              tcp_server_open_method <= tcp_server_open_method_S_0005;
            else
              tcp_server_open_method_delay <= tcp_server_open_method_delay + 1;
            end if;
          when tcp_server_open_method_tcp_server_open_method_S_0007_body => 
            if tcp_server_open_method_delay >= 1 and write_data_call_flag_0007 = '1' then
              tcp_server_open_method_delay <= (others => '0');
              tcp_server_open_method <= tcp_server_open_method_S_0008;
            else
              tcp_server_open_method_delay <= tcp_server_open_method_delay + 1;
            end if;
          when tcp_server_open_method_tcp_server_open_method_S_0010_body => 
            if tcp_server_open_method_delay >= 1 and write_data_call_flag_0010 = '1' then
              tcp_server_open_method_delay <= (others => '0');
              tcp_server_open_method <= tcp_server_open_method_S_0011;
            else
              tcp_server_open_method_delay <= tcp_server_open_method_delay + 1;
            end if;
          when tcp_server_open_method_tcp_server_open_method_S_0013_body => 
            if tcp_server_open_method_delay >= 1 and write_data_call_flag_0013 = '1' then
              tcp_server_open_method_delay <= (others => '0');
              tcp_server_open_method <= tcp_server_open_method_S_0014;
            else
              tcp_server_open_method_delay <= tcp_server_open_method_delay + 1;
            end if;
          when tcp_server_open_method_tcp_server_open_method_S_0016_body => 
            if tcp_server_open_method_delay >= 1 and read_data_call_flag_0016 = '1' then
              tcp_server_open_method_delay <= (others => '0');
              tcp_server_open_method <= tcp_server_open_method_S_0017;
            else
              tcp_server_open_method_delay <= tcp_server_open_method_delay + 1;
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
        tcp_server_listen_method <= tcp_server_listen_method_IDLE;
        tcp_server_listen_method_delay <= (others => '0');
      else
        case (tcp_server_listen_method) is
          when tcp_server_listen_method_IDLE => 
            tcp_server_listen_method <= tcp_server_listen_method_S_0000;
          when tcp_server_listen_method_S_0000 => 
            tcp_server_listen_method <= tcp_server_listen_method_S_0001;
            tcp_server_listen_method <= tcp_server_listen_method_S_0001;
          when tcp_server_listen_method_S_0001 => 
            if tcp_server_listen_req_flag = '1' then
              tcp_server_listen_method <= tcp_server_listen_method_S_0002;
            end if;
          when tcp_server_listen_method_S_0002 => 
            tcp_server_listen_method <= tcp_server_listen_method_S_0003;
          when tcp_server_listen_method_S_0003 => 
            tcp_server_listen_method <= tcp_server_listen_method_S_0004;
          when tcp_server_listen_method_S_0004 => 
            if tmp_0133 = '1' then
              tcp_server_listen_method <= tcp_server_listen_method_tcp_server_listen_method_S_0004_body;
            end if;
          when tcp_server_listen_method_S_0005 => 
            tcp_server_listen_method <= tcp_server_listen_method_S_0006;
          when tcp_server_listen_method_S_0006 => 
            tcp_server_listen_method <= tcp_server_listen_method_S_0007;
          when tcp_server_listen_method_S_0007 => 
            if tmp_0138 = '1' then
              tcp_server_listen_method <= tcp_server_listen_method_tcp_server_listen_method_S_0007_body;
            end if;
          when tcp_server_listen_method_S_0008 => 
            tcp_server_listen_method <= tcp_server_listen_method_S_0000;
          when tcp_server_listen_method_S_0009 => 
            tcp_server_listen_method <= tcp_server_listen_method_S_0000;
          when tcp_server_listen_method_tcp_server_listen_method_S_0004_body => 
            if tcp_server_listen_method_delay >= 1 and write_data_call_flag_0004 = '1' then
              tcp_server_listen_method_delay <= (others => '0');
              tcp_server_listen_method <= tcp_server_listen_method_S_0005;
            else
              tcp_server_listen_method_delay <= tcp_server_listen_method_delay + 1;
            end if;
          when tcp_server_listen_method_tcp_server_listen_method_S_0007_body => 
            if tcp_server_listen_method_delay >= 1 and read_data_call_flag_0007 = '1' then
              tcp_server_listen_method_delay <= (others => '0');
              tcp_server_listen_method <= tcp_server_listen_method_S_0008;
            else
              tcp_server_listen_method_delay <= tcp_server_listen_method_delay + 1;
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
        wait_for_established_method <= wait_for_established_method_IDLE;
        wait_for_established_method_delay <= (others => '0');
      else
        case (wait_for_established_method) is
          when wait_for_established_method_IDLE => 
            wait_for_established_method <= wait_for_established_method_S_0000;
          when wait_for_established_method_S_0000 => 
            wait_for_established_method <= wait_for_established_method_S_0001;
            wait_for_established_method <= wait_for_established_method_S_0001;
          when wait_for_established_method_S_0001 => 
            if wait_for_established_req_flag = '1' then
              wait_for_established_method <= wait_for_established_method_S_0002;
            end if;
          when wait_for_established_method_S_0002 => 
            if tmp_0143 = '1' then
              wait_for_established_method <= wait_for_established_method_S_0004;
            elsif tmp_0144 = '1' then
              wait_for_established_method <= wait_for_established_method_S_0003;
            end if;
          when wait_for_established_method_S_0003 => 
            wait_for_established_method <= wait_for_established_method_S_0014;
          when wait_for_established_method_S_0004 => 
            wait_for_established_method <= wait_for_established_method_S_0005;
          when wait_for_established_method_S_0005 => 
            wait_for_established_method <= wait_for_established_method_S_0006;
          when wait_for_established_method_S_0006 => 
            if tmp_0149 = '1' then
              wait_for_established_method <= wait_for_established_method_wait_for_established_method_S_0006_body;
            end if;
          when wait_for_established_method_S_0007 => 
            wait_for_established_method <= wait_for_established_method_S_0008;
          when wait_for_established_method_S_0008 => 
            wait_for_established_method <= wait_for_established_method_S_0009;
          when wait_for_established_method_S_0009 => 
            if tmp_0150 = '1' then
              wait_for_established_method <= wait_for_established_method_S_0011;
            elsif tmp_0151 = '1' then
              wait_for_established_method <= wait_for_established_method_S_0010;
            end if;
          when wait_for_established_method_S_0010 => 
            wait_for_established_method <= wait_for_established_method_S_0013;
          when wait_for_established_method_S_0011 => 
            wait_for_established_method <= wait_for_established_method_S_0000;
          when wait_for_established_method_S_0012 => 
            wait_for_established_method <= wait_for_established_method_S_0010;
          when wait_for_established_method_S_0013 => 
            wait_for_established_method <= wait_for_established_method_S_0002;
          when wait_for_established_method_S_0014 => 
            wait_for_established_method <= wait_for_established_method_S_0000;
          when wait_for_established_method_wait_for_established_method_S_0006_body => 
            if wait_for_established_method_delay >= 1 and read_data_call_flag_0006 = '1' then
              wait_for_established_method_delay <= (others => '0');
              wait_for_established_method <= wait_for_established_method_S_0007;
            else
              wait_for_established_method_delay <= wait_for_established_method_delay + 1;
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
        wait_for_recv_method <= wait_for_recv_method_IDLE;
        wait_for_recv_method_delay <= (others => '0');
      else
        case (wait_for_recv_method) is
          when wait_for_recv_method_IDLE => 
            wait_for_recv_method <= wait_for_recv_method_S_0000;
          when wait_for_recv_method_S_0000 => 
            wait_for_recv_method <= wait_for_recv_method_S_0001;
            wait_for_recv_method <= wait_for_recv_method_S_0001;
          when wait_for_recv_method_S_0001 => 
            if wait_for_recv_req_flag = '1' then
              wait_for_recv_method <= wait_for_recv_method_S_0002;
            end if;
          when wait_for_recv_method_S_0002 => 
            wait_for_recv_method <= wait_for_recv_method_S_0003;
          when wait_for_recv_method_S_0003 => 
            if tmp_0155 = '1' then
              wait_for_recv_method <= wait_for_recv_method_S_0005;
            elsif tmp_0156 = '1' then
              wait_for_recv_method <= wait_for_recv_method_S_0004;
            end if;
          when wait_for_recv_method_S_0004 => 
            wait_for_recv_method <= wait_for_recv_method_S_0032;
          when wait_for_recv_method_S_0005 => 
            wait_for_recv_method <= wait_for_recv_method_S_0007;
          when wait_for_recv_method_S_0007 => 
            wait_for_recv_method <= wait_for_recv_method_S_0008;
          when wait_for_recv_method_S_0008 => 
            if tmp_0161 = '1' then
              wait_for_recv_method <= wait_for_recv_method_wait_for_recv_method_S_0008_body;
            end if;
          when wait_for_recv_method_S_0009 => 
            wait_for_recv_method <= wait_for_recv_method_S_0010;
          when wait_for_recv_method_S_0010 => 
            wait_for_recv_method <= wait_for_recv_method_S_0013;
          when wait_for_recv_method_S_0013 => 
            if tmp_0166 = '1' then
              wait_for_recv_method <= wait_for_recv_method_wait_for_recv_method_S_0013_body;
            end if;
          when wait_for_recv_method_S_0014 => 
            wait_for_recv_method <= wait_for_recv_method_S_0015;
          when wait_for_recv_method_S_0015 => 
            wait_for_recv_method <= wait_for_recv_method_S_0018;
          when wait_for_recv_method_S_0018 => 
            if tmp_0171 = '1' then
              wait_for_recv_method <= wait_for_recv_method_wait_for_recv_method_S_0018_body;
            end if;
          when wait_for_recv_method_S_0019 => 
            wait_for_recv_method <= wait_for_recv_method_S_0020;
          when wait_for_recv_method_S_0020 => 
            wait_for_recv_method <= wait_for_recv_method_S_0024;
          when wait_for_recv_method_S_0024 => 
            wait_for_recv_method <= wait_for_recv_method_S_0025;
          when wait_for_recv_method_S_0025 => 
            wait_for_recv_method <= wait_for_recv_method_S_0026;
          when wait_for_recv_method_S_0026 => 
            wait_for_recv_method <= wait_for_recv_method_S_0027;
          when wait_for_recv_method_S_0027 => 
            if tmp_0172 = '1' then
              wait_for_recv_method <= wait_for_recv_method_S_0029;
            elsif tmp_0173 = '1' then
              wait_for_recv_method <= wait_for_recv_method_S_0028;
            end if;
          when wait_for_recv_method_S_0028 => 
            wait_for_recv_method <= wait_for_recv_method_S_0031;
          when wait_for_recv_method_S_0029 => 
            wait_for_recv_method <= wait_for_recv_method_S_0000;
          when wait_for_recv_method_S_0030 => 
            wait_for_recv_method <= wait_for_recv_method_S_0028;
          when wait_for_recv_method_S_0031 => 
            wait_for_recv_method <= wait_for_recv_method_S_0003;
          when wait_for_recv_method_S_0032 => 
            wait_for_recv_method <= wait_for_recv_method_S_0000;
          when wait_for_recv_method_wait_for_recv_method_S_0008_body => 
            if wait_for_recv_method_delay >= 1 and read_data_call_flag_0008 = '1' then
              wait_for_recv_method_delay <= (others => '0');
              wait_for_recv_method <= wait_for_recv_method_S_0009;
            else
              wait_for_recv_method_delay <= wait_for_recv_method_delay + 1;
            end if;
          when wait_for_recv_method_wait_for_recv_method_S_0013_body => 
            if wait_for_recv_method_delay >= 1 and read_data_call_flag_0013 = '1' then
              wait_for_recv_method_delay <= (others => '0');
              wait_for_recv_method <= wait_for_recv_method_S_0014;
            else
              wait_for_recv_method_delay <= wait_for_recv_method_delay + 1;
            end if;
          when wait_for_recv_method_wait_for_recv_method_S_0018_body => 
            if wait_for_recv_method_delay >= 1 and read_data_call_flag_0018 = '1' then
              wait_for_recv_method_delay <= (others => '0');
              wait_for_recv_method <= wait_for_recv_method_S_0019;
            else
              wait_for_recv_method_delay <= wait_for_recv_method_delay + 1;
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
        pull_recv_data_method <= pull_recv_data_method_IDLE;
        pull_recv_data_method_delay <= (others => '0');
      else
        case (pull_recv_data_method) is
          when pull_recv_data_method_IDLE => 
            pull_recv_data_method <= pull_recv_data_method_S_0000;
          when pull_recv_data_method_S_0000 => 
            pull_recv_data_method <= pull_recv_data_method_S_0001;
            pull_recv_data_method <= pull_recv_data_method_S_0001;
          when pull_recv_data_method_S_0001 => 
            if pull_recv_data_req_flag = '1' then
              pull_recv_data_method <= pull_recv_data_method_S_0002;
            end if;
          when pull_recv_data_method_S_0002 => 
            pull_recv_data_method <= pull_recv_data_method_S_0003;
          when pull_recv_data_method_S_0003 => 
            pull_recv_data_method <= pull_recv_data_method_S_0006;
          when pull_recv_data_method_S_0006 => 
            if tmp_0188 = '1' then
              pull_recv_data_method <= pull_recv_data_method_S_0008;
            elsif tmp_0189 = '1' then
              pull_recv_data_method <= pull_recv_data_method_S_0007;
            end if;
          when pull_recv_data_method_S_0007 => 
            pull_recv_data_method <= pull_recv_data_method_S_0011;
          when pull_recv_data_method_S_0008 => 
            pull_recv_data_method <= pull_recv_data_method_S_0009;
          when pull_recv_data_method_S_0009 => 
            pull_recv_data_method <= pull_recv_data_method_S_0010;
          when pull_recv_data_method_S_0010 => 
            pull_recv_data_method <= pull_recv_data_method_S_0007;
          when pull_recv_data_method_S_0011 => 
            pull_recv_data_method <= pull_recv_data_method_S_0012;
          when pull_recv_data_method_S_0012 => 
            pull_recv_data_method <= pull_recv_data_method_S_0013;
          when pull_recv_data_method_S_0013 => 
            if tmp_0190 = '1' then
              pull_recv_data_method <= pull_recv_data_method_S_0018;
            elsif tmp_0191 = '1' then
              pull_recv_data_method <= pull_recv_data_method_S_0014;
            end if;
          when pull_recv_data_method_S_0014 => 
            pull_recv_data_method <= pull_recv_data_method_S_0033;
          when pull_recv_data_method_S_0015 => 
            pull_recv_data_method <= pull_recv_data_method_S_0016;
          when pull_recv_data_method_S_0016 => 
            pull_recv_data_method <= pull_recv_data_method_S_0017;
          when pull_recv_data_method_S_0017 => 
            pull_recv_data_method <= pull_recv_data_method_S_0012;
          when pull_recv_data_method_S_0018 => 
            pull_recv_data_method <= pull_recv_data_method_S_0019;
          when pull_recv_data_method_S_0019 => 
            pull_recv_data_method <= pull_recv_data_method_S_0020;
          when pull_recv_data_method_S_0020 => 
            pull_recv_data_method <= pull_recv_data_method_S_0021;
          when pull_recv_data_method_S_0021 => 
            pull_recv_data_method <= pull_recv_data_method_S_0022;
          when pull_recv_data_method_S_0022 => 
            pull_recv_data_method <= pull_recv_data_method_S_0023;
          when pull_recv_data_method_S_0023 => 
            if tmp_0196 = '1' then
              pull_recv_data_method <= pull_recv_data_method_pull_recv_data_method_S_0023_body;
            end if;
          when pull_recv_data_method_S_0024 => 
            pull_recv_data_method <= pull_recv_data_method_S_0026;
          when pull_recv_data_method_S_0026 => 
            pull_recv_data_method <= pull_recv_data_method_S_0027;
          when pull_recv_data_method_S_0027 => 
            pull_recv_data_method <= pull_recv_data_method_S_0028;
          when pull_recv_data_method_S_0028 => 
            pull_recv_data_method <= pull_recv_data_method_S_0029;
          when pull_recv_data_method_S_0029 => 
            pull_recv_data_method <= pull_recv_data_method_S_0030;
          when pull_recv_data_method_S_0030 => 
            if tmp_0201 = '1' then
              pull_recv_data_method <= pull_recv_data_method_pull_recv_data_method_S_0030_body;
            end if;
          when pull_recv_data_method_S_0031 => 
            pull_recv_data_method <= pull_recv_data_method_S_0032;
          when pull_recv_data_method_S_0032 => 
            pull_recv_data_method <= pull_recv_data_method_S_0015;
          when pull_recv_data_method_S_0033 => 
            pull_recv_data_method <= pull_recv_data_method_S_0034;
          when pull_recv_data_method_S_0034 => 
            pull_recv_data_method <= pull_recv_data_method_S_0035;
          when pull_recv_data_method_S_0035 => 
            if tmp_0206 = '1' then
              pull_recv_data_method <= pull_recv_data_method_pull_recv_data_method_S_0035_body;
            end if;
          when pull_recv_data_method_S_0036 => 
            pull_recv_data_method <= pull_recv_data_method_S_0000;
          when pull_recv_data_method_pull_recv_data_method_S_0023_body => 
            if pull_recv_data_method_delay >= 1 and read_data_call_flag_0023 = '1' then
              pull_recv_data_method_delay <= (others => '0');
              pull_recv_data_method <= pull_recv_data_method_S_0024;
            else
              pull_recv_data_method_delay <= pull_recv_data_method_delay + 1;
            end if;
          when pull_recv_data_method_pull_recv_data_method_S_0030_body => 
            if pull_recv_data_method_delay >= 1 and read_data_call_flag_0030 = '1' then
              pull_recv_data_method_delay <= (others => '0');
              pull_recv_data_method <= pull_recv_data_method_S_0031;
            else
              pull_recv_data_method_delay <= pull_recv_data_method_delay + 1;
            end if;
          when pull_recv_data_method_pull_recv_data_method_S_0035_body => 
            if pull_recv_data_method_delay >= 1 and write_data_call_flag_0035 = '1' then
              pull_recv_data_method_delay <= (others => '0');
              pull_recv_data_method <= pull_recv_data_method_S_0036;
            else
              pull_recv_data_method_delay <= pull_recv_data_method_delay + 1;
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
        push_send_data_method <= push_send_data_method_IDLE;
        push_send_data_method_delay <= (others => '0');
      else
        case (push_send_data_method) is
          when push_send_data_method_IDLE => 
            push_send_data_method <= push_send_data_method_S_0000;
          when push_send_data_method_S_0000 => 
            push_send_data_method <= push_send_data_method_S_0001;
            push_send_data_method <= push_send_data_method_S_0001;
          when push_send_data_method_S_0001 => 
            if push_send_data_req_flag = '1' then
              push_send_data_method <= push_send_data_method_S_0002;
            end if;
          when push_send_data_method_S_0002 => 
            push_send_data_method <= push_send_data_method_S_0003;
          when push_send_data_method_S_0003 => 
            push_send_data_method <= push_send_data_method_S_0006;
          when push_send_data_method_S_0006 => 
            if tmp_0223 = '1' then
              push_send_data_method <= push_send_data_method_S_0008;
            elsif tmp_0224 = '1' then
              push_send_data_method <= push_send_data_method_S_0007;
            end if;
          when push_send_data_method_S_0007 => 
            push_send_data_method <= push_send_data_method_S_0011;
          when push_send_data_method_S_0008 => 
            push_send_data_method <= push_send_data_method_S_0009;
          when push_send_data_method_S_0009 => 
            push_send_data_method <= push_send_data_method_S_0010;
          when push_send_data_method_S_0010 => 
            push_send_data_method <= push_send_data_method_S_0007;
          when push_send_data_method_S_0011 => 
            push_send_data_method <= push_send_data_method_S_0012;
          when push_send_data_method_S_0012 => 
            push_send_data_method <= push_send_data_method_S_0013;
          when push_send_data_method_S_0013 => 
            if tmp_0225 = '1' then
              push_send_data_method <= push_send_data_method_S_0018;
            elsif tmp_0226 = '1' then
              push_send_data_method <= push_send_data_method_S_0014;
            end if;
          when push_send_data_method_S_0014 => 
            push_send_data_method <= push_send_data_method_S_0033;
          when push_send_data_method_S_0015 => 
            push_send_data_method <= push_send_data_method_S_0016;
          when push_send_data_method_S_0016 => 
            push_send_data_method <= push_send_data_method_S_0017;
          when push_send_data_method_S_0017 => 
            push_send_data_method <= push_send_data_method_S_0012;
          when push_send_data_method_S_0018 => 
            push_send_data_method <= push_send_data_method_S_0019;
          when push_send_data_method_S_0019 => 
            push_send_data_method <= push_send_data_method_S_0020;
          when push_send_data_method_S_0020 => 
            if push_send_data_method_delay >= 2 then
              push_send_data_method_delay <= (others => '0');
              push_send_data_method <= push_send_data_method_S_0021;
            else
              push_send_data_method_delay <= push_send_data_method_delay + 1;
            end if;
          when push_send_data_method_S_0021 => 
            push_send_data_method <= push_send_data_method_S_0023;
          when push_send_data_method_S_0023 => 
            push_send_data_method <= push_send_data_method_S_0024;
          when push_send_data_method_S_0024 => 
            if tmp_0231 = '1' then
              push_send_data_method <= push_send_data_method_push_send_data_method_S_0024_body;
            end if;
          when push_send_data_method_S_0025 => 
            push_send_data_method <= push_send_data_method_S_0026;
          when push_send_data_method_S_0026 => 
            push_send_data_method <= push_send_data_method_S_0027;
          when push_send_data_method_S_0027 => 
            if push_send_data_method_delay >= 2 then
              push_send_data_method_delay <= (others => '0');
              push_send_data_method <= push_send_data_method_S_0028;
            else
              push_send_data_method_delay <= push_send_data_method_delay + 1;
            end if;
          when push_send_data_method_S_0028 => 
            push_send_data_method <= push_send_data_method_S_0030;
          when push_send_data_method_S_0030 => 
            push_send_data_method <= push_send_data_method_S_0031;
          when push_send_data_method_S_0031 => 
            if tmp_0236 = '1' then
              push_send_data_method <= push_send_data_method_push_send_data_method_S_0031_body;
            end if;
          when push_send_data_method_S_0032 => 
            push_send_data_method <= push_send_data_method_S_0015;
          when push_send_data_method_S_0033 => 
            push_send_data_method <= push_send_data_method_S_0034;
          when push_send_data_method_S_0034 => 
            push_send_data_method <= push_send_data_method_S_0035;
          when push_send_data_method_S_0035 => 
            if tmp_0237 = '1' then
              push_send_data_method <= push_send_data_method_push_send_data_method_S_0035_body;
            end if;
          when push_send_data_method_S_0036 => 
            push_send_data_method <= push_send_data_method_S_0037;
          when push_send_data_method_S_0037 => 
            push_send_data_method <= push_send_data_method_S_0040;
          when push_send_data_method_S_0040 => 
            if tmp_0242 = '1' then
              push_send_data_method <= push_send_data_method_push_send_data_method_S_0040_body;
            end if;
          when push_send_data_method_S_0041 => 
            push_send_data_method <= push_send_data_method_S_0042;
          when push_send_data_method_S_0042 => 
            push_send_data_method <= push_send_data_method_S_0045;
          when push_send_data_method_S_0045 => 
            if tmp_0247 = '1' then
              push_send_data_method <= push_send_data_method_push_send_data_method_S_0045_body;
            end if;
          when push_send_data_method_S_0046 => 
            push_send_data_method <= push_send_data_method_S_0047;
          when push_send_data_method_S_0047 => 
            push_send_data_method <= push_send_data_method_S_0050;
          when push_send_data_method_S_0050 => 
            if tmp_0252 = '1' then
              push_send_data_method <= push_send_data_method_push_send_data_method_S_0050_body;
            end if;
          when push_send_data_method_S_0051 => 
            push_send_data_method <= push_send_data_method_S_0052;
          when push_send_data_method_S_0052 => 
            push_send_data_method <= push_send_data_method_S_0053;
          when push_send_data_method_S_0053 => 
            if tmp_0257 = '1' then
              push_send_data_method <= push_send_data_method_push_send_data_method_S_0053_body;
            end if;
          when push_send_data_method_S_0054 => 
            push_send_data_method <= push_send_data_method_S_0000;
          when push_send_data_method_push_send_data_method_S_0024_body => 
            if push_send_data_method_delay >= 1 and write_data_call_flag_0024 = '1' then
              push_send_data_method_delay <= (others => '0');
              push_send_data_method <= push_send_data_method_S_0025;
            else
              push_send_data_method_delay <= push_send_data_method_delay + 1;
            end if;
          when push_send_data_method_push_send_data_method_S_0031_body => 
            if push_send_data_method_delay >= 1 and write_data_call_flag_0031 = '1' then
              push_send_data_method_delay <= (others => '0');
              push_send_data_method <= push_send_data_method_S_0032;
            else
              push_send_data_method_delay <= push_send_data_method_delay + 1;
            end if;
          when push_send_data_method_push_send_data_method_S_0035_body => 
            if push_send_data_method_delay >= 1 and write_data_call_flag_0035 = '1' then
              push_send_data_method_delay <= (others => '0');
              push_send_data_method <= push_send_data_method_S_0036;
            else
              push_send_data_method_delay <= push_send_data_method_delay + 1;
            end if;
          when push_send_data_method_push_send_data_method_S_0040_body => 
            if push_send_data_method_delay >= 1 and write_data_call_flag_0040 = '1' then
              push_send_data_method_delay <= (others => '0');
              push_send_data_method <= push_send_data_method_S_0041;
            else
              push_send_data_method_delay <= push_send_data_method_delay + 1;
            end if;
          when push_send_data_method_push_send_data_method_S_0045_body => 
            if push_send_data_method_delay >= 1 and write_data_call_flag_0045 = '1' then
              push_send_data_method_delay <= (others => '0');
              push_send_data_method <= push_send_data_method_S_0046;
            else
              push_send_data_method_delay <= push_send_data_method_delay + 1;
            end if;
          when push_send_data_method_push_send_data_method_S_0050_body => 
            if push_send_data_method_delay >= 1 and write_data_call_flag_0050 = '1' then
              push_send_data_method_delay <= (others => '0');
              push_send_data_method <= push_send_data_method_S_0051;
            else
              push_send_data_method_delay <= push_send_data_method_delay + 1;
            end if;
          when push_send_data_method_push_send_data_method_S_0053_body => 
            if push_send_data_method_delay >= 1 and write_data_call_flag_0053 = '1' then
              push_send_data_method_delay <= (others => '0');
              push_send_data_method <= push_send_data_method_S_0054;
            else
              push_send_data_method_delay <= push_send_data_method_delay + 1;
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
        tcp_server_method <= tcp_server_method_IDLE;
        tcp_server_method_delay <= (others => '0');
      else
        case (tcp_server_method) is
          when tcp_server_method_IDLE => 
            tcp_server_method <= tcp_server_method_S_0000;
          when tcp_server_method_S_0000 => 
            tcp_server_method <= tcp_server_method_S_0001;
            tcp_server_method <= tcp_server_method_S_0001;
          when tcp_server_method_S_0001 => 
            if tcp_server_req_flag = '1' then
              tcp_server_method <= tcp_server_method_S_0002;
            end if;
          when tcp_server_method_S_0002 => 
            tcp_server_method <= tcp_server_method_S_0003;
          when tcp_server_method_S_0003 => 
            tcp_server_method <= tcp_server_method_S_0004;
          when tcp_server_method_S_0004 => 
            if tmp_0288 = '1' then
              tcp_server_method <= tcp_server_method_tcp_server_method_S_0004_body;
            end if;
          when tcp_server_method_S_0005 => 
            if tmp_0293 = '1' then
              tcp_server_method <= tcp_server_method_tcp_server_method_S_0005_body;
            end if;
          when tcp_server_method_S_0006 => 
            tcp_server_method <= tcp_server_method_S_0007;
          when tcp_server_method_S_0007 => 
            tcp_server_method <= tcp_server_method_S_0008;
          when tcp_server_method_S_0008 => 
            if tmp_0294 = '1' then
              tcp_server_method <= tcp_server_method_S_0010;
            elsif tmp_0295 = '1' then
              tcp_server_method <= tcp_server_method_S_0009;
            end if;
          when tcp_server_method_S_0009 => 
            tcp_server_method <= tcp_server_method_S_0016;
          when tcp_server_method_S_0010 => 
            tcp_server_method <= tcp_server_method_S_0011;
          when tcp_server_method_S_0011 => 
            tcp_server_method <= tcp_server_method_S_0012;
          when tcp_server_method_S_0012 => 
            if tmp_0296 = '1' then
              tcp_server_method <= tcp_server_method_tcp_server_method_S_0012_body;
            end if;
          when tcp_server_method_S_0013 => 
            if tmp_0301 = '1' then
              tcp_server_method <= tcp_server_method_tcp_server_method_S_0013_body;
            end if;
          when tcp_server_method_S_0014 => 
            tcp_server_method <= tcp_server_method_S_0015;
          when tcp_server_method_S_0015 => 
            tcp_server_method <= tcp_server_method_S_0007;
          when tcp_server_method_S_0016 => 
            if tmp_0306 = '1' then
              tcp_server_method <= tcp_server_method_tcp_server_method_S_0016_body;
            end if;
          when tcp_server_method_S_0017 => 
            tcp_server_method <= tcp_server_method_S_0018;
          when tcp_server_method_S_0018 => 
            tcp_server_method <= tcp_server_method_S_0019;
          when tcp_server_method_S_0019 => 
            if tmp_0307 = '1' then
              tcp_server_method <= tcp_server_method_S_0021;
            elsif tmp_0308 = '1' then
              tcp_server_method <= tcp_server_method_S_0020;
            end if;
          when tcp_server_method_S_0020 => 
            tcp_server_method <= tcp_server_method_S_0027;
          when tcp_server_method_S_0021 => 
            tcp_server_method <= tcp_server_method_S_0022;
          when tcp_server_method_S_0022 => 
            tcp_server_method <= tcp_server_method_S_0023;
          when tcp_server_method_S_0023 => 
            if tmp_0313 = '1' then
              tcp_server_method <= tcp_server_method_tcp_server_method_S_0023_body;
            end if;
          when tcp_server_method_S_0024 => 
            if tmp_0318 = '1' then
              tcp_server_method <= tcp_server_method_tcp_server_method_S_0024_body;
            end if;
          when tcp_server_method_S_0025 => 
            tcp_server_method <= tcp_server_method_S_0026;
          when tcp_server_method_S_0026 => 
            tcp_server_method <= tcp_server_method_S_0018;
          when tcp_server_method_S_0027 => 
            if tmp_0323 = '1' then
              tcp_server_method <= tcp_server_method_tcp_server_method_S_0027_body;
            end if;
          when tcp_server_method_S_0028 => 
            if tmp_0324 = '1' then
              tcp_server_method <= tcp_server_method_S_0030;
            elsif tmp_0325 = '1' then
              tcp_server_method <= tcp_server_method_S_0029;
            end if;
          when tcp_server_method_S_0029 => 
            tcp_server_method <= tcp_server_method_S_0035;
          when tcp_server_method_S_0030 => 
            if tmp_0330 = '1' then
              tcp_server_method <= tcp_server_method_tcp_server_method_S_0030_body;
            end if;
          when tcp_server_method_S_0031 => 
            tcp_server_method <= tcp_server_method_S_0032;
          when tcp_server_method_S_0032 => 
            if tmp_0335 = '1' then
              tcp_server_method <= tcp_server_method_tcp_server_method_S_0032_body;
            end if;
          when tcp_server_method_S_0033 => 
            if tmp_0340 = '1' then
              tcp_server_method <= tcp_server_method_tcp_server_method_S_0033_body;
            end if;
          when tcp_server_method_S_0034 => 
            tcp_server_method <= tcp_server_method_S_0028;
          when tcp_server_method_S_0035 => 
            tcp_server_method <= tcp_server_method_S_0000;
          when tcp_server_method_tcp_server_method_S_0004_body => 
            if tcp_server_method_delay >= 1 and write_data_call_flag_0004 = '1' then
              tcp_server_method_delay <= (others => '0');
              tcp_server_method <= tcp_server_method_S_0005;
            else
              tcp_server_method_delay <= tcp_server_method_delay + 1;
            end if;
          when tcp_server_method_tcp_server_method_S_0005_body => 
            if tcp_server_method_delay >= 1 and tcp_server_open_call_flag_0005 = '1' then
              tcp_server_method_delay <= (others => '0');
              tcp_server_method <= tcp_server_method_S_0006;
            else
              tcp_server_method_delay <= tcp_server_method_delay + 1;
            end if;
          when tcp_server_method_tcp_server_method_S_0012_body => 
            if tcp_server_method_delay >= 1 and write_data_call_flag_0012 = '1' then
              tcp_server_method_delay <= (others => '0');
              tcp_server_method <= tcp_server_method_S_0013;
            else
              tcp_server_method_delay <= tcp_server_method_delay + 1;
            end if;
          when tcp_server_method_tcp_server_method_S_0013_body => 
            if tcp_server_method_delay >= 1 and tcp_server_open_call_flag_0013 = '1' then
              tcp_server_method_delay <= (others => '0');
              tcp_server_method <= tcp_server_method_S_0014;
            else
              tcp_server_method_delay <= tcp_server_method_delay + 1;
            end if;
          when tcp_server_method_tcp_server_method_S_0016_body => 
            if tcp_server_method_delay >= 1 and tcp_server_listen_call_flag_0016 = '1' then
              tcp_server_method_delay <= (others => '0');
              tcp_server_method <= tcp_server_method_S_0017;
            else
              tcp_server_method_delay <= tcp_server_method_delay + 1;
            end if;
          when tcp_server_method_tcp_server_method_S_0023_body => 
            if tcp_server_method_delay >= 1 and write_data_call_flag_0023 = '1' then
              tcp_server_method_delay <= (others => '0');
              tcp_server_method <= tcp_server_method_S_0024;
            else
              tcp_server_method_delay <= tcp_server_method_delay + 1;
            end if;
          when tcp_server_method_tcp_server_method_S_0024_body => 
            if tcp_server_method_delay >= 1 and tcp_server_listen_call_flag_0024 = '1' then
              tcp_server_method_delay <= (others => '0');
              tcp_server_method <= tcp_server_method_S_0025;
            else
              tcp_server_method_delay <= tcp_server_method_delay + 1;
            end if;
          when tcp_server_method_tcp_server_method_S_0027_body => 
            if tcp_server_method_delay >= 1 and wait_for_established_call_flag_0027 = '1' then
              tcp_server_method_delay <= (others => '0');
              tcp_server_method <= tcp_server_method_S_0028;
            else
              tcp_server_method_delay <= tcp_server_method_delay + 1;
            end if;
          when tcp_server_method_tcp_server_method_S_0030_body => 
            if tcp_server_method_delay >= 1 and wait_for_recv_call_flag_0030 = '1' then
              tcp_server_method_delay <= (others => '0');
              tcp_server_method <= tcp_server_method_S_0031;
            else
              tcp_server_method_delay <= tcp_server_method_delay + 1;
            end if;
          when tcp_server_method_tcp_server_method_S_0032_body => 
            if tcp_server_method_delay >= 1 and pull_recv_data_call_flag_0032 = '1' then
              tcp_server_method_delay <= (others => '0');
              tcp_server_method <= tcp_server_method_S_0033;
            else
              tcp_server_method_delay <= tcp_server_method_delay + 1;
            end if;
          when tcp_server_method_tcp_server_method_S_0033_body => 
            if tcp_server_method_delay >= 1 and push_send_data_call_flag_0033 = '1' then
              tcp_server_method_delay <= (others => '0');
              tcp_server_method <= tcp_server_method_S_0034;
            else
              tcp_server_method_delay <= tcp_server_method_delay + 1;
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
        test_method <= test_method_IDLE;
        test_method_delay <= (others => '0');
      else
        case (test_method) is
          when test_method_IDLE => 
            test_method <= test_method_S_0000;
          when test_method_S_0000 => 
            test_method <= test_method_S_0001;
            test_method <= test_method_S_0001;
          when test_method_S_0001 => 
            if test_req_flag = '1' then
              test_method <= test_method_S_0002;
            end if;
          when test_method_S_0002 => 
            if tmp_0353 = '1' then
              test_method <= test_method_test_method_S_0002_body;
            end if;
          when test_method_S_0003 => 
            if tmp_0358 = '1' then
              test_method <= test_method_test_method_S_0003_body;
            end if;
          when test_method_S_0004 => 
            if tmp_0363 = '1' then
              test_method <= test_method_test_method_S_0004_body;
            end if;
          when test_method_S_0005 => 
            if tmp_0364 = '1' then
              test_method <= test_method_S_0007;
            elsif tmp_0365 = '1' then
              test_method <= test_method_S_0006;
            end if;
          when test_method_S_0006 => 
            test_method <= test_method_S_0008;
          when test_method_S_0007 => 
            test_method <= test_method_S_0005;
          when test_method_S_0008 => 
            test_method <= test_method_S_0000;
          when test_method_test_method_S_0002_body => 
            if test_method_delay >= 1 and init_call_flag_0002 = '1' then
              test_method_delay <= (others => '0');
              test_method <= test_method_S_0003;
            else
              test_method_delay <= test_method_delay + 1;
            end if;
          when test_method_test_method_S_0003_body => 
            if test_method_delay >= 1 and network_configuration_call_flag_0003 = '1' then
              test_method_delay <= (others => '0');
              test_method <= test_method_S_0004;
            else
              test_method_delay <= test_method_delay + 1;
            end if;
          when test_method_test_method_S_0004_body => 
            if test_method_delay >= 1 and tcp_server_call_flag_0004 = '1' then
              test_method_delay <= (others => '0');
              test_method <= test_method_S_0005;
            else
              test_method_delay <= test_method_delay + 1;
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
        blink_led_method <= blink_led_method_IDLE;
        blink_led_method_delay <= (others => '0');
      else
        case (blink_led_method) is
          when blink_led_method_IDLE => 
            blink_led_method <= blink_led_method_S_0000;
          when blink_led_method_S_0000 => 
            blink_led_method <= blink_led_method_S_0001;
            blink_led_method <= blink_led_method_S_0001;
          when blink_led_method_S_0001 => 
            if blink_led_req_flag = '1' then
              blink_led_method <= blink_led_method_S_0002;
            end if;
          when blink_led_method_S_0002 => 
            if tmp_0366 = '1' then
              blink_led_method <= blink_led_method_S_0004;
            elsif tmp_0367 = '1' then
              blink_led_method <= blink_led_method_S_0003;
            end if;
          when blink_led_method_S_0003 => 
            blink_led_method <= blink_led_method_S_0021;
          when blink_led_method_S_0004 => 
            blink_led_method <= blink_led_method_S_0005;
          when blink_led_method_S_0005 => 
            if tmp_0368 = '1' then
              blink_led_method <= blink_led_method_S_0007;
            elsif tmp_0369 = '1' then
              blink_led_method <= blink_led_method_S_0009;
            end if;
          when blink_led_method_S_0006 => 
            blink_led_method <= blink_led_method_S_0012;
          when blink_led_method_S_0007 => 
            blink_led_method <= blink_led_method_S_0008;
          when blink_led_method_S_0008 => 
            blink_led_method <= blink_led_method_S_0006;
          when blink_led_method_S_0009 => 
            blink_led_method <= blink_led_method_S_0010;
          when blink_led_method_S_0010 => 
            blink_led_method <= blink_led_method_S_0011;
          when blink_led_method_S_0011 => 
            blink_led_method <= blink_led_method_S_0006;
          when blink_led_method_S_0012 => 
            blink_led_method <= blink_led_method_S_0013;
          when blink_led_method_S_0013 => 
            blink_led_method <= blink_led_method_S_0014;
          when blink_led_method_S_0014 => 
            if tmp_0370 = '1' then
              blink_led_method <= blink_led_method_S_0019;
            elsif tmp_0371 = '1' then
              blink_led_method <= blink_led_method_S_0015;
            end if;
          when blink_led_method_S_0015 => 
            blink_led_method <= blink_led_method_S_0020;
          when blink_led_method_S_0016 => 
            blink_led_method <= blink_led_method_S_0017;
          when blink_led_method_S_0017 => 
            blink_led_method <= blink_led_method_S_0018;
          when blink_led_method_S_0018 => 
            blink_led_method <= blink_led_method_S_0013;
          when blink_led_method_S_0019 => 
            blink_led_method <= blink_led_method_S_0016;
          when blink_led_method_S_0020 => 
            blink_led_method <= blink_led_method_S_0002;
          when blink_led_method_S_0021 => 
            blink_led_method <= blink_led_method_S_0000;
          when others => null;
        end case;
      end if;
    end if;
  end process;


  class_wiz830mj_0000_clk <= clk_sig;

  class_wiz830mj_0000_reset <= reset_sig;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_wiz830mj_0000_address <= (others => '0');
      else
        if write_data_method = write_data_method_S_0003 then
          class_wiz830mj_0000_address <= std_logic_vector(write_data_addr_0093);
        elsif read_data_method = read_data_method_S_0003 then
          class_wiz830mj_0000_address <= std_logic_vector(read_data_addr_0102);
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_wiz830mj_0000_wdata <= (others => '0');
      else
        if write_data_method = write_data_method_S_0005 then
          class_wiz830mj_0000_wdata <= std_logic_vector(write_data_data_0094);
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_wiz830mj_0000_cs <= '0';
      else
        if write_data_method = write_data_method_S_0007 then
          class_wiz830mj_0000_cs <= '1';
        elsif write_data_method = write_data_method_S_0014 then
          class_wiz830mj_0000_cs <= '0';
        elsif read_data_method = read_data_method_S_0005 then
          class_wiz830mj_0000_cs <= '1';
        elsif read_data_method = read_data_method_S_0014 then
          class_wiz830mj_0000_cs <= '0';
        elsif init_method = init_method_S_0003 then
          class_wiz830mj_0000_cs <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_wiz830mj_0000_oe <= '0';
      else
        if read_data_method = read_data_method_S_0007 then
          class_wiz830mj_0000_oe <= '1';
        elsif read_data_method = read_data_method_S_0012 then
          class_wiz830mj_0000_oe <= '0';
        elsif init_method = init_method_S_0007 then
          class_wiz830mj_0000_oe <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_wiz830mj_0000_we <= '0';
      else
        if write_data_method = write_data_method_S_0009 then
          class_wiz830mj_0000_we <= '1';
        elsif write_data_method = write_data_method_S_0012 then
          class_wiz830mj_0000_we <= '0';
        elsif init_method = init_method_S_0005 then
          class_wiz830mj_0000_we <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_wiz830mj_0000_module_reset <= '0';
      else
        if init_method = init_method_S_0009 then
          class_wiz830mj_0000_module_reset <= '1';
        elsif init_method = init_method_S_0012 then
          class_wiz830mj_0000_module_reset <= '0';
        end if;
      end if;
    end if;
  end process;

--  class_wiz830mj_0000_DATA <= class_wiz830mj_0000_DATA_exp_sig;

--  class_wiz830mj_0000_nINT <= class_wiz830mj_0000_nINT_exp_sig;

--  class_wiz830mj_0000_BRDY <= class_wiz830mj_0000_BRDY_exp_sig;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_led_0002 <= (others => '0');
      else
        if blink_led_method = blink_led_method_S_0007 then
          class_led_0002 <= X"00000000";
        elsif blink_led_method = blink_led_method_S_0010 then
          class_led_0002 <= unary_expr_00282;
        else
          class_led_0002 <= class_led_0002_mux;
        end if;
      end if;
    end if;
  end process;

  class_led_0002_mux <= tmp_0001;

  class_buffer_0088_clk <= clk_sig;

  class_buffer_0088_reset <= reset_sig;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_buffer_0088_address_b <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0020 then
          class_buffer_0088_address_b <= binary_expr_00198;
        elsif pull_recv_data_method = pull_recv_data_method_S_0027 then
          class_buffer_0088_address_b <= binary_expr_00204;
        elsif push_send_data_method = push_send_data_method_S_0020 and push_send_data_method_delay = 0 then
          class_buffer_0088_address_b <= binary_expr_00224;
        elsif push_send_data_method = push_send_data_method_S_0027 and push_send_data_method_delay = 0 then
          class_buffer_0088_address_b <= binary_expr_00230;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_buffer_0088_din_b <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0024 then
          class_buffer_0088_din_b <= method_result_00200;
        elsif pull_recv_data_method = pull_recv_data_method_S_0031 then
          class_buffer_0088_din_b <= method_result_00206;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_buffer_0088_we_b <= '0';
      else
        if pull_recv_data_method = pull_recv_data_method_S_0024 then
          class_buffer_0088_we_b <= '1';
        elsif pull_recv_data_method = pull_recv_data_method_S_0031 then
          class_buffer_0088_we_b <= '1';
        else
          class_buffer_0088_we_b <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_buffer_0088_oe_b <= '0';
      else
        if push_send_data_method = push_send_data_method_S_0020 and push_send_data_method_delay = 0 then
          class_buffer_0088_oe_b <= '1';
        elsif push_send_data_method = push_send_data_method_S_0027 and push_send_data_method_delay = 0 then
          class_buffer_0088_oe_b <= '1';
        else
          class_buffer_0088_oe_b <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_cycles_n_0089 <= (others => '0');
      else
        if wait_cycles_method = wait_cycles_method_S_0001 then
          wait_cycles_n_0089 <= wait_cycles_n_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_cycles_n_local <= (others => '0');
      else
        if write_data_method = write_data_method_write_data_method_S_0010_body and write_data_method_delay = 0 then
          wait_cycles_n_local <= X"00000003";
        elsif read_data_method = read_data_method_read_data_method_S_0008_body and read_data_method_delay = 0 then
          wait_cycles_n_local <= X"00000003";
        elsif init_method = init_method_init_method_S_0010_body and init_method_delay = 0 then
          wait_cycles_n_local <= X"000003e8";
        elsif init_method = init_method_init_method_S_0013_body and init_method_delay = 0 then
          wait_cycles_n_local <= X"000003e8";
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_cycles_i_0090 <= X"00000000";
      else
        if wait_cycles_method = wait_cycles_method_S_0002 then
          wait_cycles_i_0090 <= X"00000000";
        elsif wait_cycles_method = wait_cycles_method_S_0007 then
          wait_cycles_i_0090 <= unary_expr_00092;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00091 <= '0';
      else
        if wait_cycles_method = wait_cycles_method_S_0003 then
          binary_expr_00091 <= tmp_0006;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        unary_expr_00092 <= (others => '0');
      else
        if wait_cycles_method = wait_cycles_method_S_0006 then
          unary_expr_00092 <= tmp_0007;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        write_data_addr_0093 <= (others => '0');
      else
        if write_data_method = write_data_method_S_0001 then
          write_data_addr_0093 <= write_data_addr_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        write_data_addr_local <= (others => '0');
      else
        if network_configuration_method = network_configuration_method_network_configuration_method_S_0002_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"00000008";
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0003_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"00000009";
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0004_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"0000000a";
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0005_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"0000000b";
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0006_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"0000000c";
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0007_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"0000000d";
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0008_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"00000010";
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0009_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"00000011";
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0010_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"00000012";
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0011_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"00000013";
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0012_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"00000014";
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0013_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"00000015";
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0014_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"00000016";
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0015_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"00000017";
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0016_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"00000018";
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0017_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"00000019";
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0018_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"0000001a";
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0019_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"0000001b";
        elsif tcp_server_open_method = tcp_server_open_method_tcp_server_open_method_S_0004_body and tcp_server_open_method_delay = 0 then
          write_data_addr_local <= binary_expr_00139;
        elsif tcp_server_open_method = tcp_server_open_method_tcp_server_open_method_S_0007_body and tcp_server_open_method_delay = 0 then
          write_data_addr_local <= binary_expr_00142;
        elsif tcp_server_open_method = tcp_server_open_method_tcp_server_open_method_S_0010_body and tcp_server_open_method_delay = 0 then
          write_data_addr_local <= binary_expr_00145;
        elsif tcp_server_open_method = tcp_server_open_method_tcp_server_open_method_S_0013_body and tcp_server_open_method_delay = 0 then
          write_data_addr_local <= binary_expr_00148;
        elsif tcp_server_listen_method = tcp_server_listen_method_tcp_server_listen_method_S_0004_body and tcp_server_listen_method_delay = 0 then
          write_data_addr_local <= binary_expr_00155;
        elsif pull_recv_data_method = pull_recv_data_method_pull_recv_data_method_S_0035_body and pull_recv_data_method_delay = 0 then
          write_data_addr_local <= binary_expr_00211;
        elsif push_send_data_method = push_send_data_method_push_send_data_method_S_0024_body and push_send_data_method_delay = 0 then
          write_data_addr_local <= binary_expr_00228;
        elsif push_send_data_method = push_send_data_method_push_send_data_method_S_0031_body and push_send_data_method_delay = 0 then
          write_data_addr_local <= binary_expr_00234;
        elsif push_send_data_method = push_send_data_method_push_send_data_method_S_0035_body and push_send_data_method_delay = 0 then
          write_data_addr_local <= binary_expr_00237;
        elsif push_send_data_method = push_send_data_method_push_send_data_method_S_0040_body and push_send_data_method_delay = 0 then
          write_data_addr_local <= binary_expr_00240;
        elsif push_send_data_method = push_send_data_method_push_send_data_method_S_0045_body and push_send_data_method_delay = 0 then
          write_data_addr_local <= binary_expr_00245;
        elsif push_send_data_method = push_send_data_method_push_send_data_method_S_0050_body and push_send_data_method_delay = 0 then
          write_data_addr_local <= binary_expr_00250;
        elsif push_send_data_method = push_send_data_method_push_send_data_method_S_0053_body and push_send_data_method_delay = 0 then
          write_data_addr_local <= binary_expr_00255;
        elsif tcp_server_method = tcp_server_method_tcp_server_method_S_0004_body and tcp_server_method_delay = 0 then
          write_data_addr_local <= binary_expr_00259;
        elsif tcp_server_method = tcp_server_method_tcp_server_method_S_0012_body and tcp_server_method_delay = 0 then
          write_data_addr_local <= binary_expr_00265;
        elsif tcp_server_method = tcp_server_method_tcp_server_method_S_0023_body and tcp_server_method_delay = 0 then
          write_data_addr_local <= binary_expr_00271;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        write_data_data_0094 <= (others => '0');
      else
        if write_data_method = write_data_method_S_0001 then
          write_data_data_0094 <= write_data_data_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        write_data_data_local <= (others => '0');
      else
        if network_configuration_method = network_configuration_method_network_configuration_method_S_0002_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"00";
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0003_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"08";
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0004_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"dc";
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0005_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"01";
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0006_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"02";
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0007_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"03";
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0008_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"0a";
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0009_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"00";
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0010_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"00";
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0011_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"01";
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0012_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"ff";
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0013_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"00";
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0014_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"00";
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0015_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"00";
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0016_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"0a";
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0017_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"00";
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0018_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"00";
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0019_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"02";
        elsif tcp_server_open_method = tcp_server_open_method_tcp_server_open_method_S_0004_body and tcp_server_open_method_delay = 0 then
          write_data_data_local <= class_Sn_MR_TCP_0054;
        elsif tcp_server_open_method = tcp_server_open_method_tcp_server_open_method_S_0007_body and tcp_server_open_method_delay = 0 then
          write_data_data_local <= X"00";
        elsif tcp_server_open_method = tcp_server_open_method_tcp_server_open_method_S_0010_body and tcp_server_open_method_delay = 0 then
          write_data_data_local <= X"50";
        elsif tcp_server_open_method = tcp_server_open_method_tcp_server_open_method_S_0013_body and tcp_server_open_method_delay = 0 then
          write_data_data_local <= class_Sn_CR_OPEN_0059;
        elsif tcp_server_listen_method = tcp_server_listen_method_tcp_server_listen_method_S_0004_body and tcp_server_listen_method_delay = 0 then
          write_data_data_local <= class_Sn_CR_LISTEN_0060;
        elsif pull_recv_data_method = pull_recv_data_method_pull_recv_data_method_S_0035_body and pull_recv_data_method_delay = 0 then
          write_data_data_local <= class_Sn_CR_RECV_0067;
        elsif push_send_data_method = push_send_data_method_push_send_data_method_S_0024_body and push_send_data_method_delay = 0 then
          write_data_data_local <= push_send_data_v_0222;
        elsif push_send_data_method = push_send_data_method_push_send_data_method_S_0031_body and push_send_data_method_delay = 0 then
          write_data_data_local <= push_send_data_v_0222;
        elsif push_send_data_method = push_send_data_method_push_send_data_method_S_0035_body and push_send_data_method_delay = 0 then
          write_data_data_local <= class_Sn_CR_RECV_0067;
        elsif push_send_data_method = push_send_data_method_push_send_data_method_S_0040_body and push_send_data_method_delay = 0 then
          write_data_data_local <= cast_expr_00242;
        elsif push_send_data_method = push_send_data_method_push_send_data_method_S_0045_body and push_send_data_method_delay = 0 then
          write_data_data_local <= cast_expr_00247;
        elsif push_send_data_method = push_send_data_method_push_send_data_method_S_0050_body and push_send_data_method_delay = 0 then
          write_data_data_local <= cast_expr_00252;
        elsif push_send_data_method = push_send_data_method_push_send_data_method_S_0053_body and push_send_data_method_delay = 0 then
          write_data_data_local <= class_Sn_CR_SEND_0064;
        elsif tcp_server_method = tcp_server_method_tcp_server_method_S_0004_body and tcp_server_method_delay = 0 then
          write_data_data_local <= X"01";
        elsif tcp_server_method = tcp_server_method_tcp_server_method_S_0012_body and tcp_server_method_delay = 0 then
          write_data_data_local <= class_Sn_CR_CLOSE_0063;
        elsif tcp_server_method = tcp_server_method_tcp_server_method_S_0023_body and tcp_server_method_delay = 0 then
          write_data_data_local <= class_Sn_CR_CLOSE_0063;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        field_access_00095 <= (others => '0');
      else
        if write_data_method = write_data_method_S_0002 then
          field_access_00095 <= signed(class_wiz830mj_0000_address);
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        field_access_00096 <= (others => '0');
      else
        if write_data_method = write_data_method_S_0004 then
          field_access_00096 <= signed(class_wiz830mj_0000_wdata);
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        field_access_00097 <= '0';
      else
        if write_data_method = write_data_method_S_0006 then
          field_access_00097 <= class_wiz830mj_0000_cs;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        field_access_00098 <= '0';
      else
        if write_data_method = write_data_method_S_0008 then
          field_access_00098 <= class_wiz830mj_0000_we;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        field_access_00100 <= '0';
      else
        if write_data_method = write_data_method_S_0011 then
          field_access_00100 <= class_wiz830mj_0000_we;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        field_access_00101 <= '0';
      else
        if write_data_method = write_data_method_S_0013 then
          field_access_00101 <= class_wiz830mj_0000_cs;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        read_data_addr_0102 <= (others => '0');
      else
        if read_data_method = read_data_method_S_0001 then
          read_data_addr_0102 <= read_data_addr_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        read_data_addr_local <= (others => '0');
      else
        if tcp_server_open_method = tcp_server_open_method_tcp_server_open_method_S_0016_body and tcp_server_open_method_delay = 0 then
          read_data_addr_local <= binary_expr_00151;
        elsif tcp_server_listen_method = tcp_server_listen_method_tcp_server_listen_method_S_0007_body and tcp_server_listen_method_delay = 0 then
          read_data_addr_local <= binary_expr_00158;
        elsif wait_for_established_method = wait_for_established_method_wait_for_established_method_S_0006_body and wait_for_established_method_delay = 0 then
          read_data_addr_local <= binary_expr_00163;
        elsif wait_for_recv_method = wait_for_recv_method_wait_for_recv_method_S_0008_body and wait_for_recv_method_delay = 0 then
          read_data_addr_local <= binary_expr_00170;
        elsif wait_for_recv_method = wait_for_recv_method_wait_for_recv_method_S_0013_body and wait_for_recv_method_delay = 0 then
          read_data_addr_local <= binary_expr_00175;
        elsif wait_for_recv_method = wait_for_recv_method_wait_for_recv_method_S_0018_body and wait_for_recv_method_delay = 0 then
          read_data_addr_local <= binary_expr_00180;
        elsif pull_recv_data_method = pull_recv_data_method_pull_recv_data_method_S_0023_body and pull_recv_data_method_delay = 0 then
          read_data_addr_local <= binary_expr_00202;
        elsif pull_recv_data_method = pull_recv_data_method_pull_recv_data_method_S_0030_body and pull_recv_data_method_delay = 0 then
          read_data_addr_local <= binary_expr_00208;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        field_access_00103 <= (others => '0');
      else
        if read_data_method = read_data_method_S_0002 then
          field_access_00103 <= signed(class_wiz830mj_0000_address);
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        field_access_00104 <= '0';
      else
        if read_data_method = read_data_method_S_0004 then
          field_access_00104 <= class_wiz830mj_0000_cs;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        field_access_00105 <= '0';
      else
        if read_data_method = read_data_method_S_0006 then
          field_access_00105 <= class_wiz830mj_0000_oe;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        read_data_v_0107 <= (others => '0');
      else
        if read_data_method = read_data_method_S_0010 then
          read_data_v_0107 <= field_access_00108;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        field_access_00108 <= (others => '0');
      else
        if read_data_method = read_data_method_S_0009 then
          field_access_00108 <= signed(class_wiz830mj_0000_rdata);
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        field_access_00109 <= '0';
      else
        if read_data_method = read_data_method_S_0011 then
          field_access_00109 <= class_wiz830mj_0000_oe;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        field_access_00110 <= '0';
      else
        if read_data_method = read_data_method_S_0013 then
          field_access_00110 <= class_wiz830mj_0000_cs;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        field_access_00111 <= '0';
      else
        if init_method = init_method_S_0002 then
          field_access_00111 <= class_wiz830mj_0000_cs;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        field_access_00112 <= '0';
      else
        if init_method = init_method_S_0004 then
          field_access_00112 <= class_wiz830mj_0000_we;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        field_access_00113 <= '0';
      else
        if init_method = init_method_S_0006 then
          field_access_00113 <= class_wiz830mj_0000_oe;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        field_access_00114 <= '0';
      else
        if init_method = init_method_S_0008 then
          field_access_00114 <= class_wiz830mj_0000_module_reset;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        field_access_00116 <= '0';
      else
        if init_method = init_method_S_0011 then
          field_access_00116 <= class_wiz830mj_0000_module_reset;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_open_port_0136 <= (others => '0');
      else
        if tcp_server_open_method = tcp_server_open_method_S_0001 then
          tcp_server_open_port_0136 <= tcp_server_open_port_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_open_port_local <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_tcp_server_method_S_0005_body and tcp_server_method_delay = 0 then
          tcp_server_open_port_local <= tcp_server_port_0256;
        elsif tcp_server_method = tcp_server_method_tcp_server_method_S_0013_body and tcp_server_method_delay = 0 then
          tcp_server_open_port_local <= tcp_server_port_0256;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00138 <= (others => '0');
      else
        if tcp_server_open_method = tcp_server_open_method_S_0002 then
          binary_expr_00138 <= tmp_0123;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00139 <= (others => '0');
      else
        if tcp_server_open_method = tcp_server_open_method_S_0003 then
          binary_expr_00139 <= tmp_0124;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00141 <= (others => '0');
      else
        if tcp_server_open_method = tcp_server_open_method_S_0005 then
          binary_expr_00141 <= tmp_0125;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00142 <= (others => '0');
      else
        if tcp_server_open_method = tcp_server_open_method_S_0006 then
          binary_expr_00142 <= tmp_0126;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00144 <= (others => '0');
      else
        if tcp_server_open_method = tcp_server_open_method_S_0008 then
          binary_expr_00144 <= tmp_0127;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00145 <= (others => '0');
      else
        if tcp_server_open_method = tcp_server_open_method_S_0009 then
          binary_expr_00145 <= tmp_0128;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00147 <= (others => '0');
      else
        if tcp_server_open_method = tcp_server_open_method_S_0011 then
          binary_expr_00147 <= tmp_0129;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00148 <= (others => '0');
      else
        if tcp_server_open_method = tcp_server_open_method_S_0012 then
          binary_expr_00148 <= tmp_0130;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00149 <= (others => '0');
      else
        if tcp_server_open_method = tcp_server_open_method_tcp_server_open_method_S_0016_body and tcp_server_open_method_delay >= 1 and read_data_call_flag_0016 = '1' then
          method_result_00149 <= read_data_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00150 <= (others => '0');
      else
        if tcp_server_open_method = tcp_server_open_method_S_0014 then
          binary_expr_00150 <= tmp_0131;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00151 <= (others => '0');
      else
        if tcp_server_open_method = tcp_server_open_method_S_0015 then
          binary_expr_00151 <= tmp_0132;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_listen_port_0152 <= (others => '0');
      else
        if tcp_server_listen_method = tcp_server_listen_method_S_0001 then
          tcp_server_listen_port_0152 <= tcp_server_listen_port_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_listen_port_local <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_tcp_server_method_S_0016_body and tcp_server_method_delay = 0 then
          tcp_server_listen_port_local <= tcp_server_port_0256;
        elsif tcp_server_method = tcp_server_method_tcp_server_method_S_0024_body and tcp_server_method_delay = 0 then
          tcp_server_listen_port_local <= tcp_server_port_0256;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00154 <= (others => '0');
      else
        if tcp_server_listen_method = tcp_server_listen_method_S_0002 then
          binary_expr_00154 <= tmp_0139;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00155 <= (others => '0');
      else
        if tcp_server_listen_method = tcp_server_listen_method_S_0003 then
          binary_expr_00155 <= tmp_0140;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00156 <= (others => '0');
      else
        if tcp_server_listen_method = tcp_server_listen_method_tcp_server_listen_method_S_0007_body and tcp_server_listen_method_delay >= 1 and read_data_call_flag_0007 = '1' then
          method_result_00156 <= read_data_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00157 <= (others => '0');
      else
        if tcp_server_listen_method = tcp_server_listen_method_S_0005 then
          binary_expr_00157 <= tmp_0141;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00158 <= (others => '0');
      else
        if tcp_server_listen_method = tcp_server_listen_method_S_0006 then
          binary_expr_00158 <= tmp_0142;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_established_port_0159 <= (others => '0');
      else
        if wait_for_established_method = wait_for_established_method_S_0001 then
          wait_for_established_port_0159 <= wait_for_established_port_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_established_port_local <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_tcp_server_method_S_0027_body and tcp_server_method_delay = 0 then
          wait_for_established_port_local <= tcp_server_port_0256;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_established_v_0160 <= (others => '0');
      else
        if wait_for_established_method = wait_for_established_method_S_0007 then
          wait_for_established_v_0160 <= method_result_00161;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00161 <= (others => '0');
      else
        if wait_for_established_method = wait_for_established_method_wait_for_established_method_S_0006_body and wait_for_established_method_delay >= 1 and read_data_call_flag_0006 = '1' then
          method_result_00161 <= read_data_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00162 <= (others => '0');
      else
        if wait_for_established_method = wait_for_established_method_S_0004 then
          binary_expr_00162 <= tmp_0152;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00163 <= (others => '0');
      else
        if wait_for_established_method = wait_for_established_method_S_0005 then
          binary_expr_00163 <= tmp_0153;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00164 <= '0';
      else
        if wait_for_established_method = wait_for_established_method_S_0008 then
          binary_expr_00164 <= tmp_0154;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_recv_port_0165 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0001 then
          wait_for_recv_port_0165 <= wait_for_recv_port_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_recv_port_local <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_tcp_server_method_S_0030_body and tcp_server_method_delay = 0 then
          wait_for_recv_port_local <= tcp_server_port_0256;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_recv_v_0166 <= X"00000000";
      else
        if wait_for_recv_method = wait_for_recv_method_S_0002 then
          wait_for_recv_v_0166 <= X"00000000";
        elsif wait_for_recv_method = wait_for_recv_method_S_0005 then
          wait_for_recv_v_0166 <= X"00000000";
        elsif wait_for_recv_method = wait_for_recv_method_S_0025 then
          wait_for_recv_v_0166 <= binary_expr_00185;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_recv_v0_0167 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0010 then
          wait_for_recv_v0_0167 <= cast_expr_00171;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00168 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_wait_for_recv_method_S_0008_body and wait_for_recv_method_delay >= 1 and read_data_call_flag_0008 = '1' then
          method_result_00168 <= read_data_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00169 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0005 then
          binary_expr_00169 <= tmp_0174;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00170 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0007 then
          binary_expr_00170 <= tmp_0175;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00171 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0009 then
          cast_expr_00171 <= tmp_0176;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_recv_v1_0172 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0015 then
          wait_for_recv_v1_0172 <= cast_expr_00176;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00173 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_wait_for_recv_method_S_0013_body and wait_for_recv_method_delay >= 1 and read_data_call_flag_0013 = '1' then
          method_result_00173 <= read_data_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00174 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0009 then
          binary_expr_00174 <= tmp_0177;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00175 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0010 then
          binary_expr_00175 <= tmp_0178;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00176 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0014 then
          cast_expr_00176 <= tmp_0179;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_recv_v2_0177 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0020 then
          wait_for_recv_v2_0177 <= cast_expr_00181;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00178 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_wait_for_recv_method_S_0018_body and wait_for_recv_method_delay >= 1 and read_data_call_flag_0018 = '1' then
          method_result_00178 <= read_data_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00179 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0014 then
          binary_expr_00179 <= tmp_0180;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00180 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0015 then
          binary_expr_00180 <= tmp_0181;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00181 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0019 then
          cast_expr_00181 <= tmp_0182;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00182 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0019 then
          binary_expr_00182 <= tmp_0183;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00183 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0019 then
          binary_expr_00183 <= tmp_0184;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00184 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0020 then
          binary_expr_00184 <= tmp_0185;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00185 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0024 then
          binary_expr_00185 <= tmp_0186;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00186 <= '0';
      else
        if wait_for_recv_method = wait_for_recv_method_S_0026 then
          binary_expr_00186 <= tmp_0187;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pull_recv_data_port_0187 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0001 then
          pull_recv_data_port_0187 <= pull_recv_data_port_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pull_recv_data_port_local <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_tcp_server_method_S_0032_body and tcp_server_method_delay = 0 then
          pull_recv_data_port_local <= tcp_server_port_0256;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pull_recv_data_len_0188 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0001 then
          pull_recv_data_len_0188 <= pull_recv_data_len_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pull_recv_data_len_local <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_tcp_server_method_S_0032_body and tcp_server_method_delay = 0 then
          pull_recv_data_len_local <= tcp_server_len_0274;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pull_recv_data_read_len_0189 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0003 then
          pull_recv_data_read_len_0189 <= binary_expr_00190;
        elsif pull_recv_data_method = pull_recv_data_method_S_0009 then
          pull_recv_data_read_len_0189 <= binary_expr_00193;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00190 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0002 then
          binary_expr_00190 <= tmp_0207;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00191 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0002 then
          binary_expr_00191 <= tmp_0208;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00192 <= '0';
      else
        if pull_recv_data_method = pull_recv_data_method_S_0003 then
          binary_expr_00192 <= tmp_0209;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00210 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0033 then
          binary_expr_00210 <= tmp_0221;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00211 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0034 then
          binary_expr_00211 <= tmp_0222;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00193 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0008 then
          binary_expr_00193 <= tmp_0210;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pull_recv_data_i_0194 <= X"00000000";
      else
        if pull_recv_data_method = pull_recv_data_method_S_0011 then
          pull_recv_data_i_0194 <= X"00000000";
        elsif pull_recv_data_method = pull_recv_data_method_S_0016 then
          pull_recv_data_i_0194 <= unary_expr_00196;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00195 <= '0';
      else
        if pull_recv_data_method = pull_recv_data_method_S_0012 then
          binary_expr_00195 <= tmp_0211;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        unary_expr_00196 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0015 then
          unary_expr_00196 <= tmp_0212;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00197 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0018 then
          binary_expr_00197 <= tmp_0213;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00198 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0019 then
          binary_expr_00198 <= tmp_0214;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00200 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_pull_recv_data_method_S_0023_body and pull_recv_data_method_delay >= 1 and read_data_call_flag_0023 = '1' then
          method_result_00200 <= read_data_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00201 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0021 then
          binary_expr_00201 <= tmp_0215;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00202 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0022 then
          binary_expr_00202 <= tmp_0216;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00203 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0024 then
          binary_expr_00203 <= tmp_0217;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00204 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0026 then
          binary_expr_00204 <= tmp_0218;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00206 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_pull_recv_data_method_S_0030_body and pull_recv_data_method_delay >= 1 and read_data_call_flag_0030 = '1' then
          method_result_00206 <= read_data_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00207 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0028 then
          binary_expr_00207 <= tmp_0219;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00208 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0029 then
          binary_expr_00208 <= tmp_0220;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        push_send_data_port_0212 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0001 then
          push_send_data_port_0212 <= push_send_data_port_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        push_send_data_port_local <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_tcp_server_method_S_0033_body and tcp_server_method_delay = 0 then
          push_send_data_port_local <= tcp_server_port_0256;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        push_send_data_len_0213 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0001 then
          push_send_data_len_0213 <= push_send_data_len_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        push_send_data_len_local <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_tcp_server_method_S_0033_body and tcp_server_method_delay = 0 then
          push_send_data_len_local <= tcp_server_len_0274;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        push_send_data_write_len_0214 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0003 then
          push_send_data_write_len_0214 <= binary_expr_00215;
        elsif push_send_data_method = push_send_data_method_S_0009 then
          push_send_data_write_len_0214 <= binary_expr_00218;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00215 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0002 then
          binary_expr_00215 <= tmp_0258;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00216 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0002 then
          binary_expr_00216 <= tmp_0259;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00217 <= '0';
      else
        if push_send_data_method = push_send_data_method_S_0003 then
          binary_expr_00217 <= tmp_0260;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00236 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0033 then
          binary_expr_00236 <= tmp_0272;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00237 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0034 then
          binary_expr_00237 <= tmp_0273;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00239 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0036 then
          binary_expr_00239 <= tmp_0274;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00240 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0037 then
          binary_expr_00240 <= tmp_0276;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00241 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0036 then
          binary_expr_00241 <= tmp_0275;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00242 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0037 then
          cast_expr_00242 <= tmp_0277;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00244 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0041 then
          binary_expr_00244 <= tmp_0278;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00245 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0042 then
          binary_expr_00245 <= tmp_0280;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00246 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0041 then
          binary_expr_00246 <= tmp_0279;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00247 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0042 then
          cast_expr_00247 <= tmp_0281;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00249 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0046 then
          binary_expr_00249 <= tmp_0282;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00250 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0047 then
          binary_expr_00250 <= tmp_0284;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00251 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0046 then
          binary_expr_00251 <= tmp_0283;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00252 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0047 then
          cast_expr_00252 <= tmp_0285;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00254 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0051 then
          binary_expr_00254 <= tmp_0286;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00255 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0052 then
          binary_expr_00255 <= tmp_0287;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00218 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0008 then
          binary_expr_00218 <= tmp_0261;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        push_send_data_i_0219 <= X"00000000";
      else
        if push_send_data_method = push_send_data_method_S_0011 then
          push_send_data_i_0219 <= X"00000000";
        elsif push_send_data_method = push_send_data_method_S_0016 then
          push_send_data_i_0219 <= unary_expr_00221;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00220 <= '0';
      else
        if push_send_data_method = push_send_data_method_S_0012 then
          binary_expr_00220 <= tmp_0262;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        unary_expr_00221 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0015 then
          unary_expr_00221 <= tmp_0263;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        push_send_data_v_0222 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0021 then
          push_send_data_v_0222 <= array_access_00225;
        elsif push_send_data_method = push_send_data_method_S_0028 then
          push_send_data_v_0222 <= array_access_00231;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00223 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0018 then
          binary_expr_00223 <= tmp_0264;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00224 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0019 then
          binary_expr_00224 <= tmp_0265;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        array_access_00225 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0020 and push_send_data_method_delay = 2 then
          array_access_00225 <= class_buffer_0088_dout_b;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00227 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0021 then
          binary_expr_00227 <= tmp_0266;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00228 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0023 then
          binary_expr_00228 <= tmp_0267;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00229 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0025 then
          binary_expr_00229 <= tmp_0268;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00230 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0026 then
          binary_expr_00230 <= tmp_0269;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        array_access_00231 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0027 and push_send_data_method_delay = 2 then
          array_access_00231 <= class_buffer_0088_dout_b;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00233 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0028 then
          binary_expr_00233 <= tmp_0270;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00234 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0030 then
          binary_expr_00234 <= tmp_0271;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_port_0256 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0001 then
          tcp_server_port_0256 <= tcp_server_port_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_port_local <= (others => '0');
      else
        if test_method = test_method_test_method_S_0004_body and test_method_delay = 0 then
          tcp_server_port_local <= X"00000000";
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00258 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0002 then
          binary_expr_00258 <= tmp_0341;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00259 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0003 then
          binary_expr_00259 <= tmp_0342;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_v_0260 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0006 then
          tcp_server_v_0260 <= method_result_00261;
        elsif tcp_server_method = tcp_server_method_S_0014 then
          tcp_server_v_0260 <= method_result_00266;
        elsif tcp_server_method = tcp_server_method_S_0017 then
          tcp_server_v_0260 <= method_result_00267;
        elsif tcp_server_method = tcp_server_method_S_0025 then
          tcp_server_v_0260 <= method_result_00272;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00261 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_tcp_server_method_S_0005_body and tcp_server_method_delay >= 1 and tcp_server_open_call_flag_0005 = '1' then
          method_result_00261 <= tcp_server_open_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00262 <= '0';
      else
        if tcp_server_method = tcp_server_method_S_0007 then
          binary_expr_00262 <= tmp_0343;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00267 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_tcp_server_method_S_0016_body and tcp_server_method_delay >= 1 and tcp_server_listen_call_flag_0016 = '1' then
          method_result_00267 <= tcp_server_listen_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00268 <= '0';
      else
        if tcp_server_method = tcp_server_method_S_0018 then
          binary_expr_00268 <= tmp_0346;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00264 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0010 then
          binary_expr_00264 <= tmp_0344;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00265 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0011 then
          binary_expr_00265 <= tmp_0345;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00266 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_tcp_server_method_S_0013_body and tcp_server_method_delay >= 1 and tcp_server_open_call_flag_0013 = '1' then
          method_result_00266 <= tcp_server_open_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00270 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0021 then
          binary_expr_00270 <= tmp_0347;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00271 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0022 then
          binary_expr_00271 <= tmp_0348;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00272 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_tcp_server_method_S_0024_body and tcp_server_method_delay >= 1 and tcp_server_listen_call_flag_0024 = '1' then
          method_result_00272 <= tcp_server_listen_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_len_0274 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0031 then
          tcp_server_len_0274 <= method_result_00275;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00275 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_tcp_server_method_S_0030_body and tcp_server_method_delay >= 1 and wait_for_recv_call_flag_0030 = '1' then
          method_result_00275 <= wait_for_recv_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00281 <= '0';
      else
        if blink_led_method = blink_led_method_S_0004 then
          binary_expr_00281 <= tmp_0372;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        unary_expr_00282 <= (others => '0');
      else
        if blink_led_method = blink_led_method_S_0009 then
          unary_expr_00282 <= tmp_0373;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        blink_led_i_0283 <= X"00000000";
      else
        if blink_led_method = blink_led_method_S_0012 then
          blink_led_i_0283 <= X"00000000";
        elsif blink_led_method = blink_led_method_S_0017 then
          blink_led_i_0283 <= unary_expr_00285;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00284 <= '0';
      else
        if blink_led_method = blink_led_method_S_0013 then
          binary_expr_00284 <= tmp_0374;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        unary_expr_00285 <= (others => '0');
      else
        if blink_led_method = blink_led_method_S_0016 then
          unary_expr_00285 <= tmp_0375;
        end if;
      end if;
    end if;
  end process;

  wait_cycles_req_flag <= wait_cycles_req_local;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_cycles_req_local <= '0';
      else
        if write_data_method = write_data_method_write_data_method_S_0010_body and write_data_method_delay = 0 then
          wait_cycles_req_local <= '1';
        elsif read_data_method = read_data_method_read_data_method_S_0008_body and read_data_method_delay = 0 then
          wait_cycles_req_local <= '1';
        elsif init_method = init_method_init_method_S_0010_body and init_method_delay = 0 then
          wait_cycles_req_local <= '1';
        elsif init_method = init_method_init_method_S_0013_body and init_method_delay = 0 then
          wait_cycles_req_local <= '1';
        else
          wait_cycles_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_cycles_busy <= '0';
      else
        if wait_cycles_method = wait_cycles_method_S_0001 then
          wait_cycles_busy <= wait_cycles_req_flag;
        end if;
      end if;
    end if;
  end process;

  write_data_req_flag <= write_data_req_local;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        write_data_req_local <= '0';
      else
        if network_configuration_method = network_configuration_method_network_configuration_method_S_0002_body and network_configuration_method_delay = 0 then
          write_data_req_local <= '1';
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0003_body and network_configuration_method_delay = 0 then
          write_data_req_local <= '1';
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0004_body and network_configuration_method_delay = 0 then
          write_data_req_local <= '1';
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0005_body and network_configuration_method_delay = 0 then
          write_data_req_local <= '1';
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0006_body and network_configuration_method_delay = 0 then
          write_data_req_local <= '1';
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0007_body and network_configuration_method_delay = 0 then
          write_data_req_local <= '1';
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0008_body and network_configuration_method_delay = 0 then
          write_data_req_local <= '1';
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0009_body and network_configuration_method_delay = 0 then
          write_data_req_local <= '1';
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0010_body and network_configuration_method_delay = 0 then
          write_data_req_local <= '1';
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0011_body and network_configuration_method_delay = 0 then
          write_data_req_local <= '1';
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0012_body and network_configuration_method_delay = 0 then
          write_data_req_local <= '1';
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0013_body and network_configuration_method_delay = 0 then
          write_data_req_local <= '1';
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0014_body and network_configuration_method_delay = 0 then
          write_data_req_local <= '1';
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0015_body and network_configuration_method_delay = 0 then
          write_data_req_local <= '1';
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0016_body and network_configuration_method_delay = 0 then
          write_data_req_local <= '1';
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0017_body and network_configuration_method_delay = 0 then
          write_data_req_local <= '1';
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0018_body and network_configuration_method_delay = 0 then
          write_data_req_local <= '1';
        elsif network_configuration_method = network_configuration_method_network_configuration_method_S_0019_body and network_configuration_method_delay = 0 then
          write_data_req_local <= '1';
        elsif tcp_server_open_method = tcp_server_open_method_tcp_server_open_method_S_0004_body and tcp_server_open_method_delay = 0 then
          write_data_req_local <= '1';
        elsif tcp_server_open_method = tcp_server_open_method_tcp_server_open_method_S_0007_body and tcp_server_open_method_delay = 0 then
          write_data_req_local <= '1';
        elsif tcp_server_open_method = tcp_server_open_method_tcp_server_open_method_S_0010_body and tcp_server_open_method_delay = 0 then
          write_data_req_local <= '1';
        elsif tcp_server_open_method = tcp_server_open_method_tcp_server_open_method_S_0013_body and tcp_server_open_method_delay = 0 then
          write_data_req_local <= '1';
        elsif tcp_server_listen_method = tcp_server_listen_method_tcp_server_listen_method_S_0004_body and tcp_server_listen_method_delay = 0 then
          write_data_req_local <= '1';
        elsif pull_recv_data_method = pull_recv_data_method_pull_recv_data_method_S_0035_body and pull_recv_data_method_delay = 0 then
          write_data_req_local <= '1';
        elsif push_send_data_method = push_send_data_method_push_send_data_method_S_0024_body and push_send_data_method_delay = 0 then
          write_data_req_local <= '1';
        elsif push_send_data_method = push_send_data_method_push_send_data_method_S_0031_body and push_send_data_method_delay = 0 then
          write_data_req_local <= '1';
        elsif push_send_data_method = push_send_data_method_push_send_data_method_S_0035_body and push_send_data_method_delay = 0 then
          write_data_req_local <= '1';
        elsif push_send_data_method = push_send_data_method_push_send_data_method_S_0040_body and push_send_data_method_delay = 0 then
          write_data_req_local <= '1';
        elsif push_send_data_method = push_send_data_method_push_send_data_method_S_0045_body and push_send_data_method_delay = 0 then
          write_data_req_local <= '1';
        elsif push_send_data_method = push_send_data_method_push_send_data_method_S_0050_body and push_send_data_method_delay = 0 then
          write_data_req_local <= '1';
        elsif push_send_data_method = push_send_data_method_push_send_data_method_S_0053_body and push_send_data_method_delay = 0 then
          write_data_req_local <= '1';
        elsif tcp_server_method = tcp_server_method_tcp_server_method_S_0004_body and tcp_server_method_delay = 0 then
          write_data_req_local <= '1';
        elsif tcp_server_method = tcp_server_method_tcp_server_method_S_0012_body and tcp_server_method_delay = 0 then
          write_data_req_local <= '1';
        elsif tcp_server_method = tcp_server_method_tcp_server_method_S_0023_body and tcp_server_method_delay = 0 then
          write_data_req_local <= '1';
        else
          write_data_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        write_data_busy <= '0';
      else
        if write_data_method = write_data_method_S_0001 then
          write_data_busy <= write_data_req_flag;
        end if;
      end if;
    end if;
  end process;

  read_data_req_flag <= read_data_req_local;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        read_data_req_local <= '0';
      else
        if tcp_server_open_method = tcp_server_open_method_tcp_server_open_method_S_0016_body and tcp_server_open_method_delay = 0 then
          read_data_req_local <= '1';
        elsif tcp_server_listen_method = tcp_server_listen_method_tcp_server_listen_method_S_0007_body and tcp_server_listen_method_delay = 0 then
          read_data_req_local <= '1';
        elsif wait_for_established_method = wait_for_established_method_wait_for_established_method_S_0006_body and wait_for_established_method_delay = 0 then
          read_data_req_local <= '1';
        elsif wait_for_recv_method = wait_for_recv_method_wait_for_recv_method_S_0008_body and wait_for_recv_method_delay = 0 then
          read_data_req_local <= '1';
        elsif wait_for_recv_method = wait_for_recv_method_wait_for_recv_method_S_0013_body and wait_for_recv_method_delay = 0 then
          read_data_req_local <= '1';
        elsif wait_for_recv_method = wait_for_recv_method_wait_for_recv_method_S_0018_body and wait_for_recv_method_delay = 0 then
          read_data_req_local <= '1';
        elsif pull_recv_data_method = pull_recv_data_method_pull_recv_data_method_S_0023_body and pull_recv_data_method_delay = 0 then
          read_data_req_local <= '1';
        elsif pull_recv_data_method = pull_recv_data_method_pull_recv_data_method_S_0030_body and pull_recv_data_method_delay = 0 then
          read_data_req_local <= '1';
        else
          read_data_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        read_data_busy <= '0';
      else
        if read_data_method = read_data_method_S_0001 then
          read_data_busy <= read_data_req_flag;
        end if;
      end if;
    end if;
  end process;

  init_req_flag <= init_req_local;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        init_req_local <= '0';
      else
        if test_method = test_method_test_method_S_0002_body and test_method_delay = 0 then
          init_req_local <= '1';
        else
          init_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        init_busy <= '0';
      else
        if init_method = init_method_S_0001 then
          init_busy <= init_req_flag;
        end if;
      end if;
    end if;
  end process;

  network_configuration_req_flag <= network_configuration_req_local;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        network_configuration_req_local <= '0';
      else
        if test_method = test_method_test_method_S_0003_body and test_method_delay = 0 then
          network_configuration_req_local <= '1';
        else
          network_configuration_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        network_configuration_busy <= '0';
      else
        if network_configuration_method = network_configuration_method_S_0001 then
          network_configuration_busy <= network_configuration_req_flag;
        end if;
      end if;
    end if;
  end process;

  tcp_server_open_req_flag <= tcp_server_open_req_local;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_open_req_local <= '0';
      else
        if tcp_server_method = tcp_server_method_tcp_server_method_S_0005_body and tcp_server_method_delay = 0 then
          tcp_server_open_req_local <= '1';
        elsif tcp_server_method = tcp_server_method_tcp_server_method_S_0013_body and tcp_server_method_delay = 0 then
          tcp_server_open_req_local <= '1';
        else
          tcp_server_open_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_open_busy <= '0';
      else
        if tcp_server_open_method = tcp_server_open_method_S_0001 then
          tcp_server_open_busy <= tcp_server_open_req_flag;
        end if;
      end if;
    end if;
  end process;

  tcp_server_listen_req_flag <= tcp_server_listen_req_local;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_listen_req_local <= '0';
      else
        if tcp_server_method = tcp_server_method_tcp_server_method_S_0016_body and tcp_server_method_delay = 0 then
          tcp_server_listen_req_local <= '1';
        elsif tcp_server_method = tcp_server_method_tcp_server_method_S_0024_body and tcp_server_method_delay = 0 then
          tcp_server_listen_req_local <= '1';
        else
          tcp_server_listen_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_listen_busy <= '0';
      else
        if tcp_server_listen_method = tcp_server_listen_method_S_0001 then
          tcp_server_listen_busy <= tcp_server_listen_req_flag;
        end if;
      end if;
    end if;
  end process;

  wait_for_established_req_flag <= wait_for_established_req_local;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_established_req_local <= '0';
      else
        if tcp_server_method = tcp_server_method_tcp_server_method_S_0027_body and tcp_server_method_delay = 0 then
          wait_for_established_req_local <= '1';
        else
          wait_for_established_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_established_busy <= '0';
      else
        if wait_for_established_method = wait_for_established_method_S_0001 then
          wait_for_established_busy <= wait_for_established_req_flag;
        end if;
      end if;
    end if;
  end process;

  wait_for_recv_req_flag <= wait_for_recv_req_local;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_recv_req_local <= '0';
      else
        if tcp_server_method = tcp_server_method_tcp_server_method_S_0030_body and tcp_server_method_delay = 0 then
          wait_for_recv_req_local <= '1';
        else
          wait_for_recv_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_recv_busy <= '0';
      else
        if wait_for_recv_method = wait_for_recv_method_S_0001 then
          wait_for_recv_busy <= wait_for_recv_req_flag;
        end if;
      end if;
    end if;
  end process;

  pull_recv_data_req_flag <= pull_recv_data_req_local;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pull_recv_data_req_local <= '0';
      else
        if tcp_server_method = tcp_server_method_tcp_server_method_S_0032_body and tcp_server_method_delay = 0 then
          pull_recv_data_req_local <= '1';
        else
          pull_recv_data_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pull_recv_data_busy <= '0';
      else
        if pull_recv_data_method = pull_recv_data_method_S_0001 then
          pull_recv_data_busy <= pull_recv_data_req_flag;
        end if;
      end if;
    end if;
  end process;

  push_send_data_req_flag <= push_send_data_req_local;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        push_send_data_req_local <= '0';
      else
        if tcp_server_method = tcp_server_method_tcp_server_method_S_0033_body and tcp_server_method_delay = 0 then
          push_send_data_req_local <= '1';
        else
          push_send_data_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        push_send_data_busy <= '0';
      else
        if push_send_data_method = push_send_data_method_S_0001 then
          push_send_data_busy <= push_send_data_req_flag;
        end if;
      end if;
    end if;
  end process;

  tcp_server_req_flag <= tcp_server_req_local;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_req_local <= '0';
      else
        if test_method = test_method_test_method_S_0004_body and test_method_delay = 0 then
          tcp_server_req_local <= '1';
        else
          tcp_server_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_busy <= '0';
      else
        if tcp_server_method = tcp_server_method_S_0001 then
          tcp_server_busy <= tcp_server_req_flag;
        end if;
      end if;
    end if;
  end process;

  test_req_flag <= tmp_0002;

  blink_led_req_flag <= tmp_0003;

  wait_cycles_call_flag_0010 <= tmp_0011;

  wait_cycles_call_flag_0008 <= tmp_0016;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        read_data_return <= (others => '0');
      else
        if read_data_method = read_data_method_S_0015 then
          read_data_return <= read_data_v_0107;
        end if;
      end if;
    end if;
  end process;

  wait_cycles_call_flag_0013 <= tmp_0022;

  write_data_call_flag_0002 <= tmp_0027;

  write_data_call_flag_0003 <= tmp_0032;

  write_data_call_flag_0004 <= tmp_0037;

  write_data_call_flag_0005 <= tmp_0042;

  write_data_call_flag_0006 <= tmp_0047;

  write_data_call_flag_0007 <= tmp_0052;

  write_data_call_flag_0008 <= tmp_0057;

  write_data_call_flag_0009 <= tmp_0062;

  write_data_call_flag_0010 <= tmp_0067;

  write_data_call_flag_0011 <= tmp_0072;

  write_data_call_flag_0012 <= tmp_0077;

  write_data_call_flag_0013 <= tmp_0082;

  write_data_call_flag_0014 <= tmp_0087;

  write_data_call_flag_0015 <= tmp_0092;

  write_data_call_flag_0016 <= tmp_0097;

  write_data_call_flag_0017 <= tmp_0102;

  write_data_call_flag_0018 <= tmp_0107;

  write_data_call_flag_0019 <= tmp_0112;

  read_data_call_flag_0016 <= tmp_0121;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_open_return <= (others => '0');
      else
        if tcp_server_open_method = tcp_server_open_method_S_0017 then
          tcp_server_open_return <= method_result_00149;
        end if;
      end if;
    end if;
  end process;

  read_data_call_flag_0007 <= tmp_0137;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_listen_return <= (others => '0');
      else
        if tcp_server_listen_method = tcp_server_listen_method_S_0008 then
          tcp_server_listen_return <= method_result_00156;
        end if;
      end if;
    end if;
  end process;

  read_data_call_flag_0006 <= tmp_0148;

  read_data_call_flag_0008 <= tmp_0160;

  read_data_call_flag_0013 <= tmp_0165;

  read_data_call_flag_0018 <= tmp_0170;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_recv_return <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0029 then
          wait_for_recv_return <= wait_for_recv_v_0166;
        end if;
      end if;
    end if;
  end process;

  read_data_call_flag_0023 <= tmp_0195;

  read_data_call_flag_0030 <= tmp_0200;

  write_data_call_flag_0035 <= tmp_0205;

  write_data_call_flag_0024 <= tmp_0230;

  write_data_call_flag_0031 <= tmp_0235;

  write_data_call_flag_0040 <= tmp_0241;

  write_data_call_flag_0045 <= tmp_0246;

  write_data_call_flag_0050 <= tmp_0251;

  write_data_call_flag_0053 <= tmp_0256;

  tcp_server_open_call_flag_0005 <= tmp_0292;

  tcp_server_open_call_flag_0013 <= tmp_0300;

  tcp_server_listen_call_flag_0016 <= tmp_0305;

  write_data_call_flag_0023 <= tmp_0312;

  tcp_server_listen_call_flag_0024 <= tmp_0317;

  wait_for_established_call_flag_0027 <= tmp_0322;

  wait_for_recv_call_flag_0030 <= tmp_0329;

  pull_recv_data_call_flag_0032 <= tmp_0334;

  push_send_data_call_flag_0033 <= tmp_0339;

  init_call_flag_0002 <= tmp_0352;

  network_configuration_call_flag_0003 <= tmp_0357;

  tcp_server_call_flag_0004 <= tmp_0362;


  inst_class_wiz830mj_0000 : wiz830mj_iface
  port map(
    clk => class_wiz830mj_0000_clk,
    reset => class_wiz830mj_0000_reset,
    address => class_wiz830mj_0000_address,
    wdata => class_wiz830mj_0000_wdata,
    rdata => class_wiz830mj_0000_rdata,
    cs => class_wiz830mj_0000_cs,
    oe => class_wiz830mj_0000_oe,
    we => class_wiz830mj_0000_we,
    interrupt => class_wiz830mj_0000_interrupt,
    module_reset => class_wiz830mj_0000_module_reset,
    bready0 => class_wiz830mj_0000_bready0,
    bready1 => class_wiz830mj_0000_bready1,
    bready2 => class_wiz830mj_0000_bready2,
    bready3 => class_wiz830mj_0000_bready3,
    ADDR => class_wiz830mj_0000_ADDR_exp,
    DATA => class_wiz830mj_0000_DATA_exp,
    nCS => class_wiz830mj_0000_nCS_exp,
    nRD => class_wiz830mj_0000_nRD_exp,
    nWR => class_wiz830mj_0000_nWR_exp,
    nINT => class_wiz830mj_0000_nINT_exp,
    nRESET => class_wiz830mj_0000_nRESET,
    BRDY => class_wiz830mj_0000_BRDY_exp
  );

  inst_class_buffer_0088 : dualportram
  generic map(
    WIDTH => 8,
    DEPTH => 13,
    WORDS => 8192
  )
  port map(
    clk => class_buffer_0088_clk,
    reset => class_buffer_0088_reset,
    length => class_buffer_0088_length,
    address => class_buffer_0088_address,
    din => class_buffer_0088_din,
    dout => class_buffer_0088_dout,
    we => class_buffer_0088_we,
    oe => class_buffer_0088_oe,
    address_b => class_buffer_0088_address_b,
    din_b => class_buffer_0088_din_b,
    dout_b => class_buffer_0088_dout_b,
    we_b => class_buffer_0088_we_b,
    oe_b => class_buffer_0088_oe_b
  );


end RTL;
