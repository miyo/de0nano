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
  signal led : signed(32-1 downto 0) := (others => '0');
  signal wait_cycles_i_1 : signed(32-1 downto 0) := X"00000000";
  signal blink_led_i_0 : signed(32-1 downto 0) := X"00000000";
  signal tmp_0001 : signed(32-1 downto 0);
  type Type_methodId is (
    IDLE,
    method_wait_cycles,
    method_write_data,
    method_read_data,
    method_init,
    method_test,
    method_blink_led  
  );
  signal methodId : Type_methodId := IDLE;
  signal wait_cycles_n : signed(32-1 downto 0) := (others => '0');
  signal wait_cycles_req_local : std_logic := '0';
  signal tmp_0002 : std_logic;
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
  signal tmp_0003 : std_logic;
  signal tmp_0004 : std_logic;
  signal tmp_0005 : std_logic;
  signal tmp_0006 : std_logic;
  signal tmp_0007 : std_logic;
  signal tmp_0008 : std_logic;
  signal tmp_0009 : signed(32-1 downto 0);
  signal tmp_0010 : signed(32-1 downto 0);
  signal write_data_addr : signed(32-1 downto 0) := (others => '0');
  signal write_data_data : signed(8-1 downto 0) := (others => '0');
  signal write_data_req_local : std_logic := '0';
  signal tmp_0011 : std_logic;
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
  signal tmp_0012 : std_logic;
  signal tmp_0013 : std_logic;
  signal tmp_0014 : std_logic;
  signal tmp_0015 : std_logic;
  signal tmp_0016 : signed(32-1 downto 0);
  signal wait_cycles_busy_sig_0017 : std_logic;
  signal tmp_0018 : std_logic;
  signal tmp_0019 : std_logic;
  signal tmp_0020 : std_logic;
  signal tmp_0021 : std_logic;
  signal tmp_0022 : std_logic;
  signal tmp_0023 : std_logic;
  signal read_data_addr : signed(32-1 downto 0) := (others => '0');
  signal read_data_return_sig : signed(8-1 downto 0) := (others => '0');
  signal read_data_req_local : std_logic := '0';
  signal tmp_0024 : std_logic;
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
  signal tmp_0025 : std_logic;
  signal tmp_0026 : std_logic;
  signal tmp_0027 : std_logic;
  signal tmp_0028 : std_logic;
  signal tmp_0029 : signed(32-1 downto 0);
  signal wait_cycles_busy_sig_0030 : std_logic;
  signal tmp_0031 : std_logic;
  signal tmp_0032 : std_logic;
  signal tmp_0033 : std_logic;
  signal tmp_0034 : std_logic;
  signal tmp_0035 : std_logic;
  signal tmp_0036 : std_logic;
  signal init_req_local : std_logic := '0';
  signal tmp_0037 : std_logic;
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
  signal tmp_0038 : std_logic;
  signal tmp_0039 : std_logic;
  signal tmp_0040 : std_logic;
  signal tmp_0041 : std_logic;
  signal tmp_0042 : std_logic;
  signal tmp_0043 : std_logic;
  signal tmp_0044 : signed(32-1 downto 0);
  signal wait_cycles_busy_sig_0045 : std_logic;
  signal tmp_0046 : std_logic;
  signal tmp_0047 : std_logic;
  signal tmp_0048 : std_logic;
  signal tmp_0049 : std_logic;
  signal tmp_0050 : std_logic;
  signal tmp_0051 : signed(32-1 downto 0);
  signal wait_cycles_busy_sig_0052 : std_logic;
  signal tmp_0053 : std_logic;
  signal tmp_0054 : std_logic;
  signal tmp_0055 : std_logic;
  signal tmp_0056 : std_logic;
  signal test_req_local : std_logic := '0';
  signal tmp_0057 : std_logic;
  type Type_S_test is (
    S_test_IDLE,
    S_test_S_test_0001,
    S_test_S_test_0002,
    S_test_S_test_0003,
    S_test_S_test_0004,
    S_test_S_test_0005,
    S_test_S_test_0006,
    S_test_S_test_0007,
    S_test_S_test_0008,
    S_test_S_test_0009,
    S_test_S_test_0010,
    S_test_S_test_0011,
    S_test_S_test_0012,
    S_test_S_test_0013,
    S_test_S_test_0014,
    S_test_S_test_0015,
    S_test_S_test_0016,
    S_test_S_test_0017,
    S_test_S_test_0018,
    S_test_S_test_0019,
    S_test_S_test_0020,
    S_test_S_test_0021  
  );
  signal S_test : Type_S_test := S_test_IDLE;
  signal S_test_delay : signed(32-1 downto 0) := (others => '0');
  signal tmp_0058 : std_logic;
  signal tmp_0059 : std_logic;
  signal tmp_0060 : std_logic;
  signal tmp_0061 : std_logic;
  signal tmp_0062 : std_logic;
  signal tmp_0063 : std_logic;
  signal init_busy_sig_0064 : std_logic;
  signal tmp_0065 : std_logic;
  signal tmp_0066 : std_logic;
  signal tmp_0067 : std_logic;
  signal tmp_0068 : std_logic;
  signal tmp_0069 : signed(32-1 downto 0);
  signal tmp_0070 : signed(32-1 downto 0);
  signal tmp_0071 : signed(8-1 downto 0);
  signal write_data_busy_sig_0072 : std_logic;
  signal tmp_0073 : std_logic;
  signal tmp_0074 : std_logic;
  signal tmp_0075 : std_logic;
  signal tmp_0076 : std_logic;
  signal tmp_0077 : signed(32-1 downto 0);
  signal tmp_0078 : signed(32-1 downto 0);
  signal tmp_0079 : signed(8-1 downto 0);
  signal write_data_busy_sig_0080 : std_logic;
  signal tmp_0081 : std_logic;
  signal tmp_0082 : std_logic;
  signal tmp_0083 : std_logic;
  signal tmp_0084 : std_logic;
  signal tmp_0085 : signed(32-1 downto 0);
  signal tmp_0086 : signed(32-1 downto 0);
  signal tmp_0087 : signed(8-1 downto 0);
  signal write_data_busy_sig_0088 : std_logic;
  signal tmp_0089 : std_logic;
  signal tmp_0090 : std_logic;
  signal tmp_0091 : std_logic;
  signal tmp_0092 : std_logic;
  signal tmp_0093 : signed(32-1 downto 0);
  signal tmp_0094 : signed(32-1 downto 0);
  signal tmp_0095 : signed(8-1 downto 0);
  signal write_data_busy_sig_0096 : std_logic;
  signal tmp_0097 : std_logic;
  signal tmp_0098 : std_logic;
  signal tmp_0099 : std_logic;
  signal tmp_0100 : std_logic;
  signal tmp_0101 : signed(32-1 downto 0);
  signal tmp_0102 : signed(32-1 downto 0);
  signal tmp_0103 : signed(8-1 downto 0);
  signal write_data_busy_sig_0104 : std_logic;
  signal tmp_0105 : std_logic;
  signal tmp_0106 : std_logic;
  signal tmp_0107 : std_logic;
  signal tmp_0108 : std_logic;
  signal tmp_0109 : signed(32-1 downto 0);
  signal tmp_0110 : signed(32-1 downto 0);
  signal tmp_0111 : signed(8-1 downto 0);
  signal write_data_busy_sig_0112 : std_logic;
  signal tmp_0113 : std_logic;
  signal tmp_0114 : std_logic;
  signal tmp_0115 : std_logic;
  signal tmp_0116 : std_logic;
  signal tmp_0117 : signed(32-1 downto 0);
  signal tmp_0118 : signed(32-1 downto 0);
  signal tmp_0119 : signed(8-1 downto 0);
  signal write_data_busy_sig_0120 : std_logic;
  signal tmp_0121 : std_logic;
  signal tmp_0122 : std_logic;
  signal tmp_0123 : std_logic;
  signal tmp_0124 : std_logic;
  signal tmp_0125 : signed(32-1 downto 0);
  signal tmp_0126 : signed(32-1 downto 0);
  signal tmp_0127 : signed(8-1 downto 0);
  signal write_data_busy_sig_0128 : std_logic;
  signal tmp_0129 : std_logic;
  signal tmp_0130 : std_logic;
  signal tmp_0131 : std_logic;
  signal tmp_0132 : std_logic;
  signal tmp_0133 : signed(32-1 downto 0);
  signal tmp_0134 : signed(32-1 downto 0);
  signal tmp_0135 : signed(8-1 downto 0);
  signal write_data_busy_sig_0136 : std_logic;
  signal tmp_0137 : std_logic;
  signal tmp_0138 : std_logic;
  signal tmp_0139 : std_logic;
  signal tmp_0140 : std_logic;
  signal tmp_0141 : signed(32-1 downto 0);
  signal tmp_0142 : signed(32-1 downto 0);
  signal tmp_0143 : signed(8-1 downto 0);
  signal write_data_busy_sig_0144 : std_logic;
  signal tmp_0145 : std_logic;
  signal tmp_0146 : std_logic;
  signal tmp_0147 : std_logic;
  signal tmp_0148 : std_logic;
  signal tmp_0149 : signed(32-1 downto 0);
  signal tmp_0150 : signed(32-1 downto 0);
  signal tmp_0151 : signed(8-1 downto 0);
  signal write_data_busy_sig_0152 : std_logic;
  signal tmp_0153 : std_logic;
  signal tmp_0154 : std_logic;
  signal tmp_0155 : std_logic;
  signal tmp_0156 : std_logic;
  signal tmp_0157 : signed(32-1 downto 0);
  signal tmp_0158 : signed(32-1 downto 0);
  signal tmp_0159 : signed(8-1 downto 0);
  signal write_data_busy_sig_0160 : std_logic;
  signal tmp_0161 : std_logic;
  signal tmp_0162 : std_logic;
  signal tmp_0163 : std_logic;
  signal tmp_0164 : std_logic;
  signal tmp_0165 : signed(32-1 downto 0);
  signal tmp_0166 : signed(32-1 downto 0);
  signal tmp_0167 : signed(8-1 downto 0);
  signal write_data_busy_sig_0168 : std_logic;
  signal tmp_0169 : std_logic;
  signal tmp_0170 : std_logic;
  signal tmp_0171 : std_logic;
  signal tmp_0172 : std_logic;
  signal tmp_0173 : signed(32-1 downto 0);
  signal tmp_0174 : signed(32-1 downto 0);
  signal tmp_0175 : signed(8-1 downto 0);
  signal write_data_busy_sig_0176 : std_logic;
  signal tmp_0177 : std_logic;
  signal tmp_0178 : std_logic;
  signal tmp_0179 : std_logic;
  signal tmp_0180 : std_logic;
  signal tmp_0181 : signed(32-1 downto 0);
  signal tmp_0182 : signed(32-1 downto 0);
  signal tmp_0183 : signed(8-1 downto 0);
  signal write_data_busy_sig_0184 : std_logic;
  signal tmp_0185 : std_logic;
  signal tmp_0186 : std_logic;
  signal tmp_0187 : std_logic;
  signal tmp_0188 : std_logic;
  signal tmp_0189 : signed(32-1 downto 0);
  signal tmp_0190 : signed(32-1 downto 0);
  signal tmp_0191 : signed(8-1 downto 0);
  signal write_data_busy_sig_0192 : std_logic;
  signal tmp_0193 : std_logic;
  signal tmp_0194 : std_logic;
  signal tmp_0195 : std_logic;
  signal tmp_0196 : std_logic;
  signal tmp_0197 : signed(32-1 downto 0);
  signal tmp_0198 : signed(32-1 downto 0);
  signal tmp_0199 : signed(8-1 downto 0);
  signal write_data_busy_sig_0200 : std_logic;
  signal tmp_0201 : std_logic;
  signal tmp_0202 : std_logic;
  signal tmp_0203 : std_logic;
  signal tmp_0204 : std_logic;
  signal tmp_0205 : signed(32-1 downto 0);
  signal tmp_0206 : signed(32-1 downto 0);
  signal tmp_0207 : signed(8-1 downto 0);
  signal write_data_busy_sig_0208 : std_logic;
  signal tmp_0209 : std_logic;
  signal tmp_0210 : std_logic;
  signal tmp_0211 : std_logic;
  signal tmp_0212 : std_logic;
  signal blink_led_req_local : std_logic := '0';
  signal tmp_0213 : std_logic;
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
  signal tmp_0214 : std_logic;
  signal tmp_0215 : std_logic;
  signal tmp_0216 : std_logic;
  signal tmp_0217 : std_logic;
  signal tmp_0218 : signed(32-1 downto 0);
  signal tmp_0219 : std_logic;
  signal tmp_0220 : std_logic;
  signal tmp_0221 : signed(32-1 downto 0);
  signal tmp_0222 : std_logic;
  signal tmp_0223 : std_logic;
  signal tmp_0224 : signed(32-1 downto 0);
  signal tmp_0225 : std_logic;
  signal tmp_0226 : std_logic;
  signal tmp_0227 : signed(32-1 downto 0);
  signal tmp_0228 : std_logic;
  signal tmp_0229 : std_logic;
  signal tmp_0230 : std_logic;
  signal tmp_0231 : std_logic;
  signal tmp_0232 : signed(32-1 downto 0);
  signal tmp_0233 : signed(32-1 downto 0);
  signal tmp_0234 : signed(32-1 downto 0);
  signal tmp_0235 : signed(32-1 downto 0);

