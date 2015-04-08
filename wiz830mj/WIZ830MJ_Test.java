
public class WIZ830MJ_Test{

    private final WIZ830MJ_Iface wiz830mj = new WIZ830MJ_Iface();

    public int led;

    private void wait_cycles(int n){
	for(int i = 0; i < n; i++){;}
    }

    private void write_data(int addr, byte data){
	wiz830mj.address = addr;
	wiz830mj.wdata = data;
	wiz830mj.cs = true;
	wiz830mj.we = true;
	wait_cycles(3);
	wiz830mj.we = false;
	wiz830mj.cs = false;
    }

    private byte read_data(int addr){
	wiz830mj.address = addr;
	wiz830mj.cs = true;
	wiz830mj.oe = true;
	wait_cycles(5);
	byte v = wiz830mj.rdata;
	wiz830mj.oe = false;
	wiz830mj.cs = false;
	return v;
    }

    private void init(){
	wiz830mj.cs = false;
	wiz830mj.we = false;
	wiz830mj.oe = false;
	wiz830mj.module_reset = true;
	wait_cycles(1000);
	wiz830mj.module_reset = false;
	wait_cycles(1000);
    }

    private void network_configuration(){
	// SHAR(Source Hardware Address Register)
	write_data(0x0008, (byte)0x00);
	write_data(0x0009, (byte)0x08);
	write_data(0x000a, (byte)0xDC);
	write_data(0x000b, (byte)0x01);
	write_data(0x000c, (byte)0x02);
	write_data(0x000d, (byte)0x03);
	// GAR(Gateway IP Address Register)
	write_data(0x0010, (byte)10);
	write_data(0x0011, (byte)0);
	write_data(0x0012, (byte)0);
	write_data(0x0013, (byte)1);
	// SUBR(Subnet Mask Register)
	write_data(0x0014, (byte)255);
	write_data(0x0015, (byte)0);
	write_data(0x0016, (byte)0);
	write_data(0x0017, (byte)0);
	// SIPR(Source IP Register)
	write_data(0x0018, (byte)10);
	write_data(0x0019, (byte)0);
	write_data(0x001a, (byte)0);
	write_data(0x001b, (byte)2);
    }

    private final static int Sn_MR0       = 0x08200;
    private final static int Sn_MR1       = 0x08201;
    private final static int Sn_CR0       = 0x08202;
    private final static int Sn_CR1       = 0x08203;
    private final static int Sn_IMR0      = 0x08204;
    private final static int Sn_IMR1      = 0x08205;
    private final static int Sn_IR0       = 0x08206;
    private final static int Sn_IR1       = 0x08207;
    private final static int Sn_SSR0      = 0x08208;
    private final static int Sn_SSR1      = 0x08209;
    private final static int Sn_PORTR0    = 0x0820a;
    private final static int Sn_PORTR1    = 0x0820b;
    private final static int Sn_DHAR0     = 0x0820c;
    private final static int Sn_DHAR1     = 0x0820d;
    private final static int Sn_DHAR2     = 0x0820e;
    private final static int Sn_DHAR3     = 0x0820f;
    private final static int Sn_DHAR4     = 0x08210;
    private final static int Sn_DHAR5     = 0x08211;
    private final static int Sn_DPORTR0   = 0x08212;
    private final static int Sn_DPORTR1   = 0x08213;
    private final static int Sn_DIPR0     = 0x08214;
    private final static int Sn_DIPR1     = 0x08215;
    private final static int Sn_DIPR2     = 0x08216;
    private final static int Sn_DIPR3     = 0x08217;
    private final static int Sn_MSSR0     = 0x08218;
    private final static int Sn_MSSR1     = 0x08219;
    private final static int Sn_KPALVTR   = 0x0821a;
    private final static int Sn_PROTOR    = 0x0821b;
    private final static int Sn_TOSR0     = 0x0821c;
    private final static int Sn_TOSR1     = 0x0821d;
    private final static int Sn_TTLR0     = 0x0821e;
    private final static int Sn_TTLR1     = 0x0821f;
    private final static int Sn_TX_WRSR0  = 0x08220;
    private final static int Sn_TX_WRSR1  = 0x08221;
    private final static int Sn_TX_WRSR2  = 0x08222;
    private final static int Sn_TX_WRSR3  = 0x08223;
    private final static int Sn_TX_FSR0   = 0x08224;
    private final static int Sn_TX_FSR1   = 0x08225;
    private final static int Sn_TX_FSR2   = 0x08226;
    private final static int Sn_TX_FSR3   = 0x08227;
    private final static int Sn_RX_RSR0   = 0x08228;
    private final static int Sn_RX_RSR1   = 0x08229;
    private final static int Sn_RX_RSR2   = 0x0822a;
    private final static int Sn_RX_RSR3   = 0x0822b;
    private final static int Sn_FRAGR0    = 0x0822c;
    private final static int Sn_FRAGR1    = 0x0822d;
    private final static int Sn_TX_FIFOR0 = 0x0822e;
    private final static int Sn_TX_FIFOR1 = 0x0822f;
    private final static int Sn_RX_FIFOR0 = 0x08230;
    private final static int Sn_RX_FIFOR1 = 0x08231;

