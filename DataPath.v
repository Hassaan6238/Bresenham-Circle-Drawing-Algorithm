module DataPath (
    input clock,
    input resetn,
    input Draw_SIG,
    input [7:0] x1,
    input [6:0] y1,
    input [7:0] xc,
    input [6:0] yc,
    input[7:0] radius,
    input [3:0] Control_sig,
    output reg[7:0] outx,
    output reg[6:0] outy,
    output CLR_SIG,
    output reg[7:0] x,
    output reg[6:0] y
);

reg [6:0] d;

assign CLR_SIG=(Control_sig==8)?1:0;

always@(posedge clock, negedge resetn)
begin
if(~resetn)    
begin
y<=y;
d<=d;
end
else if(Draw_SIG)
begin
y<=(radius<60)?radius:59;
d<=(radius<60)?3-(radius*2):-159;
end
else if(x<=y & Control_sig==9 &y>0)
begin    
if(d[6]==1)
d<=d+(x*4)+6;
else
begin
    d<=d+((x-y)*4)+10;
    y<=y-1;
end
end
else 
begin 
y<=y;
d<=d;
end
end



always@(posedge clock, negedge resetn)
if(~resetn)
begin
    outx<=x1;
    outy<=y1;
end
else
begin 
    case(Control_sig)
    0:
    begin if(x<=y) begin outx<=xc+x; outy<=yc+y; end else begin outx<=outx; outy<=outy; end end
    1:
    begin outx<=xc-x; outy<=yc+y; end
    2:
    begin outx<=xc+x; outy<=yc-y; end
    3:
    begin outx<=xc-x; outy<=yc-y; end
    4:
    begin outx<=xc+y; outy<=yc+x; end
    5:
    begin outx<=xc-y; outy<=yc+x; end
    6:
    begin outx<=xc+y; outy<=yc-x; end
    7:
    begin outx<=xc-y; outy<=yc-x; end
    8: 
    begin outx<=x1; outy<=y1;  end
    9:
    begin outx<=outx; outy<=outy; end
    default: 
    begin  outx<=outx; outy<=outy; end
    endcase
end

always@(posedge clock, negedge resetn)
begin
    if(~resetn)
    x<=x;
     else if(Draw_SIG)
     x<=0;
    else if(x<=y & Control_sig==7)
    x<=x+1;
    else 
    x<=x;
end

endmodule

module rand_valgen (
    input clock,
    input resetn,
    input Draw_SIG,
    output reg[7:0] rand_xc,
    output reg[6:0] rand_yc,
    output reg[2:0] rand_colour,
    output reg sig,
    output reg[7:0] rand_radius
);

reg[25:0] counter;
reg[7:0] xr;
reg[7:0] xl;
reg[7:0] temp_x;
reg[6:0] yu;
reg[6:0] yd;
reg[7:0] temp_y;
reg[7:0] temp_radius;
reg temp_sig;

always@(*)
begin
    xl=rand_xc;
    xr=159-rand_xc;
    yu=rand_yc;
    yd=119-rand_yc;
    temp_x=(xr>xl)?xl:xr;
    temp_y=(yu>yd)?yd:yu;
    temp_radius=(temp_x>temp_y)?temp_y:temp_x;
    end

always@(posedge clock, negedge resetn)
begin
if(~resetn)
rand_radius<=0;
else
if(rand_xc>159|rand_yc>119) 
rand_radius<=0;
else
rand_radius<=temp_radius; 
end

always@(posedge clock, negedge resetn)
begin
    if(~resetn)
    begin
    counter<=0;
    temp_sig<=0;
    sig=0;
    end
    else
    begin
    sig<=(counter == 25000000)?1:0;
    temp_sig<=(counter == (25000000+22000))?1:0;
    counter<=(counter == (25000000+22000))?0:counter+1;
    end
end


always@(posedge clock, negedge resetn)
if(~resetn)
begin
rand_xc<=120;
rand_yc<=90;
rand_colour<=6;
end
else 
begin
rand_colour<=sig?{rand_colour[0],rand_colour[2:1]}:rand_colour;
rand_xc<=temp_sig?{rand_xc[6:0],rand_xc[7]}:rand_xc;
rand_yc<=temp_sig?{rand_yc[5:0],rand_yc[6]}:rand_yc;
end
    
endmodule


module logic2 (
    input resetn,
    input clock,
    output reg[7:0] outx,
    output reg [6:0] outy,
    output  Clr_State
);
wire Draw_SIG;

assign Clr_State=(outy==119);
assign Draw_SIG=(outx==159);
always@(posedge clock, negedge resetn)

begin
if(~resetn)
    outy<=0;
    else if (Clr_State)
    outy<=0;
    else if(Draw_SIG)
    outy<=outy+1;
    else 
     outy<=outy;
end

always@(posedge clock, negedge resetn)
begin
if(~resetn)
begin
    outx<=0;
end
else if(Draw_SIG)
outx<=0;
else
outx<=outx+1;
end

endmodule
