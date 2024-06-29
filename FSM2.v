module FSM2 (
    input clock,
    input resetn,
    input Draw_SIG,
    input [7:0] x,
    input [6:0] y,
    input Clr_State,
    output[3:0] Control_sig
);

reg[3:0] n_state;
reg[3:0] p_state;

assign Control_sig=p_state;

always@(*)
begin
case(p_state)
0:begin if (x<=y) n_state=1; else n_state=0; end
1:begin n_state=2; end
2:begin n_state=3; end
3:begin n_state=4; end
4:begin n_state=5; end
5:begin n_state=6; end
6:begin n_state=7; end
7:begin n_state=9; end
8:begin if(Clr_State) n_state=0; else n_state=8; end
9: begin n_state=0; end
default: begin n_state=0; end
endcase
end

always@(posedge clock, negedge resetn)
begin
if(~resetn)
begin
p_state<=8;
end
else if(Draw_SIG)
p_state<=0;
else
p_state<=n_state;
end

endmodule
