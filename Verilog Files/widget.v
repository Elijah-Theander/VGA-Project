/*
Authored by Elijah Theander
December 3, 2016
Widget.v
State machine module designed to run a sprite
on a VGA screen at 800x600.
*/

module widget(yes,red,green,blue,X,Y,xSize,ySize,delX,delY,redIn,greenIn,blueIn,firstX,firstY,clk,reset);

	output       yes;
	output [3:0] red,green,blue;
	
	input  [10:0] X,Y,firstX,firstY;
	input  [8:0] xSize,ySize;
	input  [4:0] delX,delY;
	input  [3:0] redIn,greenIn,blueIn;
	input        clk,reset;
	
	wire signed [4:0] negDelX,negDelY;
	assign negDelX = -delX;
	assign negDelY = -delY;
	//With this signed interpretation, we can have a positive value
	//of 0-15 for our positive del values.
	reg signed [4:0]  myDelX,myDelY,nextDelX,nextDelY;
	reg        [10:0]  myX,myY,nextX,nextY;
	
	parameter rightBorder = 799, bottomBorder = 599;
	
	always @(posedge clk)begin
		if(reset)begin
			myX <= firstX;
			myY <= firstY;
			myDelX <= delX;
			myDelY <= delY;
		end
		else begin
			myX <= nextX;
			myY <= nextY;
			myDelX <= nextDelX;
			myDelY <= nextDelY;
		end
	end
	
	//nextX and nextY
	always @(myX,myY,myDelX,myDelY)begin
		nextX = (myX + myDelX);
		nextY = (myY + myDelY);
	end
	
	//nextDelX and nextDelY
	always @(myX,myDelX,xSize,negDelX,delX)begin
	
		if((myX + xSize + myDelX) == rightBorder)begin
			nextDelX = negDelX;
		end
		else if((myX + myDelX) == 0)begin
			nextDelX = delX;
		end
		else begin
			nextDelX = myDelX;
		end
		
	end
	always @(myY,myDelY,ySize,negDelY,delY)begin
	   
            if((myY + ySize + myDelY) == bottomBorder)begin
                nextDelY = negDelY;
            end
            else if((myY + myDelY) == 0)begin
                nextDelY = delY;
            end
            else begin
                nextDelY = myDelY;
            end
            
	end
	
	assign {red,green,blue} = {redIn,greenIn,blueIn};
	
	assign yes = (((X >= myX)&&(X <= (myX + xSize)))&&((Y >= myY) && (Y <= (myY + ySize))));
	
endmodule