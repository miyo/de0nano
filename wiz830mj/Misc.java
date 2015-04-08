
import synthesijer.rt.*;

public class Misc{

    private int simple_div(int d, int r){
	int q = 0;
	int d0 = d;
	while(d0 >= r){
	    d0 = d0 - r;
	    q++;
	}
	return q;
    }

    private int to_d(int v){
	if(0 <= v && v <= 9){
	    return 0x30 + v;
	}else{
	    return 0x20;
	}
    }

    public int i_to_4digit_ascii(int x){
	int q;
	int x0 = x;
	int r = 0;
	// 1000
	q = simple_div(x0, 1000);
	if(q > 0){
	    r = r + (to_d(q) << 24);
	}else{
	    r = r + (0x20 << 24);
	}
	x0 = x0 - q * 1000;
	// 100
	q = simple_div(x0, 100);
	if(q > 0 || r > 0x20000000){
	    r = r + (to_d(q) << 16);
	}else{
	    r = r + (0x20 << 16);
	}
	x0 = x0 - q * 100;
	// 10
	q = simple_div(x0, 10);
	if(q > 0 || r > 0x20200000){
	    r = r + (to_d(q) << 8);
	}else{
	    r = r + (0x20 << 8);
	}
	x0 = x0 - q * 10;
	// 1
	q = simple_div(x0, 1);
	r = r + (to_d(q) << 0);
	return r;
    }

    public boolean isHex(byte v){
	if(((byte)'0' <= v && v <= (byte)'9') ||
	   ((byte)'a' <= v && v <= (byte)'f') ||
	   ((byte)'A' <= v && v <= (byte)'F')){
	    return true;
	}else{
	    return false;
	}
    }

    public int toHex1(byte v){
	if((byte)'0' <= v && v <= (byte)'9') return (int)(v - (byte)'0');
	if((byte)'a' <= v && v <= (byte)'f') return (int)((v - (byte)'a') + 10);
	if((byte)'A' <= v && v <= (byte)'F') return (int)((v - (byte)'A') + 10);
	return 0;
    }

    public int toHex2(byte v0, byte v1){
	int r = 0;
	r = r + (toHex1(v0) << 4);
	r = r + (toHex1(v1) << 0);
	return r;
    }

    @unsynthesizable
    public static void main(String... args){
	Misc m = new Misc();
	System.out.printf("%08x\n", m.i_to_4digit_ascii(40));
	System.out.printf("%b\n", m.isHex((byte)'f'));
	System.out.printf("%b\n", m.isHex((byte)'g'));
	System.out.printf("%d\n", m.toHex2((byte)'f', (byte)'e'));
    }

}
