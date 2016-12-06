// VGAStart.v - Top level module for example VGA driver implementation in Verilog
// UW EE 4490 Fall 2016
// Jerry C. Hamann

module FirstVGA(VS, HS, RED, GREEN, BLUE, SWITCH,BTNU,BTND, CLK_100MHz, Reset);
    output          VS, HS; 
    output [3:0]    RED, GREEN, BLUE;
    input  [4:0]    SWITCH;
	input           BTNU,BTND;
    input           CLK_100MHz, Reset;
    
    wire            HBlank, VBlank,ballYes,paddleYes,wEn;
    wire   [10:0]   CurrentX, CurrentY;
	wire   [3:0]    bRed,bGreen,bBlue,pRed,pGreen,pBlue;
	wire signed [10:0] paddleX,paddleNextY;
	wire  [8:0]     paddleSizeY;

    // Connect to driver of VGA signals
    VGALLDriver vgadll(.VS(VS),
					   .HS(HS),
					   .VBlank(VBlank),
					   .HBlank(HBlank),
                       .CurrentX(CurrentX),
					   .CurrentY(CurrentY), 
                       .CLK_100MHz(CLK_100MHz),
					   .Reset(Reset));
   
    // Connect to "client" which produces pixel color based on (X,Y) location
    VGAClient   vgacl(.RED(RED),
					  .GREEN(GREEN),
					  .BLUE(BLUE),
                      .CurrentX(CurrentX),
					  .CurrentY(CurrentY),
					  .VBlank(VBlank),
					  .HBlank(HBlank),
                      .SWITCH(SWITCH),
					  .redOne(bRed),
					  .greenOne(bGreen),
					  .blueOne(bBlue),
					  .yesOne(ballYes),
					  .redTwo(pRed),
					  .greenTwo(pGreen),
					  .blueTwo(pBlue),
					  .yesTwo(paddleYes),
					  .CLK_100MHz(CLK_100MHz));
					  
	// Create an instance of widget
	widget		ball(.yes(ballYes),
						.red(bRed),
						.green(bGreen),
						.blue(bBlue),
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
						.theirX(paddleX),
						.theirNextY(paddleNextY),
						.theirSizeY(paddleSizeY),
						.clk(CLK_100MHz),
						.reset(Reset));
						
	buttonWidget paddle(.yes(paddleYes),
					    .myX(paddleX),
						.nextY(paddleNextY),
						.sizeY(paddleSizeY),
						.red(pRed),
						.green(pGreen),
						.blue(pBlue),
						.X(CurrentX),
						.Y(CurrentY),
						.xSize(9'd20),
						.ySize(9'd100),
						.delX(0),
						.delY(5'd4),
						.redIn(4'd15),
						.greenIn(4'd15),
						.blueIn(4'd15),
						.enable(wEn),
						.firstX(11'd739),
						.firstY(11'd249),
						.up(BTNU),
						.down(BTND),
						.clk(CLK_100MHz),
						.reset(Reset));
	
	// Clock divider
	clockDiv divClk(.divPulse(wEn),
						 .enable(1'b1),
						 .clk(CLK_100MHz),
						 .reset(Reset));
endmodule
