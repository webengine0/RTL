
//BCD to 7 segment display ///
module seven_seg(a,b,c,d,e,f,g,A,B,C,D
    );
	output a,b,c,d,e,f,g;
	input A,B,C,D;
	
	wire y_D,y_B,y_C,y_A;
	wire y_a31,y_a32,y_a21,y_a22,y_a23,y_a24,y_a33,y_a34;
	wire y_b31,y_b32,y_b33,y_b21,y_b22,y_b34,y_b23;
	wire y_c21,y_c22,y_c23,y_c24,y_c25,y_c31,y_c26;
	wire y_d31,y_d32,y_d33,y_d34,y_d21,y_d35,y_d22;
	wire y_e21,y_e22,y_e23,y_e24,y_e25,y_e26;
	wire y_f31,y_f21,y_f22,y_f23,y_f24,y_f32,y_f25;
	wire y_g31,y_g21,y_g22,y_g23,y_g24,y_g32,y_g25; 
	
	inv i1(y_D,D);
	inv i2(y_C,C);
	inv i3(y_B,B);
	inv i4(y_A,A);

	and3 a1(y_a31,A,y_B,y_C);
	and3 a2(y_a32,y_A,B,D);
	and2 a3(y_a21,y_B,y_D);
	and2 a4(y_a22,y_A,C);
	and2 a5(y_a23,A,y_D);
	and2 a6(y_a24,B,C);
	or3 a7(y_a33,y_a31,y_a32,y_a21);
	or3 a8(y_a34,y_a22,y_a23,y_a24);
	or2 a9(a,y_a33,y_a34);
		
	and3 b1(y_b31,y_A,y_C,y_D);
	and3 b2(y_b32,y_A,C,D);
	and3 b3(y_b33,A,y_C,D);
	and2 b4(y_b21,y_B,y_C);
	and2 b5(y_b22,y_B,y_D);
	or3 b6(y_b34,y_b31,y_b32,y_b33);
	or2 b7(y_b23,y_b21,y_b22);
	or2 b8(b,y_b34,y_b23);
	
	and2 c1(y_c21,y_A,y_C);
	and2 c2(y_c22,y_A,D);
	and2 c3(y_c23,y_C,D);
	and2 c4(y_c24,y_A,B);
	and2 c5(y_c25,A,y_B);
	or3 c6(y_c31,y_c21,y_c22,y_c23);
	or2 c7(y_c26,y_c24,y_c25);
	or2 c8(c,y_c31,y_c26);
		
	and3 d1(y_d31,y_A,y_B,y_D);
	and3 d2(y_d32,y_B,C,D);
	and3 d3(y_d33,B,y_C,D);
	and3 d4(y_d34,B,C,y_D);
	and2 d5(y_d21,A,y_C);
	or3 d6(y_d35,y_d31,y_d32,y_d33);
	or2 d7(y_d22,y_d34,y_d21);
	or2 d8(c,y_d35,y_d22);
	
	and2 e1(y_e21,A,C);
	and2 e2(y_e22,A,B);
	and2 e3(y_e23,C,y_D);
	and2 e4(y_e24,y_B,y_D);
	or2 e5(y_e25,y_e21,y_e22);
	or2 e5(y_e26,y_e23,y_e24);
	or2 e6(e,y_e25,y_e26);
	
	and3 f1(y_f31,y_A,B,y_C);
	and2 f2(y_f21,y_C,y_D);
	and2 f3(y_f22,B,y_D);
	and2 f4(y_f23,A,y_B);
	and2 f5(y_f24,A,C);
	or3 f6(y_f32,y_f31,y_f21,y_f22);
	or2 f7(y_f25,y_f23,y_f24);
	or2 f8(f,y_f32,y_f25);
	
	and3 g1(y_g31,y_A,B,y_C);
	and2 g2(y_g21,A,y_B);
	and2 g3(y_g22,A,D);
	and2 g4(y_g23,y_B,C);
	and2 g5(y_g24,C,y_D);
	or3 g6(y_g32,y_g31,y_g21,y_g22);
	or2 g7(y_g25,y_g23,y_g24);
	or2 g8(g,y_g32,y_g25);

endmodule

//inverter using CMOS
module inv(Y,A);
	output Y;
	input A;
	supply0 gnd;
	supply1 vdd;
	
	pmos p1(Y,vdd,A);
	
	nmos n1(Y,gnd,A);

endmodule

// 3-input AND gate using CMOS
module and3(Y, A, B, C);
    output Y;
    input A, B, C;
    supply0 gnd;
    supply1 vdd;
    wire a, b;

    pmos p1(a, vdd, A);
    pmos p2(b, a, B);
    pmos p3(Y, b, C);

    nmos n1(Y, gnd, A);
    nmos n2(Y, gnd, B);
    nmos n3(Y, gnd, C);
endmodule



// 2-input AND gate using CMOS
module and2(Y, A, B);
    output Y;
    input A, B;
    supply0 gnd;
    supply1 vdd;
    wire a;

    pmos p1(a, vdd, A);
    pmos p2(Y, a, B);

    nmos n1(Y, gnd, A);
    nmos n2(Y, gnd, B);
endmodule



// 3-input OR gate using CMOS
module or3(Y, A, B, C);
    output Y;
    input A, B, C;
    supply0 gnd;
    supply1 vdd;
    wire a, b;

    pmos p1(a, vdd, A);
    pmos p2(b, vdd, B);
    pmos p3(Y, vdd, C);

    nmos n1(Y, gnd, A);
    nmos n2(Y, gnd, B);
    nmos n3(Y, gnd, C);
endmodule


// 2-input OR gate using CMOS
module or2(Y, A, B);
    output Y;
    input A, B;
    supply0 gnd;
    supply1 vdd;
    wire a;

    pmos p1(a, vdd, A);
    pmos p2(Y, a, B);

    nmos n1(Y, gnd, A);
    nmos n2(Y, gnd, B);
endmodule



//BCD to 7 segment
module segment7(
     bcd,
     seg
    );
     input [3:0] bcd;
     output [6:0] seg;
     reg [6:0] seg;
	  
    always @(bcd)
    begin
        case (bcd) 
            0 : seg = 7'b0000001;
            1 : seg = 7'b1001111;
            2 : seg = 7'b0010010;
            3 : seg = 7'b0000110;
            4 : seg = 7'b1001100;
            5 : seg = 7'b0100100;
            6 : seg = 7'b0100000;
            7 : seg = 7'b0001111;
            8 : seg = 7'b0000000;
            9 : seg = 7'b0000100;

            default : seg = 7'b1111111; 
        endcase
    end
endmodule
