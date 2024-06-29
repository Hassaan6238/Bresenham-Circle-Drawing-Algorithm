module Main_mod (
    input CLOCK_50,
    input [9:0] SW,
    input [3:0] KEY,
    output [7:0] VGA_R,
    output [7:0] VGA_G,
    output [7:0] VGA_B,
    output [4:0]LEDR,
    output VGA_HS,
    output VGA_VS,
    output VGA_BLANK_N,
    output VGA_SYNC_N,
    output VGA_CLK
);

wire Draw_SIG;
wire Clr_State;
wire CLR_SIG;
wire [2:0] colour;
wire [7:0] radius;
wire [7:0] VGA_x;
wire [7:0] x1;
wire [7:0] temp_x;
wire [6:0] y1;
wire [6:0] temp_y;
wire [6:0] VGA_y;
wire [3:0] Control_sig;
wire [2:0] rand_colour;
wire [7:0] rand_xc;
wire [6:0] rand_yc;
assign colour[0]=CLR_SIG?0:rand_colour[0];
assign colour[1]=CLR_SIG?0:rand_colour[1];
assign colour[2]=CLR_SIG?0:rand_colour[2];
assign LEDR=radius;
// assign radius[0]=SW[3];
// assign radius[1]=SW[4];
// assign radius[2]=SW[5];
// assign radius[3]=SW[6];
// assign radius[4]=SW[7];

vga_adapter VGA(
            .resetn(KEY[3]),
            .clock(CLOCK_50),
            .colour(colour),
            .x(VGA_x),
            .y(VGA_y),
            .plot(SW[9]),
            .VGA_R(VGA_R),
            .VGA_G(VGA_G),
            .VGA_B(VGA_B),
            .VGA_HS(VGA_HS),
            .VGA_VS(VGA_VS),
            .VGA_BLANK(VGA_BLANK_N),
            .VGA_SYNC(VGA_SYNC_N),
            .VGA_CLK(VGA_CLK));
        defparam VGA.RESOLUTION = "160x120";
        defparam VGA.MONOCHROME = "FALSE";
        defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
        defparam VGA.BACKGROUND_IMAGE = "image.colour.mif";
        defparam VGA.USING_DE1 = "TRUE";

FSM2 INST1(
    .clock(CLOCK_50),
    .resetn(KEY[3]),
    .Draw_SIG(signal),
    .x(temp_x),
    .y(temp_y),
    .Clr_State(Clr_State),
    .Control_sig(Control_sig)
);

DataPath INST2(
    .clock(CLOCK_50),
    .resetn(KEY[3]),
    .Draw_SIG(signal),
    .radius(radius),
    .Control_sig(Control_sig),
    .x1(x1),
    .xc(rand_xc),
    .yc(rand_yc),
    .y1(y1),
    .x(temp_x),
    .y(temp_y),
    .outx(VGA_x),
    .outy(VGA_y),
    .CLR_SIG(CLR_SIG)
);

logic2 INST3(
    .clock(CLOCK_50),
    .resetn(KEY[3]),
    .outx(x1),
    .outy(y1),
    .Clr_State(Clr_State)
);

rand_valgen INST4(
    .clock(CLOCK_50),
    .resetn(KEY[3]),
    .rand_colour(rand_colour),
    .rand_xc(rand_xc),
    .rand_yc(rand_yc),
    .sig(signal),
    .rand_radius(radius)
);

endmodule

