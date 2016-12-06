/*
Authored by Elijah Theander
December 5, 2016
buttonWidget.v
widget.v, but with added logic for 
user input for controlling y location.
*/

module buttonWidget(yes,red,green,blue,X,Y,xSize,ySize,delX,delY,redIn,greenIn,blueIn,enable,up,down,firstX,firstY,clk,reset);

	output              yes;
	output       [3:0]  red,green,blue;
	
	input        [10:0] X,Y,firstX,firstY;
	input        [8:0]  xSize,ySize;
	input signed [4:0]  delX,delY;
	input        [3:0]  redIn,greenIn,blueIn;
	input               enable;
	input               up,down;
	input               clk,reset;
	
	reg signed    [10:0]  myX,myY,nextX,nextY;
	reg subtractX,subtractY,nextSubX,nextSubY;
	
	parameter rightBorder = 799, bottomBorder = 599;
	
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
	
	//nextX and nextY
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
	
	//subtractX & subtractY
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
	
	assign {red,green,blue} = {redIn,greenIn,blueIn};
	
	assign yes = (((X >= myX)&&(X <= (myX + xSize)))&&((Y >= myY) && (Y <= (myY + ySize))));
	
endmodule