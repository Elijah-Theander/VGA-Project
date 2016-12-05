/*
Authored by Elijah Theander
December 4, 2016
Clock divider module to create an enable for 
modules we want running slower than 100 MHz.
right now the divPulse signal is running at 30 Hz.
*/

module clockDiv(divPulse,enable,clk,reset);
	output divPulse;       
	input  enable;      //Enable the counter. For our purposes it will be high always.
	input  clk,reset;   
	
	//State and next state variables
	reg [21:0] S,nS;
	
	//State memory
	always @(posedge clk)begin
		if(reset)begin
			S <= 22'd0;
		end
		else begin
			S <= nS;
		end
	end
	
	//Next state
	always @(S,enable)begin
		if(enable)begin
			nS = (S < 22'd3_333_334)? S+1:0;
		end 
		else begin
			nS = S;
		end
	end
	
	assign tenHz = (S == 22'd3_333_334);
	
endmodule

