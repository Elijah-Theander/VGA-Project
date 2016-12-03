// VGAStart.v - Top level module for example VGA driver implementation in Verilog
// UW EE 4490 Fall 2016
// Jerry C. Hamann

module FirstVGA(VS, HS, RED, GREEN, BLUE, SWITCH, CLK_100MHz, Reset);
    output          VS, HS; 
    output [3:0]    RED, GREEN, BLUE;
    input  [3:0]    SWITCH;
    input           CLK_100MHz, Reset;
    
    wire            HBlank, VBlank;
    wire   [10:0]   CurrentX, CurrentY;

    // Connect to driver of VGA signals
    VGALLDriver vgadll(.VS(VS),.HS(HS),.VBlank(VBlank),.HBlank(HBlank),
                       .CurrentX(CurrentX),.CurrentY(CurrentY), 
                       .CLK_100MHz(CLK_100MHz),.Reset(Reset));
   
    // Connect to "client" which produces pixel color based on (X,Y) location
    VGAClient   vgacl(.RED(RED),.GREEN(GREEN),.BLUE(BLUE),
                      .CurrentX(CurrentX),.CurrentY(CurrentY),.VBlank(VBlank),.HBlank(HBlank),
                      .SWITCH(SWITCH),.CLK_100MHz(CLK_100MHz));
endmodule
