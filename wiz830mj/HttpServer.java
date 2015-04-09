public class HttpServer{

    private final HttpResponseHeader resp = new HttpResponseHeader();
    
    public final byte[] buffer = new byte[8192];

    private int[] data = new int[1024];

    private int pack(char a, char b, char c, char d){
	return (((int)a&0xFF) << 24) + (((int)b&0xFF) << 16) + (((int)c&0xFF) << 8) + ((int)d&0xFF);
    }

    private int content_words = 8;
    private int content_length_field_0;
    private int content_length_field_1;
    private int content_length_field_2;

    private final Misc misc = new Misc();
   
    public void init_contents(){
	
	data[0] = pack('<', 'h', 't', 'm');
	data[1] = pack('l', '>', '<', 'b');
	data[2] = pack('o', 'd', 'y', '>');
	data[3] = pack('A', 'r', 'g', 'u');
	data[4] = pack('m', 'e', 'n', 't');
	data[5] = pack('?', '=', ' ', ' ');
	data[6] = pack('<', '/', 'b', 'o');
	data[7] = pack('d', 'y', '>', '<');
	data[8] = pack('/', 'h', 't', 'm');
	data[9] = pack('l', '>', '\n', '\n');
        
	content_words = 10;
	int v = content_words << 2;
	misc.simple_div(v, 100000000);
	int bytes_2 = misc.quant;
	v = misc.remainder;
	misc.simple_div(v, 10000);
	int bytes_1 = misc.quant;
	int bytes_0 = misc.remainder;
	if(bytes_2 > 0){
	    content_length_field_2 = misc.i_to_4digit_ascii(bytes_2, false);
	    content_length_field_1 = misc.i_to_4digit_ascii(bytes_1, true);
	    content_length_field_0 = misc.i_to_4digit_ascii(bytes_0, true);
	}else if(bytes_1 > 0){
	    content_length_field_2 = 0x20202020;
	    content_length_field_1 = misc.i_to_4digit_ascii(bytes_1, false);
	    content_length_field_0 = misc.i_to_4digit_ascii(bytes_0, true);
	}else{
	    content_length_field_2 = 0x20202020;
	    content_length_field_1 = 0x20202020;
	    content_length_field_0 = misc.i_to_4digit_ascii(bytes_0, false);
	}
        
    }

    byte arg0 = (byte)' ', arg1 = (byte)' ';

    public int ready_contents(){
	// header
	for(int i = 0; i < resp.length; i++){
	    int v = resp.data[i];
	    buffer[(i<<2)+0] = (byte)(v >> 24);
	    buffer[(i<<2)+1] = (byte)(v >> 16);
	    buffer[(i<<2)+2] = (byte)(v >>  8);
	    buffer[(i<<2)+3] = (byte)(v >>  0);
	}
	buffer[(8<<2)+0] = (byte)(content_length_field_2 >> 24);
	buffer[(8<<2)+1] = (byte)(content_length_field_2 >> 16);
	buffer[(8<<2)+2] = (byte)(content_length_field_2 >>  8);
	buffer[(8<<2)+3] = (byte)(content_length_field_2 >>  0);

	buffer[(9<<2)+0] = (byte)(content_length_field_1 >> 24);
	buffer[(9<<2)+1] = (byte)(content_length_field_1 >> 16);
	buffer[(9<<2)+2] = (byte)(content_length_field_1 >>  8);
	buffer[(9<<2)+3] = (byte)(content_length_field_1 >>  0);

	buffer[(10<<2)+0] = (byte)(content_length_field_0 >> 24);
	buffer[(10<<2)+1] = (byte)(content_length_field_0 >> 16);
	buffer[(10<<2)+2] = (byte)(content_length_field_0 >>  8);
	buffer[(10<<2)+3] = (byte)(content_length_field_0 >>  0);
        
	// data
	int offset = resp.length;
	for(int i = 0; i < content_words; i++){
	    int v = data[i];
	    int ptr = (offset + i) << 2;
	    buffer[ptr+0] = (byte)(v >> 24);
	    buffer[ptr+1] = (byte)(v >> 16);
	    buffer[ptr+2] = (byte)(v >>  8);
	    buffer[ptr+3] = (byte)(v >>  0);
	    if(i == 5){
		buffer[ptr+2] = arg0;
		buffer[ptr+3] = arg1;
	    }
	}
	return (resp.length + content_words) << 2;
    }

    public int action(int len){
	int S = 0;
	byte v0 = 0, v1 = 0;
	for(int i = 0; i < len; i++){
	    byte b = buffer[i];
	    switch(S){
	    case 0:
		if(b == (byte)'?'){ S = 1; } else { S = 0; }
		break;
	    case 1:
		if(b == (byte)'v'){ S = 2; } else { S = 0; }
		break;
	    case 2:
		if(b == (byte)'='){ S = 3; } else { S = 0; }
		break;
	    case 3:
		if(misc.isHex(b)){ v0 = b; S = 4; }else{ S = 0; }
		break;
	    case 4:
		if(misc.isHex(b)){ v1 = b; S = 5; }else{ S = 0; }
		break;
	    case 5:
		break;
	    default:
		S = 0;
	    }
	}
	int v = 0;
	if(S == 5){
	    v = misc.toHex2(v0, v1);
	    arg0 = v0;
	    arg1 = v1;
	}else{
	    arg0 = (byte)'?';
	    arg1 = (byte)'?';
	}
	return v;
    }

}
