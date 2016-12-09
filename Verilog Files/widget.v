/*
Authored by Elijah Theander
December 3, 2016
Widget.v
State machine module designed to run a sprite
on a VGA screen at 800x600.
*/

module widget(yes,red,green,blue,X,Y,xSize,ySize,delX,delY,redIn,greenIn,blueIn,enable,firstX,firstY,theirNextY,theirSizeY,theirX,clk,reset);

	output              yes; //Signal for Drawing of object
	output       [3:0]  red,green,blue; //Color of object being fed to Client
	
	input        [10:0] X,Y,firstX,firstY; //Location of driver scan and starting location of widget
	input signed [10:0] theirX, theirNextY; // Status signal for collision with other widget.
	input        [8:0]  theirSizeY; //Size for collision calculation with other widget
	input        [8:0]  xSize,ySize; // Determines width and Height of widget
	input signed [4:0]  delX,delY; // "Velocity" of object, also depends on refresh rate given by enable
	input        [3:0]  redIn,greenIn,blueIn; // Color the widget is picking up
	input               enable; // Enable signal from clockDiv
	input               clk,reset; //Synchronous clock and reset
	
	//State variables
	reg signed   [10:0] myX,myY,nextX,nextY;
	reg                 subtractX,subtractY,nextSubX,nextSubY;
	reg          [3:0]  myRed,myGreen,myBlue,nextRed,nextGreen,nextBlue;
	
	parameter rightBorder = 799, bottomBorder = 599;
	
	//State Memory
	always @(posedge clk)begin
		if(reset)begin
			myX <= firstX;
			myY <= firstY;
			{myRed,myGreen,myBlue} = 12'h000;
			subtractX = 0;
			subtractY = 0;
		end
		else begin
			myX <= nextX;
			myY <= nextY;
			{myRed,myGreen,myBlue} = {nextRed,nextGreen,nextBlue};
			subtractX = nextSubX;
			subtractY = nextSubY;
		end
	end
	
	//nextX
	always @(myX,delX,xSize,subtractX,enable,theirX,myY,delY,theirNextY,theirSizeY,ySize)begin
	   if(enable)begin
	   
	       if(subtractX)begin
	       
	           if((myX - delX)<=0)begin
	               nextX=0;
	           end
	           else begin
                   nextX = (myX - delX);
               end
               
	       end
	       else begin
			   if(((myX+delX+xSize)>=theirX)&&(((myY+delY) <= (theirNextY +theirSizeY))&&((myY+delY+ySize)>=theirNextY)))begin
					nextX = (theirX-xSize);
			   end
	           else if(((myX + delX +xSize)>=rightBorder)&&((myX + delX + xSize)<=1023))begin
	               nextX = (rightBorder - xSize);
	           end 
	           else begin
	               nextX = (myX + delX);
	           end
	       end
	   end
	   else begin
	       nextX = myX;
	   end
	   
	end
	
	//nextY
	always @(myY,delY,ySize,subtractY,enable)begin
	   if(enable)begin
	       if(subtractY)begin
	           if((myY - delY)<=0)begin
	               nextY = 0;
	           end
	           else begin
	               nextY = (myY - delY);
	           end
	       end
	       else begin
	           if(((myY + delY + ySize)>=bottomBorder)&&((myY + delY + ySize)<=1023))begin
	               nextY = (bottomBorder - ySize);
	           end
	           else begin
	               nextY = (myY + delY);
	           end
	       end
	   end
	   else begin
	       nextY = myY;
	   end
	end
	
	//nextSubX
	always @(myX,xSize,delX,subtractX,enable,theirX,myY,delY,theirNextY,theirSizeY,ySize)begin
	
		if(enable)begin
			if(((!subtractX)&&((myX + xSize + delX) >= rightBorder))||((((myX+delX+xSize)>=theirX)&&(((myY+delY) <= (theirNextY +theirSizeY))&&((myY+delY+ySize)>=theirNextY)))))begin
				nextSubX = 1;
			end
			else if(subtractX &&((myX - delX)<=0))begin
				nextSubX = 0;
			end
			else begin
				nextSubX = subtractX;
			end
		end
		else begin
			nextSubX = subtractX;
		end
		
	end

	//nextSubY
    always @(myY,ySize,delY,subtractY,enable)begin
        if(enable)begin
            if((!subtractY)&&((myY + ySize + delY)>= bottomBorder))begin
                nextSubY=1;
            end
            else if(subtractY && ((myY - delY)<=0))begin
                nextSubY = 0;
            end
            else begin
                nextSubY = subtractY;
            end
        end
        else begin
            nextSubY = subtractY;
        end
    end
	
	
	assign {red,green,blue} = {myRed,myGreen,myBlue};
	
	//yes assignment for drawing of object
	assign yes = (((X >= myX)&&(X <= (myX + xSize)))&&((Y >= myY) && (Y <= (myY + ySize))));
	
	//next Red,Green,Blue
	always @(myX,delX,xSize,theirX,myY,delY,theirNextY,theirSizeY,ySize,redIn,blueIn,greenIn,myRed,myBlue,myGreen)begin
		if((((myX+delX+xSize)>=theirX)&&(((myY+delY) <= (theirNextY +theirSizeY))&&((myY+delY+ySize)>=theirNextY))))begin
			{nextRed,nextGreen,nextBlue} = {redIn,greenIn,blueIn};
		end
		else begin
			{nextRed,nextGreen,nextBlue} = {myRed,myGreen,myBlue};
		end
	end
	
endmodule