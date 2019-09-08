module clock_slow(in_clock, out_clock);
  // out_clock will be in_clock slowed down by 2*factor
  parameter factor = 50;
  parameter reg_width = 8;
  input in_clock;
  output reg out_clock = 0;
  reg [(reg_width-1):0] cnt = 0;

  always @(posedge in_clock)
  begin
    if (cnt >= factor) begin
      cnt <= 0;
      out_clock <= ~out_clock;
    end else
      cnt <= cnt + 1;
  end
endmodule //clock_slow

// Output cols to scan the keypad column by column; read rows while doing so.
// The output [15:0] contains bitmap with 1's for pressed keys and 0's for
// released. A value in the bitmap might change only when the corresponding
// column is scanned (i.e., there is no flickering caused by the
// column-by-column sweep).
module keypad4x4(clk, cols, rows, value);
  output reg [3:0] cols = 4'b1111;
  output reg [15:0] value = 0;
  input [3:0] rows;
  input clk;

  reg [2:0] current_col = 3'b000;
  integer i;
  always @(posedge clk)
  begin
    cols[3] <= current_col[2] && current_col[1];
    cols[2] <= current_col[2] && !current_col[1];
    cols[1] <= !current_col[2] && current_col[1];
    cols[0] <= !current_col[2] && !current_col[1];
    for (i=0; i<4; i=i+1)
    begin
      if (cols[i] && current_col[0])
        value[i*4 +: 4] <= rows;
      else
        value[i*4 +: 4] <= value[i*4 +: 4];
    end
    current_col <= current_col + 1;
  end
endmodule //keypad4x4

// Read 16 bits and produce 4-bit representations of base-10 digits (five of
// those). The most significant digit is stored in the highest 4 bits. If the
// value of the input (bits) changes during a single pass, the output value is
// undetermined for a short time, but that's ok since the output is meant to be
// consumed by a human.
module decimal_converter(clk, bits, value);
  input clk;
  input [15:0] bits;
  output reg [19:0] value;

  reg [3:0] d_tmp[4:0];
  reg [16:0] b_tmp;
  reg [2:0] digit = 3'b111;
  integer i;

  initial begin
    for (i = 0; i < 5; i=i+1) begin
      d_tmp[i] <= 0;
    end
    value <= 0;
    b_tmp <= 0;
  end

  always @(posedge clk) begin
    if (digit == 3'b111) begin
      for (i = 0; i < 5; i=i+1) begin
        value[i*4 +: 4] <= d_tmp[i];
        d_tmp[i] <= 0;
      end
      b_tmp <= 0;
      digit <= 4;
    end else begin
      for (i = 0; i < 5; i=i+1) begin
        if (digit == i) begin
          if (b_tmp <= bits) begin
            b_tmp <= b_tmp + 10**i;
            d_tmp[i] <= d_tmp[i] + 1;
          end else begin
            b_tmp <= b_tmp - 10**i;
            d_tmp[i] <= d_tmp[i] - 1;
            digit <= digit - 1;
          end
        end
      end
    end
  end
endmodule //decimal_converter

// Display the 16 bits in the first row of the display
// Display the 5 digits (encoded with 4 bits each) in the second row
module lcd(clk, N, P, RST, PSB, rs, rw, en, dat, bits, decimals);
  output reg N;
  output reg P;
  output reg RST;
  output reg PSB;
  output reg rs,rw,en; 
  output reg [7:0] dat; 

  input clk;
  input [15:0] bits;
  input [19:0] decimals;

  wire clk_380Hz;
  clock_slow #(.factor(32'h1FFFE),
               .reg_width(32))
             clock_lcd(clk, clk_380Hz);

  reg [4:0] state=0; 

  initial
  begin
    rs<=0;
    dat<=8'b00000001;
  end

  always @(posedge clk) begin
    en<=clk_380Hz;
    rw<=0; 
    N<=1'b0;
    P<=1'b1;
    RST<=1'b1;
    PSB<=1'b1;
  end 

  always @(posedge clk_380Hz) begin 
    case(state) 
      0:   begin  rs<=0; dat<=8'b00110000; state<=1; end 
      1:   begin  rs<=0; dat<=8'b00001100; state<=2; end 
      2:   begin  rs<=0; dat<=8'b00000110; state<=3; end// 
      3:   begin  rs<=0; dat<=8'b00000010; state<=4; end 
   
      4:   begin  rs<=1; dat<=bits[15]+"0"; state<=5; end //?????
      5:   begin  rs<=1; dat<=bits[14]+"0"; state<=6; end //?????
      6:   begin  rs<=1; dat<=bits[13]+"0"; state<=7; end //?????
      7:   begin  rs<=1; dat<=bits[12]+"0"; state<=8; end //?????
      8:   begin  rs<=1; dat<=bits[11]+"0"; state<=9; end //?????
      9:   begin  rs<=1; dat<=bits[10]+"0"; state<=10; end //?????
      10:   begin  rs<=1; dat<=bits[9]+"0"; state<=11; end //?????
      11:   begin  rs<=1; dat<=bits[8]+"0"; state<=12; end //?????
      12:   begin  rs<=1; dat<=bits[7]+"0"; state<=13; end //?????
      13:   begin  rs<=1; dat<=bits[6]+"0"; state<=14;end //?????
      14:  begin  rs<=1; dat<=bits[5]+"0"; state<=15;end //?????
      15:  begin  rs<=1; dat<=bits[4]+"0"; state<=16;end //?????
      16:  begin  rs<=1; dat<=bits[3]+"0"; state<=17;end //?????
      17:  begin  rs<=1; dat<=bits[2]+"0"; state<=18;end //?????
      18:  begin  rs<=1; dat<=bits[1]+"0"; state<=19;end //?????
      19:  begin  rs<=1; dat<=bits[0]+"0"; state<=20;end 
      20:  begin  rs<=1; dat<=decimals[19:16]+"0"; state<=21;end 
      21:  begin  rs<=1; dat<=decimals[15:12]+"0"; state<=22;end 
      22:  begin  rs<=1; dat<=decimals[11:8]+"0"; state<=23;end 
      23:  begin  rs<=1; dat<=decimals[7:4]+"0"; state<=24;end 
      24:  begin  rs<=1; dat<=decimals[3:0]+"0"; state<=0;end 
      default:   state<=0; 
    endcase 
  end 

endmodule //lcd

module lcd12864(LCD_N,LCD_P,LCD_RST,PSB,clk, rs, rw, en,dat,
                key_col, key_row);
  output wire LCD_N, LCD_P, LCD_RST, PSB;
  input clk;  

  wire clk_1MHz;
  clock_slow clock_keypad(clk, clk_1MHz);

  output [3:0] key_col;
  input [3:0] key_row;
  wire [15:0] keys;
  reg [15:0] prev_keys= 16'h0000;
  keypad4x4 keypad(clk_1MHz, key_col, key_row, keys);

  reg [15:0] bits = 16'h0000;
  always @(posedge clk_1MHz) begin
    bits <= bits ^ (keys & ~prev_keys);
    prev_keys <= keys;
  end

  wire [19:0] decimals;
  decimal_converter convert(clk, bits, decimals);

  output [7:0] dat; 
  output en, rs, rw;
  lcd display(clk, LCD_N, LCD_P, LCD_RST, PSB, rs, rw, en, dat, bits, decimals);
endmodule  

