module lcd12864(LCD_N,LCD_P,LCD_RST,PSB,clk, rs, rw, en,dat,
                key_col, key_row);
output reg  LCD_N;
output reg LCD_P;
output reg LCD_RST;
output reg PSB;
input clk;  

/////// 4x4 KEYPAD
output reg [3:0] key_col = 4'b1111;
input [3:0] key_row;
reg [15:0] keypad = 16'h0000;
reg [2:0] key_i = 3'b000;
integer keypad_iter;
always @(posedge clk)
begin
  key_col[3] <= key_i[2] && key_i[1];
  key_col[2] <= key_i[2] && !key_i[1];
  key_col[1] <= !key_i[2] && key_i[1];
  key_col[0] <= !key_i[2] && !key_i[1];
  for (keypad_iter=0; keypad_iter<4; keypad_iter=keypad_iter+1)
  begin
    if (key_col[keypad_iter] && key_i[0])
      keypad[keypad_iter*4+:4] <= key_row;
    else
      keypad[keypad_iter*4+:4] <= keypad[keypad_iter*4+:4];
  end
  key_i <= key_i + 1;
end
/////// 4x4 KEYPAD end

 output [7:0] dat; 
 output reg rs,rw,en; 
 //tri en; 
 reg e; 
 reg [7:0] dat; 
  
 reg  [31:0] counter=0; 
 reg [6:0] current=0,next=0; 
 reg clkr; 
 reg [31:0] cnt=0; 
 parameter  set0=6'h0; 
 parameter  set1=6'h1; 
 parameter  set2=6'h2; 
 parameter  set3=6'h3; 
 parameter  set4=6'h4; 
 parameter  set5=6'h5;
 parameter  set6=6'h6;  

 parameter  dat0=6'h7; 
 parameter  dat1=6'h8; 
 parameter  dat2=6'h9; 
 parameter  dat3=6'hA; 
 parameter  dat4=6'hB; 
 parameter  dat5=6'hC;
 parameter  dat6=6'hD; 
 parameter  dat7=6'hE; 
 parameter  dat8=6'hF; 
 parameter  dat9=6'h10;

 parameter  dat10=6'h12; 
 parameter  dat11=6'h13; 
 parameter  dat12=6'h14; 
 parameter  dat13=6'h15; 
 parameter  dat14=6'h16; 
 parameter  dat15=6'h17;
 parameter  dat16=6'h18; 
 parameter  dat17=6'h19; 
 parameter  dat18=6'h1A; 
 parameter  dat19=6'h1B; 
 parameter  dat20=6'h1C;
 parameter  dat21=6'h1D; 
 parameter  dat22=6'h1E; 
 parameter  dat23=6'h1F; 
 parameter  dat24=6'h20; 
 parameter  dat25=6'h21; 
 parameter  dat26=6'h22; 
 parameter  dat27=6'h23; 
 parameter  dat28=6'h24; 
 parameter  dat29=6'h25; 
 parameter  dat30=6'h26; 
 parameter  dat31=6'h27; 
 parameter  dat32=6'h28; 
 parameter  dat33=6'h29; 
 parameter  dat34=6'h2A; 
 parameter  dat35=6'h2B;
 parameter  dat36=6'h2C; 
 parameter  dat37=6'h2E; 
 parameter  dat38=6'h2F; 
 parameter  dat39=6'h30;
 parameter  dat40=6'h31; 
 parameter  dat41=6'h32; 
 parameter  dat42=6'h33; 
 parameter  dat43=6'h34; 
   
  
 parameter  nul=6'h35; 

always @(posedge clk)         //da de shi zhong pinlv 
 begin 
  counter<=counter+1; 
  if(counter==32'h1FFFE)  begin
  counter<=0;
  end
  else if((counter==32'hF)) begin//||(counter==32'h57FE)
  clkr<=~clkr; 
  end
en<=clkr|e; 
rw<=0; 
LCD_N<=1'b0;
LCD_P<=1'b1;
LCD_RST<=1'b1;
PSB<=1'b1;
end 

initial
begin
  rs<=0;
  dat<=8'b00000001;
end

always @(posedge clk) 
begin 
 if(counter==32'hF)begin //counter==32'haff0
		 current<=next; 
		 case(current) 
			 set0:   begin  rs<=0; dat<=8'b00110000; next<=set1; end 
			 set1:   begin  rs<=0; dat<=8'b00001100; next<=set2; end 
			 set2:   begin  rs<=0; dat<=8'b00000010; next<=set4; end 
			 set4:   begin  rs<=0; dat<=8'b00000110; next<=dat0; end// 
		
			 dat0:   begin  rs<=1; dat<=keypad[15]+"0"; next<=dat1; end //?????
			 dat1:   begin  rs<=1; dat<=keypad[14]+"0"; next<=dat2; end //?????
			 dat2:   begin  rs<=1; dat<=keypad[13]+"0"; next<=dat3; end //?????
			 dat3:   begin  rs<=1; dat<=keypad[12]+"0"; next<=dat4; end //?????
			 dat4:   begin  rs<=1; dat<=keypad[11]+"0"; next<=dat5; end //?????
			 dat5:   begin  rs<=1; dat<=keypad[10]+"0"; next<=dat6; end //?????
			 dat6:   begin  rs<=1; dat<=keypad[9]+"0"; next<=dat7; end //?????
			 dat7:   begin  rs<=1; dat<=keypad[8]+"0"; next<=dat8; end //?????
			 dat8:   begin  rs<=1; dat<=keypad[7]+"0"; next<=dat9; end //?????
			 dat9:   begin  rs<=1; dat<=keypad[6]+"0"; next<=dat10;end //?????
			 dat10:  begin  rs<=1; dat<=keypad[5]+"0"; next<=dat11;end //?????
			 dat11:  begin  rs<=1; dat<=keypad[4]+"0"; next<=dat12;end //?????
			 dat12:  begin  rs<=1; dat<=keypad[3]+"0"; next<=dat13;end //?????
			 dat13:  begin  rs<=1; dat<=keypad[2]+"0"; next<=dat14;end //?????
			 dat14:  begin  rs<=1; dat<=keypad[1]+"0"; next<=dat15;end //?????
			 dat15:  begin  rs<=1; dat<=keypad[0]+"0"; next<=nul; end 
			
			  nul:   begin rs<=0;  dat<=8'h00;                    // ????E ? ?? 
				         if(cnt!=2'h2)  
                      begin  
                       e<=0;current<=set0;cnt<=cnt+1;  
                      end  
                     else  
                      begin current<=set0; e<=1;cnt<=0; 
                     end  
					   end 
             

			default:   next<=set0; 
			 endcase 
	end		 
	
end 

endmodule  

