module Arithmetic_Unit #(parameter Data_In_Width = 16)
(
    // Inputs
    input   wire    signed  [Data_In_Width-1 : 0]    A_in ,     // n-bits = 16
    input   wire    signed  [Data_In_Width-1 : 0]    B_in ,     // n-bits = 16
    input   wire                          [3 : 0]    alu_fun,   // Will use only the MSBs by using a signal below
    input   wire                                     CLK_in,
    input   wire                                     RST_in,
    input   wire                                     arith_En,
    // Outputs
    output  reg         [(2*Data_In_Width)-1 : 0]    arith_out,  
    output  reg                                      arith_flag,
    output  reg                                      over_flow
);

// Signal assignment
wire    [1:0]   alu_fun_LSBs = alu_fun[1:0];     // to choose the arithmetic operation by getting the first 2-bits of alu_fun
reg     [(2*Data_In_Width)-1 : 0]   arith_out_comb;
reg     arith_flag_comb;
reg     over_flow_comb;

always @ (posedge CLK_in or negedge RST_in)  // Active low Async Reset
    begin
        if (!RST_in)
            begin
               arith_out  <= 'sb0; 
               arith_flag <= 1'b0;
               over_flow  <= 1'b0;
            end
        else
            begin
                arith_out  <= arith_out_comb;
                arith_flag <= arith_flag_comb;
                over_flow  <= over_flow_comb;
            end
    end


always @ (*)
    begin
        if (arith_En)
            begin
                arith_flag_comb = 1'b1;

                case (alu_fun_LSBs)
                    2'b00 : {over_flow_comb , arith_out_comb} = A_in + B_in ;
                    2'b10 : {over_flow_comb , arith_out_comb} = A_in * B_in ;
                    2'b01 : {over_flow_comb , arith_out_comb} = A_in - B_in ;
                    2'b11 : arith_out_comb = (B_in != 'sb0) ? A_in / B_in : 'sb0 ;  // used conditional operator to avoid division by zero which is undefined 
                endcase
            end
        else
            begin
                arith_flag_comb = 1'b0;
                arith_out_comb = 'sb0;
                over_flow_comb = 1'b0;
            end
    end


endmodule
