library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Misc is
  port (
    clk : in std_logic;
    reset : in std_logic;
    quant_in : in signed(32-1 downto 0);
    quant_we : in std_logic;
    quant_out : out signed(32-1 downto 0);
    remainder_in : in signed(32-1 downto 0);
    remainder_we : in std_logic;
    remainder_out : out signed(32-1 downto 0);
    simple_div_n : in signed(32-1 downto 0);
    simple_div_d : in signed(32-1 downto 0);
    i_to_4digit_ascii_x : in signed(32-1 downto 0);
    i_to_4digit_ascii_flag : in std_logic;
    isHex_v : in signed(8-1 downto 0);
    toHex1_v : in signed(8-1 downto 0);
    toHex2_v0 : in signed(8-1 downto 0);
    toHex2_v1 : in signed(8-1 downto 0);
    simple_div_return : out signed(32-1 downto 0);
    simple_div_busy : out std_logic;
    simple_div_req : in std_logic;
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


  signal clk_sig : std_logic;
  signal reset_sig : std_logic;
  signal quant_in_sig : signed(32-1 downto 0);
  signal quant_we_sig : std_logic;
  signal quant_out_sig : signed(32-1 downto 0);
  signal remainder_in_sig : signed(32-1 downto 0);
  signal remainder_we_sig : std_logic;
  signal remainder_out_sig : signed(32-1 downto 0);
  signal simple_div_n_sig : signed(32-1 downto 0);
  signal simple_div_d_sig : signed(32-1 downto 0);
  signal i_to_4digit_ascii_x_sig : signed(32-1 downto 0);
  signal i_to_4digit_ascii_flag_sig : std_logic;
  signal isHex_v_sig : signed(8-1 downto 0);
  signal toHex1_v_sig : signed(8-1 downto 0);
  signal toHex2_v0_sig : signed(8-1 downto 0);
  signal toHex2_v1_sig : signed(8-1 downto 0);
  signal simple_div_return_sig : signed(32-1 downto 0) := (others => '0');
  signal simple_div_busy_sig : std_logic := '1';
  signal simple_div_req_sig : std_logic;
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

  signal class_quant_0000 : signed(32-1 downto 0) := (others => '0');
  signal class_quant_0000_mux : signed(32-1 downto 0);
  signal tmp_0001 : signed(32-1 downto 0);
  signal class_remainder_0001 : signed(32-1 downto 0) := (others => '0');
  signal class_remainder_0001_mux : signed(32-1 downto 0);
  signal tmp_0002 : signed(32-1 downto 0);
  signal simple_div_n_0002 : signed(32-1 downto 0) := (others => '0');
  signal simple_div_n_local : signed(32-1 downto 0) := (others => '0');
  signal simple_div_d_0003 : signed(32-1 downto 0) := (others => '0');
  signal simple_div_d_local : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00004 : std_logic := '0';
  signal simple_div_q_0005 : signed(32-1 downto 0) := X"00000000";
  signal simple_div_r_0006 : signed(32-1 downto 0) := X"00000000";
  signal simple_div_v_0007 : signed(32-1 downto 0) := X"80000000";
  signal simple_div_i_0008 : signed(32-1 downto 0) := X"0000001f";
  signal binary_expr_00009 : std_logic := '0';
  signal unary_expr_00010 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00011 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00012 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00013 : std_logic := '0';
  signal binary_expr_00015 : std_logic := '0';
  signal binary_expr_00018 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00014 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00016 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00017 : signed(32-1 downto 0) := (others => '0');
  signal to_d_v_0019 : signed(32-1 downto 0) := (others => '0');
  signal to_d_v_local : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00020 : std_logic := '0';
  signal binary_expr_00021 : std_logic := '0';
  signal binary_expr_00022 : std_logic := '0';
  signal binary_expr_00023 : signed(32-1 downto 0) := (others => '0');
  signal i_to_4digit_ascii_x_0024 : signed(32-1 downto 0) := (others => '0');
  signal i_to_4digit_ascii_x_local : signed(32-1 downto 0) := (others => '0');
  signal i_to_4digit_ascii_flag_0025 : std_logic := '0';
  signal i_to_4digit_ascii_flag_local : std_logic := '0';
  signal i_to_4digit_ascii_x0_0026 : signed(32-1 downto 0) := (others => '0');
  signal i_to_4digit_ascii_r_0027 : signed(32-1 downto 0) := X"00000000";
  signal method_result_00028 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00029 : std_logic := '0';
  signal binary_expr_00030 : std_logic := '0';
  signal method_result_00036 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00037 : std_logic := '0';
  signal binary_expr_00038 : std_logic := '0';
  signal binary_expr_00039 : std_logic := '0';
  signal binary_expr_00040 : std_logic := '0';
  signal method_result_00046 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00047 : std_logic := '0';
  signal binary_expr_00048 : std_logic := '0';
  signal binary_expr_00049 : std_logic := '0';
  signal binary_expr_00050 : std_logic := '0';
  signal method_result_00056 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00057 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00058 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00059 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00031 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00032 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00033 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00034 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00035 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00041 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00042 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00043 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00044 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00045 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00051 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00052 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00053 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00054 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00055 : signed(32-1 downto 0) := (others => '0');
  signal isHex_v_0060 : signed(8-1 downto 0) := (others => '0');
  signal isHex_v_local : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00061 : std_logic := '0';
  signal binary_expr_00062 : std_logic := '0';
  signal binary_expr_00063 : std_logic := '0';
  signal binary_expr_00064 : std_logic := '0';
  signal binary_expr_00065 : std_logic := '0';
  signal binary_expr_00066 : std_logic := '0';
  signal binary_expr_00067 : std_logic := '0';
  signal binary_expr_00068 : std_logic := '0';
  signal binary_expr_00069 : std_logic := '0';
  signal binary_expr_00070 : std_logic := '0';
  signal binary_expr_00071 : std_logic := '0';
  signal toHex1_v_0072 : signed(8-1 downto 0) := (others => '0');
  signal toHex1_v_local : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00073 : std_logic := '0';
  signal binary_expr_00074 : std_logic := '0';
  signal binary_expr_00075 : std_logic := '0';
  signal binary_expr_00078 : std_logic := '0';
  signal binary_expr_00079 : std_logic := '0';
  signal binary_expr_00080 : std_logic := '0';
  signal binary_expr_00084 : std_logic := '0';
  signal binary_expr_00085 : std_logic := '0';
  signal binary_expr_00086 : std_logic := '0';
  signal binary_expr_00076 : signed(8-1 downto 0) := (others => '0');
  signal cast_expr_00077 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00081 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00082 : signed(8-1 downto 0) := (others => '0');
  signal cast_expr_00083 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00087 : signed(8-1 downto 0) := (others => '0');
  signal binary_expr_00088 : signed(8-1 downto 0) := (others => '0');
  signal cast_expr_00089 : signed(32-1 downto 0) := (others => '0');
  signal toHex2_v0_0090 : signed(8-1 downto 0) := (others => '0');
  signal toHex2_v0_local : signed(8-1 downto 0) := (others => '0');
  signal toHex2_v1_0091 : signed(8-1 downto 0) := (others => '0');
  signal toHex2_v1_local : signed(8-1 downto 0) := (others => '0');
  signal toHex2_r_0092 : signed(32-1 downto 0) := X"00000000";
  signal method_result_00093 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00094 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00095 : signed(32-1 downto 0) := (others => '0');
  signal method_result_00096 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00097 : signed(32-1 downto 0) := (others => '0');
  signal binary_expr_00098 : signed(32-1 downto 0) := (others => '0');
  signal simple_div_req_flag : std_logic;
  signal simple_div_req_local : std_logic := '0';
  signal tmp_0003 : std_logic;
  signal to_d_return : signed(32-1 downto 0) := (others => '0');
  signal to_d_busy : std_logic := '0';
  signal to_d_req_flag : std_logic;
  signal to_d_req_local : std_logic := '0';
  signal i_to_4digit_ascii_req_flag : std_logic;
  signal i_to_4digit_ascii_req_local : std_logic := '0';
  signal tmp_0004 : std_logic;
  signal isHex_req_flag : std_logic;
  signal isHex_req_local : std_logic := '0';
  signal tmp_0005 : std_logic;
  signal toHex1_req_flag : std_logic;
  signal toHex1_req_local : std_logic := '0';
  signal tmp_0006 : std_logic;
  signal toHex2_req_flag : std_logic;
  signal toHex2_req_local : std_logic := '0';
  signal tmp_0007 : std_logic;
  type Type_simple_div_method is (
    simple_div_method_IDLE,
    simple_div_method_S_0000,
    simple_div_method_S_0001,
    simple_div_method_S_0002,
    simple_div_method_S_0003,
    simple_div_method_S_0004,
    simple_div_method_S_0005,
    simple_div_method_S_0006,
    simple_div_method_S_0007,
    simple_div_method_S_0011,
    simple_div_method_S_0012,
    simple_div_method_S_0013,
    simple_div_method_S_0014,
    simple_div_method_S_0016,
    simple_div_method_S_0017,
    simple_div_method_S_0021,
    simple_div_method_S_0022,
    simple_div_method_S_0023,
    simple_div_method_S_0025,
    simple_div_method_S_0026,
    simple_div_method_S_0027,
    simple_div_method_S_0028,
    simple_div_method_S_0029,
    simple_div_method_S_0033,
    simple_div_method_S_0034,
    simple_div_method_S_0036,
    simple_div_method_S_0037,
    simple_div_method_S_0039,
    simple_div_method_S_0040  
  );
  signal simple_div_method : Type_simple_div_method := simple_div_method_IDLE;
  signal simple_div_method_delay : signed(32-1 downto 0) := (others => '0');
  signal simple_div_req_flag_d : std_logic := '0';
  signal simple_div_req_flag_edge : std_logic;
  signal tmp_0008 : std_logic;
  signal tmp_0009 : std_logic;
  signal tmp_0010 : std_logic;
  signal tmp_0011 : std_logic;
  signal tmp_0012 : std_logic;
  signal tmp_0013 : std_logic;
  signal tmp_0014 : std_logic;
  signal tmp_0015 : std_logic;
  signal tmp_0016 : std_logic;
  signal tmp_0017 : std_logic;
  signal tmp_0018 : std_logic;
  signal tmp_0019 : std_logic;
  signal tmp_0020 : std_logic;
  signal tmp_0021 : std_logic;
  signal tmp_0022 : std_logic;
  signal tmp_0023 : std_logic;
  signal tmp_0024 : signed(32-1 downto 0);
  signal tmp_0025 : signed(32-1 downto 0);
  signal tmp_0026 : std_logic;
  signal tmp_0027 : std_logic;
  signal tmp_0028 : signed(32-1 downto 0);
  signal tmp_0029 : signed(32-1 downto 0);
  signal tmp_0030 : signed(32-1 downto 0);
  signal tmp_0031 : std_logic;
  signal tmp_0032 : signed(32-1 downto 0);
  signal tmp_0033 : std_logic;
  signal tmp_0034 : signed(32-1 downto 0);
  signal tmp_0035 : signed(32-1 downto 0);
  signal tmp_0036 : signed(32-1 downto 0);
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
  signal tmp_0037 : std_logic;
  signal tmp_0038 : std_logic;
  signal tmp_0039 : std_logic;
  signal tmp_0040 : std_logic;
  signal tmp_0041 : std_logic;
  signal tmp_0042 : std_logic;
  signal tmp_0043 : std_logic;
  signal tmp_0044 : std_logic;
  signal tmp_0045 : std_logic;
  signal tmp_0046 : std_logic;
  signal tmp_0047 : std_logic;
  signal tmp_0048 : std_logic;
  signal tmp_0049 : std_logic;
  signal tmp_0050 : signed(32-1 downto 0);
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
    i_to_4digit_ascii_method_S_0020,
    i_to_4digit_ascii_method_S_0024,
    i_to_4digit_ascii_method_S_0025,
    i_to_4digit_ascii_method_S_0026,
    i_to_4digit_ascii_method_S_0027,
    i_to_4digit_ascii_method_S_0030,
    i_to_4digit_ascii_method_S_0031,
    i_to_4digit_ascii_method_S_0034,
    i_to_4digit_ascii_method_S_0035,
    i_to_4digit_ascii_method_S_0036,
    i_to_4digit_ascii_method_S_0037,
    i_to_4digit_ascii_method_S_0041,
    i_to_4digit_ascii_method_S_0042,
    i_to_4digit_ascii_method_S_0043,
    i_to_4digit_ascii_method_S_0044,
    i_to_4digit_ascii_method_S_0047,
    i_to_4digit_ascii_method_S_0048,
    i_to_4digit_ascii_method_S_0051,
    i_to_4digit_ascii_method_S_0052,
    i_to_4digit_ascii_method_S_0053,
    i_to_4digit_ascii_method_S_0054,
    i_to_4digit_ascii_method_S_0055,
    i_to_4digit_ascii_method_S_0058,
    i_to_4digit_ascii_method_S_0059,
    i_to_4digit_ascii_method_S_0004_body,
    i_to_4digit_ascii_method_S_0004_wait,
    i_to_4digit_ascii_method_S_0009_body,
    i_to_4digit_ascii_method_S_0009_wait,
    i_to_4digit_ascii_method_S_0019_body,
    i_to_4digit_ascii_method_S_0019_wait,
    i_to_4digit_ascii_method_S_0026_body,
    i_to_4digit_ascii_method_S_0026_wait,
    i_to_4digit_ascii_method_S_0036_body,
    i_to_4digit_ascii_method_S_0036_wait,
    i_to_4digit_ascii_method_S_0043_body,
    i_to_4digit_ascii_method_S_0043_wait,
    i_to_4digit_ascii_method_S_0053_body,
    i_to_4digit_ascii_method_S_0053_wait,
    i_to_4digit_ascii_method_S_0054_body,
    i_to_4digit_ascii_method_S_0054_wait  
  );
  signal i_to_4digit_ascii_method : Type_i_to_4digit_ascii_method := i_to_4digit_ascii_method_IDLE;
  signal i_to_4digit_ascii_method_delay : signed(32-1 downto 0) := (others => '0');
  signal i_to_4digit_ascii_req_flag_d : std_logic := '0';
  signal i_to_4digit_ascii_req_flag_edge : std_logic;
  signal tmp_0051 : std_logic;
  signal tmp_0052 : std_logic;
  signal tmp_0053 : std_logic;
  signal tmp_0054 : std_logic;
  signal simple_div_call_flag_0004 : std_logic;
  signal tmp_0055 : std_logic;
  signal tmp_0056 : std_logic;
  signal tmp_0057 : std_logic;
  signal tmp_0058 : std_logic;
  signal tmp_0059 : std_logic;
  signal tmp_0060 : std_logic;
  signal to_d_call_flag_0009 : std_logic;
  signal tmp_0061 : std_logic;
  signal tmp_0062 : std_logic;
  signal tmp_0063 : std_logic;
  signal tmp_0064 : std_logic;
  signal simple_div_call_flag_0019 : std_logic;
  signal tmp_0065 : std_logic;
  signal tmp_0066 : std_logic;
  signal tmp_0067 : std_logic;
  signal tmp_0068 : std_logic;
  signal tmp_0069 : std_logic;
  signal tmp_0070 : std_logic;
  signal to_d_call_flag_0026 : std_logic;
  signal tmp_0071 : std_logic;
  signal tmp_0072 : std_logic;
  signal tmp_0073 : std_logic;
  signal tmp_0074 : std_logic;
  signal simple_div_call_flag_0036 : std_logic;
  signal tmp_0075 : std_logic;
  signal tmp_0076 : std_logic;
  signal tmp_0077 : std_logic;
  signal tmp_0078 : std_logic;
  signal tmp_0079 : std_logic;
  signal tmp_0080 : std_logic;
  signal to_d_call_flag_0043 : std_logic;
  signal tmp_0081 : std_logic;
  signal tmp_0082 : std_logic;
  signal tmp_0083 : std_logic;
  signal tmp_0084 : std_logic;
  signal simple_div_call_flag_0053 : std_logic;
  signal tmp_0085 : std_logic;
  signal tmp_0086 : std_logic;
  signal tmp_0087 : std_logic;
  signal tmp_0088 : std_logic;
  signal to_d_call_flag_0054 : std_logic;
  signal tmp_0089 : std_logic;
  signal tmp_0090 : std_logic;
  signal tmp_0091 : std_logic;
  signal tmp_0092 : std_logic;
  signal tmp_0093 : std_logic;
  signal tmp_0094 : std_logic;
  signal tmp_0095 : std_logic;
  signal tmp_0096 : std_logic;
  signal tmp_0097 : signed(32-1 downto 0);
  signal tmp_0098 : std_logic;
  signal tmp_0099 : std_logic;
  signal tmp_0100 : std_logic;
  signal tmp_0101 : signed(32-1 downto 0);
  signal tmp_0102 : signed(32-1 downto 0);
  signal tmp_0103 : signed(32-1 downto 0);
  signal tmp_0104 : signed(32-1 downto 0);
  signal tmp_0105 : std_logic;
  signal tmp_0106 : std_logic;
  signal tmp_0107 : std_logic;
  signal tmp_0108 : std_logic;
  signal tmp_0109 : signed(32-1 downto 0);
  signal tmp_0110 : signed(32-1 downto 0);
  signal tmp_0111 : signed(32-1 downto 0);
  signal tmp_0112 : signed(32-1 downto 0);
  signal tmp_0113 : std_logic;
  signal tmp_0114 : std_logic;
  signal tmp_0115 : std_logic;
  signal tmp_0116 : std_logic;
  signal tmp_0117 : signed(32-1 downto 0);
  signal tmp_0118 : signed(32-1 downto 0);
  signal tmp_0119 : signed(32-1 downto 0);
  signal tmp_0120 : signed(32-1 downto 0);
  signal tmp_0121 : signed(32-1 downto 0);
  signal tmp_0122 : signed(32-1 downto 0);
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
  signal tmp_0123 : std_logic;
  signal tmp_0124 : std_logic;
  signal tmp_0125 : std_logic;
  signal tmp_0126 : std_logic;
  signal tmp_0127 : std_logic;
  signal tmp_0128 : std_logic;
  signal tmp_0129 : std_logic;
  signal tmp_0130 : std_logic;
  signal tmp_0131 : std_logic;
  signal tmp_0132 : std_logic;
  signal tmp_0133 : signed(8-1 downto 0);
  signal tmp_0134 : std_logic;
  signal tmp_0135 : std_logic;
  signal tmp_0136 : std_logic;
  signal tmp_0137 : std_logic;
  signal tmp_0138 : std_logic;
  signal tmp_0139 : std_logic;
  signal tmp_0140 : std_logic;
  signal tmp_0141 : std_logic;
  signal tmp_0142 : std_logic;
  signal tmp_0143 : std_logic;
  signal tmp_0144 : std_logic;
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
  signal tmp_0145 : std_logic;
  signal tmp_0146 : std_logic;
  signal tmp_0147 : std_logic;
  signal tmp_0148 : std_logic;
  signal tmp_0149 : std_logic;
  signal tmp_0150 : std_logic;
  signal tmp_0151 : std_logic;
  signal tmp_0152 : std_logic;
  signal tmp_0153 : std_logic;
  signal tmp_0154 : std_logic;
  signal tmp_0155 : std_logic;
  signal tmp_0156 : std_logic;
  signal tmp_0157 : std_logic;
  signal tmp_0158 : std_logic;
  signal tmp_0159 : signed(8-1 downto 0);
  signal tmp_0160 : std_logic;
  signal tmp_0161 : std_logic;
  signal tmp_0162 : std_logic;
  signal tmp_0163 : signed(8-1 downto 0);
  signal tmp_0164 : signed(32-1 downto 0);
  signal tmp_0165 : std_logic;
  signal tmp_0166 : std_logic;
  signal tmp_0167 : std_logic;
  signal tmp_0168 : signed(8-1 downto 0);
  signal tmp_0169 : signed(8-1 downto 0);
  signal tmp_0170 : signed(32-1 downto 0);
  signal tmp_0171 : std_logic;
  signal tmp_0172 : std_logic;
  signal tmp_0173 : std_logic;
  signal tmp_0174 : signed(8-1 downto 0);
  signal tmp_0175 : signed(8-1 downto 0);
  signal tmp_0176 : signed(32-1 downto 0);
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
  signal tmp_0177 : std_logic;
  signal tmp_0178 : std_logic;
  signal tmp_0179 : std_logic;
  signal tmp_0180 : std_logic;
  signal toHex1_call_flag_0003 : std_logic;
  signal tmp_0181 : std_logic;
  signal tmp_0182 : std_logic;
  signal tmp_0183 : std_logic;
  signal tmp_0184 : std_logic;
  signal toHex1_call_flag_0007 : std_logic;
  signal tmp_0185 : std_logic;
  signal tmp_0186 : std_logic;
  signal tmp_0187 : std_logic;
  signal tmp_0188 : std_logic;
  signal tmp_0189 : std_logic;
  signal tmp_0190 : std_logic;
  signal tmp_0191 : std_logic;
  signal tmp_0192 : std_logic;
  signal tmp_0193 : signed(8-1 downto 0);
  signal tmp_0194 : signed(8-1 downto 0);
  signal tmp_0195 : signed(32-1 downto 0);
  signal tmp_0196 : signed(32-1 downto 0);
  signal tmp_0197 : signed(32-1 downto 0);
  signal tmp_0198 : signed(32-1 downto 0);

