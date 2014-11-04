
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
	wait_cycles(3);
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

    public void test(){
	init();
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
	while(true){;}
    }

    public void blink_led(){
	while(true){
	    if(led == 255){
		led = 0;
	    }else{
		led++;
	    }
	    for(int i = 0; i < 1000000; i++){ ; }
	}
    }

}
