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
    test_busy : out std_logic;
    test_req : in std_logic;
    blink_led_busy : out std_logic;
    blink_led_req : in std_logic
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
  component singleportram
    generic (
      WIDTH : integer := 8;
      DEPTH : integer := 10;
      WORDS : integer := 1024
    );
    port (
      clk : in std_logic;
      reset : in std_logic;
      length : out signed(31 downto 0);
      address_b : in signed(31 downto 0);
      din_b : in signed(WIDTH-1 downto 0);
      dout_b : out signed(WIDTH-1 downto 0);
      we_b : in std_logic;
      oe_b : in std_logic
    );
  end component singleportram;

  signal clk_sig : std_logic;
  signal reset_sig : std_logic;
  signal class_wiz830mj_0000_ADDR_exp_sig : std_logic_vector(10-1 downto 0);
  signal class_wiz830mj_0000_nCS_exp_sig : std_logic;
  signal class_wiz830mj_0000_nRD_exp_sig : std_logic;
  signal class_wiz830mj_0000_nWR_exp_sig : std_logic;
  signal class_wiz830mj_0000_nINT_exp_sig : std_logic;
  signal class_wiz830mj_0000_nRESET_exp_sig : std_logic;
  signal class_wiz830mj_0000_BRDY_exp_sig : std_logic_vector(4-1 downto 0);
  signal led_in_sig : signed(32-1 downto 0);
  signal led_we_sig : std_logic;
  signal led_out_sig : signed(32-1 downto 0);
  signal test_busy_sig : std_logic := '1';
  signal test_req_sig : std_logic;
  signal blink_led_busy_sig : std_logic := '1';
  signal blink_led_req_sig : std_logic;

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
  signal class_wiz830mj_0000_nCS : std_logic;
  signal class_wiz830mj_0000_nRD : std_logic;
  signal class_wiz830mj_0000_nWR : std_logic;
  signal class_wiz830mj_0000_nINT : std_logic;
  signal class_wiz830mj_0000_nRESET : std_logic;
  signal class_wiz830mj_0000_BRDY : std_logic_vector(4-1 downto 0);
  signal class_led_0002 : signed(32-1 downto 0) := (others => '0');
  signal class_led_0002_mux : signed(32-1 downto 0);
  signal tmp_0001 : signed(32-1 downto 0);
  signal class_Sn_MR0_0003 : signed(32-1 downto 0) := X"00008200";
  signal class_Sn_MR1_0004 : signed(32-1 downto 0) := X"00008201";
  signal class_Sn_CR0_0005 : signed(32-1 downto 0) := X"00008202";
  signal class_Sn_CR1_0006 : signed(32-1 downto 0) := X"00008203";
  signal class_Sn_IMR0_0007 : signed(32-1 downto 0) := X"00008204";
  signal class_Sn_IMR1_0008 : signed(32-1 downto 0) := X"00008205";
  signal class_Sn_IR0_0009 : signed(32-1 downto 0) := X"00008206";
  signal class_Sn_IR1_0010 : signed(32-1 downto 0) := X"00008207";
  signal class_Sn_SSR0_0011 : signed(32-1 downto 0) := X"00008208";
  signal class_Sn_SSR1_0012 : signed(32-1 downto 0) := X"00008209";
  signal class_Sn_PORTR0_0013 : signed(32-1 downto 0) := X"0000820a";
  signal class_Sn_PORTR1_0014 : signed(32-1 downto 0) := X"0000820b";
  signal class_Sn_DHAR0_0015 : signed(32-1 downto 0) := X"0000820c";
  signal class_Sn_DHAR1_0016 : signed(32-1 downto 0) := X"0000820d";
  signal class_Sn_DHAR2_0017 : signed(32-1 downto 0) := X"0000820e";
  signal class_Sn_DHAR3_0018 : signed(32-1 downto 0) := X"0000820f";
  signal class_Sn_DHAR4_0019 : signed(32-1 downto 0) := X"00008210";
  signal class_Sn_DHAR5_0020 : signed(32-1 downto 0) := X"00008211";
  signal class_Sn_DPORTR0_0021 : signed(32-1 downto 0) := X"00008212";
  signal class_Sn_DPORTR1_0022 : signed(32-1 downto 0) := X"00008213";
  signal class_Sn_DIPR0_0023 : signed(32-1 downto 0) := X"00008214";
  signal class_Sn_DIPR1_0024 : signed(32-1 downto 0) := X"00008215";
  signal class_Sn_DIPR2_0025 : signed(32-1 downto 0) := X"00008216";
  signal class_Sn_DIPR3_0026 : signed(32-1 downto 0) := X"00008217";
  signal class_Sn_MSSR0_0027 : signed(32-1 downto 0) := X"00008218";
  signal class_Sn_MSSR1_0028 : signed(32-1 downto 0) := X"00008219";
  signal class_Sn_KPALVTR_0029 : signed(32-1 downto 0) := X"0000821a";
  signal class_Sn_PROTOR_0030 : signed(32-1 downto 0) := X"0000821b";
  signal class_Sn_TOSR0_0031 : signed(32-1 downto 0) := X"0000821c";
  signal class_Sn_TOSR1_0032 : signed(32-1 downto 0) := X"0000821d";
  signal class_Sn_TTLR0_0033 : signed(32-1 downto 0) := X"0000821e";
  signal class_Sn_TTLR1_0034 : signed(32-1 downto 0) := X"0000821f";
  signal class_Sn_TX_WRSR0_0035 : signed(32-1 downto 0) := X"00008220";
  signal class_Sn_TX_WRSR1_0036 : signed(32-1 downto 0) := X"00008221";
  signal class_Sn_TX_WRSR2_0037 : signed(32-1 downto 0) := X"00008222";
  signal class_Sn_TX_WRSR3_0038 : signed(32-1 downto 0) := X"00008223";
  signal class_Sn_TX_FSR0_0039 : signed(32-1 downto 0) := X"00008224";
  signal class_Sn_TX_FSR1_0040 : signed(32-1 downto 0) := X"00008225";
  signal class_Sn_TX_FSR2_0041 : signed(32-1 downto 0) := X"00008226";
  signal class_Sn_TX_FSR3_0042 : signed(32-1 downto 0) := X"00008227";
  signal class_Sn_RX_RSR0_0043 : signed(32-1 downto 0) := X"00008228";
  signal class_Sn_RX_RSR1_0044 : signed(32-1 downto 0) := X"00008229";
  signal class_Sn_RX_RSR2_0045 : signed(32-1 downto 0) := X"0000822a";
  signal class_Sn_RX_RSR3_0046 : signed(32-1 downto 0) := X"0000822b";
  signal class_Sn_FRAGR0_0047 : signed(32-1 downto 0) := X"0000822c";
  signal class_Sn_FRAGR1_0048 : signed(32-1 downto 0) := X"0000822d";
  signal class_Sn_TX_FIFOR0_0049 : signed(32-1 downto 0) := X"0000822e";
  signal class_Sn_TX_FIFOR1_0050 : signed(32-1 downto 0) := X"0000822f";
  signal class_Sn_RX_FIFOR0_0051 : signed(32-1 downto 0) := X"00008230";
  signal class_Sn_RX_FIFOR1_0052 : signed(32-1 downto 0) := X"00008231";
  signal class_Sn_MR_CLOSE_0053 : signed(8-1 downto 0) := X"00";
  signal class_Sn_MR_TCP_0054 : signed(8-1 downto 0) := X"01";
  signal class_Sn_MR_UDP_0055 : signed(8-1 downto 0) := X"02";
  signal class_Sn_MR_IPRAW_0056 : signed(8-1 downto 0) := X"03";
  signal class_Sn_MR_MACRAW_0057 : signed(8-1 downto 0) := X"04";
  signal class_Sn_MR_PPPoE_0058 : signed(8-1 downto 0) := X"05";
  signal class_Sn_CR_OPEN_0059 : signed(8-1 downto 0) := X"01";
  signal class_Sn_CR_LISTEN_0060 : signed(8-1 downto 0) := X"02";
  signal class_Sn_CR_CONNECT_0061 : signed(8-1 downto 0) := X"04";
  signal class_Sn_CR_DISCON_0062 : signed(8-1 downto 0) := X"08";
  signal class_Sn_CR_CLOSE_0063 : signed(8-1 downto 0) := X"10";
  signal class_Sn_CR_SEND_0064 : signed(8-1 downto 0) := X"20";
  signal class_Sn_CR_SEND_MAC_0065 : signed(8-1 downto 0) := X"21";
  signal class_Sn_CR_SEND_KEEP_0066 : signed(8-1 downto 0) := X"22";
  signal class_Sn_CR_RECV_0067 : signed(8-1 downto 0) := X"40";
  signal class_Sn_CR_PCON_0068 : signed(8-1 downto 0) := X"23";
  signal class_Sn_CR_PDISCON_0069 : signed(8-1 downto 0) := X"24";
  signal class_Sn_CR_PCR_0070 : signed(8-1 downto 0) := X"25";
  signal class_Sn_CR_PCN_0071 : signed(8-1 downto 0) := X"26";
  signal class_Sn_CR_PCJ_0072 : signed(8-1 downto 0) := X"27";
  signal class_Sn_SOCK_CLOSED_0073 : signed(8-1 downto 0) := X"00";
  signal class_Sn_SOCK_INIT_0074 : signed(8-1 downto 0) := X"13";
  signal class_Sn_SOCK_LISTEN_0075 : signed(8-1 downto 0) := X"14";
  signal class_Sn_SOCK_ESTABLISHED_0076 : signed(8-1 downto 0) := X"17";
  signal class_Sn_SOCK_CLOSE_WAIT_0077 : signed(8-1 downto 0) := X"1c";
  signal class_Sn_SOCK_UDP_0078 : signed(8-1 downto 0) := X"22";
  signal class_Sn_SOCK_IPRAW_0079 : signed(8-1 downto 0) := X"32";
  signal class_Sn_SOCK_MACRAW_0080 : signed(8-1 downto 0) := X"42";
  signal class_Sn_SOCK_PPPoE_0081 : signed(8-1 downto 0) := X"5f";
  signal class_Sn_SOCK_SYSSENT_0082 : signed(8-1 downto 0) := X"15";
  signal class_Sn_SOCK_SYSRECV_0083 : signed(8-1 downto 0) := X"16";
  signal class_Sn_SOCK_FIN_WAIT_0084 : signed(8-1 downto 0) := X"18";
  signal class_Sn_SOCK_TIME_WAIT_0085 : signed(8-1 downto 0) := X"1b";
  signal class_Sn_SOCK_LAST_ACK_0086 : signed(8-1 downto 0) := X"1d";
  signal class_Sn_SOCK_ARP_0087 : signed(8-1 downto 0) := X"01";
  signal class_buffer_0088_clk : std_logic;
  signal class_buffer_0088_reset : std_logic;
  signal class_buffer_0088_length : signed(32-1 downto 0);
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
  signal cast_expr_00140 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00141 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00142 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00144 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00145 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00147 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00148 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00150 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00151 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00152 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00153 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00154 : signed(32-1 downto 0) := (others => '0');
  signal tcp_server_listen_port_0155 : signed(32-1 downto 0) := (others => '0');
  signal tcp_server_listen_port_local : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00157 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00158 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00159 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00160 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00161 : signed(32-1 downto 0) := (others => '0');
  signal wait_for_established_port_0162 : signed(32-1 downto 0) := (others => '0');
  signal wait_for_established_port_local : signed(32-1 downto 0) := (others => '0');
  signal wait_for_established_v_0163 : signed(8-1 downto 0) := X"00";
  signal method_result_00164 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00165 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00166 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00167 : std_logic := '0';
  signal wait_for_recv_port_0168 : signed(32-1 downto 0) := (others => '0');
  signal wait_for_recv_port_local : signed(32-1 downto 0) := (others => '0');
  signal wait_for_recv_v_0169 : signed(32-1 downto 0) := X"00000000";
  signal wait_for_recv_v0_0170 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00171 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00172 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00173 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00174 : signed(32-1 downto 0) := (others => '0');
  signal wait_for_recv_v1_0175 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00176 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00177 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00178 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00179 : signed(32-1 downto 0) := (others => '0');
  signal wait_for_recv_v2_0180 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00181 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00182 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00183 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00184 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00185 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00186 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00187 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00188 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00189 : std_logic := '0';
  signal method_result_00190 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00191 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00192 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00193 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00194 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00195 : std_logic := '0';
  signal cast_expr_00196 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00197 : std_logic := '0';
  signal binary_expr_00198 : std_logic := '0';
  signal binary_expr_00200 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00201 : signed(32-1 downto 0) := (others => '0');
  signal pull_recv_data_port_0202 : signed(32-1 downto 0) := (others => '0');
  signal pull_recv_data_port_local : signed(32-1 downto 0) := (others => '0');
  signal pull_recv_data_v0_0203 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00204 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00205 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00206 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00207 : signed(32-1 downto 0) := (others => '0');
  signal pull_recv_data_v1_0208 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00209 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00210 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00211 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00212 : signed(32-1 downto 0) := (others => '0');
  signal pull_recv_data_actual_len_0213 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00214 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00215 : signed(32-1 downto 0) := (others => '0');
  signal pull_recv_data_read_len_0216 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00217 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00218 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00219 : std_logic := '0';
  signal binary_expr_00237 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00238 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00220 : signed(32-1 downto 0) := (others => '0');
  signal pull_recv_data_i_0221 : signed(32-1 downto 0) := X"00000000";
  signal binary_expr_00222 : std_logic := '0';
  signal unary_expr_00223 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00224 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00225 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00226 : signed(8-1 downto 0) := (others => '0');
  signal method_result_00227 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00228 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00229 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00230 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00231 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00232 : signed(8-1 downto 0) := (others => '0');
  signal method_result_00233 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00234 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00235 : signed(32-1 downto 0) := (others => '0');
  signal push_send_data_port_0239 : signed(32-1 downto 0) := (others => '0');
  signal push_send_data_port_local : signed(32-1 downto 0) := (others => '0');
  signal push_send_data_len_0240 : signed(32-1 downto 0) := (others => '0');
  signal push_send_data_len_local : signed(32-1 downto 0) := (others => '0');
  signal push_send_data_write_len_0241 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00242 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00243 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00244 : std_logic := '0';
  signal binary_expr_00263 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00264 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00266 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00267 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00268 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00269 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00271 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00272 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00273 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00274 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00276 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00277 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00278 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00279 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00281 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00282 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00245 : signed(32-1 downto 0) := (others => '0');
  signal push_send_data_i_0246 : signed(32-1 downto 0) := X"00000000";
  signal binary_expr_00247 : std_logic := '0';
  signal unary_expr_00248 : signed(32-1 downto 0) := (others => '0');
  signal push_send_data_v_0249 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00250 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00251 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00252 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00254 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00255 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00256 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00257 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00258 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00260 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00261 : signed(32-1 downto 0) := (others => '0');
  signal tcp_server_port_0283 : signed(32-1 downto 0) := (others => '0');
  signal tcp_server_port_local : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00285 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00286 : signed(32-1 downto 0) := (others => '0');
  signal tcp_server_v_0287 : signed(8-1 downto 0) := (others => '0');
  signal method_result_00288 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00289 : std_logic := '0';
  signal cast_expr_00294 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00295 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00296 : std_logic := '0';
  signal method_result_00302 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00303 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00304 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00305 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00291 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00292 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00293 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00298 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00299 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00300 : signed(8-1 downto 0) := (others => '0');
  signal tcp_server_len_0306 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00307 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00308 : std_logic := '0';
  signal method_result_00309 : signed(32-1 downto 0) := (others => '0');
  signal wait_cycles_busy : std_logic := '0';
  signal wait_cycles_req_flag : std_logic;
  signal wait_cycles_req_local : std_logic := '0';
  signal write_data_busy : std_logic := '0';
  signal write_data_req_flag : std_logic;
  signal write_data_req_local : std_logic := '0';
  signal read_data_return : signed(8-1 downto 0) := (others => '0');
  signal read_data_busy : std_logic := '0';
  signal read_data_req_flag : std_logic;
  signal read_data_req_local : std_logic := '0';
  signal init_busy : std_logic := '0';
  signal init_req_flag : std_logic;
  signal init_req_local : std_logic := '0';
  signal network_configuration_busy : std_logic := '0';
  signal network_configuration_req_flag : std_logic;
  signal network_configuration_req_local : std_logic := '0';
  signal tcp_server_open_return : signed(8-1 downto 0) := (others => '0');
  signal tcp_server_open_busy : std_logic := '0';
  signal tcp_server_open_req_flag : std_logic;
  signal tcp_server_open_req_local : std_logic := '0';
  signal tcp_server_listen_return : signed(8-1 downto 0) := (others => '0');
  signal tcp_server_listen_busy : std_logic := '0';
  signal tcp_server_listen_req_flag : std_logic;
  signal tcp_server_listen_req_local : std_logic := '0';
  signal wait_for_established_busy : std_logic := '0';
  signal wait_for_established_req_flag : std_logic;
  signal wait_for_established_req_local : std_logic := '0';
  signal wait_for_recv_return : signed(32-1 downto 0) := (others => '0');
  signal wait_for_recv_busy : std_logic := '0';
  signal wait_for_recv_req_flag : std_logic;
  signal wait_for_recv_req_local : std_logic := '0';
  signal pull_recv_data_return : signed(32-1 downto 0) := (others => '0');
  signal pull_recv_data_busy : std_logic := '0';
  signal pull_recv_data_req_flag : std_logic;
  signal pull_recv_data_req_local : std_logic := '0';
  signal push_send_data_busy : std_logic := '0';
  signal push_send_data_req_flag : std_logic;
  signal push_send_data_req_local : std_logic := '0';
  signal tcp_server_busy : std_logic := '0';
  signal tcp_server_req_flag : std_logic;
  signal tcp_server_req_local : std_logic := '0';
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
    wait_cycles_method_S_0008,
    wait_cycles_method_S_0009,
    wait_cycles_method_S_0010  
  );
  signal wait_cycles_method : Type_wait_cycles_method := wait_cycles_method_IDLE;
  signal wait_cycles_method_delay : signed(32-1 downto 0) := (others => '0');
  signal wait_cycles_req_flag_d : std_logic := '0';
  signal wait_cycles_req_flag_edge : std_logic;
  signal tmp_0004 : std_logic;
  signal tmp_0005 : std_logic;
  signal tmp_0006 : std_logic;
  signal tmp_0007 : std_logic;
  signal tmp_0008 : std_logic;
  signal tmp_0009 : std_logic;
  signal tmp_0010 : std_logic;
  signal tmp_0011 : std_logic;
  signal tmp_0012 : std_logic;
  signal tmp_0013 : std_logic;
  signal tmp_0014 : std_logic;
  signal tmp_0015 : signed(32-1 downto 0);
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
    write_data_method_S_0010_body,
    write_data_method_S_0010_wait  
  );
  signal write_data_method : Type_write_data_method := write_data_method_IDLE;
  signal write_data_method_delay : signed(32-1 downto 0) := (others => '0');
  signal write_data_req_flag_d : std_logic := '0';
  signal write_data_req_flag_edge : std_logic;
  signal tmp_0016 : std_logic;
  signal tmp_0017 : std_logic;
  signal tmp_0018 : std_logic;
  signal tmp_0019 : std_logic;
  signal wait_cycles_call_flag_0010 : std_logic;
  signal tmp_0020 : std_logic;
  signal tmp_0021 : std_logic;
  signal tmp_0022 : std_logic;
  signal tmp_0023 : std_logic;
  signal tmp_0024 : std_logic;
  signal tmp_0025 : std_logic;
  signal tmp_0026 : std_logic;
  signal tmp_0027 : std_logic;
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
    read_data_method_S_0008_body,
    read_data_method_S_0008_wait  
  );
  signal read_data_method : Type_read_data_method := read_data_method_IDLE;
  signal read_data_method_delay : signed(32-1 downto 0) := (others => '0');
  signal read_data_req_flag_d : std_logic := '0';
  signal read_data_req_flag_edge : std_logic;
  signal tmp_0028 : std_logic;
  signal tmp_0029 : std_logic;
  signal tmp_0030 : std_logic;
  signal tmp_0031 : std_logic;
  signal wait_cycles_call_flag_0008 : std_logic;
  signal tmp_0032 : std_logic;
  signal tmp_0033 : std_logic;
  signal tmp_0034 : std_logic;
  signal tmp_0035 : std_logic;
  signal tmp_0036 : std_logic;
  signal tmp_0037 : std_logic;
  signal tmp_0038 : std_logic;
  signal tmp_0039 : std_logic;
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
    init_method_S_0010_body,
    init_method_S_0010_wait,
    init_method_S_0013_body,
    init_method_S_0013_wait  
  );
  signal init_method : Type_init_method := init_method_IDLE;
  signal init_method_delay : signed(32-1 downto 0) := (others => '0');
  signal init_req_flag_d : std_logic := '0';
  signal init_req_flag_edge : std_logic;
  signal tmp_0040 : std_logic;
  signal tmp_0041 : std_logic;
  signal tmp_0042 : std_logic;
  signal tmp_0043 : std_logic;
  signal wait_cycles_call_flag_0013 : std_logic;
  signal tmp_0044 : std_logic;
  signal tmp_0045 : std_logic;
  signal tmp_0046 : std_logic;
  signal tmp_0047 : std_logic;
  signal tmp_0048 : std_logic;
  signal tmp_0049 : std_logic;
  signal tmp_0050 : std_logic;
  signal tmp_0051 : std_logic;
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
    network_configuration_method_S_0002_body,
    network_configuration_method_S_0002_wait,
    network_configuration_method_S_0003_body,
    network_configuration_method_S_0003_wait,
    network_configuration_method_S_0004_body,
    network_configuration_method_S_0004_wait,
    network_configuration_method_S_0005_body,
    network_configuration_method_S_0005_wait,
    network_configuration_method_S_0006_body,
    network_configuration_method_S_0006_wait,
    network_configuration_method_S_0007_body,
    network_configuration_method_S_0007_wait,
    network_configuration_method_S_0008_body,
    network_configuration_method_S_0008_wait,
    network_configuration_method_S_0009_body,
    network_configuration_method_S_0009_wait,
    network_configuration_method_S_0010_body,
    network_configuration_method_S_0010_wait,
    network_configuration_method_S_0011_body,
    network_configuration_method_S_0011_wait,
    network_configuration_method_S_0012_body,
    network_configuration_method_S_0012_wait,
    network_configuration_method_S_0013_body,
    network_configuration_method_S_0013_wait,
    network_configuration_method_S_0014_body,
    network_configuration_method_S_0014_wait,
    network_configuration_method_S_0015_body,
    network_configuration_method_S_0015_wait,
    network_configuration_method_S_0016_body,
    network_configuration_method_S_0016_wait,
    network_configuration_method_S_0017_body,
    network_configuration_method_S_0017_wait,
    network_configuration_method_S_0018_body,
    network_configuration_method_S_0018_wait,
    network_configuration_method_S_0019_body,
    network_configuration_method_S_0019_wait  
  );
  signal network_configuration_method : Type_network_configuration_method := network_configuration_method_IDLE;
  signal network_configuration_method_delay : signed(32-1 downto 0) := (others => '0');
  signal network_configuration_req_flag_d : std_logic := '0';
  signal network_configuration_req_flag_edge : std_logic;
  signal tmp_0052 : std_logic;
  signal tmp_0053 : std_logic;
  signal tmp_0054 : std_logic;
  signal tmp_0055 : std_logic;
  signal write_data_call_flag_0002 : std_logic;
  signal tmp_0056 : std_logic;
  signal tmp_0057 : std_logic;
  signal tmp_0058 : std_logic;
  signal tmp_0059 : std_logic;
  signal write_data_call_flag_0003 : std_logic;
  signal tmp_0060 : std_logic;
  signal tmp_0061 : std_logic;
  signal tmp_0062 : std_logic;
  signal tmp_0063 : std_logic;
  signal write_data_call_flag_0004 : std_logic;
  signal tmp_0064 : std_logic;
  signal tmp_0065 : std_logic;
  signal tmp_0066 : std_logic;
  signal tmp_0067 : std_logic;
  signal write_data_call_flag_0005 : std_logic;
  signal tmp_0068 : std_logic;
  signal tmp_0069 : std_logic;
  signal tmp_0070 : std_logic;
  signal tmp_0071 : std_logic;
  signal write_data_call_flag_0006 : std_logic;
  signal tmp_0072 : std_logic;
  signal tmp_0073 : std_logic;
  signal tmp_0074 : std_logic;
  signal tmp_0075 : std_logic;
  signal write_data_call_flag_0007 : std_logic;
  signal tmp_0076 : std_logic;
  signal tmp_0077 : std_logic;
  signal tmp_0078 : std_logic;
  signal tmp_0079 : std_logic;
  signal write_data_call_flag_0008 : std_logic;
  signal tmp_0080 : std_logic;
  signal tmp_0081 : std_logic;
  signal tmp_0082 : std_logic;
  signal tmp_0083 : std_logic;
  signal write_data_call_flag_0009 : std_logic;
  signal tmp_0084 : std_logic;
  signal tmp_0085 : std_logic;
  signal tmp_0086 : std_logic;
  signal tmp_0087 : std_logic;
  signal write_data_call_flag_0010 : std_logic;
  signal tmp_0088 : std_logic;
  signal tmp_0089 : std_logic;
  signal tmp_0090 : std_logic;
  signal tmp_0091 : std_logic;
  signal write_data_call_flag_0011 : std_logic;
  signal tmp_0092 : std_logic;
  signal tmp_0093 : std_logic;
  signal tmp_0094 : std_logic;
  signal tmp_0095 : std_logic;
  signal write_data_call_flag_0012 : std_logic;
  signal tmp_0096 : std_logic;
  signal tmp_0097 : std_logic;
  signal tmp_0098 : std_logic;
  signal tmp_0099 : std_logic;
  signal write_data_call_flag_0013 : std_logic;
  signal tmp_0100 : std_logic;
  signal tmp_0101 : std_logic;
  signal tmp_0102 : std_logic;
  signal tmp_0103 : std_logic;
  signal write_data_call_flag_0014 : std_logic;
  signal tmp_0104 : std_logic;
  signal tmp_0105 : std_logic;
  signal tmp_0106 : std_logic;
  signal tmp_0107 : std_logic;
  signal write_data_call_flag_0015 : std_logic;
  signal tmp_0108 : std_logic;
  signal tmp_0109 : std_logic;
  signal tmp_0110 : std_logic;
  signal tmp_0111 : std_logic;
  signal write_data_call_flag_0016 : std_logic;
  signal tmp_0112 : std_logic;
  signal tmp_0113 : std_logic;
  signal tmp_0114 : std_logic;
  signal tmp_0115 : std_logic;
  signal write_data_call_flag_0017 : std_logic;
  signal tmp_0116 : std_logic;
  signal tmp_0117 : std_logic;
  signal tmp_0118 : std_logic;
  signal tmp_0119 : std_logic;
  signal write_data_call_flag_0018 : std_logic;
  signal tmp_0120 : std_logic;
  signal tmp_0121 : std_logic;
  signal tmp_0122 : std_logic;
  signal tmp_0123 : std_logic;
  signal write_data_call_flag_0019 : std_logic;
  signal tmp_0124 : std_logic;
  signal tmp_0125 : std_logic;
  signal tmp_0126 : std_logic;
  signal tmp_0127 : std_logic;
  signal tmp_0128 : std_logic;
  signal tmp_0129 : std_logic;
  signal tmp_0130 : std_logic;
  signal tmp_0131 : std_logic;
  type Type_tcp_server_open_method is (
    tcp_server_open_method_IDLE,
    tcp_server_open_method_S_0000,
    tcp_server_open_method_S_0001,
    tcp_server_open_method_S_0002,
    tcp_server_open_method_S_0007,
    tcp_server_open_method_S_0008,
    tcp_server_open_method_S_0010,
    tcp_server_open_method_S_0011,
    tcp_server_open_method_S_0013,
    tcp_server_open_method_S_0014,
    tcp_server_open_method_S_0016,
    tcp_server_open_method_S_0017,
    tcp_server_open_method_S_0019,
    tcp_server_open_method_S_0020,
    tcp_server_open_method_S_0021,
    tcp_server_open_method_S_0007_body,
    tcp_server_open_method_S_0007_wait,
    tcp_server_open_method_S_0010_body,
    tcp_server_open_method_S_0010_wait,
    tcp_server_open_method_S_0013_body,
    tcp_server_open_method_S_0013_wait,
    tcp_server_open_method_S_0016_body,
    tcp_server_open_method_S_0016_wait,
    tcp_server_open_method_S_0019_body,
    tcp_server_open_method_S_0019_wait  
  );
  signal tcp_server_open_method : Type_tcp_server_open_method := tcp_server_open_method_IDLE;
  signal tcp_server_open_method_delay : signed(32-1 downto 0) := (others => '0');
  signal tcp_server_open_req_flag_d : std_logic := '0';
  signal tcp_server_open_req_flag_edge : std_logic;
  signal tmp_0132 : std_logic;
  signal tmp_0133 : std_logic;
  signal tmp_0134 : std_logic;
  signal tmp_0135 : std_logic;
  signal read_data_call_flag_0019 : std_logic;
  signal tmp_0136 : std_logic;
  signal tmp_0137 : std_logic;
  signal tmp_0138 : std_logic;
  signal tmp_0139 : std_logic;
  signal tmp_0140 : std_logic;
  signal tmp_0141 : std_logic;
  signal tmp_0142 : std_logic;
  signal tmp_0143 : std_logic;
  signal tmp_0144 : signed(32-1 downto 0);
  signal tmp_0145 : signed(32-1 downto 0);
  signal tmp_0146 : signed(32-1 downto 0);
  signal tmp_0147 : signed(32-1 downto 0);
  signal tmp_0148 : signed(8-1 downto 0);
  signal tmp_0149 : signed(32-1 downto 0);
  signal tmp_0150 : signed(32-1 downto 0);
  signal tmp_0151 : signed(32-1 downto 0);
  signal tmp_0152 : signed(32-1 downto 0);
  signal tmp_0153 : signed(32-1 downto 0);
  signal tmp_0154 : signed(32-1 downto 0);
  signal tmp_0155 : signed(32-1 downto 0);
  signal tmp_0156 : signed(32-1 downto 0);
  type Type_tcp_server_listen_method is (
    tcp_server_listen_method_IDLE,
    tcp_server_listen_method_S_0000,
    tcp_server_listen_method_S_0001,
    tcp_server_listen_method_S_0002,
    tcp_server_listen_method_S_0004,
    tcp_server_listen_method_S_0005,
    tcp_server_listen_method_S_0007,
    tcp_server_listen_method_S_0008,
    tcp_server_listen_method_S_0009,
    tcp_server_listen_method_S_0004_body,
    tcp_server_listen_method_S_0004_wait,
    tcp_server_listen_method_S_0007_body,
    tcp_server_listen_method_S_0007_wait  
  );
  signal tcp_server_listen_method : Type_tcp_server_listen_method := tcp_server_listen_method_IDLE;
  signal tcp_server_listen_method_delay : signed(32-1 downto 0) := (others => '0');
  signal tcp_server_listen_req_flag_d : std_logic := '0';
  signal tcp_server_listen_req_flag_edge : std_logic;
  signal tmp_0157 : std_logic;
  signal tmp_0158 : std_logic;
  signal tmp_0159 : std_logic;
  signal tmp_0160 : std_logic;
  signal read_data_call_flag_0007 : std_logic;
  signal tmp_0161 : std_logic;
  signal tmp_0162 : std_logic;
  signal tmp_0163 : std_logic;
  signal tmp_0164 : std_logic;
  signal tmp_0165 : std_logic;
  signal tmp_0166 : std_logic;
  signal tmp_0167 : std_logic;
  signal tmp_0168 : std_logic;
  signal tmp_0169 : signed(32-1 downto 0);
  signal tmp_0170 : signed(32-1 downto 0);
  signal tmp_0171 : signed(32-1 downto 0);
  signal tmp_0172 : signed(32-1 downto 0);
  type Type_wait_for_established_method is (
    wait_for_established_method_IDLE,
    wait_for_established_method_S_0000,
    wait_for_established_method_S_0001,
    wait_for_established_method_S_0002,
    wait_for_established_method_S_0003,
    wait_for_established_method_S_0004,
    wait_for_established_method_S_0005,
    wait_for_established_method_S_0007,
    wait_for_established_method_S_0008,
    wait_for_established_method_S_0010,
    wait_for_established_method_S_0011,
    wait_for_established_method_S_0012,
    wait_for_established_method_S_0013,
    wait_for_established_method_S_0014,
    wait_for_established_method_S_0015,
    wait_for_established_method_S_0007_body,
    wait_for_established_method_S_0007_wait  
  );
  signal wait_for_established_method : Type_wait_for_established_method := wait_for_established_method_IDLE;
  signal wait_for_established_method_delay : signed(32-1 downto 0) := (others => '0');
  signal wait_for_established_req_flag_d : std_logic := '0';
  signal wait_for_established_req_flag_edge : std_logic;
  signal tmp_0173 : std_logic;
  signal tmp_0174 : std_logic;
  signal tmp_0175 : std_logic;
  signal tmp_0176 : std_logic;
  signal tmp_0177 : std_logic;
  signal tmp_0178 : std_logic;
  signal tmp_0179 : std_logic;
  signal tmp_0180 : std_logic;
  signal tmp_0181 : std_logic;
  signal tmp_0182 : std_logic;
  signal tmp_0183 : std_logic;
  signal tmp_0184 : std_logic;
  signal tmp_0185 : signed(32-1 downto 0);
  signal tmp_0186 : signed(32-1 downto 0);
  signal tmp_0187 : std_logic;
  type Type_wait_for_recv_method is (
    wait_for_recv_method_IDLE,
    wait_for_recv_method_S_0000,
    wait_for_recv_method_S_0001,
    wait_for_recv_method_S_0002,
    wait_for_recv_method_S_0003,
    wait_for_recv_method_S_0004,
    wait_for_recv_method_S_0005,
    wait_for_recv_method_S_0008,
    wait_for_recv_method_S_0009,
    wait_for_recv_method_S_0013,
    wait_for_recv_method_S_0014,
    wait_for_recv_method_S_0018,
    wait_for_recv_method_S_0019,
    wait_for_recv_method_S_0027,
    wait_for_recv_method_S_0028,
    wait_for_recv_method_S_0029,
    wait_for_recv_method_S_0030,
    wait_for_recv_method_S_0031,
    wait_for_recv_method_S_0033,
    wait_for_recv_method_S_0034,
    wait_for_recv_method_S_0041,
    wait_for_recv_method_S_0042,
    wait_for_recv_method_S_0043,
    wait_for_recv_method_S_0045,
    wait_for_recv_method_S_0046,
    wait_for_recv_method_S_0047,
    wait_for_recv_method_S_0048,
    wait_for_recv_method_S_0049,
    wait_for_recv_method_S_0008_body,
    wait_for_recv_method_S_0008_wait,
    wait_for_recv_method_S_0013_body,
    wait_for_recv_method_S_0013_wait,
    wait_for_recv_method_S_0018_body,
    wait_for_recv_method_S_0018_wait,
    wait_for_recv_method_S_0033_body,
    wait_for_recv_method_S_0033_wait,
    wait_for_recv_method_S_0045_body,
    wait_for_recv_method_S_0045_wait  
  );
  signal wait_for_recv_method : Type_wait_for_recv_method := wait_for_recv_method_IDLE;
  signal wait_for_recv_method_delay : signed(32-1 downto 0) := (others => '0');
  signal wait_for_recv_req_flag_d : std_logic := '0';
  signal wait_for_recv_req_flag_edge : std_logic;
  signal tmp_0188 : std_logic;
  signal tmp_0189 : std_logic;
  signal tmp_0190 : std_logic;
  signal tmp_0191 : std_logic;
  signal tmp_0192 : std_logic;
  signal tmp_0193 : std_logic;
  signal read_data_call_flag_0008 : std_logic;
  signal tmp_0194 : std_logic;
  signal tmp_0195 : std_logic;
  signal tmp_0196 : std_logic;
  signal tmp_0197 : std_logic;
  signal read_data_call_flag_0013 : std_logic;
  signal tmp_0198 : std_logic;
  signal tmp_0199 : std_logic;
  signal tmp_0200 : std_logic;
  signal tmp_0201 : std_logic;
  signal read_data_call_flag_0018 : std_logic;
  signal tmp_0202 : std_logic;
  signal tmp_0203 : std_logic;
  signal tmp_0204 : std_logic;
  signal tmp_0205 : std_logic;
  signal tmp_0206 : std_logic;
  signal tmp_0207 : std_logic;
  signal read_data_call_flag_0033 : std_logic;
  signal tmp_0208 : std_logic;
  signal tmp_0209 : std_logic;
  signal tmp_0210 : std_logic;
  signal tmp_0211 : std_logic;
  signal tmp_0212 : std_logic;
  signal tmp_0213 : std_logic;
  signal write_data_call_flag_0045 : std_logic;
  signal tmp_0214 : std_logic;
  signal tmp_0215 : std_logic;
  signal tmp_0216 : std_logic;
  signal tmp_0217 : std_logic;
  signal tmp_0218 : std_logic;
  signal tmp_0219 : std_logic;
  signal tmp_0220 : std_logic;
  signal tmp_0221 : std_logic;
  signal tmp_0222 : signed(32-1 downto 0);
  signal tmp_0223 : signed(32-1 downto 0);
  signal tmp_0224 : signed(32-1 downto 0);
  signal tmp_0225 : signed(32-1 downto 0);
  signal tmp_0226 : signed(32-1 downto 0);
  signal tmp_0227 : signed(32-1 downto 0);
  signal tmp_0228 : signed(32-1 downto 0);
  signal tmp_0229 : signed(32-1 downto 0);
  signal tmp_0230 : signed(32-1 downto 0);
  signal tmp_0231 : signed(32-1 downto 0);
  signal tmp_0232 : signed(32-1 downto 0);
  signal tmp_0233 : signed(32-1 downto 0);
  signal tmp_0234 : signed(32-1 downto 0);
  signal tmp_0235 : std_logic;
  signal tmp_0236 : signed(32-1 downto 0);
  signal tmp_0237 : signed(32-1 downto 0);
  signal tmp_0238 : signed(32-1 downto 0);
  signal tmp_0239 : signed(32-1 downto 0);
  signal tmp_0240 : signed(32-1 downto 0);
  signal tmp_0241 : std_logic;
  signal tmp_0242 : std_logic;
  signal tmp_0243 : std_logic;
  signal tmp_0244 : signed(32-1 downto 0);
  signal tmp_0245 : signed(32-1 downto 0);
  type Type_pull_recv_data_method is (
    pull_recv_data_method_IDLE,
    pull_recv_data_method_S_0000,
    pull_recv_data_method_S_0001,
    pull_recv_data_method_S_0002,
    pull_recv_data_method_S_0004,
    pull_recv_data_method_S_0005,
    pull_recv_data_method_S_0009,
    pull_recv_data_method_S_0010,
    pull_recv_data_method_S_0019,
    pull_recv_data_method_S_0020,
    pull_recv_data_method_S_0021,
    pull_recv_data_method_S_0023,
    pull_recv_data_method_S_0024,
    pull_recv_data_method_S_0025,
    pull_recv_data_method_S_0026,
    pull_recv_data_method_S_0027,
    pull_recv_data_method_S_0028,
    pull_recv_data_method_S_0030,
    pull_recv_data_method_S_0031,
    pull_recv_data_method_S_0033,
    pull_recv_data_method_S_0034,
    pull_recv_data_method_S_0036,
    pull_recv_data_method_S_0037,
    pull_recv_data_method_S_0040,
    pull_recv_data_method_S_0041,
    pull_recv_data_method_S_0043,
    pull_recv_data_method_S_0044,
    pull_recv_data_method_S_0045,
    pull_recv_data_method_S_0046,
    pull_recv_data_method_S_0048,
    pull_recv_data_method_S_0049,
    pull_recv_data_method_S_0050,
    pull_recv_data_method_S_0004_body,
    pull_recv_data_method_S_0004_wait,
    pull_recv_data_method_S_0009_body,
    pull_recv_data_method_S_0009_wait,
    pull_recv_data_method_S_0036_body,
    pull_recv_data_method_S_0036_wait,
    pull_recv_data_method_S_0043_body,
    pull_recv_data_method_S_0043_wait,
    pull_recv_data_method_S_0048_body,
    pull_recv_data_method_S_0048_wait  
  );
  signal pull_recv_data_method : Type_pull_recv_data_method := pull_recv_data_method_IDLE;
  signal pull_recv_data_method_delay : signed(32-1 downto 0) := (others => '0');
  signal pull_recv_data_req_flag_d : std_logic := '0';
  signal pull_recv_data_req_flag_edge : std_logic;
  signal tmp_0246 : std_logic;
  signal tmp_0247 : std_logic;
  signal tmp_0248 : std_logic;
  signal tmp_0249 : std_logic;
  signal read_data_call_flag_0004 : std_logic;
  signal tmp_0250 : std_logic;
  signal tmp_0251 : std_logic;
  signal tmp_0252 : std_logic;
  signal tmp_0253 : std_logic;
  signal read_data_call_flag_0009 : std_logic;
  signal tmp_0254 : std_logic;
  signal tmp_0255 : std_logic;
  signal tmp_0256 : std_logic;
  signal tmp_0257 : std_logic;
  signal tmp_0258 : std_logic;
  signal tmp_0259 : std_logic;
  signal tmp_0260 : std_logic;
  signal tmp_0261 : std_logic;
  signal read_data_call_flag_0036 : std_logic;
  signal tmp_0262 : std_logic;
  signal tmp_0263 : std_logic;
  signal tmp_0264 : std_logic;
  signal tmp_0265 : std_logic;
  signal read_data_call_flag_0043 : std_logic;
  signal tmp_0266 : std_logic;
  signal tmp_0267 : std_logic;
  signal tmp_0268 : std_logic;
  signal tmp_0269 : std_logic;
  signal write_data_call_flag_0048 : std_logic;
  signal tmp_0270 : std_logic;
  signal tmp_0271 : std_logic;
  signal tmp_0272 : std_logic;
  signal tmp_0273 : std_logic;
  signal tmp_0274 : std_logic;
  signal tmp_0275 : std_logic;
  signal tmp_0276 : std_logic;
  signal tmp_0277 : std_logic;
  signal tmp_0278 : signed(32-1 downto 0);
  signal tmp_0279 : signed(32-1 downto 0);
  signal tmp_0280 : signed(32-1 downto 0);
  signal tmp_0281 : signed(32-1 downto 0);
  signal tmp_0282 : signed(32-1 downto 0);
  signal tmp_0283 : signed(32-1 downto 0);
  signal tmp_0284 : signed(32-1 downto 0);
  signal tmp_0285 : signed(32-1 downto 0);
  signal tmp_0286 : signed(32-1 downto 0);
  signal tmp_0287 : signed(32-1 downto 0);
  signal tmp_0288 : std_logic;
  signal tmp_0289 : signed(32-1 downto 0);
  signal tmp_0290 : std_logic;
  signal tmp_0291 : signed(32-1 downto 0);
  signal tmp_0292 : signed(32-1 downto 0);
  signal tmp_0293 : signed(32-1 downto 0);
  signal tmp_0294 : signed(32-1 downto 0);
  signal tmp_0295 : signed(32-1 downto 0);
  signal tmp_0296 : signed(32-1 downto 0);
  signal tmp_0297 : signed(32-1 downto 0);
  signal tmp_0298 : signed(32-1 downto 0);
  signal tmp_0299 : signed(32-1 downto 0);
  signal tmp_0300 : signed(32-1 downto 0);
  signal tmp_0301 : signed(32-1 downto 0);
  type Type_push_send_data_method is (
    push_send_data_method_IDLE,
    push_send_data_method_S_0000,
    push_send_data_method_S_0001,
    push_send_data_method_S_0002,
    push_send_data_method_S_0006,
    push_send_data_method_S_0007,
    push_send_data_method_S_0008,
    push_send_data_method_S_0010,
    push_send_data_method_S_0011,
    push_send_data_method_S_0012,
    push_send_data_method_S_0013,
    push_send_data_method_S_0014,
    push_send_data_method_S_0015,
    push_send_data_method_S_0017,
    push_send_data_method_S_0018,
    push_send_data_method_S_0020,
    push_send_data_method_S_0021,
    push_send_data_method_S_0024,
    push_send_data_method_S_0025,
    push_send_data_method_S_0027,
    push_send_data_method_S_0028,
    push_send_data_method_S_0031,
    push_send_data_method_S_0032,
    push_send_data_method_S_0033,
    push_send_data_method_S_0035,
    push_send_data_method_S_0036,
    push_send_data_method_S_0040,
    push_send_data_method_S_0041,
    push_send_data_method_S_0045,
    push_send_data_method_S_0046,
    push_send_data_method_S_0050,
    push_send_data_method_S_0051,
    push_send_data_method_S_0053,
    push_send_data_method_S_0054,
    push_send_data_method_S_0024_body,
    push_send_data_method_S_0024_wait,
    push_send_data_method_S_0031_body,
    push_send_data_method_S_0031_wait,
    push_send_data_method_S_0035_body,
    push_send_data_method_S_0035_wait,
    push_send_data_method_S_0040_body,
    push_send_data_method_S_0040_wait,
    push_send_data_method_S_0045_body,
    push_send_data_method_S_0045_wait,
    push_send_data_method_S_0050_body,
    push_send_data_method_S_0050_wait,
    push_send_data_method_S_0053_body,
    push_send_data_method_S_0053_wait  
  );
  signal push_send_data_method : Type_push_send_data_method := push_send_data_method_IDLE;
  signal push_send_data_method_delay : signed(32-1 downto 0) := (others => '0');
  signal push_send_data_req_flag_d : std_logic := '0';
  signal push_send_data_req_flag_edge : std_logic;
  signal tmp_0302 : std_logic;
  signal tmp_0303 : std_logic;
  signal tmp_0304 : std_logic;
  signal tmp_0305 : std_logic;
  signal tmp_0306 : std_logic;
  signal tmp_0307 : std_logic;
  signal tmp_0308 : std_logic;
  signal tmp_0309 : std_logic;
  signal write_data_call_flag_0024 : std_logic;
  signal tmp_0310 : std_logic;
  signal tmp_0311 : std_logic;
  signal tmp_0312 : std_logic;
  signal tmp_0313 : std_logic;
  signal write_data_call_flag_0031 : std_logic;
  signal tmp_0314 : std_logic;
  signal tmp_0315 : std_logic;
  signal tmp_0316 : std_logic;
  signal tmp_0317 : std_logic;
  signal write_data_call_flag_0035 : std_logic;
  signal tmp_0318 : std_logic;
  signal tmp_0319 : std_logic;
  signal tmp_0320 : std_logic;
  signal tmp_0321 : std_logic;
  signal write_data_call_flag_0040 : std_logic;
  signal tmp_0322 : std_logic;
  signal tmp_0323 : std_logic;
  signal tmp_0324 : std_logic;
  signal tmp_0325 : std_logic;
  signal write_data_call_flag_0050 : std_logic;
  signal tmp_0326 : std_logic;
  signal tmp_0327 : std_logic;
  signal tmp_0328 : std_logic;
  signal tmp_0329 : std_logic;
  signal write_data_call_flag_0053 : std_logic;
  signal tmp_0330 : std_logic;
  signal tmp_0331 : std_logic;
  signal tmp_0332 : std_logic;
  signal tmp_0333 : std_logic;
  signal tmp_0334 : std_logic;
  signal tmp_0335 : std_logic;
  signal tmp_0336 : std_logic;
  signal tmp_0337 : std_logic;
  signal tmp_0338 : signed(32-1 downto 0);
  signal tmp_0339 : signed(32-1 downto 0);
  signal tmp_0340 : std_logic;
  signal tmp_0341 : signed(32-1 downto 0);
  signal tmp_0342 : std_logic;
  signal tmp_0343 : signed(32-1 downto 0);
  signal tmp_0344 : signed(32-1 downto 0);
  signal tmp_0345 : signed(32-1 downto 0);
  signal tmp_0346 : signed(32-1 downto 0);
  signal tmp_0347 : signed(32-1 downto 0);
  signal tmp_0348 : signed(32-1 downto 0);
  signal tmp_0349 : signed(32-1 downto 0);
  signal tmp_0350 : signed(32-1 downto 0);
  signal tmp_0351 : signed(32-1 downto 0);
  signal tmp_0352 : signed(32-1 downto 0);
  signal tmp_0353 : signed(32-1 downto 0);
  signal tmp_0354 : signed(32-1 downto 0);
  signal tmp_0355 : signed(32-1 downto 0);
  signal tmp_0356 : signed(32-1 downto 0);
  signal tmp_0357 : signed(8-1 downto 0);
  signal tmp_0358 : signed(32-1 downto 0);
  signal tmp_0359 : signed(32-1 downto 0);
  signal tmp_0360 : signed(32-1 downto 0);
  signal tmp_0361 : signed(8-1 downto 0);
  signal tmp_0362 : signed(32-1 downto 0);
  signal tmp_0363 : signed(32-1 downto 0);
  signal tmp_0364 : signed(32-1 downto 0);
  signal tmp_0365 : signed(8-1 downto 0);
  signal tmp_0366 : signed(32-1 downto 0);
  signal tmp_0367 : signed(32-1 downto 0);
  type Type_tcp_server_method is (
    tcp_server_method_IDLE,
    tcp_server_method_S_0000,
    tcp_server_method_S_0001,
    tcp_server_method_S_0002,
    tcp_server_method_S_0004,
    tcp_server_method_S_0005,
    tcp_server_method_S_0006,
    tcp_server_method_S_0007,
    tcp_server_method_S_0008,
    tcp_server_method_S_0009,
    tcp_server_method_S_0010,
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
    tcp_server_method_S_0025,
    tcp_server_method_S_0026,
    tcp_server_method_S_0027,
    tcp_server_method_S_0028,
    tcp_server_method_S_0029,
    tcp_server_method_S_0030,
    tcp_server_method_S_0032,
    tcp_server_method_S_0033,
    tcp_server_method_S_0034,
    tcp_server_method_S_0035,
    tcp_server_method_S_0036,
    tcp_server_method_S_0037,
    tcp_server_method_S_0038,
    tcp_server_method_S_0039,
    tcp_server_method_S_0041,
    tcp_server_method_S_0042,
    tcp_server_method_S_0043,
    tcp_server_method_S_0044,
    tcp_server_method_S_0045,
    tcp_server_method_S_0046,
    tcp_server_method_S_0047,
    tcp_server_method_S_0048,
    tcp_server_method_S_0049,
    tcp_server_method_S_0050,
    tcp_server_method_S_0051,
    tcp_server_method_S_0004_body,
    tcp_server_method_S_0004_wait,
    tcp_server_method_S_0005_body,
    tcp_server_method_S_0005_wait,
    tcp_server_method_S_0012_body,
    tcp_server_method_S_0012_wait,
    tcp_server_method_S_0013_body,
    tcp_server_method_S_0013_wait,
    tcp_server_method_S_0018_body,
    tcp_server_method_S_0018_wait,
    tcp_server_method_S_0025_body,
    tcp_server_method_S_0025_wait,
    tcp_server_method_S_0026_body,
    tcp_server_method_S_0026_wait,
    tcp_server_method_S_0029_body,
    tcp_server_method_S_0029_wait,
    tcp_server_method_S_0033_body,
    tcp_server_method_S_0033_wait,
    tcp_server_method_S_0038_body,
    tcp_server_method_S_0038_wait,
    tcp_server_method_S_0046_body,
    tcp_server_method_S_0046_wait,
    tcp_server_method_S_0049_body,
    tcp_server_method_S_0049_wait  
  );
  signal tcp_server_method : Type_tcp_server_method := tcp_server_method_IDLE;
  signal tcp_server_method_delay : signed(32-1 downto 0) := (others => '0');
  signal tcp_server_req_flag_d : std_logic := '0';
  signal tcp_server_req_flag_edge : std_logic;
  signal tmp_0368 : std_logic;
  signal tmp_0369 : std_logic;
  signal tmp_0370 : std_logic;
  signal tmp_0371 : std_logic;
  signal tcp_server_open_call_flag_0005 : std_logic;
  signal tmp_0372 : std_logic;
  signal tmp_0373 : std_logic;
  signal tmp_0374 : std_logic;
  signal tmp_0375 : std_logic;
  signal tmp_0376 : std_logic;
  signal tmp_0377 : std_logic;
  signal tcp_server_open_call_flag_0013 : std_logic;
  signal tmp_0378 : std_logic;
  signal tmp_0379 : std_logic;
  signal tmp_0380 : std_logic;
  signal tmp_0381 : std_logic;
  signal tcp_server_listen_call_flag_0018 : std_logic;
  signal tmp_0382 : std_logic;
  signal tmp_0383 : std_logic;
  signal tmp_0384 : std_logic;
  signal tmp_0385 : std_logic;
  signal tmp_0386 : std_logic;
  signal tmp_0387 : std_logic;
  signal write_data_call_flag_0025 : std_logic;
  signal tmp_0388 : std_logic;
  signal tmp_0389 : std_logic;
  signal tmp_0390 : std_logic;
  signal tmp_0391 : std_logic;
  signal tcp_server_listen_call_flag_0026 : std_logic;
  signal tmp_0392 : std_logic;
  signal tmp_0393 : std_logic;
  signal tmp_0394 : std_logic;
  signal tmp_0395 : std_logic;
  signal wait_for_established_call_flag_0029 : std_logic;
  signal tmp_0396 : std_logic;
  signal tmp_0397 : std_logic;
  signal tmp_0398 : std_logic;
  signal tmp_0399 : std_logic;
  signal tmp_0400 : std_logic;
  signal tmp_0401 : std_logic;
  signal wait_for_recv_call_flag_0038 : std_logic;
  signal tmp_0402 : std_logic;
  signal tmp_0403 : std_logic;
  signal tmp_0404 : std_logic;
  signal tmp_0405 : std_logic;
  signal tmp_0406 : std_logic;
  signal tmp_0407 : std_logic;
  signal pull_recv_data_call_flag_0046 : std_logic;
  signal tmp_0408 : std_logic;
  signal tmp_0409 : std_logic;
  signal tmp_0410 : std_logic;
  signal tmp_0411 : std_logic;
  signal push_send_data_call_flag_0049 : std_logic;
  signal tmp_0412 : std_logic;
  signal tmp_0413 : std_logic;
  signal tmp_0414 : std_logic;
  signal tmp_0415 : std_logic;
  signal tmp_0416 : std_logic;
  signal tmp_0417 : std_logic;
  signal tmp_0418 : std_logic;
  signal tmp_0419 : std_logic;
  signal tmp_0420 : signed(32-1 downto 0);
  signal tmp_0421 : signed(32-1 downto 0);
  signal tmp_0422 : std_logic;
  signal tmp_0423 : signed(32-1 downto 0);
  signal tmp_0424 : signed(32-1 downto 0);
  signal tmp_0425 : signed(32-1 downto 0);
  signal tmp_0426 : std_logic;
  signal tmp_0427 : signed(32-1 downto 0);
  signal tmp_0428 : signed(32-1 downto 0);
  signal tmp_0429 : signed(32-1 downto 0);
  signal tmp_0430 : signed(32-1 downto 0);
  signal tmp_0431 : signed(32-1 downto 0);
  signal tmp_0432 : std_logic;
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
    test_method_S_0009,
    test_method_S_0010,
    test_method_S_0011,
    test_method_S_0012,
    test_method_S_0003_body,
    test_method_S_0003_wait,
    test_method_S_0005_body,
    test_method_S_0005_wait,
    test_method_S_0010_body,
    test_method_S_0010_wait  
  );
  signal test_method : Type_test_method := test_method_IDLE;
  signal test_method_delay : signed(32-1 downto 0) := (others => '0');
  signal test_req_flag_d : std_logic := '0';
  signal test_req_flag_edge : std_logic;
  signal tmp_0433 : std_logic;
  signal tmp_0434 : std_logic;
  signal tmp_0435 : std_logic;
  signal tmp_0436 : std_logic;
  signal init_call_flag_0003 : std_logic;
  signal tmp_0437 : std_logic;
  signal tmp_0438 : std_logic;
  signal tmp_0439 : std_logic;
  signal tmp_0440 : std_logic;
  signal network_configuration_call_flag_0005 : std_logic;
  signal tmp_0441 : std_logic;
  signal tmp_0442 : std_logic;
  signal tmp_0443 : std_logic;
  signal tmp_0444 : std_logic;
  signal tmp_0445 : std_logic;
  signal tmp_0446 : std_logic;
  signal tcp_server_call_flag_0010 : std_logic;
  signal tmp_0447 : std_logic;
  signal tmp_0448 : std_logic;
  signal tmp_0449 : std_logic;
  signal tmp_0450 : std_logic;
  signal tmp_0451 : std_logic;
  signal tmp_0452 : std_logic;
  signal tmp_0453 : std_logic;
  signal tmp_0454 : std_logic;
  type Type_blink_led_method is (
    blink_led_method_IDLE,
    blink_led_method_S_0000,
    blink_led_method_S_0001,
    blink_led_method_S_0002  
  );
  signal blink_led_method : Type_blink_led_method := blink_led_method_IDLE;
  signal blink_led_method_delay : signed(32-1 downto 0) := (others => '0');
  signal blink_led_req_flag_d : std_logic := '0';
  signal blink_led_req_flag_edge : std_logic;
  signal tmp_0455 : std_logic;
  signal tmp_0456 : std_logic;
  signal tmp_0457 : std_logic;
  signal tmp_0458 : std_logic;
  signal tmp_0459 : std_logic;
  signal tmp_0460 : std_logic;
  signal tmp_0461 : std_logic;
  signal tmp_0462 : std_logic;

