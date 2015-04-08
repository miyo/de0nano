public class Test{

    private int simple_div(int d, int r){
	int q = 0;
	int d0 = d;
	while(d0 >= r){
	    d0 = d0 - r;
	    q++;
	}
	System.out.println("div:" + d + "/" + r + "=" + q);
	return q;
    }

    private int to_d_or_sp(int v){
	if(0 <= v && v <= 9){
	    return 0x30 + v;
	}else{
	    return 0x20;
	}
    }

    private int i_to_4digit_ascii(int x){
	int q;
	int x0 = x;
	int r = 0;
	// 1000
	q = simple_div(x0, 1000);
	if(q > 0){
	    r = r + (to_d_or_sp(q) << 24);
	}else{
	    r = r + (0x20 << 24);
	}
	x0 = x0 - q * 1000;
	// 100
	q = simple_div(x0, 100);
	if(q > 0 || r > 0x20000000){
	    r = r + (to_d_or_sp(q) << 16);
	}else{
	    r = r + (0x20 << 16);
	}
	x0 = x0 - q * 100;
	// 10
	q = simple_div(x0, 10);
	if(q > 0 || r > 0x20200000){
	    r = r + (to_d_or_sp(q) << 8);
	}else{
	    r = r + (0x20 << 8);
	}
	x0 = x0 - q * 10;
	// 1
	q = simple_div(x0, 1);
	r = r + (to_d_or_sp(q) << 0);
	return r;
    }

    public static void main(String... args){
	Test t = new Test();
	System.out.printf("%08x\n", t.i_to_4digit_ascii(40));
    }

}
