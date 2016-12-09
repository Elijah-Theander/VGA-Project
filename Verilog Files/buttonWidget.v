/*
Authored by Elijah Theander
December 5, 2016
buttonWidget.v
widget.v, but with added logic for 
user input for controlling y location.
*/

module buttonWidget(yes,myX,nextY,sizeY,red,green,blue,X,Y,xSize,ySize,delX,delY,redIn,greenIn,blueIn,enable,up,down,firstX,firstY,clk,reset);

	output              yes;//Output signal for drawing of object
	output signed[10:0] myX,nextY;//output signals for interfacing with other widget
	output       [8:0]  sizeY; //size output for interfacing with other widget
	output       [3:0]  red,green,blue;//color signal going to client
	
	input        [10:0] X,Y,firstX,firstY;//place where driver is located, starting position of widget
	input        [8:0]  xSize,ySize;//width and height of widget
	input signed [4:0]  delX,delY; //"Velocity" of widget
	input        [3:0]  redIn,greenIn,blueIn;//input colors of widget
	input               enable;//enable coming from a clock divider
	input               up,down;//button inputs for movement of widget
	input               clk,reset;//synchronous clock and reset
	
	reg signed    [10:0]  myX,myY,nextX,nextY;
	reg subtractX,subtractY,nextSubX,nextSubY;
	
	parameter rightBorder = 799, bottomBorder = 599;
	
	assign sizeY = ySize;
	
	//State memory
	always @(posedge clk)begin
		if(reset)begin
			myX <= firstX;
			myY <= firstY;
			subtractX = 0;
			subtractY = 0;
		end
		else begin
			myX <= nextX;
			myY <= nextY;
			subtractX = nextSubX;
			subtractY = nextSubY;
		end
	end
	
	//nextX
	always @(myX,delX,xSize,subtractX,enable)begin
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
	           if(((myX + delX +xSize)>=rightBorder)&&((myX + delX + xSize)<=1023))begin
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
	always @(myY,delY,ySize,subtractY,enable,up,down)begin
	   if(enable)begin
	       if(subtractY)begin
	           if((myY - delY)<=0)begin
	               nextY = up ? 0:myY;
	           end
	           else begin
	               nextY = up ?(myY - delY):myY;
	           end
	       end
	       else begin
	           if(((myY + delY + ySize)>=bottomBorder)&&((myY + delY + ySize)<=1023))begin
	               nextY = down? (bottomBorder - ySize):myY;
	           end
	           else begin
	               nextY = down? (myY + delY):myY;
	           end
	       end
	   end
	   else begin
	       nextY = myY;
	   end
	end
	
	//nextSubX
	always @(myX,xSize,delX,subtractX,enable)begin
	
		if(enable)begin
			if((!subtractX)&&((myX + xSize + delX) >= rightBorder))begin
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
    always @(up,down,subtractY)begin
        nextSubY = up? 1:(down? 0: subtractY);
    end
	
	assign {red,green,blue} = {redIn,greenIn,blueIn};
	
	//yes assignment for drawing of object
	assign yes = (((X >= myX)&&(X <= (myX + xSize)))&&((Y >= myY) && (Y <= (myY + ySize))));
	
endmodule