begin

  clk_sig <= clk;
  reset_sig <= reset;
  class_wiz830mj_0000_ADDR_exp <= class_wiz830mj_0000_ADDR_exp_sig;
  class_wiz830mj_0000_ADDR_exp_sig <= class_wiz830mj_0000_ADDR;

  class_wiz830mj_0000_nCS_exp <= class_wiz830mj_0000_nCS_exp_sig;
  class_wiz830mj_0000_nCS_exp_sig <= class_wiz830mj_0000_nCS;

  class_wiz830mj_0000_nRD_exp <= class_wiz830mj_0000_nRD_exp_sig;
  class_wiz830mj_0000_nRD_exp_sig <= class_wiz830mj_0000_nRD;

  class_wiz830mj_0000_nWR_exp <= class_wiz830mj_0000_nWR_exp_sig;
  class_wiz830mj_0000_nWR_exp_sig <= class_wiz830mj_0000_nWR;

  class_wiz830mj_0000_nINT_exp_sig <= class_wiz830mj_0000_nINT_exp;
  class_wiz830mj_0000_nRESET_exp <= class_wiz830mj_0000_nRESET_exp_sig;
  class_wiz830mj_0000_nRESET_exp_sig <= class_wiz830mj_0000_nRESET;

  class_wiz830mj_0000_BRDY_exp_sig <= class_wiz830mj_0000_BRDY_exp;
  led_in_sig <= led_in;
  led_we_sig <= led_we;
  led_out <= led_out_sig;
  led_out_sig <= class_led_0002;

  test_busy <= test_busy_sig;
  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        test_busy_sig <= '1';
      else
        if test_method = test_method_S_0000 then
          test_busy_sig <= '0';
        elsif test_method = test_method_S_0001 then
          test_busy_sig <= tmp_0436;
        end if;
      end if;
    end if;
  end process;

  test_req_sig <= test_req;
  blink_led_busy <= blink_led_busy_sig;
  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        blink_led_busy_sig <= '1';
      else
        if blink_led_method = blink_led_method_S_0000 then
          blink_led_busy_sig <= '0';
        elsif blink_led_method = blink_led_method_S_0001 then
          blink_led_busy_sig <= tmp_0458;
        end if;
      end if;
    end if;
  end process;

  blink_led_req_sig <= blink_led_req;

  -- expressions
  tmp_0001 <= led_in_sig when led_we_sig = '1' else class_led_0002;
  tmp_0002 <= test_req_local or test_req_sig;
  tmp_0003 <= blink_led_req_local or blink_led_req_sig;
  tmp_0004 <= not wait_cycles_req_flag_d;
  tmp_0005 <= wait_cycles_req_flag and tmp_0004;
  tmp_0006 <= wait_cycles_req_flag or wait_cycles_req_flag_d;
  tmp_0007 <= wait_cycles_req_flag or wait_cycles_req_flag_d;
  tmp_0008 <= '1' when binary_expr_00091 = '1' else '0';
  tmp_0009 <= '1' when binary_expr_00091 = '0' else '0';
  tmp_0010 <= '1' when wait_cycles_method /= wait_cycles_method_S_0000 else '0';
  tmp_0011 <= '1' when wait_cycles_method /= wait_cycles_method_S_0001 else '0';
  tmp_0012 <= tmp_0011 and wait_cycles_req_flag_edge;
  tmp_0013 <= tmp_0010 and tmp_0012;
  tmp_0014 <= '1' when wait_cycles_i_0090 < wait_cycles_n_0089 else '0';
  tmp_0015 <= wait_cycles_i_0090 + X"00000001";
  tmp_0016 <= not write_data_req_flag_d;
  tmp_0017 <= write_data_req_flag and tmp_0016;
  tmp_0018 <= write_data_req_flag or write_data_req_flag_d;
  tmp_0019 <= write_data_req_flag or write_data_req_flag_d;
  tmp_0020 <= '1' when wait_cycles_busy = '0' else '0';
  tmp_0021 <= '1' when wait_cycles_req_local = '0' else '0';
  tmp_0022 <= tmp_0020 and tmp_0021;
  tmp_0023 <= '1' when tmp_0022 = '1' else '0';
  tmp_0024 <= '1' when write_data_method /= write_data_method_S_0000 else '0';
  tmp_0025 <= '1' when write_data_method /= write_data_method_S_0001 else '0';
  tmp_0026 <= tmp_0025 and write_data_req_flag_edge;
  tmp_0027 <= tmp_0024 and tmp_0026;
  tmp_0028 <= not read_data_req_flag_d;
  tmp_0029 <= read_data_req_flag and tmp_0028;
  tmp_0030 <= read_data_req_flag or read_data_req_flag_d;
  tmp_0031 <= read_data_req_flag or read_data_req_flag_d;
  tmp_0032 <= '1' when wait_cycles_busy = '0' else '0';
  tmp_0033 <= '1' when wait_cycles_req_local = '0' else '0';
  tmp_0034 <= tmp_0032 and tmp_0033;
  tmp_0035 <= '1' when tmp_0034 = '1' else '0';
  tmp_0036 <= '1' when read_data_method /= read_data_method_S_0000 else '0';
  tmp_0037 <= '1' when read_data_method /= read_data_method_S_0001 else '0';
  tmp_0038 <= tmp_0037 and read_data_req_flag_edge;
  tmp_0039 <= tmp_0036 and tmp_0038;
  tmp_0040 <= not init_req_flag_d;
  tmp_0041 <= init_req_flag and tmp_0040;
  tmp_0042 <= init_req_flag or init_req_flag_d;
  tmp_0043 <= init_req_flag or init_req_flag_d;
  tmp_0044 <= '1' when wait_cycles_busy = '0' else '0';
  tmp_0045 <= '1' when wait_cycles_req_local = '0' else '0';
  tmp_0046 <= tmp_0044 and tmp_0045;
  tmp_0047 <= '1' when tmp_0046 = '1' else '0';
  tmp_0048 <= '1' when init_method /= init_method_S_0000 else '0';
  tmp_0049 <= '1' when init_method /= init_method_S_0001 else '0';
  tmp_0050 <= tmp_0049 and init_req_flag_edge;
  tmp_0051 <= tmp_0048 and tmp_0050;
  tmp_0052 <= not network_configuration_req_flag_d;
  tmp_0053 <= network_configuration_req_flag and tmp_0052;
  tmp_0054 <= network_configuration_req_flag or network_configuration_req_flag_d;
  tmp_0055 <= network_configuration_req_flag or network_configuration_req_flag_d;
  tmp_0056 <= '1' when write_data_busy = '0' else '0';
  tmp_0057 <= '1' when write_data_req_local = '0' else '0';
  tmp_0058 <= tmp_0056 and tmp_0057;
  tmp_0059 <= '1' when tmp_0058 = '1' else '0';
  tmp_0060 <= '1' when write_data_busy = '0' else '0';
  tmp_0061 <= '1' when write_data_req_local = '0' else '0';
  tmp_0062 <= tmp_0060 and tmp_0061;
  tmp_0063 <= '1' when tmp_0062 = '1' else '0';
  tmp_0064 <= '1' when write_data_busy = '0' else '0';
  tmp_0065 <= '1' when write_data_req_local = '0' else '0';
  tmp_0066 <= tmp_0064 and tmp_0065;
  tmp_0067 <= '1' when tmp_0066 = '1' else '0';
  tmp_0068 <= '1' when write_data_busy = '0' else '0';
  tmp_0069 <= '1' when write_data_req_local = '0' else '0';
  tmp_0070 <= tmp_0068 and tmp_0069;
  tmp_0071 <= '1' when tmp_0070 = '1' else '0';
  tmp_0072 <= '1' when write_data_busy = '0' else '0';
  tmp_0073 <= '1' when write_data_req_local = '0' else '0';
  tmp_0074 <= tmp_0072 and tmp_0073;
  tmp_0075 <= '1' when tmp_0074 = '1' else '0';
  tmp_0076 <= '1' when write_data_busy = '0' else '0';
  tmp_0077 <= '1' when write_data_req_local = '0' else '0';
  tmp_0078 <= tmp_0076 and tmp_0077;
  tmp_0079 <= '1' when tmp_0078 = '1' else '0';
  tmp_0080 <= '1' when write_data_busy = '0' else '0';
  tmp_0081 <= '1' when write_data_req_local = '0' else '0';
  tmp_0082 <= tmp_0080 and tmp_0081;
  tmp_0083 <= '1' when tmp_0082 = '1' else '0';
  tmp_0084 <= '1' when write_data_busy = '0' else '0';
  tmp_0085 <= '1' when write_data_req_local = '0' else '0';
  tmp_0086 <= tmp_0084 and tmp_0085;
  tmp_0087 <= '1' when tmp_0086 = '1' else '0';
  tmp_0088 <= '1' when write_data_busy = '0' else '0';
  tmp_0089 <= '1' when write_data_req_local = '0' else '0';
  tmp_0090 <= tmp_0088 and tmp_0089;
  tmp_0091 <= '1' when tmp_0090 = '1' else '0';
  tmp_0092 <= '1' when write_data_busy = '0' else '0';
  tmp_0093 <= '1' when write_data_req_local = '0' else '0';
  tmp_0094 <= tmp_0092 and tmp_0093;
  tmp_0095 <= '1' when tmp_0094 = '1' else '0';
  tmp_0096 <= '1' when write_data_busy = '0' else '0';
  tmp_0097 <= '1' when write_data_req_local = '0' else '0';
  tmp_0098 <= tmp_0096 and tmp_0097;
  tmp_0099 <= '1' when tmp_0098 = '1' else '0';
  tmp_0100 <= '1' when write_data_busy = '0' else '0';
  tmp_0101 <= '1' when write_data_req_local = '0' else '0';
  tmp_0102 <= tmp_0100 and tmp_0101;
  tmp_0103 <= '1' when tmp_0102 = '1' else '0';
  tmp_0104 <= '1' when write_data_busy = '0' else '0';
  tmp_0105 <= '1' when write_data_req_local = '0' else '0';
  tmp_0106 <= tmp_0104 and tmp_0105;
  tmp_0107 <= '1' when tmp_0106 = '1' else '0';
  tmp_0108 <= '1' when write_data_busy = '0' else '0';
  tmp_0109 <= '1' when write_data_req_local = '0' else '0';
  tmp_0110 <= tmp_0108 and tmp_0109;
  tmp_0111 <= '1' when tmp_0110 = '1' else '0';
  tmp_0112 <= '1' when write_data_busy = '0' else '0';
  tmp_0113 <= '1' when write_data_req_local = '0' else '0';
  tmp_0114 <= tmp_0112 and tmp_0113;
  tmp_0115 <= '1' when tmp_0114 = '1' else '0';
  tmp_0116 <= '1' when write_data_busy = '0' else '0';
  tmp_0117 <= '1' when write_data_req_local = '0' else '0';
  tmp_0118 <= tmp_0116 and tmp_0117;
  tmp_0119 <= '1' when tmp_0118 = '1' else '0';
  tmp_0120 <= '1' when write_data_busy = '0' else '0';
  tmp_0121 <= '1' when write_data_req_local = '0' else '0';
  tmp_0122 <= tmp_0120 and tmp_0121;
  tmp_0123 <= '1' when tmp_0122 = '1' else '0';
  tmp_0124 <= '1' when write_data_busy = '0' else '0';
  tmp_0125 <= '1' when write_data_req_local = '0' else '0';
  tmp_0126 <= tmp_0124 and tmp_0125;
  tmp_0127 <= '1' when tmp_0126 = '1' else '0';
  tmp_0128 <= '1' when network_configuration_method /= network_configuration_method_S_0000 else '0';
  tmp_0129 <= '1' when network_configuration_method /= network_configuration_method_S_0001 else '0';
  tmp_0130 <= tmp_0129 and network_configuration_req_flag_edge;
  tmp_0131 <= tmp_0128 and tmp_0130;
  tmp_0132 <= not tcp_server_open_req_flag_d;
  tmp_0133 <= tcp_server_open_req_flag and tmp_0132;
  tmp_0134 <= tcp_server_open_req_flag or tcp_server_open_req_flag_d;
  tmp_0135 <= tcp_server_open_req_flag or tcp_server_open_req_flag_d;
  tmp_0136 <= '1' when read_data_busy = '0' else '0';
  tmp_0137 <= '1' when read_data_req_local = '0' else '0';
  tmp_0138 <= tmp_0136 and tmp_0137;
  tmp_0139 <= '1' when tmp_0138 = '1' else '0';
  tmp_0140 <= '1' when tcp_server_open_method /= tcp_server_open_method_S_0000 else '0';
  tmp_0141 <= '1' when tcp_server_open_method /= tcp_server_open_method_S_0001 else '0';
  tmp_0142 <= tmp_0141 and tcp_server_open_req_flag_edge;
  tmp_0143 <= tmp_0140 and tmp_0142;
  tmp_0144 <= tcp_server_open_port_0136(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0145 <= (32-1 downto 8 => class_Sn_MR_TCP_0054(7)) & class_Sn_MR_TCP_0054;
  tmp_0146 <= class_Sn_MR1_0004 + tmp_0144;
  tmp_0147 <= X"00000020" or tmp_0145;
  tmp_0148 <= tmp_0147(32 - 24 - 1 downto 0);
  tmp_0149 <= tcp_server_open_port_0136(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0150 <= class_Sn_PORTR0_0013 + tmp_0149;
  tmp_0151 <= tcp_server_open_port_0136(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0152 <= class_Sn_PORTR1_0014 + tmp_0151;
  tmp_0153 <= tcp_server_open_port_0136(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0154 <= class_Sn_CR1_0006 + tmp_0153;
  tmp_0155 <= tcp_server_open_port_0136(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0156 <= class_Sn_SSR1_0012 + tmp_0155;
  tmp_0157 <= not tcp_server_listen_req_flag_d;
  tmp_0158 <= tcp_server_listen_req_flag and tmp_0157;
  tmp_0159 <= tcp_server_listen_req_flag or tcp_server_listen_req_flag_d;
  tmp_0160 <= tcp_server_listen_req_flag or tcp_server_listen_req_flag_d;
  tmp_0161 <= '1' when read_data_busy = '0' else '0';
  tmp_0162 <= '1' when read_data_req_local = '0' else '0';
  tmp_0163 <= tmp_0161 and tmp_0162;
  tmp_0164 <= '1' when tmp_0163 = '1' else '0';
  tmp_0165 <= '1' when tcp_server_listen_method /= tcp_server_listen_method_S_0000 else '0';
  tmp_0166 <= '1' when tcp_server_listen_method /= tcp_server_listen_method_S_0001 else '0';
  tmp_0167 <= tmp_0166 and tcp_server_listen_req_flag_edge;
  tmp_0168 <= tmp_0165 and tmp_0167;
  tmp_0169 <= tcp_server_listen_port_0155(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0170 <= class_Sn_CR1_0006 + tmp_0169;
  tmp_0171 <= tcp_server_listen_port_0155(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0172 <= class_Sn_SSR1_0012 + tmp_0171;
  tmp_0173 <= not wait_for_established_req_flag_d;
  tmp_0174 <= wait_for_established_req_flag and tmp_0173;
  tmp_0175 <= wait_for_established_req_flag or wait_for_established_req_flag_d;
  tmp_0176 <= wait_for_established_req_flag or wait_for_established_req_flag_d;
  tmp_0177 <= '1' and '1';
  tmp_0178 <= '1' and '0';
  tmp_0179 <= '1' when binary_expr_00167 = '1' else '0';
  tmp_0180 <= '1' when binary_expr_00167 = '0' else '0';
  tmp_0181 <= '1' when wait_for_established_method /= wait_for_established_method_S_0000 else '0';
  tmp_0182 <= '1' when wait_for_established_method /= wait_for_established_method_S_0001 else '0';
  tmp_0183 <= tmp_0182 and wait_for_established_req_flag_edge;
  tmp_0184 <= tmp_0181 and tmp_0183;
  tmp_0185 <= wait_for_established_port_0162(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0186 <= class_Sn_SSR1_0012 + tmp_0185;
  tmp_0187 <= '1' when method_result_00164 = class_Sn_SOCK_ESTABLISHED_0076 else '0';
  tmp_0188 <= not wait_for_recv_req_flag_d;
  tmp_0189 <= wait_for_recv_req_flag and tmp_0188;
  tmp_0190 <= wait_for_recv_req_flag or wait_for_recv_req_flag_d;
  tmp_0191 <= wait_for_recv_req_flag or wait_for_recv_req_flag_d;
  tmp_0192 <= '1' and '1';
  tmp_0193 <= '1' and '0';
  tmp_0194 <= '1' when read_data_busy = '0' else '0';
  tmp_0195 <= '1' when read_data_req_local = '0' else '0';
  tmp_0196 <= tmp_0194 and tmp_0195;
  tmp_0197 <= '1' when tmp_0196 = '1' else '0';
  tmp_0198 <= '1' when read_data_busy = '0' else '0';
  tmp_0199 <= '1' when read_data_req_local = '0' else '0';
  tmp_0200 <= tmp_0198 and tmp_0199;
  tmp_0201 <= '1' when tmp_0200 = '1' else '0';
  tmp_0202 <= '1' when read_data_busy = '0' else '0';
  tmp_0203 <= '1' when read_data_req_local = '0' else '0';
  tmp_0204 <= tmp_0202 and tmp_0203;
  tmp_0205 <= '1' when tmp_0204 = '1' else '0';
  tmp_0206 <= '1' when binary_expr_00189 = '1' else '0';
  tmp_0207 <= '1' when binary_expr_00189 = '0' else '0';
  tmp_0208 <= '1' when read_data_busy = '0' else '0';
  tmp_0209 <= '1' when read_data_req_local = '0' else '0';
  tmp_0210 <= tmp_0208 and tmp_0209;
  tmp_0211 <= '1' when tmp_0210 = '1' else '0';
  tmp_0212 <= '1' when binary_expr_00198 = '1' else '0';
  tmp_0213 <= '1' when binary_expr_00198 = '0' else '0';
  tmp_0214 <= '1' when write_data_busy = '0' else '0';
  tmp_0215 <= '1' when write_data_req_local = '0' else '0';
  tmp_0216 <= tmp_0214 and tmp_0215;
  tmp_0217 <= '1' when tmp_0216 = '1' else '0';
  tmp_0218 <= '1' when wait_for_recv_method /= wait_for_recv_method_S_0000 else '0';
  tmp_0219 <= '1' when wait_for_recv_method /= wait_for_recv_method_S_0001 else '0';
  tmp_0220 <= tmp_0219 and wait_for_recv_req_flag_edge;
  tmp_0221 <= tmp_0218 and tmp_0220;
  tmp_0222 <= wait_for_recv_port_0168(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0223 <= class_Sn_RX_RSR1_0044 + tmp_0222;
  tmp_0224 <= (32-1 downto 8 => method_result_00171(7)) & method_result_00171;
  tmp_0225 <= wait_for_recv_port_0168(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0226 <= class_Sn_RX_RSR2_0045 + tmp_0225;
  tmp_0227 <= (32-1 downto 8 => method_result_00176(7)) & method_result_00176;
  tmp_0228 <= wait_for_recv_port_0168(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0229 <= class_Sn_RX_RSR3_0046 + tmp_0228;
  tmp_0230 <= (32-1 downto 8 => method_result_00181(7)) & method_result_00181;
  tmp_0231 <= wait_for_recv_v0_0170(15 downto 0) & (16-1 downto 0 => '0');
  tmp_0232 <= wait_for_recv_v1_0175(23 downto 0) & (8-1 downto 0 => '0');
  tmp_0233 <= tmp_0231 + tmp_0232;
  tmp_0234 <= tmp_0233 + tmp_0230;
  tmp_0235 <= '1' when tmp_0234 /= X"00000000" else '0';
  tmp_0236 <= wait_for_recv_port_0168(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0237 <= class_Sn_SSR1_0012 + tmp_0236;
  tmp_0238 <= (32-1 downto 8 => method_result_00190(7)) & method_result_00190;
  tmp_0239 <= (32-1 downto 8 => class_Sn_SOCK_CLOSE_WAIT_0077(7)) & class_Sn_SOCK_CLOSE_WAIT_0077;
  tmp_0240 <= (32-1 downto 8 => class_Sn_SOCK_CLOSED_0073(7)) & class_Sn_SOCK_CLOSED_0073;
  tmp_0241 <= '1' when tmp_0238 = tmp_0239 else '0';
  tmp_0242 <= '1' when tmp_0238 = tmp_0240 else '0';
  tmp_0243 <= tmp_0241 or tmp_0242;
  tmp_0244 <= wait_for_recv_port_0168(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0245 <= class_Sn_CR1_0006 + tmp_0244;
  tmp_0246 <= not pull_recv_data_req_flag_d;
  tmp_0247 <= pull_recv_data_req_flag and tmp_0246;
  tmp_0248 <= pull_recv_data_req_flag or pull_recv_data_req_flag_d;
  tmp_0249 <= pull_recv_data_req_flag or pull_recv_data_req_flag_d;
  tmp_0250 <= '1' when read_data_busy = '0' else '0';
  tmp_0251 <= '1' when read_data_req_local = '0' else '0';
  tmp_0252 <= tmp_0250 and tmp_0251;
  tmp_0253 <= '1' when tmp_0252 = '1' else '0';
  tmp_0254 <= '1' when read_data_busy = '0' else '0';
  tmp_0255 <= '1' when read_data_req_local = '0' else '0';
  tmp_0256 <= tmp_0254 and tmp_0255;
  tmp_0257 <= '1' when tmp_0256 = '1' else '0';
  tmp_0258 <= '1' when binary_expr_00219 = '1' else '0';
  tmp_0259 <= '1' when binary_expr_00219 = '0' else '0';
  tmp_0260 <= '1' when binary_expr_00222 = '1' else '0';
  tmp_0261 <= '1' when binary_expr_00222 = '0' else '0';
  tmp_0262 <= '1' when read_data_busy = '0' else '0';
  tmp_0263 <= '1' when read_data_req_local = '0' else '0';
  tmp_0264 <= tmp_0262 and tmp_0263;
  tmp_0265 <= '1' when tmp_0264 = '1' else '0';
  tmp_0266 <= '1' when read_data_busy = '0' else '0';
  tmp_0267 <= '1' when read_data_req_local = '0' else '0';
  tmp_0268 <= tmp_0266 and tmp_0267;
  tmp_0269 <= '1' when tmp_0268 = '1' else '0';
  tmp_0270 <= '1' when write_data_busy = '0' else '0';
  tmp_0271 <= '1' when write_data_req_local = '0' else '0';
  tmp_0272 <= tmp_0270 and tmp_0271;
  tmp_0273 <= '1' when tmp_0272 = '1' else '0';
  tmp_0274 <= '1' when pull_recv_data_method /= pull_recv_data_method_S_0000 else '0';
  tmp_0275 <= '1' when pull_recv_data_method /= pull_recv_data_method_S_0001 else '0';
  tmp_0276 <= tmp_0275 and pull_recv_data_req_flag_edge;
  tmp_0277 <= tmp_0274 and tmp_0276;
  tmp_0278 <= pull_recv_data_port_0202(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0279 <= class_Sn_RX_FIFOR0_0051 + tmp_0278;
  tmp_0280 <= (32-1 downto 8 => method_result_00204(7)) & method_result_00204;
  tmp_0281 <= pull_recv_data_port_0202(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0282 <= class_Sn_RX_FIFOR1_0052 + tmp_0281;
  tmp_0283 <= (32-1 downto 8 => method_result_00209(7)) & method_result_00209;
  tmp_0284 <= pull_recv_data_v0_0203(23 downto 0) & (8-1 downto 0 => '0');
  tmp_0285 <= tmp_0284 + tmp_0283;
  tmp_0286 <= (1-1 downto 0 => tmp_0285(31)) & tmp_0285(31 downto 1);
  tmp_0287 <= tmp_0285 and X"00000001";
  tmp_0288 <= '1' when tmp_0287 = X"00000001" else '0';
  tmp_0289 <= pull_recv_data_read_len_0216 + X"00000001";
  tmp_0290 <= '1' when pull_recv_data_i_0221 < pull_recv_data_read_len_0216 else '0';
  tmp_0291 <= pull_recv_data_i_0221 + X"00000001";
  tmp_0292 <= pull_recv_data_i_0221(30 downto 0) & (1-1 downto 0 => '0');
  tmp_0293 <= tmp_0292 + X"00000000";
  tmp_0294 <= pull_recv_data_port_0202(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0295 <= class_Sn_RX_FIFOR0_0051 + tmp_0294;
  tmp_0296 <= pull_recv_data_i_0221(30 downto 0) & (1-1 downto 0 => '0');
  tmp_0297 <= tmp_0296 + X"00000001";
  tmp_0298 <= pull_recv_data_port_0202(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0299 <= class_Sn_RX_FIFOR1_0052 + tmp_0298;
  tmp_0300 <= pull_recv_data_port_0202(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0301 <= class_Sn_CR1_0006 + tmp_0300;
  tmp_0302 <= not push_send_data_req_flag_d;
  tmp_0303 <= push_send_data_req_flag and tmp_0302;
  tmp_0304 <= push_send_data_req_flag or push_send_data_req_flag_d;
  tmp_0305 <= push_send_data_req_flag or push_send_data_req_flag_d;
  tmp_0306 <= '1' when binary_expr_00244 = '1' else '0';
  tmp_0307 <= '1' when binary_expr_00244 = '0' else '0';
  tmp_0308 <= '1' when binary_expr_00247 = '1' else '0';
  tmp_0309 <= '1' when binary_expr_00247 = '0' else '0';
  tmp_0310 <= '1' when write_data_busy = '0' else '0';
  tmp_0311 <= '1' when write_data_req_local = '0' else '0';
  tmp_0312 <= tmp_0310 and tmp_0311;
  tmp_0313 <= '1' when tmp_0312 = '1' else '0';
  tmp_0314 <= '1' when write_data_busy = '0' else '0';
  tmp_0315 <= '1' when write_data_req_local = '0' else '0';
  tmp_0316 <= tmp_0314 and tmp_0315;
  tmp_0317 <= '1' when tmp_0316 = '1' else '0';
  tmp_0318 <= '1' when write_data_busy = '0' else '0';
  tmp_0319 <= '1' when write_data_req_local = '0' else '0';
  tmp_0320 <= tmp_0318 and tmp_0319;
  tmp_0321 <= '1' when tmp_0320 = '1' else '0';
  tmp_0322 <= '1' when write_data_busy = '0' else '0';
  tmp_0323 <= '1' when write_data_req_local = '0' else '0';
  tmp_0324 <= tmp_0322 and tmp_0323;
  tmp_0325 <= '1' when tmp_0324 = '1' else '0';
  tmp_0326 <= '1' when write_data_busy = '0' else '0';
  tmp_0327 <= '1' when write_data_req_local = '0' else '0';
  tmp_0328 <= tmp_0326 and tmp_0327;
  tmp_0329 <= '1' when tmp_0328 = '1' else '0';
  tmp_0330 <= '1' when write_data_busy = '0' else '0';
  tmp_0331 <= '1' when write_data_req_local = '0' else '0';
  tmp_0332 <= tmp_0330 and tmp_0331;
  tmp_0333 <= '1' when tmp_0332 = '1' else '0';
  tmp_0334 <= '1' when push_send_data_method /= push_send_data_method_S_0000 else '0';
  tmp_0335 <= '1' when push_send_data_method /= push_send_data_method_S_0001 else '0';
  tmp_0336 <= tmp_0335 and push_send_data_req_flag_edge;
  tmp_0337 <= tmp_0334 and tmp_0336;
  tmp_0338 <= (1-1 downto 0 => push_send_data_len_0240(31)) & push_send_data_len_0240(31 downto 1);
  tmp_0339 <= push_send_data_len_0240 and X"00000001";
  tmp_0340 <= '1' when tmp_0339 = X"00000001" else '0';
  tmp_0341 <= push_send_data_write_len_0241 + X"00000001";
  tmp_0342 <= '1' when push_send_data_i_0246 < push_send_data_write_len_0241 else '0';
  tmp_0343 <= push_send_data_i_0246 + X"00000001";
  tmp_0344 <= push_send_data_i_0246(30 downto 0) & (1-1 downto 0 => '0');
  tmp_0345 <= tmp_0344 + X"00000000";
  tmp_0346 <= push_send_data_port_0239(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0347 <= class_Sn_TX_FIFOR0_0049 + tmp_0346;
  tmp_0348 <= push_send_data_i_0246(30 downto 0) & (1-1 downto 0 => '0');
  tmp_0349 <= tmp_0348 + X"00000001";
  tmp_0350 <= push_send_data_port_0239(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0351 <= class_Sn_TX_FIFOR1_0050 + tmp_0350;
  tmp_0352 <= push_send_data_port_0239(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0353 <= class_Sn_CR1_0006 + tmp_0352;
  tmp_0354 <= push_send_data_port_0239(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0355 <= (16-1 downto 0 => push_send_data_len_0240(31)) & push_send_data_len_0240(31 downto 16);
  tmp_0356 <= class_Sn_TX_WRSR1_0036 + tmp_0354;
  tmp_0357 <= tmp_0355(32 - 24 - 1 downto 0);
  tmp_0358 <= push_send_data_port_0239(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0359 <= (8-1 downto 0 => push_send_data_len_0240(31)) & push_send_data_len_0240(31 downto 8);
  tmp_0360 <= class_Sn_TX_WRSR2_0037 + tmp_0358;
  tmp_0361 <= tmp_0359(32 - 24 - 1 downto 0);
  tmp_0362 <= push_send_data_port_0239(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0363 <= push_send_data_len_0240;
  tmp_0364 <= class_Sn_TX_WRSR3_0038 + tmp_0362;
  tmp_0365 <= tmp_0363(32 - 24 - 1 downto 0);
  tmp_0366 <= push_send_data_port_0239(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0367 <= class_Sn_CR1_0006 + tmp_0366;
  tmp_0368 <= not tcp_server_req_flag_d;
  tmp_0369 <= tcp_server_req_flag and tmp_0368;
  tmp_0370 <= tcp_server_req_flag or tcp_server_req_flag_d;
  tmp_0371 <= tcp_server_req_flag or tcp_server_req_flag_d;
  tmp_0372 <= '1' when tcp_server_open_busy = '0' else '0';
  tmp_0373 <= '1' when tcp_server_open_req_local = '0' else '0';
  tmp_0374 <= tmp_0372 and tmp_0373;
  tmp_0375 <= '1' when tmp_0374 = '1' else '0';
  tmp_0376 <= '1' when binary_expr_00289 = '1' else '0';
  tmp_0377 <= '1' when binary_expr_00289 = '0' else '0';
  tmp_0378 <= '1' when tcp_server_open_busy = '0' else '0';
  tmp_0379 <= '1' when tcp_server_open_req_local = '0' else '0';
  tmp_0380 <= tmp_0378 and tmp_0379;
  tmp_0381 <= '1' when tmp_0380 = '1' else '0';
  tmp_0382 <= '1' when tcp_server_listen_busy = '0' else '0';
  tmp_0383 <= '1' when tcp_server_listen_req_local = '0' else '0';
  tmp_0384 <= tmp_0382 and tmp_0383;
  tmp_0385 <= '1' when tmp_0384 = '1' else '0';
  tmp_0386 <= '1' when binary_expr_00296 = '1' else '0';
  tmp_0387 <= '1' when binary_expr_00296 = '0' else '0';
  tmp_0388 <= '1' when write_data_busy = '0' else '0';
  tmp_0389 <= '1' when write_data_req_local = '0' else '0';
  tmp_0390 <= tmp_0388 and tmp_0389;
  tmp_0391 <= '1' when tmp_0390 = '1' else '0';
  tmp_0392 <= '1' when tcp_server_listen_busy = '0' else '0';
  tmp_0393 <= '1' when tcp_server_listen_req_local = '0' else '0';
  tmp_0394 <= tmp_0392 and tmp_0393;
  tmp_0395 <= '1' when tmp_0394 = '1' else '0';
  tmp_0396 <= '1' when wait_for_established_busy = '0' else '0';
  tmp_0397 <= '1' when wait_for_established_req_local = '0' else '0';
  tmp_0398 <= tmp_0396 and tmp_0397;
  tmp_0399 <= '1' when tmp_0398 = '1' else '0';
  tmp_0400 <= '1' and '1';
  tmp_0401 <= '1' and '0';
  tmp_0402 <= '1' when wait_for_recv_busy = '0' else '0';
  tmp_0403 <= '1' when wait_for_recv_req_local = '0' else '0';
  tmp_0404 <= tmp_0402 and tmp_0403;
  tmp_0405 <= '1' when tmp_0404 = '1' else '0';
  tmp_0406 <= '1' when binary_expr_00308 = '1' else '0';
  tmp_0407 <= '1' when binary_expr_00308 = '0' else '0';
  tmp_0408 <= '1' when pull_recv_data_busy = '0' else '0';
  tmp_0409 <= '1' when pull_recv_data_req_local = '0' else '0';
  tmp_0410 <= tmp_0408 and tmp_0409;
  tmp_0411 <= '1' when tmp_0410 = '1' else '0';
  tmp_0412 <= '1' when push_send_data_busy = '0' else '0';
  tmp_0413 <= '1' when push_send_data_req_local = '0' else '0';
  tmp_0414 <= tmp_0412 and tmp_0413;
  tmp_0415 <= '1' when tmp_0414 = '1' else '0';
  tmp_0416 <= '1' when tcp_server_method /= tcp_server_method_S_0000 else '0';
  tmp_0417 <= '1' when tcp_server_method /= tcp_server_method_S_0001 else '0';
  tmp_0418 <= tmp_0417 and tcp_server_req_flag_edge;
  tmp_0419 <= tmp_0416 and tmp_0418;
  tmp_0420 <= tcp_server_port_0283(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0421 <= class_Sn_IMR1_0008 + tmp_0420;
  tmp_0422 <= '1' when tcp_server_v_0287 /= class_Sn_SOCK_INIT_0074 else '0';
  tmp_0423 <= tcp_server_port_0283(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0424 <= class_Sn_CR1_0006 + tmp_0423;
  tmp_0425 <= (32-1 downto 8 => tcp_server_v_0287(7)) & tcp_server_v_0287;
  tmp_0426 <= '1' when tcp_server_v_0287 /= class_Sn_SOCK_LISTEN_0075 else '0';
  tmp_0427 <= tcp_server_port_0283(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0428 <= class_Sn_CR1_0006 + tmp_0427;
  tmp_0429 <= tcp_server_port_0283(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0430 <= class_Sn_MR0_0003 + binary_expr_00303;
  tmp_0431 <= (32-1 downto 8 => method_result_00302(7)) & method_result_00302;
  tmp_0432 <= '1' when method_result_00307 = X"00000000" else '0';
  tmp_0433 <= not test_req_flag_d;
  tmp_0434 <= test_req_flag and tmp_0433;
  tmp_0435 <= test_req_flag or test_req_flag_d;
  tmp_0436 <= test_req_flag or test_req_flag_d;
  tmp_0437 <= '1' when init_busy = '0' else '0';
  tmp_0438 <= '1' when init_req_local = '0' else '0';
  tmp_0439 <= tmp_0437 and tmp_0438;
  tmp_0440 <= '1' when tmp_0439 = '1' else '0';
  tmp_0441 <= '1' when network_configuration_busy = '0' else '0';
  tmp_0442 <= '1' when network_configuration_req_local = '0' else '0';
  tmp_0443 <= tmp_0441 and tmp_0442;
  tmp_0444 <= '1' when tmp_0443 = '1' else '0';
  tmp_0445 <= '1' and '1';
  tmp_0446 <= '1' and '0';
  tmp_0447 <= '1' when tcp_server_busy = '0' else '0';
  tmp_0448 <= '1' when tcp_server_req_local = '0' else '0';
  tmp_0449 <= tmp_0447 and tmp_0448;
  tmp_0450 <= '1' when tmp_0449 = '1' else '0';
  tmp_0451 <= '1' when test_method /= test_method_S_0000 else '0';
  tmp_0452 <= '1' when test_method /= test_method_S_0001 else '0';
  tmp_0453 <= tmp_0452 and test_req_flag_edge;
  tmp_0454 <= tmp_0451 and tmp_0453;
  tmp_0455 <= not blink_led_req_flag_d;
  tmp_0456 <= blink_led_req_flag and tmp_0455;
  tmp_0457 <= blink_led_req_flag or blink_led_req_flag_d;
  tmp_0458 <= blink_led_req_flag or blink_led_req_flag_d;
  tmp_0459 <= '1' when blink_led_method /= blink_led_method_S_0000 else '0';
  tmp_0460 <= '1' when blink_led_method /= blink_led_method_S_0001 else '0';
  tmp_0461 <= tmp_0460 and blink_led_req_flag_edge;
  tmp_0462 <= tmp_0459 and tmp_0461;

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
          when wait_cycles_method_S_0001 => 
            if tmp_0006 = '1' then
              wait_cycles_method <= wait_cycles_method_S_0002;
            end if;
          when wait_cycles_method_S_0002 => 
            wait_cycles_method <= wait_cycles_method_S_0003;
          when wait_cycles_method_S_0003 => 
            wait_cycles_method <= wait_cycles_method_S_0004;
          when wait_cycles_method_S_0004 => 
            if tmp_0008 = '1' then
              wait_cycles_method <= wait_cycles_method_S_0009;
            elsif tmp_0009 = '1' then
              wait_cycles_method <= wait_cycles_method_S_0005;
            end if;
          when wait_cycles_method_S_0005 => 
            wait_cycles_method <= wait_cycles_method_S_0010;
          when wait_cycles_method_S_0006 => 
            wait_cycles_method <= wait_cycles_method_S_0008;
          when wait_cycles_method_S_0008 => 
            wait_cycles_method <= wait_cycles_method_S_0003;
          when wait_cycles_method_S_0009 => 
            wait_cycles_method <= wait_cycles_method_S_0006;
          when wait_cycles_method_S_0010 => 
            wait_cycles_method <= wait_cycles_method_S_0000;
          when others => null;
        end case;
        wait_cycles_req_flag_d <= wait_cycles_req_flag;
        if (tmp_0010 and tmp_0012) = '1' then
          wait_cycles_method <= wait_cycles_method_S_0001;
        end if;
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
          when write_data_method_S_0001 => 
            if tmp_0018 = '1' then
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
            write_data_method <= write_data_method_S_0010_body;
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
          when write_data_method_S_0010_body => 
            write_data_method <= write_data_method_S_0010_wait;
          when write_data_method_S_0010_wait => 
            if wait_cycles_call_flag_0010 = '1' then
              write_data_method <= write_data_method_S_0011;
            end if;
          when others => null;
        end case;
        write_data_req_flag_d <= write_data_req_flag;
        if (tmp_0024 and tmp_0026) = '1' then
          write_data_method <= write_data_method_S_0001;
        end if;
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
          when read_data_method_S_0001 => 
            if tmp_0030 = '1' then
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
            read_data_method <= read_data_method_S_0008_body;
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
          when read_data_method_S_0008_body => 
            read_data_method <= read_data_method_S_0008_wait;
          when read_data_method_S_0008_wait => 
            if wait_cycles_call_flag_0008 = '1' then
              read_data_method <= read_data_method_S_0009;
            end if;
          when others => null;
        end case;
        read_data_req_flag_d <= read_data_req_flag;
        if (tmp_0036 and tmp_0038) = '1' then
          read_data_method <= read_data_method_S_0001;
        end if;
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
          when init_method_S_0001 => 
            if tmp_0042 = '1' then
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
            init_method <= init_method_S_0010_body;
          when init_method_S_0011 => 
            init_method <= init_method_S_0012;
          when init_method_S_0012 => 
            init_method <= init_method_S_0013;
          when init_method_S_0013 => 
            init_method <= init_method_S_0013_body;
          when init_method_S_0014 => 
            init_method <= init_method_S_0000;
          when init_method_S_0010_body => 
            init_method <= init_method_S_0010_wait;
          when init_method_S_0010_wait => 
            if wait_cycles_call_flag_0010 = '1' then
              init_method <= init_method_S_0011;
            end if;
          when init_method_S_0013_body => 
            init_method <= init_method_S_0013_wait;
          when init_method_S_0013_wait => 
            if wait_cycles_call_flag_0013 = '1' then
              init_method <= init_method_S_0014;
            end if;
          when others => null;
        end case;
        init_req_flag_d <= init_req_flag;
        if (tmp_0048 and tmp_0050) = '1' then
          init_method <= init_method_S_0001;
        end if;
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
          when network_configuration_method_S_0001 => 
            if tmp_0054 = '1' then
              network_configuration_method <= network_configuration_method_S_0002;
            end if;
          when network_configuration_method_S_0002 => 
            network_configuration_method <= network_configuration_method_S_0002_body;
          when network_configuration_method_S_0003 => 
            network_configuration_method <= network_configuration_method_S_0003_body;
          when network_configuration_method_S_0004 => 
            network_configuration_method <= network_configuration_method_S_0004_body;
          when network_configuration_method_S_0005 => 
            network_configuration_method <= network_configuration_method_S_0005_body;
          when network_configuration_method_S_0006 => 
            network_configuration_method <= network_configuration_method_S_0006_body;
          when network_configuration_method_S_0007 => 
            network_configuration_method <= network_configuration_method_S_0007_body;
          when network_configuration_method_S_0008 => 
            network_configuration_method <= network_configuration_method_S_0008_body;
          when network_configuration_method_S_0009 => 
            network_configuration_method <= network_configuration_method_S_0009_body;
          when network_configuration_method_S_0010 => 
            network_configuration_method <= network_configuration_method_S_0010_body;
          when network_configuration_method_S_0011 => 
            network_configuration_method <= network_configuration_method_S_0011_body;
          when network_configuration_method_S_0012 => 
            network_configuration_method <= network_configuration_method_S_0012_body;
          when network_configuration_method_S_0013 => 
            network_configuration_method <= network_configuration_method_S_0013_body;
          when network_configuration_method_S_0014 => 
            network_configuration_method <= network_configuration_method_S_0014_body;
          when network_configuration_method_S_0015 => 
            network_configuration_method <= network_configuration_method_S_0015_body;
          when network_configuration_method_S_0016 => 
            network_configuration_method <= network_configuration_method_S_0016_body;
          when network_configuration_method_S_0017 => 
            network_configuration_method <= network_configuration_method_S_0017_body;
          when network_configuration_method_S_0018 => 
            network_configuration_method <= network_configuration_method_S_0018_body;
          when network_configuration_method_S_0019 => 
            network_configuration_method <= network_configuration_method_S_0019_body;
          when network_configuration_method_S_0020 => 
            network_configuration_method <= network_configuration_method_S_0000;
          when network_configuration_method_S_0002_body => 
            network_configuration_method <= network_configuration_method_S_0002_wait;
          when network_configuration_method_S_0002_wait => 
            if write_data_call_flag_0002 = '1' then
              network_configuration_method <= network_configuration_method_S_0003;
            end if;
          when network_configuration_method_S_0003_body => 
            network_configuration_method <= network_configuration_method_S_0003_wait;
          when network_configuration_method_S_0003_wait => 
            if write_data_call_flag_0003 = '1' then
              network_configuration_method <= network_configuration_method_S_0004;
            end if;
          when network_configuration_method_S_0004_body => 
            network_configuration_method <= network_configuration_method_S_0004_wait;
          when network_configuration_method_S_0004_wait => 
            if write_data_call_flag_0004 = '1' then
              network_configuration_method <= network_configuration_method_S_0005;
            end if;
          when network_configuration_method_S_0005_body => 
            network_configuration_method <= network_configuration_method_S_0005_wait;
          when network_configuration_method_S_0005_wait => 
            if write_data_call_flag_0005 = '1' then
              network_configuration_method <= network_configuration_method_S_0006;
            end if;
          when network_configuration_method_S_0006_body => 
            network_configuration_method <= network_configuration_method_S_0006_wait;
          when network_configuration_method_S_0006_wait => 
            if write_data_call_flag_0006 = '1' then
              network_configuration_method <= network_configuration_method_S_0007;
            end if;
          when network_configuration_method_S_0007_body => 
            network_configuration_method <= network_configuration_method_S_0007_wait;
          when network_configuration_method_S_0007_wait => 
            if write_data_call_flag_0007 = '1' then
              network_configuration_method <= network_configuration_method_S_0008;
            end if;
          when network_configuration_method_S_0008_body => 
            network_configuration_method <= network_configuration_method_S_0008_wait;
          when network_configuration_method_S_0008_wait => 
            if write_data_call_flag_0008 = '1' then
              network_configuration_method <= network_configuration_method_S_0009;
            end if;
          when network_configuration_method_S_0009_body => 
            network_configuration_method <= network_configuration_method_S_0009_wait;
          when network_configuration_method_S_0009_wait => 
            if write_data_call_flag_0009 = '1' then
              network_configuration_method <= network_configuration_method_S_0010;
            end if;
          when network_configuration_method_S_0010_body => 
            network_configuration_method <= network_configuration_method_S_0010_wait;
          when network_configuration_method_S_0010_wait => 
            if write_data_call_flag_0010 = '1' then
              network_configuration_method <= network_configuration_method_S_0011;
            end if;
          when network_configuration_method_S_0011_body => 
            network_configuration_method <= network_configuration_method_S_0011_wait;
          when network_configuration_method_S_0011_wait => 
            if write_data_call_flag_0011 = '1' then
              network_configuration_method <= network_configuration_method_S_0012;
            end if;
          when network_configuration_method_S_0012_body => 
            network_configuration_method <= network_configuration_method_S_0012_wait;
          when network_configuration_method_S_0012_wait => 
            if write_data_call_flag_0012 = '1' then
              network_configuration_method <= network_configuration_method_S_0013;
            end if;
          when network_configuration_method_S_0013_body => 
            network_configuration_method <= network_configuration_method_S_0013_wait;
          when network_configuration_method_S_0013_wait => 
            if write_data_call_flag_0013 = '1' then
              network_configuration_method <= network_configuration_method_S_0014;
            end if;
          when network_configuration_method_S_0014_body => 
            network_configuration_method <= network_configuration_method_S_0014_wait;
          when network_configuration_method_S_0014_wait => 
            if write_data_call_flag_0014 = '1' then
              network_configuration_method <= network_configuration_method_S_0015;
            end if;
          when network_configuration_method_S_0015_body => 
            network_configuration_method <= network_configuration_method_S_0015_wait;
          when network_configuration_method_S_0015_wait => 
            if write_data_call_flag_0015 = '1' then
              network_configuration_method <= network_configuration_method_S_0016;
            end if;
          when network_configuration_method_S_0016_body => 
            network_configuration_method <= network_configuration_method_S_0016_wait;
          when network_configuration_method_S_0016_wait => 
            if write_data_call_flag_0016 = '1' then
              network_configuration_method <= network_configuration_method_S_0017;
            end if;
          when network_configuration_method_S_0017_body => 
            network_configuration_method <= network_configuration_method_S_0017_wait;
          when network_configuration_method_S_0017_wait => 
            if write_data_call_flag_0017 = '1' then
              network_configuration_method <= network_configuration_method_S_0018;
            end if;
          when network_configuration_method_S_0018_body => 
            network_configuration_method <= network_configuration_method_S_0018_wait;
          when network_configuration_method_S_0018_wait => 
            if write_data_call_flag_0018 = '1' then
              network_configuration_method <= network_configuration_method_S_0019;
            end if;
          when network_configuration_method_S_0019_body => 
            network_configuration_method <= network_configuration_method_S_0019_wait;
          when network_configuration_method_S_0019_wait => 
            if write_data_call_flag_0019 = '1' then
              network_configuration_method <= network_configuration_method_S_0020;
            end if;
          when others => null;
        end case;
        network_configuration_req_flag_d <= network_configuration_req_flag;
        if (tmp_0128 and tmp_0130) = '1' then
          network_configuration_method <= network_configuration_method_S_0001;
        end if;
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
          when tcp_server_open_method_S_0001 => 
            if tmp_0134 = '1' then
              tcp_server_open_method <= tcp_server_open_method_S_0002;
            end if;
          when tcp_server_open_method_S_0002 => 
            tcp_server_open_method <= tcp_server_open_method_S_0007;
          when tcp_server_open_method_S_0007 => 
            tcp_server_open_method <= tcp_server_open_method_S_0007_body;
          when tcp_server_open_method_S_0008 => 
            tcp_server_open_method <= tcp_server_open_method_S_0010;
          when tcp_server_open_method_S_0010 => 
            tcp_server_open_method <= tcp_server_open_method_S_0010_body;
          when tcp_server_open_method_S_0011 => 
            tcp_server_open_method <= tcp_server_open_method_S_0013;
          when tcp_server_open_method_S_0013 => 
            tcp_server_open_method <= tcp_server_open_method_S_0013_body;
          when tcp_server_open_method_S_0014 => 
            tcp_server_open_method <= tcp_server_open_method_S_0016;
          when tcp_server_open_method_S_0016 => 
            tcp_server_open_method <= tcp_server_open_method_S_0016_body;
          when tcp_server_open_method_S_0017 => 
            tcp_server_open_method <= tcp_server_open_method_S_0019;
          when tcp_server_open_method_S_0019 => 
            tcp_server_open_method <= tcp_server_open_method_S_0019_body;
          when tcp_server_open_method_S_0020 => 
            tcp_server_open_method <= tcp_server_open_method_S_0000;
          when tcp_server_open_method_S_0021 => 
            tcp_server_open_method <= tcp_server_open_method_S_0000;
          when tcp_server_open_method_S_0007_body => 
            tcp_server_open_method <= tcp_server_open_method_S_0007_wait;
          when tcp_server_open_method_S_0007_wait => 
            if write_data_call_flag_0007 = '1' then
              tcp_server_open_method <= tcp_server_open_method_S_0008;
            end if;
          when tcp_server_open_method_S_0010_body => 
            tcp_server_open_method <= tcp_server_open_method_S_0010_wait;
          when tcp_server_open_method_S_0010_wait => 
            if write_data_call_flag_0010 = '1' then
              tcp_server_open_method <= tcp_server_open_method_S_0011;
            end if;
          when tcp_server_open_method_S_0013_body => 
            tcp_server_open_method <= tcp_server_open_method_S_0013_wait;
          when tcp_server_open_method_S_0013_wait => 
            if write_data_call_flag_0013 = '1' then
              tcp_server_open_method <= tcp_server_open_method_S_0014;
            end if;
          when tcp_server_open_method_S_0016_body => 
            tcp_server_open_method <= tcp_server_open_method_S_0016_wait;
          when tcp_server_open_method_S_0016_wait => 
            if write_data_call_flag_0016 = '1' then
              tcp_server_open_method <= tcp_server_open_method_S_0017;
            end if;
          when tcp_server_open_method_S_0019_body => 
            tcp_server_open_method <= tcp_server_open_method_S_0019_wait;
          when tcp_server_open_method_S_0019_wait => 
            if read_data_call_flag_0019 = '1' then
              tcp_server_open_method <= tcp_server_open_method_S_0020;
            end if;
          when others => null;
        end case;
        tcp_server_open_req_flag_d <= tcp_server_open_req_flag;
        if (tmp_0140 and tmp_0142) = '1' then
          tcp_server_open_method <= tcp_server_open_method_S_0001;
        end if;
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
          when tcp_server_listen_method_S_0001 => 
            if tmp_0159 = '1' then
              tcp_server_listen_method <= tcp_server_listen_method_S_0002;
            end if;
          when tcp_server_listen_method_S_0002 => 
            tcp_server_listen_method <= tcp_server_listen_method_S_0004;
          when tcp_server_listen_method_S_0004 => 
            tcp_server_listen_method <= tcp_server_listen_method_S_0004_body;
          when tcp_server_listen_method_S_0005 => 
            tcp_server_listen_method <= tcp_server_listen_method_S_0007;
          when tcp_server_listen_method_S_0007 => 
            tcp_server_listen_method <= tcp_server_listen_method_S_0007_body;
          when tcp_server_listen_method_S_0008 => 
            tcp_server_listen_method <= tcp_server_listen_method_S_0000;
          when tcp_server_listen_method_S_0009 => 
            tcp_server_listen_method <= tcp_server_listen_method_S_0000;
          when tcp_server_listen_method_S_0004_body => 
            tcp_server_listen_method <= tcp_server_listen_method_S_0004_wait;
          when tcp_server_listen_method_S_0004_wait => 
            if write_data_call_flag_0004 = '1' then
              tcp_server_listen_method <= tcp_server_listen_method_S_0005;
            end if;
          when tcp_server_listen_method_S_0007_body => 
            tcp_server_listen_method <= tcp_server_listen_method_S_0007_wait;
          when tcp_server_listen_method_S_0007_wait => 
            if read_data_call_flag_0007 = '1' then
              tcp_server_listen_method <= tcp_server_listen_method_S_0008;
            end if;
          when others => null;
        end case;
        tcp_server_listen_req_flag_d <= tcp_server_listen_req_flag;
        if (tmp_0165 and tmp_0167) = '1' then
          tcp_server_listen_method <= tcp_server_listen_method_S_0001;
        end if;
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
          when wait_for_established_method_S_0001 => 
            if tmp_0175 = '1' then
              wait_for_established_method <= wait_for_established_method_S_0002;
            end if;
          when wait_for_established_method_S_0002 => 
            wait_for_established_method <= wait_for_established_method_S_0003;
          when wait_for_established_method_S_0003 => 
            if tmp_0177 = '1' then
              wait_for_established_method <= wait_for_established_method_S_0005;
            elsif tmp_0178 = '1' then
              wait_for_established_method <= wait_for_established_method_S_0004;
            end if;
          when wait_for_established_method_S_0004 => 
            wait_for_established_method <= wait_for_established_method_S_0015;
          when wait_for_established_method_S_0005 => 
            wait_for_established_method <= wait_for_established_method_S_0007;
          when wait_for_established_method_S_0007 => 
            wait_for_established_method <= wait_for_established_method_S_0007_body;
          when wait_for_established_method_S_0008 => 
            wait_for_established_method <= wait_for_established_method_S_0010;
          when wait_for_established_method_S_0010 => 
            if tmp_0179 = '1' then
              wait_for_established_method <= wait_for_established_method_S_0012;
            elsif tmp_0180 = '1' then
              wait_for_established_method <= wait_for_established_method_S_0011;
            end if;
          when wait_for_established_method_S_0011 => 
            wait_for_established_method <= wait_for_established_method_S_0014;
          when wait_for_established_method_S_0012 => 
            wait_for_established_method <= wait_for_established_method_S_0000;
          when wait_for_established_method_S_0013 => 
            wait_for_established_method <= wait_for_established_method_S_0011;
          when wait_for_established_method_S_0014 => 
            wait_for_established_method <= wait_for_established_method_S_0003;
          when wait_for_established_method_S_0015 => 
            wait_for_established_method <= wait_for_established_method_S_0000;
          when wait_for_established_method_S_0007_body => 
            wait_for_established_method <= wait_for_established_method_S_0007_wait;
          when wait_for_established_method_S_0007_wait => 
            if read_data_call_flag_0007 = '1' then
              wait_for_established_method <= wait_for_established_method_S_0008;
            end if;
          when others => null;
        end case;
        wait_for_established_req_flag_d <= wait_for_established_req_flag;
        if (tmp_0181 and tmp_0183) = '1' then
          wait_for_established_method <= wait_for_established_method_S_0001;
        end if;
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
          when wait_for_recv_method_S_0001 => 
            if tmp_0190 = '1' then
              wait_for_recv_method <= wait_for_recv_method_S_0002;
            end if;
          when wait_for_recv_method_S_0002 => 
            wait_for_recv_method <= wait_for_recv_method_S_0003;
          when wait_for_recv_method_S_0003 => 
            if tmp_0192 = '1' then
              wait_for_recv_method <= wait_for_recv_method_S_0005;
            elsif tmp_0193 = '1' then
              wait_for_recv_method <= wait_for_recv_method_S_0004;
            end if;
          when wait_for_recv_method_S_0004 => 
            wait_for_recv_method <= wait_for_recv_method_S_0049;
          when wait_for_recv_method_S_0005 => 
            wait_for_recv_method <= wait_for_recv_method_S_0008;
          when wait_for_recv_method_S_0008 => 
            wait_for_recv_method <= wait_for_recv_method_S_0008_body;
          when wait_for_recv_method_S_0009 => 
            wait_for_recv_method <= wait_for_recv_method_S_0013;
          when wait_for_recv_method_S_0013 => 
            wait_for_recv_method <= wait_for_recv_method_S_0013_body;
          when wait_for_recv_method_S_0014 => 
            wait_for_recv_method <= wait_for_recv_method_S_0018;
          when wait_for_recv_method_S_0018 => 
            wait_for_recv_method <= wait_for_recv_method_S_0018_body;
          when wait_for_recv_method_S_0019 => 
            wait_for_recv_method <= wait_for_recv_method_S_0027;
          when wait_for_recv_method_S_0027 => 
            if tmp_0206 = '1' then
              wait_for_recv_method <= wait_for_recv_method_S_0029;
            elsif tmp_0207 = '1' then
              wait_for_recv_method <= wait_for_recv_method_S_0028;
            end if;
          when wait_for_recv_method_S_0028 => 
            wait_for_recv_method <= wait_for_recv_method_S_0031;
          when wait_for_recv_method_S_0029 => 
            wait_for_recv_method <= wait_for_recv_method_S_0000;
          when wait_for_recv_method_S_0030 => 
            wait_for_recv_method <= wait_for_recv_method_S_0028;
          when wait_for_recv_method_S_0031 => 
            wait_for_recv_method <= wait_for_recv_method_S_0033;
          when wait_for_recv_method_S_0033 => 
            wait_for_recv_method <= wait_for_recv_method_S_0033_body;
          when wait_for_recv_method_S_0034 => 
            wait_for_recv_method <= wait_for_recv_method_S_0041;
          when wait_for_recv_method_S_0041 => 
            if tmp_0212 = '1' then
              wait_for_recv_method <= wait_for_recv_method_S_0043;
            elsif tmp_0213 = '1' then
              wait_for_recv_method <= wait_for_recv_method_S_0042;
            end if;
          when wait_for_recv_method_S_0042 => 
            wait_for_recv_method <= wait_for_recv_method_S_0048;
          when wait_for_recv_method_S_0043 => 
            wait_for_recv_method <= wait_for_recv_method_S_0045;
          when wait_for_recv_method_S_0045 => 
            wait_for_recv_method <= wait_for_recv_method_S_0045_body;
          when wait_for_recv_method_S_0046 => 
            wait_for_recv_method <= wait_for_recv_method_S_0000;
          when wait_for_recv_method_S_0047 => 
            wait_for_recv_method <= wait_for_recv_method_S_0042;
          when wait_for_recv_method_S_0048 => 
            wait_for_recv_method <= wait_for_recv_method_S_0003;
          when wait_for_recv_method_S_0049 => 
            wait_for_recv_method <= wait_for_recv_method_S_0000;
          when wait_for_recv_method_S_0008_body => 
            wait_for_recv_method <= wait_for_recv_method_S_0008_wait;
          when wait_for_recv_method_S_0008_wait => 
            if read_data_call_flag_0008 = '1' then
              wait_for_recv_method <= wait_for_recv_method_S_0009;
            end if;
          when wait_for_recv_method_S_0013_body => 
            wait_for_recv_method <= wait_for_recv_method_S_0013_wait;
          when wait_for_recv_method_S_0013_wait => 
            if read_data_call_flag_0013 = '1' then
              wait_for_recv_method <= wait_for_recv_method_S_0014;
            end if;
          when wait_for_recv_method_S_0018_body => 
            wait_for_recv_method <= wait_for_recv_method_S_0018_wait;
          when wait_for_recv_method_S_0018_wait => 
            if read_data_call_flag_0018 = '1' then
              wait_for_recv_method <= wait_for_recv_method_S_0019;
            end if;
          when wait_for_recv_method_S_0033_body => 
            wait_for_recv_method <= wait_for_recv_method_S_0033_wait;
          when wait_for_recv_method_S_0033_wait => 
            if read_data_call_flag_0033 = '1' then
              wait_for_recv_method <= wait_for_recv_method_S_0034;
            end if;
          when wait_for_recv_method_S_0045_body => 
            wait_for_recv_method <= wait_for_recv_method_S_0045_wait;
          when wait_for_recv_method_S_0045_wait => 
            if write_data_call_flag_0045 = '1' then
              wait_for_recv_method <= wait_for_recv_method_S_0046;
            end if;
          when others => null;
        end case;
        wait_for_recv_req_flag_d <= wait_for_recv_req_flag;
        if (tmp_0218 and tmp_0220) = '1' then
          wait_for_recv_method <= wait_for_recv_method_S_0001;
        end if;
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
          when pull_recv_data_method_S_0001 => 
            if tmp_0248 = '1' then
              pull_recv_data_method <= pull_recv_data_method_S_0002;
            end if;
          when pull_recv_data_method_S_0002 => 
            pull_recv_data_method <= pull_recv_data_method_S_0004;
          when pull_recv_data_method_S_0004 => 
            pull_recv_data_method <= pull_recv_data_method_S_0004_body;
          when pull_recv_data_method_S_0005 => 
            pull_recv_data_method <= pull_recv_data_method_S_0009;
          when pull_recv_data_method_S_0009 => 
            pull_recv_data_method <= pull_recv_data_method_S_0009_body;
          when pull_recv_data_method_S_0010 => 
            pull_recv_data_method <= pull_recv_data_method_S_0019;
          when pull_recv_data_method_S_0019 => 
            if tmp_0258 = '1' then
              pull_recv_data_method <= pull_recv_data_method_S_0021;
            elsif tmp_0259 = '1' then
              pull_recv_data_method <= pull_recv_data_method_S_0020;
            end if;
          when pull_recv_data_method_S_0020 => 
            pull_recv_data_method <= pull_recv_data_method_S_0024;
          when pull_recv_data_method_S_0021 => 
            pull_recv_data_method <= pull_recv_data_method_S_0023;
          when pull_recv_data_method_S_0023 => 
            pull_recv_data_method <= pull_recv_data_method_S_0020;
          when pull_recv_data_method_S_0024 => 
            pull_recv_data_method <= pull_recv_data_method_S_0025;
          when pull_recv_data_method_S_0025 => 
            pull_recv_data_method <= pull_recv_data_method_S_0026;
          when pull_recv_data_method_S_0026 => 
            if tmp_0260 = '1' then
              pull_recv_data_method <= pull_recv_data_method_S_0031;
            elsif tmp_0261 = '1' then
              pull_recv_data_method <= pull_recv_data_method_S_0027;
            end if;
          when pull_recv_data_method_S_0027 => 
            pull_recv_data_method <= pull_recv_data_method_S_0046;
          when pull_recv_data_method_S_0028 => 
            pull_recv_data_method <= pull_recv_data_method_S_0030;
          when pull_recv_data_method_S_0030 => 
            pull_recv_data_method <= pull_recv_data_method_S_0025;
          when pull_recv_data_method_S_0031 => 
            pull_recv_data_method <= pull_recv_data_method_S_0033;
          when pull_recv_data_method_S_0033 => 
            pull_recv_data_method <= pull_recv_data_method_S_0034;
          when pull_recv_data_method_S_0034 => 
            pull_recv_data_method <= pull_recv_data_method_S_0036;
          when pull_recv_data_method_S_0036 => 
            pull_recv_data_method <= pull_recv_data_method_S_0036_body;
          when pull_recv_data_method_S_0037 => 
            pull_recv_data_method <= pull_recv_data_method_S_0040;
          when pull_recv_data_method_S_0040 => 
            pull_recv_data_method <= pull_recv_data_method_S_0041;
          when pull_recv_data_method_S_0041 => 
            pull_recv_data_method <= pull_recv_data_method_S_0043;
          when pull_recv_data_method_S_0043 => 
            pull_recv_data_method <= pull_recv_data_method_S_0043_body;
          when pull_recv_data_method_S_0044 => 
            pull_recv_data_method <= pull_recv_data_method_S_0045;
          when pull_recv_data_method_S_0045 => 
            pull_recv_data_method <= pull_recv_data_method_S_0028;
          when pull_recv_data_method_S_0046 => 
            pull_recv_data_method <= pull_recv_data_method_S_0048;
          when pull_recv_data_method_S_0048 => 
            pull_recv_data_method <= pull_recv_data_method_S_0048_body;
          when pull_recv_data_method_S_0049 => 
            pull_recv_data_method <= pull_recv_data_method_S_0000;
          when pull_recv_data_method_S_0050 => 
            pull_recv_data_method <= pull_recv_data_method_S_0000;
          when pull_recv_data_method_S_0004_body => 
            pull_recv_data_method <= pull_recv_data_method_S_0004_wait;
          when pull_recv_data_method_S_0004_wait => 
            if read_data_call_flag_0004 = '1' then
              pull_recv_data_method <= pull_recv_data_method_S_0005;
            end if;
          when pull_recv_data_method_S_0009_body => 
            pull_recv_data_method <= pull_recv_data_method_S_0009_wait;
          when pull_recv_data_method_S_0009_wait => 
            if read_data_call_flag_0009 = '1' then
              pull_recv_data_method <= pull_recv_data_method_S_0010;
            end if;
          when pull_recv_data_method_S_0036_body => 
            pull_recv_data_method <= pull_recv_data_method_S_0036_wait;
          when pull_recv_data_method_S_0036_wait => 
            if read_data_call_flag_0036 = '1' then
              pull_recv_data_method <= pull_recv_data_method_S_0037;
            end if;
          when pull_recv_data_method_S_0043_body => 
            pull_recv_data_method <= pull_recv_data_method_S_0043_wait;
          when pull_recv_data_method_S_0043_wait => 
            if read_data_call_flag_0043 = '1' then
              pull_recv_data_method <= pull_recv_data_method_S_0044;
            end if;
          when pull_recv_data_method_S_0048_body => 
            pull_recv_data_method <= pull_recv_data_method_S_0048_wait;
          when pull_recv_data_method_S_0048_wait => 
            if write_data_call_flag_0048 = '1' then
              pull_recv_data_method <= pull_recv_data_method_S_0049;
            end if;
          when others => null;
        end case;
        pull_recv_data_req_flag_d <= pull_recv_data_req_flag;
        if (tmp_0274 and tmp_0276) = '1' then
          pull_recv_data_method <= pull_recv_data_method_S_0001;
        end if;
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
          when push_send_data_method_S_0001 => 
            if tmp_0304 = '1' then
              push_send_data_method <= push_send_data_method_S_0002;
            end if;
          when push_send_data_method_S_0002 => 
            push_send_data_method <= push_send_data_method_S_0006;
          when push_send_data_method_S_0006 => 
            if tmp_0306 = '1' then
              push_send_data_method <= push_send_data_method_S_0008;
            elsif tmp_0307 = '1' then
              push_send_data_method <= push_send_data_method_S_0007;
            end if;
          when push_send_data_method_S_0007 => 
            push_send_data_method <= push_send_data_method_S_0011;
          when push_send_data_method_S_0008 => 
            push_send_data_method <= push_send_data_method_S_0010;
          when push_send_data_method_S_0010 => 
            push_send_data_method <= push_send_data_method_S_0007;
          when push_send_data_method_S_0011 => 
            push_send_data_method <= push_send_data_method_S_0012;
          when push_send_data_method_S_0012 => 
            push_send_data_method <= push_send_data_method_S_0013;
          when push_send_data_method_S_0013 => 
            if tmp_0308 = '1' then
              push_send_data_method <= push_send_data_method_S_0018;
            elsif tmp_0309 = '1' then
              push_send_data_method <= push_send_data_method_S_0014;
            end if;
          when push_send_data_method_S_0014 => 
            push_send_data_method <= push_send_data_method_S_0033;
          when push_send_data_method_S_0015 => 
            push_send_data_method <= push_send_data_method_S_0017;
          when push_send_data_method_S_0017 => 
            push_send_data_method <= push_send_data_method_S_0012;
          when push_send_data_method_S_0018 => 
            push_send_data_method <= push_send_data_method_S_0020;
          when push_send_data_method_S_0020 => 
            if push_send_data_method_delay >= 2 then
              push_send_data_method_delay <= (others => '0');
              push_send_data_method <= push_send_data_method_S_0021;
            else
              push_send_data_method_delay <= push_send_data_method_delay + 1;
            end if;
          when push_send_data_method_S_0021 => 
            push_send_data_method <= push_send_data_method_S_0024;
          when push_send_data_method_S_0024 => 
            push_send_data_method <= push_send_data_method_S_0024_body;
          when push_send_data_method_S_0025 => 
            push_send_data_method <= push_send_data_method_S_0027;
          when push_send_data_method_S_0027 => 
            if push_send_data_method_delay >= 2 then
              push_send_data_method_delay <= (others => '0');
              push_send_data_method <= push_send_data_method_S_0028;
            else
              push_send_data_method_delay <= push_send_data_method_delay + 1;
            end if;
          when push_send_data_method_S_0028 => 
            push_send_data_method <= push_send_data_method_S_0031;
          when push_send_data_method_S_0031 => 
            push_send_data_method <= push_send_data_method_S_0031_body;
          when push_send_data_method_S_0032 => 
            push_send_data_method <= push_send_data_method_S_0015;
          when push_send_data_method_S_0033 => 
            push_send_data_method <= push_send_data_method_S_0035;
          when push_send_data_method_S_0035 => 
            push_send_data_method <= push_send_data_method_S_0035_body;
          when push_send_data_method_S_0036 => 
            push_send_data_method <= push_send_data_method_S_0040;
          when push_send_data_method_S_0040 => 
            push_send_data_method <= push_send_data_method_S_0040_body;
          when push_send_data_method_S_0041 => 
            push_send_data_method <= push_send_data_method_S_0045;
          when push_send_data_method_S_0045 => 
            push_send_data_method <= push_send_data_method_S_0045_body;
          when push_send_data_method_S_0046 => 
            push_send_data_method <= push_send_data_method_S_0050;
          when push_send_data_method_S_0050 => 
            push_send_data_method <= push_send_data_method_S_0050_body;
          when push_send_data_method_S_0051 => 
            push_send_data_method <= push_send_data_method_S_0053;
          when push_send_data_method_S_0053 => 
            push_send_data_method <= push_send_data_method_S_0053_body;
          when push_send_data_method_S_0054 => 
            push_send_data_method <= push_send_data_method_S_0000;
          when push_send_data_method_S_0024_body => 
            push_send_data_method <= push_send_data_method_S_0024_wait;
          when push_send_data_method_S_0024_wait => 
            if write_data_call_flag_0024 = '1' then
              push_send_data_method <= push_send_data_method_S_0025;
            end if;
          when push_send_data_method_S_0031_body => 
            push_send_data_method <= push_send_data_method_S_0031_wait;
          when push_send_data_method_S_0031_wait => 
            if write_data_call_flag_0031 = '1' then
              push_send_data_method <= push_send_data_method_S_0032;
            end if;
          when push_send_data_method_S_0035_body => 
            push_send_data_method <= push_send_data_method_S_0035_wait;
          when push_send_data_method_S_0035_wait => 
            if write_data_call_flag_0035 = '1' then
              push_send_data_method <= push_send_data_method_S_0036;
            end if;
          when push_send_data_method_S_0040_body => 
            push_send_data_method <= push_send_data_method_S_0040_wait;
          when push_send_data_method_S_0040_wait => 
            if write_data_call_flag_0040 = '1' then
              push_send_data_method <= push_send_data_method_S_0041;
            end if;
          when push_send_data_method_S_0045_body => 
            push_send_data_method <= push_send_data_method_S_0045_wait;
          when push_send_data_method_S_0045_wait => 
            if write_data_call_flag_0045 = '1' then
              push_send_data_method <= push_send_data_method_S_0046;
            end if;
          when push_send_data_method_S_0050_body => 
            push_send_data_method <= push_send_data_method_S_0050_wait;
          when push_send_data_method_S_0050_wait => 
            if write_data_call_flag_0050 = '1' then
              push_send_data_method <= push_send_data_method_S_0051;
            end if;
          when push_send_data_method_S_0053_body => 
            push_send_data_method <= push_send_data_method_S_0053_wait;
          when push_send_data_method_S_0053_wait => 
            if write_data_call_flag_0053 = '1' then
              push_send_data_method <= push_send_data_method_S_0054;
            end if;
          when others => null;
        end case;
        push_send_data_req_flag_d <= push_send_data_req_flag;
        if (tmp_0334 and tmp_0336) = '1' then
          push_send_data_method <= push_send_data_method_S_0001;
        end if;
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
          when tcp_server_method_S_0001 => 
            if tmp_0370 = '1' then
              tcp_server_method <= tcp_server_method_S_0002;
            end if;
          when tcp_server_method_S_0002 => 
            tcp_server_method <= tcp_server_method_S_0004;
          when tcp_server_method_S_0004 => 
            tcp_server_method <= tcp_server_method_S_0004_body;
          when tcp_server_method_S_0005 => 
            tcp_server_method <= tcp_server_method_S_0005_body;
          when tcp_server_method_S_0006 => 
            tcp_server_method <= tcp_server_method_S_0007;
          when tcp_server_method_S_0007 => 
            tcp_server_method <= tcp_server_method_S_0008;
          when tcp_server_method_S_0008 => 
            if tmp_0376 = '1' then
              tcp_server_method <= tcp_server_method_S_0010;
            elsif tmp_0377 = '1' then
              tcp_server_method <= tcp_server_method_S_0009;
            end if;
          when tcp_server_method_S_0009 => 
            tcp_server_method <= tcp_server_method_S_0016;
          when tcp_server_method_S_0010 => 
            tcp_server_method <= tcp_server_method_S_0012;
          when tcp_server_method_S_0012 => 
            tcp_server_method <= tcp_server_method_S_0012_body;
          when tcp_server_method_S_0013 => 
            tcp_server_method <= tcp_server_method_S_0013_body;
          when tcp_server_method_S_0014 => 
            tcp_server_method <= tcp_server_method_S_0015;
          when tcp_server_method_S_0015 => 
            tcp_server_method <= tcp_server_method_S_0007;
          when tcp_server_method_S_0016 => 
            tcp_server_method <= tcp_server_method_S_0017;
          when tcp_server_method_S_0017 => 
            tcp_server_method <= tcp_server_method_S_0018;
          when tcp_server_method_S_0018 => 
            tcp_server_method <= tcp_server_method_S_0018_body;
          when tcp_server_method_S_0019 => 
            tcp_server_method <= tcp_server_method_S_0020;
          when tcp_server_method_S_0020 => 
            tcp_server_method <= tcp_server_method_S_0021;
          when tcp_server_method_S_0021 => 
            if tmp_0386 = '1' then
              tcp_server_method <= tcp_server_method_S_0023;
            elsif tmp_0387 = '1' then
              tcp_server_method <= tcp_server_method_S_0022;
            end if;
          when tcp_server_method_S_0022 => 
            tcp_server_method <= tcp_server_method_S_0029;
          when tcp_server_method_S_0023 => 
            tcp_server_method <= tcp_server_method_S_0025;
          when tcp_server_method_S_0025 => 
            tcp_server_method <= tcp_server_method_S_0025_body;
          when tcp_server_method_S_0026 => 
            tcp_server_method <= tcp_server_method_S_0026_body;
          when tcp_server_method_S_0027 => 
            tcp_server_method <= tcp_server_method_S_0028;
          when tcp_server_method_S_0028 => 
            tcp_server_method <= tcp_server_method_S_0020;
          when tcp_server_method_S_0029 => 
            tcp_server_method <= tcp_server_method_S_0029_body;
          when tcp_server_method_S_0030 => 
            tcp_server_method <= tcp_server_method_S_0032;
          when tcp_server_method_S_0032 => 
            tcp_server_method <= tcp_server_method_S_0033;
          when tcp_server_method_S_0033 => 
            tcp_server_method <= tcp_server_method_S_0033_body;
          when tcp_server_method_S_0034 => 
            tcp_server_method <= tcp_server_method_S_0035;
          when tcp_server_method_S_0035 => 
            tcp_server_method <= tcp_server_method_S_0036;
          when tcp_server_method_S_0036 => 
            if tmp_0400 = '1' then
              tcp_server_method <= tcp_server_method_S_0038;
            elsif tmp_0401 = '1' then
              tcp_server_method <= tcp_server_method_S_0037;
            end if;
          when tcp_server_method_S_0037 => 
            tcp_server_method <= tcp_server_method_S_0051;
          when tcp_server_method_S_0038 => 
            tcp_server_method <= tcp_server_method_S_0038_body;
          when tcp_server_method_S_0039 => 
            tcp_server_method <= tcp_server_method_S_0041;
          when tcp_server_method_S_0041 => 
            if tmp_0406 = '1' then
              tcp_server_method <= tcp_server_method_S_0043;
            elsif tmp_0407 = '1' then
              tcp_server_method <= tcp_server_method_S_0042;
            end if;
          when tcp_server_method_S_0042 => 
            tcp_server_method <= tcp_server_method_S_0045;
          when tcp_server_method_S_0043 => 
            tcp_server_method <= tcp_server_method_S_0037;
          when tcp_server_method_S_0044 => 
            tcp_server_method <= tcp_server_method_S_0042;
          when tcp_server_method_S_0045 => 
            tcp_server_method <= tcp_server_method_S_0046;
          when tcp_server_method_S_0046 => 
            tcp_server_method <= tcp_server_method_S_0046_body;
          when tcp_server_method_S_0047 => 
            tcp_server_method <= tcp_server_method_S_0048;
          when tcp_server_method_S_0048 => 
            tcp_server_method <= tcp_server_method_S_0049;
          when tcp_server_method_S_0049 => 
            tcp_server_method <= tcp_server_method_S_0049_body;
          when tcp_server_method_S_0050 => 
            tcp_server_method <= tcp_server_method_S_0036;
          when tcp_server_method_S_0051 => 
            tcp_server_method <= tcp_server_method_S_0000;
          when tcp_server_method_S_0004_body => 
            tcp_server_method <= tcp_server_method_S_0004_wait;
          when tcp_server_method_S_0004_wait => 
            if write_data_call_flag_0004 = '1' then
              tcp_server_method <= tcp_server_method_S_0005;
            end if;
          when tcp_server_method_S_0005_body => 
            tcp_server_method <= tcp_server_method_S_0005_wait;
          when tcp_server_method_S_0005_wait => 
            if tcp_server_open_call_flag_0005 = '1' then
              tcp_server_method <= tcp_server_method_S_0006;
            end if;
          when tcp_server_method_S_0012_body => 
            tcp_server_method <= tcp_server_method_S_0012_wait;
          when tcp_server_method_S_0012_wait => 
            if write_data_call_flag_0012 = '1' then
              tcp_server_method <= tcp_server_method_S_0013;
            end if;
          when tcp_server_method_S_0013_body => 
            tcp_server_method <= tcp_server_method_S_0013_wait;
          when tcp_server_method_S_0013_wait => 
            if tcp_server_open_call_flag_0013 = '1' then
              tcp_server_method <= tcp_server_method_S_0014;
            end if;
          when tcp_server_method_S_0018_body => 
            tcp_server_method <= tcp_server_method_S_0018_wait;
          when tcp_server_method_S_0018_wait => 
            if tcp_server_listen_call_flag_0018 = '1' then
              tcp_server_method <= tcp_server_method_S_0019;
            end if;
          when tcp_server_method_S_0025_body => 
            tcp_server_method <= tcp_server_method_S_0025_wait;
          when tcp_server_method_S_0025_wait => 
            if write_data_call_flag_0025 = '1' then
              tcp_server_method <= tcp_server_method_S_0026;
            end if;
          when tcp_server_method_S_0026_body => 
            tcp_server_method <= tcp_server_method_S_0026_wait;
          when tcp_server_method_S_0026_wait => 
            if tcp_server_listen_call_flag_0026 = '1' then
              tcp_server_method <= tcp_server_method_S_0027;
            end if;
          when tcp_server_method_S_0029_body => 
            tcp_server_method <= tcp_server_method_S_0029_wait;
          when tcp_server_method_S_0029_wait => 
            if wait_for_established_call_flag_0029 = '1' then
              tcp_server_method <= tcp_server_method_S_0030;
            end if;
          when tcp_server_method_S_0033_body => 
            tcp_server_method <= tcp_server_method_S_0033_wait;
          when tcp_server_method_S_0033_wait => 
            if read_data_call_flag_0033 = '1' then
              tcp_server_method <= tcp_server_method_S_0034;
            end if;
          when tcp_server_method_S_0038_body => 
            tcp_server_method <= tcp_server_method_S_0038_wait;
          when tcp_server_method_S_0038_wait => 
            if wait_for_recv_call_flag_0038 = '1' then
              tcp_server_method <= tcp_server_method_S_0039;
            end if;
          when tcp_server_method_S_0046_body => 
            tcp_server_method <= tcp_server_method_S_0046_wait;
          when tcp_server_method_S_0046_wait => 
            if pull_recv_data_call_flag_0046 = '1' then
              tcp_server_method <= tcp_server_method_S_0047;
            end if;
          when tcp_server_method_S_0049_body => 
            tcp_server_method <= tcp_server_method_S_0049_wait;
          when tcp_server_method_S_0049_wait => 
            if push_send_data_call_flag_0049 = '1' then
              tcp_server_method <= tcp_server_method_S_0050;
            end if;
          when others => null;
        end case;
        tcp_server_req_flag_d <= tcp_server_req_flag;
        if (tmp_0416 and tmp_0418) = '1' then
          tcp_server_method <= tcp_server_method_S_0001;
        end if;
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
          when test_method_S_0001 => 
            if tmp_0435 = '1' then
              test_method <= test_method_S_0002;
            end if;
          when test_method_S_0002 => 
            test_method <= test_method_S_0003;
          when test_method_S_0003 => 
            test_method <= test_method_S_0003_body;
          when test_method_S_0004 => 
            test_method <= test_method_S_0005;
          when test_method_S_0005 => 
            test_method <= test_method_S_0005_body;
          when test_method_S_0006 => 
            test_method <= test_method_S_0007;
          when test_method_S_0007 => 
            test_method <= test_method_S_0008;
          when test_method_S_0008 => 
            if tmp_0445 = '1' then
              test_method <= test_method_S_0010;
            elsif tmp_0446 = '1' then
              test_method <= test_method_S_0009;
            end if;
          when test_method_S_0009 => 
            test_method <= test_method_S_0012;
          when test_method_S_0010 => 
            test_method <= test_method_S_0010_body;
          when test_method_S_0011 => 
            test_method <= test_method_S_0008;
          when test_method_S_0012 => 
            test_method <= test_method_S_0000;
          when test_method_S_0003_body => 
            test_method <= test_method_S_0003_wait;
          when test_method_S_0003_wait => 
            if init_call_flag_0003 = '1' then
              test_method <= test_method_S_0004;
            end if;
          when test_method_S_0005_body => 
            test_method <= test_method_S_0005_wait;
          when test_method_S_0005_wait => 
            if network_configuration_call_flag_0005 = '1' then
              test_method <= test_method_S_0006;
            end if;
          when test_method_S_0010_body => 
            test_method <= test_method_S_0010_wait;
          when test_method_S_0010_wait => 
            if tcp_server_call_flag_0010 = '1' then
              test_method <= test_method_S_0011;
            end if;
          when others => null;
        end case;
        test_req_flag_d <= test_req_flag;
        if (tmp_0451 and tmp_0453) = '1' then
          test_method <= test_method_S_0001;
        end if;
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
          when blink_led_method_S_0001 => 
            if tmp_0457 = '1' then
              blink_led_method <= blink_led_method_S_0002;
            end if;
          when blink_led_method_S_0002 => 
            blink_led_method <= blink_led_method_S_0000;
          when others => null;
        end case;
        blink_led_req_flag_d <= blink_led_req_flag;
        if (tmp_0459 and tmp_0461) = '1' then
          blink_led_method <= blink_led_method_S_0001;
        end if;
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

  class_wiz830mj_0000_nINT <= class_wiz830mj_0000_nINT_exp_sig;

  class_wiz830mj_0000_BRDY <= class_wiz830mj_0000_BRDY_exp_sig;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_led_0002 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0017 then
          class_led_0002 <= cast_expr_00294;
        elsif tcp_server_method = tcp_server_method_S_0030 then
          class_led_0002 <= X"00000000";
        elsif tcp_server_method = tcp_server_method_S_0035 then
          class_led_0002 <= cast_expr_00305;
        elsif tcp_server_method = tcp_server_method_S_0045 then
          class_led_0002 <= tcp_server_len_0306;
        elsif tcp_server_method = tcp_server_method_S_0048 then
          class_led_0002 <= tcp_server_len_0306;
        elsif test_method = test_method_S_0002 then
          class_led_0002 <= X"00000000";
        elsif test_method = test_method_S_0004 then
          class_led_0002 <= X"00000001";
        elsif test_method = test_method_S_0006 then
          class_led_0002 <= X"00000003";
        elsif test_method = test_method_S_0007 then
          class_led_0002 <= X"000000ff";
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
        if pull_recv_data_method = pull_recv_data_method_S_0033 then
          class_buffer_0088_address_b <= binary_expr_00225;
        elsif pull_recv_data_method = pull_recv_data_method_S_0040 then
          class_buffer_0088_address_b <= binary_expr_00231;
        elsif push_send_data_method = push_send_data_method_S_0020 and push_send_data_method_delay = 0 then
          class_buffer_0088_address_b <= binary_expr_00251;
        elsif push_send_data_method = push_send_data_method_S_0027 and push_send_data_method_delay = 0 then
          class_buffer_0088_address_b <= binary_expr_00257;
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
        if pull_recv_data_method = pull_recv_data_method_S_0037 then
          class_buffer_0088_din_b <= method_result_00227;
        elsif pull_recv_data_method = pull_recv_data_method_S_0044 then
          class_buffer_0088_din_b <= method_result_00233;
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
        if pull_recv_data_method = pull_recv_data_method_S_0037 then
          class_buffer_0088_we_b <= '1';
        elsif pull_recv_data_method = pull_recv_data_method_S_0044 then
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
        if write_data_method = write_data_method_S_0010_body and write_data_method_delay = 0 then
          wait_cycles_n_local <= X"00000003";
        elsif read_data_method = read_data_method_S_0008_body and read_data_method_delay = 0 then
          wait_cycles_n_local <= X"00000005";
        elsif init_method = init_method_S_0010_body and init_method_delay = 0 then
          wait_cycles_n_local <= X"000003e8";
        elsif init_method = init_method_S_0013_body and init_method_delay = 0 then
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
        elsif wait_cycles_method = wait_cycles_method_S_0006 then
          wait_cycles_i_0090 <= tmp_0015;
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
          binary_expr_00091 <= tmp_0014;
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
          unary_expr_00092 <= tmp_0015;
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
        if network_configuration_method = network_configuration_method_S_0002_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"00000008";
        elsif network_configuration_method = network_configuration_method_S_0003_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"00000009";
        elsif network_configuration_method = network_configuration_method_S_0004_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"0000000a";
        elsif network_configuration_method = network_configuration_method_S_0005_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"0000000b";
        elsif network_configuration_method = network_configuration_method_S_0006_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"0000000c";
        elsif network_configuration_method = network_configuration_method_S_0007_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"0000000d";
        elsif network_configuration_method = network_configuration_method_S_0008_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"00000010";
        elsif network_configuration_method = network_configuration_method_S_0009_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"00000011";
        elsif network_configuration_method = network_configuration_method_S_0010_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"00000012";
        elsif network_configuration_method = network_configuration_method_S_0011_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"00000013";
        elsif network_configuration_method = network_configuration_method_S_0012_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"00000014";
        elsif network_configuration_method = network_configuration_method_S_0013_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"00000015";
        elsif network_configuration_method = network_configuration_method_S_0014_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"00000016";
        elsif network_configuration_method = network_configuration_method_S_0015_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"00000017";
        elsif network_configuration_method = network_configuration_method_S_0016_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"00000018";
        elsif network_configuration_method = network_configuration_method_S_0017_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"00000019";
        elsif network_configuration_method = network_configuration_method_S_0018_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"0000001a";
        elsif network_configuration_method = network_configuration_method_S_0019_body and network_configuration_method_delay = 0 then
          write_data_addr_local <= X"0000001b";
        elsif tcp_server_open_method = tcp_server_open_method_S_0007_body and tcp_server_open_method_delay = 0 then
          write_data_addr_local <= binary_expr_00139;
        elsif tcp_server_open_method = tcp_server_open_method_S_0010_body and tcp_server_open_method_delay = 0 then
          write_data_addr_local <= binary_expr_00145;
        elsif tcp_server_open_method = tcp_server_open_method_S_0013_body and tcp_server_open_method_delay = 0 then
          write_data_addr_local <= binary_expr_00148;
        elsif tcp_server_open_method = tcp_server_open_method_S_0016_body and tcp_server_open_method_delay = 0 then
          write_data_addr_local <= binary_expr_00151;
        elsif tcp_server_listen_method = tcp_server_listen_method_S_0004_body and tcp_server_listen_method_delay = 0 then
          write_data_addr_local <= binary_expr_00158;
        elsif wait_for_recv_method = wait_for_recv_method_S_0045_body and wait_for_recv_method_delay = 0 then
          write_data_addr_local <= binary_expr_00201;
        elsif pull_recv_data_method = pull_recv_data_method_S_0048_body and pull_recv_data_method_delay = 0 then
          write_data_addr_local <= binary_expr_00238;
        elsif push_send_data_method = push_send_data_method_S_0024_body and push_send_data_method_delay = 0 then
          write_data_addr_local <= binary_expr_00255;
        elsif push_send_data_method = push_send_data_method_S_0031_body and push_send_data_method_delay = 0 then
          write_data_addr_local <= binary_expr_00261;
        elsif push_send_data_method = push_send_data_method_S_0035_body and push_send_data_method_delay = 0 then
          write_data_addr_local <= binary_expr_00264;
        elsif push_send_data_method = push_send_data_method_S_0040_body and push_send_data_method_delay = 0 then
          write_data_addr_local <= binary_expr_00267;
        elsif push_send_data_method = push_send_data_method_S_0045_body and push_send_data_method_delay = 0 then
          write_data_addr_local <= binary_expr_00272;
        elsif push_send_data_method = push_send_data_method_S_0050_body and push_send_data_method_delay = 0 then
          write_data_addr_local <= binary_expr_00277;
        elsif push_send_data_method = push_send_data_method_S_0053_body and push_send_data_method_delay = 0 then
          write_data_addr_local <= binary_expr_00282;
        elsif tcp_server_method = tcp_server_method_S_0004_body and tcp_server_method_delay = 0 then
          write_data_addr_local <= binary_expr_00286;
        elsif tcp_server_method = tcp_server_method_S_0012_body and tcp_server_method_delay = 0 then
          write_data_addr_local <= binary_expr_00292;
        elsif tcp_server_method = tcp_server_method_S_0025_body and tcp_server_method_delay = 0 then
          write_data_addr_local <= binary_expr_00299;
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
        if network_configuration_method = network_configuration_method_S_0002_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"00";
        elsif network_configuration_method = network_configuration_method_S_0003_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"08";
        elsif network_configuration_method = network_configuration_method_S_0004_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"dc";
        elsif network_configuration_method = network_configuration_method_S_0005_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"01";
        elsif network_configuration_method = network_configuration_method_S_0006_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"02";
        elsif network_configuration_method = network_configuration_method_S_0007_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"03";
        elsif network_configuration_method = network_configuration_method_S_0008_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"0a";
        elsif network_configuration_method = network_configuration_method_S_0009_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"00";
        elsif network_configuration_method = network_configuration_method_S_0010_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"00";
        elsif network_configuration_method = network_configuration_method_S_0011_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"01";
        elsif network_configuration_method = network_configuration_method_S_0012_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"ff";
        elsif network_configuration_method = network_configuration_method_S_0013_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"00";
        elsif network_configuration_method = network_configuration_method_S_0014_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"00";
        elsif network_configuration_method = network_configuration_method_S_0015_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"00";
        elsif network_configuration_method = network_configuration_method_S_0016_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"0a";
        elsif network_configuration_method = network_configuration_method_S_0017_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"00";
        elsif network_configuration_method = network_configuration_method_S_0018_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"00";
        elsif network_configuration_method = network_configuration_method_S_0019_body and network_configuration_method_delay = 0 then
          write_data_data_local <= X"02";
        elsif tcp_server_open_method = tcp_server_open_method_S_0007_body and tcp_server_open_method_delay = 0 then
          write_data_data_local <= cast_expr_00142;
        elsif tcp_server_open_method = tcp_server_open_method_S_0010_body and tcp_server_open_method_delay = 0 then
          write_data_data_local <= X"00";
        elsif tcp_server_open_method = tcp_server_open_method_S_0013_body and tcp_server_open_method_delay = 0 then
          write_data_data_local <= X"50";
        elsif tcp_server_open_method = tcp_server_open_method_S_0016_body and tcp_server_open_method_delay = 0 then
          write_data_data_local <= class_Sn_CR_OPEN_0059;
        elsif tcp_server_listen_method = tcp_server_listen_method_S_0004_body and tcp_server_listen_method_delay = 0 then
          write_data_data_local <= class_Sn_CR_LISTEN_0060;
        elsif wait_for_recv_method = wait_for_recv_method_S_0045_body and wait_for_recv_method_delay = 0 then
          write_data_data_local <= class_Sn_CR_DISCON_0062;
        elsif pull_recv_data_method = pull_recv_data_method_S_0048_body and pull_recv_data_method_delay = 0 then
          write_data_data_local <= class_Sn_CR_RECV_0067;
        elsif push_send_data_method = push_send_data_method_S_0024_body and push_send_data_method_delay = 0 then
          write_data_data_local <= push_send_data_v_0249;
        elsif push_send_data_method = push_send_data_method_S_0031_body and push_send_data_method_delay = 0 then
          write_data_data_local <= push_send_data_v_0249;
        elsif push_send_data_method = push_send_data_method_S_0035_body and push_send_data_method_delay = 0 then
          write_data_data_local <= class_Sn_CR_RECV_0067;
        elsif push_send_data_method = push_send_data_method_S_0040_body and push_send_data_method_delay = 0 then
          write_data_data_local <= cast_expr_00269;
        elsif push_send_data_method = push_send_data_method_S_0045_body and push_send_data_method_delay = 0 then
          write_data_data_local <= cast_expr_00274;
        elsif push_send_data_method = push_send_data_method_S_0050_body and push_send_data_method_delay = 0 then
          write_data_data_local <= cast_expr_00279;
        elsif push_send_data_method = push_send_data_method_S_0053_body and push_send_data_method_delay = 0 then
          write_data_data_local <= class_Sn_CR_SEND_0064;
        elsif tcp_server_method = tcp_server_method_S_0004_body and tcp_server_method_delay = 0 then
          write_data_data_local <= X"00";
        elsif tcp_server_method = tcp_server_method_S_0012_body and tcp_server_method_delay = 0 then
          write_data_data_local <= class_Sn_CR_CLOSE_0063;
        elsif tcp_server_method = tcp_server_method_S_0025_body and tcp_server_method_delay = 0 then
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
        if tcp_server_open_method = tcp_server_open_method_S_0019_body and tcp_server_open_method_delay = 0 then
          read_data_addr_local <= binary_expr_00154;
        elsif tcp_server_listen_method = tcp_server_listen_method_S_0007_body and tcp_server_listen_method_delay = 0 then
          read_data_addr_local <= binary_expr_00161;
        elsif wait_for_established_method = wait_for_established_method_S_0007_body and wait_for_established_method_delay = 0 then
          read_data_addr_local <= binary_expr_00166;
        elsif wait_for_recv_method = wait_for_recv_method_S_0008_body and wait_for_recv_method_delay = 0 then
          read_data_addr_local <= binary_expr_00173;
        elsif wait_for_recv_method = wait_for_recv_method_S_0013_body and wait_for_recv_method_delay = 0 then
          read_data_addr_local <= binary_expr_00178;
        elsif wait_for_recv_method = wait_for_recv_method_S_0018_body and wait_for_recv_method_delay = 0 then
          read_data_addr_local <= binary_expr_00183;
        elsif wait_for_recv_method = wait_for_recv_method_S_0033_body and wait_for_recv_method_delay = 0 then
          read_data_addr_local <= binary_expr_00192;
        elsif pull_recv_data_method = pull_recv_data_method_S_0004_body and pull_recv_data_method_delay = 0 then
          read_data_addr_local <= binary_expr_00206;
        elsif pull_recv_data_method = pull_recv_data_method_S_0009_body and pull_recv_data_method_delay = 0 then
          read_data_addr_local <= binary_expr_00211;
        elsif pull_recv_data_method = pull_recv_data_method_S_0036_body and pull_recv_data_method_delay = 0 then
          read_data_addr_local <= binary_expr_00229;
        elsif pull_recv_data_method = pull_recv_data_method_S_0043_body and pull_recv_data_method_delay = 0 then
          read_data_addr_local <= binary_expr_00235;
        elsif tcp_server_method = tcp_server_method_S_0033_body and tcp_server_method_delay = 0 then
          read_data_addr_local <= binary_expr_00304;
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
        if tcp_server_method = tcp_server_method_S_0005_body and tcp_server_method_delay = 0 then
          tcp_server_open_port_local <= tcp_server_port_0283;
        elsif tcp_server_method = tcp_server_method_S_0013_body and tcp_server_method_delay = 0 then
          tcp_server_open_port_local <= tcp_server_port_0283;
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
          binary_expr_00138 <= tmp_0144;
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
        if tcp_server_open_method = tcp_server_open_method_S_0002 then
          binary_expr_00139 <= tmp_0146;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00140 <= (others => '0');
      else
        if tcp_server_open_method = tcp_server_open_method_S_0002 then
          cast_expr_00140 <= tmp_0145;
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
        if tcp_server_open_method = tcp_server_open_method_S_0002 then
          binary_expr_00141 <= tmp_0147;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00142 <= (others => '0');
      else
        if tcp_server_open_method = tcp_server_open_method_S_0002 then
          cast_expr_00142 <= tmp_0148;
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
          binary_expr_00144 <= tmp_0149;
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
        if tcp_server_open_method = tcp_server_open_method_S_0008 then
          binary_expr_00145 <= tmp_0150;
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
          binary_expr_00147 <= tmp_0151;
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
        if tcp_server_open_method = tcp_server_open_method_S_0011 then
          binary_expr_00148 <= tmp_0152;
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
          binary_expr_00150 <= tmp_0153;
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
        if tcp_server_open_method = tcp_server_open_method_S_0014 then
          binary_expr_00151 <= tmp_0154;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00152 <= (others => '0');
      else
        if tcp_server_open_method = tcp_server_open_method_S_0019_wait then
          method_result_00152 <= read_data_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00153 <= (others => '0');
      else
        if tcp_server_open_method = tcp_server_open_method_S_0017 then
          binary_expr_00153 <= tmp_0155;
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
        if tcp_server_open_method = tcp_server_open_method_S_0017 then
          binary_expr_00154 <= tmp_0156;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_listen_port_0155 <= (others => '0');
      else
        if tcp_server_listen_method = tcp_server_listen_method_S_0001 then
          tcp_server_listen_port_0155 <= tcp_server_listen_port_local;
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
        if tcp_server_method = tcp_server_method_S_0018_body and tcp_server_method_delay = 0 then
          tcp_server_listen_port_local <= tcp_server_port_0283;
        elsif tcp_server_method = tcp_server_method_S_0026_body and tcp_server_method_delay = 0 then
          tcp_server_listen_port_local <= tcp_server_port_0283;
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
        if tcp_server_listen_method = tcp_server_listen_method_S_0002 then
          binary_expr_00157 <= tmp_0169;
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
        if tcp_server_listen_method = tcp_server_listen_method_S_0002 then
          binary_expr_00158 <= tmp_0170;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00159 <= (others => '0');
      else
        if tcp_server_listen_method = tcp_server_listen_method_S_0007_wait then
          method_result_00159 <= read_data_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00160 <= (others => '0');
      else
        if tcp_server_listen_method = tcp_server_listen_method_S_0005 then
          binary_expr_00160 <= tmp_0171;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00161 <= (others => '0');
      else
        if tcp_server_listen_method = tcp_server_listen_method_S_0005 then
          binary_expr_00161 <= tmp_0172;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_established_port_0162 <= (others => '0');
      else
        if wait_for_established_method = wait_for_established_method_S_0001 then
          wait_for_established_port_0162 <= wait_for_established_port_local;
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
        if tcp_server_method = tcp_server_method_S_0029_body and tcp_server_method_delay = 0 then
          wait_for_established_port_local <= tcp_server_port_0283;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_established_v_0163 <= X"00";
      else
        if wait_for_established_method = wait_for_established_method_S_0002 then
          wait_for_established_v_0163 <= X"00";
        elsif wait_for_established_method = wait_for_established_method_S_0008 then
          wait_for_established_v_0163 <= method_result_00164;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00164 <= (others => '0');
      else
        if wait_for_established_method = wait_for_established_method_S_0007_wait then
          method_result_00164 <= read_data_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00165 <= (others => '0');
      else
        if wait_for_established_method = wait_for_established_method_S_0005 then
          binary_expr_00165 <= tmp_0185;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00166 <= (others => '0');
      else
        if wait_for_established_method = wait_for_established_method_S_0005 then
          binary_expr_00166 <= tmp_0186;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00167 <= '0';
      else
        if wait_for_established_method = wait_for_established_method_S_0008 then
          binary_expr_00167 <= tmp_0187;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_recv_port_0168 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0001 then
          wait_for_recv_port_0168 <= wait_for_recv_port_local;
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
        if tcp_server_method = tcp_server_method_S_0038_body and tcp_server_method_delay = 0 then
          wait_for_recv_port_local <= tcp_server_port_0283;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_recv_v_0169 <= X"00000000";
      else
        if wait_for_recv_method = wait_for_recv_method_S_0002 then
          wait_for_recv_v_0169 <= X"00000000";
        elsif wait_for_recv_method = wait_for_recv_method_S_0005 then
          wait_for_recv_v_0169 <= X"00000000";
        elsif wait_for_recv_method = wait_for_recv_method_S_0019 then
          wait_for_recv_v_0169 <= tmp_0234;
        elsif wait_for_recv_method = wait_for_recv_method_S_0034 then
          wait_for_recv_v_0169 <= tmp_0238;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_recv_v0_0170 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0009 then
          wait_for_recv_v0_0170 <= tmp_0224;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00171 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0008_wait then
          method_result_00171 <= read_data_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00172 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0005 then
          binary_expr_00172 <= tmp_0222;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00173 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0005 then
          binary_expr_00173 <= tmp_0223;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00174 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0009 then
          cast_expr_00174 <= tmp_0224;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_recv_v1_0175 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0014 then
          wait_for_recv_v1_0175 <= tmp_0227;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00176 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0013_wait then
          method_result_00176 <= read_data_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00177 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0009 then
          binary_expr_00177 <= tmp_0225;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00178 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0009 then
          binary_expr_00178 <= tmp_0226;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00179 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0014 then
          cast_expr_00179 <= tmp_0227;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_recv_v2_0180 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0019 then
          wait_for_recv_v2_0180 <= tmp_0230;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00181 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0018_wait then
          method_result_00181 <= read_data_return;
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
        if wait_for_recv_method = wait_for_recv_method_S_0014 then
          binary_expr_00182 <= tmp_0228;
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
        if wait_for_recv_method = wait_for_recv_method_S_0014 then
          binary_expr_00183 <= tmp_0229;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00184 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0019 then
          cast_expr_00184 <= tmp_0230;
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
        if wait_for_recv_method = wait_for_recv_method_S_0019 then
          binary_expr_00185 <= tmp_0231;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00186 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0019 then
          binary_expr_00186 <= tmp_0232;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00187 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0019 then
          binary_expr_00187 <= tmp_0233;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00188 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0019 then
          binary_expr_00188 <= tmp_0234;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00189 <= '0';
      else
        if wait_for_recv_method = wait_for_recv_method_S_0019 then
          binary_expr_00189 <= tmp_0235;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00190 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0033_wait then
          method_result_00190 <= read_data_return;
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
        if wait_for_recv_method = wait_for_recv_method_S_0031 then
          binary_expr_00191 <= tmp_0236;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00192 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0031 then
          binary_expr_00192 <= tmp_0237;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00193 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0034 then
          cast_expr_00193 <= tmp_0238;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00194 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0034 then
          cast_expr_00194 <= tmp_0239;
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
        if wait_for_recv_method = wait_for_recv_method_S_0034 then
          binary_expr_00195 <= tmp_0241;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00196 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0034 then
          cast_expr_00196 <= tmp_0240;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00197 <= '0';
      else
        if wait_for_recv_method = wait_for_recv_method_S_0034 then
          binary_expr_00197 <= tmp_0242;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00198 <= '0';
      else
        if wait_for_recv_method = wait_for_recv_method_S_0034 then
          binary_expr_00198 <= tmp_0243;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00200 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0043 then
          binary_expr_00200 <= tmp_0244;
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
        if wait_for_recv_method = wait_for_recv_method_S_0043 then
          binary_expr_00201 <= tmp_0245;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pull_recv_data_port_0202 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0001 then
          pull_recv_data_port_0202 <= pull_recv_data_port_local;
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
        if tcp_server_method = tcp_server_method_S_0046_body and tcp_server_method_delay = 0 then
          pull_recv_data_port_local <= tcp_server_port_0283;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pull_recv_data_v0_0203 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0005 then
          pull_recv_data_v0_0203 <= tmp_0280;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00204 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0004_wait then
          method_result_00204 <= read_data_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00205 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0002 then
          binary_expr_00205 <= tmp_0278;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00206 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0002 then
          binary_expr_00206 <= tmp_0279;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00207 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0005 then
          cast_expr_00207 <= tmp_0280;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pull_recv_data_v1_0208 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0010 then
          pull_recv_data_v1_0208 <= tmp_0283;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00209 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0009_wait then
          method_result_00209 <= read_data_return;
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
        if pull_recv_data_method = pull_recv_data_method_S_0005 then
          binary_expr_00210 <= tmp_0281;
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
        if pull_recv_data_method = pull_recv_data_method_S_0005 then
          binary_expr_00211 <= tmp_0282;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00212 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0010 then
          cast_expr_00212 <= tmp_0283;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pull_recv_data_actual_len_0213 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0010 then
          pull_recv_data_actual_len_0213 <= tmp_0285;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00214 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0010 then
          binary_expr_00214 <= tmp_0284;
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
        if pull_recv_data_method = pull_recv_data_method_S_0010 then
          binary_expr_00215 <= tmp_0285;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pull_recv_data_read_len_0216 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0010 then
          pull_recv_data_read_len_0216 <= tmp_0286;
        elsif pull_recv_data_method = pull_recv_data_method_S_0021 then
          pull_recv_data_read_len_0216 <= tmp_0289;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00217 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0010 then
          binary_expr_00217 <= tmp_0286;
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
        if pull_recv_data_method = pull_recv_data_method_S_0010 then
          binary_expr_00218 <= tmp_0287;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00219 <= '0';
      else
        if pull_recv_data_method = pull_recv_data_method_S_0010 then
          binary_expr_00219 <= tmp_0288;
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
        if pull_recv_data_method = pull_recv_data_method_S_0046 then
          binary_expr_00237 <= tmp_0300;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00238 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0046 then
          binary_expr_00238 <= tmp_0301;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00220 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0021 then
          binary_expr_00220 <= tmp_0289;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pull_recv_data_i_0221 <= X"00000000";
      else
        if pull_recv_data_method = pull_recv_data_method_S_0024 then
          pull_recv_data_i_0221 <= X"00000000";
        elsif pull_recv_data_method = pull_recv_data_method_S_0028 then
          pull_recv_data_i_0221 <= tmp_0291;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00222 <= '0';
      else
        if pull_recv_data_method = pull_recv_data_method_S_0025 then
          binary_expr_00222 <= tmp_0290;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        unary_expr_00223 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0028 then
          unary_expr_00223 <= tmp_0291;
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
        if pull_recv_data_method = pull_recv_data_method_S_0031 then
          binary_expr_00224 <= tmp_0292;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00225 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0031 then
          binary_expr_00225 <= tmp_0293;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00227 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0036_wait then
          method_result_00227 <= read_data_return;
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
        if pull_recv_data_method = pull_recv_data_method_S_0034 then
          binary_expr_00228 <= tmp_0294;
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
        if pull_recv_data_method = pull_recv_data_method_S_0034 then
          binary_expr_00229 <= tmp_0295;
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
        if pull_recv_data_method = pull_recv_data_method_S_0037 then
          binary_expr_00230 <= tmp_0296;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00231 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0037 then
          binary_expr_00231 <= tmp_0297;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00233 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0043_wait then
          method_result_00233 <= read_data_return;
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
        if pull_recv_data_method = pull_recv_data_method_S_0041 then
          binary_expr_00234 <= tmp_0298;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00235 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0041 then
          binary_expr_00235 <= tmp_0299;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        push_send_data_port_0239 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0001 then
          push_send_data_port_0239 <= push_send_data_port_local;
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
        if tcp_server_method = tcp_server_method_S_0049_body and tcp_server_method_delay = 0 then
          push_send_data_port_local <= tcp_server_port_0283;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        push_send_data_len_0240 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0001 then
          push_send_data_len_0240 <= push_send_data_len_local;
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
        if tcp_server_method = tcp_server_method_S_0049_body and tcp_server_method_delay = 0 then
          push_send_data_len_local <= tcp_server_len_0306;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        push_send_data_write_len_0241 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0002 then
          push_send_data_write_len_0241 <= tmp_0338;
        elsif push_send_data_method = push_send_data_method_S_0008 then
          push_send_data_write_len_0241 <= tmp_0341;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00242 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0002 then
          binary_expr_00242 <= tmp_0338;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00243 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0002 then
          binary_expr_00243 <= tmp_0339;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00244 <= '0';
      else
        if push_send_data_method = push_send_data_method_S_0002 then
          binary_expr_00244 <= tmp_0340;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00263 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0033 then
          binary_expr_00263 <= tmp_0352;
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
        if push_send_data_method = push_send_data_method_S_0033 then
          binary_expr_00264 <= tmp_0353;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00266 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0036 then
          binary_expr_00266 <= tmp_0354;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00267 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0036 then
          binary_expr_00267 <= tmp_0356;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00268 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0036 then
          binary_expr_00268 <= tmp_0355;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00269 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0036 then
          cast_expr_00269 <= tmp_0357;
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
        if push_send_data_method = push_send_data_method_S_0041 then
          binary_expr_00271 <= tmp_0358;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00272 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0041 then
          binary_expr_00272 <= tmp_0360;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00273 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0041 then
          binary_expr_00273 <= tmp_0359;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00274 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0041 then
          cast_expr_00274 <= tmp_0361;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00276 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0046 then
          binary_expr_00276 <= tmp_0362;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00277 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0046 then
          binary_expr_00277 <= tmp_0364;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00278 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0046 then
          binary_expr_00278 <= tmp_0363;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00279 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0046 then
          cast_expr_00279 <= tmp_0365;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00281 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0051 then
          binary_expr_00281 <= tmp_0366;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00282 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0051 then
          binary_expr_00282 <= tmp_0367;
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
        if push_send_data_method = push_send_data_method_S_0008 then
          binary_expr_00245 <= tmp_0341;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        push_send_data_i_0246 <= X"00000000";
      else
        if push_send_data_method = push_send_data_method_S_0011 then
          push_send_data_i_0246 <= X"00000000";
        elsif push_send_data_method = push_send_data_method_S_0015 then
          push_send_data_i_0246 <= tmp_0343;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00247 <= '0';
      else
        if push_send_data_method = push_send_data_method_S_0012 then
          binary_expr_00247 <= tmp_0342;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        unary_expr_00248 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0015 then
          unary_expr_00248 <= tmp_0343;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        push_send_data_v_0249 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0021 then
          push_send_data_v_0249 <= array_access_00252;
        elsif push_send_data_method = push_send_data_method_S_0028 then
          push_send_data_v_0249 <= array_access_00258;
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
        if push_send_data_method = push_send_data_method_S_0018 then
          binary_expr_00250 <= tmp_0344;
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
        if push_send_data_method = push_send_data_method_S_0018 then
          binary_expr_00251 <= tmp_0345;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        array_access_00252 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0020 and push_send_data_method_delay = 2 then
          array_access_00252 <= class_buffer_0088_dout_b;
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
        if push_send_data_method = push_send_data_method_S_0021 then
          binary_expr_00254 <= tmp_0346;
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
        if push_send_data_method = push_send_data_method_S_0021 then
          binary_expr_00255 <= tmp_0347;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00256 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0025 then
          binary_expr_00256 <= tmp_0348;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00257 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0025 then
          binary_expr_00257 <= tmp_0349;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        array_access_00258 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0027 and push_send_data_method_delay = 2 then
          array_access_00258 <= class_buffer_0088_dout_b;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00260 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0028 then
          binary_expr_00260 <= tmp_0350;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00261 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0028 then
          binary_expr_00261 <= tmp_0351;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_port_0283 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0001 then
          tcp_server_port_0283 <= tcp_server_port_local;
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
        if test_method = test_method_S_0010_body and test_method_delay = 0 then
          tcp_server_port_local <= X"00000000";
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00285 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0002 then
          binary_expr_00285 <= tmp_0420;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00286 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0002 then
          binary_expr_00286 <= tmp_0421;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_v_0287 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0006 then
          tcp_server_v_0287 <= method_result_00288;
        elsif tcp_server_method = tcp_server_method_S_0014 then
          tcp_server_v_0287 <= method_result_00293;
        elsif tcp_server_method = tcp_server_method_S_0019 then
          tcp_server_v_0287 <= method_result_00295;
        elsif tcp_server_method = tcp_server_method_S_0027 then
          tcp_server_v_0287 <= method_result_00300;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00288 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0005_wait then
          method_result_00288 <= tcp_server_open_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00289 <= '0';
      else
        if tcp_server_method = tcp_server_method_S_0007 then
          binary_expr_00289 <= tmp_0422;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00294 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0016 then
          cast_expr_00294 <= tmp_0425;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00295 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0018_wait then
          method_result_00295 <= tcp_server_listen_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00296 <= '0';
      else
        if tcp_server_method = tcp_server_method_S_0020 then
          binary_expr_00296 <= tmp_0426;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00302 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0033_wait then
          method_result_00302 <= read_data_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00303 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0030 then
          binary_expr_00303 <= tmp_0429;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00304 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0032 then
          binary_expr_00304 <= tmp_0430;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00305 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0034 then
          cast_expr_00305 <= tmp_0431;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00291 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0010 then
          binary_expr_00291 <= tmp_0423;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00292 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0010 then
          binary_expr_00292 <= tmp_0424;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00293 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0013_wait then
          method_result_00293 <= tcp_server_open_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00298 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0023 then
          binary_expr_00298 <= tmp_0427;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00299 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0023 then
          binary_expr_00299 <= tmp_0428;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00300 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0026_wait then
          method_result_00300 <= tcp_server_listen_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_len_0306 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0039 then
          tcp_server_len_0306 <= method_result_00307;
        elsif tcp_server_method = tcp_server_method_S_0047 then
          tcp_server_len_0306 <= method_result_00309;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00307 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0038_wait then
          method_result_00307 <= wait_for_recv_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00308 <= '0';
      else
        if tcp_server_method = tcp_server_method_S_0039 then
          binary_expr_00308 <= tmp_0432;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00309 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0046_wait then
          method_result_00309 <= pull_recv_data_return;
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
        if wait_cycles_method = wait_cycles_method_S_0000 then
          wait_cycles_busy <= '0';
        elsif wait_cycles_method = wait_cycles_method_S_0001 then
          wait_cycles_busy <= tmp_0007;
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
        if write_data_method = write_data_method_S_0010_body then
          wait_cycles_req_local <= '1';
        elsif read_data_method = read_data_method_S_0008_body then
          wait_cycles_req_local <= '1';
        elsif init_method = init_method_S_0010_body then
          wait_cycles_req_local <= '1';
        elsif init_method = init_method_S_0013_body then
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
        write_data_busy <= '0';
      else
        if write_data_method = write_data_method_S_0000 then
          write_data_busy <= '0';
        elsif write_data_method = write_data_method_S_0001 then
          write_data_busy <= tmp_0019;
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
        if network_configuration_method = network_configuration_method_S_0002_body then
          write_data_req_local <= '1';
        elsif network_configuration_method = network_configuration_method_S_0003_body then
          write_data_req_local <= '1';
        elsif network_configuration_method = network_configuration_method_S_0004_body then
          write_data_req_local <= '1';
        elsif network_configuration_method = network_configuration_method_S_0005_body then
          write_data_req_local <= '1';
        elsif network_configuration_method = network_configuration_method_S_0006_body then
          write_data_req_local <= '1';
        elsif network_configuration_method = network_configuration_method_S_0007_body then
          write_data_req_local <= '1';
        elsif network_configuration_method = network_configuration_method_S_0008_body then
          write_data_req_local <= '1';
        elsif network_configuration_method = network_configuration_method_S_0009_body then
          write_data_req_local <= '1';
        elsif network_configuration_method = network_configuration_method_S_0010_body then
          write_data_req_local <= '1';
        elsif network_configuration_method = network_configuration_method_S_0011_body then
          write_data_req_local <= '1';
        elsif network_configuration_method = network_configuration_method_S_0012_body then
          write_data_req_local <= '1';
        elsif network_configuration_method = network_configuration_method_S_0013_body then
          write_data_req_local <= '1';
        elsif network_configuration_method = network_configuration_method_S_0014_body then
          write_data_req_local <= '1';
        elsif network_configuration_method = network_configuration_method_S_0015_body then
          write_data_req_local <= '1';
        elsif network_configuration_method = network_configuration_method_S_0016_body then
          write_data_req_local <= '1';
        elsif network_configuration_method = network_configuration_method_S_0017_body then
          write_data_req_local <= '1';
        elsif network_configuration_method = network_configuration_method_S_0018_body then
          write_data_req_local <= '1';
        elsif network_configuration_method = network_configuration_method_S_0019_body then
          write_data_req_local <= '1';
        elsif tcp_server_open_method = tcp_server_open_method_S_0007_body then
          write_data_req_local <= '1';
        elsif tcp_server_open_method = tcp_server_open_method_S_0010_body then
          write_data_req_local <= '1';
        elsif tcp_server_open_method = tcp_server_open_method_S_0013_body then
          write_data_req_local <= '1';
        elsif tcp_server_open_method = tcp_server_open_method_S_0016_body then
          write_data_req_local <= '1';
        elsif tcp_server_listen_method = tcp_server_listen_method_S_0004_body then
          write_data_req_local <= '1';
        elsif wait_for_recv_method = wait_for_recv_method_S_0045_body then
          write_data_req_local <= '1';
        elsif pull_recv_data_method = pull_recv_data_method_S_0048_body then
          write_data_req_local <= '1';
        elsif push_send_data_method = push_send_data_method_S_0024_body then
          write_data_req_local <= '1';
        elsif push_send_data_method = push_send_data_method_S_0031_body then
          write_data_req_local <= '1';
        elsif push_send_data_method = push_send_data_method_S_0035_body then
          write_data_req_local <= '1';
        elsif push_send_data_method = push_send_data_method_S_0040_body then
          write_data_req_local <= '1';
        elsif push_send_data_method = push_send_data_method_S_0045_body then
          write_data_req_local <= '1';
        elsif push_send_data_method = push_send_data_method_S_0050_body then
          write_data_req_local <= '1';
        elsif push_send_data_method = push_send_data_method_S_0053_body then
          write_data_req_local <= '1';
        elsif tcp_server_method = tcp_server_method_S_0004_body then
          write_data_req_local <= '1';
        elsif tcp_server_method = tcp_server_method_S_0012_body then
          write_data_req_local <= '1';
        elsif tcp_server_method = tcp_server_method_S_0025_body then
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
        read_data_return <= (others => '0');
      else
        if read_data_method = read_data_method_S_0015 then
          read_data_return <= read_data_v_0107;
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
        if read_data_method = read_data_method_S_0000 then
          read_data_busy <= '0';
        elsif read_data_method = read_data_method_S_0001 then
          read_data_busy <= tmp_0031;
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
        if tcp_server_open_method = tcp_server_open_method_S_0019_body then
          read_data_req_local <= '1';
        elsif tcp_server_listen_method = tcp_server_listen_method_S_0007_body then
          read_data_req_local <= '1';
        elsif wait_for_established_method = wait_for_established_method_S_0007_body then
          read_data_req_local <= '1';
        elsif wait_for_recv_method = wait_for_recv_method_S_0008_body then
          read_data_req_local <= '1';
        elsif wait_for_recv_method = wait_for_recv_method_S_0013_body then
          read_data_req_local <= '1';
        elsif wait_for_recv_method = wait_for_recv_method_S_0018_body then
          read_data_req_local <= '1';
        elsif wait_for_recv_method = wait_for_recv_method_S_0033_body then
          read_data_req_local <= '1';
        elsif pull_recv_data_method = pull_recv_data_method_S_0004_body then
          read_data_req_local <= '1';
        elsif pull_recv_data_method = pull_recv_data_method_S_0009_body then
          read_data_req_local <= '1';
        elsif pull_recv_data_method = pull_recv_data_method_S_0036_body then
          read_data_req_local <= '1';
        elsif pull_recv_data_method = pull_recv_data_method_S_0043_body then
          read_data_req_local <= '1';
        elsif tcp_server_method = tcp_server_method_S_0033_body then
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
        init_busy <= '0';
      else
        if init_method = init_method_S_0000 then
          init_busy <= '0';
        elsif init_method = init_method_S_0001 then
          init_busy <= tmp_0043;
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
        if test_method = test_method_S_0003_body then
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
        network_configuration_busy <= '0';
      else
        if network_configuration_method = network_configuration_method_S_0000 then
          network_configuration_busy <= '0';
        elsif network_configuration_method = network_configuration_method_S_0001 then
          network_configuration_busy <= tmp_0055;
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
        if test_method = test_method_S_0005_body then
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
        tcp_server_open_return <= (others => '0');
      else
        if tcp_server_open_method = tcp_server_open_method_S_0020 then
          tcp_server_open_return <= method_result_00152;
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
        if tcp_server_open_method = tcp_server_open_method_S_0000 then
          tcp_server_open_busy <= '0';
        elsif tcp_server_open_method = tcp_server_open_method_S_0001 then
          tcp_server_open_busy <= tmp_0135;
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
        if tcp_server_method = tcp_server_method_S_0005_body then
          tcp_server_open_req_local <= '1';
        elsif tcp_server_method = tcp_server_method_S_0013_body then
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
        tcp_server_listen_return <= (others => '0');
      else
        if tcp_server_listen_method = tcp_server_listen_method_S_0008 then
          tcp_server_listen_return <= method_result_00159;
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
        if tcp_server_listen_method = tcp_server_listen_method_S_0000 then
          tcp_server_listen_busy <= '0';
        elsif tcp_server_listen_method = tcp_server_listen_method_S_0001 then
          tcp_server_listen_busy <= tmp_0160;
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
        if tcp_server_method = tcp_server_method_S_0018_body then
          tcp_server_listen_req_local <= '1';
        elsif tcp_server_method = tcp_server_method_S_0026_body then
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
        wait_for_established_busy <= '0';
      else
        if wait_for_established_method = wait_for_established_method_S_0000 then
          wait_for_established_busy <= '0';
        elsif wait_for_established_method = wait_for_established_method_S_0001 then
          wait_for_established_busy <= tmp_0176;
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
        if tcp_server_method = tcp_server_method_S_0029_body then
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
        wait_for_recv_return <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0029 then
          wait_for_recv_return <= wait_for_recv_v_0169;
        elsif wait_for_recv_method = wait_for_recv_method_S_0046 then
          wait_for_recv_return <= X"00000000";
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
        if wait_for_recv_method = wait_for_recv_method_S_0000 then
          wait_for_recv_busy <= '0';
        elsif wait_for_recv_method = wait_for_recv_method_S_0001 then
          wait_for_recv_busy <= tmp_0191;
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
        if tcp_server_method = tcp_server_method_S_0038_body then
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
        pull_recv_data_return <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0049 then
          pull_recv_data_return <= pull_recv_data_actual_len_0213;
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
        if pull_recv_data_method = pull_recv_data_method_S_0000 then
          pull_recv_data_busy <= '0';
        elsif pull_recv_data_method = pull_recv_data_method_S_0001 then
          pull_recv_data_busy <= tmp_0249;
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
        if tcp_server_method = tcp_server_method_S_0046_body then
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
        push_send_data_busy <= '0';
      else
        if push_send_data_method = push_send_data_method_S_0000 then
          push_send_data_busy <= '0';
        elsif push_send_data_method = push_send_data_method_S_0001 then
          push_send_data_busy <= tmp_0305;
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
        if tcp_server_method = tcp_server_method_S_0049_body then
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
        tcp_server_busy <= '0';
      else
        if tcp_server_method = tcp_server_method_S_0000 then
          tcp_server_busy <= '0';
        elsif tcp_server_method = tcp_server_method_S_0001 then
          tcp_server_busy <= tmp_0371;
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
        if test_method = test_method_S_0010_body then
          tcp_server_req_local <= '1';
        else
          tcp_server_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  test_req_flag <= tmp_0002;

  blink_led_req_flag <= tmp_0003;

  wait_cycles_req_flag_edge <= tmp_0005;

  write_data_req_flag_edge <= tmp_0017;

  wait_cycles_call_flag_0010 <= tmp_0023;

  read_data_req_flag_edge <= tmp_0029;

  wait_cycles_call_flag_0008 <= tmp_0035;

  init_req_flag_edge <= tmp_0041;

  wait_cycles_call_flag_0013 <= tmp_0047;

  network_configuration_req_flag_edge <= tmp_0053;

  write_data_call_flag_0002 <= tmp_0059;

  write_data_call_flag_0003 <= tmp_0063;

  write_data_call_flag_0004 <= tmp_0067;

  write_data_call_flag_0005 <= tmp_0071;

  write_data_call_flag_0006 <= tmp_0075;

  write_data_call_flag_0007 <= tmp_0079;

  write_data_call_flag_0008 <= tmp_0083;

  write_data_call_flag_0009 <= tmp_0087;

  write_data_call_flag_0010 <= tmp_0091;

  write_data_call_flag_0011 <= tmp_0095;

  write_data_call_flag_0012 <= tmp_0099;

  write_data_call_flag_0013 <= tmp_0103;

  write_data_call_flag_0014 <= tmp_0107;

  write_data_call_flag_0015 <= tmp_0111;

  write_data_call_flag_0016 <= tmp_0115;

  write_data_call_flag_0017 <= tmp_0119;

  write_data_call_flag_0018 <= tmp_0123;

  write_data_call_flag_0019 <= tmp_0127;

  tcp_server_open_req_flag_edge <= tmp_0133;

  read_data_call_flag_0019 <= tmp_0139;

  tcp_server_listen_req_flag_edge <= tmp_0158;

  read_data_call_flag_0007 <= tmp_0164;

  wait_for_established_req_flag_edge <= tmp_0174;

  wait_for_recv_req_flag_edge <= tmp_0189;

  read_data_call_flag_0008 <= tmp_0197;

  read_data_call_flag_0013 <= tmp_0201;

  read_data_call_flag_0018 <= tmp_0205;

  read_data_call_flag_0033 <= tmp_0211;

  write_data_call_flag_0045 <= tmp_0217;

  pull_recv_data_req_flag_edge <= tmp_0247;

  read_data_call_flag_0004 <= tmp_0253;

  read_data_call_flag_0009 <= tmp_0257;

  read_data_call_flag_0036 <= tmp_0265;

  read_data_call_flag_0043 <= tmp_0269;

  write_data_call_flag_0048 <= tmp_0273;

  push_send_data_req_flag_edge <= tmp_0303;

  write_data_call_flag_0024 <= tmp_0313;

  write_data_call_flag_0031 <= tmp_0317;

  write_data_call_flag_0035 <= tmp_0321;

  write_data_call_flag_0040 <= tmp_0325;

  write_data_call_flag_0050 <= tmp_0329;

  write_data_call_flag_0053 <= tmp_0333;

  tcp_server_req_flag_edge <= tmp_0369;

  tcp_server_open_call_flag_0005 <= tmp_0375;

  tcp_server_open_call_flag_0013 <= tmp_0381;

  tcp_server_listen_call_flag_0018 <= tmp_0385;

  write_data_call_flag_0025 <= tmp_0391;

  tcp_server_listen_call_flag_0026 <= tmp_0395;

  wait_for_established_call_flag_0029 <= tmp_0399;

  wait_for_recv_call_flag_0038 <= tmp_0405;

  pull_recv_data_call_flag_0046 <= tmp_0411;

  push_send_data_call_flag_0049 <= tmp_0415;

  test_req_flag_edge <= tmp_0434;

  init_call_flag_0003 <= tmp_0440;

  network_configuration_call_flag_0005 <= tmp_0444;

  tcp_server_call_flag_0010 <= tmp_0450;

  blink_led_req_flag_edge <= tmp_0456;


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
    ADDR => class_wiz830mj_0000_ADDR,
    nCS => class_wiz830mj_0000_nCS,
    nRD => class_wiz830mj_0000_nRD,
    nWR => class_wiz830mj_0000_nWR,
    nINT => class_wiz830mj_0000_nINT,
    nRESET => class_wiz830mj_0000_nRESET,
    BRDY => class_wiz830mj_0000_BRDY,
    DATA => class_wiz830mj_0000_DATA_exp
  );

  inst_class_buffer_0088 : singleportram
  generic map(
    WIDTH => 8,
    DEPTH => 13,
    WORDS => 8192
  )
  port map(
    clk => class_buffer_0088_clk,
    reset => class_buffer_0088_reset,
    length => class_buffer_0088_length,
    address_b => class_buffer_0088_address_b,
    din_b => class_buffer_0088_din_b,
    dout_b => class_buffer_0088_dout_b,
    we_b => class_buffer_0088_we_b,
    oe_b => class_buffer_0088_oe_b
  );


end RTL;
