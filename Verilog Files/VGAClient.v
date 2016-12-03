// VGAClient.v - Example VGA color computation client
// UW EE 4490 Fall 2016
// Jerry C. Hamann
// Computes the desired color at pix (X,Y), must do this fast!

module VGAClient(RED,GREEN,BLUE,CurrentX,CurrentY,VBlank,HBlank,SWITCH,CLK_100MHz);
    output  [3:0]   RED, GREEN, BLUE;
    input   [10:0]  CurrentX, CurrentY;
    input           VBlank, HBlank;
    input   [3:0]   SWITCH;
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
    always @(VBlank,HBlank,ColorSel,CurrentX,CurrentY,SWITCH[3]) begin
        if(VBlank || HBlank)
            {RED,GREEN,BLUE}=0; // Must drive colors only during non-blanking times.
        else if(!SWITCH[3])
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
        else begin
            UglyTemp=CurrentX*CurrentY;
            {RED,GREEN,BLUE}=UglyTemp[11:0];    
        end
    end
 endmodule
