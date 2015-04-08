import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;

import synthesijer.hdl.HDLPort;


public class HttpResponseHeaderGen {


	private int pack(char a, char b, char c, char d){
		return (((int)a&0xFF) << 24) + (((int)b&0xFF) << 16) + (((int)c&0xFF) << 8) + ((int)d&0xFF);
	}
	
	private String pad(int n){
		String s = "";
		for(int i = 0; i < n; i++) s += " ";
		return s;
	}
	
	private int[] genHeaderArray(){
		String CRLF = new String(new byte[]{0x0d, 0x0a});
		String header = "";
		header += "HTTP/1.1 200 OK" + CRLF; // 17bytes
		header += "Content-Length:"; // 15bytes 
		header += "    "; // data[8]
		header += "    "; // data[9]
		header += "    "; // data[10]
		header += "    "; // data[11]
		header += CRLF;
		header += "Keep-Alive: timeout=15, max=1" + CRLF;
		header += "Connection: close" + CRLF;
		
		// when there is no pad, the length of "Content-Type:~" is 26.
		// to align header in x4 bytes 
		header += "Content-Type:" + pad(4-(header.length()+2)%4) + "text/html" + CRLF + CRLF;
		System.out.println(header.length());
		System.out.println("---------------------");
		System.out.print(header);
		System.out.println("---------------------");
		int[] result = new int[header.length()/4]; 
		for(int i = 0; i < header.length()/4; i++){
			result[i] = pack(header.charAt(4*i), header.charAt(4*i+1), header.charAt(4*i+2), header.charAt(4*i+3));
		}
		return result;
	}

	public static void main(String... args){
		HttpResponseHeader t = new HttpResponseHeader();
		HttpResponseHeaderGen m = new HttpResponseHeaderGen();
		int[] contents = m.genHeaderArray();
		int depth = (int)(Math.ceil(Math.log(contents.length)/Math.log(2)));
		
		File file = new File(t.getName() + ".vhd");
		String NL = System.getProperty("line.separator");
		
		try(PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(file)))){

			out.println("library IEEE;");
			out.println("use IEEE.std_logic_1164.all;");
			out.println("use IEEE.numeric_std.all;");
			out.println();
			out.println("entity " + t.getName() + " is");
			out.println("port(");
			String sep = "";
			for(HDLPort p: t.getPorts()){
				out.print(sep + p.getName() + " : " + p.getDir().getVHDL() + " " + p.getType().getVHDL());
				sep = ";" + NL;
			}
			out.println(");");
			out.println("end " + t.getName() + ";");
			out.println("architecture RTL of " + t.getName() + " is");
			out.println("subtype MEM is signed(31 downto 0);");
			out.println("type ROM is array ( 0 to " + (contents.length-1) + " ) of MEM;");
			out.println("constant data : ROM := (");
			sep = "";
			for(int d: contents){
				out.printf("%sX\"%08x\"", sep, d);
				sep = "," + NL;
			}
			out.println(");");
			out.println("begin");
			out.println("data_length <= to_signed(" + contents.length + ", 32);");
			out.println("length <= to_signed(" + contents.length + ", 32);");
			out.println("process(clk)");
			out.println("begin");
	       out.println("if (clk'event and clk = '1') then");
	       out.println("data_dout <= data(to_integer(unsigned(data_address)));");
	       out.println("end if;");
	       out.println("end process;");
	       out.println("end RTL;");
	       
		}catch(IOException e){
			
		}
	}
	
}

