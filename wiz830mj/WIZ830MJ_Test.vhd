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
    wiz830mj_nBRDY : in std_logic;
    test_req : in std_logic;
    test_busy : out std_logic
  );
end WIZ830MJ_Test;

architecture RTL of WIZ830MJ_Test is

  component wiz830mj_iface
    port (
      clk : in std_logic;
      reset : in std_logic;
      address : in std_logic_vector(31-1 downto 0);
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
      nBRDY : in std_logic
    );
  end component wiz830mj_iface;

  signal clk_sig : std_logic;
  signal reset_sig : std_logic;
  signal test_req_sig : std_logic;
  signal test_busy_sig : std_logic;

  signal wiz830mj_clk : std_logic;
  signal wiz830mj_reset : std_logic;
  signal wiz830mj_address : std_logic_vector(31-1 downto 0) := (others => '0');
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
  signal wait_cycles_i_1 : signed(32-1 downto 0) := X"00000000";
  type Type_methodId is (
    IDLE,
    method_wait_cycles,
    method_write_data,
    method_read_data,
    method_init,
    method_test  
  );
  signal methodId : Type_methodId := IDLE;
  signal wait_cycles_n : signed(32-1 downto 0) := (others => '0');
  signal wait_cycles_req_local : std_logic := '0';
  signal tmp_0001 : std_logic;
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
  signal tmp_0002 : std_logic;
  signal tmp_0003 : std_logic;
  signal tmp_0004 : std_logic;
  signal tmp_0005 : std_logic;
  signal tmp_0006 : std_logic;
  signal tmp_0007 : std_logic;
  signal tmp_0008 : signed(32-1 downto 0);
  signal tmp_0009 : signed(32-1 downto 0);
  signal write_data_addr : signed(32-1 downto 0) := (others => '0');
  signal write_data_data : signed(8-1 downto 0) := (others => '0');
  signal write_data_req_local : std_logic := '0';
  signal tmp_0010 : std_logic;
  signal write_data_busy_sig : std_logic;
  type Type_S_write_data is (
    S_write_data_IDLE,
    S_write_data_S_write_data_0001,
    S_write_data_S_write_data_0002,
    S_write_data_S_write_data_0003,
    S_write_data_S_write_data_0004,
    S_write_data_S_write_data_0005,
    S_write_data_S_write_data_0006  
  );
  signal S_write_data : Type_S_write_data := S_write_data_IDLE;
  signal S_write_data_delay : signed(32-1 downto 0) := (others => '0');
  signal tmp_0011 : std_logic;
  signal tmp_0012 : std_logic;
  signal tmp_0013 : std_logic;
  signal tmp_0014 : signed(32-1 downto 0);
  signal wait_cycles_busy_sig_0015 : std_logic;
  signal tmp_0016 : std_logic;
  signal tmp_0017 : std_logic;
  signal tmp_0018 : std_logic;
  signal tmp_0019 : std_logic;
  signal tmp_0020 : std_logic;
  signal read_data_addr : signed(32-1 downto 0) := (others => '0');
  signal read_data_return_sig : signed(8-1 downto 0) := (others => '0');
  signal read_data_req_local : std_logic := '0';
  signal tmp_0021 : std_logic;
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
    S_read_data_S_read_data_0007  
  );
  signal S_read_data : Type_S_read_data := S_read_data_IDLE;
  signal S_read_data_delay : signed(32-1 downto 0) := (others => '0');
  signal tmp_0022 : std_logic;
  signal tmp_0023 : std_logic;
  signal tmp_0024 : std_logic;
  signal tmp_0025 : signed(32-1 downto 0);
  signal wait_cycles_busy_sig_0026 : std_logic;
  signal tmp_0027 : std_logic;
  signal tmp_0028 : std_logic;
  signal tmp_0029 : std_logic;
  signal tmp_0030 : std_logic;
  signal tmp_0031 : std_logic;
  signal init_req_local : std_logic := '0';
  signal tmp_0032 : std_logic;
  signal init_busy_sig : std_logic;
  type Type_S_init is (
    S_init_IDLE,
    S_init_S_init_0001,
    S_init_S_init_0002,
    S_init_S_init_0003,
    S_init_S_init_0004,
    S_init_S_init_0005,
    S_init_S_init_0006  
  );
  signal S_init : Type_S_init := S_init_IDLE;
  signal S_init_delay : signed(32-1 downto 0) := (others => '0');
  signal tmp_0033 : std_logic;
  signal tmp_0034 : std_logic;
  signal tmp_0035 : std_logic;
  signal tmp_0036 : std_logic;
  signal tmp_0037 : std_logic;
  signal tmp_0038 : std_logic;
  signal tmp_0039 : std_logic;
  signal test_req_local : std_logic := '0';
  signal tmp_0040 : std_logic;
  type Type_S_test is (
    S_test_IDLE,
    S_test_S_test_0001  
  );
  signal S_test : Type_S_test := S_test_IDLE;
  signal S_test_delay : signed(32-1 downto 0) := (others => '0');
  signal tmp_0041 : std_logic;
  signal tmp_0042 : std_logic;

