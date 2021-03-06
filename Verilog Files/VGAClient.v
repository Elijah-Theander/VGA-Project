// VGAClient.v - Example VGA color computation client
// UW EE 4490 Fall 2016
// Jerry C. Hamann
// Computes the desired color at pix (X,Y), must do this fast!

module VGAClient(RED,GREEN,BLUE,CurrentX,CurrentY,VBlank,HBlank,SWITCH,redOne,redTwo,greenOne,greenTwo,blueOne,blueTwo,yesOne,yesTwo,CLK_100MHz);
    output  [3:0]   RED, GREEN, BLUE; //Output signals going to the screen
    input   [10:0]  CurrentX, CurrentY;//Input from driver saying where it is scanning currently
    input           VBlank, HBlank;//Blanking signals for wraparound
    input   [4:0]   SWITCH;//Basys 3 switch inputs
	input   [3:0]   redOne,redTwo,greenOne,greenTwo,blueOne,blueTwo;//color input for two widgets
	input           yesOne,yesTwo;//Yes inputs for drawing of widgets
    input           CLK_100MHz;

    reg     [2:0]   ColorSel;
    reg     [3:0]   RED, GREEN, BLUE;
    reg     [20:0]  UglyTemp;
    
   // Change color scheme only during a blanking condition
    always @(posedge CLK_100MHz) begin
        if(VBlank || HBlank)
            ColorSel <= SWITCH[2:0];
        else
            ColorSel <= ColorSel;
    end
   
    // Assuming an 800x600 screen resolution, paints a 100 pixel white border.
    always @(VBlank,HBlank,ColorSel,CurrentX,CurrentY,SWITCH[3],SWITCH[4],yesOne,yesTwo,redOne,redTwo,greenOne,greenTwo,blueOne,blueTwo) begin
        if(VBlank || HBlank)
            {RED,GREEN,BLUE}=0; // Must drive colors only during non-blanking times.
        else if((!SWITCH[3])&&(!SWITCH[4]))
            case(ColorSel)
                3'b000: {RED,GREEN,BLUE} = (CurrentX<100 || CurrentX>700 || CurrentY<100 || CurrentY>500) ? 12'hfff : 12'h000;
                3'b001: {RED,GREEN,BLUE} = (CurrentX<100 || CurrentX>700 || CurrentY<100 || CurrentY>500) ? 12'hfff : 12'h00f;
                3'b010: {RED,GREEN,BLUE} = (CurrentX<100 || CurrentX>700 || CurrentY<100 || CurrentY>500) ? 12'hfff : 12'h0f0;
                3'b011: {RED,GREEN,BLUE} = (CurrentX<100 || CurrentX>700 || CurrentY<100 || CurrentY>500) ? 12'hfff : 12'h0ff;
                3'b100: {RED,GREEN,BLUE} = (CurrentX<100 || CurrentX>700 || CurrentY<100 || CurrentY>500) ? 12'hfff : 12'hf00;
                3'b101: {RED,GREEN,BLUE} = (CurrentX<100 || CurrentX>700 || CurrentY<100 || CurrentY>500) ? 12'hfff : 12'hf0f;
                3'b110: {RED,GREEN,BLUE} = (CurrentX<100 || CurrentX>700 || CurrentY<100 || CurrentY>500) ? 12'hfff : 12'hff0;
                3'b111: {RED,GREEN,BLUE} = (CurrentX<100 || CurrentX>700 || CurrentY<100 || CurrentY>500) ? 12'hfff : 12'h777;
                default:  {RED,GREEN,BLUE} = (CurrentX<100 || CurrentX>700 || CurrentY<100 || CurrentY>500) ? 12'hfff : 12'h000;
            endcase
        else if(!SWITCH[4]) begin
            UglyTemp=CurrentX*CurrentY;
            {RED,GREEN,BLUE}={UglyTemp[20],UglyTemp[18],UglyTemp[16],UglyTemp[14],UglyTemp[12],UglyTemp[10],
			                  UglyTemp[8],UglyTemp[6],UglyTemp[4],UglyTemp[2],UglyTemp[0],UglyTemp[19]};  
								//I changed the assignment here, but not the calculation
        end
		else begin
			{RED,GREEN,BLUE} = yesOne ? {redOne,greenOne,blueOne} : (yesTwo ? {redTwo,greenTwo,blueTwo}:12'h777);
			//Draw widgets based on the yes signals for them.
		end
    end
 endmodule