    private final static byte Sn_MR_CLOSE  = (byte)0;
    private final static byte Sn_MR_TCP    = (byte)1;
    private final static byte Sn_MR_UDP    = (byte)2;
    private final static byte Sn_MR_IPRAW  = (byte)3;
    private final static byte Sn_MR_MACRAW = (byte)4;
    private final static byte Sn_MR_PPPoE  = (byte)5;

    private final static byte Sn_CR_OPEN      = (byte)0x01;
    private final static byte Sn_CR_LISTEN    = (byte)0x02;
    private final static byte Sn_CR_CONNECT   = (byte)0x04;
    private final static byte Sn_CR_DISCON    = (byte)0x08;
    private final static byte Sn_CR_CLOSE     = (byte)0x10;
    private final static byte Sn_CR_SEND      = (byte)0x20;
    private final static byte Sn_CR_SEND_MAC  = (byte)0x21;
    private final static byte Sn_CR_SEND_KEEP = (byte)0x22;
    private final static byte Sn_CR_RECV      = (byte)0x40;

    private final static byte Sn_CR_PCON    = (byte)0x23;
    private final static byte Sn_CR_PDISCON = (byte)0x24;
    private final static byte Sn_CR_PCR     = (byte)0x25;
    private final static byte Sn_CR_PCN     = (byte)0x26;
    private final static byte Sn_CR_PCJ     = (byte)0x27;

    private final static byte Sn_SOCK_CLOSED      = (byte)0x00;
    private final static byte Sn_SOCK_INIT        = (byte)0x13;
    private final static byte Sn_SOCK_LISTEN      = (byte)0x14;
    private final static byte Sn_SOCK_ESTABLISHED = (byte)0x17;
    private final static byte Sn_SOCK_CLOSE_WAIT  = (byte)0x1C;
    private final static byte Sn_SOCK_UDP         = (byte)0x22;
    private final static byte Sn_SOCK_IPRAW       = (byte)0x32;
    private final static byte Sn_SOCK_MACRAW      = (byte)0x42;
    private final static byte Sn_SOCK_PPPoE       = (byte)0x5F;

    private final static byte Sn_SOCK_SYSSENT   = (byte)0x15;
    private final static byte Sn_SOCK_SYSRECV   = (byte)0x16;
    private final static byte Sn_SOCK_FIN_WAIT  = (byte)0x18;
    private final static byte Sn_SOCK_TIME_WAIT = (byte)0x1b;
    private final static byte Sn_SOCK_LAST_ACK  = (byte)0x1d;
    private final static byte Sn_SOCK_ARP       = (byte)0x01;

    private byte tcp_server_open(int port){
	write_data(Sn_MR1 + (port << 6), (byte)(0x20 | Sn_MR_TCP)); // S0_MR1: TCP mode
	//	write_data(Sn_MR0 + (port << 6), (byte)0x01); // Use alignment
	write_data(Sn_PORTR0 + (port << 6), (byte)0);
	write_data(Sn_PORTR1 + (port << 6), (byte)80); // port 80
	write_data(Sn_CR1 + (port << 6), Sn_CR_OPEN); // open
	return read_data(Sn_SSR1 + (port << 6));
    }

