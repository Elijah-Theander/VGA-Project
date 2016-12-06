// VGAStart.v - Top level module for example VGA driver implementation in Verilog
// UW EE 4490 Fall 2016
// Jerry C. Hamann

module FirstVGA(VS, HS, RED, GREEN, BLUE, SWITCH, CLK_100MHz, Reset);
    output          VS, HS; 
    output [3:0]    RED, GREEN, BLUE;
    input  [4:0]    SWITCH;
    input           CLK_100MHz, Reset;
    
    wire            HBlank, VBlank,yeswire,wEn;
    wire   [10:0]   CurrentX, CurrentY;
	wire   [3:0]    widgred,widggreen,widgblue;

    // Connect to driver of VGA signals
    VGALLDriver vgadll(.VS(VS),.HS(HS),.VBlank(VBlank),.HBlank(HBlank),
                       .CurrentX(CurrentX),.CurrentY(CurrentY), 
                       .CLK_100MHz(CLK_100MHz),.Reset(Reset));
   
    // Connect to "client" which produces pixel color based on (X,Y) location
    VGAClient   vgacl(.RED(RED),.GREEN(GREEN),.BLUE(BLUE),
                      .CurrentX(CurrentX),.CurrentY(CurrentY),.VBlank(VBlank),.HBlank(HBlank),
                      .SWITCH(SWITCH),.wRed(widgred),.wGreen(widggreen),.wBlue(widgblue),.yes(yeswire),.CLK_100MHz(CLK_100MHz));
					  
	// Create an instance of widget
	widget		ball(.yes(yeswire),
						.red(widgred),
						.green(widggreen),
						.blue(widgblue),
						.X(CurrentX),
						.Y(CurrentY),
						.xSize(9'd14),
						.ySize(9'd20),
						.delX(5'd6),
						.delY(5'd4),
						.redIn(4'd0),
						.greenIn(4'd15),
						.blueIn(4'd0),
						.enable(wEn),
						.firstX(11'd0),
						.firstY(11'd0),
						.clk(CLK_100MHz),
						.reset(Reset));
						
	
	// Clock divider
	clockDiv divClk(.divPulse(wEn),
						 .enable(1'b1),
						 .clk(CLK_100MHz),
						 .reset(Reset));
endmodule