begin

  clk_sig <= clk;
  reset_sig <= reset;
  field_led_output <= field_led_output_sig;
  field_led_output_sig <= led;

  field_led_input_sig <= field_led_input;
  field_led_input_we_sig <= field_led_input_we;
  test_req_sig <= test_req;
  test_busy <= test_busy_sig;
  test_busy_sig <= tmp_0063;

  blink_led_req_sig <= blink_led_req;
  blink_led_busy <= blink_led_busy_sig;
  blink_led_busy_sig <= tmp_0231;


  -- expressions
  tmp_0001 <= field_led_input_sig when field_led_input_we_sig = '1' else led;
  tmp_0002 <= '1' when wait_cycles_req_local = '1' else '0';
  tmp_0003 <= '1' when wait_cycles_i_1 < wait_cycles_n else '0';
  tmp_0004 <= '1' when tmp_0003 = '0' else '0';
  tmp_0005 <= '1' when wait_cycles_i_1 < wait_cycles_n else '0';
  tmp_0006 <= '1' when tmp_0005 = '1' else '0';
  tmp_0007 <= '1' when S_wait_cycles = S_wait_cycles_IDLE else '0';
  tmp_0008 <= '0' when tmp_0007 = '1' else '1';
  tmp_0009 <= X"00000000";
  tmp_0010 <= wait_cycles_i_1 + 1;
  tmp_0011 <= '1' when write_data_req_local = '1' else '0';
  tmp_0012 <= '1' when S_write_data = S_write_data_IDLE else '0';
  tmp_0013 <= '0' when tmp_0012 = '1' else '1';
  tmp_0014 <= '1';
  tmp_0015 <= '1';
  tmp_0016 <= X"00000003";
  tmp_0018 <= '1' when wait_cycles_busy_sig = '0' else '0';
  tmp_0019 <= '1' when wait_cycles_req_local = '0' else '0';
  tmp_0020 <= tmp_0018 and tmp_0019;
  tmp_0021 <= '1' when tmp_0020 = '1' else '0';
  tmp_0022 <= '0';
  tmp_0023 <= '0';
  tmp_0024 <= '1' when read_data_req_local = '1' else '0';
  tmp_0025 <= '1' when S_read_data = S_read_data_IDLE else '0';
  tmp_0026 <= '0' when tmp_0025 = '1' else '1';
  tmp_0027 <= '1';
  tmp_0028 <= '1';
  tmp_0029 <= X"00000003";
  tmp_0031 <= '1' when wait_cycles_busy_sig = '0' else '0';
  tmp_0032 <= '1' when wait_cycles_req_local = '0' else '0';
  tmp_0033 <= tmp_0031 and tmp_0032;
  tmp_0034 <= '1' when tmp_0033 = '1' else '0';
  tmp_0035 <= '0';
  tmp_0036 <= '0';
  tmp_0037 <= '1' when init_req_local = '1' else '0';
  tmp_0038 <= '1' when S_init = S_init_IDLE else '0';
  tmp_0039 <= '0' when tmp_0038 = '1' else '1';
  tmp_0040 <= '0';
  tmp_0041 <= '0';
  tmp_0042 <= '0';
  tmp_0043 <= '1';
  tmp_0044 <= X"000003e8";
  tmp_0046 <= '1' when wait_cycles_busy_sig = '0' else '0';
  tmp_0047 <= '1' when wait_cycles_req_local = '0' else '0';
  tmp_0048 <= tmp_0046 and tmp_0047;
  tmp_0049 <= '1' when tmp_0048 = '1' else '0';
  tmp_0050 <= '0';
  tmp_0051 <= X"000003e8";
  tmp_0053 <= '1' when wait_cycles_busy_sig = '0' else '0';
  tmp_0054 <= '1' when wait_cycles_req_local = '0' else '0';
  tmp_0055 <= tmp_0053 and tmp_0054;
  tmp_0056 <= '1' when tmp_0055 = '1' else '0';
  tmp_0057 <= test_req_sig or test_req_local;
  tmp_0058 <= '1';
  tmp_0059 <= '1' when tmp_0058 = '1' else '0';
  tmp_0060 <= '1';
  tmp_0061 <= '1' when tmp_0060 = '0' else '0';
  tmp_0062 <= '1' when S_test = S_test_IDLE else '0';
  tmp_0063 <= '0' when tmp_0062 = '1' else '1';
  tmp_0065 <= '1' when init_busy_sig = '0' else '0';
  tmp_0066 <= '1' when init_req_local = '0' else '0';
  tmp_0067 <= tmp_0065 and tmp_0066;
  tmp_0068 <= '1' when tmp_0067 = '1' else '0';
  tmp_0069 <= X"00000008";
  tmp_0070 <= X"00000000";
  tmp_0071 <= tmp_0070(32 - 24 - 1 downto 0);
  tmp_0073 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0074 <= '1' when write_data_req_local = '0' else '0';
  tmp_0075 <= tmp_0073 and tmp_0074;
  tmp_0076 <= '1' when tmp_0075 = '1' else '0';
  tmp_0077 <= X"00000009";
  tmp_0078 <= X"00000008";
  tmp_0079 <= tmp_0078(32 - 24 - 1 downto 0);
  tmp_0081 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0082 <= '1' when write_data_req_local = '0' else '0';
  tmp_0083 <= tmp_0081 and tmp_0082;
  tmp_0084 <= '1' when tmp_0083 = '1' else '0';
  tmp_0085 <= X"0000000a";
  tmp_0086 <= X"000000dc";
  tmp_0087 <= tmp_0086(32 - 24 - 1 downto 0);
  tmp_0089 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0090 <= '1' when write_data_req_local = '0' else '0';
  tmp_0091 <= tmp_0089 and tmp_0090;
  tmp_0092 <= '1' when tmp_0091 = '1' else '0';
  tmp_0093 <= X"0000000b";
  tmp_0094 <= X"00000001";
  tmp_0095 <= tmp_0094(32 - 24 - 1 downto 0);
  tmp_0097 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0098 <= '1' when write_data_req_local = '0' else '0';
  tmp_0099 <= tmp_0097 and tmp_0098;
  tmp_0100 <= '1' when tmp_0099 = '1' else '0';
  tmp_0101 <= X"0000000c";
  tmp_0102 <= X"00000002";
  tmp_0103 <= tmp_0102(32 - 24 - 1 downto 0);
  tmp_0105 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0106 <= '1' when write_data_req_local = '0' else '0';
  tmp_0107 <= tmp_0105 and tmp_0106;
  tmp_0108 <= '1' when tmp_0107 = '1' else '0';
  tmp_0109 <= X"0000000d";
  tmp_0110 <= X"00000003";
  tmp_0111 <= tmp_0110(32 - 24 - 1 downto 0);
  tmp_0113 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0114 <= '1' when write_data_req_local = '0' else '0';
  tmp_0115 <= tmp_0113 and tmp_0114;
  tmp_0116 <= '1' when tmp_0115 = '1' else '0';
  tmp_0117 <= X"00000010";
  tmp_0118 <= X"0000000a";
  tmp_0119 <= tmp_0118(32 - 24 - 1 downto 0);
  tmp_0121 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0122 <= '1' when write_data_req_local = '0' else '0';
  tmp_0123 <= tmp_0121 and tmp_0122;
  tmp_0124 <= '1' when tmp_0123 = '1' else '0';
  tmp_0125 <= X"00000011";
  tmp_0126 <= X"00000000";
  tmp_0127 <= tmp_0126(32 - 24 - 1 downto 0);
  tmp_0129 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0130 <= '1' when write_data_req_local = '0' else '0';
  tmp_0131 <= tmp_0129 and tmp_0130;
  tmp_0132 <= '1' when tmp_0131 = '1' else '0';
  tmp_0133 <= X"00000012";
  tmp_0134 <= X"00000000";
  tmp_0135 <= tmp_0134(32 - 24 - 1 downto 0);
  tmp_0137 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0138 <= '1' when write_data_req_local = '0' else '0';
  tmp_0139 <= tmp_0137 and tmp_0138;
  tmp_0140 <= '1' when tmp_0139 = '1' else '0';
  tmp_0141 <= X"00000013";
  tmp_0142 <= X"00000001";
  tmp_0143 <= tmp_0142(32 - 24 - 1 downto 0);
  tmp_0145 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0146 <= '1' when write_data_req_local = '0' else '0';
  tmp_0147 <= tmp_0145 and tmp_0146;
  tmp_0148 <= '1' when tmp_0147 = '1' else '0';
  tmp_0149 <= X"00000014";
  tmp_0150 <= X"000000ff";
  tmp_0151 <= tmp_0150(32 - 24 - 1 downto 0);
  tmp_0153 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0154 <= '1' when write_data_req_local = '0' else '0';
  tmp_0155 <= tmp_0153 and tmp_0154;
  tmp_0156 <= '1' when tmp_0155 = '1' else '0';
  tmp_0157 <= X"00000015";
  tmp_0158 <= X"00000000";
  tmp_0159 <= tmp_0158(32 - 24 - 1 downto 0);
  tmp_0161 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0162 <= '1' when write_data_req_local = '0' else '0';
  tmp_0163 <= tmp_0161 and tmp_0162;
  tmp_0164 <= '1' when tmp_0163 = '1' else '0';
  tmp_0165 <= X"00000016";
  tmp_0166 <= X"00000000";
  tmp_0167 <= tmp_0166(32 - 24 - 1 downto 0);
  tmp_0169 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0170 <= '1' when write_data_req_local = '0' else '0';
  tmp_0171 <= tmp_0169 and tmp_0170;
  tmp_0172 <= '1' when tmp_0171 = '1' else '0';
  tmp_0173 <= X"00000017";
  tmp_0174 <= X"00000000";
  tmp_0175 <= tmp_0174(32 - 24 - 1 downto 0);
  tmp_0177 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0178 <= '1' when write_data_req_local = '0' else '0';
  tmp_0179 <= tmp_0177 and tmp_0178;
  tmp_0180 <= '1' when tmp_0179 = '1' else '0';
  tmp_0181 <= X"00000018";
  tmp_0182 <= X"0000000a";
  tmp_0183 <= tmp_0182(32 - 24 - 1 downto 0);
  tmp_0185 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0186 <= '1' when write_data_req_local = '0' else '0';
  tmp_0187 <= tmp_0185 and tmp_0186;
  tmp_0188 <= '1' when tmp_0187 = '1' else '0';
  tmp_0189 <= X"00000019";
  tmp_0190 <= X"00000000";
  tmp_0191 <= tmp_0190(32 - 24 - 1 downto 0);
  tmp_0193 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0194 <= '1' when write_data_req_local = '0' else '0';
  tmp_0195 <= tmp_0193 and tmp_0194;
  tmp_0196 <= '1' when tmp_0195 = '1' else '0';
  tmp_0197 <= X"0000001a";
  tmp_0198 <= X"00000000";
  tmp_0199 <= tmp_0198(32 - 24 - 1 downto 0);
  tmp_0201 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0202 <= '1' when write_data_req_local = '0' else '0';
  tmp_0203 <= tmp_0201 and tmp_0202;
  tmp_0204 <= '1' when tmp_0203 = '1' else '0';
  tmp_0205 <= X"0000001b";
  tmp_0206 <= X"00000002";
  tmp_0207 <= tmp_0206(32 - 24 - 1 downto 0);
  tmp_0209 <= '1' when write_data_busy_sig = '0' else '0';
  tmp_0210 <= '1' when write_data_req_local = '0' else '0';
  tmp_0211 <= tmp_0209 and tmp_0210;
  tmp_0212 <= '1' when tmp_0211 = '1' else '0';
  tmp_0213 <= blink_led_req_sig or blink_led_req_local;
  tmp_0214 <= '1';
  tmp_0215 <= '1' when tmp_0214 = '1' else '0';
  tmp_0216 <= '1';
  tmp_0217 <= '1' when tmp_0216 = '0' else '0';
  tmp_0218 <= X"000f4240";
  tmp_0219 <= '1' when blink_led_i_0 < tmp_0218 else '0';
  tmp_0220 <= '1' when tmp_0219 = '0' else '0';
  tmp_0221 <= X"000f4240";
  tmp_0222 <= '1' when blink_led_i_0 < tmp_0221 else '0';
  tmp_0223 <= '1' when tmp_0222 = '1' else '0';
  tmp_0224 <= X"000000ff";
  tmp_0225 <= '1' when led = tmp_0224 else '0';
  tmp_0226 <= '1' when tmp_0225 = '1' else '0';
  tmp_0227 <= X"000000ff";
  tmp_0228 <= '1' when led = tmp_0227 else '0';
  tmp_0229 <= '1' when tmp_0228 = '0' else '0';
  tmp_0230 <= '1' when S_blink_led = S_blink_led_IDLE else '0';
  tmp_0231 <= '0' when tmp_0230 = '1' else '1';
  tmp_0232 <= X"00000000";
  tmp_0233 <= led + 1;
  tmp_0234 <= X"00000000";
  tmp_0235 <= blink_led_i_0 + 1;

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
            if tmp_0002 = '1' then
              S_wait_cycles <= S_wait_cycles_S_wait_cycles_0004;
            end if;
          when S_wait_cycles_S_wait_cycles_0001 => 
            S_wait_cycles <= S_wait_cycles_IDLE;
          when S_wait_cycles_S_wait_cycles_0002 => 
            if tmp_0004 = '1' then
              S_wait_cycles <= S_wait_cycles_S_wait_cycles_0001;
            elsif tmp_0006 = '1' then
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
            if tmp_0011 = '1' then
              S_write_data <= S_write_data_S_write_data_0008;
            end if;
          when S_write_data_S_write_data_0001 => 
            S_write_data <= S_write_data_IDLE;
          when S_write_data_S_write_data_0002 => 
            S_write_data <= S_write_data_S_write_data_0001;
          when S_write_data_S_write_data_0003 => 
            S_write_data <= S_write_data_S_write_data_0002;
          when S_write_data_S_write_data_0004 => 
            if S_write_data_delay >= 1 and wait_cycles_busy_sig_0017 = '1' then
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
            if tmp_0024 = '1' then
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
            if S_read_data_delay >= 1 and wait_cycles_busy_sig_0030 = '1' then
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
            if tmp_0037 = '1' then
              S_init <= S_init_S_init_0008;
            end if;
          when S_init_S_init_0001 => 
            S_init <= S_init_IDLE;
          when S_init_S_init_0002 => 
            if S_init_delay >= 1 and wait_cycles_busy_sig_0052 = '1' then
              S_init_delay <= (others => '0');
              S_init <= S_init_S_init_0001;
            else
              S_init_delay <= S_init_delay + 1;
            end if;
          when S_init_S_init_0003 => 
            S_init <= S_init_S_init_0002;
          when S_init_S_init_0004 => 
            if S_init_delay >= 1 and wait_cycles_busy_sig_0045 = '1' then
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
        S_test <= S_test_IDLE;
        S_test_delay <= (others => '0');
      else
        case (S_test) is
          when S_test_IDLE => 
            if tmp_0057 = '1' then
              S_test <= S_test_S_test_0021;
            end if;
          when S_test_S_test_0001 => 
            S_test <= S_test_IDLE;
          when S_test_S_test_0002 => 
            if tmp_0059 = '1' then
              S_test <= S_test_S_test_0002;
            elsif tmp_0061 = '1' then
              S_test <= S_test_S_test_0001;
            end if;
          when S_test_S_test_0003 => 
            if S_test_delay >= 1 and write_data_busy_sig_0208 = '1' then
              S_test_delay <= (others => '0');
              S_test <= S_test_S_test_0002;
            else
              S_test_delay <= S_test_delay + 1;
            end if;
          when S_test_S_test_0004 => 
            if S_test_delay >= 1 and write_data_busy_sig_0200 = '1' then
              S_test_delay <= (others => '0');
              S_test <= S_test_S_test_0003;
            else
              S_test_delay <= S_test_delay + 1;
            end if;
          when S_test_S_test_0005 => 
            if S_test_delay >= 1 and write_data_busy_sig_0192 = '1' then
              S_test_delay <= (others => '0');
              S_test <= S_test_S_test_0004;
            else
              S_test_delay <= S_test_delay + 1;
            end if;
          when S_test_S_test_0006 => 
            if S_test_delay >= 1 and write_data_busy_sig_0184 = '1' then
              S_test_delay <= (others => '0');
              S_test <= S_test_S_test_0005;
            else
              S_test_delay <= S_test_delay + 1;
            end if;
          when S_test_S_test_0007 => 
            if S_test_delay >= 1 and write_data_busy_sig_0176 = '1' then
              S_test_delay <= (others => '0');
              S_test <= S_test_S_test_0006;
            else
              S_test_delay <= S_test_delay + 1;
            end if;
          when S_test_S_test_0008 => 
            if S_test_delay >= 1 and write_data_busy_sig_0168 = '1' then
              S_test_delay <= (others => '0');
              S_test <= S_test_S_test_0007;
            else
              S_test_delay <= S_test_delay + 1;
            end if;
          when S_test_S_test_0009 => 
            if S_test_delay >= 1 and write_data_busy_sig_0160 = '1' then
              S_test_delay <= (others => '0');
              S_test <= S_test_S_test_0008;
            else
              S_test_delay <= S_test_delay + 1;
            end if;
          when S_test_S_test_0010 => 
            if S_test_delay >= 1 and write_data_busy_sig_0152 = '1' then
              S_test_delay <= (others => '0');
              S_test <= S_test_S_test_0009;
            else
              S_test_delay <= S_test_delay + 1;
            end if;
          when S_test_S_test_0011 => 
            if S_test_delay >= 1 and write_data_busy_sig_0144 = '1' then
              S_test_delay <= (others => '0');
              S_test <= S_test_S_test_0010;
            else
              S_test_delay <= S_test_delay + 1;
            end if;
          when S_test_S_test_0012 => 
            if S_test_delay >= 1 and write_data_busy_sig_0136 = '1' then
              S_test_delay <= (others => '0');
              S_test <= S_test_S_test_0011;
            else
              S_test_delay <= S_test_delay + 1;
            end if;
          when S_test_S_test_0013 => 
            if S_test_delay >= 1 and write_data_busy_sig_0128 = '1' then
              S_test_delay <= (others => '0');
              S_test <= S_test_S_test_0012;
            else
              S_test_delay <= S_test_delay + 1;
            end if;
          when S_test_S_test_0014 => 
            if S_test_delay >= 1 and write_data_busy_sig_0120 = '1' then
              S_test_delay <= (others => '0');
              S_test <= S_test_S_test_0013;
            else
              S_test_delay <= S_test_delay + 1;
            end if;
          when S_test_S_test_0015 => 
            if S_test_delay >= 1 and write_data_busy_sig_0112 = '1' then
              S_test_delay <= (others => '0');
              S_test <= S_test_S_test_0014;
            else
              S_test_delay <= S_test_delay + 1;
            end if;
          when S_test_S_test_0016 => 
            if S_test_delay >= 1 and write_data_busy_sig_0104 = '1' then
              S_test_delay <= (others => '0');
              S_test <= S_test_S_test_0015;
            else
              S_test_delay <= S_test_delay + 1;
            end if;
          when S_test_S_test_0017 => 
            if S_test_delay >= 1 and write_data_busy_sig_0096 = '1' then
              S_test_delay <= (others => '0');
              S_test <= S_test_S_test_0016;
            else
              S_test_delay <= S_test_delay + 1;
            end if;
          when S_test_S_test_0018 => 
            if S_test_delay >= 1 and write_data_busy_sig_0088 = '1' then
              S_test_delay <= (others => '0');
              S_test <= S_test_S_test_0017;
            else
              S_test_delay <= S_test_delay + 1;
            end if;
          when S_test_S_test_0019 => 
            if S_test_delay >= 1 and write_data_busy_sig_0080 = '1' then
              S_test_delay <= (others => '0');
              S_test <= S_test_S_test_0018;
            else
              S_test_delay <= S_test_delay + 1;
            end if;
          when S_test_S_test_0020 => 
            if S_test_delay >= 1 and write_data_busy_sig_0072 = '1' then
              S_test_delay <= (others => '0');
              S_test <= S_test_S_test_0019;
            else
              S_test_delay <= S_test_delay + 1;
            end if;
          when S_test_S_test_0021 => 
            if S_test_delay >= 1 and init_busy_sig_0064 = '1' then
              S_test_delay <= (others => '0');
              S_test <= S_test_S_test_0020;
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
            if tmp_0213 = '1' then
              S_blink_led <= S_blink_led_S_blink_led_0002;
            end if;
          when S_blink_led_S_blink_led_0001 => 
            S_blink_led <= S_blink_led_IDLE;
          when S_blink_led_S_blink_led_0002 => 
            if tmp_0215 = '1' then
              S_blink_led <= S_blink_led_S_blink_led_0007;
            elsif tmp_0217 = '1' then
              S_blink_led <= S_blink_led_S_blink_led_0001;
            end if;
          when S_blink_led_S_blink_led_0003 => 
            if tmp_0220 = '1' then
              S_blink_led <= S_blink_led_S_blink_led_0002;
            elsif tmp_0223 = '1' then
              S_blink_led <= S_blink_led_S_blink_led_0004;
            end if;
          when S_blink_led_S_blink_led_0004 => 
            S_blink_led <= S_blink_led_S_blink_led_0003;
          when S_blink_led_S_blink_led_0005 => 
            S_blink_led <= S_blink_led_S_blink_led_0003;
          when S_blink_led_S_blink_led_0006 => 
            S_blink_led <= S_blink_led_S_blink_led_0005;
          when S_blink_led_S_blink_led_0007 => 
            if tmp_0226 = '1' then
              S_blink_led <= S_blink_led_S_blink_led_0006;
            elsif tmp_0229 = '1' then
              S_blink_led <= S_blink_led_S_blink_led_0008;
            end if;
          when S_blink_led_S_blink_led_0008 => 
            S_blink_led <= S_blink_led_S_blink_led_0005;
          when others => null;
        end case;
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
          wiz830mj_cs <= tmp_0014;
        elsif S_write_data = S_write_data_S_write_data_0002 then
          wiz830mj_cs <= tmp_0023;
        elsif S_read_data = S_read_data_S_read_data_0008 then
          wiz830mj_cs <= tmp_0027;
        elsif S_read_data = S_read_data_S_read_data_0003 then
          wiz830mj_cs <= tmp_0036;
        elsif S_init = S_init_S_init_0008 then
          wiz830mj_cs <= tmp_0040;
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
          wiz830mj_oe <= tmp_0028;
        elsif S_read_data = S_read_data_S_read_data_0004 then
          wiz830mj_oe <= tmp_0035;
        elsif S_init = S_init_S_init_0006 then
          wiz830mj_oe <= tmp_0042;
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
          wiz830mj_we <= tmp_0015;
        elsif S_write_data = S_write_data_S_write_data_0003 then
          wiz830mj_we <= tmp_0022;
        elsif S_init = S_init_S_init_0007 then
          wiz830mj_we <= tmp_0041;
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
          wiz830mj_module_reset <= tmp_0043;
        elsif S_init = S_init_S_init_0003 then
          wiz830mj_module_reset <= tmp_0050;
        end if;
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
          led <= tmp_0232;
        elsif S_blink_led = S_blink_led_S_blink_led_0008 then
          led <= tmp_0233;
        else
          led <= tmp_0001;
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
          wait_cycles_i_1 <= tmp_0009;
        elsif S_wait_cycles = S_wait_cycles_S_wait_cycles_0003 then
          wait_cycles_i_1 <= tmp_0010;
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
          blink_led_i_0 <= tmp_0234;
        elsif S_blink_led = S_blink_led_S_blink_led_0004 then
          blink_led_i_0 <= tmp_0235;
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
          wait_cycles_n <= tmp_0016;
        elsif S_read_data = S_read_data_S_read_data_0006 and S_read_data_delay = 0 then
          wait_cycles_n <= tmp_0029;
        elsif S_init = S_init_S_init_0004 and S_init_delay = 0 then
          wait_cycles_n <= tmp_0044;
        elsif S_init = S_init_S_init_0002 and S_init_delay = 0 then
          wait_cycles_n <= tmp_0051;
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

  wait_cycles_busy_sig <= tmp_0008;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        write_data_addr <= (others => '0');
      else
        if S_test = S_test_S_test_0020 and S_test_delay = 0 then
          write_data_addr <= tmp_0069;
        elsif S_test = S_test_S_test_0019 and S_test_delay = 0 then
          write_data_addr <= tmp_0077;
        elsif S_test = S_test_S_test_0018 and S_test_delay = 0 then
          write_data_addr <= tmp_0085;
        elsif S_test = S_test_S_test_0017 and S_test_delay = 0 then
          write_data_addr <= tmp_0093;
        elsif S_test = S_test_S_test_0016 and S_test_delay = 0 then
          write_data_addr <= tmp_0101;
        elsif S_test = S_test_S_test_0015 and S_test_delay = 0 then
          write_data_addr <= tmp_0109;
        elsif S_test = S_test_S_test_0014 and S_test_delay = 0 then
          write_data_addr <= tmp_0117;
        elsif S_test = S_test_S_test_0013 and S_test_delay = 0 then
          write_data_addr <= tmp_0125;
        elsif S_test = S_test_S_test_0012 and S_test_delay = 0 then
          write_data_addr <= tmp_0133;
        elsif S_test = S_test_S_test_0011 and S_test_delay = 0 then
          write_data_addr <= tmp_0141;
        elsif S_test = S_test_S_test_0010 and S_test_delay = 0 then
          write_data_addr <= tmp_0149;
        elsif S_test = S_test_S_test_0009 and S_test_delay = 0 then
          write_data_addr <= tmp_0157;
        elsif S_test = S_test_S_test_0008 and S_test_delay = 0 then
          write_data_addr <= tmp_0165;
        elsif S_test = S_test_S_test_0007 and S_test_delay = 0 then
          write_data_addr <= tmp_0173;
        elsif S_test = S_test_S_test_0006 and S_test_delay = 0 then
          write_data_addr <= tmp_0181;
        elsif S_test = S_test_S_test_0005 and S_test_delay = 0 then
          write_data_addr <= tmp_0189;
        elsif S_test = S_test_S_test_0004 and S_test_delay = 0 then
          write_data_addr <= tmp_0197;
        elsif S_test = S_test_S_test_0003 and S_test_delay = 0 then
          write_data_addr <= tmp_0205;
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
        if S_test = S_test_S_test_0020 and S_test_delay = 0 then
          write_data_data <= tmp_0071;
        elsif S_test = S_test_S_test_0019 and S_test_delay = 0 then
          write_data_data <= tmp_0079;
        elsif S_test = S_test_S_test_0018 and S_test_delay = 0 then
          write_data_data <= tmp_0087;
        elsif S_test = S_test_S_test_0017 and S_test_delay = 0 then
          write_data_data <= tmp_0095;
        elsif S_test = S_test_S_test_0016 and S_test_delay = 0 then
          write_data_data <= tmp_0103;
        elsif S_test = S_test_S_test_0015 and S_test_delay = 0 then
          write_data_data <= tmp_0111;
        elsif S_test = S_test_S_test_0014 and S_test_delay = 0 then
          write_data_data <= tmp_0119;
        elsif S_test = S_test_S_test_0013 and S_test_delay = 0 then
          write_data_data <= tmp_0127;
        elsif S_test = S_test_S_test_0012 and S_test_delay = 0 then
          write_data_data <= tmp_0135;
        elsif S_test = S_test_S_test_0011 and S_test_delay = 0 then
          write_data_data <= tmp_0143;
        elsif S_test = S_test_S_test_0010 and S_test_delay = 0 then
          write_data_data <= tmp_0151;
        elsif S_test = S_test_S_test_0009 and S_test_delay = 0 then
          write_data_data <= tmp_0159;
        elsif S_test = S_test_S_test_0008 and S_test_delay = 0 then
          write_data_data <= tmp_0167;
        elsif S_test = S_test_S_test_0007 and S_test_delay = 0 then
          write_data_data <= tmp_0175;
        elsif S_test = S_test_S_test_0006 and S_test_delay = 0 then
          write_data_data <= tmp_0183;
        elsif S_test = S_test_S_test_0005 and S_test_delay = 0 then
          write_data_data <= tmp_0191;
        elsif S_test = S_test_S_test_0004 and S_test_delay = 0 then
          write_data_data <= tmp_0199;
        elsif S_test = S_test_S_test_0003 and S_test_delay = 0 then
          write_data_data <= tmp_0207;
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
        if S_test = S_test_S_test_0020 and S_test_delay = 0 then
          write_data_req_local <= '1';
        elsif S_test = S_test_S_test_0019 and S_test_delay = 0 then
          write_data_req_local <= '1';
        elsif S_test = S_test_S_test_0018 and S_test_delay = 0 then
          write_data_req_local <= '1';
        elsif S_test = S_test_S_test_0017 and S_test_delay = 0 then
          write_data_req_local <= '1';
        elsif S_test = S_test_S_test_0016 and S_test_delay = 0 then
          write_data_req_local <= '1';
        elsif S_test = S_test_S_test_0015 and S_test_delay = 0 then
          write_data_req_local <= '1';
        elsif S_test = S_test_S_test_0014 and S_test_delay = 0 then
          write_data_req_local <= '1';
        elsif S_test = S_test_S_test_0013 and S_test_delay = 0 then
          write_data_req_local <= '1';
        elsif S_test = S_test_S_test_0012 and S_test_delay = 0 then
          write_data_req_local <= '1';
        elsif S_test = S_test_S_test_0011 and S_test_delay = 0 then
          write_data_req_local <= '1';
        elsif S_test = S_test_S_test_0010 and S_test_delay = 0 then
          write_data_req_local <= '1';
        elsif S_test = S_test_S_test_0009 and S_test_delay = 0 then
          write_data_req_local <= '1';
        elsif S_test = S_test_S_test_0008 and S_test_delay = 0 then
          write_data_req_local <= '1';
        elsif S_test = S_test_S_test_0007 and S_test_delay = 0 then
          write_data_req_local <= '1';
        elsif S_test = S_test_S_test_0006 and S_test_delay = 0 then
          write_data_req_local <= '1';
        elsif S_test = S_test_S_test_0005 and S_test_delay = 0 then
          write_data_req_local <= '1';
        elsif S_test = S_test_S_test_0004 and S_test_delay = 0 then
          write_data_req_local <= '1';
        elsif S_test = S_test_S_test_0003 and S_test_delay = 0 then
          write_data_req_local <= '1';
        else
          write_data_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  write_data_busy_sig <= tmp_0013;

  wait_cycles_busy_sig_0017 <= tmp_0021;

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
        read_data_req_local <= '0';
      end if;
    end if;
  end process;

  read_data_busy_sig <= tmp_0026;

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

  wait_cycles_busy_sig_0030 <= tmp_0034;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        init_req_local <= '0';
      else
        if S_test = S_test_S_test_0021 and S_test_delay = 0 then
          init_req_local <= '1';
        else
          init_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  init_busy_sig <= tmp_0039;

  wait_cycles_busy_sig_0045 <= tmp_0049;

  wait_cycles_busy_sig_0052 <= tmp_0056;

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

  init_busy_sig_0064 <= tmp_0068;

  write_data_busy_sig_0072 <= tmp_0076;

  write_data_busy_sig_0080 <= tmp_0084;

  write_data_busy_sig_0088 <= tmp_0092;

  write_data_busy_sig_0096 <= tmp_0100;

  write_data_busy_sig_0104 <= tmp_0108;

  write_data_busy_sig_0112 <= tmp_0116;

  write_data_busy_sig_0120 <= tmp_0124;

  write_data_busy_sig_0128 <= tmp_0132;

  write_data_busy_sig_0136 <= tmp_0140;

  write_data_busy_sig_0144 <= tmp_0148;

  write_data_busy_sig_0152 <= tmp_0156;

  write_data_busy_sig_0160 <= tmp_0164;

  write_data_busy_sig_0168 <= tmp_0172;

  write_data_busy_sig_0176 <= tmp_0180;

  write_data_busy_sig_0184 <= tmp_0188;

  write_data_busy_sig_0192 <= tmp_0196;

  write_data_busy_sig_0200 <= tmp_0204;

  write_data_busy_sig_0208 <= tmp_0212;

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
