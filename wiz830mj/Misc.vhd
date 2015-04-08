library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Misc is
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
end Misc;

architecture RTL of Misc is

  component synthesijer_mul32
    port (
      clk : in std_logic;
      reset : in std_logic;
      a : in signed(32-1 downto 0);
      b : in signed(32-1 downto 0);
      nd : in std_logic;
      result : out signed(32-1 downto 0);
      valid : out std_logic
    );
  end component synthesijer_mul32;

  signal clk_sig : std_logic;
  signal reset_sig : std_logic;
  signal i_to_4digit_ascii_x_sig : signed(32-1 downto 0);
  signal isHex_v_sig : signed(8-1 downto 0);
  signal toHex1_v_sig : signed(8-1 downto 0);
  signal toHex2_v0_sig : signed(8-1 downto 0);
  signal toHex2_v1_sig : signed(8-1 downto 0);
  signal i_to_4digit_ascii_return_sig : signed(32-1 downto 0) := (others => '0');
  signal i_to_4digit_ascii_busy_sig : std_logic := '1';
  signal i_to_4digit_ascii_req_sig : std_logic;
  signal isHex_return_sig : std_logic := '0';
  signal isHex_busy_sig : std_logic := '1';
  signal isHex_req_sig : std_logic;
  signal toHex1_return_sig : signed(32-1 downto 0) := (others => '0');
  signal toHex1_busy_sig : std_logic := '1';
  signal toHex1_req_sig : std_logic;
  signal toHex2_return_sig : signed(32-1 downto 0) := (others => '0');
  signal toHex2_busy_sig : std_logic := '1';
  signal toHex2_req_sig : std_logic;

  signal simple_div_d_0000 : signed(32-1 downto 0) := (others => '0');
  signal simple_div_d_local : signed(32-1 downto 0) := (others => '0');
  signal simple_div_r_0001 : signed(32-1 downto 0) := (others => '0');
  signal simple_div_r_local : signed(32-1 downto 0) := (others => '0');
  signal simple_div_q_0002 : signed(32-1 downto 0) := X"00000000";
  signal simple_div_d0_0003 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00004 : std_logic := '0';
  signal binary_expr_00005 : signed(32-1 downto 0) := (others => '0');
  signal unary_expr_00006 : signed(32-1 downto 0) := (others => '0');
  signal to_d_v_0007 : signed(32-1 downto 0) := (others => '0');
  signal to_d_v_local : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00008 : std_logic := '0';
  signal binary_expr_00009 : std_logic := '0';
  signal binary_expr_00010 : std_logic := '0';
  signal binary_expr_00011 : signed(32-1 downto 0) := (others => '0');
  signal i_to_4digit_ascii_x_0012 : signed(32-1 downto 0) := (others => '0');
  signal i_to_4digit_ascii_x_local : signed(32-1 downto 0) := (others => '0');
  signal i_to_4digit_ascii_q_0013 : signed(32-1 downto 0) := (others => '0');
  signal i_to_4digit_ascii_x0_0014 : signed(32-1 downto 0) := (others => '0');
  signal i_to_4digit_ascii_r_0015 : signed(32-1 downto 0) := X"00000000";
  signal method_result_00016 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00017 : std_logic := '0';
  signal binary_expr_00023 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00024 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00025 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00026 : std_logic := '0';
  signal binary_expr_00027 : std_logic := '0';
  signal binary_expr_00028 : std_logic := '0';
  signal binary_expr_00034 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00035 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00036 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00037 : std_logic := '0';
  signal binary_expr_00038 : std_logic := '0';
  signal binary_expr_00039 : std_logic := '0';
  signal binary_expr_00045 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00046 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00047 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00048 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00049 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00050 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00018 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00019 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00020 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00021 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00022 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00029 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00030 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00031 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00032 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00033 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00040 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00041 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00042 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00043 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00044 : signed(32-1 downto 0) := (others => '0');
  signal isHex_v_0051 : signed(8-1 downto 0) := (others => '0');
  signal isHex_v_local : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00052 : std_logic := '0';
  signal binary_expr_00053 : std_logic := '0';
  signal binary_expr_00054 : std_logic := '0';
  signal binary_expr_00055 : std_logic := '0';
  signal binary_expr_00056 : std_logic := '0';
  signal binary_expr_00057 : std_logic := '0';
  signal binary_expr_00058 : std_logic := '0';
  signal binary_expr_00059 : std_logic := '0';
  signal binary_expr_00060 : std_logic := '0';
  signal binary_expr_00061 : std_logic := '0';
  signal binary_expr_00062 : std_logic := '0';
  signal toHex1_v_0063 : signed(8-1 downto 0) := (others => '0');
  signal toHex1_v_local : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00064 : std_logic := '0';
  signal binary_expr_00065 : std_logic := '0';
  signal binary_expr_00066 : std_logic := '0';
  signal binary_expr_00069 : std_logic := '0';
  signal binary_expr_00070 : std_logic := '0';
  signal binary_expr_00071 : std_logic := '0';
  signal binary_expr_00075 : std_logic := '0';
  signal binary_expr_00076 : std_logic := '0';
  signal binary_expr_00077 : std_logic := '0';
  signal binary_expr_00067 : signed(8-1 downto 0) := (others => '0');
  signal cast_expr_00068 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00072 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00073 : signed(8-1 downto 0) := (others => '0');
  signal cast_expr_00074 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00078 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00079 : signed(8-1 downto 0) := (others => '0');
  signal cast_expr_00080 : signed(32-1 downto 0) := (others => '0');
  signal toHex2_v0_0081 : signed(8-1 downto 0) := (others => '0');
  signal toHex2_v0_local : signed(8-1 downto 0) := (others => '0');
  signal toHex2_v1_0082 : signed(8-1 downto 0) := (others => '0');
  signal toHex2_v1_local : signed(8-1 downto 0) := (others => '0');
  signal toHex2_r_0083 : signed(32-1 downto 0) := X"00000000";
  signal method_result_00084 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00085 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00086 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00087 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00088 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00089 : signed(32-1 downto 0) := (others => '0');
  signal simple_div_return : signed(32-1 downto 0) := (others => '0');
  signal simple_div_busy : std_logic := '0';
  signal simple_div_req_flag : std_logic;
  signal simple_div_req_local : std_logic := '0';
  signal to_d_return : signed(32-1 downto 0) := (others => '0');
  signal to_d_busy : std_logic := '0';
  signal to_d_req_flag : std_logic;
  signal to_d_req_local : std_logic := '0';
  signal i_to_4digit_ascii_req_flag : std_logic;
  signal i_to_4digit_ascii_req_local : std_logic := '0';
  signal tmp_0001 : std_logic;
  signal isHex_req_flag : std_logic;
  signal isHex_req_local : std_logic := '0';
  signal tmp_0002 : std_logic;
  signal toHex1_req_flag : std_logic;
  signal toHex1_req_local : std_logic := '0';
  signal tmp_0003 : std_logic;
  signal toHex2_req_flag : std_logic;
  signal toHex2_req_local : std_logic := '0';
  signal tmp_0004 : std_logic;
  type Type_simple_div_method is (
    simple_div_method_IDLE,
    simple_div_method_S_0000,
    simple_div_method_S_0001,
    simple_div_method_S_0002,
    simple_div_method_S_0004,
    simple_div_method_S_0005,
    simple_div_method_S_0006,
    simple_div_method_S_0007,
    simple_div_method_S_0011,
    simple_div_method_S_0012,
    simple_div_method_S_0013  
  );
  signal simple_div_method : Type_simple_div_method := simple_div_method_IDLE;
  signal simple_div_method_delay : signed(32-1 downto 0) := (others => '0');
  signal simple_div_req_flag_d : std_logic := '0';
  signal simple_div_req_flag_edge : std_logic;
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
  signal tmp_0015 : std_logic;
  signal tmp_0016 : signed(32-1 downto 0);
  signal tmp_0017 : signed(32-1 downto 0);
  type Type_to_d_method is (
    to_d_method_IDLE,
    to_d_method_S_0000,
    to_d_method_S_0001,
    to_d_method_S_0002,
    to_d_method_S_0005,
    to_d_method_S_0006,
    to_d_method_S_0007,
    to_d_method_S_0008,
    to_d_method_S_0009,
    to_d_method_S_0010,
    to_d_method_S_0011,
    to_d_method_S_0012  
  );
  signal to_d_method : Type_to_d_method := to_d_method_IDLE;
  signal to_d_method_delay : signed(32-1 downto 0) := (others => '0');
  signal to_d_req_flag_d : std_logic := '0';
  signal to_d_req_flag_edge : std_logic;
  signal tmp_0018 : std_logic;
  signal tmp_0019 : std_logic;
  signal tmp_0020 : std_logic;
  signal tmp_0021 : std_logic;
  signal tmp_0022 : std_logic;
  signal tmp_0023 : std_logic;
  signal tmp_0024 : std_logic;
  signal tmp_0025 : std_logic;
  signal tmp_0026 : std_logic;
  signal tmp_0027 : std_logic;
  signal tmp_0028 : std_logic;
  signal tmp_0029 : std_logic;
  signal tmp_0030 : std_logic;
  signal tmp_0031 : signed(32-1 downto 0);
  type Type_i_to_4digit_ascii_method is (
    i_to_4digit_ascii_method_IDLE,
    i_to_4digit_ascii_method_S_0000,
    i_to_4digit_ascii_method_S_0001,
    i_to_4digit_ascii_method_S_0002,
    i_to_4digit_ascii_method_S_0004,
    i_to_4digit_ascii_method_S_0005,
    i_to_4digit_ascii_method_S_0007,
    i_to_4digit_ascii_method_S_0008,
    i_to_4digit_ascii_method_S_0009,
    i_to_4digit_ascii_method_S_0010,
    i_to_4digit_ascii_method_S_0013,
    i_to_4digit_ascii_method_S_0014,
    i_to_4digit_ascii_method_S_0017,
    i_to_4digit_ascii_method_S_0018,
    i_to_4digit_ascii_method_S_0019,
    i_to_4digit_ascii_method_S_0021,
    i_to_4digit_ascii_method_S_0022,
    i_to_4digit_ascii_method_S_0026,
    i_to_4digit_ascii_method_S_0027,
    i_to_4digit_ascii_method_S_0028,
    i_to_4digit_ascii_method_S_0029,
    i_to_4digit_ascii_method_S_0032,
    i_to_4digit_ascii_method_S_0033,
    i_to_4digit_ascii_method_S_0036,
    i_to_4digit_ascii_method_S_0037,
    i_to_4digit_ascii_method_S_0038,
    i_to_4digit_ascii_method_S_0040,
    i_to_4digit_ascii_method_S_0041,
    i_to_4digit_ascii_method_S_0045,
    i_to_4digit_ascii_method_S_0046,
    i_to_4digit_ascii_method_S_0047,
    i_to_4digit_ascii_method_S_0048,
    i_to_4digit_ascii_method_S_0051,
    i_to_4digit_ascii_method_S_0052,
    i_to_4digit_ascii_method_S_0055,
    i_to_4digit_ascii_method_S_0056,
    i_to_4digit_ascii_method_S_0057,
    i_to_4digit_ascii_method_S_0059,
    i_to_4digit_ascii_method_S_0060,
    i_to_4digit_ascii_method_S_0061,
    i_to_4digit_ascii_method_S_0062,
    i_to_4digit_ascii_method_S_0065,
    i_to_4digit_ascii_method_S_0066,
    i_to_4digit_ascii_method_S_0004_body,
    i_to_4digit_ascii_method_S_0004_wait,
    i_to_4digit_ascii_method_S_0009_body,
    i_to_4digit_ascii_method_S_0009_wait,
    i_to_4digit_ascii_method_S_0021_body,
    i_to_4digit_ascii_method_S_0021_wait,
    i_to_4digit_ascii_method_S_0028_body,
    i_to_4digit_ascii_method_S_0028_wait,
    i_to_4digit_ascii_method_S_0040_body,
    i_to_4digit_ascii_method_S_0040_wait,
    i_to_4digit_ascii_method_S_0047_body,
    i_to_4digit_ascii_method_S_0047_wait,
    i_to_4digit_ascii_method_S_0059_body,
    i_to_4digit_ascii_method_S_0059_wait,
    i_to_4digit_ascii_method_S_0061_body,
    i_to_4digit_ascii_method_S_0061_wait  
  );
  signal i_to_4digit_ascii_method : Type_i_to_4digit_ascii_method := i_to_4digit_ascii_method_IDLE;
  signal i_to_4digit_ascii_method_delay : signed(32-1 downto 0) := (others => '0');
  signal i_to_4digit_ascii_req_flag_d : std_logic := '0';
  signal i_to_4digit_ascii_req_flag_edge : std_logic;
  signal tmp_0032 : std_logic;
  signal tmp_0033 : std_logic;
  signal tmp_0034 : std_logic;
  signal tmp_0035 : std_logic;
  signal simple_div_call_flag_0004 : std_logic;
  signal tmp_0036 : std_logic;
  signal tmp_0037 : std_logic;
  signal tmp_0038 : std_logic;
  signal tmp_0039 : std_logic;
  signal tmp_0040 : std_logic;
  signal tmp_0041 : std_logic;
  signal to_d_call_flag_0009 : std_logic;
  signal tmp_0042 : std_logic;
  signal tmp_0043 : std_logic;
  signal tmp_0044 : std_logic;
  signal tmp_0045 : std_logic;
  signal u_synthesijer_mul32_i_to_4digit_ascii_clk : std_logic;
  signal u_synthesijer_mul32_i_to_4digit_ascii_reset : std_logic;
  signal u_synthesijer_mul32_i_to_4digit_ascii_a : signed(32-1 downto 0) := (others => '0');
  signal u_synthesijer_mul32_i_to_4digit_ascii_b : signed(32-1 downto 0) := (others => '0');
  signal u_synthesijer_mul32_i_to_4digit_ascii_nd : std_logic := '0';
  signal u_synthesijer_mul32_i_to_4digit_ascii_result : signed(32-1 downto 0);
  signal u_synthesijer_mul32_i_to_4digit_ascii_valid : std_logic;
  signal simple_div_call_flag_0021 : std_logic;
  signal tmp_0046 : std_logic;
  signal tmp_0047 : std_logic;
  signal tmp_0048 : std_logic;
  signal tmp_0049 : std_logic;
  signal tmp_0050 : std_logic;
  signal tmp_0051 : std_logic;
  signal to_d_call_flag_0028 : std_logic;
  signal tmp_0052 : std_logic;
  signal tmp_0053 : std_logic;
  signal tmp_0054 : std_logic;
  signal tmp_0055 : std_logic;
  signal simple_div_call_flag_0040 : std_logic;
  signal tmp_0056 : std_logic;
  signal tmp_0057 : std_logic;
  signal tmp_0058 : std_logic;
  signal tmp_0059 : std_logic;
  signal tmp_0060 : std_logic;
  signal tmp_0061 : std_logic;
  signal to_d_call_flag_0047 : std_logic;
  signal tmp_0062 : std_logic;
  signal tmp_0063 : std_logic;
  signal tmp_0064 : std_logic;
  signal tmp_0065 : std_logic;
  signal simple_div_call_flag_0059 : std_logic;
  signal tmp_0066 : std_logic;
  signal tmp_0067 : std_logic;
  signal tmp_0068 : std_logic;
  signal tmp_0069 : std_logic;
  signal to_d_call_flag_0061 : std_logic;
  signal tmp_0070 : std_logic;
  signal tmp_0071 : std_logic;
  signal tmp_0072 : std_logic;
  signal tmp_0073 : std_logic;
  signal tmp_0074 : std_logic;
  signal tmp_0075 : std_logic;
  signal tmp_0076 : std_logic;
  signal tmp_0077 : std_logic;
  signal tmp_0078 : signed(32-1 downto 0);
  signal tmp_0079 : std_logic;
  signal tmp_0080 : signed(32-1 downto 0);
  signal tmp_0081 : signed(32-1 downto 0);
  signal tmp_0082 : signed(32-1 downto 0);
  signal tmp_0083 : signed(32-1 downto 0);
  signal tmp_0084 : signed(32-1 downto 0);
  signal tmp_0085 : std_logic;
  signal tmp_0086 : std_logic;
  signal tmp_0087 : std_logic;
  signal tmp_0088 : signed(32-1 downto 0);
  signal tmp_0089 : signed(32-1 downto 0);
  signal tmp_0090 : signed(32-1 downto 0);
  signal tmp_0091 : signed(32-1 downto 0);
  signal tmp_0092 : signed(32-1 downto 0);
  signal tmp_0093 : std_logic;
  signal tmp_0094 : std_logic;
  signal tmp_0095 : std_logic;
  signal tmp_0096 : signed(32-1 downto 0);
  signal tmp_0097 : signed(32-1 downto 0);
  signal tmp_0098 : signed(32-1 downto 0);
  signal tmp_0099 : signed(32-1 downto 0);
  signal tmp_0100 : signed(32-1 downto 0);
  signal tmp_0101 : signed(32-1 downto 0);
  signal tmp_0102 : signed(32-1 downto 0);
  type Type_isHex_method is (
    isHex_method_IDLE,
    isHex_method_S_0000,
    isHex_method_S_0001,
    isHex_method_S_0002,
    isHex_method_S_0013,
    isHex_method_S_0014,
    isHex_method_S_0015,
    isHex_method_S_0016,
    isHex_method_S_0017,
    isHex_method_S_0018,
    isHex_method_S_0019  
  );
  signal isHex_method : Type_isHex_method := isHex_method_IDLE;
  signal isHex_method_delay : signed(32-1 downto 0) := (others => '0');
  signal isHex_req_flag_d : std_logic := '0';
  signal isHex_req_flag_edge : std_logic;
  signal tmp_0103 : std_logic;
  signal tmp_0104 : std_logic;
  signal tmp_0105 : std_logic;
  signal tmp_0106 : std_logic;
  signal tmp_0107 : std_logic;
  signal tmp_0108 : std_logic;
  signal tmp_0109 : std_logic;
  signal tmp_0110 : std_logic;
  signal tmp_0111 : std_logic;
  signal tmp_0112 : std_logic;
  signal tmp_0113 : signed(8-1 downto 0);
  signal tmp_0114 : std_logic;
  signal tmp_0115 : std_logic;
  signal tmp_0116 : std_logic;
  signal tmp_0117 : std_logic;
  signal tmp_0118 : std_logic;
  signal tmp_0119 : std_logic;
  signal tmp_0120 : std_logic;
  signal tmp_0121 : std_logic;
  signal tmp_0122 : std_logic;
  signal tmp_0123 : std_logic;
  signal tmp_0124 : std_logic;
  type Type_toHex1_method is (
    toHex1_method_IDLE,
    toHex1_method_S_0000,
    toHex1_method_S_0001,
    toHex1_method_S_0002,
    toHex1_method_S_0005,
    toHex1_method_S_0006,
    toHex1_method_S_0007,
    toHex1_method_S_0009,
    toHex1_method_S_0010,
    toHex1_method_S_0011,
    toHex1_method_S_0014,
    toHex1_method_S_0015,
    toHex1_method_S_0016,
    toHex1_method_S_0019,
    toHex1_method_S_0020,
    toHex1_method_S_0021,
    toHex1_method_S_0024,
    toHex1_method_S_0025,
    toHex1_method_S_0026,
    toHex1_method_S_0029,
    toHex1_method_S_0030,
    toHex1_method_S_0031,
    toHex1_method_S_0032  
  );
  signal toHex1_method : Type_toHex1_method := toHex1_method_IDLE;
  signal toHex1_method_delay : signed(32-1 downto 0) := (others => '0');
  signal toHex1_req_flag_d : std_logic := '0';
  signal toHex1_req_flag_edge : std_logic;
  signal tmp_0125 : std_logic;
  signal tmp_0126 : std_logic;
  signal tmp_0127 : std_logic;
  signal tmp_0128 : std_logic;
  signal tmp_0129 : std_logic;
  signal tmp_0130 : std_logic;
  signal tmp_0131 : std_logic;
  signal tmp_0132 : std_logic;
  signal tmp_0133 : std_logic;
  signal tmp_0134 : std_logic;
  signal tmp_0135 : std_logic;
  signal tmp_0136 : std_logic;
  signal tmp_0137 : std_logic;
  signal tmp_0138 : std_logic;
  signal tmp_0139 : signed(8-1 downto 0);
  signal tmp_0140 : std_logic;
  signal tmp_0141 : std_logic;
  signal tmp_0142 : std_logic;
  signal tmp_0143 : signed(8-1 downto 0);
  signal tmp_0144 : signed(32-1 downto 0);
  signal tmp_0145 : std_logic;
  signal tmp_0146 : std_logic;
  signal tmp_0147 : std_logic;
  signal tmp_0148 : signed(8-1 downto 0);
  signal tmp_0149 : signed(8-1 downto 0);
  signal tmp_0150 : signed(32-1 downto 0);
  signal tmp_0151 : std_logic;
  signal tmp_0152 : std_logic;
  signal tmp_0153 : std_logic;
  signal tmp_0154 : signed(8-1 downto 0);
  signal tmp_0155 : signed(8-1 downto 0);
  signal tmp_0156 : signed(32-1 downto 0);
  type Type_toHex2_method is (
    toHex2_method_IDLE,
    toHex2_method_S_0000,
    toHex2_method_S_0001,
    toHex2_method_S_0002,
    toHex2_method_S_0003,
    toHex2_method_S_0004,
    toHex2_method_S_0007,
    toHex2_method_S_0008,
    toHex2_method_S_0011,
    toHex2_method_S_0012,
    toHex2_method_S_0003_body,
    toHex2_method_S_0003_wait,
    toHex2_method_S_0007_body,
    toHex2_method_S_0007_wait  
  );
  signal toHex2_method : Type_toHex2_method := toHex2_method_IDLE;
  signal toHex2_method_delay : signed(32-1 downto 0) := (others => '0');
  signal toHex2_req_flag_d : std_logic := '0';
  signal toHex2_req_flag_edge : std_logic;
  signal tmp_0157 : std_logic;
  signal tmp_0158 : std_logic;
  signal tmp_0159 : std_logic;
  signal tmp_0160 : std_logic;
  signal toHex1_call_flag_0003 : std_logic;
  signal tmp_0161 : std_logic;
  signal tmp_0162 : std_logic;
  signal tmp_0163 : std_logic;
  signal tmp_0164 : std_logic;
  signal toHex1_call_flag_0007 : std_logic;
  signal tmp_0165 : std_logic;
  signal tmp_0166 : std_logic;
  signal tmp_0167 : std_logic;
  signal tmp_0168 : std_logic;
  signal tmp_0169 : std_logic;
  signal tmp_0170 : std_logic;
  signal tmp_0171 : std_logic;
  signal tmp_0172 : std_logic;
  signal tmp_0173 : signed(8-1 downto 0);
  signal tmp_0174 : signed(8-1 downto 0);
  signal tmp_0175 : signed(32-1 downto 0);
  signal tmp_0176 : signed(32-1 downto 0);
  signal tmp_0177 : signed(32-1 downto 0);
  signal tmp_0178 : signed(32-1 downto 0);

