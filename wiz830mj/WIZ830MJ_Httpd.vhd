library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity WIZ830MJ_Httpd is
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
    arg0_in : in signed(8-1 downto 0);
    arg0_we : in std_logic;
    arg0_out : out signed(8-1 downto 0);
    arg1_in : in signed(8-1 downto 0);
    arg1_we : in std_logic;
    arg1_out : out signed(8-1 downto 0);
    test_busy : out std_logic;
    test_req : in std_logic;
    blink_led_busy : out std_logic;
    blink_led_req : in std_logic
  );
end WIZ830MJ_Httpd;

architecture RTL of WIZ830MJ_Httpd is

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
  component http_response_header
    port (
      clk : in std_logic;
      reset : in std_logic;
      data_length : out signed(32-1 downto 0);
      data_address : in signed(32-1 downto 0);
      data_din : in signed(32-1 downto 0);
      data_dout : out signed(32-1 downto 0);
      data_we : in std_logic;
      data_oe : in std_logic;
      length : out signed(32-1 downto 0)
    );
  end component http_response_header;
  component Misc
    port (
      clk : in std_logic;
      reset : in std_logic;
      i_to_4digit_ascii_x : in signed(32-1 downto 0);
      isHex_v : in signed(8-1 downto 0);
      toHex1_v : in signed(8-1 downto 0);
      toHex2_v0 : in signed(8-1 downto 0);
      toHex2_v1 : in signed(8-1 downto 0);
      i_to_4digit_ascii_return : out signed(32-1 downto 0);
      i_to_4digit_ascii_busy : out std_logic;
      i_to_4digit_ascii_req : in std_logic;
      isHex_return : out std_logic;
      isHex_busy : out std_logic;
      isHex_req : in std_logic;
      toHex1_return : out signed(32-1 downto 0);
      toHex1_busy : out std_logic;
      toHex1_req : in std_logic;
      toHex2_return : out signed(32-1 downto 0);
      toHex2_busy : out std_logic;
      toHex2_req : in std_logic
    );
  end component Misc;

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
  signal arg0_in_sig : signed(8-1 downto 0);
  signal arg0_we_sig : std_logic;
  signal arg0_out_sig : signed(8-1 downto 0);
  signal arg1_in_sig : signed(8-1 downto 0);
  signal arg1_we_sig : std_logic;
  signal arg1_out_sig : signed(8-1 downto 0);
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
  signal class_resp_0089_clk : std_logic;
  signal class_resp_0089_reset : std_logic;
  signal class_resp_0089_data_length : signed(32-1 downto 0);
  signal class_resp_0089_data_address : signed(32-1 downto 0) := (others => '0');
  signal class_resp_0089_data_din : signed(32-1 downto 0) := (others => '0');
  signal class_resp_0089_data_dout : signed(32-1 downto 0);
  signal class_resp_0089_data_we : std_logic := '0';
  signal class_resp_0089_data_oe : std_logic := '0';
  signal class_resp_0089_length : signed(32-1 downto 0);
  signal class_data_0091_clk : std_logic;
  signal class_data_0091_reset : std_logic;
  signal class_data_0091_length : signed(32-1 downto 0);
  signal class_data_0091_address_b : signed(32-1 downto 0) := (others => '0');
  signal class_data_0091_din_b : signed(32-1 downto 0) := (others => '0');
  signal class_data_0091_dout_b : signed(32-1 downto 0);
  signal class_data_0091_we_b : std_logic := '0';
  signal class_data_0091_oe_b : std_logic := '0';
  signal class_content_words_0092 : signed(32-1 downto 0) := X"00000008";
  signal class_content_length_field_0093 : signed(32-1 downto 0) := X"33322020";
  signal class_misc_0094_clk : std_logic;
  signal class_misc_0094_reset : std_logic;
  signal class_misc_0094_i_to_4digit_ascii_x : signed(32-1 downto 0) := (others => '0');
  signal class_misc_0094_isHex_v : signed(8-1 downto 0) := (others => '0');
  signal class_misc_0094_toHex1_v : signed(8-1 downto 0) := (others => '0');
  signal class_misc_0094_toHex2_v0 : signed(8-1 downto 0) := (others => '0');
  signal class_misc_0094_toHex2_v1 : signed(8-1 downto 0) := (others => '0');
  signal class_misc_0094_i_to_4digit_ascii_return : signed(32-1 downto 0);
  signal class_misc_0094_i_to_4digit_ascii_busy : std_logic;
  signal class_misc_0094_i_to_4digit_ascii_req : std_logic := '0';
  signal class_misc_0094_isHex_return : std_logic;
  signal class_misc_0094_isHex_busy : std_logic;
  signal class_misc_0094_isHex_req : std_logic := '0';
  signal class_misc_0094_toHex1_return : signed(32-1 downto 0);
  signal class_misc_0094_toHex1_busy : std_logic;
  signal class_misc_0094_toHex1_req : std_logic := '0';
  signal class_misc_0094_toHex2_return : signed(32-1 downto 0);
  signal class_misc_0094_toHex2_busy : std_logic;
  signal class_misc_0094_toHex2_req : std_logic := '0';
  signal class_arg0_0096 : signed(8-1 downto 0) := X"20";
  signal class_arg0_0096_mux : signed(8-1 downto 0);
  signal tmp_0002 : signed(8-1 downto 0);
  signal class_arg1_0097 : signed(8-1 downto 0) := X"20";
  signal class_arg1_0097_mux : signed(8-1 downto 0);
  signal tmp_0003 : signed(8-1 downto 0);
  signal wait_cycles_n_0098 : signed(32-1 downto 0) := (others => '0');
  signal wait_cycles_n_local : signed(32-1 downto 0) := (others => '0');
  signal wait_cycles_i_0099 : signed(32-1 downto 0) := X"00000000";
  signal binary_expr_00100 : std_logic := '0';
  signal unary_expr_00101 : signed(32-1 downto 0) := (others => '0');
  signal write_data_addr_0102 : signed(32-1 downto 0) := (others => '0');
  signal write_data_addr_local : signed(32-1 downto 0) := (others => '0');
  signal write_data_data_0103 : signed(8-1 downto 0) := (others => '0');
  signal write_data_data_local : signed(8-1 downto 0) := (others => '0');
  signal field_access_00104 : signed(32-1 downto 0) := (others => '0');
  signal field_access_00105 : signed(8-1 downto 0) := (others => '0');
  signal field_access_00106 : std_logic := '0';
  signal field_access_00107 : std_logic := '0';
  signal field_access_00109 : std_logic := '0';
  signal field_access_00110 : std_logic := '0';
  signal read_data_addr_0111 : signed(32-1 downto 0) := (others => '0');
  signal read_data_addr_local : signed(32-1 downto 0) := (others => '0');
  signal field_access_00112 : signed(32-1 downto 0) := (others => '0');
  signal field_access_00113 : std_logic := '0';
  signal field_access_00114 : std_logic := '0';
  signal read_data_v_0116 : signed(8-1 downto 0) := (others => '0');
  signal field_access_00117 : signed(8-1 downto 0) := (others => '0');
  signal field_access_00118 : std_logic := '0';
  signal field_access_00119 : std_logic := '0';
  signal field_access_00120 : std_logic := '0';
  signal field_access_00121 : std_logic := '0';
  signal field_access_00122 : std_logic := '0';
  signal field_access_00123 : std_logic := '0';
  signal field_access_00125 : std_logic := '0';
  signal tcp_server_open_port_0145 : signed(32-1 downto 0) := (others => '0');
  signal tcp_server_open_port_local : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00147 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00148 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00149 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00150 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00151 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00153 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00154 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00156 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00157 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00159 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00160 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00161 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00162 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00163 : signed(32-1 downto 0) := (others => '0');
  signal tcp_server_listen_port_0164 : signed(32-1 downto 0) := (others => '0');
  signal tcp_server_listen_port_local : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00166 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00167 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00168 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00169 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00170 : signed(32-1 downto 0) := (others => '0');
  signal wait_for_established_port_0171 : signed(32-1 downto 0) := (others => '0');
  signal wait_for_established_port_local : signed(32-1 downto 0) := (others => '0');
  signal wait_for_established_v_0172 : signed(8-1 downto 0) := X"00";
  signal method_result_00173 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00174 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00175 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00176 : std_logic := '0';
  signal wait_for_recv_port_0177 : signed(32-1 downto 0) := (others => '0');
  signal wait_for_recv_port_local : signed(32-1 downto 0) := (others => '0');
  signal wait_for_recv_v_0178 : signed(32-1 downto 0) := X"00000000";
  signal wait_for_recv_v0_0179 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00180 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00181 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00182 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00183 : signed(32-1 downto 0) := (others => '0');
  signal wait_for_recv_v1_0184 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00185 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00186 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00187 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00188 : signed(32-1 downto 0) := (others => '0');
  signal wait_for_recv_v2_0189 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00190 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00191 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00192 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00193 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00194 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00195 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00196 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00197 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00198 : std_logic := '0';
  signal method_result_00199 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00200 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00201 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00202 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00203 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00204 : std_logic := '0';
  signal cast_expr_00205 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00206 : std_logic := '0';
  signal binary_expr_00207 : std_logic := '0';
  signal binary_expr_00209 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00210 : signed(32-1 downto 0) := (others => '0');
  signal pull_recv_data_port_0211 : signed(32-1 downto 0) := (others => '0');
  signal pull_recv_data_port_local : signed(32-1 downto 0) := (others => '0');
  signal pull_recv_data_v0_0212 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00213 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00214 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00215 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00216 : signed(32-1 downto 0) := (others => '0');
  signal pull_recv_data_v1_0217 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00218 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00219 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00220 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00221 : signed(32-1 downto 0) := (others => '0');
  signal pull_recv_data_actual_len_0222 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00223 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00224 : signed(32-1 downto 0) := (others => '0');
  signal pull_recv_data_read_len_0225 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00226 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00227 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00228 : std_logic := '0';
  signal binary_expr_00246 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00247 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00229 : signed(32-1 downto 0) := (others => '0');
  signal pull_recv_data_i_0230 : signed(32-1 downto 0) := X"00000000";
  signal binary_expr_00231 : std_logic := '0';
  signal unary_expr_00232 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00233 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00234 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00235 : signed(8-1 downto 0) := (others => '0');
  signal method_result_00236 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00237 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00238 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00239 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00240 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00241 : signed(8-1 downto 0) := (others => '0');
  signal method_result_00242 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00243 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00244 : signed(32-1 downto 0) := (others => '0');
  signal push_send_data_port_0248 : signed(32-1 downto 0) := (others => '0');
  signal push_send_data_port_local : signed(32-1 downto 0) := (others => '0');
  signal push_send_data_len_0249 : signed(32-1 downto 0) := (others => '0');
  signal push_send_data_len_local : signed(32-1 downto 0) := (others => '0');
  signal push_send_data_write_len_0250 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00251 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00253 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00254 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00255 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00256 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00257 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00259 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00260 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00261 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00262 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00263 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00264 : std_logic := '0';
  signal binary_expr_00283 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00284 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00286 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00287 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00288 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00289 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00291 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00292 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00293 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00294 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00296 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00297 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00298 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00299 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00301 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00302 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00265 : signed(32-1 downto 0) := (others => '0');
  signal push_send_data_i_0266 : signed(32-1 downto 0) := X"00000000";
  signal binary_expr_00267 : std_logic := '0';
  signal unary_expr_00268 : signed(32-1 downto 0) := (others => '0');
  signal push_send_data_v_0269 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00270 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00271 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00272 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00274 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00275 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00276 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00277 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00278 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00280 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00281 : signed(32-1 downto 0) := (others => '0');
  signal pack_a_0303 : std_logic_vector(16-1 downto 0) := (others => '0');
  signal pack_a_local : std_logic_vector(16-1 downto 0) := (others => '0');
  signal pack_b_0304 : std_logic_vector(16-1 downto 0) := (others => '0');
  signal pack_b_local : std_logic_vector(16-1 downto 0) := (others => '0');
  signal pack_c_0305 : std_logic_vector(16-1 downto 0) := (others => '0');
  signal pack_c_local : std_logic_vector(16-1 downto 0) := (others => '0');
  signal pack_d_0306 : std_logic_vector(16-1 downto 0) := (others => '0');
  signal pack_d_local : std_logic_vector(16-1 downto 0) := (others => '0');
  signal cast_expr_00307 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00308 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00309 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00310 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00311 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00312 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00313 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00314 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00315 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00316 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00317 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00318 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00319 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00320 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00321 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00322 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00323 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00324 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00325 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00326 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00327 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00328 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00329 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00330 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00331 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00332 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00333 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00334 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00335 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00336 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00337 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00338 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00339 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00340 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00341 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00342 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00370 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00371 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00372 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00373 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00374 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00375 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00376 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00377 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00378 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00379 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00380 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00381 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00382 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00383 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00384 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00385 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00386 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00387 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00388 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00389 : signed(8-1 downto 0) := (others => '0');
  signal ready_contents_offset_0390 : signed(32-1 downto 0) := (others => '0');
  signal field_access_00391 : signed(32-1 downto 0) := (others => '0');
  signal field_access_00421 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00422 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00423 : signed(32-1 downto 0) := (others => '0');
  signal ready_contents_i_0343 : signed(32-1 downto 0) := X"00000000";
  signal field_access_00344 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00345 : std_logic := '0';
  signal unary_expr_00346 : signed(32-1 downto 0) := (others => '0');
  signal ready_contents_v_0347 : signed(32-1 downto 0) := (others => '0');
  signal field_access_00348 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00349 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00350 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00351 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00352 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00353 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00354 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00355 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00356 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00357 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00358 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00359 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00360 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00361 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00362 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00363 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00364 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00365 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00366 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00367 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00368 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00369 : signed(8-1 downto 0) := (others => '0');
  signal ready_contents_i_0392 : signed(32-1 downto 0) := X"00000000";
  signal binary_expr_00393 : std_logic := '0';
  signal unary_expr_00394 : signed(32-1 downto 0) := (others => '0');
  signal ready_contents_v_0395 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00396 : signed(32-1 downto 0) := (others => '0');
  signal ready_contents_ptr_0397 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00398 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00399 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00400 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00401 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00402 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00403 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00404 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00405 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00406 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00407 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00408 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00409 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00410 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00411 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00412 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00413 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00414 : signed(32-1 downto 0) := (others => '0');
  signal cast_expr_00415 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00416 : std_logic := '0';
  signal binary_expr_00417 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00418 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00419 : signed(32-1 downto 0) := (others => '0');
  signal array_access_00420 : signed(8-1 downto 0) := (others => '0');
  signal action_len_0424 : signed(32-1 downto 0) := (others => '0');
  signal action_len_local : signed(32-1 downto 0) := (others => '0');
  signal action_S_0425 : signed(32-1 downto 0) := X"00000000";
  signal action_v0_0426 : signed(8-1 downto 0) := X"00";
  signal action_v1_0427 : signed(8-1 downto 0) := X"00";
  signal binary_expr_00438 : std_logic := '0';
  signal action_i_0428 : signed(32-1 downto 0) := X"00000000";
  signal binary_expr_00429 : std_logic := '0';
  signal unary_expr_00430 : signed(32-1 downto 0) := (others => '0');
  signal action_b_0431 : signed(8-1 downto 0) := (others => '0');
  signal array_access_00432 : signed(8-1 downto 0) := (others => '0');
  signal method_result_00433 : std_logic := '0';
  signal method_result_00434 : std_logic := '0';
  signal binary_expr_00435 : std_logic := '0';
  signal binary_expr_00436 : std_logic := '0';
  signal binary_expr_00437 : std_logic := '0';
  signal action_v_0439 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00440 : signed(32-1 downto 0) := (others => '0');
  signal tcp_server_port_0441 : signed(32-1 downto 0) := (others => '0');
  signal tcp_server_port_local : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00443 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00444 : signed(32-1 downto 0) := (others => '0');
  signal tcp_server_v_0445 : signed(8-1 downto 0) := (others => '0');
  signal method_result_00446 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00447 : std_logic := '0';
  signal method_result_00452 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00453 : std_logic := '0';
  signal method_result_00459 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00460 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00461 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00449 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00450 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00451 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00455 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00456 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00457 : signed(8-1 downto 0) := (others => '0');
  signal tcp_server_len_0462 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00463 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00464 : std_logic := '0';
  signal method_result_00465 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00467 : signed(32-1 downto 0) := (others => '0');
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
  signal pack_return : signed(32-1 downto 0) := (others => '0');
  signal pack_busy : std_logic := '0';
  signal pack_req_flag : std_logic;
  signal pack_req_local : std_logic := '0';
  signal init_contents_busy : std_logic := '0';
  signal init_contents_req_flag : std_logic;
  signal init_contents_req_local : std_logic := '0';
  signal ready_contents_return : signed(32-1 downto 0) := (others => '0');
  signal ready_contents_busy : std_logic := '0';
  signal ready_contents_req_flag : std_logic;
  signal ready_contents_req_local : std_logic := '0';
  signal action_busy : std_logic := '0';
  signal action_req_flag : std_logic;
  signal action_req_local : std_logic := '0';
  signal tcp_server_busy : std_logic := '0';
  signal tcp_server_req_flag : std_logic;
  signal tcp_server_req_local : std_logic := '0';
  signal test_req_flag : std_logic;
  signal test_req_local : std_logic := '0';
  signal tmp_0004 : std_logic;
  signal blink_led_req_flag : std_logic;
  signal blink_led_req_local : std_logic := '0';
  signal tmp_0005 : std_logic;
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
  signal tmp_0006 : std_logic;
  signal tmp_0007 : std_logic;
  signal tmp_0008 : std_logic;
  signal tmp_0009 : std_logic;
  signal tmp_0010 : std_logic;
  signal tmp_0011 : std_logic;
  signal tmp_0012 : std_logic;
  signal tmp_0013 : std_logic;
  signal tmp_0014 : std_logic;
  signal tmp_0015 : std_logic;
  signal tmp_0016 : std_logic;
  signal tmp_0017 : signed(32-1 downto 0);
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
  signal tmp_0018 : std_logic;
  signal tmp_0019 : std_logic;
  signal tmp_0020 : std_logic;
  signal tmp_0021 : std_logic;
  signal wait_cycles_call_flag_0010 : std_logic;
  signal tmp_0022 : std_logic;
  signal tmp_0023 : std_logic;
  signal tmp_0024 : std_logic;
  signal tmp_0025 : std_logic;
  signal tmp_0026 : std_logic;
  signal tmp_0027 : std_logic;
  signal tmp_0028 : std_logic;
  signal tmp_0029 : std_logic;
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
  signal tmp_0030 : std_logic;
  signal tmp_0031 : std_logic;
  signal tmp_0032 : std_logic;
  signal tmp_0033 : std_logic;
  signal wait_cycles_call_flag_0008 : std_logic;
  signal tmp_0034 : std_logic;
  signal tmp_0035 : std_logic;
  signal tmp_0036 : std_logic;
  signal tmp_0037 : std_logic;
  signal tmp_0038 : std_logic;
  signal tmp_0039 : std_logic;
  signal tmp_0040 : std_logic;
  signal tmp_0041 : std_logic;
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
  signal tmp_0042 : std_logic;
  signal tmp_0043 : std_logic;
  signal tmp_0044 : std_logic;
  signal tmp_0045 : std_logic;
  signal wait_cycles_call_flag_0013 : std_logic;
  signal tmp_0046 : std_logic;
  signal tmp_0047 : std_logic;
  signal tmp_0048 : std_logic;
  signal tmp_0049 : std_logic;
  signal tmp_0050 : std_logic;
  signal tmp_0051 : std_logic;
  signal tmp_0052 : std_logic;
  signal tmp_0053 : std_logic;
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
  signal tmp_0054 : std_logic;
  signal tmp_0055 : std_logic;
  signal tmp_0056 : std_logic;
  signal tmp_0057 : std_logic;
  signal write_data_call_flag_0002 : std_logic;
  signal tmp_0058 : std_logic;
  signal tmp_0059 : std_logic;
  signal tmp_0060 : std_logic;
  signal tmp_0061 : std_logic;
  signal write_data_call_flag_0003 : std_logic;
  signal tmp_0062 : std_logic;
  signal tmp_0063 : std_logic;
  signal tmp_0064 : std_logic;
  signal tmp_0065 : std_logic;
  signal write_data_call_flag_0004 : std_logic;
  signal tmp_0066 : std_logic;
  signal tmp_0067 : std_logic;
  signal tmp_0068 : std_logic;
  signal tmp_0069 : std_logic;
  signal write_data_call_flag_0005 : std_logic;
  signal tmp_0070 : std_logic;
  signal tmp_0071 : std_logic;
  signal tmp_0072 : std_logic;
  signal tmp_0073 : std_logic;
  signal write_data_call_flag_0006 : std_logic;
  signal tmp_0074 : std_logic;
  signal tmp_0075 : std_logic;
  signal tmp_0076 : std_logic;
  signal tmp_0077 : std_logic;
  signal write_data_call_flag_0007 : std_logic;
  signal tmp_0078 : std_logic;
  signal tmp_0079 : std_logic;
  signal tmp_0080 : std_logic;
  signal tmp_0081 : std_logic;
  signal write_data_call_flag_0008 : std_logic;
  signal tmp_0082 : std_logic;
  signal tmp_0083 : std_logic;
  signal tmp_0084 : std_logic;
  signal tmp_0085 : std_logic;
  signal write_data_call_flag_0009 : std_logic;
  signal tmp_0086 : std_logic;
  signal tmp_0087 : std_logic;
  signal tmp_0088 : std_logic;
  signal tmp_0089 : std_logic;
  signal write_data_call_flag_0010 : std_logic;
  signal tmp_0090 : std_logic;
  signal tmp_0091 : std_logic;
  signal tmp_0092 : std_logic;
  signal tmp_0093 : std_logic;
  signal write_data_call_flag_0011 : std_logic;
  signal tmp_0094 : std_logic;
  signal tmp_0095 : std_logic;
  signal tmp_0096 : std_logic;
  signal tmp_0097 : std_logic;
  signal write_data_call_flag_0012 : std_logic;
  signal tmp_0098 : std_logic;
  signal tmp_0099 : std_logic;
  signal tmp_0100 : std_logic;
  signal tmp_0101 : std_logic;
  signal write_data_call_flag_0013 : std_logic;
  signal tmp_0102 : std_logic;
  signal tmp_0103 : std_logic;
  signal tmp_0104 : std_logic;
  signal tmp_0105 : std_logic;
  signal write_data_call_flag_0014 : std_logic;
  signal tmp_0106 : std_logic;
  signal tmp_0107 : std_logic;
  signal tmp_0108 : std_logic;
  signal tmp_0109 : std_logic;
  signal write_data_call_flag_0015 : std_logic;
  signal tmp_0110 : std_logic;
  signal tmp_0111 : std_logic;
  signal tmp_0112 : std_logic;
  signal tmp_0113 : std_logic;
  signal write_data_call_flag_0016 : std_logic;
  signal tmp_0114 : std_logic;
  signal tmp_0115 : std_logic;
  signal tmp_0116 : std_logic;
  signal tmp_0117 : std_logic;
  signal write_data_call_flag_0017 : std_logic;
  signal tmp_0118 : std_logic;
  signal tmp_0119 : std_logic;
  signal tmp_0120 : std_logic;
  signal tmp_0121 : std_logic;
  signal write_data_call_flag_0018 : std_logic;
  signal tmp_0122 : std_logic;
  signal tmp_0123 : std_logic;
  signal tmp_0124 : std_logic;
  signal tmp_0125 : std_logic;
  signal write_data_call_flag_0019 : std_logic;
  signal tmp_0126 : std_logic;
  signal tmp_0127 : std_logic;
  signal tmp_0128 : std_logic;
  signal tmp_0129 : std_logic;
  signal tmp_0130 : std_logic;
  signal tmp_0131 : std_logic;
  signal tmp_0132 : std_logic;
  signal tmp_0133 : std_logic;
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
  signal tmp_0134 : std_logic;
  signal tmp_0135 : std_logic;
  signal tmp_0136 : std_logic;
  signal tmp_0137 : std_logic;
  signal read_data_call_flag_0019 : std_logic;
  signal tmp_0138 : std_logic;
  signal tmp_0139 : std_logic;
  signal tmp_0140 : std_logic;
  signal tmp_0141 : std_logic;
  signal tmp_0142 : std_logic;
  signal tmp_0143 : std_logic;
  signal tmp_0144 : std_logic;
  signal tmp_0145 : std_logic;
  signal tmp_0146 : signed(32-1 downto 0);
  signal tmp_0147 : signed(32-1 downto 0);
  signal tmp_0148 : signed(32-1 downto 0);
  signal tmp_0149 : signed(32-1 downto 0);
  signal tmp_0150 : signed(8-1 downto 0);
  signal tmp_0151 : signed(32-1 downto 0);
  signal tmp_0152 : signed(32-1 downto 0);
  signal tmp_0153 : signed(32-1 downto 0);
  signal tmp_0154 : signed(32-1 downto 0);
  signal tmp_0155 : signed(32-1 downto 0);
  signal tmp_0156 : signed(32-1 downto 0);
  signal tmp_0157 : signed(32-1 downto 0);
  signal tmp_0158 : signed(32-1 downto 0);
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
  signal tmp_0159 : std_logic;
  signal tmp_0160 : std_logic;
  signal tmp_0161 : std_logic;
  signal tmp_0162 : std_logic;
  signal read_data_call_flag_0007 : std_logic;
  signal tmp_0163 : std_logic;
  signal tmp_0164 : std_logic;
  signal tmp_0165 : std_logic;
  signal tmp_0166 : std_logic;
  signal tmp_0167 : std_logic;
  signal tmp_0168 : std_logic;
  signal tmp_0169 : std_logic;
  signal tmp_0170 : std_logic;
  signal tmp_0171 : signed(32-1 downto 0);
  signal tmp_0172 : signed(32-1 downto 0);
  signal tmp_0173 : signed(32-1 downto 0);
  signal tmp_0174 : signed(32-1 downto 0);
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
  signal tmp_0185 : std_logic;
  signal tmp_0186 : std_logic;
  signal tmp_0187 : signed(32-1 downto 0);
  signal tmp_0188 : signed(32-1 downto 0);
  signal tmp_0189 : std_logic;
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
  signal tmp_0190 : std_logic;
  signal tmp_0191 : std_logic;
  signal tmp_0192 : std_logic;
  signal tmp_0193 : std_logic;
  signal tmp_0194 : std_logic;
  signal tmp_0195 : std_logic;
  signal read_data_call_flag_0008 : std_logic;
  signal tmp_0196 : std_logic;
  signal tmp_0197 : std_logic;
  signal tmp_0198 : std_logic;
  signal tmp_0199 : std_logic;
  signal read_data_call_flag_0013 : std_logic;
  signal tmp_0200 : std_logic;
  signal tmp_0201 : std_logic;
  signal tmp_0202 : std_logic;
  signal tmp_0203 : std_logic;
  signal read_data_call_flag_0018 : std_logic;
  signal tmp_0204 : std_logic;
  signal tmp_0205 : std_logic;
  signal tmp_0206 : std_logic;
  signal tmp_0207 : std_logic;
  signal tmp_0208 : std_logic;
  signal tmp_0209 : std_logic;
  signal read_data_call_flag_0033 : std_logic;
  signal tmp_0210 : std_logic;
  signal tmp_0211 : std_logic;
  signal tmp_0212 : std_logic;
  signal tmp_0213 : std_logic;
  signal tmp_0214 : std_logic;
  signal tmp_0215 : std_logic;
  signal write_data_call_flag_0045 : std_logic;
  signal tmp_0216 : std_logic;
  signal tmp_0217 : std_logic;
  signal tmp_0218 : std_logic;
  signal tmp_0219 : std_logic;
  signal tmp_0220 : std_logic;
  signal tmp_0221 : std_logic;
  signal tmp_0222 : std_logic;
  signal tmp_0223 : std_logic;
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
  signal tmp_0235 : signed(32-1 downto 0);
  signal tmp_0236 : signed(32-1 downto 0);
  signal tmp_0237 : std_logic;
  signal tmp_0238 : signed(32-1 downto 0);
  signal tmp_0239 : signed(32-1 downto 0);
  signal tmp_0240 : signed(32-1 downto 0);
  signal tmp_0241 : signed(32-1 downto 0);
  signal tmp_0242 : signed(32-1 downto 0);
  signal tmp_0243 : std_logic;
  signal tmp_0244 : std_logic;
  signal tmp_0245 : std_logic;
  signal tmp_0246 : signed(32-1 downto 0);
  signal tmp_0247 : signed(32-1 downto 0);
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
  signal tmp_0248 : std_logic;
  signal tmp_0249 : std_logic;
  signal tmp_0250 : std_logic;
  signal tmp_0251 : std_logic;
  signal read_data_call_flag_0004 : std_logic;
  signal tmp_0252 : std_logic;
  signal tmp_0253 : std_logic;
  signal tmp_0254 : std_logic;
  signal tmp_0255 : std_logic;
  signal read_data_call_flag_0009 : std_logic;
  signal tmp_0256 : std_logic;
  signal tmp_0257 : std_logic;
  signal tmp_0258 : std_logic;
  signal tmp_0259 : std_logic;
  signal tmp_0260 : std_logic;
  signal tmp_0261 : std_logic;
  signal tmp_0262 : std_logic;
  signal tmp_0263 : std_logic;
  signal read_data_call_flag_0036 : std_logic;
  signal tmp_0264 : std_logic;
  signal tmp_0265 : std_logic;
  signal tmp_0266 : std_logic;
  signal tmp_0267 : std_logic;
  signal read_data_call_flag_0043 : std_logic;
  signal tmp_0268 : std_logic;
  signal tmp_0269 : std_logic;
  signal tmp_0270 : std_logic;
  signal tmp_0271 : std_logic;
  signal write_data_call_flag_0048 : std_logic;
  signal tmp_0272 : std_logic;
  signal tmp_0273 : std_logic;
  signal tmp_0274 : std_logic;
  signal tmp_0275 : std_logic;
  signal tmp_0276 : std_logic;
  signal tmp_0277 : std_logic;
  signal tmp_0278 : std_logic;
  signal tmp_0279 : std_logic;
  signal tmp_0280 : signed(32-1 downto 0);
  signal tmp_0281 : signed(32-1 downto 0);
  signal tmp_0282 : signed(32-1 downto 0);
  signal tmp_0283 : signed(32-1 downto 0);
  signal tmp_0284 : signed(32-1 downto 0);
  signal tmp_0285 : signed(32-1 downto 0);
  signal tmp_0286 : signed(32-1 downto 0);
  signal tmp_0287 : signed(32-1 downto 0);
  signal tmp_0288 : signed(32-1 downto 0);
  signal tmp_0289 : signed(32-1 downto 0);
  signal tmp_0290 : std_logic;
  signal tmp_0291 : signed(32-1 downto 0);
  signal tmp_0292 : std_logic;
  signal tmp_0293 : signed(32-1 downto 0);
  signal tmp_0294 : signed(32-1 downto 0);
  signal tmp_0295 : signed(32-1 downto 0);
  signal tmp_0296 : signed(32-1 downto 0);
  signal tmp_0297 : signed(32-1 downto 0);
  signal tmp_0298 : signed(32-1 downto 0);
  signal tmp_0299 : signed(32-1 downto 0);
  signal tmp_0300 : signed(32-1 downto 0);
  signal tmp_0301 : signed(32-1 downto 0);
  signal tmp_0302 : signed(32-1 downto 0);
  signal tmp_0303 : signed(32-1 downto 0);
  type Type_push_send_data_method is (
    push_send_data_method_IDLE,
    push_send_data_method_S_0000,
    push_send_data_method_S_0001,
    push_send_data_method_S_0002,
    push_send_data_method_S_0009,
    push_send_data_method_S_0010,
    push_send_data_method_S_0014,
    push_send_data_method_S_0015,
    push_send_data_method_S_0017,
    push_send_data_method_S_0018,
    push_send_data_method_S_0019,
    push_send_data_method_S_0021,
    push_send_data_method_S_0022,
    push_send_data_method_S_0023,
    push_send_data_method_S_0024,
    push_send_data_method_S_0025,
    push_send_data_method_S_0026,
    push_send_data_method_S_0028,
    push_send_data_method_S_0029,
    push_send_data_method_S_0031,
    push_send_data_method_S_0032,
    push_send_data_method_S_0035,
    push_send_data_method_S_0036,
    push_send_data_method_S_0038,
    push_send_data_method_S_0039,
    push_send_data_method_S_0042,
    push_send_data_method_S_0043,
    push_send_data_method_S_0044,
    push_send_data_method_S_0046,
    push_send_data_method_S_0047,
    push_send_data_method_S_0051,
    push_send_data_method_S_0052,
    push_send_data_method_S_0056,
    push_send_data_method_S_0057,
    push_send_data_method_S_0061,
    push_send_data_method_S_0062,
    push_send_data_method_S_0064,
    push_send_data_method_S_0065,
    push_send_data_method_S_0009_body,
    push_send_data_method_S_0009_wait,
    push_send_data_method_S_0014_body,
    push_send_data_method_S_0014_wait,
    push_send_data_method_S_0035_body,
    push_send_data_method_S_0035_wait,
    push_send_data_method_S_0042_body,
    push_send_data_method_S_0042_wait,
    push_send_data_method_S_0046_body,
    push_send_data_method_S_0046_wait,
    push_send_data_method_S_0051_body,
    push_send_data_method_S_0051_wait,
    push_send_data_method_S_0056_body,
    push_send_data_method_S_0056_wait,
    push_send_data_method_S_0061_body,
    push_send_data_method_S_0061_wait,
    push_send_data_method_S_0064_body,
    push_send_data_method_S_0064_wait  
  );
  signal push_send_data_method : Type_push_send_data_method := push_send_data_method_IDLE;
  signal push_send_data_method_delay : signed(32-1 downto 0) := (others => '0');
  signal push_send_data_req_flag_d : std_logic := '0';
  signal push_send_data_req_flag_edge : std_logic;
  signal tmp_0304 : std_logic;
  signal tmp_0305 : std_logic;
  signal tmp_0306 : std_logic;
  signal tmp_0307 : std_logic;
  signal tmp_0308 : std_logic;
  signal tmp_0309 : std_logic;
  signal tmp_0310 : std_logic;
  signal tmp_0311 : std_logic;
  signal write_data_call_flag_0035 : std_logic;
  signal tmp_0312 : std_logic;
  signal tmp_0313 : std_logic;
  signal tmp_0314 : std_logic;
  signal tmp_0315 : std_logic;
  signal write_data_call_flag_0042 : std_logic;
  signal tmp_0316 : std_logic;
  signal tmp_0317 : std_logic;
  signal tmp_0318 : std_logic;
  signal tmp_0319 : std_logic;
  signal write_data_call_flag_0046 : std_logic;
  signal tmp_0320 : std_logic;
  signal tmp_0321 : std_logic;
  signal tmp_0322 : std_logic;
  signal tmp_0323 : std_logic;
  signal write_data_call_flag_0051 : std_logic;
  signal tmp_0324 : std_logic;
  signal tmp_0325 : std_logic;
  signal tmp_0326 : std_logic;
  signal tmp_0327 : std_logic;
  signal write_data_call_flag_0056 : std_logic;
  signal tmp_0328 : std_logic;
  signal tmp_0329 : std_logic;
  signal tmp_0330 : std_logic;
  signal tmp_0331 : std_logic;
  signal write_data_call_flag_0061 : std_logic;
  signal tmp_0332 : std_logic;
  signal tmp_0333 : std_logic;
  signal tmp_0334 : std_logic;
  signal tmp_0335 : std_logic;
  signal write_data_call_flag_0064 : std_logic;
  signal tmp_0336 : std_logic;
  signal tmp_0337 : std_logic;
  signal tmp_0338 : std_logic;
  signal tmp_0339 : std_logic;
  signal tmp_0340 : std_logic;
  signal tmp_0341 : std_logic;
  signal tmp_0342 : std_logic;
  signal tmp_0343 : std_logic;
  signal tmp_0344 : signed(32-1 downto 0);
  signal tmp_0345 : signed(32-1 downto 0);
  signal tmp_0346 : signed(32-1 downto 0);
  signal tmp_0347 : signed(32-1 downto 0);
  signal tmp_0348 : signed(32-1 downto 0);
  signal tmp_0349 : signed(8-1 downto 0);
  signal tmp_0350 : signed(32-1 downto 0);
  signal tmp_0351 : signed(32-1 downto 0);
  signal tmp_0352 : signed(32-1 downto 0);
  signal tmp_0353 : signed(8-1 downto 0);
  signal tmp_0354 : signed(32-1 downto 0);
  signal tmp_0355 : std_logic;
  signal tmp_0356 : signed(32-1 downto 0);
  signal tmp_0357 : std_logic;
  signal tmp_0358 : signed(32-1 downto 0);
  signal tmp_0359 : signed(32-1 downto 0);
  signal tmp_0360 : signed(32-1 downto 0);
  signal tmp_0361 : signed(32-1 downto 0);
  signal tmp_0362 : signed(32-1 downto 0);
  signal tmp_0363 : signed(32-1 downto 0);
  signal tmp_0364 : signed(32-1 downto 0);
  signal tmp_0365 : signed(32-1 downto 0);
  signal tmp_0366 : signed(32-1 downto 0);
  signal tmp_0367 : signed(32-1 downto 0);
  signal tmp_0368 : signed(32-1 downto 0);
  signal tmp_0369 : signed(32-1 downto 0);
  signal tmp_0370 : signed(32-1 downto 0);
  signal tmp_0371 : signed(32-1 downto 0);
  signal tmp_0372 : signed(8-1 downto 0);
  signal tmp_0373 : signed(32-1 downto 0);
  signal tmp_0374 : signed(32-1 downto 0);
  signal tmp_0375 : signed(32-1 downto 0);
  signal tmp_0376 : signed(8-1 downto 0);
  signal tmp_0377 : signed(32-1 downto 0);
  signal tmp_0378 : signed(32-1 downto 0);
  signal tmp_0379 : signed(32-1 downto 0);
  signal tmp_0380 : signed(8-1 downto 0);
  signal tmp_0381 : signed(32-1 downto 0);
  signal tmp_0382 : signed(32-1 downto 0);
  type Type_pack_method is (
    pack_method_IDLE,
    pack_method_S_0000,
    pack_method_S_0001,
    pack_method_S_0002,
    pack_method_S_0016,
    pack_method_S_0017  
  );
  signal pack_method : Type_pack_method := pack_method_IDLE;
  signal pack_method_delay : signed(32-1 downto 0) := (others => '0');
  signal pack_req_flag_d : std_logic := '0';
  signal pack_req_flag_edge : std_logic;
  signal tmp_0383 : std_logic;
  signal tmp_0384 : std_logic;
  signal tmp_0385 : std_logic;
  signal tmp_0386 : std_logic;
  signal tmp_0387 : std_logic;
  signal tmp_0388 : std_logic;
  signal tmp_0389 : std_logic;
  signal tmp_0390 : std_logic;
  signal tmp_0391 : std_logic_vector(32-1 downto 0);
  signal tmp_0392 : std_logic_vector(32-1 downto 0);
  signal tmp_0393 : std_logic_vector(32-1 downto 0);
  signal tmp_0394 : std_logic_vector(32-1 downto 0);
  signal tmp_0395 : signed(32-1 downto 0);
  signal tmp_0396 : signed(32-1 downto 0);
  signal tmp_0397 : signed(32-1 downto 0);
  signal tmp_0398 : signed(32-1 downto 0);
  signal tmp_0399 : signed(32-1 downto 0);
  signal tmp_0400 : signed(32-1 downto 0);
  signal tmp_0401 : signed(32-1 downto 0);
  signal tmp_0402 : signed(32-1 downto 0);
  signal tmp_0403 : signed(32-1 downto 0);
  signal tmp_0404 : signed(32-1 downto 0);
  type Type_init_contents_method is (
    init_contents_method_IDLE,
    init_contents_method_S_0000,
    init_contents_method_S_0001,
    init_contents_method_S_0002,
    init_contents_method_S_0003,
    init_contents_method_S_0004,
    init_contents_method_S_0005,
    init_contents_method_S_0006,
    init_contents_method_S_0007,
    init_contents_method_S_0008,
    init_contents_method_S_0009,
    init_contents_method_S_0010,
    init_contents_method_S_0011,
    init_contents_method_S_0012,
    init_contents_method_S_0013,
    init_contents_method_S_0014,
    init_contents_method_S_0015,
    init_contents_method_S_0016,
    init_contents_method_S_0017,
    init_contents_method_S_0018,
    init_contents_method_S_0019,
    init_contents_method_S_0020,
    init_contents_method_S_0021,
    init_contents_method_S_0022,
    init_contents_method_S_0023,
    init_contents_method_S_0024,
    init_contents_method_S_0025,
    init_contents_method_S_0026,
    init_contents_method_S_0027,
    init_contents_method_S_0028,
    init_contents_method_S_0029,
    init_contents_method_S_0030,
    init_contents_method_S_0031,
    init_contents_method_S_0034,
    init_contents_method_S_0035,
    init_contents_method_S_0036,
    init_contents_method_S_0003_body,
    init_contents_method_S_0003_wait,
    init_contents_method_S_0006_body,
    init_contents_method_S_0006_wait,
    init_contents_method_S_0009_body,
    init_contents_method_S_0009_wait,
    init_contents_method_S_0012_body,
    init_contents_method_S_0012_wait,
    init_contents_method_S_0015_body,
    init_contents_method_S_0015_wait,
    init_contents_method_S_0018_body,
    init_contents_method_S_0018_wait,
    init_contents_method_S_0021_body,
    init_contents_method_S_0021_wait,
    init_contents_method_S_0024_body,
    init_contents_method_S_0024_wait,
    init_contents_method_S_0027_body,
    init_contents_method_S_0027_wait,
    init_contents_method_S_0030_body,
    init_contents_method_S_0030_wait,
    init_contents_method_S_0034_body,
    init_contents_method_S_0034_wait  
  );
  signal init_contents_method : Type_init_contents_method := init_contents_method_IDLE;
  signal init_contents_method_delay : signed(32-1 downto 0) := (others => '0');
  signal init_contents_req_flag_d : std_logic := '0';
  signal init_contents_req_flag_edge : std_logic;
  signal tmp_0405 : std_logic;
  signal tmp_0406 : std_logic;
  signal tmp_0407 : std_logic;
  signal tmp_0408 : std_logic;
  signal pack_call_flag_0003 : std_logic;
  signal tmp_0409 : std_logic;
  signal tmp_0410 : std_logic;
  signal tmp_0411 : std_logic;
  signal tmp_0412 : std_logic;
  signal pack_call_flag_0006 : std_logic;
  signal tmp_0413 : std_logic;
  signal tmp_0414 : std_logic;
  signal tmp_0415 : std_logic;
  signal tmp_0416 : std_logic;
  signal pack_call_flag_0009 : std_logic;
  signal tmp_0417 : std_logic;
  signal tmp_0418 : std_logic;
  signal tmp_0419 : std_logic;
  signal tmp_0420 : std_logic;
  signal pack_call_flag_0012 : std_logic;
  signal tmp_0421 : std_logic;
  signal tmp_0422 : std_logic;
  signal tmp_0423 : std_logic;
  signal tmp_0424 : std_logic;
  signal pack_call_flag_0015 : std_logic;
  signal tmp_0425 : std_logic;
  signal tmp_0426 : std_logic;
  signal tmp_0427 : std_logic;
  signal tmp_0428 : std_logic;
  signal pack_call_flag_0018 : std_logic;
  signal tmp_0429 : std_logic;
  signal tmp_0430 : std_logic;
  signal tmp_0431 : std_logic;
  signal tmp_0432 : std_logic;
  signal pack_call_flag_0021 : std_logic;
  signal tmp_0433 : std_logic;
  signal tmp_0434 : std_logic;
  signal tmp_0435 : std_logic;
  signal tmp_0436 : std_logic;
  signal pack_call_flag_0024 : std_logic;
  signal tmp_0437 : std_logic;
  signal tmp_0438 : std_logic;
  signal tmp_0439 : std_logic;
  signal tmp_0440 : std_logic;
  signal pack_call_flag_0027 : std_logic;
  signal tmp_0441 : std_logic;
  signal tmp_0442 : std_logic;
  signal tmp_0443 : std_logic;
  signal tmp_0444 : std_logic;
  signal pack_call_flag_0030 : std_logic;
  signal tmp_0445 : std_logic;
  signal tmp_0446 : std_logic;
  signal tmp_0447 : std_logic;
  signal tmp_0448 : std_logic;
  signal i_to_4digit_ascii_ext_call_flag_0034 : std_logic;
  signal tmp_0449 : std_logic;
  signal tmp_0450 : std_logic;
  signal tmp_0451 : std_logic;
  signal tmp_0452 : std_logic;
  signal tmp_0453 : std_logic;
  signal tmp_0454 : std_logic;
  signal tmp_0455 : std_logic;
  signal tmp_0456 : std_logic;
  signal tmp_0457 : signed(32-1 downto 0);
  type Type_ready_contents_method is (
    ready_contents_method_IDLE,
    ready_contents_method_S_0000,
    ready_contents_method_S_0001,
    ready_contents_method_S_0002,
    ready_contents_method_S_0003,
    ready_contents_method_S_0004,
    ready_contents_method_S_0005,
    ready_contents_method_S_0006,
    ready_contents_method_S_0007,
    ready_contents_method_S_0009,
    ready_contents_method_S_0010,
    ready_contents_method_S_0011,
    ready_contents_method_S_0012,
    ready_contents_method_S_0015,
    ready_contents_method_S_0016,
    ready_contents_method_S_0021,
    ready_contents_method_S_0022,
    ready_contents_method_S_0027,
    ready_contents_method_S_0028,
    ready_contents_method_S_0033,
    ready_contents_method_S_0034,
    ready_contents_method_S_0037,
    ready_contents_method_S_0038,
    ready_contents_method_S_0040,
    ready_contents_method_S_0041,
    ready_contents_method_S_0046,
    ready_contents_method_S_0047,
    ready_contents_method_S_0052,
    ready_contents_method_S_0053,
    ready_contents_method_S_0058,
    ready_contents_method_S_0059,
    ready_contents_method_S_0062,
    ready_contents_method_S_0063,
    ready_contents_method_S_0065,
    ready_contents_method_S_0066,
    ready_contents_method_S_0067,
    ready_contents_method_S_0068,
    ready_contents_method_S_0070,
    ready_contents_method_S_0071,
    ready_contents_method_S_0072,
    ready_contents_method_S_0077,
    ready_contents_method_S_0078,
    ready_contents_method_S_0082,
    ready_contents_method_S_0083,
    ready_contents_method_S_0087,
    ready_contents_method_S_0088,
    ready_contents_method_S_0092,
    ready_contents_method_S_0093,
    ready_contents_method_S_0097,
    ready_contents_method_S_0098,
    ready_contents_method_S_0099,
    ready_contents_method_S_0100,
    ready_contents_method_S_0102,
    ready_contents_method_S_0103,
    ready_contents_method_S_0105,
    ready_contents_method_S_0106,
    ready_contents_method_S_0107,
    ready_contents_method_S_0108,
    ready_contents_method_S_0110,
    ready_contents_method_S_0111  
  );
  signal ready_contents_method : Type_ready_contents_method := ready_contents_method_IDLE;
  signal ready_contents_method_delay : signed(32-1 downto 0) := (others => '0');
  signal ready_contents_req_flag_d : std_logic := '0';
  signal ready_contents_req_flag_edge : std_logic;
  signal tmp_0458 : std_logic;
  signal tmp_0459 : std_logic;
  signal tmp_0460 : std_logic;
  signal tmp_0461 : std_logic;
  signal tmp_0462 : std_logic;
  signal tmp_0463 : std_logic;
  signal tmp_0464 : std_logic;
  signal tmp_0465 : std_logic;
  signal tmp_0466 : std_logic;
  signal tmp_0467 : std_logic;
  signal tmp_0468 : std_logic;
  signal tmp_0469 : std_logic;
  signal tmp_0470 : std_logic;
  signal tmp_0471 : std_logic;
  signal tmp_0472 : std_logic;
  signal tmp_0473 : signed(32-1 downto 0);
  signal tmp_0474 : signed(32-1 downto 0);
  signal tmp_0475 : signed(32-1 downto 0);
  signal tmp_0476 : signed(32-1 downto 0);
  signal tmp_0477 : signed(32-1 downto 0);
  signal tmp_0478 : signed(8-1 downto 0);
  signal tmp_0479 : signed(32-1 downto 0);
  signal tmp_0480 : signed(32-1 downto 0);
  signal tmp_0481 : signed(32-1 downto 0);
  signal tmp_0482 : signed(8-1 downto 0);
  signal tmp_0483 : signed(32-1 downto 0);
  signal tmp_0484 : signed(32-1 downto 0);
  signal tmp_0485 : signed(32-1 downto 0);
  signal tmp_0486 : signed(8-1 downto 0);
  signal tmp_0487 : signed(32-1 downto 0);
  signal tmp_0488 : signed(32-1 downto 0);
  signal tmp_0489 : signed(8-1 downto 0);
  signal tmp_0490 : signed(32-1 downto 0);
  signal tmp_0491 : signed(32-1 downto 0);
  signal tmp_0492 : signed(32-1 downto 0);
  signal tmp_0493 : signed(32-1 downto 0);
  signal tmp_0494 : signed(8-1 downto 0);
  signal tmp_0495 : signed(32-1 downto 0);
  signal tmp_0496 : signed(32-1 downto 0);
  signal tmp_0497 : signed(32-1 downto 0);
  signal tmp_0498 : signed(8-1 downto 0);
  signal tmp_0499 : signed(32-1 downto 0);
  signal tmp_0500 : signed(32-1 downto 0);
  signal tmp_0501 : signed(32-1 downto 0);
  signal tmp_0502 : signed(8-1 downto 0);
  signal tmp_0503 : signed(32-1 downto 0);
  signal tmp_0504 : signed(32-1 downto 0);
  signal tmp_0505 : signed(8-1 downto 0);
  signal tmp_0506 : std_logic;
  signal tmp_0507 : signed(32-1 downto 0);
  signal tmp_0508 : signed(32-1 downto 0);
  signal tmp_0509 : signed(32-1 downto 0);
  signal tmp_0510 : signed(32-1 downto 0);
  signal tmp_0511 : signed(32-1 downto 0);
  signal tmp_0512 : signed(32-1 downto 0);
  signal tmp_0513 : signed(8-1 downto 0);
  signal tmp_0514 : signed(32-1 downto 0);
  signal tmp_0515 : signed(32-1 downto 0);
  signal tmp_0516 : signed(8-1 downto 0);
  signal tmp_0517 : signed(32-1 downto 0);
  signal tmp_0518 : signed(32-1 downto 0);
  signal tmp_0519 : signed(8-1 downto 0);
  signal tmp_0520 : signed(32-1 downto 0);
  signal tmp_0521 : std_logic;
  signal tmp_0522 : signed(8-1 downto 0);
  signal tmp_0523 : signed(32-1 downto 0);
  signal tmp_0524 : signed(32-1 downto 0);
  signal tmp_0525 : signed(32-1 downto 0);
  signal tmp_0526 : signed(32-1 downto 0);
  type Type_action_method is (
    action_method_IDLE,
    action_method_S_0000,
    action_method_S_0001,
    action_method_S_0002,
    action_method_S_0006,
    action_method_S_0007,
    action_method_S_0008,
    action_method_S_0009,
    action_method_S_0011,
    action_method_S_0012,
    action_method_S_0013,
    action_method_S_0014,
    action_method_S_0015,
    action_method_S_0016,
    action_method_S_0017,
    action_method_S_0018,
    action_method_S_0019,
    action_method_S_0020,
    action_method_S_0021,
    action_method_S_0022,
    action_method_S_0023,
    action_method_S_0025,
    action_method_S_0026,
    action_method_S_0027,
    action_method_S_0028,
    action_method_S_0029,
    action_method_S_0030,
    action_method_S_0031,
    action_method_S_0032,
    action_method_S_0033,
    action_method_S_0035,
    action_method_S_0036,
    action_method_S_0037,
    action_method_S_0038,
    action_method_S_0039,
    action_method_S_0040,
    action_method_S_0041,
    action_method_S_0042,
    action_method_S_0043,
    action_method_S_0044,
    action_method_S_0045,
    action_method_S_0046,
    action_method_S_0047,
    action_method_S_0048,
    action_method_S_0049,
    action_method_S_0050,
    action_method_S_0051,
    action_method_S_0052,
    action_method_S_0053,
    action_method_S_0054,
    action_method_S_0055,
    action_method_S_0056,
    action_method_S_0057,
    action_method_S_0058,
    action_method_S_0059,
    action_method_S_0060,
    action_method_S_0061,
    action_method_S_0062,
    action_method_S_0063,
    action_method_S_0064,
    action_method_S_0065,
    action_method_S_0066,
    action_method_S_0067,
    action_method_S_0068,
    action_method_S_0069,
    action_method_S_0070,
    action_method_S_0071,
    action_method_S_0072,
    action_method_S_0073,
    action_method_S_0076,
    action_method_S_0077,
    action_method_S_0079,
    action_method_S_0080,
    action_method_S_0020_body,
    action_method_S_0020_wait,
    action_method_S_0030_body,
    action_method_S_0030_wait,
    action_method_S_0071_body,
    action_method_S_0071_wait  
  );
  signal action_method : Type_action_method := action_method_IDLE;
  signal action_method_delay : signed(32-1 downto 0) := (others => '0');
  signal action_req_flag_d : std_logic := '0';
  signal action_req_flag_edge : std_logic;
  signal tmp_0527 : std_logic;
  signal tmp_0528 : std_logic;
  signal tmp_0529 : std_logic;
  signal tmp_0530 : std_logic;
  signal tmp_0531 : std_logic;
  signal tmp_0532 : std_logic;
  signal tmp_0533 : std_logic;
  signal tmp_0534 : std_logic;
  signal tmp_0535 : std_logic;
  signal tmp_0536 : std_logic;
  signal tmp_0537 : std_logic;
  signal tmp_0538 : std_logic;
  signal isHex_ext_call_flag_0020 : std_logic;
  signal tmp_0539 : std_logic;
  signal tmp_0540 : std_logic;
  signal tmp_0541 : std_logic;
  signal tmp_0542 : std_logic;
  signal tmp_0543 : std_logic;
  signal tmp_0544 : std_logic;
  signal isHex_ext_call_flag_0030 : std_logic;
  signal tmp_0545 : std_logic;
  signal tmp_0546 : std_logic;
  signal tmp_0547 : std_logic;
  signal tmp_0548 : std_logic;
  signal tmp_0549 : std_logic;
  signal tmp_0550 : std_logic;
  signal tmp_0551 : std_logic;
  signal tmp_0552 : std_logic;
  signal tmp_0553 : std_logic;
  signal tmp_0554 : std_logic;
  signal tmp_0555 : std_logic;
  signal tmp_0556 : std_logic;
  signal tmp_0557 : std_logic;
  signal tmp_0558 : std_logic;
  signal toHex2_ext_call_flag_0071 : std_logic;
  signal tmp_0559 : std_logic;
  signal tmp_0560 : std_logic;
  signal tmp_0561 : std_logic;
  signal tmp_0562 : std_logic;
  signal tmp_0563 : std_logic;
  signal tmp_0564 : std_logic;
  signal tmp_0565 : std_logic;
  signal tmp_0566 : std_logic;
  signal tmp_0567 : std_logic;
  signal tmp_0568 : signed(32-1 downto 0);
  signal tmp_0569 : std_logic;
  signal tmp_0570 : std_logic;
  signal tmp_0571 : std_logic;
  signal tmp_0572 : std_logic;
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
    tcp_server_method_S_0023,
    tcp_server_method_S_0024,
    tcp_server_method_S_0025,
    tcp_server_method_S_0026,
    tcp_server_method_S_0027,
    tcp_server_method_S_0028,
    tcp_server_method_S_0030,
    tcp_server_method_S_0031,
    tcp_server_method_S_0032,
    tcp_server_method_S_0033,
    tcp_server_method_S_0034,
    tcp_server_method_S_0036,
    tcp_server_method_S_0037,
    tcp_server_method_S_0038,
    tcp_server_method_S_0039,
    tcp_server_method_S_0040,
    tcp_server_method_S_0041,
    tcp_server_method_S_0042,
    tcp_server_method_S_0043,
    tcp_server_method_S_0044,
    tcp_server_method_S_0045,
    tcp_server_method_S_0046,
    tcp_server_method_S_0047,
    tcp_server_method_S_0048,
    tcp_server_method_S_0004_body,
    tcp_server_method_S_0004_wait,
    tcp_server_method_S_0005_body,
    tcp_server_method_S_0005_wait,
    tcp_server_method_S_0012_body,
    tcp_server_method_S_0012_wait,
    tcp_server_method_S_0013_body,
    tcp_server_method_S_0013_wait,
    tcp_server_method_S_0016_body,
    tcp_server_method_S_0016_wait,
    tcp_server_method_S_0023_body,
    tcp_server_method_S_0023_wait,
    tcp_server_method_S_0024_body,
    tcp_server_method_S_0024_wait,
    tcp_server_method_S_0027_body,
    tcp_server_method_S_0027_wait,
    tcp_server_method_S_0030_body,
    tcp_server_method_S_0030_wait,
    tcp_server_method_S_0033_body,
    tcp_server_method_S_0033_wait,
    tcp_server_method_S_0040_body,
    tcp_server_method_S_0040_wait,
    tcp_server_method_S_0042_body,
    tcp_server_method_S_0042_wait,
    tcp_server_method_S_0043_body,
    tcp_server_method_S_0043_wait,
    tcp_server_method_S_0045_body,
    tcp_server_method_S_0045_wait  
  );
  signal tcp_server_method : Type_tcp_server_method := tcp_server_method_IDLE;
  signal tcp_server_method_delay : signed(32-1 downto 0) := (others => '0');
  signal tcp_server_req_flag_d : std_logic := '0';
  signal tcp_server_req_flag_edge : std_logic;
  signal tmp_0573 : std_logic;
  signal tmp_0574 : std_logic;
  signal tmp_0575 : std_logic;
  signal tmp_0576 : std_logic;
  signal tcp_server_open_call_flag_0005 : std_logic;
  signal tmp_0577 : std_logic;
  signal tmp_0578 : std_logic;
  signal tmp_0579 : std_logic;
  signal tmp_0580 : std_logic;
  signal tmp_0581 : std_logic;
  signal tmp_0582 : std_logic;
  signal tcp_server_open_call_flag_0013 : std_logic;
  signal tmp_0583 : std_logic;
  signal tmp_0584 : std_logic;
  signal tmp_0585 : std_logic;
  signal tmp_0586 : std_logic;
  signal tcp_server_listen_call_flag_0016 : std_logic;
  signal tmp_0587 : std_logic;
  signal tmp_0588 : std_logic;
  signal tmp_0589 : std_logic;
  signal tmp_0590 : std_logic;
  signal tmp_0591 : std_logic;
  signal tmp_0592 : std_logic;
  signal write_data_call_flag_0023 : std_logic;
  signal tmp_0593 : std_logic;
  signal tmp_0594 : std_logic;
  signal tmp_0595 : std_logic;
  signal tmp_0596 : std_logic;
  signal tcp_server_listen_call_flag_0024 : std_logic;
  signal tmp_0597 : std_logic;
  signal tmp_0598 : std_logic;
  signal tmp_0599 : std_logic;
  signal tmp_0600 : std_logic;
  signal wait_for_established_call_flag_0027 : std_logic;
  signal tmp_0601 : std_logic;
  signal tmp_0602 : std_logic;
  signal tmp_0603 : std_logic;
  signal tmp_0604 : std_logic;
  signal read_data_call_flag_0030 : std_logic;
  signal tmp_0605 : std_logic;
  signal tmp_0606 : std_logic;
  signal tmp_0607 : std_logic;
  signal tmp_0608 : std_logic;
  signal tmp_0609 : std_logic;
  signal tmp_0610 : std_logic;
  signal wait_for_recv_call_flag_0033 : std_logic;
  signal tmp_0611 : std_logic;
  signal tmp_0612 : std_logic;
  signal tmp_0613 : std_logic;
  signal tmp_0614 : std_logic;
  signal tmp_0615 : std_logic;
  signal tmp_0616 : std_logic;
  signal pull_recv_data_call_flag_0040 : std_logic;
  signal tmp_0617 : std_logic;
  signal tmp_0618 : std_logic;
  signal tmp_0619 : std_logic;
  signal tmp_0620 : std_logic;
  signal action_call_flag_0042 : std_logic;
  signal tmp_0621 : std_logic;
  signal tmp_0622 : std_logic;
  signal tmp_0623 : std_logic;
  signal tmp_0624 : std_logic;
  signal ready_contents_call_flag_0043 : std_logic;
  signal tmp_0625 : std_logic;
  signal tmp_0626 : std_logic;
  signal tmp_0627 : std_logic;
  signal tmp_0628 : std_logic;
  signal push_send_data_call_flag_0045 : std_logic;
  signal tmp_0629 : std_logic;
  signal tmp_0630 : std_logic;
  signal tmp_0631 : std_logic;
  signal tmp_0632 : std_logic;
  signal tmp_0633 : std_logic;
  signal tmp_0634 : std_logic;
  signal tmp_0635 : std_logic;
  signal tmp_0636 : std_logic;
  signal tmp_0637 : signed(32-1 downto 0);
  signal tmp_0638 : signed(32-1 downto 0);
  signal tmp_0639 : std_logic;
  signal tmp_0640 : signed(32-1 downto 0);
  signal tmp_0641 : signed(32-1 downto 0);
  signal tmp_0642 : std_logic;
  signal tmp_0643 : signed(32-1 downto 0);
  signal tmp_0644 : signed(32-1 downto 0);
  signal tmp_0645 : signed(32-1 downto 0);
  signal tmp_0646 : signed(32-1 downto 0);
  signal tmp_0647 : std_logic;
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
    test_method_S_0013,
    test_method_S_0014,
    test_method_S_0003_body,
    test_method_S_0003_wait,
    test_method_S_0005_body,
    test_method_S_0005_wait,
    test_method_S_0007_body,
    test_method_S_0007_wait,
    test_method_S_0012_body,
    test_method_S_0012_wait  
  );
  signal test_method : Type_test_method := test_method_IDLE;
  signal test_method_delay : signed(32-1 downto 0) := (others => '0');
  signal test_req_flag_d : std_logic := '0';
  signal test_req_flag_edge : std_logic;
  signal tmp_0648 : std_logic;
  signal tmp_0649 : std_logic;
  signal tmp_0650 : std_logic;
  signal tmp_0651 : std_logic;
  signal init_call_flag_0003 : std_logic;
  signal tmp_0652 : std_logic;
  signal tmp_0653 : std_logic;
  signal tmp_0654 : std_logic;
  signal tmp_0655 : std_logic;
  signal network_configuration_call_flag_0005 : std_logic;
  signal tmp_0656 : std_logic;
  signal tmp_0657 : std_logic;
  signal tmp_0658 : std_logic;
  signal tmp_0659 : std_logic;
  signal init_contents_call_flag_0007 : std_logic;
  signal tmp_0660 : std_logic;
  signal tmp_0661 : std_logic;
  signal tmp_0662 : std_logic;
  signal tmp_0663 : std_logic;
  signal tmp_0664 : std_logic;
  signal tmp_0665 : std_logic;
  signal tcp_server_call_flag_0012 : std_logic;
  signal tmp_0666 : std_logic;
  signal tmp_0667 : std_logic;
  signal tmp_0668 : std_logic;
  signal tmp_0669 : std_logic;
  signal tmp_0670 : std_logic;
  signal tmp_0671 : std_logic;
  signal tmp_0672 : std_logic;
  signal tmp_0673 : std_logic;
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
  signal tmp_0674 : std_logic;
  signal tmp_0675 : std_logic;
  signal tmp_0676 : std_logic;
  signal tmp_0677 : std_logic;
  signal tmp_0678 : std_logic;
  signal tmp_0679 : std_logic;
  signal tmp_0680 : std_logic;
  signal tmp_0681 : std_logic;

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

  arg0_in_sig <= arg0_in;
  arg0_we_sig <= arg0_we;
  arg0_out <= arg0_out_sig;
  arg0_out_sig <= class_arg0_0096;

  arg1_in_sig <= arg1_in;
  arg1_we_sig <= arg1_we;
  arg1_out <= arg1_out_sig;
  arg1_out_sig <= class_arg1_0097;

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
          test_busy_sig <= tmp_0651;
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
          blink_led_busy_sig <= tmp_0677;
        end if;
      end if;
    end if;
  end process;

  blink_led_req_sig <= blink_led_req;

  -- expressions
  tmp_0001 <= led_in_sig when led_we_sig = '1' else class_led_0002;
  tmp_0002 <= arg0_in_sig when arg0_we_sig = '1' else class_arg0_0096;
  tmp_0003 <= arg1_in_sig when arg1_we_sig = '1' else class_arg1_0097;
  tmp_0004 <= test_req_local or test_req_sig;
  tmp_0005 <= blink_led_req_local or blink_led_req_sig;
  tmp_0006 <= not wait_cycles_req_flag_d;
  tmp_0007 <= wait_cycles_req_flag and tmp_0006;
  tmp_0008 <= wait_cycles_req_flag or wait_cycles_req_flag_d;
  tmp_0009 <= wait_cycles_req_flag or wait_cycles_req_flag_d;
  tmp_0010 <= '1' when binary_expr_00100 = '1' else '0';
  tmp_0011 <= '1' when binary_expr_00100 = '0' else '0';
  tmp_0012 <= '1' when wait_cycles_method /= wait_cycles_method_S_0000 else '0';
  tmp_0013 <= '1' when wait_cycles_method /= wait_cycles_method_S_0001 else '0';
  tmp_0014 <= tmp_0013 and wait_cycles_req_flag_edge;
  tmp_0015 <= tmp_0012 and tmp_0014;
  tmp_0016 <= '1' when wait_cycles_i_0099 < wait_cycles_n_0098 else '0';
  tmp_0017 <= wait_cycles_i_0099 + X"00000001";
  tmp_0018 <= not write_data_req_flag_d;
  tmp_0019 <= write_data_req_flag and tmp_0018;
  tmp_0020 <= write_data_req_flag or write_data_req_flag_d;
  tmp_0021 <= write_data_req_flag or write_data_req_flag_d;
  tmp_0022 <= '1' when wait_cycles_busy = '0' else '0';
  tmp_0023 <= '1' when wait_cycles_req_local = '0' else '0';
  tmp_0024 <= tmp_0022 and tmp_0023;
  tmp_0025 <= '1' when tmp_0024 = '1' else '0';
  tmp_0026 <= '1' when write_data_method /= write_data_method_S_0000 else '0';
  tmp_0027 <= '1' when write_data_method /= write_data_method_S_0001 else '0';
  tmp_0028 <= tmp_0027 and write_data_req_flag_edge;
  tmp_0029 <= tmp_0026 and tmp_0028;
  tmp_0030 <= not read_data_req_flag_d;
  tmp_0031 <= read_data_req_flag and tmp_0030;
  tmp_0032 <= read_data_req_flag or read_data_req_flag_d;
  tmp_0033 <= read_data_req_flag or read_data_req_flag_d;
  tmp_0034 <= '1' when wait_cycles_busy = '0' else '0';
  tmp_0035 <= '1' when wait_cycles_req_local = '0' else '0';
  tmp_0036 <= tmp_0034 and tmp_0035;
  tmp_0037 <= '1' when tmp_0036 = '1' else '0';
  tmp_0038 <= '1' when read_data_method /= read_data_method_S_0000 else '0';
  tmp_0039 <= '1' when read_data_method /= read_data_method_S_0001 else '0';
  tmp_0040 <= tmp_0039 and read_data_req_flag_edge;
  tmp_0041 <= tmp_0038 and tmp_0040;
  tmp_0042 <= not init_req_flag_d;
  tmp_0043 <= init_req_flag and tmp_0042;
  tmp_0044 <= init_req_flag or init_req_flag_d;
  tmp_0045 <= init_req_flag or init_req_flag_d;
  tmp_0046 <= '1' when wait_cycles_busy = '0' else '0';
  tmp_0047 <= '1' when wait_cycles_req_local = '0' else '0';
  tmp_0048 <= tmp_0046 and tmp_0047;
  tmp_0049 <= '1' when tmp_0048 = '1' else '0';
  tmp_0050 <= '1' when init_method /= init_method_S_0000 else '0';
  tmp_0051 <= '1' when init_method /= init_method_S_0001 else '0';
  tmp_0052 <= tmp_0051 and init_req_flag_edge;
  tmp_0053 <= tmp_0050 and tmp_0052;
  tmp_0054 <= not network_configuration_req_flag_d;
  tmp_0055 <= network_configuration_req_flag and tmp_0054;
  tmp_0056 <= network_configuration_req_flag or network_configuration_req_flag_d;
  tmp_0057 <= network_configuration_req_flag or network_configuration_req_flag_d;
  tmp_0058 <= '1' when write_data_busy = '0' else '0';
  tmp_0059 <= '1' when write_data_req_local = '0' else '0';
  tmp_0060 <= tmp_0058 and tmp_0059;
  tmp_0061 <= '1' when tmp_0060 = '1' else '0';
  tmp_0062 <= '1' when write_data_busy = '0' else '0';
  tmp_0063 <= '1' when write_data_req_local = '0' else '0';
  tmp_0064 <= tmp_0062 and tmp_0063;
  tmp_0065 <= '1' when tmp_0064 = '1' else '0';
  tmp_0066 <= '1' when write_data_busy = '0' else '0';
  tmp_0067 <= '1' when write_data_req_local = '0' else '0';
  tmp_0068 <= tmp_0066 and tmp_0067;
  tmp_0069 <= '1' when tmp_0068 = '1' else '0';
  tmp_0070 <= '1' when write_data_busy = '0' else '0';
  tmp_0071 <= '1' when write_data_req_local = '0' else '0';
  tmp_0072 <= tmp_0070 and tmp_0071;
  tmp_0073 <= '1' when tmp_0072 = '1' else '0';
  tmp_0074 <= '1' when write_data_busy = '0' else '0';
  tmp_0075 <= '1' when write_data_req_local = '0' else '0';
  tmp_0076 <= tmp_0074 and tmp_0075;
  tmp_0077 <= '1' when tmp_0076 = '1' else '0';
  tmp_0078 <= '1' when write_data_busy = '0' else '0';
  tmp_0079 <= '1' when write_data_req_local = '0' else '0';
  tmp_0080 <= tmp_0078 and tmp_0079;
  tmp_0081 <= '1' when tmp_0080 = '1' else '0';
  tmp_0082 <= '1' when write_data_busy = '0' else '0';
  tmp_0083 <= '1' when write_data_req_local = '0' else '0';
  tmp_0084 <= tmp_0082 and tmp_0083;
  tmp_0085 <= '1' when tmp_0084 = '1' else '0';
  tmp_0086 <= '1' when write_data_busy = '0' else '0';
  tmp_0087 <= '1' when write_data_req_local = '0' else '0';
  tmp_0088 <= tmp_0086 and tmp_0087;
  tmp_0089 <= '1' when tmp_0088 = '1' else '0';
  tmp_0090 <= '1' when write_data_busy = '0' else '0';
  tmp_0091 <= '1' when write_data_req_local = '0' else '0';
  tmp_0092 <= tmp_0090 and tmp_0091;
  tmp_0093 <= '1' when tmp_0092 = '1' else '0';
  tmp_0094 <= '1' when write_data_busy = '0' else '0';
  tmp_0095 <= '1' when write_data_req_local = '0' else '0';
  tmp_0096 <= tmp_0094 and tmp_0095;
  tmp_0097 <= '1' when tmp_0096 = '1' else '0';
  tmp_0098 <= '1' when write_data_busy = '0' else '0';
  tmp_0099 <= '1' when write_data_req_local = '0' else '0';
  tmp_0100 <= tmp_0098 and tmp_0099;
  tmp_0101 <= '1' when tmp_0100 = '1' else '0';
  tmp_0102 <= '1' when write_data_busy = '0' else '0';
  tmp_0103 <= '1' when write_data_req_local = '0' else '0';
  tmp_0104 <= tmp_0102 and tmp_0103;
  tmp_0105 <= '1' when tmp_0104 = '1' else '0';
  tmp_0106 <= '1' when write_data_busy = '0' else '0';
  tmp_0107 <= '1' when write_data_req_local = '0' else '0';
  tmp_0108 <= tmp_0106 and tmp_0107;
  tmp_0109 <= '1' when tmp_0108 = '1' else '0';
  tmp_0110 <= '1' when write_data_busy = '0' else '0';
  tmp_0111 <= '1' when write_data_req_local = '0' else '0';
  tmp_0112 <= tmp_0110 and tmp_0111;
  tmp_0113 <= '1' when tmp_0112 = '1' else '0';
  tmp_0114 <= '1' when write_data_busy = '0' else '0';
  tmp_0115 <= '1' when write_data_req_local = '0' else '0';
  tmp_0116 <= tmp_0114 and tmp_0115;
  tmp_0117 <= '1' when tmp_0116 = '1' else '0';
  tmp_0118 <= '1' when write_data_busy = '0' else '0';
  tmp_0119 <= '1' when write_data_req_local = '0' else '0';
  tmp_0120 <= tmp_0118 and tmp_0119;
  tmp_0121 <= '1' when tmp_0120 = '1' else '0';
  tmp_0122 <= '1' when write_data_busy = '0' else '0';
  tmp_0123 <= '1' when write_data_req_local = '0' else '0';
  tmp_0124 <= tmp_0122 and tmp_0123;
  tmp_0125 <= '1' when tmp_0124 = '1' else '0';
  tmp_0126 <= '1' when write_data_busy = '0' else '0';
  tmp_0127 <= '1' when write_data_req_local = '0' else '0';
  tmp_0128 <= tmp_0126 and tmp_0127;
  tmp_0129 <= '1' when tmp_0128 = '1' else '0';
  tmp_0130 <= '1' when network_configuration_method /= network_configuration_method_S_0000 else '0';
  tmp_0131 <= '1' when network_configuration_method /= network_configuration_method_S_0001 else '0';
  tmp_0132 <= tmp_0131 and network_configuration_req_flag_edge;
  tmp_0133 <= tmp_0130 and tmp_0132;
  tmp_0134 <= not tcp_server_open_req_flag_d;
  tmp_0135 <= tcp_server_open_req_flag and tmp_0134;
  tmp_0136 <= tcp_server_open_req_flag or tcp_server_open_req_flag_d;
  tmp_0137 <= tcp_server_open_req_flag or tcp_server_open_req_flag_d;
  tmp_0138 <= '1' when read_data_busy = '0' else '0';
  tmp_0139 <= '1' when read_data_req_local = '0' else '0';
  tmp_0140 <= tmp_0138 and tmp_0139;
  tmp_0141 <= '1' when tmp_0140 = '1' else '0';
  tmp_0142 <= '1' when tcp_server_open_method /= tcp_server_open_method_S_0000 else '0';
  tmp_0143 <= '1' when tcp_server_open_method /= tcp_server_open_method_S_0001 else '0';
  tmp_0144 <= tmp_0143 and tcp_server_open_req_flag_edge;
  tmp_0145 <= tmp_0142 and tmp_0144;
  tmp_0146 <= tcp_server_open_port_0145(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0147 <= (32-1 downto 8 => class_Sn_MR_TCP_0054(7)) & class_Sn_MR_TCP_0054;
  tmp_0148 <= class_Sn_MR1_0004 + tmp_0146;
  tmp_0149 <= X"00000020" or tmp_0147;
  tmp_0150 <= tmp_0149(32 - 24 - 1 downto 0);
  tmp_0151 <= tcp_server_open_port_0145(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0152 <= class_Sn_PORTR0_0013 + tmp_0151;
  tmp_0153 <= tcp_server_open_port_0145(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0154 <= class_Sn_PORTR1_0014 + tmp_0153;
  tmp_0155 <= tcp_server_open_port_0145(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0156 <= class_Sn_CR1_0006 + tmp_0155;
  tmp_0157 <= tcp_server_open_port_0145(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0158 <= class_Sn_SSR1_0012 + tmp_0157;
  tmp_0159 <= not tcp_server_listen_req_flag_d;
  tmp_0160 <= tcp_server_listen_req_flag and tmp_0159;
  tmp_0161 <= tcp_server_listen_req_flag or tcp_server_listen_req_flag_d;
  tmp_0162 <= tcp_server_listen_req_flag or tcp_server_listen_req_flag_d;
  tmp_0163 <= '1' when read_data_busy = '0' else '0';
  tmp_0164 <= '1' when read_data_req_local = '0' else '0';
  tmp_0165 <= tmp_0163 and tmp_0164;
  tmp_0166 <= '1' when tmp_0165 = '1' else '0';
  tmp_0167 <= '1' when tcp_server_listen_method /= tcp_server_listen_method_S_0000 else '0';
  tmp_0168 <= '1' when tcp_server_listen_method /= tcp_server_listen_method_S_0001 else '0';
  tmp_0169 <= tmp_0168 and tcp_server_listen_req_flag_edge;
  tmp_0170 <= tmp_0167 and tmp_0169;
  tmp_0171 <= tcp_server_listen_port_0164(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0172 <= class_Sn_CR1_0006 + tmp_0171;
  tmp_0173 <= tcp_server_listen_port_0164(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0174 <= class_Sn_SSR1_0012 + tmp_0173;
  tmp_0175 <= not wait_for_established_req_flag_d;
  tmp_0176 <= wait_for_established_req_flag and tmp_0175;
  tmp_0177 <= wait_for_established_req_flag or wait_for_established_req_flag_d;
  tmp_0178 <= wait_for_established_req_flag or wait_for_established_req_flag_d;
  tmp_0179 <= '1' and '1';
  tmp_0180 <= '1' and '0';
  tmp_0181 <= '1' when binary_expr_00176 = '1' else '0';
  tmp_0182 <= '1' when binary_expr_00176 = '0' else '0';
  tmp_0183 <= '1' when wait_for_established_method /= wait_for_established_method_S_0000 else '0';
  tmp_0184 <= '1' when wait_for_established_method /= wait_for_established_method_S_0001 else '0';
  tmp_0185 <= tmp_0184 and wait_for_established_req_flag_edge;
  tmp_0186 <= tmp_0183 and tmp_0185;
  tmp_0187 <= wait_for_established_port_0171(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0188 <= class_Sn_SSR1_0012 + tmp_0187;
  tmp_0189 <= '1' when method_result_00173 = class_Sn_SOCK_ESTABLISHED_0076 else '0';
  tmp_0190 <= not wait_for_recv_req_flag_d;
  tmp_0191 <= wait_for_recv_req_flag and tmp_0190;
  tmp_0192 <= wait_for_recv_req_flag or wait_for_recv_req_flag_d;
  tmp_0193 <= wait_for_recv_req_flag or wait_for_recv_req_flag_d;
  tmp_0194 <= '1' and '1';
  tmp_0195 <= '1' and '0';
  tmp_0196 <= '1' when read_data_busy = '0' else '0';
  tmp_0197 <= '1' when read_data_req_local = '0' else '0';
  tmp_0198 <= tmp_0196 and tmp_0197;
  tmp_0199 <= '1' when tmp_0198 = '1' else '0';
  tmp_0200 <= '1' when read_data_busy = '0' else '0';
  tmp_0201 <= '1' when read_data_req_local = '0' else '0';
  tmp_0202 <= tmp_0200 and tmp_0201;
  tmp_0203 <= '1' when tmp_0202 = '1' else '0';
  tmp_0204 <= '1' when read_data_busy = '0' else '0';
  tmp_0205 <= '1' when read_data_req_local = '0' else '0';
  tmp_0206 <= tmp_0204 and tmp_0205;
  tmp_0207 <= '1' when tmp_0206 = '1' else '0';
  tmp_0208 <= '1' when binary_expr_00198 = '1' else '0';
  tmp_0209 <= '1' when binary_expr_00198 = '0' else '0';
  tmp_0210 <= '1' when read_data_busy = '0' else '0';
  tmp_0211 <= '1' when read_data_req_local = '0' else '0';
  tmp_0212 <= tmp_0210 and tmp_0211;
  tmp_0213 <= '1' when tmp_0212 = '1' else '0';
  tmp_0214 <= '1' when binary_expr_00207 = '1' else '0';
  tmp_0215 <= '1' when binary_expr_00207 = '0' else '0';
  tmp_0216 <= '1' when write_data_busy = '0' else '0';
  tmp_0217 <= '1' when write_data_req_local = '0' else '0';
  tmp_0218 <= tmp_0216 and tmp_0217;
  tmp_0219 <= '1' when tmp_0218 = '1' else '0';
  tmp_0220 <= '1' when wait_for_recv_method /= wait_for_recv_method_S_0000 else '0';
  tmp_0221 <= '1' when wait_for_recv_method /= wait_for_recv_method_S_0001 else '0';
  tmp_0222 <= tmp_0221 and wait_for_recv_req_flag_edge;
  tmp_0223 <= tmp_0220 and tmp_0222;
  tmp_0224 <= wait_for_recv_port_0177(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0225 <= class_Sn_RX_RSR1_0044 + tmp_0224;
  tmp_0226 <= (32-1 downto 8 => method_result_00180(7)) & method_result_00180;
  tmp_0227 <= wait_for_recv_port_0177(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0228 <= class_Sn_RX_RSR2_0045 + tmp_0227;
  tmp_0229 <= (32-1 downto 8 => method_result_00185(7)) & method_result_00185;
  tmp_0230 <= wait_for_recv_port_0177(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0231 <= class_Sn_RX_RSR3_0046 + tmp_0230;
  tmp_0232 <= (32-1 downto 8 => method_result_00190(7)) & method_result_00190;
  tmp_0233 <= wait_for_recv_v0_0179(15 downto 0) & (16-1 downto 0 => '0');
  tmp_0234 <= wait_for_recv_v1_0184(23 downto 0) & (8-1 downto 0 => '0');
  tmp_0235 <= tmp_0233 + tmp_0234;
  tmp_0236 <= tmp_0235 + tmp_0232;
  tmp_0237 <= '1' when tmp_0236 /= X"00000000" else '0';
  tmp_0238 <= wait_for_recv_port_0177(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0239 <= class_Sn_SSR1_0012 + tmp_0238;
  tmp_0240 <= (32-1 downto 8 => method_result_00199(7)) & method_result_00199;
  tmp_0241 <= (32-1 downto 8 => class_Sn_SOCK_CLOSE_WAIT_0077(7)) & class_Sn_SOCK_CLOSE_WAIT_0077;
  tmp_0242 <= (32-1 downto 8 => class_Sn_SOCK_CLOSED_0073(7)) & class_Sn_SOCK_CLOSED_0073;
  tmp_0243 <= '1' when tmp_0240 = tmp_0241 else '0';
  tmp_0244 <= '1' when tmp_0240 = tmp_0242 else '0';
  tmp_0245 <= tmp_0243 or tmp_0244;
  tmp_0246 <= wait_for_recv_port_0177(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0247 <= class_Sn_CR1_0006 + tmp_0246;
  tmp_0248 <= not pull_recv_data_req_flag_d;
  tmp_0249 <= pull_recv_data_req_flag and tmp_0248;
  tmp_0250 <= pull_recv_data_req_flag or pull_recv_data_req_flag_d;
  tmp_0251 <= pull_recv_data_req_flag or pull_recv_data_req_flag_d;
  tmp_0252 <= '1' when read_data_busy = '0' else '0';
  tmp_0253 <= '1' when read_data_req_local = '0' else '0';
  tmp_0254 <= tmp_0252 and tmp_0253;
  tmp_0255 <= '1' when tmp_0254 = '1' else '0';
  tmp_0256 <= '1' when read_data_busy = '0' else '0';
  tmp_0257 <= '1' when read_data_req_local = '0' else '0';
  tmp_0258 <= tmp_0256 and tmp_0257;
  tmp_0259 <= '1' when tmp_0258 = '1' else '0';
  tmp_0260 <= '1' when binary_expr_00228 = '1' else '0';
  tmp_0261 <= '1' when binary_expr_00228 = '0' else '0';
  tmp_0262 <= '1' when binary_expr_00231 = '1' else '0';
  tmp_0263 <= '1' when binary_expr_00231 = '0' else '0';
  tmp_0264 <= '1' when read_data_busy = '0' else '0';
  tmp_0265 <= '1' when read_data_req_local = '0' else '0';
  tmp_0266 <= tmp_0264 and tmp_0265;
  tmp_0267 <= '1' when tmp_0266 = '1' else '0';
  tmp_0268 <= '1' when read_data_busy = '0' else '0';
  tmp_0269 <= '1' when read_data_req_local = '0' else '0';
  tmp_0270 <= tmp_0268 and tmp_0269;
  tmp_0271 <= '1' when tmp_0270 = '1' else '0';
  tmp_0272 <= '1' when write_data_busy = '0' else '0';
  tmp_0273 <= '1' when write_data_req_local = '0' else '0';
  tmp_0274 <= tmp_0272 and tmp_0273;
  tmp_0275 <= '1' when tmp_0274 = '1' else '0';
  tmp_0276 <= '1' when pull_recv_data_method /= pull_recv_data_method_S_0000 else '0';
  tmp_0277 <= '1' when pull_recv_data_method /= pull_recv_data_method_S_0001 else '0';
  tmp_0278 <= tmp_0277 and pull_recv_data_req_flag_edge;
  tmp_0279 <= tmp_0276 and tmp_0278;
  tmp_0280 <= pull_recv_data_port_0211(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0281 <= class_Sn_RX_FIFOR0_0051 + tmp_0280;
  tmp_0282 <= (32-1 downto 8 => method_result_00213(7)) & method_result_00213;
  tmp_0283 <= pull_recv_data_port_0211(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0284 <= class_Sn_RX_FIFOR1_0052 + tmp_0283;
  tmp_0285 <= (32-1 downto 8 => method_result_00218(7)) & method_result_00218;
  tmp_0286 <= pull_recv_data_v0_0212(23 downto 0) & (8-1 downto 0 => '0');
  tmp_0287 <= tmp_0286 + tmp_0285;
  tmp_0288 <= (1-1 downto 0 => tmp_0287(31)) & tmp_0287(31 downto 1);
  tmp_0289 <= tmp_0287 and X"00000001";
  tmp_0290 <= '1' when tmp_0289 = X"00000001" else '0';
  tmp_0291 <= pull_recv_data_read_len_0225 + X"00000001";
  tmp_0292 <= '1' when pull_recv_data_i_0230 < pull_recv_data_read_len_0225 else '0';
  tmp_0293 <= pull_recv_data_i_0230 + X"00000001";
  tmp_0294 <= pull_recv_data_i_0230(30 downto 0) & (1-1 downto 0 => '0');
  tmp_0295 <= tmp_0294 + X"00000000";
  tmp_0296 <= pull_recv_data_port_0211(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0297 <= class_Sn_RX_FIFOR0_0051 + tmp_0296;
  tmp_0298 <= pull_recv_data_i_0230(30 downto 0) & (1-1 downto 0 => '0');
  tmp_0299 <= tmp_0298 + X"00000001";
  tmp_0300 <= pull_recv_data_port_0211(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0301 <= class_Sn_RX_FIFOR1_0052 + tmp_0300;
  tmp_0302 <= pull_recv_data_port_0211(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0303 <= class_Sn_CR1_0006 + tmp_0302;
  tmp_0304 <= not push_send_data_req_flag_d;
  tmp_0305 <= push_send_data_req_flag and tmp_0304;
  tmp_0306 <= push_send_data_req_flag or push_send_data_req_flag_d;
  tmp_0307 <= push_send_data_req_flag or push_send_data_req_flag_d;
  tmp_0308 <= '1' when binary_expr_00264 = '1' else '0';
  tmp_0309 <= '1' when binary_expr_00264 = '0' else '0';
  tmp_0310 <= '1' when binary_expr_00267 = '1' else '0';
  tmp_0311 <= '1' when binary_expr_00267 = '0' else '0';
  tmp_0312 <= '1' when write_data_busy = '0' else '0';
  tmp_0313 <= '1' when write_data_req_local = '0' else '0';
  tmp_0314 <= tmp_0312 and tmp_0313;
  tmp_0315 <= '1' when tmp_0314 = '1' else '0';
  tmp_0316 <= '1' when write_data_busy = '0' else '0';
  tmp_0317 <= '1' when write_data_req_local = '0' else '0';
  tmp_0318 <= tmp_0316 and tmp_0317;
  tmp_0319 <= '1' when tmp_0318 = '1' else '0';
  tmp_0320 <= '1' when write_data_busy = '0' else '0';
  tmp_0321 <= '1' when write_data_req_local = '0' else '0';
  tmp_0322 <= tmp_0320 and tmp_0321;
  tmp_0323 <= '1' when tmp_0322 = '1' else '0';
  tmp_0324 <= '1' when write_data_busy = '0' else '0';
  tmp_0325 <= '1' when write_data_req_local = '0' else '0';
  tmp_0326 <= tmp_0324 and tmp_0325;
  tmp_0327 <= '1' when tmp_0326 = '1' else '0';
  tmp_0328 <= '1' when write_data_busy = '0' else '0';
  tmp_0329 <= '1' when write_data_req_local = '0' else '0';
  tmp_0330 <= tmp_0328 and tmp_0329;
  tmp_0331 <= '1' when tmp_0330 = '1' else '0';
  tmp_0332 <= '1' when write_data_busy = '0' else '0';
  tmp_0333 <= '1' when write_data_req_local = '0' else '0';
  tmp_0334 <= tmp_0332 and tmp_0333;
  tmp_0335 <= '1' when tmp_0334 = '1' else '0';
  tmp_0336 <= '1' when write_data_busy = '0' else '0';
  tmp_0337 <= '1' when write_data_req_local = '0' else '0';
  tmp_0338 <= tmp_0336 and tmp_0337;
  tmp_0339 <= '1' when tmp_0338 = '1' else '0';
  tmp_0340 <= '1' when push_send_data_method /= push_send_data_method_S_0000 else '0';
  tmp_0341 <= '1' when push_send_data_method /= push_send_data_method_S_0001 else '0';
  tmp_0342 <= tmp_0341 and push_send_data_req_flag_edge;
  tmp_0343 <= tmp_0340 and tmp_0342;
  tmp_0344 <= (1-1 downto 0 => push_send_data_len_0249(31)) & push_send_data_len_0249(31 downto 1);
  tmp_0345 <= push_send_data_port_0248(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0346 <= (8-1 downto 0 => push_send_data_len_0249(31)) & push_send_data_len_0249(31 downto 8);
  tmp_0347 <= class_Sn_RX_FIFOR0_0051 + tmp_0345;
  tmp_0348 <= tmp_0346 and X"000000ff";
  tmp_0349 <= tmp_0348(32 - 24 - 1 downto 0);
  tmp_0350 <= push_send_data_port_0248(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0351 <= push_send_data_len_0249 and X"000000ff";
  tmp_0352 <= class_Sn_RX_FIFOR0_0051 + tmp_0350;
  tmp_0353 <= tmp_0351(32 - 24 - 1 downto 0);
  tmp_0354 <= push_send_data_len_0249 and X"00000001";
  tmp_0355 <= '1' when tmp_0354 = X"00000001" else '0';
  tmp_0356 <= push_send_data_write_len_0250 + X"00000001";
  tmp_0357 <= '1' when push_send_data_i_0266 < push_send_data_write_len_0250 else '0';
  tmp_0358 <= push_send_data_i_0266 + X"00000001";
  tmp_0359 <= push_send_data_i_0266(30 downto 0) & (1-1 downto 0 => '0');
  tmp_0360 <= tmp_0359 + X"00000000";
  tmp_0361 <= push_send_data_port_0248(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0362 <= class_Sn_TX_FIFOR0_0049 + tmp_0361;
  tmp_0363 <= push_send_data_i_0266(30 downto 0) & (1-1 downto 0 => '0');
  tmp_0364 <= tmp_0363 + X"00000001";
  tmp_0365 <= push_send_data_port_0248(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0366 <= class_Sn_TX_FIFOR1_0050 + tmp_0365;
  tmp_0367 <= push_send_data_port_0248(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0368 <= class_Sn_CR1_0006 + tmp_0367;
  tmp_0369 <= push_send_data_port_0248(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0370 <= (16-1 downto 0 => push_send_data_len_0249(31)) & push_send_data_len_0249(31 downto 16);
  tmp_0371 <= class_Sn_TX_WRSR1_0036 + tmp_0369;
  tmp_0372 <= tmp_0370(32 - 24 - 1 downto 0);
  tmp_0373 <= push_send_data_port_0248(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0374 <= (8-1 downto 0 => push_send_data_len_0249(31)) & push_send_data_len_0249(31 downto 8);
  tmp_0375 <= class_Sn_TX_WRSR2_0037 + tmp_0373;
  tmp_0376 <= tmp_0374(32 - 24 - 1 downto 0);
  tmp_0377 <= push_send_data_port_0248(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0378 <= push_send_data_len_0249;
  tmp_0379 <= class_Sn_TX_WRSR3_0038 + tmp_0377;
  tmp_0380 <= tmp_0378(32 - 24 - 1 downto 0);
  tmp_0381 <= push_send_data_port_0248(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0382 <= class_Sn_CR1_0006 + tmp_0381;
  tmp_0383 <= not pack_req_flag_d;
  tmp_0384 <= pack_req_flag and tmp_0383;
  tmp_0385 <= pack_req_flag or pack_req_flag_d;
  tmp_0386 <= pack_req_flag or pack_req_flag_d;
  tmp_0387 <= '1' when pack_method /= pack_method_S_0000 else '0';
  tmp_0388 <= '1' when pack_method /= pack_method_S_0001 else '0';
  tmp_0389 <= tmp_0388 and pack_req_flag_edge;
  tmp_0390 <= tmp_0387 and tmp_0389;
  tmp_0391 <= (32-1 downto 16 => pack_a_0303(15)) & pack_a_0303;
  tmp_0392 <= (32-1 downto 16 => pack_b_0304(15)) & pack_b_0304;
  tmp_0393 <= (32-1 downto 16 => pack_c_0305(15)) & pack_c_0305;
  tmp_0394 <= (32-1 downto 16 => pack_d_0306(15)) & pack_d_0306;
  tmp_0395 <= signed(tmp_0391) and X"000000ff";
  tmp_0396 <= signed(tmp_0392) and X"000000ff";
  tmp_0397 <= signed(tmp_0393) and X"000000ff";
  tmp_0398 <= signed(tmp_0394) and X"000000ff";
  tmp_0399 <= tmp_0395(7 downto 0) & (24-1 downto 0 => '0');
  tmp_0400 <= tmp_0396(15 downto 0) & (16-1 downto 0 => '0');
  tmp_0401 <= tmp_0397(23 downto 0) & (8-1 downto 0 => '0');
  tmp_0402 <= tmp_0399 + tmp_0400;
  tmp_0403 <= tmp_0402 + tmp_0401;
  tmp_0404 <= tmp_0403 + tmp_0398;
  tmp_0405 <= not init_contents_req_flag_d;
  tmp_0406 <= init_contents_req_flag and tmp_0405;
  tmp_0407 <= init_contents_req_flag or init_contents_req_flag_d;
  tmp_0408 <= init_contents_req_flag or init_contents_req_flag_d;
  tmp_0409 <= '1' when pack_busy = '0' else '0';
  tmp_0410 <= '1' when pack_req_local = '0' else '0';
  tmp_0411 <= tmp_0409 and tmp_0410;
  tmp_0412 <= '1' when tmp_0411 = '1' else '0';
  tmp_0413 <= '1' when pack_busy = '0' else '0';
  tmp_0414 <= '1' when pack_req_local = '0' else '0';
  tmp_0415 <= tmp_0413 and tmp_0414;
  tmp_0416 <= '1' when tmp_0415 = '1' else '0';
  tmp_0417 <= '1' when pack_busy = '0' else '0';
  tmp_0418 <= '1' when pack_req_local = '0' else '0';
  tmp_0419 <= tmp_0417 and tmp_0418;
  tmp_0420 <= '1' when tmp_0419 = '1' else '0';
  tmp_0421 <= '1' when pack_busy = '0' else '0';
  tmp_0422 <= '1' when pack_req_local = '0' else '0';
  tmp_0423 <= tmp_0421 and tmp_0422;
  tmp_0424 <= '1' when tmp_0423 = '1' else '0';
  tmp_0425 <= '1' when pack_busy = '0' else '0';
  tmp_0426 <= '1' when pack_req_local = '0' else '0';
  tmp_0427 <= tmp_0425 and tmp_0426;
  tmp_0428 <= '1' when tmp_0427 = '1' else '0';
  tmp_0429 <= '1' when pack_busy = '0' else '0';
  tmp_0430 <= '1' when pack_req_local = '0' else '0';
  tmp_0431 <= tmp_0429 and tmp_0430;
  tmp_0432 <= '1' when tmp_0431 = '1' else '0';
  tmp_0433 <= '1' when pack_busy = '0' else '0';
  tmp_0434 <= '1' when pack_req_local = '0' else '0';
  tmp_0435 <= tmp_0433 and tmp_0434;
  tmp_0436 <= '1' when tmp_0435 = '1' else '0';
  tmp_0437 <= '1' when pack_busy = '0' else '0';
  tmp_0438 <= '1' when pack_req_local = '0' else '0';
  tmp_0439 <= tmp_0437 and tmp_0438;
  tmp_0440 <= '1' when tmp_0439 = '1' else '0';
  tmp_0441 <= '1' when pack_busy = '0' else '0';
  tmp_0442 <= '1' when pack_req_local = '0' else '0';
  tmp_0443 <= tmp_0441 and tmp_0442;
  tmp_0444 <= '1' when tmp_0443 = '1' else '0';
  tmp_0445 <= '1' when pack_busy = '0' else '0';
  tmp_0446 <= '1' when pack_req_local = '0' else '0';
  tmp_0447 <= tmp_0445 and tmp_0446;
  tmp_0448 <= '1' when tmp_0447 = '1' else '0';
  tmp_0449 <= '1' when class_misc_0094_i_to_4digit_ascii_busy = '0' else '0';
  tmp_0450 <= '1' when class_misc_0094_i_to_4digit_ascii_req = '0' else '0';
  tmp_0451 <= tmp_0449 and tmp_0450;
  tmp_0452 <= '1' when tmp_0451 = '1' else '0';
  tmp_0453 <= '1' when init_contents_method /= init_contents_method_S_0000 else '0';
  tmp_0454 <= '1' when init_contents_method /= init_contents_method_S_0001 else '0';
  tmp_0455 <= tmp_0454 and init_contents_req_flag_edge;
  tmp_0456 <= tmp_0453 and tmp_0455;
  tmp_0457 <= X"00000028";
  tmp_0458 <= not ready_contents_req_flag_d;
  tmp_0459 <= ready_contents_req_flag and tmp_0458;
  tmp_0460 <= ready_contents_req_flag or ready_contents_req_flag_d;
  tmp_0461 <= ready_contents_req_flag or ready_contents_req_flag_d;
  tmp_0462 <= '1' when binary_expr_00345 = '1' else '0';
  tmp_0463 <= '1' when binary_expr_00345 = '0' else '0';
  tmp_0464 <= '1' when binary_expr_00393 = '1' else '0';
  tmp_0465 <= '1' when binary_expr_00393 = '0' else '0';
  tmp_0466 <= '1' when binary_expr_00416 = '1' else '0';
  tmp_0467 <= '1' when binary_expr_00416 = '0' else '0';
  tmp_0468 <= '1' when ready_contents_method /= ready_contents_method_S_0000 else '0';
  tmp_0469 <= '1' when ready_contents_method /= ready_contents_method_S_0001 else '0';
  tmp_0470 <= tmp_0469 and ready_contents_req_flag_edge;
  tmp_0471 <= tmp_0468 and tmp_0470;
  tmp_0472 <= '1' when ready_contents_i_0343 < field_access_00344 else '0';
  tmp_0473 <= ready_contents_i_0343 + X"00000001";
  tmp_0474 <= ready_contents_i_0343(29 downto 0) & (2-1 downto 0 => '0');
  tmp_0475 <= tmp_0474 + X"00000000";
  tmp_0476 <= (24-1 downto 0 => ready_contents_v_0347(31)) & ready_contents_v_0347(31 downto 24);
  tmp_0477 <= ready_contents_i_0343(29 downto 0) & (2-1 downto 0 => '0');
  tmp_0478 <= tmp_0476(32 - 24 - 1 downto 0);
  tmp_0479 <= tmp_0477 + X"00000001";
  tmp_0480 <= (16-1 downto 0 => ready_contents_v_0347(31)) & ready_contents_v_0347(31 downto 16);
  tmp_0481 <= ready_contents_i_0343(29 downto 0) & (2-1 downto 0 => '0');
  tmp_0482 <= tmp_0480(32 - 24 - 1 downto 0);
  tmp_0483 <= tmp_0481 + X"00000002";
  tmp_0484 <= (8-1 downto 0 => ready_contents_v_0347(31)) & ready_contents_v_0347(31 downto 8);
  tmp_0485 <= ready_contents_i_0343(29 downto 0) & (2-1 downto 0 => '0');
  tmp_0486 <= tmp_0484(32 - 24 - 1 downto 0);
  tmp_0487 <= tmp_0485 + X"00000003";
  tmp_0488 <= ready_contents_v_0347;
  tmp_0489 <= tmp_0488(32 - 24 - 1 downto 0);
  tmp_0490 <= X"00000020";
  tmp_0491 <= tmp_0490 + X"00000000";
  tmp_0492 <= (24-1 downto 0 => class_content_length_field_0093(31)) & class_content_length_field_0093(31 downto 24);
  tmp_0493 <= X"00000020";
  tmp_0494 <= tmp_0492(32 - 24 - 1 downto 0);
  tmp_0495 <= tmp_0493 + X"00000001";
  tmp_0496 <= (16-1 downto 0 => class_content_length_field_0093(31)) & class_content_length_field_0093(31 downto 16);
  tmp_0497 <= X"00000020";
  tmp_0498 <= tmp_0496(32 - 24 - 1 downto 0);
  tmp_0499 <= tmp_0497 + X"00000002";
  tmp_0500 <= (8-1 downto 0 => class_content_length_field_0093(31)) & class_content_length_field_0093(31 downto 8);
  tmp_0501 <= X"00000020";
  tmp_0502 <= tmp_0500(32 - 24 - 1 downto 0);
  tmp_0503 <= tmp_0501 + X"00000003";
  tmp_0504 <= class_content_length_field_0093;
  tmp_0505 <= tmp_0504(32 - 24 - 1 downto 0);
  tmp_0506 <= '1' when ready_contents_i_0392 < class_content_words_0092 else '0';
  tmp_0507 <= ready_contents_i_0392 + X"00000001";
  tmp_0508 <= ready_contents_offset_0390 + ready_contents_i_0392;
  tmp_0509 <= tmp_0508(29 downto 0) & (2-1 downto 0 => '0');
  tmp_0510 <= tmp_0509 + X"00000000";
  tmp_0511 <= (24-1 downto 0 => ready_contents_v_0395(31)) & ready_contents_v_0395(31 downto 24);
  tmp_0512 <= ready_contents_ptr_0397 + X"00000001";
  tmp_0513 <= tmp_0511(32 - 24 - 1 downto 0);
  tmp_0514 <= (16-1 downto 0 => ready_contents_v_0395(31)) & ready_contents_v_0395(31 downto 16);
  tmp_0515 <= ready_contents_ptr_0397 + X"00000002";
  tmp_0516 <= tmp_0514(32 - 24 - 1 downto 0);
  tmp_0517 <= (8-1 downto 0 => ready_contents_v_0395(31)) & ready_contents_v_0395(31 downto 8);
  tmp_0518 <= ready_contents_ptr_0397 + X"00000003";
  tmp_0519 <= tmp_0517(32 - 24 - 1 downto 0);
  tmp_0520 <= ready_contents_v_0395;
  tmp_0521 <= '1' when ready_contents_i_0392 = X"00000005" else '0';
  tmp_0522 <= tmp_0520(32 - 24 - 1 downto 0);
  tmp_0523 <= ready_contents_ptr_0397 + X"00000002";
  tmp_0524 <= ready_contents_ptr_0397 + X"00000003";
  tmp_0525 <= field_access_00421 + class_content_words_0092;
  tmp_0526 <= tmp_0525(29 downto 0) & (2-1 downto 0 => '0');
  tmp_0527 <= not action_req_flag_d;
  tmp_0528 <= action_req_flag and tmp_0527;
  tmp_0529 <= action_req_flag or action_req_flag_d;
  tmp_0530 <= action_req_flag or action_req_flag_d;
  tmp_0531 <= '1' when binary_expr_00429 = '1' else '0';
  tmp_0532 <= '1' when binary_expr_00429 = '0' else '0';
  tmp_0533 <= '1' when action_S_0425 = X"00000000" else '0';
  tmp_0534 <= '1' when action_S_0425 = X"00000001" else '0';
  tmp_0535 <= '1' when action_S_0425 = X"00000002" else '0';
  tmp_0536 <= '1' when action_S_0425 = X"00000003" else '0';
  tmp_0537 <= '1' when action_S_0425 = X"00000004" else '0';
  tmp_0538 <= '1' when action_S_0425 = X"00000005" else '0';
  tmp_0539 <= '1' when class_misc_0094_isHex_busy = '0' else '0';
  tmp_0540 <= '1' when class_misc_0094_isHex_req = '0' else '0';
  tmp_0541 <= tmp_0539 and tmp_0540;
  tmp_0542 <= '1' when tmp_0541 = '1' else '0';
  tmp_0543 <= '1' when method_result_00433 = '1' else '0';
  tmp_0544 <= '1' when method_result_00433 = '0' else '0';
  tmp_0545 <= '1' when class_misc_0094_isHex_busy = '0' else '0';
  tmp_0546 <= '1' when class_misc_0094_isHex_req = '0' else '0';
  tmp_0547 <= tmp_0545 and tmp_0546;
  tmp_0548 <= '1' when tmp_0547 = '1' else '0';
  tmp_0549 <= '1' when method_result_00434 = '1' else '0';
  tmp_0550 <= '1' when method_result_00434 = '0' else '0';
  tmp_0551 <= '1' when binary_expr_00435 = '1' else '0';
  tmp_0552 <= '1' when binary_expr_00435 = '0' else '0';
  tmp_0553 <= '1' when binary_expr_00436 = '1' else '0';
  tmp_0554 <= '1' when binary_expr_00436 = '0' else '0';
  tmp_0555 <= '1' when binary_expr_00437 = '1' else '0';
  tmp_0556 <= '1' when binary_expr_00437 = '0' else '0';
  tmp_0557 <= '1' when binary_expr_00438 = '1' else '0';
  tmp_0558 <= '1' when binary_expr_00438 = '0' else '0';
  tmp_0559 <= '1' when class_misc_0094_toHex2_busy = '0' else '0';
  tmp_0560 <= '1' when class_misc_0094_toHex2_req = '0' else '0';
  tmp_0561 <= tmp_0559 and tmp_0560;
  tmp_0562 <= '1' when tmp_0561 = '1' else '0';
  tmp_0563 <= '1' when action_method /= action_method_S_0000 else '0';
  tmp_0564 <= '1' when action_method /= action_method_S_0001 else '0';
  tmp_0565 <= tmp_0564 and action_req_flag_edge;
  tmp_0566 <= tmp_0563 and tmp_0565;
  tmp_0567 <= '1' when action_i_0428 < action_len_0424 else '0';
  tmp_0568 <= action_i_0428 + X"00000001";
  tmp_0569 <= '1' when action_b_0431 = X"3d" else '0';
  tmp_0570 <= '1' when action_b_0431 = X"76" else '0';
  tmp_0571 <= '1' when action_b_0431 = X"3f" else '0';
  tmp_0572 <= '1' when action_S_0425 = X"00000005" else '0';
  tmp_0573 <= not tcp_server_req_flag_d;
  tmp_0574 <= tcp_server_req_flag and tmp_0573;
  tmp_0575 <= tcp_server_req_flag or tcp_server_req_flag_d;
  tmp_0576 <= tcp_server_req_flag or tcp_server_req_flag_d;
  tmp_0577 <= '1' when tcp_server_open_busy = '0' else '0';
  tmp_0578 <= '1' when tcp_server_open_req_local = '0' else '0';
  tmp_0579 <= tmp_0577 and tmp_0578;
  tmp_0580 <= '1' when tmp_0579 = '1' else '0';
  tmp_0581 <= '1' when binary_expr_00447 = '1' else '0';
  tmp_0582 <= '1' when binary_expr_00447 = '0' else '0';
  tmp_0583 <= '1' when tcp_server_open_busy = '0' else '0';
  tmp_0584 <= '1' when tcp_server_open_req_local = '0' else '0';
  tmp_0585 <= tmp_0583 and tmp_0584;
  tmp_0586 <= '1' when tmp_0585 = '1' else '0';
  tmp_0587 <= '1' when tcp_server_listen_busy = '0' else '0';
  tmp_0588 <= '1' when tcp_server_listen_req_local = '0' else '0';
  tmp_0589 <= tmp_0587 and tmp_0588;
  tmp_0590 <= '1' when tmp_0589 = '1' else '0';
  tmp_0591 <= '1' when binary_expr_00453 = '1' else '0';
  tmp_0592 <= '1' when binary_expr_00453 = '0' else '0';
  tmp_0593 <= '1' when write_data_busy = '0' else '0';
  tmp_0594 <= '1' when write_data_req_local = '0' else '0';
  tmp_0595 <= tmp_0593 and tmp_0594;
  tmp_0596 <= '1' when tmp_0595 = '1' else '0';
  tmp_0597 <= '1' when tcp_server_listen_busy = '0' else '0';
  tmp_0598 <= '1' when tcp_server_listen_req_local = '0' else '0';
  tmp_0599 <= tmp_0597 and tmp_0598;
  tmp_0600 <= '1' when tmp_0599 = '1' else '0';
  tmp_0601 <= '1' when wait_for_established_busy = '0' else '0';
  tmp_0602 <= '1' when wait_for_established_req_local = '0' else '0';
  tmp_0603 <= tmp_0601 and tmp_0602;
  tmp_0604 <= '1' when tmp_0603 = '1' else '0';
  tmp_0605 <= '1' when read_data_busy = '0' else '0';
  tmp_0606 <= '1' when read_data_req_local = '0' else '0';
  tmp_0607 <= tmp_0605 and tmp_0606;
  tmp_0608 <= '1' when tmp_0607 = '1' else '0';
  tmp_0609 <= '1' and '1';
  tmp_0610 <= '1' and '0';
  tmp_0611 <= '1' when wait_for_recv_busy = '0' else '0';
  tmp_0612 <= '1' when wait_for_recv_req_local = '0' else '0';
  tmp_0613 <= tmp_0611 and tmp_0612;
  tmp_0614 <= '1' when tmp_0613 = '1' else '0';
  tmp_0615 <= '1' when binary_expr_00464 = '1' else '0';
  tmp_0616 <= '1' when binary_expr_00464 = '0' else '0';
  tmp_0617 <= '1' when pull_recv_data_busy = '0' else '0';
  tmp_0618 <= '1' when pull_recv_data_req_local = '0' else '0';
  tmp_0619 <= tmp_0617 and tmp_0618;
  tmp_0620 <= '1' when tmp_0619 = '1' else '0';
  tmp_0621 <= '1' when action_busy = '0' else '0';
  tmp_0622 <= '1' when action_req_local = '0' else '0';
  tmp_0623 <= tmp_0621 and tmp_0622;
  tmp_0624 <= '1' when tmp_0623 = '1' else '0';
  tmp_0625 <= '1' when ready_contents_busy = '0' else '0';
  tmp_0626 <= '1' when ready_contents_req_local = '0' else '0';
  tmp_0627 <= tmp_0625 and tmp_0626;
  tmp_0628 <= '1' when tmp_0627 = '1' else '0';
  tmp_0629 <= '1' when push_send_data_busy = '0' else '0';
  tmp_0630 <= '1' when push_send_data_req_local = '0' else '0';
  tmp_0631 <= tmp_0629 and tmp_0630;
  tmp_0632 <= '1' when tmp_0631 = '1' else '0';
  tmp_0633 <= '1' when tcp_server_method /= tcp_server_method_S_0000 else '0';
  tmp_0634 <= '1' when tcp_server_method /= tcp_server_method_S_0001 else '0';
  tmp_0635 <= tmp_0634 and tcp_server_req_flag_edge;
  tmp_0636 <= tmp_0633 and tmp_0635;
  tmp_0637 <= tcp_server_port_0441(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0638 <= class_Sn_IMR1_0008 + tmp_0637;
  tmp_0639 <= '1' when tcp_server_v_0445 /= class_Sn_SOCK_INIT_0074 else '0';
  tmp_0640 <= tcp_server_port_0441(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0641 <= class_Sn_CR1_0006 + tmp_0640;
  tmp_0642 <= '1' when tcp_server_v_0445 /= class_Sn_SOCK_LISTEN_0075 else '0';
  tmp_0643 <= tcp_server_port_0441(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0644 <= class_Sn_CR1_0006 + tmp_0643;
  tmp_0645 <= tcp_server_port_0441(25 downto 0) & (6-1 downto 0 => '0');
  tmp_0646 <= class_Sn_MR0_0003 + tmp_0645;
  tmp_0647 <= '1' when method_result_00463 = X"00000000" else '0';
  tmp_0648 <= not test_req_flag_d;
  tmp_0649 <= test_req_flag and tmp_0648;
  tmp_0650 <= test_req_flag or test_req_flag_d;
  tmp_0651 <= test_req_flag or test_req_flag_d;
  tmp_0652 <= '1' when init_busy = '0' else '0';
  tmp_0653 <= '1' when init_req_local = '0' else '0';
  tmp_0654 <= tmp_0652 and tmp_0653;
  tmp_0655 <= '1' when tmp_0654 = '1' else '0';
  tmp_0656 <= '1' when network_configuration_busy = '0' else '0';
  tmp_0657 <= '1' when network_configuration_req_local = '0' else '0';
  tmp_0658 <= tmp_0656 and tmp_0657;
  tmp_0659 <= '1' when tmp_0658 = '1' else '0';
  tmp_0660 <= '1' when init_contents_busy = '0' else '0';
  tmp_0661 <= '1' when init_contents_req_local = '0' else '0';
  tmp_0662 <= tmp_0660 and tmp_0661;
  tmp_0663 <= '1' when tmp_0662 = '1' else '0';
  tmp_0664 <= '1' and '1';
  tmp_0665 <= '1' and '0';
  tmp_0666 <= '1' when tcp_server_busy = '0' else '0';
  tmp_0667 <= '1' when tcp_server_req_local = '0' else '0';
  tmp_0668 <= tmp_0666 and tmp_0667;
  tmp_0669 <= '1' when tmp_0668 = '1' else '0';
  tmp_0670 <= '1' when test_method /= test_method_S_0000 else '0';
  tmp_0671 <= '1' when test_method /= test_method_S_0001 else '0';
  tmp_0672 <= tmp_0671 and test_req_flag_edge;
  tmp_0673 <= tmp_0670 and tmp_0672;
  tmp_0674 <= not blink_led_req_flag_d;
  tmp_0675 <= blink_led_req_flag and tmp_0674;
  tmp_0676 <= blink_led_req_flag or blink_led_req_flag_d;
  tmp_0677 <= blink_led_req_flag or blink_led_req_flag_d;
  tmp_0678 <= '1' when blink_led_method /= blink_led_method_S_0000 else '0';
  tmp_0679 <= '1' when blink_led_method /= blink_led_method_S_0001 else '0';
  tmp_0680 <= tmp_0679 and blink_led_req_flag_edge;
  tmp_0681 <= tmp_0678 and tmp_0680;

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
            if tmp_0008 = '1' then
              wait_cycles_method <= wait_cycles_method_S_0002;
            end if;
          when wait_cycles_method_S_0002 => 
            wait_cycles_method <= wait_cycles_method_S_0003;
          when wait_cycles_method_S_0003 => 
            wait_cycles_method <= wait_cycles_method_S_0004;
          when wait_cycles_method_S_0004 => 
            if tmp_0010 = '1' then
              wait_cycles_method <= wait_cycles_method_S_0009;
            elsif tmp_0011 = '1' then
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
        if (tmp_0012 and tmp_0014) = '1' then
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
            if tmp_0020 = '1' then
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
        if (tmp_0026 and tmp_0028) = '1' then
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
            if tmp_0032 = '1' then
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
        if (tmp_0038 and tmp_0040) = '1' then
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
            if tmp_0044 = '1' then
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
        if (tmp_0050 and tmp_0052) = '1' then
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
            if tmp_0056 = '1' then
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
        if (tmp_0130 and tmp_0132) = '1' then
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
            if tmp_0136 = '1' then
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
        if (tmp_0142 and tmp_0144) = '1' then
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
            if tmp_0161 = '1' then
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
        if (tmp_0167 and tmp_0169) = '1' then
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
            if tmp_0177 = '1' then
              wait_for_established_method <= wait_for_established_method_S_0002;
            end if;
          when wait_for_established_method_S_0002 => 
            wait_for_established_method <= wait_for_established_method_S_0003;
          when wait_for_established_method_S_0003 => 
            if tmp_0179 = '1' then
              wait_for_established_method <= wait_for_established_method_S_0005;
            elsif tmp_0180 = '1' then
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
            if tmp_0181 = '1' then
              wait_for_established_method <= wait_for_established_method_S_0012;
            elsif tmp_0182 = '1' then
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
        if (tmp_0183 and tmp_0185) = '1' then
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
            if tmp_0192 = '1' then
              wait_for_recv_method <= wait_for_recv_method_S_0002;
            end if;
          when wait_for_recv_method_S_0002 => 
            wait_for_recv_method <= wait_for_recv_method_S_0003;
          when wait_for_recv_method_S_0003 => 
            if tmp_0194 = '1' then
              wait_for_recv_method <= wait_for_recv_method_S_0005;
            elsif tmp_0195 = '1' then
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
            if tmp_0208 = '1' then
              wait_for_recv_method <= wait_for_recv_method_S_0029;
            elsif tmp_0209 = '1' then
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
            if tmp_0214 = '1' then
              wait_for_recv_method <= wait_for_recv_method_S_0043;
            elsif tmp_0215 = '1' then
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
        if (tmp_0220 and tmp_0222) = '1' then
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
            if tmp_0250 = '1' then
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
            if tmp_0260 = '1' then
              pull_recv_data_method <= pull_recv_data_method_S_0021;
            elsif tmp_0261 = '1' then
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
            if tmp_0262 = '1' then
              pull_recv_data_method <= pull_recv_data_method_S_0031;
            elsif tmp_0263 = '1' then
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
        if (tmp_0276 and tmp_0278) = '1' then
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
            if tmp_0306 = '1' then
              push_send_data_method <= push_send_data_method_S_0002;
            end if;
          when push_send_data_method_S_0002 => 
            push_send_data_method <= push_send_data_method_S_0009;
          when push_send_data_method_S_0009 => 
            push_send_data_method <= push_send_data_method_S_0009_body;
          when push_send_data_method_S_0010 => 
            push_send_data_method <= push_send_data_method_S_0014;
          when push_send_data_method_S_0014 => 
            push_send_data_method <= push_send_data_method_S_0014_body;
          when push_send_data_method_S_0015 => 
            push_send_data_method <= push_send_data_method_S_0017;
          when push_send_data_method_S_0017 => 
            if tmp_0308 = '1' then
              push_send_data_method <= push_send_data_method_S_0019;
            elsif tmp_0309 = '1' then
              push_send_data_method <= push_send_data_method_S_0018;
            end if;
          when push_send_data_method_S_0018 => 
            push_send_data_method <= push_send_data_method_S_0022;
          when push_send_data_method_S_0019 => 
            push_send_data_method <= push_send_data_method_S_0021;
          when push_send_data_method_S_0021 => 
            push_send_data_method <= push_send_data_method_S_0018;
          when push_send_data_method_S_0022 => 
            push_send_data_method <= push_send_data_method_S_0023;
          when push_send_data_method_S_0023 => 
            push_send_data_method <= push_send_data_method_S_0024;
          when push_send_data_method_S_0024 => 
            if tmp_0310 = '1' then
              push_send_data_method <= push_send_data_method_S_0029;
            elsif tmp_0311 = '1' then
              push_send_data_method <= push_send_data_method_S_0025;
            end if;
          when push_send_data_method_S_0025 => 
            push_send_data_method <= push_send_data_method_S_0044;
          when push_send_data_method_S_0026 => 
            push_send_data_method <= push_send_data_method_S_0028;
          when push_send_data_method_S_0028 => 
            push_send_data_method <= push_send_data_method_S_0023;
          when push_send_data_method_S_0029 => 
            push_send_data_method <= push_send_data_method_S_0031;
          when push_send_data_method_S_0031 => 
            if push_send_data_method_delay >= 2 then
              push_send_data_method_delay <= (others => '0');
              push_send_data_method <= push_send_data_method_S_0032;
            else
              push_send_data_method_delay <= push_send_data_method_delay + 1;
            end if;
          when push_send_data_method_S_0032 => 
            push_send_data_method <= push_send_data_method_S_0035;
          when push_send_data_method_S_0035 => 
            push_send_data_method <= push_send_data_method_S_0035_body;
          when push_send_data_method_S_0036 => 
            push_send_data_method <= push_send_data_method_S_0038;
          when push_send_data_method_S_0038 => 
            if push_send_data_method_delay >= 2 then
              push_send_data_method_delay <= (others => '0');
              push_send_data_method <= push_send_data_method_S_0039;
            else
              push_send_data_method_delay <= push_send_data_method_delay + 1;
            end if;
          when push_send_data_method_S_0039 => 
            push_send_data_method <= push_send_data_method_S_0042;
          when push_send_data_method_S_0042 => 
            push_send_data_method <= push_send_data_method_S_0042_body;
          when push_send_data_method_S_0043 => 
            push_send_data_method <= push_send_data_method_S_0026;
          when push_send_data_method_S_0044 => 
            push_send_data_method <= push_send_data_method_S_0046;
          when push_send_data_method_S_0046 => 
            push_send_data_method <= push_send_data_method_S_0046_body;
          when push_send_data_method_S_0047 => 
            push_send_data_method <= push_send_data_method_S_0051;
          when push_send_data_method_S_0051 => 
            push_send_data_method <= push_send_data_method_S_0051_body;
          when push_send_data_method_S_0052 => 
            push_send_data_method <= push_send_data_method_S_0056;
          when push_send_data_method_S_0056 => 
            push_send_data_method <= push_send_data_method_S_0056_body;
          when push_send_data_method_S_0057 => 
            push_send_data_method <= push_send_data_method_S_0061;
          when push_send_data_method_S_0061 => 
            push_send_data_method <= push_send_data_method_S_0061_body;
          when push_send_data_method_S_0062 => 
            push_send_data_method <= push_send_data_method_S_0064;
          when push_send_data_method_S_0064 => 
            push_send_data_method <= push_send_data_method_S_0064_body;
          when push_send_data_method_S_0065 => 
            push_send_data_method <= push_send_data_method_S_0000;
          when push_send_data_method_S_0009_body => 
            push_send_data_method <= push_send_data_method_S_0009_wait;
          when push_send_data_method_S_0009_wait => 
            if write_data_call_flag_0009 = '1' then
              push_send_data_method <= push_send_data_method_S_0010;
            end if;
          when push_send_data_method_S_0014_body => 
            push_send_data_method <= push_send_data_method_S_0014_wait;
          when push_send_data_method_S_0014_wait => 
            if write_data_call_flag_0014 = '1' then
              push_send_data_method <= push_send_data_method_S_0015;
            end if;
          when push_send_data_method_S_0035_body => 
            push_send_data_method <= push_send_data_method_S_0035_wait;
          when push_send_data_method_S_0035_wait => 
            if write_data_call_flag_0035 = '1' then
              push_send_data_method <= push_send_data_method_S_0036;
            end if;
          when push_send_data_method_S_0042_body => 
            push_send_data_method <= push_send_data_method_S_0042_wait;
          when push_send_data_method_S_0042_wait => 
            if write_data_call_flag_0042 = '1' then
              push_send_data_method <= push_send_data_method_S_0043;
            end if;
          when push_send_data_method_S_0046_body => 
            push_send_data_method <= push_send_data_method_S_0046_wait;
          when push_send_data_method_S_0046_wait => 
            if write_data_call_flag_0046 = '1' then
              push_send_data_method <= push_send_data_method_S_0047;
            end if;
          when push_send_data_method_S_0051_body => 
            push_send_data_method <= push_send_data_method_S_0051_wait;
          when push_send_data_method_S_0051_wait => 
            if write_data_call_flag_0051 = '1' then
              push_send_data_method <= push_send_data_method_S_0052;
            end if;
          when push_send_data_method_S_0056_body => 
            push_send_data_method <= push_send_data_method_S_0056_wait;
          when push_send_data_method_S_0056_wait => 
            if write_data_call_flag_0056 = '1' then
              push_send_data_method <= push_send_data_method_S_0057;
            end if;
          when push_send_data_method_S_0061_body => 
            push_send_data_method <= push_send_data_method_S_0061_wait;
          when push_send_data_method_S_0061_wait => 
            if write_data_call_flag_0061 = '1' then
              push_send_data_method <= push_send_data_method_S_0062;
            end if;
          when push_send_data_method_S_0064_body => 
            push_send_data_method <= push_send_data_method_S_0064_wait;
          when push_send_data_method_S_0064_wait => 
            if write_data_call_flag_0064 = '1' then
              push_send_data_method <= push_send_data_method_S_0065;
            end if;
          when others => null;
        end case;
        push_send_data_req_flag_d <= push_send_data_req_flag;
        if (tmp_0340 and tmp_0342) = '1' then
          push_send_data_method <= push_send_data_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pack_method <= pack_method_IDLE;
        pack_method_delay <= (others => '0');
      else
        case (pack_method) is
          when pack_method_IDLE => 
            pack_method <= pack_method_S_0000;
          when pack_method_S_0000 => 
            pack_method <= pack_method_S_0001;
          when pack_method_S_0001 => 
            if tmp_0385 = '1' then
              pack_method <= pack_method_S_0002;
            end if;
          when pack_method_S_0002 => 
            pack_method <= pack_method_S_0016;
          when pack_method_S_0016 => 
            pack_method <= pack_method_S_0000;
          when pack_method_S_0017 => 
            pack_method <= pack_method_S_0000;
          when others => null;
        end case;
        pack_req_flag_d <= pack_req_flag;
        if (tmp_0387 and tmp_0389) = '1' then
          pack_method <= pack_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        init_contents_method <= init_contents_method_IDLE;
        init_contents_method_delay <= (others => '0');
      else
        case (init_contents_method) is
          when init_contents_method_IDLE => 
            init_contents_method <= init_contents_method_S_0000;
          when init_contents_method_S_0000 => 
            init_contents_method <= init_contents_method_S_0001;
          when init_contents_method_S_0001 => 
            if tmp_0407 = '1' then
              init_contents_method <= init_contents_method_S_0002;
            end if;
          when init_contents_method_S_0002 => 
            init_contents_method <= init_contents_method_S_0003;
          when init_contents_method_S_0003 => 
            init_contents_method <= init_contents_method_S_0003_body;
          when init_contents_method_S_0004 => 
            init_contents_method <= init_contents_method_S_0005;
          when init_contents_method_S_0005 => 
            init_contents_method <= init_contents_method_S_0006;
          when init_contents_method_S_0006 => 
            init_contents_method <= init_contents_method_S_0006_body;
          when init_contents_method_S_0007 => 
            init_contents_method <= init_contents_method_S_0008;
          when init_contents_method_S_0008 => 
            init_contents_method <= init_contents_method_S_0009;
          when init_contents_method_S_0009 => 
            init_contents_method <= init_contents_method_S_0009_body;
          when init_contents_method_S_0010 => 
            init_contents_method <= init_contents_method_S_0011;
          when init_contents_method_S_0011 => 
            init_contents_method <= init_contents_method_S_0012;
          when init_contents_method_S_0012 => 
            init_contents_method <= init_contents_method_S_0012_body;
          when init_contents_method_S_0013 => 
            init_contents_method <= init_contents_method_S_0014;
          when init_contents_method_S_0014 => 
            init_contents_method <= init_contents_method_S_0015;
          when init_contents_method_S_0015 => 
            init_contents_method <= init_contents_method_S_0015_body;
          when init_contents_method_S_0016 => 
            init_contents_method <= init_contents_method_S_0017;
          when init_contents_method_S_0017 => 
            init_contents_method <= init_contents_method_S_0018;
          when init_contents_method_S_0018 => 
            init_contents_method <= init_contents_method_S_0018_body;
          when init_contents_method_S_0019 => 
            init_contents_method <= init_contents_method_S_0020;
          when init_contents_method_S_0020 => 
            init_contents_method <= init_contents_method_S_0021;
          when init_contents_method_S_0021 => 
            init_contents_method <= init_contents_method_S_0021_body;
          when init_contents_method_S_0022 => 
            init_contents_method <= init_contents_method_S_0023;
          when init_contents_method_S_0023 => 
            init_contents_method <= init_contents_method_S_0024;
          when init_contents_method_S_0024 => 
            init_contents_method <= init_contents_method_S_0024_body;
          when init_contents_method_S_0025 => 
            init_contents_method <= init_contents_method_S_0026;
          when init_contents_method_S_0026 => 
            init_contents_method <= init_contents_method_S_0027;
          when init_contents_method_S_0027 => 
            init_contents_method <= init_contents_method_S_0027_body;
          when init_contents_method_S_0028 => 
            init_contents_method <= init_contents_method_S_0029;
          when init_contents_method_S_0029 => 
            init_contents_method <= init_contents_method_S_0030;
          when init_contents_method_S_0030 => 
            init_contents_method <= init_contents_method_S_0030_body;
          when init_contents_method_S_0031 => 
            init_contents_method <= init_contents_method_S_0034;
          when init_contents_method_S_0034 => 
            init_contents_method <= init_contents_method_S_0034_body;
          when init_contents_method_S_0035 => 
            init_contents_method <= init_contents_method_S_0036;
          when init_contents_method_S_0036 => 
            init_contents_method <= init_contents_method_S_0000;
          when init_contents_method_S_0003_body => 
            init_contents_method <= init_contents_method_S_0003_wait;
          when init_contents_method_S_0003_wait => 
            if pack_call_flag_0003 = '1' then
              init_contents_method <= init_contents_method_S_0004;
            end if;
          when init_contents_method_S_0006_body => 
            init_contents_method <= init_contents_method_S_0006_wait;
          when init_contents_method_S_0006_wait => 
            if pack_call_flag_0006 = '1' then
              init_contents_method <= init_contents_method_S_0007;
            end if;
          when init_contents_method_S_0009_body => 
            init_contents_method <= init_contents_method_S_0009_wait;
          when init_contents_method_S_0009_wait => 
            if pack_call_flag_0009 = '1' then
              init_contents_method <= init_contents_method_S_0010;
            end if;
          when init_contents_method_S_0012_body => 
            init_contents_method <= init_contents_method_S_0012_wait;
          when init_contents_method_S_0012_wait => 
            if pack_call_flag_0012 = '1' then
              init_contents_method <= init_contents_method_S_0013;
            end if;
          when init_contents_method_S_0015_body => 
            init_contents_method <= init_contents_method_S_0015_wait;
          when init_contents_method_S_0015_wait => 
            if pack_call_flag_0015 = '1' then
              init_contents_method <= init_contents_method_S_0016;
            end if;
          when init_contents_method_S_0018_body => 
            init_contents_method <= init_contents_method_S_0018_wait;
          when init_contents_method_S_0018_wait => 
            if pack_call_flag_0018 = '1' then
              init_contents_method <= init_contents_method_S_0019;
            end if;
          when init_contents_method_S_0021_body => 
            init_contents_method <= init_contents_method_S_0021_wait;
          when init_contents_method_S_0021_wait => 
            if pack_call_flag_0021 = '1' then
              init_contents_method <= init_contents_method_S_0022;
            end if;
          when init_contents_method_S_0024_body => 
            init_contents_method <= init_contents_method_S_0024_wait;
          when init_contents_method_S_0024_wait => 
            if pack_call_flag_0024 = '1' then
              init_contents_method <= init_contents_method_S_0025;
            end if;
          when init_contents_method_S_0027_body => 
            init_contents_method <= init_contents_method_S_0027_wait;
          when init_contents_method_S_0027_wait => 
            if pack_call_flag_0027 = '1' then
              init_contents_method <= init_contents_method_S_0028;
            end if;
          when init_contents_method_S_0030_body => 
            init_contents_method <= init_contents_method_S_0030_wait;
          when init_contents_method_S_0030_wait => 
            if pack_call_flag_0030 = '1' then
              init_contents_method <= init_contents_method_S_0031;
            end if;
          when init_contents_method_S_0034_body => 
            init_contents_method <= init_contents_method_S_0034_wait;
          when init_contents_method_S_0034_wait => 
            if i_to_4digit_ascii_ext_call_flag_0034 = '1' then
              init_contents_method <= init_contents_method_S_0035;
            end if;
          when others => null;
        end case;
        init_contents_req_flag_d <= init_contents_req_flag;
        if (tmp_0453 and tmp_0455) = '1' then
          init_contents_method <= init_contents_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        ready_contents_method <= ready_contents_method_IDLE;
        ready_contents_method_delay <= (others => '0');
      else
        case (ready_contents_method) is
          when ready_contents_method_IDLE => 
            ready_contents_method <= ready_contents_method_S_0000;
          when ready_contents_method_S_0000 => 
            ready_contents_method <= ready_contents_method_S_0001;
          when ready_contents_method_S_0001 => 
            if tmp_0460 = '1' then
              ready_contents_method <= ready_contents_method_S_0002;
            end if;
          when ready_contents_method_S_0002 => 
            ready_contents_method <= ready_contents_method_S_0003;
          when ready_contents_method_S_0003 => 
            ready_contents_method <= ready_contents_method_S_0004;
          when ready_contents_method_S_0004 => 
            ready_contents_method <= ready_contents_method_S_0005;
          when ready_contents_method_S_0005 => 
            if tmp_0462 = '1' then
              ready_contents_method <= ready_contents_method_S_0010;
            elsif tmp_0463 = '1' then
              ready_contents_method <= ready_contents_method_S_0006;
            end if;
          when ready_contents_method_S_0006 => 
            ready_contents_method <= ready_contents_method_S_0038;
          when ready_contents_method_S_0007 => 
            ready_contents_method <= ready_contents_method_S_0009;
          when ready_contents_method_S_0009 => 
            ready_contents_method <= ready_contents_method_S_0003;
          when ready_contents_method_S_0010 => 
            ready_contents_method <= ready_contents_method_S_0011;
          when ready_contents_method_S_0011 => 
            if ready_contents_method_delay >= 2 then
              ready_contents_method_delay <= (others => '0');
              ready_contents_method <= ready_contents_method_S_0012;
            else
              ready_contents_method_delay <= ready_contents_method_delay + 1;
            end if;
          when ready_contents_method_S_0012 => 
            ready_contents_method <= ready_contents_method_S_0015;
          when ready_contents_method_S_0015 => 
            ready_contents_method <= ready_contents_method_S_0016;
          when ready_contents_method_S_0016 => 
            ready_contents_method <= ready_contents_method_S_0021;
          when ready_contents_method_S_0021 => 
            ready_contents_method <= ready_contents_method_S_0022;
          when ready_contents_method_S_0022 => 
            ready_contents_method <= ready_contents_method_S_0027;
          when ready_contents_method_S_0027 => 
            ready_contents_method <= ready_contents_method_S_0028;
          when ready_contents_method_S_0028 => 
            ready_contents_method <= ready_contents_method_S_0033;
          when ready_contents_method_S_0033 => 
            ready_contents_method <= ready_contents_method_S_0034;
          when ready_contents_method_S_0034 => 
            ready_contents_method <= ready_contents_method_S_0037;
          when ready_contents_method_S_0037 => 
            ready_contents_method <= ready_contents_method_S_0007;
          when ready_contents_method_S_0038 => 
            ready_contents_method <= ready_contents_method_S_0040;
          when ready_contents_method_S_0040 => 
            ready_contents_method <= ready_contents_method_S_0041;
          when ready_contents_method_S_0041 => 
            ready_contents_method <= ready_contents_method_S_0046;
          when ready_contents_method_S_0046 => 
            ready_contents_method <= ready_contents_method_S_0047;
          when ready_contents_method_S_0047 => 
            ready_contents_method <= ready_contents_method_S_0052;
          when ready_contents_method_S_0052 => 
            ready_contents_method <= ready_contents_method_S_0053;
          when ready_contents_method_S_0053 => 
            ready_contents_method <= ready_contents_method_S_0058;
          when ready_contents_method_S_0058 => 
            ready_contents_method <= ready_contents_method_S_0059;
          when ready_contents_method_S_0059 => 
            ready_contents_method <= ready_contents_method_S_0062;
          when ready_contents_method_S_0062 => 
            ready_contents_method <= ready_contents_method_S_0063;
          when ready_contents_method_S_0063 => 
            ready_contents_method <= ready_contents_method_S_0065;
          when ready_contents_method_S_0065 => 
            ready_contents_method <= ready_contents_method_S_0066;
          when ready_contents_method_S_0066 => 
            if tmp_0464 = '1' then
              ready_contents_method <= ready_contents_method_S_0071;
            elsif tmp_0465 = '1' then
              ready_contents_method <= ready_contents_method_S_0067;
            end if;
          when ready_contents_method_S_0067 => 
            ready_contents_method <= ready_contents_method_S_0107;
          when ready_contents_method_S_0068 => 
            ready_contents_method <= ready_contents_method_S_0070;
          when ready_contents_method_S_0070 => 
            ready_contents_method <= ready_contents_method_S_0065;
          when ready_contents_method_S_0071 => 
            if ready_contents_method_delay >= 2 then
              ready_contents_method_delay <= (others => '0');
              ready_contents_method <= ready_contents_method_S_0072;
            else
              ready_contents_method_delay <= ready_contents_method_delay + 1;
            end if;
          when ready_contents_method_S_0072 => 
            ready_contents_method <= ready_contents_method_S_0077;
          when ready_contents_method_S_0077 => 
            ready_contents_method <= ready_contents_method_S_0078;
          when ready_contents_method_S_0078 => 
            ready_contents_method <= ready_contents_method_S_0082;
          when ready_contents_method_S_0082 => 
            ready_contents_method <= ready_contents_method_S_0083;
          when ready_contents_method_S_0083 => 
            ready_contents_method <= ready_contents_method_S_0087;
          when ready_contents_method_S_0087 => 
            ready_contents_method <= ready_contents_method_S_0088;
          when ready_contents_method_S_0088 => 
            ready_contents_method <= ready_contents_method_S_0092;
          when ready_contents_method_S_0092 => 
            ready_contents_method <= ready_contents_method_S_0093;
          when ready_contents_method_S_0093 => 
            ready_contents_method <= ready_contents_method_S_0097;
          when ready_contents_method_S_0097 => 
            if tmp_0466 = '1' then
              ready_contents_method <= ready_contents_method_S_0099;
            elsif tmp_0467 = '1' then
              ready_contents_method <= ready_contents_method_S_0098;
            end if;
          when ready_contents_method_S_0098 => 
            ready_contents_method <= ready_contents_method_S_0106;
          when ready_contents_method_S_0099 => 
            ready_contents_method <= ready_contents_method_S_0100;
          when ready_contents_method_S_0100 => 
            ready_contents_method <= ready_contents_method_S_0102;
          when ready_contents_method_S_0102 => 
            ready_contents_method <= ready_contents_method_S_0103;
          when ready_contents_method_S_0103 => 
            ready_contents_method <= ready_contents_method_S_0105;
          when ready_contents_method_S_0105 => 
            ready_contents_method <= ready_contents_method_S_0098;
          when ready_contents_method_S_0106 => 
            ready_contents_method <= ready_contents_method_S_0068;
          when ready_contents_method_S_0107 => 
            ready_contents_method <= ready_contents_method_S_0108;
          when ready_contents_method_S_0108 => 
            ready_contents_method <= ready_contents_method_S_0110;
          when ready_contents_method_S_0110 => 
            ready_contents_method <= ready_contents_method_S_0000;
          when ready_contents_method_S_0111 => 
            ready_contents_method <= ready_contents_method_S_0000;
          when others => null;
        end case;
        ready_contents_req_flag_d <= ready_contents_req_flag;
        if (tmp_0468 and tmp_0470) = '1' then
          ready_contents_method <= ready_contents_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        action_method <= action_method_IDLE;
        action_method_delay <= (others => '0');
      else
        case (action_method) is
          when action_method_IDLE => 
            action_method <= action_method_S_0000;
          when action_method_S_0000 => 
            action_method <= action_method_S_0001;
          when action_method_S_0001 => 
            if tmp_0529 = '1' then
              action_method <= action_method_S_0002;
            end if;
          when action_method_S_0002 => 
            action_method <= action_method_S_0006;
          when action_method_S_0006 => 
            action_method <= action_method_S_0007;
          when action_method_S_0007 => 
            if tmp_0531 = '1' then
              action_method <= action_method_S_0012;
            elsif tmp_0532 = '1' then
              action_method <= action_method_S_0008;
            end if;
          when action_method_S_0008 => 
            action_method <= action_method_S_0068;
          when action_method_S_0009 => 
            action_method <= action_method_S_0011;
          when action_method_S_0011 => 
            action_method <= action_method_S_0006;
          when action_method_S_0012 => 
            if action_method_delay >= 2 then
              action_method_delay <= (others => '0');
              action_method <= action_method_S_0013;
            else
              action_method_delay <= action_method_delay + 1;
            end if;
          when action_method_S_0013 => 
            action_method <= action_method_S_0014;
          when action_method_S_0014 => 
            if tmp_0533 = '1' then
              action_method <= action_method_S_0058;
            elsif tmp_0534 = '1' then
              action_method <= action_method_S_0049;
            elsif tmp_0535 = '1' then
              action_method <= action_method_S_0040;
            elsif tmp_0536 = '1' then
              action_method <= action_method_S_0030;
            elsif tmp_0537 = '1' then
              action_method <= action_method_S_0020;
            elsif tmp_0538 = '1' then
              action_method <= action_method_S_0018;
            else
              action_method <= action_method_S_0016;
            end if;
          when action_method_S_0015 => 
            action_method <= action_method_S_0067;
          when action_method_S_0016 => 
            action_method <= action_method_S_0017;
          when action_method_S_0017 => 
            action_method <= action_method_S_0015;
          when action_method_S_0018 => 
            action_method <= action_method_S_0015;
          when action_method_S_0019 => 
            action_method <= action_method_S_0016;
          when action_method_S_0020 => 
            action_method <= action_method_S_0020_body;
          when action_method_S_0021 => 
            if tmp_0543 = '1' then
              action_method <= action_method_S_0023;
            elsif tmp_0544 = '1' then
              action_method <= action_method_S_0026;
            end if;
          when action_method_S_0022 => 
            action_method <= action_method_S_0028;
          when action_method_S_0023 => 
            action_method <= action_method_S_0025;
          when action_method_S_0025 => 
            action_method <= action_method_S_0022;
          when action_method_S_0026 => 
            action_method <= action_method_S_0027;
          when action_method_S_0027 => 
            action_method <= action_method_S_0022;
          when action_method_S_0028 => 
            action_method <= action_method_S_0015;
          when action_method_S_0029 => 
            action_method <= action_method_S_0018;
          when action_method_S_0030 => 
            action_method <= action_method_S_0030_body;
          when action_method_S_0031 => 
            if tmp_0549 = '1' then
              action_method <= action_method_S_0033;
            elsif tmp_0550 = '1' then
              action_method <= action_method_S_0036;
            end if;
          when action_method_S_0032 => 
            action_method <= action_method_S_0038;
          when action_method_S_0033 => 
            action_method <= action_method_S_0035;
          when action_method_S_0035 => 
            action_method <= action_method_S_0032;
          when action_method_S_0036 => 
            action_method <= action_method_S_0037;
          when action_method_S_0037 => 
            action_method <= action_method_S_0032;
          when action_method_S_0038 => 
            action_method <= action_method_S_0015;
          when action_method_S_0039 => 
            action_method <= action_method_S_0020;
          when action_method_S_0040 => 
            action_method <= action_method_S_0041;
          when action_method_S_0041 => 
            if tmp_0551 = '1' then
              action_method <= action_method_S_0043;
            elsif tmp_0552 = '1' then
              action_method <= action_method_S_0045;
            end if;
          when action_method_S_0042 => 
            action_method <= action_method_S_0047;
          when action_method_S_0043 => 
            action_method <= action_method_S_0044;
          when action_method_S_0044 => 
            action_method <= action_method_S_0042;
          when action_method_S_0045 => 
            action_method <= action_method_S_0046;
          when action_method_S_0046 => 
            action_method <= action_method_S_0042;
          when action_method_S_0047 => 
            action_method <= action_method_S_0015;
          when action_method_S_0048 => 
            action_method <= action_method_S_0030;
          when action_method_S_0049 => 
            action_method <= action_method_S_0050;
          when action_method_S_0050 => 
            if tmp_0553 = '1' then
              action_method <= action_method_S_0052;
            elsif tmp_0554 = '1' then
              action_method <= action_method_S_0054;
            end if;
          when action_method_S_0051 => 
            action_method <= action_method_S_0056;
          when action_method_S_0052 => 
            action_method <= action_method_S_0053;
          when action_method_S_0053 => 
            action_method <= action_method_S_0051;
          when action_method_S_0054 => 
            action_method <= action_method_S_0055;
          when action_method_S_0055 => 
            action_method <= action_method_S_0051;
          when action_method_S_0056 => 
            action_method <= action_method_S_0015;
          when action_method_S_0057 => 
            action_method <= action_method_S_0040;
          when action_method_S_0058 => 
            action_method <= action_method_S_0059;
          when action_method_S_0059 => 
            if tmp_0555 = '1' then
              action_method <= action_method_S_0061;
            elsif tmp_0556 = '1' then
              action_method <= action_method_S_0063;
            end if;
          when action_method_S_0060 => 
            action_method <= action_method_S_0065;
          when action_method_S_0061 => 
            action_method <= action_method_S_0062;
          when action_method_S_0062 => 
            action_method <= action_method_S_0060;
          when action_method_S_0063 => 
            action_method <= action_method_S_0064;
          when action_method_S_0064 => 
            action_method <= action_method_S_0060;
          when action_method_S_0065 => 
            action_method <= action_method_S_0015;
          when action_method_S_0066 => 
            action_method <= action_method_S_0049;
          when action_method_S_0067 => 
            action_method <= action_method_S_0009;
          when action_method_S_0068 => 
            action_method <= action_method_S_0069;
          when action_method_S_0069 => 
            if tmp_0557 = '1' then
              action_method <= action_method_S_0071;
            elsif tmp_0558 = '1' then
              action_method <= action_method_S_0077;
            end if;
          when action_method_S_0070 => 
            action_method <= action_method_S_0080;
          when action_method_S_0071 => 
            action_method <= action_method_S_0071_body;
          when action_method_S_0072 => 
            action_method <= action_method_S_0073;
          when action_method_S_0073 => 
            action_method <= action_method_S_0076;
          when action_method_S_0076 => 
            action_method <= action_method_S_0070;
          when action_method_S_0077 => 
            action_method <= action_method_S_0079;
          when action_method_S_0079 => 
            action_method <= action_method_S_0070;
          when action_method_S_0080 => 
            action_method <= action_method_S_0000;
          when action_method_S_0020_body => 
            action_method <= action_method_S_0020_wait;
          when action_method_S_0020_wait => 
            if isHex_ext_call_flag_0020 = '1' then
              action_method <= action_method_S_0021;
            end if;
          when action_method_S_0030_body => 
            action_method <= action_method_S_0030_wait;
          when action_method_S_0030_wait => 
            if isHex_ext_call_flag_0030 = '1' then
              action_method <= action_method_S_0031;
            end if;
          when action_method_S_0071_body => 
            action_method <= action_method_S_0071_wait;
          when action_method_S_0071_wait => 
            if toHex2_ext_call_flag_0071 = '1' then
              action_method <= action_method_S_0072;
            end if;
          when others => null;
        end case;
        action_req_flag_d <= action_req_flag;
        if (tmp_0563 and tmp_0565) = '1' then
          action_method <= action_method_S_0001;
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
            if tmp_0575 = '1' then
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
            if tmp_0581 = '1' then
              tcp_server_method <= tcp_server_method_S_0010;
            elsif tmp_0582 = '1' then
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
            tcp_server_method <= tcp_server_method_S_0016_body;
          when tcp_server_method_S_0017 => 
            tcp_server_method <= tcp_server_method_S_0018;
          when tcp_server_method_S_0018 => 
            tcp_server_method <= tcp_server_method_S_0019;
          when tcp_server_method_S_0019 => 
            if tmp_0591 = '1' then
              tcp_server_method <= tcp_server_method_S_0021;
            elsif tmp_0592 = '1' then
              tcp_server_method <= tcp_server_method_S_0020;
            end if;
          when tcp_server_method_S_0020 => 
            tcp_server_method <= tcp_server_method_S_0027;
          when tcp_server_method_S_0021 => 
            tcp_server_method <= tcp_server_method_S_0023;
          when tcp_server_method_S_0023 => 
            tcp_server_method <= tcp_server_method_S_0023_body;
          when tcp_server_method_S_0024 => 
            tcp_server_method <= tcp_server_method_S_0024_body;
          when tcp_server_method_S_0025 => 
            tcp_server_method <= tcp_server_method_S_0026;
          when tcp_server_method_S_0026 => 
            tcp_server_method <= tcp_server_method_S_0018;
          when tcp_server_method_S_0027 => 
            tcp_server_method <= tcp_server_method_S_0027_body;
          when tcp_server_method_S_0028 => 
            tcp_server_method <= tcp_server_method_S_0030;
          when tcp_server_method_S_0030 => 
            tcp_server_method <= tcp_server_method_S_0030_body;
          when tcp_server_method_S_0031 => 
            if tmp_0609 = '1' then
              tcp_server_method <= tcp_server_method_S_0033;
            elsif tmp_0610 = '1' then
              tcp_server_method <= tcp_server_method_S_0032;
            end if;
          when tcp_server_method_S_0032 => 
            tcp_server_method <= tcp_server_method_S_0047;
          when tcp_server_method_S_0033 => 
            tcp_server_method <= tcp_server_method_S_0033_body;
          when tcp_server_method_S_0034 => 
            tcp_server_method <= tcp_server_method_S_0036;
          when tcp_server_method_S_0036 => 
            if tmp_0615 = '1' then
              tcp_server_method <= tcp_server_method_S_0038;
            elsif tmp_0616 = '1' then
              tcp_server_method <= tcp_server_method_S_0037;
            end if;
          when tcp_server_method_S_0037 => 
            tcp_server_method <= tcp_server_method_S_0040;
          when tcp_server_method_S_0038 => 
            tcp_server_method <= tcp_server_method_S_0032;
          when tcp_server_method_S_0039 => 
            tcp_server_method <= tcp_server_method_S_0037;
          when tcp_server_method_S_0040 => 
            tcp_server_method <= tcp_server_method_S_0040_body;
          when tcp_server_method_S_0041 => 
            tcp_server_method <= tcp_server_method_S_0042;
          when tcp_server_method_S_0042 => 
            tcp_server_method <= tcp_server_method_S_0042_body;
          when tcp_server_method_S_0043 => 
            tcp_server_method <= tcp_server_method_S_0043_body;
          when tcp_server_method_S_0044 => 
            tcp_server_method <= tcp_server_method_S_0045;
          when tcp_server_method_S_0045 => 
            tcp_server_method <= tcp_server_method_S_0045_body;
          when tcp_server_method_S_0046 => 
            tcp_server_method <= tcp_server_method_S_0031;
          when tcp_server_method_S_0047 => 
            tcp_server_method <= tcp_server_method_S_0000;
          when tcp_server_method_S_0048 => 
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
          when tcp_server_method_S_0016_body => 
            tcp_server_method <= tcp_server_method_S_0016_wait;
          when tcp_server_method_S_0016_wait => 
            if tcp_server_listen_call_flag_0016 = '1' then
              tcp_server_method <= tcp_server_method_S_0017;
            end if;
          when tcp_server_method_S_0023_body => 
            tcp_server_method <= tcp_server_method_S_0023_wait;
          when tcp_server_method_S_0023_wait => 
            if write_data_call_flag_0023 = '1' then
              tcp_server_method <= tcp_server_method_S_0024;
            end if;
          when tcp_server_method_S_0024_body => 
            tcp_server_method <= tcp_server_method_S_0024_wait;
          when tcp_server_method_S_0024_wait => 
            if tcp_server_listen_call_flag_0024 = '1' then
              tcp_server_method <= tcp_server_method_S_0025;
            end if;
          when tcp_server_method_S_0027_body => 
            tcp_server_method <= tcp_server_method_S_0027_wait;
          when tcp_server_method_S_0027_wait => 
            if wait_for_established_call_flag_0027 = '1' then
              tcp_server_method <= tcp_server_method_S_0028;
            end if;
          when tcp_server_method_S_0030_body => 
            tcp_server_method <= tcp_server_method_S_0030_wait;
          when tcp_server_method_S_0030_wait => 
            if read_data_call_flag_0030 = '1' then
              tcp_server_method <= tcp_server_method_S_0031;
            end if;
          when tcp_server_method_S_0033_body => 
            tcp_server_method <= tcp_server_method_S_0033_wait;
          when tcp_server_method_S_0033_wait => 
            if wait_for_recv_call_flag_0033 = '1' then
              tcp_server_method <= tcp_server_method_S_0034;
            end if;
          when tcp_server_method_S_0040_body => 
            tcp_server_method <= tcp_server_method_S_0040_wait;
          when tcp_server_method_S_0040_wait => 
            if pull_recv_data_call_flag_0040 = '1' then
              tcp_server_method <= tcp_server_method_S_0041;
            end if;
          when tcp_server_method_S_0042_body => 
            tcp_server_method <= tcp_server_method_S_0042_wait;
          when tcp_server_method_S_0042_wait => 
            if action_call_flag_0042 = '1' then
              tcp_server_method <= tcp_server_method_S_0043;
            end if;
          when tcp_server_method_S_0043_body => 
            tcp_server_method <= tcp_server_method_S_0043_wait;
          when tcp_server_method_S_0043_wait => 
            if ready_contents_call_flag_0043 = '1' then
              tcp_server_method <= tcp_server_method_S_0044;
            end if;
          when tcp_server_method_S_0045_body => 
            tcp_server_method <= tcp_server_method_S_0045_wait;
          when tcp_server_method_S_0045_wait => 
            if push_send_data_call_flag_0045 = '1' then
              tcp_server_method <= tcp_server_method_S_0046;
            end if;
          when others => null;
        end case;
        tcp_server_req_flag_d <= tcp_server_req_flag;
        if (tmp_0633 and tmp_0635) = '1' then
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
            if tmp_0650 = '1' then
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
            test_method <= test_method_S_0007_body;
          when test_method_S_0008 => 
            test_method <= test_method_S_0009;
          when test_method_S_0009 => 
            test_method <= test_method_S_0010;
          when test_method_S_0010 => 
            if tmp_0664 = '1' then
              test_method <= test_method_S_0012;
            elsif tmp_0665 = '1' then
              test_method <= test_method_S_0011;
            end if;
          when test_method_S_0011 => 
            test_method <= test_method_S_0014;
          when test_method_S_0012 => 
            test_method <= test_method_S_0012_body;
          when test_method_S_0013 => 
            test_method <= test_method_S_0010;
          when test_method_S_0014 => 
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
          when test_method_S_0007_body => 
            test_method <= test_method_S_0007_wait;
          when test_method_S_0007_wait => 
            if init_contents_call_flag_0007 = '1' then
              test_method <= test_method_S_0008;
            end if;
          when test_method_S_0012_body => 
            test_method <= test_method_S_0012_wait;
          when test_method_S_0012_wait => 
            if tcp_server_call_flag_0012 = '1' then
              test_method <= test_method_S_0013;
            end if;
          when others => null;
        end case;
        test_req_flag_d <= test_req_flag;
        if (tmp_0670 and tmp_0672) = '1' then
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
            if tmp_0676 = '1' then
              blink_led_method <= blink_led_method_S_0002;
            end if;
          when blink_led_method_S_0002 => 
            blink_led_method <= blink_led_method_S_0000;
          when others => null;
        end case;
        blink_led_req_flag_d <= blink_led_req_flag;
        if (tmp_0678 and tmp_0680) = '1' then
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
          class_wiz830mj_0000_address <= std_logic_vector(write_data_addr_0102);
        elsif read_data_method = read_data_method_S_0003 then
          class_wiz830mj_0000_address <= std_logic_vector(read_data_addr_0111);
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
          class_wiz830mj_0000_wdata <= std_logic_vector(write_data_data_0103);
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
        if action_method = action_method_S_0073 then
          class_led_0002 <= action_v_0439;
        elsif test_method = test_method_S_0002 then
          class_led_0002 <= X"00000000";
        elsif test_method = test_method_S_0004 then
          class_led_0002 <= X"00000001";
        elsif test_method = test_method_S_0006 then
          class_led_0002 <= X"00000003";
        elsif test_method = test_method_S_0008 then
          class_led_0002 <= X"00000004";
        elsif test_method = test_method_S_0009 then
          class_led_0002 <= X"00000000";
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
          class_buffer_0088_address_b <= binary_expr_00234;
        elsif pull_recv_data_method = pull_recv_data_method_S_0040 then
          class_buffer_0088_address_b <= binary_expr_00240;
        elsif push_send_data_method = push_send_data_method_S_0031 and push_send_data_method_delay = 0 then
          class_buffer_0088_address_b <= binary_expr_00271;
        elsif push_send_data_method = push_send_data_method_S_0038 and push_send_data_method_delay = 0 then
          class_buffer_0088_address_b <= binary_expr_00277;
        elsif ready_contents_method = ready_contents_method_S_0015 then
          class_buffer_0088_address_b <= binary_expr_00351;
        elsif ready_contents_method = ready_contents_method_S_0021 then
          class_buffer_0088_address_b <= binary_expr_00356;
        elsif ready_contents_method = ready_contents_method_S_0027 then
          class_buffer_0088_address_b <= binary_expr_00361;
        elsif ready_contents_method = ready_contents_method_S_0033 then
          class_buffer_0088_address_b <= binary_expr_00366;
        elsif ready_contents_method = ready_contents_method_S_0040 then
          class_buffer_0088_address_b <= binary_expr_00371;
        elsif ready_contents_method = ready_contents_method_S_0046 then
          class_buffer_0088_address_b <= binary_expr_00376;
        elsif ready_contents_method = ready_contents_method_S_0052 then
          class_buffer_0088_address_b <= binary_expr_00381;
        elsif ready_contents_method = ready_contents_method_S_0058 then
          class_buffer_0088_address_b <= binary_expr_00386;
        elsif ready_contents_method = ready_contents_method_S_0077 then
          class_buffer_0088_address_b <= binary_expr_00400;
        elsif ready_contents_method = ready_contents_method_S_0082 then
          class_buffer_0088_address_b <= binary_expr_00404;
        elsif ready_contents_method = ready_contents_method_S_0087 then
          class_buffer_0088_address_b <= binary_expr_00408;
        elsif ready_contents_method = ready_contents_method_S_0092 then
          class_buffer_0088_address_b <= binary_expr_00412;
        elsif ready_contents_method = ready_contents_method_S_0100 then
          class_buffer_0088_address_b <= binary_expr_00417;
        elsif ready_contents_method = ready_contents_method_S_0103 then
          class_buffer_0088_address_b <= binary_expr_00419;
        elsif action_method = action_method_S_0012 and action_method_delay = 0 then
          class_buffer_0088_address_b <= action_i_0428;
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
          class_buffer_0088_din_b <= method_result_00236;
        elsif pull_recv_data_method = pull_recv_data_method_S_0044 then
          class_buffer_0088_din_b <= method_result_00242;
        elsif ready_contents_method = ready_contents_method_S_0016 then
          class_buffer_0088_din_b <= tmp_0478;
        elsif ready_contents_method = ready_contents_method_S_0022 then
          class_buffer_0088_din_b <= tmp_0482;
        elsif ready_contents_method = ready_contents_method_S_0028 then
          class_buffer_0088_din_b <= tmp_0486;
        elsif ready_contents_method = ready_contents_method_S_0034 then
          class_buffer_0088_din_b <= tmp_0489;
        elsif ready_contents_method = ready_contents_method_S_0041 then
          class_buffer_0088_din_b <= tmp_0494;
        elsif ready_contents_method = ready_contents_method_S_0047 then
          class_buffer_0088_din_b <= tmp_0498;
        elsif ready_contents_method = ready_contents_method_S_0053 then
          class_buffer_0088_din_b <= tmp_0502;
        elsif ready_contents_method = ready_contents_method_S_0059 then
          class_buffer_0088_din_b <= tmp_0505;
        elsif ready_contents_method = ready_contents_method_S_0078 then
          class_buffer_0088_din_b <= tmp_0513;
        elsif ready_contents_method = ready_contents_method_S_0083 then
          class_buffer_0088_din_b <= tmp_0516;
        elsif ready_contents_method = ready_contents_method_S_0088 then
          class_buffer_0088_din_b <= tmp_0519;
        elsif ready_contents_method = ready_contents_method_S_0093 then
          class_buffer_0088_din_b <= tmp_0522;
        elsif ready_contents_method = ready_contents_method_S_0100 then
          class_buffer_0088_din_b <= class_arg0_0096;
        elsif ready_contents_method = ready_contents_method_S_0103 then
          class_buffer_0088_din_b <= class_arg1_0097;
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
        elsif ready_contents_method = ready_contents_method_S_0016 then
          class_buffer_0088_we_b <= '1';
        elsif ready_contents_method = ready_contents_method_S_0022 then
          class_buffer_0088_we_b <= '1';
        elsif ready_contents_method = ready_contents_method_S_0028 then
          class_buffer_0088_we_b <= '1';
        elsif ready_contents_method = ready_contents_method_S_0034 then
          class_buffer_0088_we_b <= '1';
        elsif ready_contents_method = ready_contents_method_S_0041 then
          class_buffer_0088_we_b <= '1';
        elsif ready_contents_method = ready_contents_method_S_0047 then
          class_buffer_0088_we_b <= '1';
        elsif ready_contents_method = ready_contents_method_S_0053 then
          class_buffer_0088_we_b <= '1';
        elsif ready_contents_method = ready_contents_method_S_0059 then
          class_buffer_0088_we_b <= '1';
        elsif ready_contents_method = ready_contents_method_S_0078 then
          class_buffer_0088_we_b <= '1';
        elsif ready_contents_method = ready_contents_method_S_0083 then
          class_buffer_0088_we_b <= '1';
        elsif ready_contents_method = ready_contents_method_S_0088 then
          class_buffer_0088_we_b <= '1';
        elsif ready_contents_method = ready_contents_method_S_0093 then
          class_buffer_0088_we_b <= '1';
        elsif ready_contents_method = ready_contents_method_S_0100 then
          class_buffer_0088_we_b <= '1';
        elsif ready_contents_method = ready_contents_method_S_0103 then
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
        if push_send_data_method = push_send_data_method_S_0031 and push_send_data_method_delay = 0 then
          class_buffer_0088_oe_b <= '1';
        elsif push_send_data_method = push_send_data_method_S_0038 and push_send_data_method_delay = 0 then
          class_buffer_0088_oe_b <= '1';
        elsif action_method = action_method_S_0012 and action_method_delay = 0 then
          class_buffer_0088_oe_b <= '1';
        else
          class_buffer_0088_oe_b <= '0';
        end if;
      end if;
    end if;
  end process;

  class_resp_0089_clk <= clk_sig;

  class_resp_0089_reset <= reset_sig;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_resp_0089_data_address <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0011 and ready_contents_method_delay = 0 then
          class_resp_0089_data_address <= ready_contents_i_0343;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_resp_0089_data_oe <= '0';
      else
        if ready_contents_method = ready_contents_method_S_0011 and ready_contents_method_delay = 0 then
          class_resp_0089_data_oe <= '1';
        else
          class_resp_0089_data_oe <= '0';
        end if;
      end if;
    end if;
  end process;

  class_data_0091_clk <= clk_sig;

  class_data_0091_reset <= reset_sig;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_data_0091_address_b <= (others => '0');
      else
        if init_contents_method = init_contents_method_S_0002 then
          class_data_0091_address_b <= X"00000000";
        elsif init_contents_method = init_contents_method_S_0005 then
          class_data_0091_address_b <= X"00000001";
        elsif init_contents_method = init_contents_method_S_0008 then
          class_data_0091_address_b <= X"00000002";
        elsif init_contents_method = init_contents_method_S_0011 then
          class_data_0091_address_b <= X"00000003";
        elsif init_contents_method = init_contents_method_S_0014 then
          class_data_0091_address_b <= X"00000004";
        elsif init_contents_method = init_contents_method_S_0017 then
          class_data_0091_address_b <= X"00000005";
        elsif init_contents_method = init_contents_method_S_0020 then
          class_data_0091_address_b <= X"00000006";
        elsif init_contents_method = init_contents_method_S_0023 then
          class_data_0091_address_b <= X"00000007";
        elsif init_contents_method = init_contents_method_S_0026 then
          class_data_0091_address_b <= X"00000008";
        elsif init_contents_method = init_contents_method_S_0029 then
          class_data_0091_address_b <= X"00000009";
        elsif ready_contents_method = ready_contents_method_S_0071 and ready_contents_method_delay = 0 then
          class_data_0091_address_b <= ready_contents_i_0392;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_data_0091_din_b <= (others => '0');
      else
        if init_contents_method = init_contents_method_S_0004 then
          class_data_0091_din_b <= method_result_00322;
        elsif init_contents_method = init_contents_method_S_0007 then
          class_data_0091_din_b <= method_result_00324;
        elsif init_contents_method = init_contents_method_S_0010 then
          class_data_0091_din_b <= method_result_00326;
        elsif init_contents_method = init_contents_method_S_0013 then
          class_data_0091_din_b <= method_result_00328;
        elsif init_contents_method = init_contents_method_S_0016 then
          class_data_0091_din_b <= method_result_00330;
        elsif init_contents_method = init_contents_method_S_0019 then
          class_data_0091_din_b <= method_result_00332;
        elsif init_contents_method = init_contents_method_S_0022 then
          class_data_0091_din_b <= method_result_00334;
        elsif init_contents_method = init_contents_method_S_0025 then
          class_data_0091_din_b <= method_result_00336;
        elsif init_contents_method = init_contents_method_S_0028 then
          class_data_0091_din_b <= method_result_00338;
        elsif init_contents_method = init_contents_method_S_0031 then
          class_data_0091_din_b <= method_result_00340;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_data_0091_we_b <= '0';
      else
        if init_contents_method = init_contents_method_S_0004 then
          class_data_0091_we_b <= '1';
        elsif init_contents_method = init_contents_method_S_0007 then
          class_data_0091_we_b <= '1';
        elsif init_contents_method = init_contents_method_S_0010 then
          class_data_0091_we_b <= '1';
        elsif init_contents_method = init_contents_method_S_0013 then
          class_data_0091_we_b <= '1';
        elsif init_contents_method = init_contents_method_S_0016 then
          class_data_0091_we_b <= '1';
        elsif init_contents_method = init_contents_method_S_0019 then
          class_data_0091_we_b <= '1';
        elsif init_contents_method = init_contents_method_S_0022 then
          class_data_0091_we_b <= '1';
        elsif init_contents_method = init_contents_method_S_0025 then
          class_data_0091_we_b <= '1';
        elsif init_contents_method = init_contents_method_S_0028 then
          class_data_0091_we_b <= '1';
        elsif init_contents_method = init_contents_method_S_0031 then
          class_data_0091_we_b <= '1';
        else
          class_data_0091_we_b <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_data_0091_oe_b <= '0';
      else
        if ready_contents_method = ready_contents_method_S_0071 and ready_contents_method_delay = 0 then
          class_data_0091_oe_b <= '1';
        else
          class_data_0091_oe_b <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_content_words_0092 <= X"00000008";
      else
        if init_contents_method = init_contents_method_S_0031 then
          class_content_words_0092 <= X"0000000a";
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_content_length_field_0093 <= X"33322020";
      else
        if init_contents_method = init_contents_method_S_0035 then
          class_content_length_field_0093 <= method_result_00341;
        end if;
      end if;
    end if;
  end process;

  class_misc_0094_clk <= clk_sig;

  class_misc_0094_reset <= reset_sig;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_misc_0094_i_to_4digit_ascii_x <= (others => '0');
      else
        if init_contents_method = init_contents_method_S_0034_body and init_contents_method_delay = 0 then
          class_misc_0094_i_to_4digit_ascii_x <= binary_expr_00342;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_misc_0094_isHex_v <= (others => '0');
      else
        if action_method = action_method_S_0020_body and action_method_delay = 0 then
          class_misc_0094_isHex_v <= action_b_0431;
        elsif action_method = action_method_S_0030_body and action_method_delay = 0 then
          class_misc_0094_isHex_v <= action_b_0431;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_misc_0094_toHex2_v0 <= (others => '0');
      else
        if action_method = action_method_S_0071_body and action_method_delay = 0 then
          class_misc_0094_toHex2_v0 <= action_v0_0426;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_misc_0094_toHex2_v1 <= (others => '0');
      else
        if action_method = action_method_S_0071_body and action_method_delay = 0 then
          class_misc_0094_toHex2_v1 <= action_v1_0427;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_misc_0094_i_to_4digit_ascii_req <= '0';
      else
        if init_contents_method = init_contents_method_S_0034_body then
          class_misc_0094_i_to_4digit_ascii_req <= '1';
        else
          class_misc_0094_i_to_4digit_ascii_req <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_misc_0094_isHex_req <= '0';
      else
        if action_method = action_method_S_0020_body then
          class_misc_0094_isHex_req <= '1';
        elsif action_method = action_method_S_0030_body then
          class_misc_0094_isHex_req <= '1';
        else
          class_misc_0094_isHex_req <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_misc_0094_toHex2_req <= '0';
      else
        if action_method = action_method_S_0071_body then
          class_misc_0094_toHex2_req <= '1';
        else
          class_misc_0094_toHex2_req <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_arg0_0096 <= X"20";
      else
        if action_method = action_method_S_0072 then
          class_arg0_0096 <= action_v0_0426;
        elsif action_method = action_method_S_0077 then
          class_arg0_0096 <= X"3f";
        else
          class_arg0_0096 <= class_arg0_0096_mux;
        end if;
      end if;
    end if;
  end process;

  class_arg0_0096_mux <= tmp_0002;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_arg1_0097 <= X"20";
      else
        if action_method = action_method_S_0072 then
          class_arg1_0097 <= action_v1_0427;
        elsif action_method = action_method_S_0077 then
          class_arg1_0097 <= X"3f";
        else
          class_arg1_0097 <= class_arg1_0097_mux;
        end if;
      end if;
    end if;
  end process;

  class_arg1_0097_mux <= tmp_0003;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_cycles_n_0098 <= (others => '0');
      else
        if wait_cycles_method = wait_cycles_method_S_0001 then
          wait_cycles_n_0098 <= wait_cycles_n_local;
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
        wait_cycles_i_0099 <= X"00000000";
      else
        if wait_cycles_method = wait_cycles_method_S_0002 then
          wait_cycles_i_0099 <= X"00000000";
        elsif wait_cycles_method = wait_cycles_method_S_0006 then
          wait_cycles_i_0099 <= tmp_0017;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00100 <= '0';
      else
        if wait_cycles_method = wait_cycles_method_S_0003 then
          binary_expr_00100 <= tmp_0016;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        unary_expr_00101 <= (others => '0');
      else
        if wait_cycles_method = wait_cycles_method_S_0006 then
          unary_expr_00101 <= tmp_0017;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        write_data_addr_0102 <= (others => '0');
      else
        if write_data_method = write_data_method_S_0001 then
          write_data_addr_0102 <= write_data_addr_local;
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
          write_data_addr_local <= binary_expr_00148;
        elsif tcp_server_open_method = tcp_server_open_method_S_0010_body and tcp_server_open_method_delay = 0 then
          write_data_addr_local <= binary_expr_00154;
        elsif tcp_server_open_method = tcp_server_open_method_S_0013_body and tcp_server_open_method_delay = 0 then
          write_data_addr_local <= binary_expr_00157;
        elsif tcp_server_open_method = tcp_server_open_method_S_0016_body and tcp_server_open_method_delay = 0 then
          write_data_addr_local <= binary_expr_00160;
        elsif tcp_server_listen_method = tcp_server_listen_method_S_0004_body and tcp_server_listen_method_delay = 0 then
          write_data_addr_local <= binary_expr_00167;
        elsif wait_for_recv_method = wait_for_recv_method_S_0045_body and wait_for_recv_method_delay = 0 then
          write_data_addr_local <= binary_expr_00210;
        elsif pull_recv_data_method = pull_recv_data_method_S_0048_body and pull_recv_data_method_delay = 0 then
          write_data_addr_local <= binary_expr_00247;
        elsif push_send_data_method = push_send_data_method_S_0009_body and push_send_data_method_delay = 0 then
          write_data_addr_local <= binary_expr_00254;
        elsif push_send_data_method = push_send_data_method_S_0014_body and push_send_data_method_delay = 0 then
          write_data_addr_local <= binary_expr_00260;
        elsif push_send_data_method = push_send_data_method_S_0035_body and push_send_data_method_delay = 0 then
          write_data_addr_local <= binary_expr_00275;
        elsif push_send_data_method = push_send_data_method_S_0042_body and push_send_data_method_delay = 0 then
          write_data_addr_local <= binary_expr_00281;
        elsif push_send_data_method = push_send_data_method_S_0046_body and push_send_data_method_delay = 0 then
          write_data_addr_local <= binary_expr_00284;
        elsif push_send_data_method = push_send_data_method_S_0051_body and push_send_data_method_delay = 0 then
          write_data_addr_local <= binary_expr_00287;
        elsif push_send_data_method = push_send_data_method_S_0056_body and push_send_data_method_delay = 0 then
          write_data_addr_local <= binary_expr_00292;
        elsif push_send_data_method = push_send_data_method_S_0061_body and push_send_data_method_delay = 0 then
          write_data_addr_local <= binary_expr_00297;
        elsif push_send_data_method = push_send_data_method_S_0064_body and push_send_data_method_delay = 0 then
          write_data_addr_local <= binary_expr_00302;
        elsif tcp_server_method = tcp_server_method_S_0004_body and tcp_server_method_delay = 0 then
          write_data_addr_local <= binary_expr_00444;
        elsif tcp_server_method = tcp_server_method_S_0012_body and tcp_server_method_delay = 0 then
          write_data_addr_local <= binary_expr_00450;
        elsif tcp_server_method = tcp_server_method_S_0023_body and tcp_server_method_delay = 0 then
          write_data_addr_local <= binary_expr_00456;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        write_data_data_0103 <= (others => '0');
      else
        if write_data_method = write_data_method_S_0001 then
          write_data_data_0103 <= write_data_data_local;
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
          write_data_data_local <= cast_expr_00151;
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
        elsif push_send_data_method = push_send_data_method_S_0009_body and push_send_data_method_delay = 0 then
          write_data_data_local <= cast_expr_00257;
        elsif push_send_data_method = push_send_data_method_S_0014_body and push_send_data_method_delay = 0 then
          write_data_data_local <= cast_expr_00262;
        elsif push_send_data_method = push_send_data_method_S_0035_body and push_send_data_method_delay = 0 then
          write_data_data_local <= push_send_data_v_0269;
        elsif push_send_data_method = push_send_data_method_S_0042_body and push_send_data_method_delay = 0 then
          write_data_data_local <= push_send_data_v_0269;
        elsif push_send_data_method = push_send_data_method_S_0046_body and push_send_data_method_delay = 0 then
          write_data_data_local <= class_Sn_CR_RECV_0067;
        elsif push_send_data_method = push_send_data_method_S_0051_body and push_send_data_method_delay = 0 then
          write_data_data_local <= cast_expr_00289;
        elsif push_send_data_method = push_send_data_method_S_0056_body and push_send_data_method_delay = 0 then
          write_data_data_local <= cast_expr_00294;
        elsif push_send_data_method = push_send_data_method_S_0061_body and push_send_data_method_delay = 0 then
          write_data_data_local <= cast_expr_00299;
        elsif push_send_data_method = push_send_data_method_S_0064_body and push_send_data_method_delay = 0 then
          write_data_data_local <= class_Sn_CR_SEND_0064;
        elsif tcp_server_method = tcp_server_method_S_0004_body and tcp_server_method_delay = 0 then
          write_data_data_local <= X"00";
        elsif tcp_server_method = tcp_server_method_S_0012_body and tcp_server_method_delay = 0 then
          write_data_data_local <= class_Sn_CR_CLOSE_0063;
        elsif tcp_server_method = tcp_server_method_S_0023_body and tcp_server_method_delay = 0 then
          write_data_data_local <= class_Sn_CR_CLOSE_0063;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        field_access_00104 <= (others => '0');
      else
        if write_data_method = write_data_method_S_0002 then
          field_access_00104 <= signed(class_wiz830mj_0000_address);
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        field_access_00105 <= (others => '0');
      else
        if write_data_method = write_data_method_S_0004 then
          field_access_00105 <= signed(class_wiz830mj_0000_wdata);
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        field_access_00106 <= '0';
      else
        if write_data_method = write_data_method_S_0006 then
          field_access_00106 <= class_wiz830mj_0000_cs;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        field_access_00107 <= '0';
      else
        if write_data_method = write_data_method_S_0008 then
          field_access_00107 <= class_wiz830mj_0000_we;
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
        if write_data_method = write_data_method_S_0011 then
          field_access_00109 <= class_wiz830mj_0000_we;
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
        if write_data_method = write_data_method_S_0013 then
          field_access_00110 <= class_wiz830mj_0000_cs;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        read_data_addr_0111 <= (others => '0');
      else
        if read_data_method = read_data_method_S_0001 then
          read_data_addr_0111 <= read_data_addr_local;
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
          read_data_addr_local <= binary_expr_00163;
        elsif tcp_server_listen_method = tcp_server_listen_method_S_0007_body and tcp_server_listen_method_delay = 0 then
          read_data_addr_local <= binary_expr_00170;
        elsif wait_for_established_method = wait_for_established_method_S_0007_body and wait_for_established_method_delay = 0 then
          read_data_addr_local <= binary_expr_00175;
        elsif wait_for_recv_method = wait_for_recv_method_S_0008_body and wait_for_recv_method_delay = 0 then
          read_data_addr_local <= binary_expr_00182;
        elsif wait_for_recv_method = wait_for_recv_method_S_0013_body and wait_for_recv_method_delay = 0 then
          read_data_addr_local <= binary_expr_00187;
        elsif wait_for_recv_method = wait_for_recv_method_S_0018_body and wait_for_recv_method_delay = 0 then
          read_data_addr_local <= binary_expr_00192;
        elsif wait_for_recv_method = wait_for_recv_method_S_0033_body and wait_for_recv_method_delay = 0 then
          read_data_addr_local <= binary_expr_00201;
        elsif pull_recv_data_method = pull_recv_data_method_S_0004_body and pull_recv_data_method_delay = 0 then
          read_data_addr_local <= binary_expr_00215;
        elsif pull_recv_data_method = pull_recv_data_method_S_0009_body and pull_recv_data_method_delay = 0 then
          read_data_addr_local <= binary_expr_00220;
        elsif pull_recv_data_method = pull_recv_data_method_S_0036_body and pull_recv_data_method_delay = 0 then
          read_data_addr_local <= binary_expr_00238;
        elsif pull_recv_data_method = pull_recv_data_method_S_0043_body and pull_recv_data_method_delay = 0 then
          read_data_addr_local <= binary_expr_00244;
        elsif tcp_server_method = tcp_server_method_S_0030_body and tcp_server_method_delay = 0 then
          read_data_addr_local <= binary_expr_00461;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        field_access_00112 <= (others => '0');
      else
        if read_data_method = read_data_method_S_0002 then
          field_access_00112 <= signed(class_wiz830mj_0000_address);
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
        if read_data_method = read_data_method_S_0004 then
          field_access_00113 <= class_wiz830mj_0000_cs;
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
        if read_data_method = read_data_method_S_0006 then
          field_access_00114 <= class_wiz830mj_0000_oe;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        read_data_v_0116 <= (others => '0');
      else
        if read_data_method = read_data_method_S_0010 then
          read_data_v_0116 <= field_access_00117;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        field_access_00117 <= (others => '0');
      else
        if read_data_method = read_data_method_S_0009 then
          field_access_00117 <= signed(class_wiz830mj_0000_rdata);
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        field_access_00118 <= '0';
      else
        if read_data_method = read_data_method_S_0011 then
          field_access_00118 <= class_wiz830mj_0000_oe;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        field_access_00119 <= '0';
      else
        if read_data_method = read_data_method_S_0013 then
          field_access_00119 <= class_wiz830mj_0000_cs;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        field_access_00120 <= '0';
      else
        if init_method = init_method_S_0002 then
          field_access_00120 <= class_wiz830mj_0000_cs;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        field_access_00121 <= '0';
      else
        if init_method = init_method_S_0004 then
          field_access_00121 <= class_wiz830mj_0000_we;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        field_access_00122 <= '0';
      else
        if init_method = init_method_S_0006 then
          field_access_00122 <= class_wiz830mj_0000_oe;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        field_access_00123 <= '0';
      else
        if init_method = init_method_S_0008 then
          field_access_00123 <= class_wiz830mj_0000_module_reset;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        field_access_00125 <= '0';
      else
        if init_method = init_method_S_0011 then
          field_access_00125 <= class_wiz830mj_0000_module_reset;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_open_port_0145 <= (others => '0');
      else
        if tcp_server_open_method = tcp_server_open_method_S_0001 then
          tcp_server_open_port_0145 <= tcp_server_open_port_local;
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
          tcp_server_open_port_local <= tcp_server_port_0441;
        elsif tcp_server_method = tcp_server_method_S_0013_body and tcp_server_method_delay = 0 then
          tcp_server_open_port_local <= tcp_server_port_0441;
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
        if tcp_server_open_method = tcp_server_open_method_S_0002 then
          binary_expr_00147 <= tmp_0146;
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
        if tcp_server_open_method = tcp_server_open_method_S_0002 then
          binary_expr_00148 <= tmp_0148;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00149 <= (others => '0');
      else
        if tcp_server_open_method = tcp_server_open_method_S_0002 then
          cast_expr_00149 <= tmp_0147;
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
        if tcp_server_open_method = tcp_server_open_method_S_0002 then
          binary_expr_00150 <= tmp_0149;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00151 <= (others => '0');
      else
        if tcp_server_open_method = tcp_server_open_method_S_0002 then
          cast_expr_00151 <= tmp_0150;
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
        if tcp_server_open_method = tcp_server_open_method_S_0008 then
          binary_expr_00153 <= tmp_0151;
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
        if tcp_server_open_method = tcp_server_open_method_S_0008 then
          binary_expr_00154 <= tmp_0152;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00156 <= (others => '0');
      else
        if tcp_server_open_method = tcp_server_open_method_S_0011 then
          binary_expr_00156 <= tmp_0153;
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
        if tcp_server_open_method = tcp_server_open_method_S_0011 then
          binary_expr_00157 <= tmp_0154;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00159 <= (others => '0');
      else
        if tcp_server_open_method = tcp_server_open_method_S_0014 then
          binary_expr_00159 <= tmp_0155;
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
        if tcp_server_open_method = tcp_server_open_method_S_0014 then
          binary_expr_00160 <= tmp_0156;
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
        if tcp_server_open_method = tcp_server_open_method_S_0019_wait then
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
        if tcp_server_open_method = tcp_server_open_method_S_0017 then
          binary_expr_00162 <= tmp_0157;
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
        if tcp_server_open_method = tcp_server_open_method_S_0017 then
          binary_expr_00163 <= tmp_0158;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_listen_port_0164 <= (others => '0');
      else
        if tcp_server_listen_method = tcp_server_listen_method_S_0001 then
          tcp_server_listen_port_0164 <= tcp_server_listen_port_local;
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
        if tcp_server_method = tcp_server_method_S_0016_body and tcp_server_method_delay = 0 then
          tcp_server_listen_port_local <= tcp_server_port_0441;
        elsif tcp_server_method = tcp_server_method_S_0024_body and tcp_server_method_delay = 0 then
          tcp_server_listen_port_local <= tcp_server_port_0441;
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
        if tcp_server_listen_method = tcp_server_listen_method_S_0002 then
          binary_expr_00166 <= tmp_0171;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00167 <= (others => '0');
      else
        if tcp_server_listen_method = tcp_server_listen_method_S_0002 then
          binary_expr_00167 <= tmp_0172;
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
        if tcp_server_listen_method = tcp_server_listen_method_S_0007_wait then
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
        if tcp_server_listen_method = tcp_server_listen_method_S_0005 then
          binary_expr_00169 <= tmp_0173;
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
        if tcp_server_listen_method = tcp_server_listen_method_S_0005 then
          binary_expr_00170 <= tmp_0174;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_established_port_0171 <= (others => '0');
      else
        if wait_for_established_method = wait_for_established_method_S_0001 then
          wait_for_established_port_0171 <= wait_for_established_port_local;
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
        if tcp_server_method = tcp_server_method_S_0027_body and tcp_server_method_delay = 0 then
          wait_for_established_port_local <= tcp_server_port_0441;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_established_v_0172 <= X"00";
      else
        if wait_for_established_method = wait_for_established_method_S_0002 then
          wait_for_established_v_0172 <= X"00";
        elsif wait_for_established_method = wait_for_established_method_S_0008 then
          wait_for_established_v_0172 <= method_result_00173;
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
        if wait_for_established_method = wait_for_established_method_S_0007_wait then
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
        if wait_for_established_method = wait_for_established_method_S_0005 then
          binary_expr_00174 <= tmp_0187;
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
        if wait_for_established_method = wait_for_established_method_S_0005 then
          binary_expr_00175 <= tmp_0188;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00176 <= '0';
      else
        if wait_for_established_method = wait_for_established_method_S_0008 then
          binary_expr_00176 <= tmp_0189;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_recv_port_0177 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0001 then
          wait_for_recv_port_0177 <= wait_for_recv_port_local;
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
        if tcp_server_method = tcp_server_method_S_0033_body and tcp_server_method_delay = 0 then
          wait_for_recv_port_local <= tcp_server_port_0441;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_recv_v_0178 <= X"00000000";
      else
        if wait_for_recv_method = wait_for_recv_method_S_0002 then
          wait_for_recv_v_0178 <= X"00000000";
        elsif wait_for_recv_method = wait_for_recv_method_S_0005 then
          wait_for_recv_v_0178 <= X"00000000";
        elsif wait_for_recv_method = wait_for_recv_method_S_0019 then
          wait_for_recv_v_0178 <= tmp_0236;
        elsif wait_for_recv_method = wait_for_recv_method_S_0034 then
          wait_for_recv_v_0178 <= tmp_0240;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_recv_v0_0179 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0009 then
          wait_for_recv_v0_0179 <= tmp_0226;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00180 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0008_wait then
          method_result_00180 <= read_data_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00181 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0005 then
          binary_expr_00181 <= tmp_0224;
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
        if wait_for_recv_method = wait_for_recv_method_S_0005 then
          binary_expr_00182 <= tmp_0225;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00183 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0009 then
          cast_expr_00183 <= tmp_0226;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_recv_v1_0184 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0014 then
          wait_for_recv_v1_0184 <= tmp_0229;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00185 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0013_wait then
          method_result_00185 <= read_data_return;
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
        if wait_for_recv_method = wait_for_recv_method_S_0009 then
          binary_expr_00186 <= tmp_0227;
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
        if wait_for_recv_method = wait_for_recv_method_S_0009 then
          binary_expr_00187 <= tmp_0228;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00188 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0014 then
          cast_expr_00188 <= tmp_0229;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        wait_for_recv_v2_0189 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0019 then
          wait_for_recv_v2_0189 <= tmp_0232;
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
        if wait_for_recv_method = wait_for_recv_method_S_0018_wait then
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
        if wait_for_recv_method = wait_for_recv_method_S_0014 then
          binary_expr_00191 <= tmp_0230;
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
        if wait_for_recv_method = wait_for_recv_method_S_0014 then
          binary_expr_00192 <= tmp_0231;
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
        if wait_for_recv_method = wait_for_recv_method_S_0019 then
          cast_expr_00193 <= tmp_0232;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00194 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0019 then
          binary_expr_00194 <= tmp_0233;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00195 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0019 then
          binary_expr_00195 <= tmp_0234;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00196 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0019 then
          binary_expr_00196 <= tmp_0235;
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
        if wait_for_recv_method = wait_for_recv_method_S_0019 then
          binary_expr_00197 <= tmp_0236;
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
        if wait_for_recv_method = wait_for_recv_method_S_0019 then
          binary_expr_00198 <= tmp_0237;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00199 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0033_wait then
          method_result_00199 <= read_data_return;
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
        if wait_for_recv_method = wait_for_recv_method_S_0031 then
          binary_expr_00200 <= tmp_0238;
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
        if wait_for_recv_method = wait_for_recv_method_S_0031 then
          binary_expr_00201 <= tmp_0239;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00202 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0034 then
          cast_expr_00202 <= tmp_0240;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00203 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0034 then
          cast_expr_00203 <= tmp_0241;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00204 <= '0';
      else
        if wait_for_recv_method = wait_for_recv_method_S_0034 then
          binary_expr_00204 <= tmp_0243;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00205 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0034 then
          cast_expr_00205 <= tmp_0242;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00206 <= '0';
      else
        if wait_for_recv_method = wait_for_recv_method_S_0034 then
          binary_expr_00206 <= tmp_0244;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00207 <= '0';
      else
        if wait_for_recv_method = wait_for_recv_method_S_0034 then
          binary_expr_00207 <= tmp_0245;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00209 <= (others => '0');
      else
        if wait_for_recv_method = wait_for_recv_method_S_0043 then
          binary_expr_00209 <= tmp_0246;
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
        if wait_for_recv_method = wait_for_recv_method_S_0043 then
          binary_expr_00210 <= tmp_0247;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pull_recv_data_port_0211 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0001 then
          pull_recv_data_port_0211 <= pull_recv_data_port_local;
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
        if tcp_server_method = tcp_server_method_S_0040_body and tcp_server_method_delay = 0 then
          pull_recv_data_port_local <= tcp_server_port_0441;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pull_recv_data_v0_0212 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0005 then
          pull_recv_data_v0_0212 <= tmp_0282;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00213 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0004_wait then
          method_result_00213 <= read_data_return;
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
        if pull_recv_data_method = pull_recv_data_method_S_0002 then
          binary_expr_00214 <= tmp_0280;
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
        if pull_recv_data_method = pull_recv_data_method_S_0002 then
          binary_expr_00215 <= tmp_0281;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00216 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0005 then
          cast_expr_00216 <= tmp_0282;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pull_recv_data_v1_0217 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0010 then
          pull_recv_data_v1_0217 <= tmp_0285;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00218 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0009_wait then
          method_result_00218 <= read_data_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00219 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0005 then
          binary_expr_00219 <= tmp_0283;
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
        if pull_recv_data_method = pull_recv_data_method_S_0005 then
          binary_expr_00220 <= tmp_0284;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00221 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0010 then
          cast_expr_00221 <= tmp_0285;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pull_recv_data_actual_len_0222 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0010 then
          pull_recv_data_actual_len_0222 <= tmp_0287;
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
        if pull_recv_data_method = pull_recv_data_method_S_0010 then
          binary_expr_00223 <= tmp_0286;
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
        if pull_recv_data_method = pull_recv_data_method_S_0010 then
          binary_expr_00224 <= tmp_0287;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pull_recv_data_read_len_0225 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0010 then
          pull_recv_data_read_len_0225 <= tmp_0288;
        elsif pull_recv_data_method = pull_recv_data_method_S_0021 then
          pull_recv_data_read_len_0225 <= tmp_0291;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00226 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0010 then
          binary_expr_00226 <= tmp_0288;
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
        if pull_recv_data_method = pull_recv_data_method_S_0010 then
          binary_expr_00227 <= tmp_0289;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00228 <= '0';
      else
        if pull_recv_data_method = pull_recv_data_method_S_0010 then
          binary_expr_00228 <= tmp_0290;
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
        if pull_recv_data_method = pull_recv_data_method_S_0046 then
          binary_expr_00246 <= tmp_0302;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00247 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0046 then
          binary_expr_00247 <= tmp_0303;
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
        if pull_recv_data_method = pull_recv_data_method_S_0021 then
          binary_expr_00229 <= tmp_0291;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pull_recv_data_i_0230 <= X"00000000";
      else
        if pull_recv_data_method = pull_recv_data_method_S_0024 then
          pull_recv_data_i_0230 <= X"00000000";
        elsif pull_recv_data_method = pull_recv_data_method_S_0028 then
          pull_recv_data_i_0230 <= tmp_0293;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00231 <= '0';
      else
        if pull_recv_data_method = pull_recv_data_method_S_0025 then
          binary_expr_00231 <= tmp_0292;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        unary_expr_00232 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0028 then
          unary_expr_00232 <= tmp_0293;
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
        if pull_recv_data_method = pull_recv_data_method_S_0031 then
          binary_expr_00233 <= tmp_0294;
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
        if pull_recv_data_method = pull_recv_data_method_S_0031 then
          binary_expr_00234 <= tmp_0295;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00236 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0036_wait then
          method_result_00236 <= read_data_return;
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
        if pull_recv_data_method = pull_recv_data_method_S_0034 then
          binary_expr_00237 <= tmp_0296;
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
        if pull_recv_data_method = pull_recv_data_method_S_0034 then
          binary_expr_00238 <= tmp_0297;
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
        if pull_recv_data_method = pull_recv_data_method_S_0037 then
          binary_expr_00239 <= tmp_0298;
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
        if pull_recv_data_method = pull_recv_data_method_S_0037 then
          binary_expr_00240 <= tmp_0299;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00242 <= (others => '0');
      else
        if pull_recv_data_method = pull_recv_data_method_S_0043_wait then
          method_result_00242 <= read_data_return;
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
        if pull_recv_data_method = pull_recv_data_method_S_0041 then
          binary_expr_00243 <= tmp_0300;
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
        if pull_recv_data_method = pull_recv_data_method_S_0041 then
          binary_expr_00244 <= tmp_0301;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        push_send_data_port_0248 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0001 then
          push_send_data_port_0248 <= push_send_data_port_local;
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
        if tcp_server_method = tcp_server_method_S_0045_body and tcp_server_method_delay = 0 then
          push_send_data_port_local <= tcp_server_port_0441;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        push_send_data_len_0249 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0001 then
          push_send_data_len_0249 <= push_send_data_len_local;
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
        if tcp_server_method = tcp_server_method_S_0045_body and tcp_server_method_delay = 0 then
          push_send_data_len_local <= tcp_server_len_0462;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        push_send_data_write_len_0250 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0002 then
          push_send_data_write_len_0250 <= tmp_0344;
        elsif push_send_data_method = push_send_data_method_S_0019 then
          push_send_data_write_len_0250 <= tmp_0356;
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
        if push_send_data_method = push_send_data_method_S_0002 then
          binary_expr_00251 <= tmp_0344;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00253 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0002 then
          binary_expr_00253 <= tmp_0345;
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
        if push_send_data_method = push_send_data_method_S_0002 then
          binary_expr_00254 <= tmp_0347;
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
        if push_send_data_method = push_send_data_method_S_0002 then
          binary_expr_00255 <= tmp_0346;
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
        if push_send_data_method = push_send_data_method_S_0002 then
          binary_expr_00256 <= tmp_0348;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00257 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0002 then
          cast_expr_00257 <= tmp_0349;
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
        if push_send_data_method = push_send_data_method_S_0010 then
          binary_expr_00259 <= tmp_0350;
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
        if push_send_data_method = push_send_data_method_S_0010 then
          binary_expr_00260 <= tmp_0352;
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
        if push_send_data_method = push_send_data_method_S_0010 then
          binary_expr_00261 <= tmp_0351;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00262 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0010 then
          cast_expr_00262 <= tmp_0353;
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
        if push_send_data_method = push_send_data_method_S_0015 then
          binary_expr_00263 <= tmp_0354;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00264 <= '0';
      else
        if push_send_data_method = push_send_data_method_S_0015 then
          binary_expr_00264 <= tmp_0355;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00283 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0044 then
          binary_expr_00283 <= tmp_0367;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00284 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0044 then
          binary_expr_00284 <= tmp_0368;
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
        if push_send_data_method = push_send_data_method_S_0047 then
          binary_expr_00286 <= tmp_0369;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00287 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0047 then
          binary_expr_00287 <= tmp_0371;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00288 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0047 then
          binary_expr_00288 <= tmp_0370;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00289 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0047 then
          cast_expr_00289 <= tmp_0372;
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
        if push_send_data_method = push_send_data_method_S_0052 then
          binary_expr_00291 <= tmp_0373;
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
        if push_send_data_method = push_send_data_method_S_0052 then
          binary_expr_00292 <= tmp_0375;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00293 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0052 then
          binary_expr_00293 <= tmp_0374;
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
        if push_send_data_method = push_send_data_method_S_0052 then
          cast_expr_00294 <= tmp_0376;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00296 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0057 then
          binary_expr_00296 <= tmp_0377;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00297 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0057 then
          binary_expr_00297 <= tmp_0379;
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
        if push_send_data_method = push_send_data_method_S_0057 then
          binary_expr_00298 <= tmp_0378;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00299 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0057 then
          cast_expr_00299 <= tmp_0380;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00301 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0062 then
          binary_expr_00301 <= tmp_0381;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00302 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0062 then
          binary_expr_00302 <= tmp_0382;
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
        if push_send_data_method = push_send_data_method_S_0019 then
          binary_expr_00265 <= tmp_0356;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        push_send_data_i_0266 <= X"00000000";
      else
        if push_send_data_method = push_send_data_method_S_0022 then
          push_send_data_i_0266 <= X"00000000";
        elsif push_send_data_method = push_send_data_method_S_0026 then
          push_send_data_i_0266 <= tmp_0358;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00267 <= '0';
      else
        if push_send_data_method = push_send_data_method_S_0023 then
          binary_expr_00267 <= tmp_0357;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        unary_expr_00268 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0026 then
          unary_expr_00268 <= tmp_0358;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        push_send_data_v_0269 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0032 then
          push_send_data_v_0269 <= array_access_00272;
        elsif push_send_data_method = push_send_data_method_S_0039 then
          push_send_data_v_0269 <= array_access_00278;
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
        if push_send_data_method = push_send_data_method_S_0029 then
          binary_expr_00270 <= tmp_0359;
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
        if push_send_data_method = push_send_data_method_S_0029 then
          binary_expr_00271 <= tmp_0360;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        array_access_00272 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0031 and push_send_data_method_delay = 2 then
          array_access_00272 <= class_buffer_0088_dout_b;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00274 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0032 then
          binary_expr_00274 <= tmp_0361;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00275 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0032 then
          binary_expr_00275 <= tmp_0362;
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
        if push_send_data_method = push_send_data_method_S_0036 then
          binary_expr_00276 <= tmp_0363;
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
        if push_send_data_method = push_send_data_method_S_0036 then
          binary_expr_00277 <= tmp_0364;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        array_access_00278 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0038 and push_send_data_method_delay = 2 then
          array_access_00278 <= class_buffer_0088_dout_b;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00280 <= (others => '0');
      else
        if push_send_data_method = push_send_data_method_S_0039 then
          binary_expr_00280 <= tmp_0365;
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
        if push_send_data_method = push_send_data_method_S_0039 then
          binary_expr_00281 <= tmp_0366;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pack_a_0303 <= (others => '0');
      else
        if pack_method = pack_method_S_0001 then
          pack_a_0303 <= pack_a_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pack_a_local <= (others => '0');
      else
        if init_contents_method = init_contents_method_S_0003_body and init_contents_method_delay = 0 then
          pack_a_local <= X"003c";
        elsif init_contents_method = init_contents_method_S_0006_body and init_contents_method_delay = 0 then
          pack_a_local <= X"006c";
        elsif init_contents_method = init_contents_method_S_0009_body and init_contents_method_delay = 0 then
          pack_a_local <= X"006f";
        elsif init_contents_method = init_contents_method_S_0012_body and init_contents_method_delay = 0 then
          pack_a_local <= X"0041";
        elsif init_contents_method = init_contents_method_S_0015_body and init_contents_method_delay = 0 then
          pack_a_local <= X"006d";
        elsif init_contents_method = init_contents_method_S_0018_body and init_contents_method_delay = 0 then
          pack_a_local <= X"003f";
        elsif init_contents_method = init_contents_method_S_0021_body and init_contents_method_delay = 0 then
          pack_a_local <= X"003c";
        elsif init_contents_method = init_contents_method_S_0024_body and init_contents_method_delay = 0 then
          pack_a_local <= X"0064";
        elsif init_contents_method = init_contents_method_S_0027_body and init_contents_method_delay = 0 then
          pack_a_local <= X"002f";
        elsif init_contents_method = init_contents_method_S_0030_body and init_contents_method_delay = 0 then
          pack_a_local <= X"006c";
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pack_b_0304 <= (others => '0');
      else
        if pack_method = pack_method_S_0001 then
          pack_b_0304 <= pack_b_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pack_b_local <= (others => '0');
      else
        if init_contents_method = init_contents_method_S_0003_body and init_contents_method_delay = 0 then
          pack_b_local <= X"0068";
        elsif init_contents_method = init_contents_method_S_0006_body and init_contents_method_delay = 0 then
          pack_b_local <= X"003e";
        elsif init_contents_method = init_contents_method_S_0009_body and init_contents_method_delay = 0 then
          pack_b_local <= X"0064";
        elsif init_contents_method = init_contents_method_S_0012_body and init_contents_method_delay = 0 then
          pack_b_local <= X"0072";
        elsif init_contents_method = init_contents_method_S_0015_body and init_contents_method_delay = 0 then
          pack_b_local <= X"0065";
        elsif init_contents_method = init_contents_method_S_0018_body and init_contents_method_delay = 0 then
          pack_b_local <= X"003d";
        elsif init_contents_method = init_contents_method_S_0021_body and init_contents_method_delay = 0 then
          pack_b_local <= X"002f";
        elsif init_contents_method = init_contents_method_S_0024_body and init_contents_method_delay = 0 then
          pack_b_local <= X"0079";
        elsif init_contents_method = init_contents_method_S_0027_body and init_contents_method_delay = 0 then
          pack_b_local <= X"0068";
        elsif init_contents_method = init_contents_method_S_0030_body and init_contents_method_delay = 0 then
          pack_b_local <= X"003e";
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pack_c_0305 <= (others => '0');
      else
        if pack_method = pack_method_S_0001 then
          pack_c_0305 <= pack_c_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pack_c_local <= (others => '0');
      else
        if init_contents_method = init_contents_method_S_0003_body and init_contents_method_delay = 0 then
          pack_c_local <= X"0074";
        elsif init_contents_method = init_contents_method_S_0006_body and init_contents_method_delay = 0 then
          pack_c_local <= X"003c";
        elsif init_contents_method = init_contents_method_S_0009_body and init_contents_method_delay = 0 then
          pack_c_local <= X"0079";
        elsif init_contents_method = init_contents_method_S_0012_body and init_contents_method_delay = 0 then
          pack_c_local <= X"0067";
        elsif init_contents_method = init_contents_method_S_0015_body and init_contents_method_delay = 0 then
          pack_c_local <= X"006e";
        elsif init_contents_method = init_contents_method_S_0018_body and init_contents_method_delay = 0 then
          pack_c_local <= X"0020";
        elsif init_contents_method = init_contents_method_S_0021_body and init_contents_method_delay = 0 then
          pack_c_local <= X"0062";
        elsif init_contents_method = init_contents_method_S_0024_body and init_contents_method_delay = 0 then
          pack_c_local <= X"003e";
        elsif init_contents_method = init_contents_method_S_0027_body and init_contents_method_delay = 0 then
          pack_c_local <= X"0074";
        elsif init_contents_method = init_contents_method_S_0030_body and init_contents_method_delay = 0 then
          pack_c_local <= X"000a";
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pack_d_0306 <= (others => '0');
      else
        if pack_method = pack_method_S_0001 then
          pack_d_0306 <= pack_d_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pack_d_local <= (others => '0');
      else
        if init_contents_method = init_contents_method_S_0003_body and init_contents_method_delay = 0 then
          pack_d_local <= X"006d";
        elsif init_contents_method = init_contents_method_S_0006_body and init_contents_method_delay = 0 then
          pack_d_local <= X"0062";
        elsif init_contents_method = init_contents_method_S_0009_body and init_contents_method_delay = 0 then
          pack_d_local <= X"003e";
        elsif init_contents_method = init_contents_method_S_0012_body and init_contents_method_delay = 0 then
          pack_d_local <= X"0075";
        elsif init_contents_method = init_contents_method_S_0015_body and init_contents_method_delay = 0 then
          pack_d_local <= X"0074";
        elsif init_contents_method = init_contents_method_S_0018_body and init_contents_method_delay = 0 then
          pack_d_local <= X"0020";
        elsif init_contents_method = init_contents_method_S_0021_body and init_contents_method_delay = 0 then
          pack_d_local <= X"006f";
        elsif init_contents_method = init_contents_method_S_0024_body and init_contents_method_delay = 0 then
          pack_d_local <= X"003c";
        elsif init_contents_method = init_contents_method_S_0027_body and init_contents_method_delay = 0 then
          pack_d_local <= X"006d";
        elsif init_contents_method = init_contents_method_S_0030_body and init_contents_method_delay = 0 then
          pack_d_local <= X"000a";
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00307 <= (others => '0');
      else
        if pack_method = pack_method_S_0002 then
          cast_expr_00307 <= signed(tmp_0391);
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00308 <= (others => '0');
      else
        if pack_method = pack_method_S_0002 then
          binary_expr_00308 <= tmp_0395;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00309 <= (others => '0');
      else
        if pack_method = pack_method_S_0002 then
          binary_expr_00309 <= tmp_0399;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00310 <= (others => '0');
      else
        if pack_method = pack_method_S_0002 then
          cast_expr_00310 <= signed(tmp_0392);
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00311 <= (others => '0');
      else
        if pack_method = pack_method_S_0002 then
          binary_expr_00311 <= tmp_0396;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00312 <= (others => '0');
      else
        if pack_method = pack_method_S_0002 then
          binary_expr_00312 <= tmp_0400;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00313 <= (others => '0');
      else
        if pack_method = pack_method_S_0002 then
          binary_expr_00313 <= tmp_0402;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00314 <= (others => '0');
      else
        if pack_method = pack_method_S_0002 then
          cast_expr_00314 <= signed(tmp_0393);
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00315 <= (others => '0');
      else
        if pack_method = pack_method_S_0002 then
          binary_expr_00315 <= tmp_0397;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00316 <= (others => '0');
      else
        if pack_method = pack_method_S_0002 then
          binary_expr_00316 <= tmp_0401;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00317 <= (others => '0');
      else
        if pack_method = pack_method_S_0002 then
          binary_expr_00317 <= tmp_0403;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00318 <= (others => '0');
      else
        if pack_method = pack_method_S_0002 then
          cast_expr_00318 <= signed(tmp_0394);
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00319 <= (others => '0');
      else
        if pack_method = pack_method_S_0002 then
          binary_expr_00319 <= tmp_0398;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00320 <= (others => '0');
      else
        if pack_method = pack_method_S_0002 then
          binary_expr_00320 <= tmp_0404;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00322 <= (others => '0');
      else
        if init_contents_method = init_contents_method_S_0003_wait then
          method_result_00322 <= pack_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00324 <= (others => '0');
      else
        if init_contents_method = init_contents_method_S_0006_wait then
          method_result_00324 <= pack_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00326 <= (others => '0');
      else
        if init_contents_method = init_contents_method_S_0009_wait then
          method_result_00326 <= pack_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00328 <= (others => '0');
      else
        if init_contents_method = init_contents_method_S_0012_wait then
          method_result_00328 <= pack_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00330 <= (others => '0');
      else
        if init_contents_method = init_contents_method_S_0015_wait then
          method_result_00330 <= pack_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00332 <= (others => '0');
      else
        if init_contents_method = init_contents_method_S_0018_wait then
          method_result_00332 <= pack_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00334 <= (others => '0');
      else
        if init_contents_method = init_contents_method_S_0021_wait then
          method_result_00334 <= pack_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00336 <= (others => '0');
      else
        if init_contents_method = init_contents_method_S_0024_wait then
          method_result_00336 <= pack_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00338 <= (others => '0');
      else
        if init_contents_method = init_contents_method_S_0027_wait then
          method_result_00338 <= pack_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00340 <= (others => '0');
      else
        if init_contents_method = init_contents_method_S_0030_wait then
          method_result_00340 <= pack_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00341 <= (others => '0');
      else
        if init_contents_method = init_contents_method_S_0034_wait then
          method_result_00341 <= class_misc_0094_i_to_4digit_ascii_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00342 <= (others => '0');
      else
        if init_contents_method = init_contents_method_S_0031 then
          binary_expr_00342 <= tmp_0457;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00370 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0038 then
          binary_expr_00370 <= tmp_0490;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00371 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0038 then
          binary_expr_00371 <= tmp_0491;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00373 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0041 then
          binary_expr_00373 <= tmp_0492;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00374 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0041 then
          cast_expr_00374 <= tmp_0494;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00375 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0041 then
          binary_expr_00375 <= tmp_0493;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00376 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0041 then
          binary_expr_00376 <= tmp_0495;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00378 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0047 then
          binary_expr_00378 <= tmp_0496;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00379 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0047 then
          cast_expr_00379 <= tmp_0498;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00380 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0047 then
          binary_expr_00380 <= tmp_0497;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00381 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0047 then
          binary_expr_00381 <= tmp_0499;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00383 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0053 then
          binary_expr_00383 <= tmp_0500;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00384 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0053 then
          cast_expr_00384 <= tmp_0502;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00385 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0053 then
          binary_expr_00385 <= tmp_0501;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00386 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0053 then
          binary_expr_00386 <= tmp_0503;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00388 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0059 then
          binary_expr_00388 <= tmp_0504;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00389 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0059 then
          cast_expr_00389 <= tmp_0505;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        ready_contents_offset_0390 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0063 then
          ready_contents_offset_0390 <= field_access_00391;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        field_access_00391 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0062 then
          field_access_00391 <= class_resp_0089_length;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        field_access_00421 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0107 then
          field_access_00421 <= class_resp_0089_length;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00422 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0108 then
          binary_expr_00422 <= tmp_0525;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00423 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0108 then
          binary_expr_00423 <= tmp_0526;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        ready_contents_i_0343 <= X"00000000";
      else
        if ready_contents_method = ready_contents_method_S_0002 then
          ready_contents_i_0343 <= X"00000000";
        elsif ready_contents_method = ready_contents_method_S_0007 then
          ready_contents_i_0343 <= tmp_0473;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        field_access_00344 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0003 then
          field_access_00344 <= class_resp_0089_length;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00345 <= '0';
      else
        if ready_contents_method = ready_contents_method_S_0004 then
          binary_expr_00345 <= tmp_0472;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        unary_expr_00346 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0007 then
          unary_expr_00346 <= tmp_0473;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        ready_contents_v_0347 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0012 then
          ready_contents_v_0347 <= array_access_00349;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        array_access_00349 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0011 and ready_contents_method_delay = 2 then
          array_access_00349 <= class_resp_0089_data_dout;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00350 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0012 then
          binary_expr_00350 <= tmp_0474;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00351 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0012 then
          binary_expr_00351 <= tmp_0475;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00353 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0016 then
          binary_expr_00353 <= tmp_0476;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00354 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0016 then
          cast_expr_00354 <= tmp_0478;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00355 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0016 then
          binary_expr_00355 <= tmp_0477;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00356 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0016 then
          binary_expr_00356 <= tmp_0479;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00358 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0022 then
          binary_expr_00358 <= tmp_0480;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00359 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0022 then
          cast_expr_00359 <= tmp_0482;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00360 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0022 then
          binary_expr_00360 <= tmp_0481;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00361 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0022 then
          binary_expr_00361 <= tmp_0483;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00363 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0028 then
          binary_expr_00363 <= tmp_0484;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00364 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0028 then
          cast_expr_00364 <= tmp_0486;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00365 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0028 then
          binary_expr_00365 <= tmp_0485;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00366 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0028 then
          binary_expr_00366 <= tmp_0487;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00368 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0034 then
          binary_expr_00368 <= tmp_0488;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00369 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0034 then
          cast_expr_00369 <= tmp_0489;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        ready_contents_i_0392 <= X"00000000";
      else
        if ready_contents_method = ready_contents_method_S_0063 then
          ready_contents_i_0392 <= X"00000000";
        elsif ready_contents_method = ready_contents_method_S_0068 then
          ready_contents_i_0392 <= tmp_0507;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00393 <= '0';
      else
        if ready_contents_method = ready_contents_method_S_0065 then
          binary_expr_00393 <= tmp_0506;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        unary_expr_00394 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0068 then
          unary_expr_00394 <= tmp_0507;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        ready_contents_v_0395 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0072 then
          ready_contents_v_0395 <= array_access_00396;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        array_access_00396 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0071 and ready_contents_method_delay = 2 then
          array_access_00396 <= class_data_0091_dout_b;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        ready_contents_ptr_0397 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0072 then
          ready_contents_ptr_0397 <= tmp_0509;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00398 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0072 then
          binary_expr_00398 <= tmp_0508;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00399 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0072 then
          binary_expr_00399 <= tmp_0509;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00400 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0072 then
          binary_expr_00400 <= tmp_0510;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00402 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0078 then
          binary_expr_00402 <= tmp_0511;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00403 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0078 then
          cast_expr_00403 <= tmp_0513;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00404 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0078 then
          binary_expr_00404 <= tmp_0512;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00406 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0083 then
          binary_expr_00406 <= tmp_0514;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00407 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0083 then
          cast_expr_00407 <= tmp_0516;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00408 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0083 then
          binary_expr_00408 <= tmp_0515;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00410 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0088 then
          binary_expr_00410 <= tmp_0517;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00411 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0088 then
          cast_expr_00411 <= tmp_0519;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00412 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0088 then
          binary_expr_00412 <= tmp_0518;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00414 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0093 then
          binary_expr_00414 <= tmp_0520;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00415 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0093 then
          cast_expr_00415 <= tmp_0522;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00416 <= '0';
      else
        if ready_contents_method = ready_contents_method_S_0093 then
          binary_expr_00416 <= tmp_0521;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00417 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0099 then
          binary_expr_00417 <= tmp_0523;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00419 <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0102 then
          binary_expr_00419 <= tmp_0524;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        action_len_0424 <= (others => '0');
      else
        if action_method = action_method_S_0001 then
          action_len_0424 <= action_len_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        action_len_local <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0042_body and tcp_server_method_delay = 0 then
          action_len_local <= tcp_server_len_0462;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        action_S_0425 <= X"00000000";
      else
        if action_method = action_method_S_0002 then
          action_S_0425 <= X"00000000";
        elsif action_method = action_method_S_0016 then
          action_S_0425 <= X"00000000";
        elsif action_method = action_method_S_0023 then
          action_S_0425 <= X"00000005";
        elsif action_method = action_method_S_0026 then
          action_S_0425 <= X"00000000";
        elsif action_method = action_method_S_0033 then
          action_S_0425 <= X"00000004";
        elsif action_method = action_method_S_0036 then
          action_S_0425 <= X"00000000";
        elsif action_method = action_method_S_0043 then
          action_S_0425 <= X"00000003";
        elsif action_method = action_method_S_0045 then
          action_S_0425 <= X"00000000";
        elsif action_method = action_method_S_0052 then
          action_S_0425 <= X"00000002";
        elsif action_method = action_method_S_0054 then
          action_S_0425 <= X"00000000";
        elsif action_method = action_method_S_0061 then
          action_S_0425 <= X"00000001";
        elsif action_method = action_method_S_0063 then
          action_S_0425 <= X"00000000";
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        action_v0_0426 <= X"00";
      else
        if action_method = action_method_S_0002 then
          action_v0_0426 <= X"00";
        elsif action_method = action_method_S_0033 then
          action_v0_0426 <= action_b_0431;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        action_v1_0427 <= X"00";
      else
        if action_method = action_method_S_0002 then
          action_v1_0427 <= X"00";
        elsif action_method = action_method_S_0023 then
          action_v1_0427 <= action_b_0431;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00438 <= '0';
      else
        if action_method = action_method_S_0068 then
          binary_expr_00438 <= tmp_0572;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        action_i_0428 <= X"00000000";
      else
        if action_method = action_method_S_0002 then
          action_i_0428 <= X"00000000";
        elsif action_method = action_method_S_0009 then
          action_i_0428 <= tmp_0568;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00429 <= '0';
      else
        if action_method = action_method_S_0006 then
          binary_expr_00429 <= tmp_0567;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        unary_expr_00430 <= (others => '0');
      else
        if action_method = action_method_S_0009 then
          unary_expr_00430 <= tmp_0568;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        action_b_0431 <= (others => '0');
      else
        if action_method = action_method_S_0013 then
          action_b_0431 <= array_access_00432;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        array_access_00432 <= (others => '0');
      else
        if action_method = action_method_S_0012 and action_method_delay = 2 then
          array_access_00432 <= class_buffer_0088_dout_b;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00433 <= '0';
      else
        if action_method = action_method_S_0020_wait then
          method_result_00433 <= class_misc_0094_isHex_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00434 <= '0';
      else
        if action_method = action_method_S_0030_wait then
          method_result_00434 <= class_misc_0094_isHex_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00435 <= '0';
      else
        if action_method = action_method_S_0040 then
          binary_expr_00435 <= tmp_0569;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00436 <= '0';
      else
        if action_method = action_method_S_0049 then
          binary_expr_00436 <= tmp_0570;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00437 <= '0';
      else
        if action_method = action_method_S_0058 then
          binary_expr_00437 <= tmp_0571;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        action_v_0439 <= (others => '0');
      else
        if action_method = action_method_S_0072 then
          action_v_0439 <= method_result_00440;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00440 <= (others => '0');
      else
        if action_method = action_method_S_0071_wait then
          method_result_00440 <= class_misc_0094_toHex2_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_port_0441 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0001 then
          tcp_server_port_0441 <= tcp_server_port_local;
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
        if test_method = test_method_S_0012_body and test_method_delay = 0 then
          tcp_server_port_local <= X"00000000";
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00443 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0002 then
          binary_expr_00443 <= tmp_0637;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00444 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0002 then
          binary_expr_00444 <= tmp_0638;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_v_0445 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0006 then
          tcp_server_v_0445 <= method_result_00446;
        elsif tcp_server_method = tcp_server_method_S_0014 then
          tcp_server_v_0445 <= method_result_00451;
        elsif tcp_server_method = tcp_server_method_S_0017 then
          tcp_server_v_0445 <= method_result_00452;
        elsif tcp_server_method = tcp_server_method_S_0025 then
          tcp_server_v_0445 <= method_result_00457;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00446 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0005_wait then
          method_result_00446 <= tcp_server_open_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00447 <= '0';
      else
        if tcp_server_method = tcp_server_method_S_0007 then
          binary_expr_00447 <= tmp_0639;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00452 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0016_wait then
          method_result_00452 <= tcp_server_listen_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00453 <= '0';
      else
        if tcp_server_method = tcp_server_method_S_0018 then
          binary_expr_00453 <= tmp_0642;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00459 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0030_wait then
          method_result_00459 <= read_data_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00460 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0028 then
          binary_expr_00460 <= tmp_0645;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00461 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0028 then
          binary_expr_00461 <= tmp_0646;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00449 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0010 then
          binary_expr_00449 <= tmp_0640;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00450 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0010 then
          binary_expr_00450 <= tmp_0641;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00451 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0013_wait then
          method_result_00451 <= tcp_server_open_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00455 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0021 then
          binary_expr_00455 <= tmp_0643;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00456 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0021 then
          binary_expr_00456 <= tmp_0644;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00457 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0024_wait then
          method_result_00457 <= tcp_server_listen_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        tcp_server_len_0462 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0034 then
          tcp_server_len_0462 <= method_result_00463;
        elsif tcp_server_method = tcp_server_method_S_0041 then
          tcp_server_len_0462 <= method_result_00465;
        elsif tcp_server_method = tcp_server_method_S_0044 then
          tcp_server_len_0462 <= method_result_00467;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00463 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0033_wait then
          method_result_00463 <= wait_for_recv_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00464 <= '0';
      else
        if tcp_server_method = tcp_server_method_S_0034 then
          binary_expr_00464 <= tmp_0647;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00465 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0040_wait then
          method_result_00465 <= pull_recv_data_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00467 <= (others => '0');
      else
        if tcp_server_method = tcp_server_method_S_0043_wait then
          method_result_00467 <= ready_contents_return;
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
          wait_cycles_busy <= tmp_0009;
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
          write_data_busy <= tmp_0021;
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
        elsif push_send_data_method = push_send_data_method_S_0009_body then
          write_data_req_local <= '1';
        elsif push_send_data_method = push_send_data_method_S_0014_body then
          write_data_req_local <= '1';
        elsif push_send_data_method = push_send_data_method_S_0035_body then
          write_data_req_local <= '1';
        elsif push_send_data_method = push_send_data_method_S_0042_body then
          write_data_req_local <= '1';
        elsif push_send_data_method = push_send_data_method_S_0046_body then
          write_data_req_local <= '1';
        elsif push_send_data_method = push_send_data_method_S_0051_body then
          write_data_req_local <= '1';
        elsif push_send_data_method = push_send_data_method_S_0056_body then
          write_data_req_local <= '1';
        elsif push_send_data_method = push_send_data_method_S_0061_body then
          write_data_req_local <= '1';
        elsif push_send_data_method = push_send_data_method_S_0064_body then
          write_data_req_local <= '1';
        elsif tcp_server_method = tcp_server_method_S_0004_body then
          write_data_req_local <= '1';
        elsif tcp_server_method = tcp_server_method_S_0012_body then
          write_data_req_local <= '1';
        elsif tcp_server_method = tcp_server_method_S_0023_body then
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
          read_data_return <= read_data_v_0116;
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
          read_data_busy <= tmp_0033;
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
        elsif tcp_server_method = tcp_server_method_S_0030_body then
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
          init_busy <= tmp_0045;
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
          network_configuration_busy <= tmp_0057;
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
          tcp_server_open_return <= method_result_00161;
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
          tcp_server_open_busy <= tmp_0137;
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
          tcp_server_listen_return <= method_result_00168;
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
          tcp_server_listen_busy <= tmp_0162;
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
        if tcp_server_method = tcp_server_method_S_0016_body then
          tcp_server_listen_req_local <= '1';
        elsif tcp_server_method = tcp_server_method_S_0024_body then
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
          wait_for_established_busy <= tmp_0178;
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
        if tcp_server_method = tcp_server_method_S_0027_body then
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
          wait_for_recv_return <= wait_for_recv_v_0178;
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
          wait_for_recv_busy <= tmp_0193;
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
        if tcp_server_method = tcp_server_method_S_0033_body then
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
          pull_recv_data_return <= pull_recv_data_actual_len_0222;
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
          pull_recv_data_busy <= tmp_0251;
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
        if tcp_server_method = tcp_server_method_S_0040_body then
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
          push_send_data_busy <= tmp_0307;
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
        if tcp_server_method = tcp_server_method_S_0045_body then
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
        pack_return <= (others => '0');
      else
        if pack_method = pack_method_S_0016 then
          pack_return <= binary_expr_00320;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pack_busy <= '0';
      else
        if pack_method = pack_method_S_0000 then
          pack_busy <= '0';
        elsif pack_method = pack_method_S_0001 then
          pack_busy <= tmp_0386;
        end if;
      end if;
    end if;
  end process;

  pack_req_flag <= pack_req_local;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        pack_req_local <= '0';
      else
        if init_contents_method = init_contents_method_S_0003_body then
          pack_req_local <= '1';
        elsif init_contents_method = init_contents_method_S_0006_body then
          pack_req_local <= '1';
        elsif init_contents_method = init_contents_method_S_0009_body then
          pack_req_local <= '1';
        elsif init_contents_method = init_contents_method_S_0012_body then
          pack_req_local <= '1';
        elsif init_contents_method = init_contents_method_S_0015_body then
          pack_req_local <= '1';
        elsif init_contents_method = init_contents_method_S_0018_body then
          pack_req_local <= '1';
        elsif init_contents_method = init_contents_method_S_0021_body then
          pack_req_local <= '1';
        elsif init_contents_method = init_contents_method_S_0024_body then
          pack_req_local <= '1';
        elsif init_contents_method = init_contents_method_S_0027_body then
          pack_req_local <= '1';
        elsif init_contents_method = init_contents_method_S_0030_body then
          pack_req_local <= '1';
        else
          pack_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        init_contents_busy <= '0';
      else
        if init_contents_method = init_contents_method_S_0000 then
          init_contents_busy <= '0';
        elsif init_contents_method = init_contents_method_S_0001 then
          init_contents_busy <= tmp_0408;
        end if;
      end if;
    end if;
  end process;

  init_contents_req_flag <= init_contents_req_local;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        init_contents_req_local <= '0';
      else
        if test_method = test_method_S_0007_body then
          init_contents_req_local <= '1';
        else
          init_contents_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        ready_contents_return <= (others => '0');
      else
        if ready_contents_method = ready_contents_method_S_0110 then
          ready_contents_return <= binary_expr_00423;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        ready_contents_busy <= '0';
      else
        if ready_contents_method = ready_contents_method_S_0000 then
          ready_contents_busy <= '0';
        elsif ready_contents_method = ready_contents_method_S_0001 then
          ready_contents_busy <= tmp_0461;
        end if;
      end if;
    end if;
  end process;

  ready_contents_req_flag <= ready_contents_req_local;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        ready_contents_req_local <= '0';
      else
        if tcp_server_method = tcp_server_method_S_0043_body then
          ready_contents_req_local <= '1';
        else
          ready_contents_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        action_busy <= '0';
      else
        if action_method = action_method_S_0000 then
          action_busy <= '0';
        elsif action_method = action_method_S_0001 then
          action_busy <= tmp_0530;
        end if;
      end if;
    end if;
  end process;

  action_req_flag <= action_req_local;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        action_req_local <= '0';
      else
        if tcp_server_method = tcp_server_method_S_0042_body then
          action_req_local <= '1';
        else
          action_req_local <= '0';
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
          tcp_server_busy <= tmp_0576;
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
        if test_method = test_method_S_0012_body then
          tcp_server_req_local <= '1';
        else
          tcp_server_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  test_req_flag <= tmp_0004;

  blink_led_req_flag <= tmp_0005;

  wait_cycles_req_flag_edge <= tmp_0007;

  write_data_req_flag_edge <= tmp_0019;

  wait_cycles_call_flag_0010 <= tmp_0025;

  read_data_req_flag_edge <= tmp_0031;

  wait_cycles_call_flag_0008 <= tmp_0037;

  init_req_flag_edge <= tmp_0043;

  wait_cycles_call_flag_0013 <= tmp_0049;

  network_configuration_req_flag_edge <= tmp_0055;

  write_data_call_flag_0002 <= tmp_0061;

  write_data_call_flag_0003 <= tmp_0065;

  write_data_call_flag_0004 <= tmp_0069;

  write_data_call_flag_0005 <= tmp_0073;

  write_data_call_flag_0006 <= tmp_0077;

  write_data_call_flag_0007 <= tmp_0081;

  write_data_call_flag_0008 <= tmp_0085;

  write_data_call_flag_0009 <= tmp_0089;

  write_data_call_flag_0010 <= tmp_0093;

  write_data_call_flag_0011 <= tmp_0097;

  write_data_call_flag_0012 <= tmp_0101;

  write_data_call_flag_0013 <= tmp_0105;

  write_data_call_flag_0014 <= tmp_0109;

  write_data_call_flag_0015 <= tmp_0113;

  write_data_call_flag_0016 <= tmp_0117;

  write_data_call_flag_0017 <= tmp_0121;

  write_data_call_flag_0018 <= tmp_0125;

  write_data_call_flag_0019 <= tmp_0129;

  tcp_server_open_req_flag_edge <= tmp_0135;

  read_data_call_flag_0019 <= tmp_0141;

  tcp_server_listen_req_flag_edge <= tmp_0160;

  read_data_call_flag_0007 <= tmp_0166;

  wait_for_established_req_flag_edge <= tmp_0176;

  wait_for_recv_req_flag_edge <= tmp_0191;

  read_data_call_flag_0008 <= tmp_0199;

  read_data_call_flag_0013 <= tmp_0203;

  read_data_call_flag_0018 <= tmp_0207;

  read_data_call_flag_0033 <= tmp_0213;

  write_data_call_flag_0045 <= tmp_0219;

  pull_recv_data_req_flag_edge <= tmp_0249;

  read_data_call_flag_0004 <= tmp_0255;

  read_data_call_flag_0009 <= tmp_0259;

  read_data_call_flag_0036 <= tmp_0267;

  read_data_call_flag_0043 <= tmp_0271;

  write_data_call_flag_0048 <= tmp_0275;

  push_send_data_req_flag_edge <= tmp_0305;

  write_data_call_flag_0035 <= tmp_0315;

  write_data_call_flag_0042 <= tmp_0319;

  write_data_call_flag_0046 <= tmp_0323;

  write_data_call_flag_0051 <= tmp_0327;

  write_data_call_flag_0056 <= tmp_0331;

  write_data_call_flag_0061 <= tmp_0335;

  write_data_call_flag_0064 <= tmp_0339;

  pack_req_flag_edge <= tmp_0384;

  init_contents_req_flag_edge <= tmp_0406;

  pack_call_flag_0003 <= tmp_0412;

  pack_call_flag_0006 <= tmp_0416;

  pack_call_flag_0009 <= tmp_0420;

  pack_call_flag_0012 <= tmp_0424;

  pack_call_flag_0015 <= tmp_0428;

  pack_call_flag_0018 <= tmp_0432;

  pack_call_flag_0021 <= tmp_0436;

  pack_call_flag_0024 <= tmp_0440;

  pack_call_flag_0027 <= tmp_0444;

  pack_call_flag_0030 <= tmp_0448;

  i_to_4digit_ascii_ext_call_flag_0034 <= tmp_0452;

  ready_contents_req_flag_edge <= tmp_0459;

  action_req_flag_edge <= tmp_0528;

  isHex_ext_call_flag_0020 <= tmp_0542;

  isHex_ext_call_flag_0030 <= tmp_0548;

  toHex2_ext_call_flag_0071 <= tmp_0562;

  tcp_server_req_flag_edge <= tmp_0574;

  tcp_server_open_call_flag_0005 <= tmp_0580;

  tcp_server_open_call_flag_0013 <= tmp_0586;

  tcp_server_listen_call_flag_0016 <= tmp_0590;

  write_data_call_flag_0023 <= tmp_0596;

  tcp_server_listen_call_flag_0024 <= tmp_0600;

  wait_for_established_call_flag_0027 <= tmp_0604;

  read_data_call_flag_0030 <= tmp_0608;

  wait_for_recv_call_flag_0033 <= tmp_0614;

  pull_recv_data_call_flag_0040 <= tmp_0620;

  action_call_flag_0042 <= tmp_0624;

  ready_contents_call_flag_0043 <= tmp_0628;

  push_send_data_call_flag_0045 <= tmp_0632;

  test_req_flag_edge <= tmp_0649;

  init_call_flag_0003 <= tmp_0655;

  network_configuration_call_flag_0005 <= tmp_0659;

  init_contents_call_flag_0007 <= tmp_0663;

  tcp_server_call_flag_0012 <= tmp_0669;

  blink_led_req_flag_edge <= tmp_0675;


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

  inst_class_resp_0089 : http_response_header
  port map(
    clk => class_resp_0089_clk,
    reset => class_resp_0089_reset,
    data_length => class_resp_0089_data_length,
    data_address => class_resp_0089_data_address,
    data_din => class_resp_0089_data_din,
    data_dout => class_resp_0089_data_dout,
    data_we => class_resp_0089_data_we,
    data_oe => class_resp_0089_data_oe,
    length => class_resp_0089_length
  );

  inst_class_data_0091 : singleportram
  generic map(
    WIDTH => 32,
    DEPTH => 10,
    WORDS => 1024
  )
  port map(
    clk => class_data_0091_clk,
    reset => class_data_0091_reset,
    length => class_data_0091_length,
    address_b => class_data_0091_address_b,
    din_b => class_data_0091_din_b,
    dout_b => class_data_0091_dout_b,
    we_b => class_data_0091_we_b,
    oe_b => class_data_0091_oe_b
  );

  inst_class_misc_0094 : Misc
  port map(
    clk => class_misc_0094_clk,
    reset => class_misc_0094_reset,
    i_to_4digit_ascii_x => class_misc_0094_i_to_4digit_ascii_x,
    isHex_v => class_misc_0094_isHex_v,
    toHex1_v => class_misc_0094_toHex1_v,
    toHex2_v0 => class_misc_0094_toHex2_v0,
    toHex2_v1 => class_misc_0094_toHex2_v1,
    i_to_4digit_ascii_return => class_misc_0094_i_to_4digit_ascii_return,
    i_to_4digit_ascii_busy => class_misc_0094_i_to_4digit_ascii_busy,
    i_to_4digit_ascii_req => class_misc_0094_i_to_4digit_ascii_req,
    isHex_return => class_misc_0094_isHex_return,
    isHex_busy => class_misc_0094_isHex_busy,
    isHex_req => class_misc_0094_isHex_req,
    toHex1_return => class_misc_0094_toHex1_return,
    toHex1_busy => class_misc_0094_toHex1_busy,
    toHex1_req => class_misc_0094_toHex1_req,
    toHex2_return => class_misc_0094_toHex2_return,
    toHex2_busy => class_misc_0094_toHex2_busy,
    toHex2_req => class_misc_0094_toHex2_req
  );


end RTL;