begin

  clk_sig <= clk;
  reset_sig <= reset;
  quant_in_sig <= quant_in;
  quant_we_sig <= quant_we;
  quant_out <= quant_out_sig;
  quant_out_sig <= class_quant_0000;

  remainder_in_sig <= remainder_in;
  remainder_we_sig <= remainder_we;
  remainder_out <= remainder_out_sig;
  remainder_out_sig <= class_remainder_0001;

  simple_div_n_sig <= simple_div_n;
  simple_div_d_sig <= simple_div_d;
  i_to_4digit_ascii_x_sig <= i_to_4digit_ascii_x;
  i_to_4digit_ascii_flag_sig <= i_to_4digit_ascii_flag;
  isHex_v_sig <= isHex_v;
  toHex1_v_sig <= toHex1_v;
  toHex2_v0_sig <= toHex2_v0;
  toHex2_v1_sig <= toHex2_v1;
  simple_div_return <= simple_div_return_sig;
  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        simple_div_return_sig <= (others => '0');
      else
        if simple_div_method = simple_div_method_S_0005 then
          simple_div_return_sig <= X"ffffffff";
        elsif simple_div_method = simple_div_method_S_0039 then
          simple_div_return_sig <= X"00000001";
        end if;
      end if;
    end if;
  end process;

  simple_div_busy <= simple_div_busy_sig;
  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        simple_div_busy_sig <= '1';
      else
        if simple_div_method = simple_div_method_S_0000 then
          simple_div_busy_sig <= '0';
        elsif simple_div_method = simple_div_method_S_0001 then
          simple_div_busy_sig <= tmp_0011;
        end if;
      end if;
    end if;
  end process;

  simple_div_req_sig <= simple_div_req;
  i_to_4digit_ascii_return <= i_to_4digit_ascii_return_sig;
  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        i_to_4digit_ascii_return_sig <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0058 then
          i_to_4digit_ascii_return_sig <= i_to_4digit_ascii_r_0027;
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
          i_to_4digit_ascii_busy_sig <= tmp_0054;
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
          isHex_busy_sig <= tmp_0126;
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
          toHex1_return_sig <= cast_expr_00077;
        elsif toHex1_method = toHex1_method_S_0019 then
          toHex1_return_sig <= cast_expr_00083;
        elsif toHex1_method = toHex1_method_S_0029 then
          toHex1_return_sig <= cast_expr_00089;
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
          toHex1_busy_sig <= tmp_0148;
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
          toHex2_return_sig <= toHex2_r_0092;
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
          toHex2_busy_sig <= tmp_0180;
        end if;
      end if;
    end if;
  end process;

  toHex2_req_sig <= toHex2_req;

  -- expressions
  tmp_0001 <= quant_in_sig when quant_we_sig = '1' else class_quant_0000;
  tmp_0002 <= remainder_in_sig when remainder_we_sig = '1' else class_remainder_0001;
  tmp_0003 <= simple_div_req_local or simple_div_req_sig;
  tmp_0004 <= i_to_4digit_ascii_req_local or i_to_4digit_ascii_req_sig;
  tmp_0005 <= isHex_req_local or isHex_req_sig;
  tmp_0006 <= toHex1_req_local or toHex1_req_sig;
  tmp_0007 <= toHex2_req_local or toHex2_req_sig;
  tmp_0008 <= not simple_div_req_flag_d;
  tmp_0009 <= simple_div_req_flag and tmp_0008;
  tmp_0010 <= simple_div_req_flag or simple_div_req_flag_d;
  tmp_0011 <= simple_div_req_flag or simple_div_req_flag_d;
  tmp_0012 <= '1' when binary_expr_00004 = '1' else '0';
  tmp_0013 <= '1' when binary_expr_00004 = '0' else '0';
  tmp_0014 <= '1' when binary_expr_00009 = '1' else '0';
  tmp_0015 <= '1' when binary_expr_00009 = '0' else '0';
  tmp_0016 <= '1' when binary_expr_00013 = '1' else '0';
  tmp_0017 <= '1' when binary_expr_00013 = '0' else '0';
  tmp_0018 <= '1' when binary_expr_00015 = '1' else '0';
  tmp_0019 <= '1' when binary_expr_00015 = '0' else '0';
  tmp_0020 <= '1' when simple_div_method /= simple_div_method_S_0000 else '0';
  tmp_0021 <= '1' when simple_div_method /= simple_div_method_S_0001 else '0';
  tmp_0022 <= tmp_0021 and simple_div_req_flag_edge;
  tmp_0023 <= tmp_0020 and tmp_0022;
  tmp_0024 <= simple_div_n_sig when simple_div_req_sig = '1' else simple_div_n_local;
  tmp_0025 <= simple_div_d_sig when simple_div_req_sig = '1' else simple_div_d_local;
  tmp_0026 <= '1' when simple_div_d_0003 = X"00000000" else '0';
  tmp_0027 <= '1' when simple_div_i_0008 >= X"00000000" else '0';
  tmp_0028 <= simple_div_i_0008 - X"00000001";
  tmp_0029 <= simple_div_r_0006(30 downto 0) & (1-1 downto 0 => '0');
  tmp_0030 <= simple_div_n_0002 and simple_div_v_0007;
  tmp_0031 <= '1' when tmp_0030 /= X"00000000" else '0';
  tmp_0032 <= simple_div_r_0006 or X"00000001";
  tmp_0033 <= '1' when simple_div_r_0006 >= simple_div_d_0003 else '0';
  tmp_0034 <= simple_div_r_0006 - simple_div_d_0003;
  tmp_0035 <= simple_div_q_0005 or simple_div_v_0007;
  tmp_0036 <= (1-1 downto 0 => '0') & simple_div_v_0007(31 downto 1);
  tmp_0037 <= not to_d_req_flag_d;
  tmp_0038 <= to_d_req_flag and tmp_0037;
  tmp_0039 <= to_d_req_flag or to_d_req_flag_d;
  tmp_0040 <= to_d_req_flag or to_d_req_flag_d;
  tmp_0041 <= '1' when binary_expr_00022 = '1' else '0';
  tmp_0042 <= '1' when binary_expr_00022 = '0' else '0';
  tmp_0043 <= '1' when to_d_method /= to_d_method_S_0000 else '0';
  tmp_0044 <= '1' when to_d_method /= to_d_method_S_0001 else '0';
  tmp_0045 <= tmp_0044 and to_d_req_flag_edge;
  tmp_0046 <= tmp_0043 and tmp_0045;
  tmp_0047 <= '1' when X"00000000" <= to_d_v_0019 else '0';
  tmp_0048 <= '1' when to_d_v_0019 <= X"00000009" else '0';
  tmp_0049 <= tmp_0047 and tmp_0048;
  tmp_0050 <= X"00000030" + to_d_v_0019;
  tmp_0051 <= not i_to_4digit_ascii_req_flag_d;
  tmp_0052 <= i_to_4digit_ascii_req_flag and tmp_0051;
  tmp_0053 <= i_to_4digit_ascii_req_flag or i_to_4digit_ascii_req_flag_d;
  tmp_0054 <= i_to_4digit_ascii_req_flag or i_to_4digit_ascii_req_flag_d;
  tmp_0055 <= '1' when simple_div_busy_sig = '0' else '0';
  tmp_0056 <= '1' when simple_div_req_local = '0' else '0';
  tmp_0057 <= tmp_0055 and tmp_0056;
  tmp_0058 <= '1' when tmp_0057 = '1' else '0';
  tmp_0059 <= '1' when binary_expr_00030 = '1' else '0';
  tmp_0060 <= '1' when binary_expr_00030 = '0' else '0';
  tmp_0061 <= '1' when to_d_busy = '0' else '0';
  tmp_0062 <= '1' when to_d_req_local = '0' else '0';
  tmp_0063 <= tmp_0061 and tmp_0062;
  tmp_0064 <= '1' when tmp_0063 = '1' else '0';
  tmp_0065 <= '1' when simple_div_busy_sig = '0' else '0';
  tmp_0066 <= '1' when simple_div_req_local = '0' else '0';
  tmp_0067 <= tmp_0065 and tmp_0066;
  tmp_0068 <= '1' when tmp_0067 = '1' else '0';
  tmp_0069 <= '1' when binary_expr_00040 = '1' else '0';
  tmp_0070 <= '1' when binary_expr_00040 = '0' else '0';
  tmp_0071 <= '1' when to_d_busy = '0' else '0';
  tmp_0072 <= '1' when to_d_req_local = '0' else '0';
  tmp_0073 <= tmp_0071 and tmp_0072;
  tmp_0074 <= '1' when tmp_0073 = '1' else '0';
  tmp_0075 <= '1' when simple_div_busy_sig = '0' else '0';
  tmp_0076 <= '1' when simple_div_req_local = '0' else '0';
  tmp_0077 <= tmp_0075 and tmp_0076;
  tmp_0078 <= '1' when tmp_0077 = '1' else '0';
  tmp_0079 <= '1' when binary_expr_00050 = '1' else '0';
  tmp_0080 <= '1' when binary_expr_00050 = '0' else '0';
  tmp_0081 <= '1' when to_d_busy = '0' else '0';
  tmp_0082 <= '1' when to_d_req_local = '0' else '0';
  tmp_0083 <= tmp_0081 and tmp_0082;
  tmp_0084 <= '1' when tmp_0083 = '1' else '0';
  tmp_0085 <= '1' when simple_div_busy_sig = '0' else '0';
  tmp_0086 <= '1' when simple_div_req_local = '0' else '0';
  tmp_0087 <= tmp_0085 and tmp_0086;
  tmp_0088 <= '1' when tmp_0087 = '1' else '0';
  tmp_0089 <= '1' when to_d_busy = '0' else '0';
  tmp_0090 <= '1' when to_d_req_local = '0' else '0';
  tmp_0091 <= tmp_0089 and tmp_0090;
  tmp_0092 <= '1' when tmp_0091 = '1' else '0';
  tmp_0093 <= '1' when i_to_4digit_ascii_method /= i_to_4digit_ascii_method_S_0000 else '0';
  tmp_0094 <= '1' when i_to_4digit_ascii_method /= i_to_4digit_ascii_method_S_0001 else '0';
  tmp_0095 <= tmp_0094 and i_to_4digit_ascii_req_flag_edge;
  tmp_0096 <= tmp_0093 and tmp_0095;
  tmp_0097 <= i_to_4digit_ascii_x_sig when i_to_4digit_ascii_req_sig = '1' else i_to_4digit_ascii_x_local;
  tmp_0098 <= i_to_4digit_ascii_flag_sig when i_to_4digit_ascii_req_sig = '1' else i_to_4digit_ascii_flag_local;
  tmp_0099 <= '1' when class_quant_0000 > X"00000000" else '0';
  tmp_0100 <= tmp_0099 or i_to_4digit_ascii_flag_0025;
  tmp_0101 <= method_result_00031(7 downto 0) & (24-1 downto 0 => '0');
  tmp_0102 <= i_to_4digit_ascii_r_0027 + tmp_0101;
  tmp_0103 <= X"20000000";
  tmp_0104 <= i_to_4digit_ascii_r_0027 + tmp_0103;
  tmp_0105 <= '1' when class_quant_0000 > X"00000000" else '0';
  tmp_0106 <= '1' when i_to_4digit_ascii_r_0027 > X"20000000" else '0';
  tmp_0107 <= tmp_0105 or tmp_0106;
  tmp_0108 <= tmp_0107 or i_to_4digit_ascii_flag_0025;
  tmp_0109 <= method_result_00041(15 downto 0) & (16-1 downto 0 => '0');
  tmp_0110 <= i_to_4digit_ascii_r_0027 + tmp_0109;
  tmp_0111 <= X"00200000";
  tmp_0112 <= i_to_4digit_ascii_r_0027 + tmp_0111;
  tmp_0113 <= '1' when class_quant_0000 > X"00000000" else '0';
  tmp_0114 <= '1' when i_to_4digit_ascii_r_0027 > X"20200000" else '0';
  tmp_0115 <= tmp_0113 or tmp_0114;
  tmp_0116 <= tmp_0115 or i_to_4digit_ascii_flag_0025;
  tmp_0117 <= method_result_00051(23 downto 0) & (8-1 downto 0 => '0');
  tmp_0118 <= i_to_4digit_ascii_r_0027 + tmp_0117;
  tmp_0119 <= X"00002000";
  tmp_0120 <= i_to_4digit_ascii_r_0027 + tmp_0119;
  tmp_0121 <= method_result_00057;
  tmp_0122 <= i_to_4digit_ascii_r_0027 + tmp_0121;
  tmp_0123 <= not isHex_req_flag_d;
  tmp_0124 <= isHex_req_flag and tmp_0123;
  tmp_0125 <= isHex_req_flag or isHex_req_flag_d;
  tmp_0126 <= isHex_req_flag or isHex_req_flag_d;
  tmp_0127 <= '1' when binary_expr_00071 = '1' else '0';
  tmp_0128 <= '1' when binary_expr_00071 = '0' else '0';
  tmp_0129 <= '1' when isHex_method /= isHex_method_S_0000 else '0';
  tmp_0130 <= '1' when isHex_method /= isHex_method_S_0001 else '0';
  tmp_0131 <= tmp_0130 and isHex_req_flag_edge;
  tmp_0132 <= tmp_0129 and tmp_0131;
  tmp_0133 <= isHex_v_sig when isHex_req_sig = '1' else isHex_v_local;
  tmp_0134 <= '1' when X"30" <= isHex_v_0060 else '0';
  tmp_0135 <= '1' when isHex_v_0060 <= X"39" else '0';
  tmp_0136 <= '1' when X"61" <= isHex_v_0060 else '0';
  tmp_0137 <= '1' when isHex_v_0060 <= X"66" else '0';
  tmp_0138 <= '1' when X"41" <= isHex_v_0060 else '0';
  tmp_0139 <= '1' when isHex_v_0060 <= X"46" else '0';
  tmp_0140 <= tmp_0134 and tmp_0135;
  tmp_0141 <= tmp_0136 and tmp_0137;
  tmp_0142 <= tmp_0138 and tmp_0139;
  tmp_0143 <= tmp_0140 or tmp_0141;
  tmp_0144 <= tmp_0143 or tmp_0142;
  tmp_0145 <= not toHex1_req_flag_d;
  tmp_0146 <= toHex1_req_flag and tmp_0145;
  tmp_0147 <= toHex1_req_flag or toHex1_req_flag_d;
  tmp_0148 <= toHex1_req_flag or toHex1_req_flag_d;
  tmp_0149 <= '1' when binary_expr_00075 = '1' else '0';
  tmp_0150 <= '1' when binary_expr_00075 = '0' else '0';
  tmp_0151 <= '1' when binary_expr_00080 = '1' else '0';
  tmp_0152 <= '1' when binary_expr_00080 = '0' else '0';
  tmp_0153 <= '1' when binary_expr_00086 = '1' else '0';
  tmp_0154 <= '1' when binary_expr_00086 = '0' else '0';
  tmp_0155 <= '1' when toHex1_method /= toHex1_method_S_0000 else '0';
  tmp_0156 <= '1' when toHex1_method /= toHex1_method_S_0001 else '0';
  tmp_0157 <= tmp_0156 and toHex1_req_flag_edge;
  tmp_0158 <= tmp_0155 and tmp_0157;
  tmp_0159 <= toHex1_v_sig when toHex1_req_sig = '1' else toHex1_v_local;
  tmp_0160 <= '1' when X"30" <= toHex1_v_0072 else '0';
  tmp_0161 <= '1' when toHex1_v_0072 <= X"39" else '0';
  tmp_0162 <= tmp_0160 and tmp_0161;
  tmp_0163 <= toHex1_v_0072 - X"30";
  tmp_0164 <= (32-1 downto 8 => tmp_0163(7)) & tmp_0163;
  tmp_0165 <= '1' when X"61" <= toHex1_v_0072 else '0';
  tmp_0166 <= '1' when toHex1_v_0072 <= X"66" else '0';
  tmp_0167 <= tmp_0165 and tmp_0166;
  tmp_0168 <= toHex1_v_0072 - X"61";
  tmp_0169 <= tmp_0168 + X"0a";
  tmp_0170 <= (32-1 downto 8 => tmp_0169(7)) & tmp_0169;
  tmp_0171 <= '1' when X"41" <= toHex1_v_0072 else '0';
  tmp_0172 <= '1' when toHex1_v_0072 <= X"46" else '0';
  tmp_0173 <= tmp_0171 and tmp_0172;
  tmp_0174 <= toHex1_v_0072 - X"41";
  tmp_0175 <= tmp_0174 + X"0a";
  tmp_0176 <= (32-1 downto 8 => tmp_0175(7)) & tmp_0175;
  tmp_0177 <= not toHex2_req_flag_d;
  tmp_0178 <= toHex2_req_flag and tmp_0177;
  tmp_0179 <= toHex2_req_flag or toHex2_req_flag_d;
  tmp_0180 <= toHex2_req_flag or toHex2_req_flag_d;
  tmp_0181 <= '1' when toHex1_busy_sig = '0' else '0';
  tmp_0182 <= '1' when toHex1_req_local = '0' else '0';
  tmp_0183 <= tmp_0181 and tmp_0182;
  tmp_0184 <= '1' when tmp_0183 = '1' else '0';
  tmp_0185 <= '1' when toHex1_busy_sig = '0' else '0';
  tmp_0186 <= '1' when toHex1_req_local = '0' else '0';
  tmp_0187 <= tmp_0185 and tmp_0186;
  tmp_0188 <= '1' when tmp_0187 = '1' else '0';
  tmp_0189 <= '1' when toHex2_method /= toHex2_method_S_0000 else '0';
  tmp_0190 <= '1' when toHex2_method /= toHex2_method_S_0001 else '0';
  tmp_0191 <= tmp_0190 and toHex2_req_flag_edge;
  tmp_0192 <= tmp_0189 and tmp_0191;
  tmp_0193 <= toHex2_v0_sig when toHex2_req_sig = '1' else toHex2_v0_local;
  tmp_0194 <= toHex2_v1_sig when toHex2_req_sig = '1' else toHex2_v1_local;
  tmp_0195 <= method_result_00093(27 downto 0) & (4-1 downto 0 => '0');
  tmp_0196 <= toHex2_r_0092 + tmp_0195;
  tmp_0197 <= method_result_00096;
  tmp_0198 <= toHex2_r_0092 + tmp_0197;

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
            if tmp_0010 = '1' then
              simple_div_method <= simple_div_method_S_0002;
            end if;
          when simple_div_method_S_0002 => 
            simple_div_method <= simple_div_method_S_0003;
          when simple_div_method_S_0003 => 
            if tmp_0012 = '1' then
              simple_div_method <= simple_div_method_S_0005;
            elsif tmp_0013 = '1' then
              simple_div_method <= simple_div_method_S_0004;
            end if;
          when simple_div_method_S_0004 => 
            simple_div_method <= simple_div_method_S_0007;
          when simple_div_method_S_0005 => 
            simple_div_method <= simple_div_method_S_0000;
          when simple_div_method_S_0006 => 
            simple_div_method <= simple_div_method_S_0004;
          when simple_div_method_S_0007 => 
            simple_div_method <= simple_div_method_S_0011;
          when simple_div_method_S_0011 => 
            simple_div_method <= simple_div_method_S_0012;
          when simple_div_method_S_0012 => 
            if tmp_0014 = '1' then
              simple_div_method <= simple_div_method_S_0017;
            elsif tmp_0015 = '1' then
              simple_div_method <= simple_div_method_S_0013;
            end if;
          when simple_div_method_S_0013 => 
            simple_div_method <= simple_div_method_S_0037;
          when simple_div_method_S_0014 => 
            simple_div_method <= simple_div_method_S_0016;
          when simple_div_method_S_0016 => 
            simple_div_method <= simple_div_method_S_0011;
          when simple_div_method_S_0017 => 
            simple_div_method <= simple_div_method_S_0021;
          when simple_div_method_S_0021 => 
            if tmp_0016 = '1' then
              simple_div_method <= simple_div_method_S_0023;
            elsif tmp_0017 = '1' then
              simple_div_method <= simple_div_method_S_0022;
            end if;
          when simple_div_method_S_0022 => 
            simple_div_method <= simple_div_method_S_0026;
          when simple_div_method_S_0023 => 
            simple_div_method <= simple_div_method_S_0025;
          when simple_div_method_S_0025 => 
            simple_div_method <= simple_div_method_S_0022;
          when simple_div_method_S_0026 => 
            simple_div_method <= simple_div_method_S_0027;
          when simple_div_method_S_0027 => 
            if tmp_0018 = '1' then
              simple_div_method <= simple_div_method_S_0029;
            elsif tmp_0019 = '1' then
              simple_div_method <= simple_div_method_S_0028;
            end if;
          when simple_div_method_S_0028 => 
            simple_div_method <= simple_div_method_S_0034;
          when simple_div_method_S_0029 => 
            simple_div_method <= simple_div_method_S_0033;
          when simple_div_method_S_0033 => 
            simple_div_method <= simple_div_method_S_0028;
          when simple_div_method_S_0034 => 
            simple_div_method <= simple_div_method_S_0036;
          when simple_div_method_S_0036 => 
            simple_div_method <= simple_div_method_S_0014;
          when simple_div_method_S_0037 => 
            simple_div_method <= simple_div_method_S_0039;
          when simple_div_method_S_0039 => 
            simple_div_method <= simple_div_method_S_0000;
          when simple_div_method_S_0040 => 
            simple_div_method <= simple_div_method_S_0000;
          when others => null;
        end case;
        simple_div_req_flag_d <= simple_div_req_flag;
        if (tmp_0020 and tmp_0022) = '1' then
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
            if tmp_0039 = '1' then
              to_d_method <= to_d_method_S_0002;
            end if;
          when to_d_method_S_0002 => 
            to_d_method <= to_d_method_S_0005;
          when to_d_method_S_0005 => 
            if tmp_0041 = '1' then
              to_d_method <= to_d_method_S_0007;
            elsif tmp_0042 = '1' then
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
        if (tmp_0043 and tmp_0045) = '1' then
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
            if tmp_0053 = '1' then
              i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0002;
            end if;
          when i_to_4digit_ascii_method_S_0002 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0004;
          when i_to_4digit_ascii_method_S_0004 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0004_body;
          when i_to_4digit_ascii_method_S_0005 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0007;
          when i_to_4digit_ascii_method_S_0007 => 
            if tmp_0059 = '1' then
              i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0009;
            elsif tmp_0060 = '1' then
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
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0019;
          when i_to_4digit_ascii_method_S_0019 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0019_body;
          when i_to_4digit_ascii_method_S_0020 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0024;
          when i_to_4digit_ascii_method_S_0024 => 
            if tmp_0069 = '1' then
              i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0026;
            elsif tmp_0070 = '1' then
              i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0031;
            end if;
          when i_to_4digit_ascii_method_S_0025 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0035;
          when i_to_4digit_ascii_method_S_0026 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0026_body;
          when i_to_4digit_ascii_method_S_0027 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0030;
          when i_to_4digit_ascii_method_S_0030 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0025;
          when i_to_4digit_ascii_method_S_0031 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0034;
          when i_to_4digit_ascii_method_S_0034 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0025;
          when i_to_4digit_ascii_method_S_0035 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0036;
          when i_to_4digit_ascii_method_S_0036 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0036_body;
          when i_to_4digit_ascii_method_S_0037 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0041;
          when i_to_4digit_ascii_method_S_0041 => 
            if tmp_0079 = '1' then
              i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0043;
            elsif tmp_0080 = '1' then
              i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0048;
            end if;
          when i_to_4digit_ascii_method_S_0042 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0052;
          when i_to_4digit_ascii_method_S_0043 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0043_body;
          when i_to_4digit_ascii_method_S_0044 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0047;
          when i_to_4digit_ascii_method_S_0047 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0042;
          when i_to_4digit_ascii_method_S_0048 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0051;
          when i_to_4digit_ascii_method_S_0051 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0042;
          when i_to_4digit_ascii_method_S_0052 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0053;
          when i_to_4digit_ascii_method_S_0053 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0053_body;
          when i_to_4digit_ascii_method_S_0054 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0054_body;
          when i_to_4digit_ascii_method_S_0055 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0058;
          when i_to_4digit_ascii_method_S_0058 => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0000;
          when i_to_4digit_ascii_method_S_0059 => 
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
          when i_to_4digit_ascii_method_S_0019_body => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0019_wait;
          when i_to_4digit_ascii_method_S_0019_wait => 
            if simple_div_call_flag_0019 = '1' then
              i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0020;
            end if;
          when i_to_4digit_ascii_method_S_0026_body => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0026_wait;
          when i_to_4digit_ascii_method_S_0026_wait => 
            if to_d_call_flag_0026 = '1' then
              i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0027;
            end if;
          when i_to_4digit_ascii_method_S_0036_body => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0036_wait;
          when i_to_4digit_ascii_method_S_0036_wait => 
            if simple_div_call_flag_0036 = '1' then
              i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0037;
            end if;
          when i_to_4digit_ascii_method_S_0043_body => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0043_wait;
          when i_to_4digit_ascii_method_S_0043_wait => 
            if to_d_call_flag_0043 = '1' then
              i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0044;
            end if;
          when i_to_4digit_ascii_method_S_0053_body => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0053_wait;
          when i_to_4digit_ascii_method_S_0053_wait => 
            if simple_div_call_flag_0053 = '1' then
              i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0054;
            end if;
          when i_to_4digit_ascii_method_S_0054_body => 
            i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0054_wait;
          when i_to_4digit_ascii_method_S_0054_wait => 
            if to_d_call_flag_0054 = '1' then
              i_to_4digit_ascii_method <= i_to_4digit_ascii_method_S_0055;
            end if;
          when others => null;
        end case;
        i_to_4digit_ascii_req_flag_d <= i_to_4digit_ascii_req_flag;
        if (tmp_0093 and tmp_0095) = '1' then
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
            if tmp_0125 = '1' then
              isHex_method <= isHex_method_S_0002;
            end if;
          when isHex_method_S_0002 => 
            isHex_method <= isHex_method_S_0013;
          when isHex_method_S_0013 => 
            if tmp_0127 = '1' then
              isHex_method <= isHex_method_S_0015;
            elsif tmp_0128 = '1' then
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
        if (tmp_0129 and tmp_0131) = '1' then
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
            if tmp_0147 = '1' then
              toHex1_method <= toHex1_method_S_0002;
            end if;
          when toHex1_method_S_0002 => 
            toHex1_method <= toHex1_method_S_0005;
          when toHex1_method_S_0005 => 
            if tmp_0149 = '1' then
              toHex1_method <= toHex1_method_S_0007;
            elsif tmp_0150 = '1' then
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
            if tmp_0151 = '1' then
              toHex1_method <= toHex1_method_S_0016;
            elsif tmp_0152 = '1' then
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
            if tmp_0153 = '1' then
              toHex1_method <= toHex1_method_S_0026;
            elsif tmp_0154 = '1' then
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
        if (tmp_0155 and tmp_0157) = '1' then
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
            if tmp_0179 = '1' then
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
        if (tmp_0189 and tmp_0191) = '1' then
          toHex2_method <= toHex2_method_S_0001;
        end if;
      end if;
    end if;
  end process;


  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_quant_0000 <= (others => '0');
      else
        if simple_div_method = simple_div_method_S_0037 then
          class_quant_0000 <= simple_div_q_0005;
        else
          class_quant_0000 <= class_quant_0000_mux;
        end if;
      end if;
    end if;
  end process;

  class_quant_0000_mux <= tmp_0001;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        class_remainder_0001 <= (others => '0');
      else
        if simple_div_method = simple_div_method_S_0037 then
          class_remainder_0001 <= simple_div_r_0006;
        else
          class_remainder_0001 <= class_remainder_0001_mux;
        end if;
      end if;
    end if;
  end process;

  class_remainder_0001_mux <= tmp_0002;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        simple_div_n_0002 <= (others => '0');
      else
        if simple_div_method = simple_div_method_S_0001 then
          simple_div_n_0002 <= tmp_0024;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        simple_div_n_local <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0004_body and i_to_4digit_ascii_method_delay = 0 then
          simple_div_n_local <= i_to_4digit_ascii_x0_0026;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0019_body and i_to_4digit_ascii_method_delay = 0 then
          simple_div_n_local <= i_to_4digit_ascii_x0_0026;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0036_body and i_to_4digit_ascii_method_delay = 0 then
          simple_div_n_local <= i_to_4digit_ascii_x0_0026;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0053_body and i_to_4digit_ascii_method_delay = 0 then
          simple_div_n_local <= i_to_4digit_ascii_x0_0026;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        simple_div_d_0003 <= (others => '0');
      else
        if simple_div_method = simple_div_method_S_0001 then
          simple_div_d_0003 <= tmp_0025;
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
          simple_div_d_local <= X"000003e8";
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0019_body and i_to_4digit_ascii_method_delay = 0 then
          simple_div_d_local <= X"00000064";
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0036_body and i_to_4digit_ascii_method_delay = 0 then
          simple_div_d_local <= X"0000000a";
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0053_body and i_to_4digit_ascii_method_delay = 0 then
          simple_div_d_local <= X"00000001";
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
        if simple_div_method = simple_div_method_S_0002 then
          binary_expr_00004 <= tmp_0026;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        simple_div_q_0005 <= X"00000000";
      else
        if simple_div_method = simple_div_method_S_0007 then
          simple_div_q_0005 <= X"00000000";
        elsif simple_div_method = simple_div_method_S_0029 then
          simple_div_q_0005 <= tmp_0035;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        simple_div_r_0006 <= X"00000000";
      else
        if simple_div_method = simple_div_method_S_0007 then
          simple_div_r_0006 <= X"00000000";
        elsif simple_div_method = simple_div_method_S_0017 then
          simple_div_r_0006 <= tmp_0029;
        elsif simple_div_method = simple_div_method_S_0023 then
          simple_div_r_0006 <= tmp_0032;
        elsif simple_div_method = simple_div_method_S_0029 then
          simple_div_r_0006 <= tmp_0034;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        simple_div_v_0007 <= X"80000000";
      else
        if simple_div_method = simple_div_method_S_0007 then
          simple_div_v_0007 <= X"80000000";
        elsif simple_div_method = simple_div_method_S_0034 then
          simple_div_v_0007 <= tmp_0036;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        simple_div_i_0008 <= X"0000001f";
      else
        if simple_div_method = simple_div_method_S_0007 then
          simple_div_i_0008 <= X"0000001f";
        elsif simple_div_method = simple_div_method_S_0014 then
          simple_div_i_0008 <= tmp_0028;
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
        if simple_div_method = simple_div_method_S_0011 then
          binary_expr_00009 <= tmp_0027;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        unary_expr_00010 <= (others => '0');
      else
        if simple_div_method = simple_div_method_S_0014 then
          unary_expr_00010 <= tmp_0028;
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
        if simple_div_method = simple_div_method_S_0017 then
          binary_expr_00011 <= tmp_0029;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00012 <= (others => '0');
      else
        if simple_div_method = simple_div_method_S_0017 then
          binary_expr_00012 <= tmp_0030;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00013 <= '0';
      else
        if simple_div_method = simple_div_method_S_0017 then
          binary_expr_00013 <= tmp_0031;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00015 <= '0';
      else
        if simple_div_method = simple_div_method_S_0026 then
          binary_expr_00015 <= tmp_0033;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00018 <= (others => '0');
      else
        if simple_div_method = simple_div_method_S_0034 then
          binary_expr_00018 <= tmp_0036;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00014 <= (others => '0');
      else
        if simple_div_method = simple_div_method_S_0023 then
          binary_expr_00014 <= tmp_0032;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00016 <= (others => '0');
      else
        if simple_div_method = simple_div_method_S_0029 then
          binary_expr_00016 <= tmp_0034;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00017 <= (others => '0');
      else
        if simple_div_method = simple_div_method_S_0029 then
          binary_expr_00017 <= tmp_0035;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        to_d_v_0019 <= (others => '0');
      else
        if to_d_method = to_d_method_S_0001 then
          to_d_v_0019 <= to_d_v_local;
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
          to_d_v_local <= class_quant_0000;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0026_body and i_to_4digit_ascii_method_delay = 0 then
          to_d_v_local <= class_quant_0000;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0043_body and i_to_4digit_ascii_method_delay = 0 then
          to_d_v_local <= class_quant_0000;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0054_body and i_to_4digit_ascii_method_delay = 0 then
          to_d_v_local <= class_quant_0000;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00020 <= '0';
      else
        if to_d_method = to_d_method_S_0002 then
          binary_expr_00020 <= tmp_0047;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00021 <= '0';
      else
        if to_d_method = to_d_method_S_0002 then
          binary_expr_00021 <= tmp_0048;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00022 <= '0';
      else
        if to_d_method = to_d_method_S_0002 then
          binary_expr_00022 <= tmp_0049;
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
        if to_d_method = to_d_method_S_0007 then
          binary_expr_00023 <= tmp_0050;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        i_to_4digit_ascii_x_0024 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0001 then
          i_to_4digit_ascii_x_0024 <= tmp_0097;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        i_to_4digit_ascii_flag_0025 <= '0';
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0001 then
          i_to_4digit_ascii_flag_0025 <= tmp_0098;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        i_to_4digit_ascii_x0_0026 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0002 then
          i_to_4digit_ascii_x0_0026 <= i_to_4digit_ascii_x_0024;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0018 then
          i_to_4digit_ascii_x0_0026 <= class_remainder_0001;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0035 then
          i_to_4digit_ascii_x0_0026 <= class_remainder_0001;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0052 then
          i_to_4digit_ascii_x0_0026 <= class_remainder_0001;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        i_to_4digit_ascii_r_0027 <= X"00000000";
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0002 then
          i_to_4digit_ascii_r_0027 <= X"00000000";
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0010 then
          i_to_4digit_ascii_r_0027 <= tmp_0102;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0014 then
          i_to_4digit_ascii_r_0027 <= tmp_0104;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0027 then
          i_to_4digit_ascii_r_0027 <= tmp_0110;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0031 then
          i_to_4digit_ascii_r_0027 <= tmp_0112;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0044 then
          i_to_4digit_ascii_r_0027 <= tmp_0118;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0048 then
          i_to_4digit_ascii_r_0027 <= tmp_0120;
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0055 then
          i_to_4digit_ascii_r_0027 <= tmp_0122;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00028 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0004_wait then
          method_result_00028 <= simple_div_return_sig;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00029 <= '0';
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0005 then
          binary_expr_00029 <= tmp_0099;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00030 <= '0';
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0005 then
          binary_expr_00030 <= tmp_0100;
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
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0019_wait then
          method_result_00036 <= simple_div_return_sig;
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
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0020 then
          binary_expr_00037 <= tmp_0105;
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
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0020 then
          binary_expr_00038 <= tmp_0106;
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
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0020 then
          binary_expr_00039 <= tmp_0107;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00040 <= '0';
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0020 then
          binary_expr_00040 <= tmp_0108;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00046 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0036_wait then
          method_result_00046 <= simple_div_return_sig;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00047 <= '0';
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0037 then
          binary_expr_00047 <= tmp_0113;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00048 <= '0';
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0037 then
          binary_expr_00048 <= tmp_0114;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00049 <= '0';
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0037 then
          binary_expr_00049 <= tmp_0115;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00050 <= '0';
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0037 then
          binary_expr_00050 <= tmp_0116;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00056 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0053_wait then
          method_result_00056 <= simple_div_return_sig;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00057 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0054_wait then
          method_result_00057 <= to_d_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00058 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0055 then
          binary_expr_00058 <= tmp_0121;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00059 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0055 then
          binary_expr_00059 <= tmp_0122;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00031 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0009_wait then
          method_result_00031 <= to_d_return;
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
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0010 then
          binary_expr_00032 <= tmp_0101;
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
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0010 then
          binary_expr_00033 <= tmp_0102;
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
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0014 then
          binary_expr_00034 <= tmp_0103;
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
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0014 then
          binary_expr_00035 <= tmp_0104;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00041 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0026_wait then
          method_result_00041 <= to_d_return;
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
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0027 then
          binary_expr_00042 <= tmp_0109;
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
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0027 then
          binary_expr_00043 <= tmp_0110;
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
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0031 then
          binary_expr_00044 <= tmp_0111;
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
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0031 then
          binary_expr_00045 <= tmp_0112;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00051 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0043_wait then
          method_result_00051 <= to_d_return;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00052 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0044 then
          binary_expr_00052 <= tmp_0117;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00053 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0044 then
          binary_expr_00053 <= tmp_0118;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00054 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0048 then
          binary_expr_00054 <= tmp_0119;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00055 <= (others => '0');
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0048 then
          binary_expr_00055 <= tmp_0120;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        isHex_v_0060 <= (others => '0');
      else
        if isHex_method = isHex_method_S_0001 then
          isHex_v_0060 <= tmp_0133;
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
          binary_expr_00061 <= tmp_0134;
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
          binary_expr_00062 <= tmp_0135;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00063 <= '0';
      else
        if isHex_method = isHex_method_S_0002 then
          binary_expr_00063 <= tmp_0140;
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
        if isHex_method = isHex_method_S_0002 then
          binary_expr_00064 <= tmp_0136;
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
        if isHex_method = isHex_method_S_0002 then
          binary_expr_00065 <= tmp_0137;
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
        if isHex_method = isHex_method_S_0002 then
          binary_expr_00066 <= tmp_0141;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00067 <= '0';
      else
        if isHex_method = isHex_method_S_0002 then
          binary_expr_00067 <= tmp_0143;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00068 <= '0';
      else
        if isHex_method = isHex_method_S_0002 then
          binary_expr_00068 <= tmp_0138;
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
        if isHex_method = isHex_method_S_0002 then
          binary_expr_00069 <= tmp_0139;
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
        if isHex_method = isHex_method_S_0002 then
          binary_expr_00070 <= tmp_0142;
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
        if isHex_method = isHex_method_S_0002 then
          binary_expr_00071 <= tmp_0144;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        toHex1_v_0072 <= (others => '0');
      else
        if toHex1_method = toHex1_method_S_0001 then
          toHex1_v_0072 <= tmp_0159;
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
          toHex1_v_local <= toHex2_v0_0090;
        elsif toHex2_method = toHex2_method_S_0007_body and toHex2_method_delay = 0 then
          toHex1_v_local <= toHex2_v1_0091;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00073 <= '0';
      else
        if toHex1_method = toHex1_method_S_0002 then
          binary_expr_00073 <= tmp_0160;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00074 <= '0';
      else
        if toHex1_method = toHex1_method_S_0002 then
          binary_expr_00074 <= tmp_0161;
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
        if toHex1_method = toHex1_method_S_0002 then
          binary_expr_00075 <= tmp_0162;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00078 <= '0';
      else
        if toHex1_method = toHex1_method_S_0011 then
          binary_expr_00078 <= tmp_0165;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00079 <= '0';
      else
        if toHex1_method = toHex1_method_S_0011 then
          binary_expr_00079 <= tmp_0166;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00080 <= '0';
      else
        if toHex1_method = toHex1_method_S_0011 then
          binary_expr_00080 <= tmp_0167;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00084 <= '0';
      else
        if toHex1_method = toHex1_method_S_0021 then
          binary_expr_00084 <= tmp_0171;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00085 <= '0';
      else
        if toHex1_method = toHex1_method_S_0021 then
          binary_expr_00085 <= tmp_0172;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00086 <= '0';
      else
        if toHex1_method = toHex1_method_S_0021 then
          binary_expr_00086 <= tmp_0173;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00076 <= (others => '0');
      else
        if toHex1_method = toHex1_method_S_0007 then
          binary_expr_00076 <= tmp_0163;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00077 <= (others => '0');
      else
        if toHex1_method = toHex1_method_S_0007 then
          cast_expr_00077 <= tmp_0164;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00081 <= (others => '0');
      else
        if toHex1_method = toHex1_method_S_0016 then
          binary_expr_00081 <= tmp_0168;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00082 <= (others => '0');
      else
        if toHex1_method = toHex1_method_S_0016 then
          binary_expr_00082 <= tmp_0169;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00083 <= (others => '0');
      else
        if toHex1_method = toHex1_method_S_0016 then
          cast_expr_00083 <= tmp_0170;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00087 <= (others => '0');
      else
        if toHex1_method = toHex1_method_S_0026 then
          binary_expr_00087 <= tmp_0174;
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
        if toHex1_method = toHex1_method_S_0026 then
          binary_expr_00088 <= tmp_0175;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        cast_expr_00089 <= (others => '0');
      else
        if toHex1_method = toHex1_method_S_0026 then
          cast_expr_00089 <= tmp_0176;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        toHex2_v0_0090 <= (others => '0');
      else
        if toHex2_method = toHex2_method_S_0001 then
          toHex2_v0_0090 <= tmp_0193;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        toHex2_v1_0091 <= (others => '0');
      else
        if toHex2_method = toHex2_method_S_0001 then
          toHex2_v1_0091 <= tmp_0194;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        toHex2_r_0092 <= X"00000000";
      else
        if toHex2_method = toHex2_method_S_0002 then
          toHex2_r_0092 <= X"00000000";
        elsif toHex2_method = toHex2_method_S_0004 then
          toHex2_r_0092 <= tmp_0196;
        elsif toHex2_method = toHex2_method_S_0008 then
          toHex2_r_0092 <= tmp_0198;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00093 <= (others => '0');
      else
        if toHex2_method = toHex2_method_S_0003_wait then
          method_result_00093 <= toHex1_return_sig;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00094 <= (others => '0');
      else
        if toHex2_method = toHex2_method_S_0004 then
          binary_expr_00094 <= tmp_0195;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00095 <= (others => '0');
      else
        if toHex2_method = toHex2_method_S_0004 then
          binary_expr_00095 <= tmp_0196;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        method_result_00096 <= (others => '0');
      else
        if toHex2_method = toHex2_method_S_0007_wait then
          method_result_00096 <= toHex1_return_sig;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00097 <= (others => '0');
      else
        if toHex2_method = toHex2_method_S_0008 then
          binary_expr_00097 <= tmp_0197;
        end if;
      end if;
    end if;
  end process;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        binary_expr_00098 <= (others => '0');
      else
        if toHex2_method = toHex2_method_S_0008 then
          binary_expr_00098 <= tmp_0198;
        end if;
      end if;
    end if;
  end process;

  simple_div_req_flag <= tmp_0003;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        simple_div_req_local <= '0';
      else
        if i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0004_body then
          simple_div_req_local <= '1';
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0019_body then
          simple_div_req_local <= '1';
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0036_body then
          simple_div_req_local <= '1';
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0053_body then
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
          to_d_return <= binary_expr_00023;
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
          to_d_busy <= tmp_0040;
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
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0026_body then
          to_d_req_local <= '1';
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0043_body then
          to_d_req_local <= '1';
        elsif i_to_4digit_ascii_method = i_to_4digit_ascii_method_S_0054_body then
          to_d_req_local <= '1';
        else
          to_d_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  i_to_4digit_ascii_req_flag <= tmp_0004;

  isHex_req_flag <= tmp_0005;

  toHex1_req_flag <= tmp_0006;

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

  toHex2_req_flag <= tmp_0007;

  simple_div_req_flag_edge <= tmp_0009;

  to_d_req_flag_edge <= tmp_0038;

  i_to_4digit_ascii_req_flag_edge <= tmp_0052;

  simple_div_call_flag_0004 <= tmp_0058;

  to_d_call_flag_0009 <= tmp_0064;

  simple_div_call_flag_0019 <= tmp_0068;

  to_d_call_flag_0026 <= tmp_0074;

  simple_div_call_flag_0036 <= tmp_0078;

  to_d_call_flag_0043 <= tmp_0084;

  simple_div_call_flag_0053 <= tmp_0088;

  to_d_call_flag_0054 <= tmp_0092;

  isHex_req_flag_edge <= tmp_0124;

  toHex1_req_flag_edge <= tmp_0146;

  toHex2_req_flag_edge <= tmp_0178;

  toHex1_call_flag_0003 <= tmp_0184;

  toHex1_call_flag_0007 <= tmp_0188;



end RTL;
