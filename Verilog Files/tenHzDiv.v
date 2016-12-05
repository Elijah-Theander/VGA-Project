/*
Authored by Elijah Theander
October 28, 2016
tenHzDiv.v
Takes the 100 MHz signal from Basys 3 
and divides it down to a 10Hz signal for timing of modules.

100Mhz/10Hz = x, x = 10_000_000 counts of clock
y*ln(2)=ln(10_000_000), y = 23.25= 24 bits needed.
*/

module tenHzDiv(tenHz,enable,clk,reset);
	output tenHz;       //Ten Hz pulse
	
	input  enable;      //Enable the counter. For our purposes it will be high always.
	input  clk,reset;   
	
	//State and next state variables
	reg [23:0] S,nS;
	
	//State memory
	always @(posedge clk)begin
		if(reset)begin
			S <= 24'd0;
		end
		else begin
			S <= nS;
		end
	end
	
	//Next state
	always @(S,enable)begin
		if(enable)begin
			nS = (S < 24'd10_000_001)? S+1:0;
		end 
		else begin
			nS = S;
		end
	end
	
	assign tenHz = (S == 24'd10_000_000);
	
endmodule

//I will not be writing a test bench for this module
//because I have used this module many times and
//know it works properly.