// hard-coded style bitgen
module bitgen (
	input bright, 
	input [9:0] hcount, vcount,
	input [0:6] p1, p2,
	output [23:0] rgb
);

assign rgb = {r,g,b};
reg [7:0] r, g, b;

// recall x_start = 158 = H_BACK_PORCH + H_SYNC + H_FRONT_PORCH
// 		 x_end   = 745 = H_TOTAL - H_BACK_PORCH
//        y_start = 0
//        y_end   = 480 = V_DISPLAY_INT
wire [9:0] x_pos, y_pos;
assign x_pos = hcount - 10'd158;
assign y_pos = vcount; 

always @(bright, x_pos, y_pos, p1, p2) begin

	{r,g,b} = 0;
	
	// can display
	if (bright) begin
	
		// draw border
		if (x_pos >= 315 && x_pos < 325 && y_pos >= 75 || x_pos >= 0 && x_pos < 10 || 
			 x_pos >= 630 && x_pos < 640 || y_pos >= 0 && y_pos < 10 || 
			 y_pos >= 470 && y_pos < 480 || y_pos >= 75 && y_pos < 85)
			r = 8'd0;
		
		//Draw underlines
		else if (y_pos >= 160 && y_pos < 165 && 
				  (x_pos >= 40 && x_pos < 285 || x_pos >= 355 && x_pos < 600))
			r = 8'd0;
			
		//Draw Pong
		else if ( x_pos >= 250 && x_pos < 260 && y_pos >= 25 && y_pos < 70 || x_pos >= 260 && x_pos < 280 &&
					 (y_pos >= 25 && y_pos < 35 || y_pos >= 40 && y_pos < 50) || x_pos >= 270 && x_pos < 280 &&
					  y_pos >= 35 && y_pos < 40 ||
					  (x_pos >= 290 && x_pos < 300 || x_pos >= 310 && x_pos < 320) && y_pos >= 35 && y_pos < 70 ||
					  x_pos >= 300 && x_pos < 310 && (y_pos >= 35 && y_pos < 45 || y_pos >= 60 && y_pos < 70) ||
					  x_pos >= 330 && x_pos < 340 && y_pos >= 35 && y_pos < 70 || x_pos >= 340 && x_pos < 360 &&
					  y_pos >= 35 && y_pos < 45 || x_pos >= 350 && x_pos < 360 && y_pos >= 45 && y_pos < 70 ||
					  x_pos >= 370 && x_pos < 380 && y_pos >= 35 && y_pos < 70 || x_pos >= 380 && x_pos < 400 &&
					  (y_pos >= 35 && y_pos < 45 || y_pos >= 60 && y_pos < 70) || x_pos >= 387 && x_pos < 403 && 
					  y_pos >= 50 && y_pos < 55 || x_pos >= 390 && x_pos < 400 && y_pos >= 55 && y_pos < 70	
					  )
			r = 8'd0;
		//Draw P1 
		else if(x_pos >= 115 && x_pos < 125 && y_pos >= 100 && y_pos < 155 ||
				  x_pos >= 125 && x_pos < 155 && (y_pos >= 100 && y_pos < 110 ||
				  y_pos >= 125 && y_pos < 135) || x_pos >= 145 && x_pos < 155 && 
				  y_pos >= 110 && y_pos < 125 || x_pos >= 175 && x_pos < 185 &&
				  y_pos >= 100 && y_pos < 155)
			r = 8'd0;
			
		//Draw P2
		else if(x_pos >= 435 && x_pos < 445 && y_pos >= 100 && y_pos < 155 ||
				  x_pos >= 445 && x_pos < 475 && (y_pos >= 100 && y_pos < 110 ||
				  y_pos >= 125 && y_pos < 135) || x_pos >= 465 && x_pos < 475 && 
				  y_pos >= 110 && y_pos < 125 || x_pos >= 495 && x_pos < 535 &&
				  y_pos >= 100 && y_pos < 110 || x_pos >= 525 && x_pos < 535 && 
				  y_pos >= 110 && y_pos < 133 || x_pos >= 495 && x_pos < 525 &&
				  y_pos >= 123 && y_pos < 133 || x_pos >= 495 && x_pos < 505 &&
				  y_pos >= 133 && y_pos < 145 || x_pos >= 495 && x_pos < 535 && 
				  y_pos >= 145 && y_pos < 155)
			r = 8'd0;

		//Player 1 Score -------------------------------------------------------
		//top edge p1 A
		else if (x_pos >= 115 && x_pos < 210 && y_pos >= 187 && y_pos < 200) begin
			if(p1[0])
				r = 8'd255;
			else begin
				r = 8'd210;
				b = 8'd210;
				g = 8'd210;
			end
		end
			
		//top right edge p1 B
		else if (x_pos >= 215 && x_pos < 225 && y_pos >= 195 && y_pos < 300) begin
			if(p1[1])
				r = 8'd255;
			else begin
				r = 8'd210;
				b = 8'd210;
				g = 8'd210;
			end
		end
		
		//bottom right edge p1 C
		else if (x_pos >= 215 && x_pos < 225 && y_pos >= 315 && y_pos < 420) begin
			if(p1[2])
				r = 8'd255;
			else begin
				r = 8'd210;
				b = 8'd210;
				g = 8'd210;
			end
		end
			
		//bottom edge p1 D
		else if (x_pos >= 115 && x_pos < 210 && y_pos >= 415 && y_pos < 428) begin
			if(p1[3])
				r = 8'd255;
			else begin
				r = 8'd210;
				b = 8'd210;
				g = 8'd210;
			end
		end
			
		//bottom left edge p1 E
		else if (x_pos >= 100 && x_pos < 110 && y_pos >= 315 && y_pos < 420) begin 
			if(p1[4])
				r = 8'd255;
			else begin
				r = 8'd210;
				b = 8'd210;
				g = 8'd210;
			end
		end
			
		//top left edge p1 F
		else if (x_pos >= 100 && x_pos < 110 && y_pos >= 195 && y_pos < 300) begin 
			if(p1[5])
				r = 8'd255;
			else begin
				r = 8'd210;
				b = 8'd210;
				g = 8'd210;
			end
		end
			
		//middle edge p1 G
		else if (x_pos >= 115 && x_pos < 210 && y_pos >= 301 && y_pos < 314) begin
			if(p1[6])
				r = 8'd255;
			else begin
				r = 8'd210;
				b = 8'd210;
				g = 8'd210;
			end
		end
		
		//Player 2 Score ---------------------------------------------------------
		//top edge p1 A
		else if (x_pos >= 435 && x_pos < 530 && y_pos >= 187 && y_pos < 200) begin
			if(p2[0])
				r = 8'd255;
			else begin
				r = 8'd210;
				b = 8'd210;
				g = 8'd210;
			end
		end
			
		//top right edge p1 B
		else if (x_pos >= 535 && x_pos < 545 && y_pos >= 195 && y_pos < 300) begin
			if(p2[1])
				r = 8'd255;
			else begin
				r = 8'd210;
				b = 8'd210;
				g = 8'd210;
			end
		end
		
		//bottom right edge p1 C
		else if (x_pos >= 535 && x_pos < 545 && y_pos >= 315 && y_pos < 420) begin
			if(p2[2])
				r = 8'd255;
			else begin
				r = 8'd210;
				b = 8'd210;
				g = 8'd210;
			end
		end
			
		//bottom edge p1 D
		else if (x_pos >= 435 && x_pos < 530 && y_pos >= 415 && y_pos < 428) begin
			if(p2[3])
				r = 8'd255;
			else begin
				r = 8'd210;
				b = 8'd210;
				g = 8'd210;
			end
		end
			
		//bottom left edge p1 E
		else if (x_pos >= 420 && x_pos < 430 && y_pos >= 315 && y_pos < 420) begin
			if(p2[4])
				r = 8'd255;
			else begin
				r = 8'd210;
				b = 8'd210;
				g = 8'd210;
			end
		end
			
		//top left edge p1 F
		else if (x_pos >= 420 && x_pos < 430 && y_pos >= 195 && y_pos < 300) begin
			if(p2[5])
				r = 8'd255;
			else begin
				r = 8'd210;
				b = 8'd210;
				g = 8'd210;
			end
		end
			
		//middle edge p1 G
		else if (x_pos >= 435 && x_pos < 530 && y_pos >= 301 && y_pos < 314) begin
			if(p2[6])
				r = 8'd255;
			else begin
				r = 8'd210;
				b = 8'd210;
				g = 8'd210;
			end
		end
			
		// background color
		else begin
			r = 8'd210;
			b = 8'd210;
			g = 8'd210;
		end
				
	end
	
	// cannot display
	// defaulted above to {r,g,b} = 0;

end

endmodule
