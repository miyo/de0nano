import synthesijer.hdl.HDLModule;
import synthesijer.hdl.HDLPort;
import synthesijer.hdl.HDLPrimitiveType;


public class HttpResponseHeader extends HDLModule{
	
	// for synthesijer
	int data[];
	int length;
	
	public HttpResponseHeader(String... args){
		super("http_response_header", "clk", "reset");

		newPort("data_length",  HDLPort.DIR.OUT, HDLPrimitiveType.genSignedType(32));
		newPort("data_address", HDLPort.DIR.IN, HDLPrimitiveType.genSignedType(32));
		newPort("data_din",  HDLPort.DIR.IN, HDLPrimitiveType.genSignedType(32));
		newPort("data_dout", HDLPort.DIR.OUT, HDLPrimitiveType.genSignedType(32));
		newPort("data_we",   HDLPort.DIR.IN, HDLPrimitiveType.genBitType());
		newPort("data_oe",   HDLPort.DIR.IN, HDLPrimitiveType.genBitType());
		
		newPort("length",  HDLPort.DIR.OUT, HDLPrimitiveType.genSignedType(32));
	}
	
}