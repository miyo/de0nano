
import synthesijer.rt.*;

public class Misc{

    public int quant, remainder;

    public int simple_div(int n, int d){
	if(d == 0) return -1; // zero div 
	int q = 0;
	int r = 0;                     
	int v = 0x80000000;
	for(int i = 31; i >= 0; i--){
	    r = r << 1;
	    if((n & v) != 0){ r = r | 0x00000001; } // r(0) = n0(i)
	    if(r >= d){
		r = r - d;
		q = q | v;
	    }
	    v = v >>> 1;
	}
	quant = q;
	remainder = r;
	return 1;
    }

    private int to_d(int v){
	if(0 <= v && v <= 9){
	    return 0x30 + v;
	}else{
	    return 0x20;
	}
    }

    public int i_to_4digit_ascii(int x, boolean flag){
	int x0 = x;
	int r = 0;
	// 1000
	simple_div(x0, 1000);
	if(quant > 0 || flag){
	    r = r + (to_d(quant) << 24);
	}else{
	    r = r + (0x20 << 24);
	}
	x0 = remainder;
	// 100
	simple_div(x0, 100);
	if(quant > 0 || r > 0x20000000 || flag){
	    r = r + (to_d(quant) << 16);
	}else{
	    r = r + (0x20 << 16);
	}
	x0 = remainder;
	// 10
	simple_div(x0, 10);
	if(quant > 0 || r > 0x20200000 || flag){
	    r = r + (to_d(quant) << 8);
	}else{
	    r = r + (0x20 << 8);
	}
	x0 = remainder;
	// 1
	simple_div(x0, 1);
	r = r + (to_d(quant) << 0);
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
	m.simple_div(10, 3);
	System.out.printf("10/3 => q=%d, r=%d\n", m.quant, m.remainder);
	System.out.printf("%08x\n", m.i_to_4digit_ascii(40, false));
	System.out.printf("%08x\n", m.i_to_4digit_ascii(40, true));
	System.out.printf("%b\n", m.isHex((byte)'f'));
	System.out.printf("%b\n", m.isHex((byte)'g'));
	System.out.printf("%d\n", m.toHex2((byte)'f', (byte)'e'));
    }

}