    private byte tcp_server_listen(int port){
	write_data(Sn_CR1 + (port << 6), Sn_CR_LISTEN);
	return read_data(Sn_SSR1 + (port << 6));
    }

    private void wait_for_established(int port){
	byte v = 0;
	while(true){
	    v = read_data(Sn_SSR1 + (port << 6));
	    if(v == Sn_SOCK_ESTABLISHED){
		return;
	    }
	}
    }

    private int wait_for_recv(int port){
	int v = 0;
	while(true){
	    v = 0;
	    int v0 = (int)read_data(Sn_RX_RSR1 + (port << 6));
	    int v1 = (int)read_data(Sn_RX_RSR2 + (port << 6));
	    int v2 = (int)read_data(Sn_RX_RSR3 + (port << 6));
	    v = (v0 << 16) + (v1 << 8) + v2;
	    if(v != 0){
		return v;
	    }

	    v = read_data(Sn_SSR1 + (port << 6));
	    if(v == Sn_SOCK_CLOSE_WAIT || v == Sn_SOCK_CLOSED){
		write_data(Sn_CR1 + (port << 6), Sn_CR_DISCON);
		return 0;
	    }
	}
    }

    private final byte[] buffer = new byte[8192];
    private int pull_recv_data(int port){
	int v0 = (int)read_data(Sn_RX_FIFOR0 + (port << 6));
	int v1 = (int)read_data(Sn_RX_FIFOR1 + (port << 6));
	int actual_len = (v0 << 8) + v1;
	int read_len = (actual_len >> 1);
	if((actual_len & 0x01) == 0x01){ read_len = read_len + 1; }
	for(int i = 0; i < read_len; i++){
	    buffer[(i<<1) + 0] = read_data(Sn_RX_FIFOR0 + (port << 6));
	    buffer[(i<<1) + 1] = read_data(Sn_RX_FIFOR1 + (port << 6));
	}
	write_data(Sn_CR1 + (port << 6), Sn_CR_RECV);
	return actual_len;
    }

    private void push_send_data(int port, int len){
	int write_len = (len >> 1);
	if((len & 0x01) == 0x01){ write_len = write_len + 1; }
	for(int i = 0; i < write_len; i++){
	    byte v = buffer[(i<<1)+0];
	    write_data(Sn_TX_FIFOR0 + (port << 6), v);
	    v = buffer[(i<<1)+1];
	    write_data(Sn_TX_FIFOR1 + (port << 6), v);
	}
	write_data(Sn_CR1 + (port << 6), Sn_CR_RECV);
	write_data(Sn_TX_WRSR1 + (port << 6), (byte)(len >> 16));
	write_data(Sn_TX_WRSR2 + (port << 6), (byte)(len >> 8));
	write_data(Sn_TX_WRSR3 + (port << 6), (byte)(len >> 0));
	write_data(Sn_CR1 + (port << 6), Sn_CR_SEND);
    }

    private void tcp_server(int port){
	//	write_data(Sn_MR0 + (port << 6), (byte)0x01); // Use alignment
	write_data(Sn_IMR1 + (port << 6), (byte)0x00); // don't use interrupt
	byte v = tcp_server_open(port);
	while(v != Sn_SOCK_INIT){
	    write_data(Sn_CR1 + (port << 6), Sn_CR_CLOSE);
	    v = tcp_server_open(port);
	}
	led = (int)v;
	v = tcp_server_listen(port);
	while(v != Sn_SOCK_LISTEN){
	    write_data(Sn_CR1 + (port << 6), Sn_CR_CLOSE);
	    v = tcp_server_listen(port);
	}
	wait_for_established(port);

	led = 0;
	led = read_data(Sn_MR0 + (port << 6));
	while(true){
	    int len = wait_for_recv(port);
	    if(len == 0){
		break;
	    }
	    led = len;
	    len = pull_recv_data(port);
	    led = len;
	    push_send_data(port, len);
	}
    }

    public void test(){
	led = 0x00;
	init();

	led = 0x01;

	network_configuration();
	led = 0x03;

	led = 255;

	while(true){
	    tcp_server(0);
	}
    }

    public void blink_led(){
	/*
	while(true){
	    if(led == 255){
		led = 0;
	    }else{
		led++;
	    }
	    for(int i = 0; i < 1000000; i++){ ; }
	}
	*/
    }

}
