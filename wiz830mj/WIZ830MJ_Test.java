
public class WIZ830MJ_Test{

    private final WIZ830MJ_Iface wiz830mj = new WIZ830MJ_Iface();

    private void wait_cycles(int n){
	for(int i = 0; i < n; i++){;}
    }

    private void write_data(int addr, byte data){
	wiz830mj.address = addr;
	wiz830mj.wdata = data;
	wiz830mj.we = true;
	wait_cycles(0);
	wiz830mj.we = false;
    }

    private byte read_data(int addr){
	wiz830mj.address = addr;
	wiz830mj.oe = true;
	wait_cycles(0);
	byte v = wiz830mj.rdata;
	wiz830mj.oe = false;
	return v;
    }

    private void init(){
	wiz830mj.module_reset = true;
	wiz830mj.cs = true;
	wiz830mj.module_reset = false;
	wiz830mj.we = false;
	wiz830mj.oe = false;
    }

    public void test(){
    }

}
