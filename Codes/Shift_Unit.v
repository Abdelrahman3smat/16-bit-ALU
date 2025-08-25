module Shift_unit #(parameter Data_In_Width = 16)
(
    // Inputs
    input   wire    signed  [Data_In_Width-1 : 0]    A_in ,     // n-bits = 16
    input   wire    signed  [Data_In_Width-1 : 0]    B_in ,     // n-bits = 16
    input   wire                          [3 : 0]    alu_fun,   // Will use only the MSBs by using a signal below
    input   wire                                     CLK_in,
    input   wire                                     RST_in,
    input   wire                                     shift_En,
    // Outputs
    output  reg     signed  [Data_In_Width-1 : 0]    shift_out, 
    output  reg                                      shift_flag
);

// Signal assignment
wire    [1:0]   alu_fun_LSBs = alu_fun[1:0];     // to choose the Shift operation by getting the first 2-bits of alu_fun
reg     [Data_In_Width-1 : 0]   shift_out_comb;
reg     shift_flag_comb;


always @ (posedge CLK_in or negedge RST_in)
    begin
        if (!RST_in)
            begin
                shift_out  <= 'sb0;
                shift_flag <= 1'b0;
            end
        else
            begin
                shift_out  <= shift_out_comb;
                shift_flag_comb <= shift_flag;
            end
    end


always @ (*)
    begin
        if (shift_En)
            begin
                shift_flag_comb = 1'b1;

                case (alu_fun_LSBs)
                2'b00 : shift_out_comb = (A_in >> 1'b1);   // shift A to the right by 1 
                2'b01 : shift_out_comb = (A_in << 1'b1);   // shift A to the left by 1
                2'b10 : shift_out_comb = (B_in >> 1'b1);   // shift B to the right by 1 
                2'b11 : shift_out_comb = (B_in << 1'b1);   // shift B to the left by 1
                endcase
            end
        else
            begin
                shift_flag_comb = 1'b0;
                shift_out_comb = 'sb0;
            end
    end


endmodule