/*
Authored by Elijah Theander
December 5, 2016
colorCycle.v
12 bit counter that counts up and splits
into red, green, and blue inputs for widget.
*/

module colorCycle(red,green,blue,enable,clk,reset);

	output [3:0] red,green,blue;
	input enable,clk,reset;
	
	reg [11:0] S,nS;
	
	always @(posedge clk)begin
		if(reset)begin
			S <= 0;
		end
		else if(enable)begin
			S <= nS;
		end
		else begin
            S <= S;
		end
	end
	
	always @(S)begin
		if((S + 1) == 12'h771)begin
			nS = 12'h870;
		end
		else begin
			nS = S + 1;
		end
	end
	
	assign {red,green,blue} = S;
endmodule