begin

  clk_sig <= clk;
  reset_sig <= reset;
  test_req_sig <= test_req;
  test_busy <= test_busy_sig;
  test_busy_sig <= tmp_0042;


  -- expressions
  tmp_0001 <= '1' when wait_cycles_req_local = '1' else '0';
  tmp_0002 <= '1' when wait_cycles_i_1 < wait_cycles_n else '0';
  tmp_0003 <= '1' when tmp_0002 = '0' else '0';
  tmp_0004 <= '1' when wait_cycles_i_1 < wait_cycles_n else '0';
  tmp_0005 <= '1' when tmp_0004 = '1' else '0';
  tmp_0006 <= '1' when S_wait_cycles = S_wait_cycles_IDLE else '0';
  tmp_0007 <= '0' when tmp_0006 = '1' else '1';
  tmp_0008 <= X"00000000";
  tmp_0009 <= wait_cycles_i_1 + 1;
  tmp_0010 <= '1' when write_data_req_local = '1' else '0';
  tmp_0011 <= '1' when S_write_data = S_write_data_IDLE else '0';
  tmp_0012 <= '0' when tmp_0011 = '1' else '1';
  tmp_0013 <= '1';
  tmp_0014 <= X"00000000";
  tmp_0016 <= '1' when wait_cycles_busy_sig = '0' else '0';
  tmp_0017 <= '1' when wait_cycles_req_local = '0' else '0';
  tmp_0018 <= tmp_0016 and tmp_0017;
  tmp_0019 <= '1' when tmp_0018 = '1' else '0';
  tmp_0020 <= '0';
  tmp_0021 <= '1' when read_data_req_local = '1' else '0';
  tmp_0022 <= '1' when S_read_data = S_read_data_IDLE else '0';
  tmp_0023 <= '0' when tmp_0022 = '1' else '1';
  tmp_0024 <= '1';
  tmp_0025 <= X"00000000";
  tmp_0027 <= '1' when wait_cycles_busy_sig = '0' else '0';
  tmp_0028 <= '1' when wait_cycles_req_local = '0' else '0';
  tmp_0029 <= tmp_0027 and tmp_0028;
  tmp_0030 <= '1' when tmp_0029 = '1' else '0';
  tmp_0031 <= '0';
  tmp_0032 <= '1' when init_req_local = '1' else '0';
  tmp_0033 <= '1' when S_init = S_init_IDLE else '0';
  tmp_0034 <= '0' when tmp_0033 = '1' else '1';
  tmp_0035 <= '1';
  tmp_0036 <= '1';
  tmp_0037 <= '0';
  tmp_0038 <= '0';
  tmp_0039 <= '0';
  tmp_0040 <= test_req_sig or test_req_local;
  tmp_0041 <= '1' when S_test = S_test_IDLE else '0';
  tmp_0042 <= '0' when tmp_0041 = '1' else '1';

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
            if tmp_0001 = '1' then
              S_wait_cycles <= S_wait_cycles_S_wait_cycles_0004;
            end if;
          when S_wait_cycles_S_wait_cycles_0001 => 
            S_wait_cycles <= S_wait_cycles_IDLE;
          when S_wait_cycles_S_wait_cycles_0002 => 
            if tmp_0003 = '1' then
              S_wait_cycles <= S_wait_cycles_S_wait_cycles_0001;
            elsif tmp_0005 = '1' then
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
            if tmp_0010 = '1' then
              S_write_data <= S_write_data_S_write_data_0006;
            end if;
          when S_write_data_S_write_data_0001 => 
            S_write_data <= S_write_data_IDLE;
          when S_write_data_S_write_data_0002 => 
            S_write_data <= S_write_data_S_write_data_0001;
          when S_write_data_S_write_data_0003 => 
            if S_write_data_delay >= 1 and wait_cycles_busy_sig_0015 = '1' then
              S_write_data_delay <= (others => '0');
              S_write_data <= S_write_data_S_write_data_0002;
            else
              S_write_data_delay <= S_write_data_delay + 1;
            end if;
          when S_write_data_S_write_data_0004 => 
            S_write_data <= S_write_data_S_write_data_0003;
          when S_write_data_S_write_data_0005 => 
            S_write_data <= S_write_data_S_write_data_0004;
          when S_write_data_S_write_data_0006 => 
            S_write_data <= S_write_data_S_write_data_0005;
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
            if tmp_0021 = '1' then
              S_read_data <= S_read_data_S_read_data_0007;
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
            if S_read_data_delay >= 1 and wait_cycles_busy_sig_0026 = '1' then
              S_read_data_delay <= (others => '0');
              S_read_data <= S_read_data_S_read_data_0004;
            else
              S_read_data_delay <= S_read_data_delay + 1;
            end if;
          when S_read_data_S_read_data_0006 => 
            S_read_data <= S_read_data_S_read_data_0005;
          when S_read_data_S_read_data_0007 => 
            S_read_data <= S_read_data_S_read_data_0006;
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
            if tmp_0032 = '1' then
              S_init <= S_init_S_init_0006;
            end if;
          when S_init_S_init_0001 => 
            S_init <= S_init_IDLE;
          when S_init_S_init_0002 => 
            S_init <= S_init_S_init_0001;
          when S_init_S_init_0003 => 
            S_init <= S_init_S_init_0002;
          when S_init_S_init_0004 => 
            S_init <= S_init_S_init_0003;
          when S_init_S_init_0005 => 
            S_init <= S_init_S_init_0004;
          when S_init_S_init_0006 => 
            S_init <= S_init_S_init_0005;
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
            if tmp_0040 = '1' then
              S_test <= S_test_S_test_0001;
            end if;
          when S_test_S_test_0001 => 
            S_test <= S_test_IDLE;
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
        if S_write_data = S_write_data_S_write_data_0006 then
          wiz830mj_address <= std_logic_vector(write_data_addr);
        elsif S_read_data = S_read_data_S_read_data_0007 then
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
        if S_write_data = S_write_data_S_write_data_0005 then
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
        if S_init = S_init_S_init_0005 then
          wiz830mj_cs <= tmp_0036;
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
        if S_read_data = S_read_data_S_read_data_0006 then
          wiz830mj_oe <= tmp_0024;
        elsif S_read_data = S_read_data_S_read_data_0003 then
          wiz830mj_oe <= tmp_0031;
        elsif S_init = S_init_S_init_0002 then
          wiz830mj_oe <= tmp_0039;
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
        if S_write_data = S_write_data_S_write_data_0004 then
          wiz830mj_we <= tmp_0013;
        elsif S_write_data = S_write_data_S_write_data_0002 then
          wiz830mj_we <= tmp_0020;
        elsif S_init = S_init_S_init_0003 then
          wiz830mj_we <= tmp_0038;
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
        if S_init = S_init_S_init_0006 then
          wiz830mj_module_reset <= tmp_0035;
        elsif S_init = S_init_S_init_0004 then
          wiz830mj_module_reset <= tmp_0037;
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
          wait_cycles_i_1 <= tmp_0008;
        elsif S_wait_cycles = S_wait_cycles_S_wait_cycles_0003 then
          wait_cycles_i_1 <= tmp_0009;
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
        if S_write_data = S_write_data_S_write_data_0003 and S_write_data_delay = 0 then
          wait_cycles_n <= tmp_0014;
        elsif S_read_data = S_read_data_S_read_data_0005 and S_read_data_delay = 0 then
          wait_cycles_n <= tmp_0025;
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
        if S_write_data = S_write_data_S_write_data_0003 and S_write_data_delay = 0 then
          wait_cycles_req_local <= '1';
        elsif S_read_data = S_read_data_S_read_data_0005 and S_read_data_delay = 0 then
          wait_cycles_req_local <= '1';
        else
          wait_cycles_req_local <= '0';
        end if;
      end if;
    end if;
  end process;

  wait_cycles_busy_sig <= tmp_0007;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        write_data_req_local <= '0';
      else
        write_data_req_local <= '0';
      end if;
    end if;
  end process;

  write_data_busy_sig <= tmp_0012;

  wait_cycles_busy_sig_0015 <= tmp_0019;

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

  read_data_busy_sig <= tmp_0023;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        read_data_v_1 <= (others => '0');
      else
        if S_read_data = S_read_data_S_read_data_0004 then
          read_data_v_1 <= signed(wiz830mj_rdata);
        end if;
      end if;
    end if;
  end process;

  wait_cycles_busy_sig_0026 <= tmp_0030;

  process(clk)
  begin
    if clk'event and clk = '1' then
      if reset = '1' then
        init_req_local <= '0';
      else
        init_req_local <= '0';
      end if;
    end if;
  end process;

  init_busy_sig <= tmp_0034;

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
    nBRDY => wiz830mj_nBRDY
  );


end RTL;