begin

  clk_sig <= clk;
  reset_sig <= reset;
  i_to_4digit_ascii_x_sig <= i_to_4digit_ascii_x;
  isHex_v_sig <= isHex_v;
  toHex1_v_sig <= toHex1_v;
  toHex2_v0_sig <= toHex2_v0;
  toHex2_v1_sig <= toHex2_v1;
  i_to_4digit_ascii_return <= i_to_4digit_ascii_return_sig;
  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        i_to_4digit_ascii_return_sig <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0065 then
          i_to_4digit_ascii_return_sig <= i_to_4digit_ascii_r_0015;
        end if;
      end if;
    end if;
  end process;

  i_to_4digit_ascii_busy <= i_to_4digit_ascii_busy_sig;
  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        i_to_4digit_ascii_busy_sig <= '1';
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0000 then
          i_to_4digit_ascii_busy_sig <= '0';
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0001 then
          i_to_4digit_ascii_busy_sig <= tmp_0035;
        end if;
      end if;
    end if;
  end process;

  i_to_4digit_ascii_req_sig <= i_to_4digit_ascii_req;
  isHex_return <= isHex_return_sig;
  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        isHex_return_sig <= '0';
      else
        if isHex_method = isHex_method_S_0015 then
          isHex_return_sig <= '1';
        elsif isHex_method = isHex_method_S_0017 then
          isHex_return_sig <= '0';
        end if;
      end if;
    end if;
  end process;

  isHex_busy <= isHex_busy_sig;
  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        isHex_busy_sig <= '1';
      else
        if isHex_method = isHex_method_S_0000 then
          isHex_busy_sig <= '0';
        elsif isHex_method = isHex_method_S_0001 then
          isHex_busy_sig <= tmp_0106;
        end if;
      end if;
    end if;
  end process;

  isHex_req_sig <= isHex_req;
  toHex1_return <= toHex1_return_sig;
  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        toHex1_return_sig <= (others => '0');
      else
        if toHex1_method = toHex1_method_S_0009 then
          toHex1_return_sig <= cast_expr_00068;
        elsif toHex1_method = toHex1_method_S_0019 then
          toHex1_return_sig <= cast_expr_00074;
        elsif toHex1_method = toHex1_method_S_0029 then
          toHex1_return_sig <= cast_expr_00080;
        elsif toHex1_method = toHex1_method_S_0031 then
          toHex1_return_sig <= X"00000000";
        end if;
      end if;
    end if;
  end process;

  toHex1_busy <= toHex1_busy_sig;
  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        toHex1_busy_sig <= '1';
      else
        if toHex1_method = toHex1_method_S_0000 then
          toHex1_busy_sig <= '0';
        elsif toHex1_method = toHex1_method_S_0001 then
          toHex1_busy_sig <= tmp_0128;
        end if;
      end if;
    end if;
  end process;

  toHex1_req_sig <= toHex1_req;
  toHex2_return <= toHex2_return_sig;
  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        toHex2_return_sig <= (others => '0');
      else
        if toHex2_method = toHex2_method_S_0011 then
          toHex2_return_sig <= toHex2_r_0083;
        end if;
      end if;
    end if;
  end process;

  toHex2_busy <= toHex2_busy_sig;
  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        toHex2_busy_sig <= '1';
      else
        if toHex2_method = toHex2_method_S_0000 then
          toHex2_busy_sig <= '0';
        elsif toHex2_method = toHex2_method_S_0001 then
          toHex2_busy_sig <= tmp_0160;
        end if;
      end if;
    end if;
  end process;

  toHex2_req_sig <= toHex2_req;

  -- expressions
  tmp_0001 <= i_to_4digit_ascii_req_local or i_to_4digit_ascii_req_sig;
  tmp_0002 <= isHex_req_local or isHex_req_sig;
  tmp_0003 <= toHex1_req_local or toHex1_req_sig;
  tmp_0004 <= toHex2_req_local or toHex2_req_sig;
  tmp_0005 <= not simple_div_req_flag_d;
  tmp_0006 <= simple_div_req_flag and tmp_0005;
  tmp_0007 <= simple_div_req_flag or simple_div_req_flag_d;
  tmp_0008 <= simple_div_req_flag or simple_div_req_flag_d;
  tmp_0009 <= '1' when binary_expr_00004 = '1' else '0';
  tmp_0010 <= '1' when binary_expr_00004 = '0' else '0';
  tmp_0011 <= '1' when simple_div_method /= simple_div_method_S_0000 else '0';
  tmp_0012 <= '1' when simple_div_method /= simple_div_method_S_0001 else '0';
  tmp_0013 <= tmp_0012 and simple_div_req_flag_edge;
  tmp_0014 <= tmp_0011 and tmp_0013;
  tmp_0015 <= '1' when simple_div_d0_0003 >= simple_div_r_0001 else '0';
  tmp_0016 <= simple_div_d0_0003 - simple_div_r_0001;
  tmp_0017 <= simple_div_q_0002 + X"00000001";
  tmp_0018 <= not to_d_req_flag_d;
  tmp_0019 <= to_d_req_flag and tmp_0018;
  tmp_0020 <= to_d_req_flag or to_d_req_flag_d;
  tmp_0021 <= to_d_req_flag or to_d_req_flag_d;
  tmp_0022 <= '1' when binary_expr_00010 = '1' else '0';
  tmp_0023 <= '1' when binary_expr_00010 = '0' else '0';
  tmp_0024 <= '1' when to_d_method /= to_d_method_S_0000 else '0';
  tmp_0025 <= '1' when to_d_method /= to_d_method_S_0001 else '0';
  tmp_0026 <= tmp_0025 and to_d_req_flag_edge;
  tmp_0027 <= tmp_0024 and tmp_0026;
  tmp_0028 <= '1' when X"00000000" <= to_d_v_0007 else '0';
  tmp_0029 <= '1' when to_d_v_0007 <= X"00000009" else '0';
  tmp_0030 <= tmp_0028 and tmp_0029;
  tmp_0031 <= X"00000030" + to_d_v_0007;
  tmp_0032 <= not i_to_4digit_ascii_req_flag_d;
  tmp_0033 <= i_to_4digit_ascii_req_flag and tmp_0032;
  tmp_0034 <= i_to_4digit_ascii_req_flag or i_to_4digit_ascii_req_flag_d;
  tmp_0035 <= i_to_4digit_ascii_req_flag or i_to_4digit_ascii_req_flag_d;
  tmp_0036 <= '1' when simple_div_busy = '0' else '0';
  tmp_0037 <= '1' when simple_div_req_local = '0' else '0';
  tmp_0038 <= tmp_0036 and tmp_0037;
  tmp_0039 <= '1' when tmp_0038 = '1' else '0';
  tmp_0040 <= '1' when binary_expr_00017 = '1' else '0';
  tmp_0041 <= '1' when binary_expr_00017 = '0' else '0';
  tmp_0042 <= '1' when to_d_busy = '0' else '0';
  tmp_0043 <= '1' when to_d_req_local = '0' else '0';
  tmp_0044 <= tmp_0042 and tmp_0043;
  tmp_0045 <= '1' when tmp_0044 = '1' else '0';
  tmp_0046 <= '1' when simple_div_busy = '0' else '0';
  tmp_0047 <= '1' when simple_div_req_local = '0' else '0';
  tmp_0048 <= tmp_0046 and tmp_0047;
  tmp_0049 <= '1' when tmp_0048 = '1' else '0';
  tmp_0050 <= '1' when binary_expr_00028 = '1' else '0';
  tmp_0051 <= '1' when binary_expr_00028 = '0' else '0';
  tmp_0052 <= '1' when to_d_busy = '0' else '0';
  tmp_0053 <= '1' when to_d_req_local = '0' else '0';
  tmp_0054 <= tmp_0052 and tmp_0053;
  tmp_0055 <= '1' when tmp_0054 = '1' else '0';
  tmp_0056 <= '1' when simple_div_busy = '0' else '0';
  tmp_0057 <= '1' when simple_div_req_local = '0' else '0';
  tmp_0058 <= tmp_0056 and tmp_0057;
  tmp_0059 <= '1' when tmp_0058 = '1' else '0';
  tmp_0060 <= '1' when binary_expr_00039 = '1' else '0';
  tmp_0061 <= '1' when binary_expr_00039 = '0' else '0';
  tmp_0062 <= '1' when to_d_busy = '0' else '0';
  tmp_0063 <= '1' when to_d_req_local = '0' else '0';
  tmp_0064 <= tmp_0062 and tmp_0063;
  tmp_0065 <= '1' when tmp_0064 = '1' else '0';
  tmp_0066 <= '1' when simple_div_busy = '0' else '0';
  tmp_0067 <= '1' when simple_div_req_local = '0' else '0';
  tmp_0068 <= tmp_0066 and tmp_0067;
  tmp_0069 <= '1' when tmp_0068 = '1' else '0';
  tmp_0070 <= '1' when to_d_busy = '0' else '0';
  tmp_0071 <= '1' when to_d_req_local = '0' else '0';
  tmp_0072 <= tmp_0070 and tmp_0071;
  tmp_0073 <= '1' when tmp_0072 = '1' else '0';
  tmp_0074 <= '1' when i_to_4digit_ascii_method /= i_to_4digit_ascii_method_S_0000 else '0';
  tmp_0075 <= '1' when i_to_4digit_ascii_method /= i_to_4digit_ascii_method_S_0001 else '0';
  tmp_0076 <= tmp_0075 and i_to_4digit_ascii_req_flag_edge;
  tmp_0077 <= tmp_0074 and tmp_0076;
  tmp_0078 <= i_to_4digit_ascii_x_sig when i_to_4digit_ascii_req_sig = '1' else i_to_4digit_ascii_x_local;
  tmp_0079 <= '1' when method_result_00016 > X"00000000" else '0';
  tmp_0080 <= method_result_00018(7 downto 0) & (24-1 downto 0 => '0');
  tmp_0081 <= i_to_4digit_ascii_r_0015 + tmp_0080;
  tmp_0082 <= X"20000000";
  tmp_0083 <= i_to_4digit_ascii_r_0015 + tmp_0082;
  tmp_0084 <= i_to_4digit_ascii_x0_0014 - binary_expr_00023;
  tmp_0085 <= '1' when i_to_4digit_ascii_r_0015 > X"20000000" else '0';
  tmp_0086 <= '1' when method_result_00025 > X"00000000" else '0';
  tmp_0087 <= tmp_0086 or tmp_0085;
  tmp_0088 <= method_result_00029(15 downto 0) & (16-1 downto 0 => '0');
  tmp_0089 <= i_to_4digit_ascii_r_0015 + tmp_0088;
  tmp_0090 <= X"00200000";
  tmp_0091 <= i_to_4digit_ascii_r_0015 + tmp_0090;
  tmp_0092 <= i_to_4digit_ascii_x0_0014 - binary_expr_00034;
  tmp_0093 <= '1' when i_to_4digit_ascii_r_0015 > X"20200000" else '0';
  tmp_0094 <= '1' when method_result_00036 > X"00000000" else '0';
  tmp_0095 <= tmp_0094 or tmp_0093;
  tmp_0096 <= method_result_00040(23 downto 0) & (8-1 downto 0 => '0');
  tmp_0097 <= i_to_4digit_ascii_r_0015 + tmp_0096;
  tmp_0098 <= X"00002000";
  tmp_0099 <= i_to_4digit_ascii_r_0015 + tmp_0098;
  tmp_0100 <= i_to_4digit_ascii_x0_0014 - binary_expr_00045;
  tmp_0101 <= method_result_00048;
  tmp_0102 <= i_to_4digit_ascii_r_0015 + tmp_0101;
  tmp_0103 <= not isHex_req_flag_d;
  tmp_0104 <= isHex_req_flag and tmp_0103;
  tmp_0105 <= isHex_req_flag or isHex_req_flag_d;
  tmp_0106 <= isHex_req_flag or isHex_req_flag_d;
  tmp_0107 <= '1' when binary_expr_00062 = '1' else '0';
  tmp_0108 <= '1' when binary_expr_00062 = '0' else '0';
  tmp_0109 <= '1' when isHex_method /= isHex_method_S_0000 else '0';
  tmp_0110 <= '1' when isHex_method /= isHex_method_S_0001 else '0';
  tmp_0111 <= tmp_0110 and isHex_req_flag_edge;
  tmp_0112 <= tmp_0109 and tmp_0111;
  tmp_0113 <= isHex_v_sig when isHex_req_sig = '1' else isHex_v_local;
  tmp_0114 <= '1' when X"30" <= isHex_v_0051 else '0';
  tmp_0115 <= '1' when isHex_v_0051 <= X"39" else '0';
  tmp_0116 <= '1' when X"61" <= isHex_v_0051 else '0';
  tmp_0117 <= '1' when isHex_v_0051 <= X"66" else '0';
  tmp_0118 <= '1' when X"41" <= isHex_v_0051 else '0';
  tmp_0119 <= '1' when isHex_v_0051 <= X"46" else '0';
  tmp_0120 <= tmp_0114 and tmp_0115;
  tmp_0121 <= tmp_0116 and tmp_0117;
  tmp_0122 <= tmp_0118 and tmp_0119;
  tmp_0123 <= tmp_0120 or tmp_0121;
  tmp_0124 <= tmp_0123 or tmp_0122;
  tmp_0125 <= not toHex1_req_flag_d;
  tmp_0126 <= toHex1_req_flag and tmp_0125;
  tmp_0127 <= toHex1_req_flag or toHex1_req_flag_d;
  tmp_0128 <= toHex1_req_flag or toHex1_req_flag_d;
  tmp_0129 <= '1' when binary_expr_00066 = '1' else '0';
  tmp_0130 <= '1' when binary_expr_00066 = '0' else '0';
  tmp_0131 <= '1' when binary_expr_00071 = '1' else '0';
  tmp_0132 <= '1' when binary_expr_00071 = '0' else '0';
  tmp_0133 <= '1' when binary_expr_00077 = '1' else '0';
  tmp_0134 <= '1' when binary_expr_00077 = '0' else '0';
  tmp_0135 <= '1' when toHex1_method /= toHex1_method_S_0000 else '0';
  tmp_0136 <= '1' when toHex1_method /= toHex1_method_S_0001 else '0';
  tmp_0137 <= tmp_0136 and toHex1_req_flag_edge;
  tmp_0138 <= tmp_0135 and tmp_0137;
  tmp_0139 <= toHex1_v_sig when toHex1_req_sig = '1' else toHex1_v_local;
  tmp_0140 <= '1' when X"30" <= toHex1_v_0063 else '0';
  tmp_0141 <= '1' when toHex1_v_0063 <= X"39" else '0';
  tmp_0142 <= tmp_0140 and tmp_0141;
  tmp_0143 <= toHex1_v_0063 - X"30";
  tmp_0144 <= (32-1 downto 8 => tmp_0143(7)) & tmp_0143;
  tmp_0145 <= '1' when X"61" <= toHex1_v_0063 else '0';
  tmp_0146 <= '1' when toHex1_v_0063 <= X"66" else '0';
  tmp_0147 <= tmp_0145 and tmp_0146;
  tmp_0148 <= toHex1_v_0063 - X"61";
  tmp_0149 <= tmp_0148 + X"0a";
  tmp_0150 <= (32-1 downto 8 => tmp_0149(7)) & tmp_0149;
  tmp_0151 <= '1' when X"41" <= toHex1_v_0063 else '0';
  tmp_0152 <= '1' when toHex1_v_0063 <= X"46" else '0';
  tmp_0153 <= tmp_0151 and tmp_0152;
  tmp_0154 <= toHex1_v_0063 - X"41";
  tmp_0155 <= tmp_0154 + X"0a";
  tmp_0156 <= (32-1 downto 8 => tmp_0155(7)) & tmp_0155;
  tmp_0157 <= not toHex2_req_flag_d;
  tmp_0158 <= toHex2_req_flag and tmp_0157;
  tmp_0159 <= toHex2_req_flag or toHex2_req_flag_d;
  tmp_0160 <= toHex2_req_flag or toHex2_req_flag_d;
  tmp_0161 <= '1' when toHex1_busy_sig = '0' else '0';
  tmp_0162 <= '1' when toHex1_req_local = '0' else '0';
  tmp_0163 <= tmp_0161 and tmp_0162;
  tmp_0164 <= '1' when tmp_0163 = '1' else '0';
  tmp_0165 <= '1' when toHex1_busy_sig = '0' else '0';
  tmp_0166 <= '1' when toHex1_req_local = '0' else '0';
  tmp_0167 <= tmp_0165 and tmp_0166;
  tmp_0168 <= '1' when tmp_0167 = '1' else '0';
  tmp_0169 <= '1' when toHex2_method /= toHex2_method_S_0000 else '0';
  tmp_0170 <= '1' when toHex2_method /= toHex2_method_S_0001 else '0';
  tmp_0171 <= tmp_0170 and toHex2_req_flag_edge;
  tmp_0172 <= tmp_0169 and tmp_0171;
  tmp_0173 <= toHex2_v0_sig when toHex2_req_sig = '1' else toHex2_v0_local;
  tmp_0174 <= toHex2_v1_sig when toHex2_req_sig = '1' else toHex2_v1_local;
  tmp_0175 <= method_result_00084(27 downto 0) & (4-1 downto 0 => '0');
  tmp_0176 <= toHex2_r_0083 + tmp_0175;
  tmp_0177 <= method_result_00087;
  tmp_0178 <= toHex2_r_0083 + tmp_0177;

  -- sequencers
  process (clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        simple_div_method <= simple_div_method_IDLE;
        simple_div_method_delay <= (others => '0');
      else
        case (simple_div_method) is
          when simple_div_method_IDLE => 
            simple_div_method <= simple_div_method_S_0000;
          when simple_div_method_S_0000 => 
            simple_div_method <= simple_div_method_S_0001;
          when simple_div_method_S_0001 => 
            if tmp_0007 = '1' then
              simple_div_method <= simple_div_method_S_0002;
            end if;
          when simple_div_method_S_0002 => 
            simple_div_method <= simple_div_method_S_0004;
          when simple_div_method_S_0004 => 
            simple_div_method <= simple_div_method_S_0005;
          when simple_div_method_S_0005 => 
            if tmp_0009 = '1' then
              simple_div_method <= simple_div_method_S_0007;
            elsif tmp_0010 = '1' then
              simple_div_method <= simple_div_method_S_0006;
            end if;
          when simple_div_method_S_0006 => 
            simple_div_method <= simple_div_method_S_0012;
          when simple_div_method_S_0007 => 
            simple_div_method <= simple_div_method_S_0011;
          when simple_div_method_S_0011 => 
            simple_div_method <= simple_div_method_S_0004;
          when simple_div_method_S_0012 => 
            simple_div_method <= simple_div_method_S_0000;
          when simple_div_method_S_0013 => 
            simple_div_method <= simple_div_method_S_0000;
          when others => null;
        end case;
        simple_div_req_flag_d <= simple_div_req_flag;
        if (tmp_0011 and tmp_0013) = '1' then
          simple_div_method <= simple_div_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        to_d_method <= to_d_method_IDLE;
        to_d_method_delay <= (others => '0');
      else
        case (to_d_method) is
          when to_d_method_IDLE => 
            to_d_method <= to_d_method_S_0000;
          when to_d_method_S_0000 => 
            to_d_method <= to_d_method_S_0001;
          when to_d_method_S_0001 => 
            if tmp_0020 = '1' then
              to_d_method <= to_d_method_S_0002;
            end if;
          when to_d_method_S_0002 => 
            to_d_method <= to_d_method_S_0005;
          when to_d_method_S_0005 => 
            if tmp_0022 = '1' then
              to_d_method <= to_d_method_S_0007;
            elsif tmp_0023 = '1' then
              to_d_method <= to_d_method_S_0010;
            end if;
          when to_d_method_S_0006 => 
            to_d_method <= to_d_method_S_0012;
          when to_d_method_S_0007 => 
            to_d_method <= to_d_method_S_0008;
          when to_d_method_S_0008 => 
            to_d_method <= to_d_method_S_0000;
          when to_d_method_S_0009 => 
            to_d_method <= to_d_method_S_0006;
          when to_d_method_S_0010 => 
            to_d_method <= to_d_method_S_0000;
          when to_d_method_S_0011 => 
            to_d_method <= to_d_method_S_0006;
          when to_d_method_S_0012 => 
            to_d_method <= to_d_method_S_0000;
          when others => null;
        end case;
        to_d_req_flag_d <= to_d_req_flag;
        if (tmp_0024 and tmp_0026) = '1' then
          to_d_method <= to_d_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        i_to_4digit_ascii_method <= i_to_4digit_ascii_method_IDLE;
        i_to_4digit_ascii_method_delay <= (others => '0');
      else
        case (i_to_4digit_ascii_method) is
          when i_to_4digit_ascii_method_IDLE => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0000;
          when i_to_4digit_ascii_method_S_0000 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0001;
          when i_to_4digit_ascii_method_S_0001 => 
            if tmp_0034 = '1' then
              i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0002;
            end if;
          when i_to_4digit_ascii_method_S_0002 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0004;
          when i_to_4digit_ascii_method_S_0004 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0004_body;
          when i_to_4digit_ascii_method_S_0005 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0007;
          when i_to_4digit_ascii_method_S_0007 => 
            if tmp_0040 = '1' then
              i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0009;
            elsif tmp_0041 = '1' then
              i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0014;
            end if;
          when i_to_4digit_ascii_method_S_0008 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0018;
          when i_to_4digit_ascii_method_S_0009 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0009_body;
          when i_to_4digit_ascii_method_S_0010 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0013;
          when i_to_4digit_ascii_method_S_0013 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0008;
          when i_to_4digit_ascii_method_S_0014 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0017;
          when i_to_4digit_ascii_method_S_0017 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0008;
          when i_to_4digit_ascii_method_S_0018 => 
            if i_to_4digit_ascii_method_delay >= 1 and u_synthesijer_mul32_i_to_4digit_ascii_valid = '1' then
              i_to_4digit_ascii_method_delay <= (others => '0');
              i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0019;
            else
              i_to_4digit_ascii_method_delay <= i_to_4digit_ascii_method_delay + 1;
            end if;
          when i_to_4digit_ascii_method_S_0019 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0021;
          when i_to_4digit_ascii_method_S_0021 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0021_body;
          when i_to_4digit_ascii_method_S_0022 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0026;
          when i_to_4digit_ascii_method_S_0026 => 
            if tmp_0050 = '1' then
              i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0028;
            elsif tmp_0051 = '1' then
              i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0033;
            end if;
          when i_to_4digit_ascii_method_S_0027 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0037;
          when i_to_4digit_ascii_method_S_0028 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0028_body;
          when i_to_4digit_ascii_method_S_0029 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0032;
          when i_to_4digit_ascii_method_S_0032 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0027;
          when i_to_4digit_ascii_method_S_0033 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0036;
          when i_to_4digit_ascii_method_S_0036 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0027;
          when i_to_4digit_ascii_method_S_0037 => 
            if i_to_4digit_ascii_method_delay >= 1 and u_synthesijer_mul32_i_to_4digit_ascii_valid = '1' then
              i_to_4digit_ascii_method_delay <= (others => '0');
              i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0038;
            else
              i_to_4digit_ascii_method_delay <= i_to_4digit_ascii_method_delay + 1;
            end if;
          when i_to_4digit_ascii_method_S_0038 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0040;
          when i_to_4digit_ascii_method_S_0040 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0040_body;
          when i_to_4digit_ascii_method_S_0041 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0045;
          when i_to_4digit_ascii_method_S_0045 => 
            if tmp_0060 = '1' then
              i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0047;
            elsif tmp_0061 = '1' then
              i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0052;
            end if;
          when i_to_4digit_ascii_method_S_0046 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0056;
          when i_to_4digit_ascii_method_S_0047 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0047_body;
          when i_to_4digit_ascii_method_S_0048 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0051;
          when i_to_4digit_ascii_method_S_0051 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0046;
          when i_to_4digit_ascii_method_S_0052 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0055;
          when i_to_4digit_ascii_method_S_0055 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0046;
          when i_to_4digit_ascii_method_S_0056 => 
            if i_to_4digit_ascii_method_delay >= 1 and u_synthesijer_mul32_i_to_4digit_ascii_valid = '1' then
              i_to_4digit_ascii_method_delay <= (others => '0');
              i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0057;
            else
              i_to_4digit_ascii_method_delay <= i_to_4digit_ascii_method_delay + 1;
            end if;
          when i_to_4digit_ascii_method_S_0057 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0059;
          when i_to_4digit_ascii_method_S_0059 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0059_body;
          when i_to_4digit_ascii_method_S_0060 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0061;
          when i_to_4digit_ascii_method_S_0061 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0061_body;
          when i_to_4digit_ascii_method_S_0062 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0065;
          when i_to_4digit_ascii_method_S_0065 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0000;
          when i_to_4digit_ascii_method_S_0066 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0000;
          when i_to_4digit_ascii_method_S_0004_body => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0004_wait;
          when i_to_4digit_ascii_method_S_0004_wait => 
            if simple_div_call_flag_0004 = '1' then
              i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0005;
            end if;
          when i_to_4digit_ascii_method_S_0009_body => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0009_wait;
          when i_to_4digit_ascii_method_S_0009_wait => 
            if to_d_call_flag_0009 = '1' then
              i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0010;
            end if;
          when i_to_4digit_ascii_method_S_0021_body => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0021_wait;
          when i_to_4digit_ascii_method_S_0021_wait => 
            if simple_div_call_flag_0021 = '1' then
              i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0022;
            end if;
          when i_to_4digit_ascii_method_S_0028_body => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0028_wait;
          when i_to_4digit_ascii_method_S_0028_wait => 
            if to_d_call_flag_0028 = '1' then
              i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0029;
            end if;
          when i_to_4digit_ascii_method_S_0040_body => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0040_wait;
          when i_to_4digit_ascii_method_S_0040_wait => 
            if simple_div_call_flag_0040 = '1' then
              i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0041;
            end if;
          when i_to_4digit_ascii_method_S_0047_body => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0047_wait;
          when i_to_4digit_ascii_method_S_0047_wait => 
            if to_d_call_flag_0047 = '1' then
              i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0048;
            end if;
          when i_to_4digit_ascii_method_S_0059_body => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0059_wait;
          when i_to_4digit_ascii_method_S_0059_wait => 
            if simple_div_call_flag_0059 = '1' then
              i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0060;
            end if;
          when i_to_4digit_ascii_method_S_0061_body => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0061_wait;
          when i_to_4digit_ascii_method_S_0061_wait => 
            if to_d_call_flag_0061 = '1' then
              i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0062;
            end if;
          when others => null;
        end case;
        i_to_4digit_ascii_req_flag_d <= i_to_4digit_ascii_req_flag;
        if (tmp_0074 and tmp_0076) = '1' then
          i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        isHex_method <= isHex_method_IDLE;
        isHex_method_delay <= (others => '0');
      else
        case (isHex_method) is
          when isHex_method_IDLE => 
            isHex_method <= isHex_method_S_0000;
          when isHex_method_S_0000 => 
            isHex_method <= isHex_method_S_0001;
          when isHex_method_S_0001 => 
            if tmp_0105 = '1' then
              isHex_method <= isHex_method_S_0002;
            end if;
          when isHex_method_S_0002 => 
            isHex_method <= isHex_method_S_0013;
          when isHex_method_S_0013 => 
            if tmp_0107 = '1' then
              isHex_method <= isHex_method_S_0015;
            elsif tmp_0108 = '1' then
              isHex_method <= isHex_method_S_0017;
            end if;
          when isHex_method_S_0014 => 
            isHex_method <= isHex_method_S_0019;
          when isHex_method_S_0015 => 
            isHex_method <= isHex_method_S_0000;
          when isHex_method_S_0016 => 
            isHex_method <= isHex_method_S_0014;
          when isHex_method_S_0017 => 
            isHex_method <= isHex_method_S_0000;
          when isHex_method_S_0018 => 
            isHex_method <= isHex_method_S_0014;
          when isHex_method_S_0019 => 
            isHex_method <= isHex_method_S_0000;
          when others => null;
        end case;
        isHex_req_flag_d <= isHex_req_flag;
        if (tmp_0109 and tmp_0111) = '1' then
          isHex_method <= isHex_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        toHex1_method <= toHex1_method_IDLE;
        toHex1_method_delay <= (others => '0');
      else
        case (toHex1_method) is
          when toHex1_method_IDLE => 
            toHex1_method <= toHex1_method_S_0000;
          when toHex1_method_S_0000 => 
            toHex1_method <= toHex1_method_S_0001;
          when toHex1_method_S_0001 => 
            if tmp_0127 = '1' then
              toHex1_method <= toHex1_method_S_0002;
            end if;
          when toHex1_method_S_0002 => 
            toHex1_method <= toHex1_method_S_0005;
          when toHex1_method_S_0005 => 
            if tmp_0129 = '1' then
              toHex1_method <= toHex1_method_S_0007;
            elsif tmp_0130 = '1' then
              toHex1_method <= toHex1_method_S_0006;
            end if;
          when toHex1_method_S_0006 => 
            toHex1_method <= toHex1_method_S_0011;
          when toHex1_method_S_0007 => 
            toHex1_method <= toHex1_method_S_0009;
          when toHex1_method_S_0009 => 
            toHex1_method <= toHex1_method_S_0000;
          when toHex1_method_S_0010 => 
            toHex1_method <= toHex1_method_S_0006;
          when toHex1_method_S_0011 => 
            toHex1_method <= toHex1_method_S_0014;
          when toHex1_method_S_0014 => 
            if tmp_0131 = '1' then
              toHex1_method <= toHex1_method_S_0016;
            elsif tmp_0132 = '1' then
              toHex1_method <= toHex1_method_S_0015;
            end if;
          when toHex1_method_S_0015 => 
            toHex1_method <= toHex1_method_S_0021;
          when toHex1_method_S_0016 => 
            toHex1_method <= toHex1_method_S_0019;
          when toHex1_method_S_0019 => 
            toHex1_method <= toHex1_method_S_0000;
          when toHex1_method_S_0020 => 
            toHex1_method <= toHex1_method_S_0015;
          when toHex1_method_S_0021 => 
            toHex1_method <= toHex1_method_S_0024;
          when toHex1_method_S_0024 => 
            if tmp_0133 = '1' then
              toHex1_method <= toHex1_method_S_0026;
            elsif tmp_0134 = '1' then
              toHex1_method <= toHex1_method_S_0025;
            end if;
          when toHex1_method_S_0025 => 
            toHex1_method <= toHex1_method_S_0031;
          when toHex1_method_S_0026 => 
            toHex1_method <= toHex1_method_S_0029;
          when toHex1_method_S_0029 => 
            toHex1_method <= toHex1_method_S_0000;
          when toHex1_method_S_0030 => 
            toHex1_method <= toHex1_method_S_0025;
          when toHex1_method_S_0031 => 
            toHex1_method <= toHex1_method_S_0000;
          when toHex1_method_S_0032 => 
            toHex1_method <= toHex1_method_S_0000;
          when others => null;
        end case;
        toHex1_req_flag_d <= toHex1_req_flag;
        if (tmp_0135 and tmp_0137) = '1' then
          toHex1_method <= toHex1_method_S_0001;
        end if;
      end if;
    end if;
  end process;

  process (clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        toHex2_method <= toHex2_method_IDLE;
        toHex2_method_delay <= (others => '0');
      else
        case (toHex2_method) is
          when toHex2_method_IDLE => 
            toHex2_method <= toHex2_method_S_0000;
          when toHex2_method_S_0000 => 
            toHex2_method <= toHex2_method_S_0001;
          when toHex2_method_S_0001 => 
            if tmp_0159 = '1' then
              toHex2_method <= toHex2_method_S_0002;
            end if;
          when toHex2_method_S_0002 => 
            toHex2_method <= toHex2_method_S_0003;
          when toHex2_method_S_0003 => 
            toHex2_method <= toHex2_method_S_0003_body;
          when toHex2_method_S_0004 => 
            toHex2_method <= toHex2_method_S_0007;
          when toHex2_method_S_0007 => 
            toHex2_method <= toHex2_method_S_0007_body;
          when toHex2_method_S_0008 => 
            toHex2_method <= toHex2_method_S_0011;
          when toHex2_method_S_0011 => 
            toHex2_method <= toHex2_method_S_0000;
          when toHex2_method_S_0012 => 
            toHex2_method <= toHex2_method_S_0000;
          when toHex2_method_S_0003_body => 
            toHex2_method <= toHex2_method_S_0003_wait;
          when toHex2_method_S_0003_wait => 
            if toHex1_call_flag_0003 = '1' then
              toHex2_method <= toHex2_method_S_0004;
            end if;
          when toHex2_method_S_0007_body => 
            toHex2_method <= toHex2_method_S_0007_wait;
          when toHex2_method_S_0007_wait => 
            if toHex1_call_flag_0007 = '1' then
              toHex2_method <= toHex2_method_S_0008;
            end if;
          when others => null;
        end case;
        toHex2_req_flag_d <= toHex2_req_flag;
        if (tmp_0169 and tmp_0171) = '1' then
          toHex2_method <= toHex2_method_S_0001;
        end if;
      end if;
    end if;
  end process;


  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        simple_div_d_0000 <= (others => '0');
      else
        if simple_div_method = simple_div_method_S_0001 then
          simple_div_d_0000 <= simple_div_d_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        simple_div_d_local <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0004_body and i_to_4digit_ascii_method_delay = 0 then
          simple_div_d_local <= i_to_4digit_ascii_x0_0014;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0021_body and i_to_4digit_ascii_method_delay = 0 then
          simple_div_d_local <= i_to_4digit_ascii_x0_0014;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0040_body and i_to_4digit_ascii_method_delay = 0 then
          simple_div_d_local <= i_to_4digit_ascii_x0_0014;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0059_body and i_to_4digit_ascii_method_delay = 0 then
          simple_div_d_local <= i_to_4digit_ascii_x0_0014;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        simple_div_r_0001 <= (others => '0');
      else
        if simple_div_method = simple_div_method_S_0001 then
          simple_div_r_0001 <= simple_div_r_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        simple_div_r_local <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0004_body and i_to_4digit_ascii_method_delay = 0 then
          simple_div_r_local <= X"000003e8";
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0021_body and i_to_4digit_ascii_method_delay = 0 then
          simple_div_r_local <= X"00000064";
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0040_body and i_to_4digit_ascii_method_delay = 0 then
          simple_div_r_local <= X"0000000a";
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0059_body and i_to_4digit_ascii_method_delay = 0 then
          simple_div_r_local <= X"00000001";
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        simple_div_q_0002 <= X"00000000";
      else
        if simple_div_method = simple_div_method_S_0002 then
          simple_div_q_0002 <= X"00000000";
        elsif simple_div_method = simple_div_method_S_0007 then
          simple_div_q_0002 <= tmp_0017;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        simple_div_d0_0003 <= (others => '0');
      else
        if simple_div_method = simple_div_method_S_0002 then
          simple_div_d0_0003 <= simple_div_d_0000;
        elsif simple_div_method = simple_div_method_S_0007 then
          simple_div_d0_0003 <= tmp_0016;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00004 <= '0';
      else
        if simple_div_method = simple_div_method_S_0004 then
          binary_expr_00004 <= tmp_0015;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00005 <= (others => '0');
      else
        if simple_div_method = simple_div_method_S_0007 then
          binary_expr_00005 <= tmp_0016;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        unary_expr_00006 <= (others => '0');
      else
        if simple_div_method = simple_div_method_S_0007 then
          unary_expr_00006 <= tmp_0017;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        to_d_v_0007 <= (others => '0');
      else
        if to_d_method = to_d_method_S_0001 then
          to_d_v_0007 <= to_d_v_local;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        to_d_v_local <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0009_body and i_to_4digit_ascii_method_delay = 0 then
          to_d_v_local <= i_to_4digit_ascii_q_0013;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0028_body and i_to_4digit_ascii_method_delay = 0 then
          to_d_v_local <= i_to_4digit_ascii_q_0013;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0047_body and i_to_4digit_ascii_method_delay = 0 then
          to_d_v_local <= i_to_4digit_ascii_q_0013;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0061_body and i_to_4digit_ascii_method_delay = 0 then
          to_d_v_local <= i_to_4digit_ascii_q_0013;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00008 <= '0';
      else
        if to_d_method = to_d_method_S_0002 then
          binary_expr_00008 <= tmp_0028;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00009 <= '0';
      else
        if to_d_method = to_d_method_S_0002 then
          binary_expr_00009 <= tmp_0029;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00010 <= '0';
      else
        if to_d_method = to_d_method_S_0002 then
          binary_expr_00010 <= tmp_0030;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00011 <= (others => '0');
      else
        if to_d_method = to_d_method_S_0007 then
          binary_expr_00011 <= tmp_0031;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        i_to_4digit_ascii_x_0012 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0001 then
          i_to_4digit_ascii_x_0012 <= tmp_0078;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        i_to_4digit_ascii_q_0013 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0005 then
          i_to_4digit_ascii_q_0013 <= method_result_00016;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0022 then
          i_to_4digit_ascii_q_0013 <= method_result_00025;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0041 then
          i_to_4digit_ascii_q_0013 <= method_result_00036;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0060 then
          i_to_4digit_ascii_q_0013 <= method_result_00047;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        i_to_4digit_ascii_x0_0014 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0002 then
          i_to_4digit_ascii_x0_0014 <= i_to_4digit_ascii_x_0012;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0019 then
          i_to_4digit_ascii_x0_0014 <= tmp_0084;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0038 then
          i_to_4digit_ascii_x0_0014 <= tmp_0092;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0057 then
          i_to_4digit_ascii_x0_0014 <= tmp_0100;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        i_to_4digit_ascii_r_0015 <= X"00000000";
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0002 then
          i_to_4digit_ascii_r_0015 <= X"00000000";
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0010 then
          i_to_4digit_ascii_r_0015 <= tmp_0081;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0014 then
          i_to_4digit_ascii_r_0015 <= tmp_0083;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0029 then
          i_to_4digit_ascii_r_0015 <= tmp_0089;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0033 then
          i_to_4digit_ascii_r_0015 <= tmp_0091;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0048 then
          i_to_4digit_ascii_r_0015 <= tmp_0097;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0052 then
          i_to_4digit_ascii_r_0015 <= tmp_0099;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0062 then
          i_to_4digit_ascii_r_0015 <= tmp_0102;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00016 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0004_wait then
          method_result_00016 <= simple_div_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00017 <= '0';
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0005 then
          binary_expr_00017 <= tmp_0079;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00023 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0018 and i_to_4digit_ascii_method_delay >= 1 and u_synthesijer_mul32_i_to_4digit_ascii_valid = '1' then
          binary_expr_00023 <= u_synthesijer_mul32_i_to_4digit_ascii_result;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00024 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0019 then
          binary_expr_00024 <= tmp_0084;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00025 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0021_wait then
          method_result_00025 <= simple_div_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00026 <= '0';
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0022 then
          binary_expr_00026 <= tmp_0086;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00027 <= '0';
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0022 then
          binary_expr_00027 <= tmp_0085;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00028 <= '0';
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0022 then
          binary_expr_00028 <= tmp_0087;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00034 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0037 and i_to_4digit_ascii_method_delay >= 1 and u_synthesijer_mul32_i_to_4digit_ascii_valid = '1' then
          binary_expr_00034 <= u_synthesijer_mul32_i_to_4digit_ascii_result;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00035 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0038 then
          binary_expr_00035 <= tmp_0092;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00036 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0040_wait then
          method_result_00036 <= simple_div_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00037 <= '0';
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0041 then
          binary_expr_00037 <= tmp_0094;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00038 <= '0';
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0041 then
          binary_expr_00038 <= tmp_0093;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00039 <= '0';
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0041 then
          binary_expr_00039 <= tmp_0095;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00045 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0056 and i_to_4digit_ascii_method_delay >= 1 and u_synthesijer_mul32_i_to_4digit_ascii_valid = '1' then
          binary_expr_00045 <= u_synthesijer_mul32_i_to_4digit_ascii_result;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00046 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0057 then
          binary_expr_00046 <= tmp_0100;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00047 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0059_wait then
          method_result_00047 <= simple_div_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00048 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0061_wait then
          method_result_00048 <= to_d_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00049 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0062 then
          binary_expr_00049 <= tmp_0101;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00050 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0062 then
          binary_expr_00050 <= tmp_0102;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00018 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0009_wait then
          method_result_00018 <= to_d_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00019 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0010 then
          binary_expr_00019 <= tmp_0080;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00020 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0010 then
          binary_expr_00020 <= tmp_0081;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00021 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0014 then
          binary_expr_00021 <= tmp_0082;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00022 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0014 then
          binary_expr_00022 <= tmp_0083;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00029 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0028_wait then
          method_result_00029 <= to_d_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00030 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0029 then
          binary_expr_00030 <= tmp_0088;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00031 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0029 then
          binary_expr_00031 <= tmp_0089;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00032 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0033 then
          binary_expr_00032 <= tmp_0090;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00033 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0033 then
          binary_expr_00033 <= tmp_0091;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00040 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0047_wait then
          method_result_00040 <= to_d_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00041 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0048 then
          binary_expr_00041 <= tmp_0096;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00042 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0048 then
          binary_expr_00042 <= tmp_0097;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00043 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0052 then
          binary_expr_00043 <= tmp_0098;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00044 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0052 then
          binary_expr_00044 <= tmp_0099;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        isHex_v_0051 <= (others => '0');
      else
        if isHex_method = isHex_method_S_0001 then
          isHex_v_0051 <= tmp_0113;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00052 <= '0';
      else
        if isHex_method = isHex_method_S_0002 then
          binary_expr_00052 <= tmp_0114;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00053 <= '0';
      else
        if isHex_method = isHex_method_S_0002 then
          binary_expr_00053 <= tmp_0115;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00054 <= '0';
      else
        if isHex_method = isHex_method_S_0002 then
          binary_expr_00054 <= tmp_0120;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00055 <= '0';
      else
        if isHex_method = isHex_method_S_0002 then
          binary_expr_00055 <= tmp_0116;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00056 <= '0';
      else
        if isHex_method = isHex_method_S_0002 then
          binary_expr_00056 <= tmp_0117;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00057 <= '0';
      else
        if isHex_method = isHex_method_S_0002 then
          binary_expr_00057 <= tmp_0121;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00058 <= '0';
      else
        if isHex_method = isHex_method_S_0002 then
          binary_expr_00058 <= tmp_0123;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00059 <= '0';
      else
        if isHex_method = isHex_method_S_0002 then
          binary_expr_00059 <= tmp_0118;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00060 <= '0';
      else
        if isHex_method = isHex_method_S_0002 then
          binary_expr_00060 <= tmp_0119;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00061 <= '0';
      else
        if isHex_method = isHex_method_S_0002 then
          binary_expr_00061 <= tmp_0122;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00062 <= '0';
      else
        if isHex_method = isHex_method_S_0002 then
          binary_expr_00062 <= tmp_0124;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        toHex1_v_0063 <= (others => '0');
      else
        if toHex1_method = toHex1_method_S_0001 then
          toHex1_v_0063 <= tmp_0139;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        toHex1_v_local <= (others => '0');
      else
        if toHex2_method = toHex2_method_S_0003_body and toHex2_method_delay = 0 then
          toHex1_v_local <= toHex2_v0_0081;
        elsif toHex2_method = toHex2_method_S_0007_body and toHex2_method_delay = 0 then
          toHex1_v_local <= toHex2_v1_0082;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00064 <= '0';
      else
        if toHex1_method = toHex1_method_S_0002 then
          binary_expr_00064 <= tmp_0140;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00065 <= '0';
      else
        if toHex1_method = toHex1_method_S_0002 then
          binary_expr_00065 <= tmp_0141;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00066 <= '0';
      else
        if toHex1_method = toHex1_method_S_0002 then
          binary_expr_00066 <= tmp_0142;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00069 <= '0';
      else
        if toHex1_method = toHex1_method_S_0011 then
          binary_expr_00069 <= tmp_0145;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00070 <= '0';
      else
        if toHex1_method = toHex1_method_S_0011 then
          binary_expr_00070 <= tmp_0146;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00071 <= '0';
      else
        if toHex1_method = toHex1_method_S_0011 then
          binary_expr_00071 <= tmp_0147;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00075 <= '0';
      else
        if toHex1_method = toHex1_method_S_0021 then
          binary_expr_00075 <= tmp_0151;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00076 <= '0';
      else
        if toHex1_method = toHex1_method_S_0021 then
          binary_expr_00076 <= tmp_0152;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00077 <= '0';
      else
        if toHex1_method = toHex1_method_S_0021 then
          binary_expr_00077 <= tmp_0153;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00067 <= (others => '0');
      else
        if toHex1_method = toHex1_method_S_0007 then
          binary_expr_00067 <= tmp_0143;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00068 <= (others => '0');
      else
        if toHex1_method = toHex1_method_S_0007 then
          cast_expr_00068 <= tmp_0144;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00072 <= (others => '0');
      else
        if toHex1_method = toHex1_method_S_0016 then
          binary_expr_00072 <= tmp_0148;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00073 <= (others => '0');
      else
        if toHex1_method = toHex1_method_S_0016 then
          binary_expr_00073 <= tmp_0149;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00074 <= (others => '0');
      else
        if toHex1_method = toHex1_method_S_0016 then
          cast_expr_00074 <= tmp_0150;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00078 <= (others => '0');
      else
        if toHex1_method = toHex1_method_S_0026 then
          binary_expr_00078 <= tmp_0154;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00079 <= (others => '0');
      else
        if toHex1_method = toHex1_method_S_0026 then
          binary_expr_00079 <= tmp_0155;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00080 <= (others => '0');
      else
        if toHex1_method = toHex1_method_S_0026 then
          cast_expr_00080 <= tmp_0156;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        toHex2_v0_0081 <= (others => '0');
      else
        if toHex2_method = toHex2_method_S_0001 then
          toHex2_v0_0081 <= tmp_0173;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        toHex2_v1_0082 <= (others => '0');
      else
        if toHex2_method = toHex2_method_S_0001 then
          toHex2_v1_0082 <= tmp_0174;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        toHex2_r_0083 <= X"00000000";
      else
        if toHex2_method = toHex2_method_S_0002 then
          toHex2_r_0083 <= X"00000000";
        elsif toHex2_method = toHex2_method_S_0004 then
          toHex2_r_0083 <= tmp_0176;
        elsif toHex2_method = toHex2_method_S_0008 then
          toHex2_r_0083 <= tmp_0178;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00084 <= (others => '0');
      else
        if toHex2_method = toHex2_method_S_0003_wait then
          method_result_00084 <= toHex1_return_sig;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00085 <= (others => '0');
      else
        if toHex2_method = toHex2_method_S_0004 then
          binary_expr_00085 <= tmp_0175;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00086 <= (others => '0');
      else
        if toHex2_method = toHex2_method_S_0004 then
          binary_expr_00086 <= tmp_0176;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00087 <= (others => '0');
      else
        if toHex2_method = toHex2_method_S_0007_wait then
          method_result_00087 <= toHex1_return_sig;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00088 <= (others => '0');
      else
        if toHex2_method = toHex2_method_S_0008 then
          binary_expr_00088 <= tmp_0177;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00089 <= (others => '0');
      else
        if toHex2_method = toHex2_method_S_0008 then
          binary_expr_00089 <= tmp_0178;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        simple_div_return <= (others => '0');
      else
        if simple_div_method = simple_div_method_S_0012 then
          simple_div_return <= simple_div_q_0002;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        simple_div_busy <= '0';
      else
        if simple_div_method = simple_div_method_S_0000 then
          simple_div_busy <= '0';
        elsif simple_div_method = simple_div_method_S_0001 then
          simple_div_busy <= tmp_0008;
        end if;
      end if;
    end if;
  end process;

  simple_div_req_flag <= simple_div_req_local;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        simple_div_req_local <= '0';
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0004_body then
          simple_div_req_local <= '1';
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0021_body then
          simple_div_req_local <= '1';
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0040_body then
          simple_div_req_local <= '1';
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0059_body then
          simple_div_req_local <= '1';
        else
          simple_div_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        to_d_return <= (others => '0');
      else
        if to_d_method = to_d_method_S_0008 then
          to_d_return <= binary_expr_00011;
        elsif to_d_method = to_d_method_S_0010 then
          to_d_return <= X"00000020";
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        to_d_busy <= '0';
      else
        if to_d_method = to_d_method_S_0000 then
          to_d_busy <= '0';
        elsif to_d_method = to_d_method_S_0001 then
          to_d_busy <= tmp_0021;
        end if;
      end if;
    end if;
  end process;

  to_d_req_flag <= to_d_req_local;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        to_d_req_local <= '0';
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0009_body then
          to_d_req_local <= '1';
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0028_body then
          to_d_req_local <= '1';
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0047_body then
          to_d_req_local <= '1';
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0061_body then
          to_d_req_local <= '1';
        else
          to_d_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  i_to_4digit_ascii_req_flag <= tmp_0001;

  isHex_req_flag <= tmp_0002;

  toHex1_req_flag <= tmp_0003;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        toHex1_req_local <= '0';
      else
        if toHex2_method = toHex2_method_S_0003_body then
          toHex1_req_local <= '1';
        elsif toHex2_method = toHex2_method_S_0007_body then
          toHex1_req_local <= '1';
        else
          toHex1_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  toHex2_req_flag <= tmp_0004;

  simple_div_req_flag_edge <= tmp_0006;

  to_d_req_flag_edge <= tmp_0019;

  i_to_4digit_ascii_req_flag_edge <= tmp_0033;

  simple_div_call_flag_0004 <= tmp_0039;

  to_d_call_flag_0009 <= tmp_0045;

  u_synthesijer_mul32_i_to_4digit_ascii_clk <= clk_sig;

  u_synthesijer_mul32_i_to_4digit_ascii_reset <= reset_sig;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        u_synthesijer_mul32_i_to_4digit_ascii_a <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0018 and i_to_4digit_ascii_method_delay = 0 then
          u_synthesijer_mul32_i_to_4digit_ascii_a <= i_to_4digit_ascii_q_0013;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0037 and i_to_4digit_ascii_method_delay = 0 then
          u_synthesijer_mul32_i_to_4digit_ascii_a <= i_to_4digit_ascii_q_0013;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0056 and i_to_4digit_ascii_method_delay = 0 then
          u_synthesijer_mul32_i_to_4digit_ascii_a <= i_to_4digit_ascii_q_0013;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        u_synthesijer_mul32_i_to_4digit_ascii_b <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0018 and i_to_4digit_ascii_method_delay = 0 then
          u_synthesijer_mul32_i_to_4digit_ascii_b <= X"000003e8";
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0037 and i_to_4digit_ascii_method_delay = 0 then
          u_synthesijer_mul32_i_to_4digit_ascii_b <= X"00000064";
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0056 and i_to_4digit_ascii_method_delay = 0 then
          u_synthesijer_mul32_i_to_4digit_ascii_b <= X"0000000a";
        end if;
      end if;
    end if;
  end process;

  simple_div_call_flag_0021 <= tmp_0049;

  to_d_call_flag_0028 <= tmp_0055;

  simple_div_call_flag_0040 <= tmp_0059;

  to_d_call_flag_0047 <= tmp_0065;

  simple_div_call_flag_0059 <= tmp_0069;

  to_d_call_flag_0061 <= tmp_0073;

  isHex_req_flag_edge <= tmp_0104;

  toHex1_req_flag_edge <= tmp_0126;

  toHex2_req_flag_edge <= tmp_0158;

  toHex1_call_flag_0003 <= tmp_0164;

  toHex1_call_flag_0007 <= tmp_0168;


  inst_u_synthesijer_mul32_i_to_4digit_ascii : synthesijer_mul32
  port map(
    clk => u_synthesijer_mul32_i_to_4digit_ascii_clk,
    reset => u_synthesijer_mul32_i_to_4digit_ascii_reset,
    a => u_synthesijer_mul32_i_to_4digit_ascii_a,
    b => u_synthesijer_mul32_i_to_4digit_ascii_b,
    nd => u_synthesijer_mul32_i_to_4digit_ascii_nd,
    result => u_synthesijer_mul32_i_to_4digit_ascii_result,
    valid => u_synthesijer_mul32_i_to_4digit_ascii_valid
  );


end RTL;
